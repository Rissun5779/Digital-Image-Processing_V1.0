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


## \file reconfiguration_stratix10.tcl
# includes common reconfiguration parameters, port definitions and validation callbacks for Stratix 10 Native PHY and PLLs

package provide alt_xcvr::utils::reconfiguration_stratix10 18.1

package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::utils::device
package require alt_xcvr::utils::ipgen
package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::common

namespace eval ::alt_xcvr::utils::reconfiguration_stratix10:: {
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace import ::alt_xcvr::ip_tcl::ip_module::*

   namespace export \
      declare_display_items \
      declare_parameters \
      generate_config_files \
	  get_variables \
	  get_variable \

      variable display_items_rcfg
	  variable display_items_multi_profile
      variable rcfg_parameters_common
	  variable rcfg_parameters_multi_profile

      variable rcfg_criteria {M_RCFG_REPORT 1}


set display_items_rcfg {\
      {NAME                                       GROUP                      ENABLED                           VISIBLE                                                       TYPE   ARGS  }\
      {"Dynamic Reconfiguration"                  ""                         NOVAL                             NOVAL                                                         GROUP  tab   }\
      {"Optional Reconfiguration Logic"           "Dynamic Reconfiguration"  NOVAL                             NOVAL                                                         GROUP  NOVAL }\
      {"Configuration Files"                      "Dynamic Reconfiguration"  NOVAL                             NOVAL                                                         GROUP  NOVAL }\
    }

set display_items_multi_profile {\
      {NAME                                       GROUP                      ENABLED                           VISIBLE                                                       TYPE   ARGS  }\
      {"Configuration Profiles"                   "Dynamic Reconfiguration"  NOVAL                             true  GROUP  NOVAL }\
      {"Store configuration to selected profile"  "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  action ::alt_xcvr::utils::reconfiguration_stratix10::action_store_profile   }\
      {"Load configuration from selected profile" "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  action ::alt_xcvr::utils::reconfiguration_stratix10::action_load_profile    }\
      {"Clear selected profile"                   "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  action ::alt_xcvr::utils::reconfiguration_stratix10::action_clear_profile   }\
      {"Clear all profiles"                       "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  action ::alt_xcvr::utils::reconfiguration_stratix10::action_clear_profiles  }\
      {"Refresh selected profile"                 "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  action ::alt_xcvr::utils::reconfiguration_stratix10::action_refresh_profile }\
      {"Reconfiguration Parameters"               "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  true  GROUP  TABLE }\
      {"Configuration Profile Data"               "Configuration Profiles"   "rcfg_multi_enable&&rcfg_enable"  NOVAL GROUP  NOVAL }\
    }

 set rcfg_parameters_common {\
      {NAME                                 M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                               M_ALWAYS_VALIDATE DERIVED HDL_PARAMETER   TYPE         DEFAULT_VALUE            ALLOWED_RANGES                                        ENABLED                                                                      VISIBLE                   DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                 DISPLAY_NAME                                DESCRIPTION }\
      {rcfg_debug                           NOVAL      1                1                NOVAL                                                                             0				 false   false           INTEGER      0                        { 0 1 }                                               false                                                                        false                     BOOLEAN       NOVAL         NOVAL                        NOVAL                                       NOVAL}\
      {rcfg_enable               	    NOVAL      1                1                NOVAL                                                                             0				 false   true            INTEGER      0                        NOVAL                                                 true                                    	                                  true						BOOLEAN       NOVAL  	"Dynamic Reconfiguration"    "Enable dynamic reconfiguration"            "Enables the dynamic reconfiguration interface." }\
      {enable_advanced_avmm_options         NOVAL      0                0                NOVAL                                                                             0				 true    false           INTEGER      0                        { 0 1 }                                               true                                                                         false                     NOVAL         NOVAL         NOVAL                         NOVAL                                      NOVAL}\
      {rcfg_jtag_enable                     NOVAL      1                1                NOVAL                                                                             0				 false   true            INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Dynamic Reconfiguration"    "Enable Altera Debug Master Endpoint"       "When enabled, the PLL IP includes an embedded Altera Debug Master Endpoint that connects internally Avalon-MM slave interface. The ADME can access the reconfiguration space of the transceiver. It can perform certain test and debug functions via JTAG using the System Console. This option requires you to enable the \"Share reconfiguration interface\" option for configurations using more than 1 channel and may also require that a jtag_debug link be included in the system."}\
      {rcfg_separate_avmm_busy              NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_separate_avmm_busy    1				 false   true            INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Dynamic Reconfiguration"    "Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE"          "When enabled, the reconfig_waitrequest will not indicate the status of AVMM arbitration with PreSICE.  The AVMM arbitration status will be reflected in a soft status register bit.  This feature requires that the \"Enable control and status registers\" feature under \"Optional Reconfiguration Logic\" be enabled.  For more information, please refer to the User Guide."}\
      {rcfg_enable_avmm_busy_port           NOVAL      1                1                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  enable_advanced_avmm_options BOOLEAN    NOVAL         "Dynamic Reconfiguration"    "Enable avmm_busy port"                     "Enable the port for avmm_busy"}\
      \
      {set_capability_reg_enable            NOVAL      1                1                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Optional Reconfiguration Logic"    "Enable capability registers"         "Enables capability registers, which provide high level information about the transceiver PLL's configuration"}\
      {set_user_identifier                  NOVAL      1                1                NOVAL                                                                             0				 false   false           INTEGER      0                        {0:255}                                               "rcfg_enable&&set_capability_reg_enable"                                     true                      NOVAL         NOVAL         "Optional Reconfiguration Logic"    "Set user-defined IP identifier"      "Sets a user-defined numeric identifier that can be read from the user_identifer offset when the capability registers are enabled"}\
      {set_csr_soft_logic_enable            NOVAL      1                1                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Optional Reconfiguration Logic"    "Enable control and status registers" "Enables soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Available signals include pll_cal_busy, pll_locked and pll_powerdown.  For more details, please refer to the User Guide."}\
      \
      {dbg_embedded_debug_enable            NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_embedded_debug_enable  1				 true    true            INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  false                     NOVAL         NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {dbg_capability_reg_enable            NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_capability_reg_enable  1				 true    true            INTEGER      0                        NOVAL                                                 true                                                                         false                     NOVAL         NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {dbg_user_identifier                  NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_user_identifier        1				 true    true            INTEGER      0                        NOVAL                                                 true                                                                         false                     NOVAL         NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {dbg_stat_soft_logic_enable           NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_stat_soft_logic_enable 1				 true    true            INTEGER      0                        NOVAL                                                 true                                                                         false                     NOVAL         NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {dbg_ctrl_soft_logic_enable           NOVAL      1                1                ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_ctrl_soft_logic_enable 1				 true    true            INTEGER      0                        NOVAL                                                 true                                                                         false                     NOVAL         NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      \
      {rcfg_file_prefix                     NOVAL      0                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_file_prefix           1				 false   false           STRING       "altera_xcvr_rcfg_10"    NOVAL                                                 rcfg_enable                                                                  true                      NOVAL         NOVAL         "Configuration Files"        "Configuration file prefix"                 "Specifies the file prefix to use for generated configuration files when enabled. Each variant of the IP should use a unique prefix for configuration files."}\
      {rcfg_files_as_common_package         NOVAL      0                0                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  false                     BOOLEAN       NOVAL         "Configuration Files"        "Declare SystemVerilog package file as common package file"       "Declares the SystemVerilog reconfig file as common package."}\
      {rcfg_sv_file_enable                  NOVAL      0                0                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Configuration Files"        "Generate SystemVerilog package file"       "When enabled, The IP will generate a SystemVerilog package file named \"(Configuration file prefix)_reconfig_parameters.sv\" containing parameters defined with the attribute values needed for reconfiguration."}\
      {rcfg_h_file_enable                   NOVAL      0                0                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Configuration Files"        "Generate C header file"                    "When enabled, The IP will generate a C header file named \"(Configuration file prefix)_reconfig_parameters.h\" containing macros defined with the attribute values needed for reconfiguration."}\
      {rcfg_txt_file_enable                 NOVAL      0                0                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 false                                                                        false                     BOOLEAN       NOVAL         "Configuration Files"        "Generate text file"                        "When enabled, The IP will generate a text file named \"(Configuration file prefix)_reconfig_parameters.txt\" containing the attribute values needed for reconfiguration."}\
      {rcfg_mif_file_enable                 NOVAL      0                0                NOVAL                                                                             0				 false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Configuration Files"        "Generate MIF (Memory Initialize File)"     "When enabled The IP will generate an Altera MIF (Memory Initialization File) named \"(Configuration file prefix)_reconfig_parameters.mif\". The MIF file contains the attribute values needed for reconfiguration in a data format."}\
      }

 set rcfg_parameters_multi_profile {\
      {NAME                                 M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                             M_ALWAYS_VALIDATE DERIVED HDL_PARAMETER   TYPE         DEFAULT_VALUE            ALLOWED_RANGES                                        ENABLED                                                                      VISIBLE                   DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                 DISPLAY_NAME                                DESCRIPTION }\
      {rcfg_multi_enable                    NOVAL      0                0                NOVAL                                                                           0		   false   false           INTEGER      0                        NOVAL                                                 rcfg_enable                                                                  true                      BOOLEAN       NOVAL         "Configuration Profiles"     "Enable multiple reconfiguration profiles"  "When enabled, you can use the GUI to store multiple configurations. The IP will generate reconfiguration files for all of the stored profiles. The IP will also check your multiple reconfiguration profiles for consistency to ensure you can reconfigure between them."}\
      {set_rcfg_emb_strm_enable             NOVAL      0                0                NOVAL                                                                           0		   false   false           INTEGER      0                        NOVAL                                                 "rcfg_multi_enable&&rcfg_enable"                                             true                      BOOLEAN       NOVAL         "Configuration Profiles"     "Enable embedded reconfiguration streamer"  "Enables the embedded reconfiguration streamer, which automates the dynamic reconfiguration process between multiple predefined configuration profiles."}\
      {rcfg_emb_strm_enable                 NOVAL      0                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_emb_strm_enable     1		   true    true            INTEGER      0                        NOVAL                                                 true                                                                         false                     NOVAL         NOVAL          NOVAL                        NOVAL                                       NOVAL}\
      {rcfg_reduced_files_enable            NOVAL      0                0                NOVAL                                                                           0		   false   false           INTEGER      0                        NOVAL                                                 "rcfg_multi_enable&&rcfg_enable"                                             true                      BOOLEAN       NOVAL         "Configuration Profiles"     "Generate reduced reconfiguration files"    "When enabled, The Native PHY generates reconfiguration report files containing only the attributes or RAM data that are different between the multiple configured profiles."}\
      {rcfg_profile_cnt                     NOVAL      0                0                NOVAL                                                                           0		   false   true            INTEGER      2                        { 1 2 3 4 5 6 7 8 }                                   "rcfg_multi_enable&&rcfg_enable"                                             true                      NOVAL         NOVAL         "Configuration Profiles"     "Number of reconfiguration profiles"        "Specifies the number of reconfiguration profiles to support when multiple reconfiguration profiles are enabled."}\
      {rcfg_profile_select                  NOVAL      0                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_profile_select      1		   false   false           INTEGER      1                        { 1 }                                                 "rcfg_multi_enable&&rcfg_enable"                                             true                      NOVAL         NOVAL         "Configuration Profiles"     "Store current configuration to profile:"   "Selects which reconfiguration profile to store when clicking the \"Store profile\" button."}\
      {rcfg_profile_data0                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data1                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data2                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data3                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data4                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data5                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data6                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_profile_data7                   NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        true                      NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data0       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data1       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data2       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data3       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data4       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data5       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data6       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_profile_data7       NOVAL      0                0                NOVAL                                                                           0		   false   false           STRING      ""                        NOVAL                                                 false                                                                        false                     NOVAL         NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL}\

      \
      {rcfg_params                          NOVAL      1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_params              1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {rcfg_param_labels                    NOVAL      1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_labels        1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "IP Parameters"                             NOVAL}\
      {rcfg_param_vals0                     0          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 0"                                 NOVAL}\
      {rcfg_param_vals1                     1          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 1"                                 NOVAL}\
      {rcfg_param_vals2                     2          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 2"                                 NOVAL}\
      {rcfg_param_vals3                     3          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 3"                                 NOVAL}\
      {rcfg_param_vals4                     4          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 4"                                 NOVAL}\
      {rcfg_param_vals5                     5          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 5"                                 NOVAL}\
      {rcfg_param_vals6                     6          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 6"                                 NOVAL}\
      {rcfg_param_vals7                     7          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals          1		   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 7"                                 NOVAL}\
      \
      {rcfg_sdc_derived_params              NOVAL      1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_params        1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         NOVAL                         NOVAL                                       NOVAL}\
      {rcfg_sdc_derived_param_vals0         0          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 0"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals1         1          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 1"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals2         2          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 2"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals3         3          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 3"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals4         4          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 4"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals5         5          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 5"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals6         6          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 6"                                 NOVAL}\
      {rcfg_sdc_derived_param_vals7         7          1                0                ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals    1	   true    false           STRING_LIST  NOVAL                    NOVAL                                                 false                                                                        false                     FIXED_SIZE    NOVAL         "Reconfiguration Parameters"  "Profile 7"                                 NOVAL}\
      }
}


proc ::alt_xcvr::utils::reconfiguration_stratix10::declare_parameters { enable_multi_profile } {
   variable rcfg_parameters_common
   variable rcfg_parameters_multi_profile

   ip_declare_parameters $rcfg_parameters_common
   
   if {$enable_multi_profile} {
	ip_declare_parameters $rcfg_parameters_multi_profile
   }   

   ip_set "parameter.enable_advanced_avmm_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_avmm_advanced ENABLED]
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::declare_display_items { group_value args_value enable_multi_profile } {
   variable display_items_rcfg
   variable display_items_multi_profile

   set display_items_rcfg [ip_set_property_byParameterIndex $display_items_rcfg GROUP $group_value 1]
   set display_items_rcfg [ip_set_property_byParameterIndex $display_items_rcfg ARGS $args_value 1]
   ip_declare_display_items $display_items_rcfg

   if {$enable_multi_profile} {
	ip_declare_display_items $display_items_multi_profile	
	set_display_item_property "Configuration Profile Data" DISPLAY_HINT COLLAPSED
   }
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::get_variables {} {
	return {display_items_rcfg display_items_multi_profile rcfg_parameters_common rcfg_parameters_multi_profile}
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::get_variable { var } {
	variable display_items_rcfg
	variable display_items_multi_profile
	variable rcfg_parameters_common	
	variable rcfg_parameters_multi_profile
	return [set $var]
}


##################################################################################################################################################
# VALIDATION CALLBACKS
##################################################################################################################################################

##############################
# Validate rcfg_file_prefix
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_file_prefix { rcfg_file_prefix rcfg_enable rcfg_sv_file_enable } {
  # notes for the regexp below: ^[] means beginning of string, ^\$\w means not ($ or numbers or alphabetic characters or underscore)
  set good_first_char [regexp {^[a-zA-Z_]} ${rcfg_file_prefix} a] 
  set bad_chars [regexp -start 1 {[^\$\w]} ${rcfg_file_prefix} b]
  set bad_file_name [expr { !${good_first_char} || ${bad_chars}}]
  
  
  if {${rcfg_enable} && ${rcfg_sv_file_enable} && ${bad_file_name}} {
    set err_msg [::alt_xcvr::ip_tcl::messages::get_invalid_current_value_string rcfg_file_prefix $rcfg_file_prefix]
    # ip_message :: send_message can not hadle cases involving braces properly and throws an error, so remove them before displaying
    regsub -all {\{} $err_msg " " err_msg
    regsub -all {\}} $err_msg " " err_msg
    ip_message warning "$err_msg SystemVerilog package names must contain only \"a-z\" \"A-Z\" \"0-9\" \"\_\" \"\$\"  and begin with an alphabetic character or an underscore"
  }
}

##############################
# Check rcfg_emb_strm_enable
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_emb_strm_enable { rcfg_enable rcfg_multi_enable set_rcfg_emb_strm_enable } {

  if { $rcfg_enable && $rcfg_multi_enable } {
    ip_set "parameter.rcfg_emb_strm_enable.value" $set_rcfg_emb_strm_enable
  } else {
    ip_set "parameter.rcfg_emb_strm_enable.value" 0
  }
}

##############################
# Set the allowed ranges of rcfg_profile_select based on rcfg_profile_cnt
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_profile_select { PROP_NAME rcfg_profile_cnt } {
  set legal_values {}
  for {set x 0} {$x < $rcfg_profile_cnt} {incr x} {
    lappend legal_values $x
  }  
  ip_set "parameter.${PROP_NAME}.allowed_ranges" $legal_values
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_params { PROP_NAME } {
  # Initialize reconfiguration profile header
  dict set criteria M_USED_FOR_RCFG 1
  dict set criteria DERIVED 0
  set params [ip_get_matching_parameters $criteria]
  ip_set "parameter.${PROP_NAME}.value" $params
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_params { PROP_NAME } {
  # Initialize reconfiguration profile header
  dict set criteria M_USED_FOR_RCFG 1
  dict set criteria DERIVED 1
  set sdc_params [ip_get_matching_parameters $criteria]

  # Remove rcfg_data and rcfg_val parameters from the list
  set rcfg_param_index [lsearch -regexp $sdc_params rcfg_param*]
  set rcfg_sdc_derived_param_index [lsearch -regexp $sdc_params rcfg_sdc_derived_param*]

  while { $rcfg_param_index > -1 || $rcfg_sdc_derived_param_index > -1} {
    if {$rcfg_param_index > -1} {
      set sdc_params [lreplace $sdc_params $rcfg_param_index $rcfg_param_index]
    } else {
      set sdc_params [lreplace $sdc_params $rcfg_sdc_derived_param_index $rcfg_sdc_derived_param_index]
    }

    set rcfg_param_index [lsearch -regexp $sdc_params rcfg_param*]
    set rcfg_sdc_derived_param_index [lsearch -regexp $sdc_params rcfg_sdc_derived_param*]

  }
  
  ip_set "parameter.${PROP_NAME}.value" $sdc_params
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_labels { PROP_NAME rcfg_params } {
  set labels {}
  foreach param $rcfg_params {
    lappend labels [ip_get "parameter.${param}.display_name"]
  }
  ip_set "parameter.${PROP_NAME}.value" $labels
}

##############################
# Validate reconfiguration profiles
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_param_vals { PROP_NAME PROP_M_CONTEXT \
  rcfg_enable rcfg_multi_enable rcfg_profile_cnt rcfg_params } {

  # Initialize the result list
  set rcfg_param_vals ""

  # For each profile we make sure the settings are consistent with the current profile.
  if {$rcfg_enable && $rcfg_multi_enable && ($PROP_M_CONTEXT < $rcfg_profile_cnt)} {
    # Grab profile data (except for current config)
    set rcfg_profile_data ""
    set use_current_config 1

    set rcfg_profile_data [ip_get "parameter.rcfg_profile_data${PROP_M_CONTEXT}.value"]
    # If the profile data is empty, issue a warning and use the current configuration
    if {$rcfg_profile_data == ""} {
      ip_message warning "Multiple reconfiguration profile $PROP_M_CONTEXT is empty. The IP will use the current configuration for profile $PROP_M_CONTEXT"
    } else {
      set use_current_config 0
    }

    set same_as_current 1

    # Iterate over the necessary parameters and set the value appropriately
    foreach param $rcfg_params {
      set cur_val [ip_get "parameter.${param}.value"]
      set this_val ""
      # If we're using the current config just grab the value
      if {$use_current_config} {
        set this_val $cur_val
      } else {
        # The remaining profiles we pull from stored data
        # Use the stored value if it was found
        if {[dict exist $rcfg_profile_data $param]} {
          set this_val [dict get $rcfg_profile_data $param]
        } else {
          # Use the default parameter value if the value is not contained in the stored data
          # This would occur if the IP were upgraded with new parameters
          set this_val [ip_get "parameter.${param}.default_value"]
          ip_message warning "Reconfiguration profile $PROP_M_CONTEXT is missing a value for parameter [ip_get "parameter.${param}.display_name"] (${param}). Altera recommends that you refresh the profile."
        }
      }

      # For parameters that must be the same across configurations; check the current value against the stored value
      if {$cur_val != $this_val} {
        set same_as_current 0
        if {[ip_get "parameter.${param}.M_SAME_FOR_RCFG"] } {
          ip_message error "Parameter \"${param}\" ([ip_get "parameter.${param}.display_name"]) must be consistent for all reconfiguration profiles. Current value:${cur_val}; Profile${PROP_M_CONTEXT} value:${this_val}."
        }
      }

      # Add the value to the list
      lappend rcfg_param_vals $this_val
    }
    # Finished iterating over params

    # Check that there is no reconfig between FIFO and Register modes
    if {[dict exist $rcfg_profile_data "tx_fifo_mode"] && [dict exist $rcfg_profile_data "tx_fifo_mode"] } {
      set cur_tx_fifo_mode [dict get $rcfg_profile_data "tx_fifo_mode"]
      set cur_rx_fifo_mode [dict get $rcfg_profile_data "rx_fifo_mode"]

      for {set i 0} {$i < $rcfg_profile_cnt } {incr i} {
        set temp_rcfg_profile_i_data [ip_get "parameter.rcfg_profile_data${i}.value"]

        if {[dict exist $temp_rcfg_profile_i_data "tx_fifo_mode"]} {
          set profile_tx_fifo_mode [dict get $temp_rcfg_profile_i_data "tx_fifo_mode"]

          if {$cur_tx_fifo_mode == "Register" && $profile_tx_fifo_mode != "Register"} {
            ip_message error "Parameter \"tx_fifo_mode\" ([ip_get "parameter.tx_fifo_mode.display_name"]) must be either register mode for all profiles, or fifo mode for all profiles. Current value:${cur_tx_fifo_mode}; Profile${i} value: ${profile_tx_fifo_mode}."
          }
        }
  
        if {[dict exist $temp_rcfg_profile_i_data "rx_fifo_mode"]} {
          set profile_rx_fifo_mode [dict get $temp_rcfg_profile_i_data "rx_fifo_mode"]

          if {$cur_rx_fifo_mode == "Register" && $profile_rx_fifo_mode != "Register"} {
            ip_message error "Parameter \"rx_fifo_mode\" ([ip_get "parameter.rx_fifo_mode.display_name"]) must be either register mode for all profiles, or fifo mode for all profiles. Current value:${cur_rx_fifo_mode}; Profile${i} value: ${profile_rx_fifo_mode}."
          }
        }
      }
    }
    # If the current configuration matches the stored configuration, issue a message
    if {$same_as_current} {
      ip_message info "Current IP configuration matches reconfiguration profile $PROP_M_CONTEXT"
    }
    
  }

  ip_set "parameter.${PROP_NAME}.value" $rcfg_param_vals
}

##############################
# Validate SDC derived reconfiguration profiles
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_sdc_derived_param_vals { PROP_NAME PROP_M_CONTEXT \
  rcfg_enable rcfg_multi_enable rcfg_profile_cnt rcfg_sdc_derived_params } {

  # Initialize the result list
  set rcfg_sdc_derived_param_vals ""

  # For each profile we make sure the settings are consistent with the current profile.
  if {$rcfg_enable && $rcfg_multi_enable && ($PROP_M_CONTEXT < $rcfg_profile_cnt)} {
    # Grab profile data (except for current config)
    set rcfg_sdc_derived_profile_data ""
    set use_current_config 1

    set rcfg_sdc_derived_profile_data [ip_get "parameter.rcfg_sdc_derived_profile_data${PROP_M_CONTEXT}.value"]
    # If the profile data is empty, issue a warning and use the current configuration
    if {$rcfg_sdc_derived_profile_data == ""} {
      ip_message warning "Multiple reconfiguration profile $PROP_M_CONTEXT is empty. The IP will use the current configuration for profile $PROP_M_CONTEXT"
    } else {
      set use_current_config 0
    }

    set same_as_current 1

    # Iterate over the necessary parameters and set the value appropriately
    foreach sdc_param $rcfg_sdc_derived_params {
      set cur_val [ip_get "parameter.${sdc_param}.value"]
      set this_val ""
      # If we're using the current config just grab the value
      if {$use_current_config} {
        set this_val $cur_val
      } else {
        # The remaining profiles we pull from stored data
        # Use the stored value if it was found
        if {[dict exist $rcfg_sdc_derived_profile_data $sdc_param]} {
          set this_val [dict get $rcfg_sdc_derived_profile_data $sdc_param]
        } else {
          # Use the default parameter value if the value is not contained in the stored data
          # This would occur if the IP were upgraded with new parameters
          set this_val [ip_get "parameter.${sdc_param}.default_value"]
          ip_message warning "Reconfiguration profile $PROP_M_CONTEXT is missing a value for parameter [ip_get "parameter.${sdc_param}.display_name"] (${sdc_param}). Altera recommends that you refresh the profile."
        }
      }

      # For parameters that must be the same across configurations; check the current value against the stored value
      if {$cur_val != $this_val} {
        set same_as_current 0
        if {[ip_get "parameter.${sdc_param}.M_SAME_FOR_RCFG"] } {
          ip_message error "Parameter \"${sdc_param}\" ([ip_get "parameter.${sdc_param}.display_name"]) must be consistent for all reconfiguration profiles. Current value:${cur_val}; Profile${PROP_M_CONTEXT} value:${this_val}."
        }
      }

      # Add the value to the list
      lappend rcfg_sdc_derived_param_vals $this_val
    }
    # Finished iterating over params
    
  }

  ip_set "parameter.${PROP_NAME}.value" $rcfg_sdc_derived_param_vals
}

##################################################################################################################################################
# MULTI-PROFILE ACTION CALLBACKS
##################################################################################################################################################

##############################
# Action callback for "Store Profile"
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::action_store_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }
  set rcfg_profile_cnt [ip_get "parameter.rcfg_profile_cnt.value"]

  # Constructing profile
  if {$profile < $rcfg_profile_cnt} {
    set rcfg_params [ip_get "parameter.rcfg_params.value"]
    set rcfg_sdc_derived_params [ip_get "parameter.rcfg_sdc_derived_params.value"]
    set rcfg_profile_data [dict create]
    set rcfg_sdc_derived_profile_data [dict create]

    # Iterate over necessary parameters and store value
    foreach param $rcfg_params {
      dict set rcfg_profile_data $param [ip_get "parameter.${param}.value"]
    }
    foreach sdc_param $rcfg_sdc_derived_params {
      dict set rcfg_sdc_derived_profile_data $sdc_param [ip_get "parameter.${sdc_param}.value"]
    }

    ip_set "Storing profile ${profile} $rcfg_profile_data"
    ip_set "parameter.rcfg_profile_data${profile}.value" $rcfg_profile_data
    ip_set "parameter.rcfg_sdc_derived_profile_data${profile}.value" $rcfg_sdc_derived_profile_data
  }
}

##############################
# Action callback for "Clear Profiles"
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::action_clear_profiles {} {
  for {set i 0} {$i < 8} {incr i} {
    action_clear_profile $i
  }
}

##############################
# Action callback for "Load Profile"
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::action_load_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }
  set rcfg_profile_cnt [ip_get "parameter.rcfg_profile_cnt.value"]

  if {$profile < $rcfg_profile_cnt} {
    set rcfg_params [ip_get "parameter.rcfg_params.value"]
    set rcfg_param_vals [ip_get "parameter.rcfg_param_vals${profile}.value"] 
    
    # Iterate over each parameter and set the value from the stored profile
    for {set i 0} {$i < [llength $rcfg_params]} {incr i} {
      set param [lindex $rcfg_params $i]
      set param_val [lindex $rcfg_param_vals $i]
      ip_set "parameter.${param}.value" $param_val
    }

  }
}

##############################
# Clear the selected profile
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::action_clear_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }

  ip_set "parameter.rcfg_profile_data${profile}.value" ""
  ip_set "parameter.rcfg_sdc_derived_profile_data${profile}.value" ""
}

##############################
# Refresh the selected profile
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::action_refresh_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }

  # Store current configuration data
  set rcfg_params [ip_get "parameter.rcfg_params.value"]
  set current_param_vals {}
  foreach param $rcfg_params {
    lappend current_param_vals [ip_get "parameter.${param}.value"]
  }

  # Refresh = load->store
  action_load_profile $profile
  action_store_profile $profile

  # Restore current values
  for {set i 0} {$i < [llength $rcfg_params]} {incr i} {
    set param [lindex $rcfg_params $i]
    set value [lindex $current_param_vals $i]
    ip_set "parameter.${param}.value" $value
  }

}


##################################################################################################################################################
# RECONFIGURATION FILE GENERATION FUNCTIONS
##################################################################################################################################################

##
# Generate files needed for dynamic reconfiguration.
# These include reconfiguration report files
#
# @param ip_name - The name of this IP core
# @param ip_core - Specifies which IP core (e.g. native, atx_pll, fpll)
# @param fileset - The fileset being generated (QUARTUS_SYNTH, SIM_VERILOG, SIM_VHDL)
# @param criteria - A dictionary of <parameter_property property_value> pairs that will act as
#                   criteria for which IP parameters should be included in reconfiguration
#                   report files.
# @param regmap_list - A list of which register maps to include. This list will be passed
#                     to the ::alt_xcvr::utils::device_get_stratix10_regmap. (e.g. {pcs pma} or {atx} or {fpll})
# @param atom_list - A list of atoms for specific ip core
# @param ip_params_for_timing - list of IP parameters for timing
proc ::alt_xcvr::utils::reconfiguration_stratix10::generate_config_files { ip_name ip_core fileset criteria regmap_list atom_list ip_params_for_timing} {

  # Bail if reconfiguration is disabled
  if { ![ip_get "parameter.rcfg_enable.value"] } {
    return
  }

  # Determine which files are requested
  set rcfg_sv_file_enable  [ip_get "parameter.rcfg_sv_file_enable.value" ]
  set rcfg_h_file_enable   [ip_get "parameter.rcfg_h_file_enable.value"  ]
  set rcfg_mif_file_enable [ip_get "parameter.rcfg_mif_file_enable.value"]
  set rcfg_files_as_common_package [ip_get "parameter.rcfg_files_as_common_package.value"]

  # Retrieve register map
  set regmap [::alt_xcvr::utils::device::get_stratix10_regmap $regmap_list [ip_get "parameter.device_revision.value"]]
  if {$regmap == -1} {
    :alt_xcvr::ip_tcl::messages::ip_message error "Register map data not available."
    return
  }

  # Collect useful parameters
  set enable_multi_profile [ip_get_matching_parameters {NAME rcfg_multi_enable}]
  if { [llength $enable_multi_profile] == 0 } {
    set rcfg_multi_enable    0
    set rcfg_emb_strm_enable 0
    set rcfg_profile_cnt     1
  } else {
    set rcfg_multi_enable    [ip_get "parameter.rcfg_multi_enable.value"]
    set rcfg_emb_strm_enable [ip_get "parameter.rcfg_emb_strm_enable.value"]
    set rcfg_profile_cnt     [expr {$rcfg_multi_enable ? [ip_get "parameter.rcfg_profile_cnt.value"] : 1 }]
  }

  # Get the configuration file prefix
  set rcfg_file_prefix [ip_get "parameter.rcfg_file_prefix.value"]
  set file_prefix "${rcfg_file_prefix}_reconfig_parameters"
  set this_file_prefix $file_prefix
  set profile_values [dict create]

  # For multiple configuration profiles, we put the framework in standalone
  # mode and re-validate; then build the config data for that profile
  # (Seriously spooky black magic stuff here! - Kids don't try this at home!)
  # Enable IP TCL framework standalone mode
  if {$rcfg_multi_enable} {
    ip_set_standalone_mode 1
    # Get the list of parameters to load
    set params [ip_get "parameter.rcfg_params.value"]
    for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
      dict set profile_values $index [ip_get "parameter.rcfg_param_vals${index}.value"]
    }
  }

  # Iterate over each configuration and build config data
  set rcfg_data [dict create]
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    ::alt_xcvr::ip_tcl::messages::ip_message info "Building configuration data for reconfiguration profile $index"
    if {$rcfg_multi_enable} {
      # Get the parameter values to load for this configuration
      set param_values [dict get $profile_values $index]
      # Load the parameter values for this configuration
      for {set i 0} {$i < [llength $params]} {incr i} {
        ip_set "parameter.[lindex $params $i].value" [lindex $param_values $i]
      }
      # Re-validate IP with loaded parameters
      ::alt_xcvr::ip_tcl::messages::ip_message info "Validating reconfiguration profile $index"
      ip_validate_parameters
      ::alt_xcvr::ip_tcl::messages::issue_deferred_messages
    }
    # Build reconfiguration data for this configuration
    dict set rcfg_data $index [build_config_data $criteria $regmap]
  }

  # Produce reconfig_settings for each of the atoms only if multi profile is enabled
  # This is essential in order to pull multiple timing modes 
  if {$rcfg_multi_enable && ($ip_core eq "native_phy" || $ip_core eq "fpll")} {
    if {$ip_core eq "native_phy"} {
     foreach item $atom_list {
        generate_reconfig_settings $ip_name $rcfg_profile_cnt $item $rcfg_data
      }
    }

    # Generate the file with parameter values required for IP SDC clock frequency calculations
    generate_parameters_file_for_reconfig $ip_name $ip_core $rcfg_profile_cnt $ip_params_for_timing $rcfg_data
  }

  # Disable standalone mode if previously enabled
  if {$rcfg_multi_enable} {
    ip_set_standalone_mode 0
    # Reduce reconfiguration data if enabled
    if {[ip_get "parameter.rcfg_reduced_files_enable.value"]} {
      set rcfg_data [reduce_ram_config_data $rcfg_data]
      set rcfg_data [reduce_ascii_config_data $rcfg_data]
    }
  }

  # If no reconfiguration report files are requested when the embedded streamer is not enabled, return
  # Else, go ahead to generate the requested configuration file or the internal ROM initialization file for the streamer
  if {!$rcfg_sv_file_enable && !$rcfg_h_file_enable && !$rcfg_mif_file_enable && !$rcfg_emb_strm_enable} {
    return
  }

  # Hex file of concatenated config profiles used to initialize the rom for the embedded reconfiguration streamer if enabled
  set concat_hex_file_contents ""
  # List of config profile depths in order of increasing profile number
  set config_depths_list ""
  set rom_depth 0  

  # Iterate over profiles and generate config files
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    ::alt_xcvr::ip_tcl::messages::ip_message info "Generating configuration files for reconfiguration profile $index"
    # Build reconfiguration data dictionary
    set ascii_data [dict get $rcfg_data $index ascii_data]
    set ram_data [dict get $rcfg_data $index ram_data]

    # Append suffix for multi-config
    if {$rcfg_multi_enable} {
      set this_file_prefix "${file_prefix}_CFG${index}"
    }

    # Generate the SystemVerilog package file if requested
    if { $rcfg_sv_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating SystemVerilog configuration file"
      set filename "${this_file_prefix}.sv"
      set file_contents [::alt_xcvr::utils::ipgen::create_system_verilog_param_package "stratix10" ${this_file_prefix} $ascii_data $ram_data]      
      add_fileset_file "./reconfig/${filename}" SYSTEM_VERILOG TEXT $file_contents
      if {$fileset eq "SIM_VERILOG" || $fileset eq "SIM_VHDL"} {
         if {$rcfg_files_as_common_package} {	      
          set_fileset_file_attribute "./reconfig/${filename}" COMMON_SYSTEMVERILOG_PACKAGE $this_file_prefix
         }	  
      }

    }

    # Generate the C header file if requested
    if { $rcfg_h_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating C header configuration file"
      set filename "${this_file_prefix}.h"
      set macro_prefix $rcfg_file_prefix
      if {$rcfg_multi_enable} {
        set macro_prefix "${macro_prefix}_CFG${index}"
      }
      set file_contents [::alt_xcvr::utils::ipgen::create_c_param_header "stratix10" ${this_file_prefix} $rcfg_file_prefix $ascii_data $ram_data]
      add_fileset_file "./reconfig/${filename}" OTHER TEXT $file_contents
    }

    # Generate the MIF file if requested
    if { $rcfg_mif_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating MIF configuration file"
      set filename "${this_file_prefix}.mif"
      set file_contents [::alt_xcvr::utils::ipgen::create_series10_style_mif "stratix10" $ram_data]
      add_fileset_file "./reconfig/${filename}" OTHER TEXT $file_contents
    }

    # Add values to concatenated hex file if embedded reconfiguration enabled    
    if { $rcfg_emb_strm_enable } {
      set results [::alt_xcvr::utils::ipgen::create_raw_hex_file "stratix10" $ram_data]
      set concat_hex_file_contents "${concat_hex_file_contents}[lindex ${results} 1]"
      set config_depths_list "${config_depths_list}[lindex $results 0],"
      set rom_depth [expr {$rom_depth + [lindex $results 0]}]
    }
  }

  set random_str [lindex [split $ip_name "_"] end]

  if { $rcfg_emb_strm_enable } {

      # Generate SV package file for embedded reconfig
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating SystemVerilog package file with embedded reconfiguration parameters"
      set filename "alt_xcvr_native_rcfg_strm_params_${random_str}.sv"
      set file_contents [::alt_xcvr::utils::ipgen::create_rcfg_strm_params "stratix10" "alt_xcvr_native_rcfg_strm_params_${random_str}" $config_depths_list $rom_depth $concat_hex_file_contents]
      add_fileset_file "./${filename}" SYSTEM_VERILOG TEXT $file_contents      

      # Generate embedded reconfig files 
      set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
      set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/source"
      set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
      
      set embedded_rcfg_files { \
        alt_xcvr_native_rcfg_strm_functions.sv \
      }
      
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating embedded reconfiguration modules"
      # Read files and generate dynamically
      foreach file $embedded_rcfg_files {
        set filename "${path}/${file}"
        set file_handle [open ${filename} r] 
        set contents [read $file_handle]
        set output_filename $file
        add_fileset_file "./${output_filename}" SYSTEM_VERILOG TEXT $contents
      }
  }

}



##################################################################################################################################################
# INTERNAL UTILITY FUNCTIONS
##################################################################################################################################################

##
# Builds a dictionary containing register map information for parameters
# that can subsequently be used to create reconfiguration report files.
#
# @param criteria - A dictionary containing criteria for which IP parameters
#                   should be included in the returned data structure. This
#                   criteria will be passed to
#                   "::alt_xcvr::ip_tcl::ip_module::ip_get_matching_parameters"
#                   to obtain a parameter list.
#                   The criteria dictionary should contain a list of
#                   <parameter property->parameter property_value> pairs. Only
#                   those parameters whose properties meet all criteria will be
#                   included.
#
# @param rcfg_regmap - A dictionary of the format obtained from a call to
#                   "::alt_xcvr::utils::device::get_stratix10_regmap" as an example.
#                   This dictionary contains register map data for each parameter.
#
# @return - Returns a dictionary that contains two important subdictionaries
#           ascii_data <data for creation of ascii report files>
#           ram_data <data for creation of address offset based files>
#
#           ascii_data is organized by parameter name
#           ram_data is organized by register offset
proc ::alt_xcvr::utils::reconfiguration_stratix10::build_config_data { criteria rcfg_regmap} {

  # Initialize our config data dictionaries
  set ascii_data [dict create]
  set ram_data [dict create]

  # Get list of parameters that match the criteria
  set params [ip_get_matching_parameters $criteria]

  # Iterate over each parameter
  foreach param $params {

    # Get parameter value
    set val [ip_get "parameter.${param}.value"]

    # Convert parameter value to string if necessary and add to ascii data
    set str_val $val
    if {[string toupper [ip_get "parameter.${param}.type"]] == "STRING"} {
      set str_val "\"${str_val}\""
    } else {
      set width [ip_get "parameter.${param}.width"]
      if {$width != "NOVAL" && $width != ""} {
        set str_val "${width}'d${str_val}"
      } 
    }

    dict set ascii_data $param "value" $str_val

    # Get register map data for this parameter
    set regmap "NOVAL"
    if { [dict exists $rcfg_regmap $param] } {
      set regmap [dict get $rcfg_regmap $param]
    }

    if {$regmap != "NOVAL"} {
      # Iterate over attribute possible attribute values
      dict for {attrib_value offset} $regmap {

        # For direct mapped parameters override attribute value
        set is_direct [expr {$attrib_value == "DIRECT MAPPED"}]
        set attrib_value [string tolower $attrib_value]

        # Proceed if the attribute value matches
        if {$attrib_value == $val || $is_direct} {

          # If there are multiple address offsets, give them indices
          set addr_idx ""
          if {[dict size $offset] > 1} {
            set addr_idx 0
          }

          # Iterate over address offsets in the regmap data
          dict for {this_offset bit_offset} $offset {
            # Add address offset
            set this_offset_dec [expr 0x${this_offset}]
            dict set ascii_data $param "ADDR${addr_idx}_OFST" $this_offset_dec

            # If there are multiple bit offsets, give them indices
            set field_idx ""
            if {[dict size $bit_offset] > 1} {
              set field_idx 0
            }

            # definining regular expressions to be used to extract high and low indices from a range definition
            # range could be one of the following three cases (due to the way information is presented in register map spreadsheet) 
            # [M:N] where M is high index and N is low index ()
            # or [M] where M is both high and low index 
            # or M where M is both high and low index
            set reg_exp_for_high_index {(\[)?([0-9]*)(:)?([0-9]*)?(\])?}
            set reg_exp_for_low_index   {(\[)?([0-9]*:)?([0-9]*)(\])?}

            # Iterate over bitfield offsets
            dict for {this_bit_offset bit_value} $bit_offset {

              # Find low and high bits of bitfield range
              set bit_l [regsub $reg_exp_for_low_index $this_bit_offset {\3}]
              set bit_h [regsub $reg_exp_for_high_index $this_bit_offset {\2}]
              set bit_s [expr {($bit_h + 1) - $bit_l}]

              if {$is_direct} {
                # Modify value for direct mapped parameters
                set val_range_l [regsub $reg_exp_for_low_index $bit_value {\3}]
                set val_range_h [regsub $reg_exp_for_high_index $bit_value {\2}]
                set val_range_mask 0
                # Mask off needed bits
                for {set x $val_range_l} {$x <= $val_range_h} {incr x} {
                  set val_range_mask [expr {$val_range_mask | (1 << $x)}]
                }
                set bit_value [expr {($val & $val_range_mask) >> $val_range_l}]
              } else {
                # Convert non-direct mapped parameters from binary to decimal
                set bit_value [regsub {[0-9]*'b([01]*)} $bit_value "\\1"]
                set bit_value [::alt_xcvr::utils::common::bin_to_dec $bit_value]
              }

              # Create bitfield mask
              set mask 0
              for {set x $bit_l} {$x <= $bit_h} {incr x} {
                set mask [expr {$mask | (1 << $x)}]
              }
              set mask_val [expr {$bit_value << $bit_l}]

              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_OFST" $bit_l
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_HIGH" $bit_h
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_SIZE" $bit_s
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_BITMASK" "32'h[format %08X $mask]"
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_VALMASK" "32'h[format %08X $mask_val]"
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_VALUE" "$bit_s'h[format %X $bit_value]"

              dict set ram_data $this_offset_dec $bit_h mask $mask
              dict set ram_data $this_offset_dec $bit_h val_mask $mask_val
              dict set ram_data $this_offset_dec $bit_h param $param
              dict set ram_data $this_offset_dec $bit_h param_val $val
              dict set ram_data $this_offset_dec $bit_h bit_l $bit_l
              dict set ram_data $this_offset_dec $bit_h bit_h $bit_h
              dict set ram_data $this_offset_dec $bit_h bit_s $bit_s
              dict set ram_data $this_offset_dec $bit_h bit_value $bit_value

              # Increment to next field index if necessary
              if {$field_idx != ""} {
                incr field_idx
              }
            }
            # Increment to next address index if necessary
            if {$addr_idx != ""} {
              incr addr_idx
            }
          }
        }
      }
    }
  }

  #puts "\[build_config_data\] Returning"
  #::alt_xcvr::ip_tcl::ip_module::print_dict $ascii_data
  return [dict create ascii_data $ascii_data ram_data $ram_data]
}


##
# Analyzes multiple sets of config data and reduces there ascii data
# to only those parameters whose values are different. Note that this procedure
# does not reduce parameters whose settings might be different but the resulting
# bit data is the same. For example two parameter values that result in the same
# bit settings will not be reduced.
#
# @param config_data - A dictionary where each key contains a dictionary of
# reconfig data (both ascii_data and ram_data) as returned by the "build_config_data"
# procedure
#
# @return - The same dictionary as passed but with all redundant data removed.
proc ::alt_xcvr::utils::reconfiguration_stratix10::reduce_ascii_config_data { config_data } {
  set keys [dict keys $config_data]
  set config_cnt [llength $keys]
  if {$config_cnt < 2} {
    return $config_data
  }

  set config0 [lindex $keys 0]
  # Let's prune the ASCII data first 
  # Iterate over every parameter in the ASCII data
  dict for {param data} [dict get $config_data $config0 ascii_data] {
    set same 1
    # Compare the value for this parameter for each config.
    for {set index 1} {$index < $config_cnt} {incr index} {
      set key [lindex $keys $index]
      # If the parameter values are identical, remove the element
      if {[dict get $data value] != [dict get $config_data $key ascii_data $param value]} {
        set same 0
      }
    }

    if {$same} {
      for {set index 0} {$index < $config_cnt} {incr index} {
        set key [lindex $keys $index]
        dict set config_data $key ascii_data [dict remove [dict get $config_data $key ascii_data] $param]
      }
    }
  }
  return $config_data
}


##
# Analyzes multiple sets of config data and reduces the ram config data to only
# those data bits that differ between them all.
#
# @param config_data - A dictionary where each key contains a dictionary of
# reconfig data (both ascii_data and ram_data) as returned by the "build_config_data"
# procedure
#
# @return - The same dictionary as passed but with all redundant data removed.
proc ::alt_xcvr::utils::reconfiguration_stratix10::reduce_ram_config_data { config_data } {
  set keys [dict keys $config_data]
  set config_cnt [llength $keys]
  if {$config_cnt < 2} {
    return $config_data
  }

  set config0 [lindex $keys 0]
  dict for {offset high_bits} [dict get $config_data $config0 ram_data] {
    dict for {bit_h data} $high_bits {
      set same 1
      # Iterate over all configs to see if the data is the same
      for {set index 1} {$index < $config_cnt} {incr index} {
        set key [lindex $keys $index]
        if {[dict get $data val_mask] != [dict get $config_data $key ram_data $offset $bit_h val_mask]} {
          set same 0
        }
      }

      # Remove this entry from each config
      if {$same} {
        #puts "Removing [dict get $data param]:[dict get $data param_val] @ $offset:$bit_h"
        for {set index 0} {$index < $config_cnt} {incr index} {
          set key [lindex $keys $index]
          # Remove this bitfield if they were the same
          dict set config_data $key ram_data $offset [dict remove [dict get $config_data $key ram_data $offset] $bit_h]

          # If all bitfields for a given offset have been removed, remove the offset
          if {[llength [dict keys [dict get $config_data $key ram_data $offset]]] == 0} {
            dict set config_data $key ram_data [dict remove [dict get $config_data $key ram_data] $offset]
          }
        }
      }
      # Done with this bitfield
    }
    # Done with this offset
  }
  return $config_data
}


#####
# Generate reconfig settings for each atom 
# @param ip_name - unique qsys name 
# @param rcfg_profile_cnt - number of reconfig profiles 
# @param atom - name of the atom 
# @param all_rcfg_data - a dict of n keys (1 for each profile) 
# and n values (rcfg_data for each profile)
# rcfg_data is a dict of 2 subdictonaries; ascii_data and ram_data
# 
proc ::alt_xcvr::utils::reconfiguration_stratix10::generate_reconfig_settings {ip_name rcfg_profile_cnt atom all_rcfg_data} {
  # terp reconfig file  
  # all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/source/
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_pll/altera_xcvr_atx_pll_vi/source/terp/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  
  # extract the unique random string 
  set random_str [lindex [split $ip_name "_"] end]
  
  # get template
  set file_name "reconfig_settings.txt.terp"
  set filename ${path}/${file_name}
  set file_handle [open ${filename} r] 
  set template [read $file_handle]
  
  set dict_list_of_params [dict create] 
  set dict_list_of_values [dict create]
  
  # iterate over each profile 
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    # first get the <value> for <key> index; <value> is a dict of 2 subdict 
    # second get the <value> for <key> ascii_data; <value> is a dict of [params:values]
    # last get the list of keys for the dict obtained in step 2 with keys *atom*; these contains list of params

    set list_of_params [dict keys [dict get [dict get $all_rcfg_data $index] ascii_data] *${atom}*]
    
    # strip off the atom name from the param
    set list_of_atom_params [list]
    foreach param $list_of_params {
      lappend list_of_atom_params [regsub -all ${atom}_ $param ""]
    } 
    dict set dict_list_of_params $index $list_of_atom_params
    
    # set up a list for the values field 
    set list_of_values [list] 
    # Follow Step 1 and 2 from above 
    # Filter the dict to have key,value pairs only for keys having *atom* 
    # get the list of values; note that values itself is a dict 
    # go through each item in the list and extract the value field for key value
    # finally construct a list of values 
    foreach item [dict values [dict filter [dict get [dict get $all_rcfg_data $index] ascii_data] key *${atom}*]] {
      lappend list_of_values [string trim [dict get $item value] \"]
    }
  
    # set the dict_list_of_values as dict with key:$index and value: list of values 
    dict set dict_list_of_values $index $list_of_values
  } 
  
  # setup template parameters 
  # extract the keys from rcfg_data dict, it has the list of profiles 
  set template_params(list_of_profiles) [dict keys $all_rcfg_data]
  set template_params(dict_list_of_params) $dict_list_of_params
  set template_params(dict_list_of_values) $dict_list_of_values

  set contents [altera_terp $template template_params]
  add_fileset_file "./rcfg_timing_db/${atom}_reconfig_settings_${random_str}.json" OTHER TEXT $contents 
} 

######
# Generate parameter file for each profile of Native PHY in reconfig
# @param ip_name - Top level name
# 
proc ::alt_xcvr::utils::reconfiguration_stratix10::generate_parameters_file_for_reconfig {ip_name ip_core rcfg_profile_cnt timing_params rcfg_data} {
  
  set file_contents ""
    
  append file_contents "if {[info exists ip_params]} {\n"
  append file_contents "   unset ${ip_core}_ip_params\n"
  append file_contents "}\n\n"
  append file_contents "set ${ip_core}_ip_params \[dict create\]\n\n"

  append file_contents "dict set ${ip_core}_ip_params profile_cnt \"$rcfg_profile_cnt\"\n"

  append file_contents "set ::GLOBAL_corename $ip_name\n"
  
  set random_str [lindex [split $ip_name "_"] end]
  
  # get a list of parameters
  set rcfg_params [ip_get "parameter.rcfg_params.value"]
  set rcfg_sdc_derived_params [ip_get "parameter.rcfg_sdc_derived_params.value"]

  # create a list that contains indices of timing parameters in rcfg_params 
  set timing_rcfg_param_indices [list]
  set timing_rcfg_sdc_derived_param_indices [list]

  # iterate over the timing_params list and find the index for each of the param 
  foreach param $timing_params {
    set matching_index [ lsearch $rcfg_params $param ]

    if { $matching_index != -1 } {
      lappend timing_rcfg_param_indices $matching_index
    } else {
      # Param might be derived
      set matching_index [ lsearch $rcfg_sdc_derived_params $param ]
      
      if { $matching_index != -1 } {
        lappend timing_rcfg_sdc_derived_param_indices $matching_index
      }
    }


  }

  # iterate over all the profiles 
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} { 
    append file_contents "# ------------------------------- #\n"
    append file_contents "# --- Profile$index settings       --- #\n" 
    append file_contents "# ------------------------------- #\n"
    
    # get a list of values for the profile of interest 
    set rcfg_param_vals [ip_get "parameter.rcfg_param_vals${index}.value"] 
    set rcfg_sdc_derived_param_vals [ip_get "parameter.rcfg_sdc_derived_param_vals${index}.value"]

    # iterate over the list of indices and print the parameter and value corresponding to it 
    foreach element_index $timing_rcfg_param_indices {
      set param [lindex $rcfg_params $element_index]
      set param_value [lindex $rcfg_param_vals $element_index]
      append file_contents "dict set ${ip_core}_ip_params ${param}_profile$index \"${param_value}\"\n" 
    }

    foreach element_index $timing_rcfg_sdc_derived_param_indices {
      set sdc_param [lindex $rcfg_sdc_derived_params $element_index]
      set sdc_param_value [lindex $rcfg_sdc_derived_param_vals $element_index]
      append file_contents "dict set ${ip_core}_ip_params ${sdc_param}_profile$index \"${sdc_param_value}\"\n" 
    }

    if {$ip_core eq "native_phy"} {
      append file_contents "dict set ${ip_core}_ip_params tx_enable_profile$index \"[ip_get "parameter.tx_enable.value"]\"\n"
      append file_contents "dict set ${ip_core}_ip_params rx_enable_profile$index \"[ip_get "parameter.rx_enable.value"]\"\n"
      append file_contents "dict set ${ip_core}_ip_params tx_coreclkin_freq_profile$index \"156.25\"\n"
    }
  }
  
  # Generate a parameters file using file_contents
  set filename "${ip_core}_ip_parameters_${random_str}.tcl"
  add_fileset_file "./${filename}" OTHER TEXT $file_contents

}



##################################################################################################################################################
#        Dynamic reconfiguration validation callbacks BEGIN
##################################################################################################################################################

##############################
# Set dbg_embedded_debug_enable to 1 if any of the embedded debug logic is enabled
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_embedded_debug_enable { rcfg_enable set_capability_reg_enable set_csr_soft_logic_enable} {
  set set_embedded_debug_enable [expr $set_capability_reg_enable || $set_csr_soft_logic_enable]
  if { $rcfg_enable } {
    ip_set "parameter.dbg_embedded_debug_enable.value" $set_embedded_debug_enable
  } else {
    ip_set "parameter.dbg_embedded_debug_enable.value" 0
  }
}

##############################
# Set dbg_capability_reg_enable 
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_capability_reg_enable { rcfg_enable set_capability_reg_enable} {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_capability_reg_enable.value" $set_capability_reg_enable
  } else {
    ip_set "parameter.dbg_capability_reg_enable.value" 0
  }
}

##############################
# Set dbg_user_identifier 
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_user_identifier { rcfg_enable dbg_capability_reg_enable set_user_identifier } {
  if { $rcfg_enable && $dbg_capability_reg_enable } {
    ip_set "parameter.dbg_user_identifier.value" $set_user_identifier
  } else {
    ip_set "parameter.dbg_user_identifier.value" 0
  }
}

##############################
# Set dbg_stat_soft_logic_enable 
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_stat_soft_logic_enable { rcfg_enable set_csr_soft_logic_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_stat_soft_logic_enable.value" $set_csr_soft_logic_enable
  } else {
    ip_set "parameter.dbg_stat_soft_logic_enable.value" 0
  }
}

##############################
# Set dbg_ctrl_soft_logic_enable 
##############################
proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_dbg_ctrl_soft_logic_enable { rcfg_enable set_csr_soft_logic_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_ctrl_soft_logic_enable.value" $set_csr_soft_logic_enable
  } else {
    ip_set "parameter.dbg_ctrl_soft_logic_enable.value" 0
  }
}

proc ::alt_xcvr::utils::reconfiguration_stratix10::validate_rcfg_separate_avmm_busy { PROP_NAME PROP_VALUE enable_advanced_avmm_options set_csr_soft_logic_enable rcfg_enable_avmm_busy_port } {
  if {$PROP_VALUE} {
    if { $enable_advanced_avmm_options == 0 } {
      if { $set_csr_soft_logic_enable == 0 } {
        ip_message error "Enabling Separate AVMM Busy requires Optional Reconfiguation logic option for soft CSR being enabled"
      }

    # If the advanced avmm option is enabled
    } else {
      if { $rcfg_enable_avmm_busy_port == 1 || $set_csr_soft_logic_enable == 1 } {

      # If neither the port is enabled or the soft logic
      } else {
        ip_message error "Enabling Separate AVMM Busy requires either the AVMM Busy port to be enabled or the Optional Reconfiguation logic option for soft CSR"
      }
    }
  }
}

##################################################################################################################################################
#        Dynamic reconfiguration validation callbacks END
##################################################################################################################################################


