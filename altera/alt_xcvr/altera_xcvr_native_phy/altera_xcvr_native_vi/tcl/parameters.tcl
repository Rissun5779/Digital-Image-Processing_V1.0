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


package provide altera_xcvr_native_vi::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::device
#package require alt_xcvr::utils::rbc
package require alt_xcvr::utils::common
package require nf_xcvr_native::parameters
package require altera_xcvr_cdr_pll_vi::parameters

namespace eval ::altera_xcvr_native_vi::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    get_variable \
    declare_parameters \
    validate

  variable package_name
  variable display_items
  variable parameters
  variable analog_parameters
  variable rcfg_parameters
  variable parameter_mappings
  variable analog_parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable analog_parameter_overrides
  variable static_hdl_parameters
  variable rcfg_report_filters_dyn
  variable rcfg_report_filters_stat

  # the value of this variable is not intended to be changed, it is used to increase code readibility
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  set CONST_ALL_ONES_30_BITS_DECIMAL 1073741823
  
  # the value of this variable is not intended to be changed, it is used to share code accross functions
  variable CONST_DATAPATH_SELECT_MAPPING 
  set CONST_DATAPATH_SELECT_MAPPING {"pcs_direct:PCS Direct" "basic_std:Standard" "basic_std_rm:Standard" "cpri:Standard" "cpri_rx_tx:Standard" "gige:Standard" "gige_1588:Standard" "pipe_g1:Standard" "pipe_g2:Standard" "pipe_g3:Standard" "basic_enh:Enhanced" "interlaken_mode:Enhanced" "sfis_mode:Enhanced" "teng_baser_mode:Enhanced" "teng_1588_mode:Enhanced" "teng_sdi_mode:Enhanced" "teng_baser_krfec_mode:Enhanced" "basic_krfec_mode:Enhanced" "fortyg_basekr_krfec_mode:Enhanced" "test_prp_mode:Enhanced" "teng_1588_krfec_mode:Enhanced"}

  set package_name "altera_xcvr_native_vi::parameters"

  set display_items {\
    {NAME                                         GROUP                         ENABLED                             VISIBLE                               TYPE    ARGS                                                          VALIDATION_CALLBACK }\
    {"General"                                    ""                            NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Common PMA Options"                         ""                            NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {display_analog_options_msg                   "Common PMA Options"          NOVAL                               NOVAL                                 TEXT    {"Not validated"}                                             ::altera_xcvr_native_vi::parameters::validate_display_analog_options_msg }\
    {display_anlg_voltage_msg                     "Common PMA Options"          NOVAL                               NOVAL                                 TEXT    {"Not validated"}                                             ::altera_xcvr_native_vi::parameters::validate_display_anlg_voltage_msg }\
    {"Datapath Options"                           ""                            NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"TX PMA"                                     ""                            NOVAL                               tx_enable                             GROUP   tab                                                           NOVAL           }\
    {"TX Bonding Options"                         "TX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"TX PLL Options"                             "TX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"TX PMA Optional Ports"                      "TX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {display_base_data_rate                       "TX PLL Options"              NOVAL                               tx_enable                             TEXT    {"Not validated"}                                             ::altera_xcvr_native_vi::parameters::validate_display_base_data_rate }\
    \
    {"RX PMA"                                     ""                            NOVAL                               rx_enable                             GROUP   tab                                                           NOVAL           }\
    {"RX CDR Options"                             "RX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Equalization"                               "RX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"RX PMA Optional Ports"                      "RX PMA"                      NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"Standard PCS"                               ""                            NOVAL                               "enable_std || rcfg_iface_enable"     GROUP   tab                                                           NOVAL           }\
    {"Standard PCS FIFO"                          "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Byte Serializer and Deserializer"           "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"8B/10B Encoder and Decoder"                 "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Rate Match FIFO"                            "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Word Aligner and Bitslip"                   "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Bit Reversal and Polarity Inversion"        "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"PCIe Ports"                                 "Standard PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"Enhanced PCS"                               ""                            NOVAL                               "enable_enh || rcfg_iface_enable"     GROUP   tab                                                           NOVAL           }\
    {"Enhanced PCS TX FIFO"                       "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Enhanced PCS RX FIFO"                       "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Interlaken Frame Generator"                 "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Interlaken Frame Sync"                      "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Interlaken CRC-32 Generator and Checker"    "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"10GBASE-R BER Checker"                      "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"64b/66b Encoder and Decoder"                "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Scrambler and Descrambler"                  "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Interlaken Disparity Generator and Checker" "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Block Sync"                                 "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Gearbox"                                    "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"KR-FEC"                                     "Enhanced PCS"                NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"PCS Direct Datapath"                        ""                            NOVAL                               "enable_pcs_dir || rcfg_iface_enable" GROUP   tab                                                           NOVAL           }\
    \
    {"Dynamic Reconfiguration"                    ""                            NOVAL                               NOVAL                                 GROUP   tab                                                           NOVAL           }\
    {"Optional Reconfiguration Logic"             "Dynamic Reconfiguration"     NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Configuration Files"                        "Dynamic Reconfiguration"     NOVAL                               NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Configuration Profiles"                     "Dynamic Reconfiguration"     "rcfg_enable"                       NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"Store configuration to selected profile"    "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 action   ::altera_xcvr_native_vi::parameters::action_store_profile    NOVAL           }\
    {"Load configuration from selected profile"   "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 action   ::altera_xcvr_native_vi::parameters::action_load_profile     NOVAL           }\
    {"Clear selected profile"                     "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 action   ::altera_xcvr_native_vi::parameters::action_clear_profile    NOVAL           }\
    {"Clear all profiles"                         "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 action   ::altera_xcvr_native_vi::parameters::action_clear_profiles   NOVAL           }\
    {"Refresh selected_profile"                   "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 action   ::altera_xcvr_native_vi::parameters::action_refresh_profile  NOVAL           }\
    {"Refresh all profiles"                       "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  false                                 action   ::altera_xcvr_native_vi::parameters::action_refresh_profiles NOVAL           }\
    {"Reconfiguration Parameters"                 "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 GROUP   TABLE                                                         NOVAL           }\
    {"Configuration Profile Data"                 "Configuration Profiles"      "rcfg_multi_enable && rcfg_enable"  NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"Analog PMA Settings (Optional)"             ""                            "l_anlg_tx_enable || l_anlg_rx_enable" "l_anlg_tx_enable || l_anlg_rx_enable" GROUP   tab                                                       NOVAL           }\
    {display_analog_options_mif_msg               "Analog PMA Settings (Optional)" NOVAL                            NOVAL                                 TEXT    {"Not validated"}                                             ::altera_xcvr_native_vi::parameters::validate_display_analog_options_mif_msg }\
    {"TX Analog PMA Settings"                     "Analog PMA Settings (Optional)" l_anlg_tx_enable                 NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    {"RX Analog PMA Settings"                     "Analog PMA Settings (Optional)" l_anlg_rx_enable                 NOVAL                                 GROUP   NOVAL                                                         NOVAL           }\
    \
    {"Generation Options"                         ""                            NOVAL                               NOVAL                                 GROUP   tab                                                           NOVAL           }\
    \
    {"Debug"                                      ""                            enable_debug_options                enable_debug_options                  GROUP   tab                                                           NOVAL           }\
    {"Parameter Validation Rules"                 "Debug"                       enable_debug_options                enable_debug_options                  GROUP   NOVAL                                                         NOVAL           }\
    {"Transceiver Attributes"                     "Debug"                       enable_debug_options                enable_debug_options                  GROUP   NOVAL                                                         NOVAL           }\
    {"validation_rule_display"                    "Parameter Validation Rules"  enable_debug_options                enable_debug_options                  TEXT    {"Select a parameter from the dropdown"}                      NOVAL           }\
}

  set parameters {\
    {NAME                                         DERIVED HDL_PARAMETER TYPE      DEFAULT_VALUE                   ALLOWED_RANGES                                                                                                                                      ENABLED                                   VISIBLE                                 DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                                  DISPLAY_NAME                                                                    M_USED_FOR_RCFG     M_SAME_FOR_RCFG     VALIDATION_CALLBACK                                                               M_ALWAYS_VALIDATE	DESCRIPTION }\
    {device_family                                false   false         STRING    "Stratix VI"                    NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0					NOVAL}\
    {device                                       false   false         STRING    "Unknown"                       NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0					NOVAL}\
    {base_device                                  false   false         STRING    "Unknown"                       NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0					NOVAL}\
    {design_environment                           false   false         STRING    "NATIVE"                        NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0					NOVAL}\
    \
    {device_revision                              true    true          STRING    "20nm5es"                       NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_device_revision                     0					NOVAL}\
    {message_level                                false   false         STRING    "error"                         {error warning}                                                                                                                                     true                                      true                                    NOVAL         NOVAL         "General"                                     "Message level for rule violations"                                             0                   0                   ::altera_xcvr_native_vi::parameters::validate_message_level                       0					"Specifies the messaging level to use for parameter rule violations. Selecting \"error\" causes all rule violations to prevent IP generation. Selecting \"warning\" displays all rule violations as warnings and allows IP generation in spite of violations."}\
    \
    {anlg_voltage                                 false   false         STRING    "1_0V"                          {"1_1V" "1_0V" "0_9V"}                                                                                                                              true                                      true                                    NOVAL         NOVAL         "Common PMA Options"                          "VCCR_GXB and VCCT_GXB supply voltage for the Transceiver"                      1                   1                   NOVAL                                                                             0         "Selects the VCCR_GXB and VCCT_GXB supply voltage for the Transceiver."}\
    {anlg_link                                    false   false         STRING    "sr"                            {"sr:SR" "lr:LR"}                                                                                                                                         true                                      true                                    NOVAL         NOVAL         "Common PMA Options"                          "Tranceiver Link Type"                                                          1                   1                   NOVAL                                                                             0         "Selects the type of transceiver link. SR-Short Reach (Chip-to-chip communication), LR-Long Reach (Backplane communication)"}\
    \
    {support_mode                                 false   false         STRING    "user_mode"                     {"user_mode" "engineering_mode"}                                                                                                                    enable_advanced_options                   enable_advanced_options                 NOVAL         NOVAL         "Datapath Options"                            "Protocol support mode"                                                         1                   0                   ::altera_xcvr_native_vi::parameters::validate_support_mode                        0					"Selects the protocol support mode (user or engineering). Engineering mode options are not officially supported by Altera or Quartus."}\
    {protocol_mode                                false   false         STRING    "basic_std"                     NOVAL                                                                                                                                               true                                      true                                    NOVAL         NOVAL         "Datapath Options"                            "Transceiver configuration rules"                                               1                   0                   ::altera_xcvr_native_vi::parameters::validate_protocol_mode                       0					"Selects the protocol configuration rules for the transceiver. This parameter governs the rules for correct settings of individual parameters within the PMA and PCS. Certain features of the transceiver are available only for specific protocol configuration rules. This parameter is not a \"preset\". You must still correctly set all other parameters for your specific protocol and application needs."}\
    {pma_mode                                     false   false         STRING    "basic"                         {"basic" "SATA:SATA/SAS" "QPI" "GPON"}                                                                                                              true                                      true                                    NOVAL         NOVAL         "Datapath Options"                            "PMA configuration rules"                                                       1                   0                   ::altera_xcvr_native_vi::parameters::validate_pma_mode                            0					"Selects the configuration rules for PMA. Options are SATA/SAS, GPON, QPI and basic. Basic should be selected for all modes other than SATA/SAS, GPON, and QPI. SATA/SAS mode can be used only if \"Transceiver configuration rules\" is selected as Standard PCS. GPON mode can be used only if \"Transceiver configuration rules\" is selected as Standard or Enhanced PCS. QPI mode can be used only if \"Transceiver configuration rules\" is selected as PCS Direct. This parameter is not a \"preset\". You must still correctly set other parameters and enable relavant ports for your specific application needs."}\
    {duplex_mode                                  false   true          STRING    "duplex"                        {"duplex:TX/RX Duplex" "tx:TX Simplex" "rx:RX Simplex"}                                                                                             true                                      true                                    NOVAL         NOVAL         "Datapath Options"                            "Transceiver mode"                                                              1                   1                   ::altera_xcvr_native_vi::parameters::validate_duplex_mode                         0					"Selects the transceiver operation mode."}\
    {channels                                     false   true          INTEGER   1                               {1:96}                                                                                                                                              true                                      true                                    NOVAL         NOVAL         "Datapath Options"                            "Number of data channels"                                                       1                   1                   NOVAL                                                                             0					"Specifies the total number of data channels."}\
    {set_data_rate                                false   false         STRING    "1250"                          NOVAL                                                                                                                                               true                                      true                                    "columns:10"  Mbps          "Datapath Options"                            "Data rate"                                                                     1                   0                   ::altera_xcvr_native_vi::parameters::validate_set_data_rate                       0					"Specifies the transceiver data rate in units of Mbps (megabits per second)."}\
    {rcfg_iface_enable                            false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "Datapath Options"                            "Enable datapath and interface reconfiguration"                                 1                   1                   NOVAL                                                                             0					"Enables the ability to preconfigure and dynamically switch between the Standard PCS, Enhanced PCS, and PCS direct transceiver datapaths." }\
    {enable_simple_interface                      false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "Datapath Options"                            "Enable simplified data interface"                                              1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_simple_interface             1					"When selected the Native PHY presents a simplified data and control interface between the FPGA and transceiver. When not selected the Native PHY presents the full raw data interface to the transceiver. You need to understand the mapping of data and control signals within the interface. This option cannot be enabled if you want to perform dynamic interface reconfiguration as only a fixed subset of the data and control signals are provided."}\
    {enable_split_interface                       false   false         INTEGER   0                               NOVAL                                                                                                                                               false                                     false                                   boolean       NOVAL         "Datapath Options"                            "Provide separate interface for each channel"                                   1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_split_interface              0					"When selected the Native PHY presents separate data, reset, and clock interfaces for each channel rather than a wide bus."}\
    {set_enable_calibration                       false   false         INTEGER   1                               NOVAL                                                                                                                                               enable_advanced_options                   enable_advanced_options                 boolean       NOVAL         "Datapath Options"                            "Enable calibration"                                                            1                   1                   NOVAL                                                                             0					"When selected the Native PHY enables transceiver calibration algorithms."}\
    {enable_calibration                           true    true          INTEGER   0                               NOVAL                                                                                                                                               enable_advanced_options                   false                                   boolean       NOVAL         "Datapath Options"                            NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_enable_calibration                  0					NOVAL}\
    {set_disconnect_analog_resets                 false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "Datapath Options"                            "Disconnect analog resets"                                                      0                   0                   NOVAL                                                                             0					"When selected the Native PHY will disconnect the tx_analogreset and rx_analogreset. This can be enabled only after consultation with Altera factory/applications."}\
    {enable_analog_resets                         true    true          INTEGER   1                               NOVAL                                                                                                                                               false                                     false                                   boolean       NOVAL         "Datapath Options"                            "Enable analog resets"                                                          0                   0                   NOVAL                                                                             0					"When selected the Native PHY will enable tx_analog_resets and rx_analog_resets."}\
    {enable_reset_sequence                        true    true          INTEGER   0                               NOVAL                                                                                                                                               false                                     false                                   boolean       NOVAL         "Datapath Options"                            "Enable reset sequence"                                                         0                   0                   NOVAL                                                                             0					"When selected the Native PHY will enable sequencing of tx_analog_resets and rx_analog_resets."}\
    {enable_transparent_pcs                       false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   boolean       NOVAL         "Datapath Options"                            "Enable transparent PCS"                                                        0                   0                   NOVAL                                                                             0					NOVAL}\
    {enable_parallel_loopback                     false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_advanced_options                   enable_advanced_options                 boolean       NOVAL         "Datapath Options"                            "Enable parallel loopback"                                                      1                   1                   NOVAL                                                                             0					NOVAL}\
    \
    {bonded_mode                                  false   true          STRING    not_bonded                      {"not_bonded:Not bonded" "pma_only:PMA only bonding" "pma_pcs:PMA and PCS bonding"}                                                                 tx_enable                                 tx_enable                               NOVAL         NOVAL         "TX Bonding Options"                          "TX channel bonding mode"                                                       1                   1                   ::altera_xcvr_native_vi::parameters::validate_bonded_mode                         0					"Specifies the transceiver TX channel bonding mode to control channel-to-channel skew for the TX datapath. Refer to the user guide for bonding details. Options are no TX channel bonding (non-bonded); PMA only channel bonding; or PMA & PCS channel bonding."}\
    {set_pcs_bonding_master                       false   false         STRING    "Auto"                          {"Auto"}                                                                                                                                            tx_enable                                 tx_enable                               NOVAL         NOVAL         "TX Bonding Options"                          "PCS TX channel bonding master"                                                 1                   1                   ::altera_xcvr_native_vi::parameters::validate_set_pcs_bonding_master              0					"Specifies the master PCS channel for PCS bonded configurations. Refer to the user guide for bonding details. Selecting 'Auto' allows the Native PHY to automatically select a recommended channel."}\
    {pcs_bonding_master                           true    true          INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               NOVAL         NOVAL         "TX Bonding Options"                          "Actual PCS TX channel bonding master"                                          0                   0                   ::altera_xcvr_native_vi::parameters::validate_pcs_bonding_master                  0					"Indicates the selected master PCS channel for PCS bonded configurations."}\
    {tx_pma_clk_div                               false   false         INTEGER   1                               {1 2 4 8}                                                                                                                                           !l_enable_pma_bonding                     tx_enable                               NOVAL         NOVAL         "TX PLL Options"                              "TX local clock division factor"                                                1                   0                   NOVAL                                                                             0					"Specifies the TX serial clock division factor. The transceiver has the ability to further divide the TX serial clock from the TX PLL before use. This parameter specifies the division factor to use. Example: A PLL data rate of \"10000 Mbps\" and a local division factor of 8 results in a channel data rate of \"1250 Mbps\""}\
    {plls                                         false   true          INTEGER   1                               {1 2 3 4}                                                                                                                                           !l_enable_pma_bonding                     tx_enable                               NOVAL         NOVAL         "TX PLL Options"                              "Number of TX PLL clock inputs per channel"                                     1                   1                   NOVAL                                                                             0                   "Specifies the desired number of TX PLL clock inputs per channel. This is used when you intend to dynamically switch between TX PLL clock sources. The Native PHY presents up to 4 clock inputs per channel to allow dynamically input clock switching."}\
    {pll_select                                   false   false         INTEGER   0                               {0}                                                                                                                                                 !l_enable_pma_bonding                     tx_enable                               NOVAL         NOVAL         "TX PLL Options"                              "Initial TX PLL clock input selection"                                          1                   0                   ::altera_xcvr_native_vi::parameters::validate_pll_select                          0                   "Specifies the initially selected TX PLL clock input. This indicates the starting clock input selection used for this configuration when dynamically switching between multiple TX PLL clock inputs."}\
    {enable_port_tx_analog_reset_ack              false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_analog_reset_ack port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional tx_pma_analog_reset_ack output. This port should not be used for register mode data transfers."}\
    {enable_port_tx_pma_clkout                    false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_clkout port"                                                     1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_clkout           0                   "Enables the optional tx_pma_clkout output clock. This is the parallel clock from the TX PMA. This port is not to be used to clock the data interface."}\
    {enable_port_tx_pma_div_clkout                false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_div_clkout port"                                                 1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_div_clkout       0                   "Enables the optional tx_pma_div_clkout output clock. This port should not be used for register mode data transfers."}\
    {tx_pma_div_clkout_divider                    false   false         STRING    0                               {"0:Disabled" "1" "2" "33" "40" "66"}                                                                                                               enable_port_tx_pma_div_clkout             tx_enable                               NOVAL         NOVAL         "TX PMA Optional Ports"                       "tx_pma_div_clkout division factor"                                             1                   0                   NOVAL                                                                             0                   "Specifies the divider value for the tx_pma_div_clkout clock signal."}\
    {enable_port_tx_pma_iqtxrx_clkout             false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_iqtxrx_clkout port"                                              1                   1                   NOVAL                                                                             0                   "Enables the optional tx_pma_iqtxrx_clkout output clock. This clock can be used to cascade the TX PMA output clock to the input of a PLL."}\
    {enable_port_tx_pma_elecidle                  false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_elecidle port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional tx_pma_elecidle control input port. The assertion of this signal forces the transmitter into an electrical idle condition. Note that this port has no effect when the transceiver is configured for PCI express modes."}\
    {enable_port_tx_pma_qpipullup                 false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_qpipullup port (QPI)"                                            1                   1                   NOVAL                                                                             0                   "Enables the tx_pma_qpipullup control input port. This port is used only in QPI applications."}\
    {enable_port_tx_pma_qpipulldn                 false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_qpipulldn port (QPI)"                                            1                   1                   NOVAL                                                                             0                   "Enables the tx_pma_qpipulldn control input port. This port is used only in QPI applications."}\
    {enable_port_tx_pma_txdetectrx                false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_txdetectrx port (QPI)"                                           1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_txdetectrx       0                   "Enables the tx_pma_txdetectrx control input port. This port is used only in QPI applications. The receiver detect block in TX PMA detects the presence of a receiver at the other end of the channel. After receiving tx_pma_txdetectrx request the receiver detect block initiates the detection process."}\
    {enable_port_tx_pma_rxfound                   false   false         INTEGER   0                               NOVAL                                                                                                                                               tx_enable                                 tx_enable                               boolean       NOVAL         "TX PMA Optional Ports"                       "Enable tx_pma_rxfound port (QPI)"                                              1                   1                   NOVAL                                                                             0                   "Enables the tx_rxfound status output port. This port is used only in QPI applications. The receiver detect block in TX PMA detects the presence of a receiver at the other end by using tx_pma_txdetectrx input. Detection of RX status is given on the tx_pma_rxfound port."}\
    {enable_port_rx_seriallpbken_tx               false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "TX PMA Optional Ports"                       "Enable rx_seriallpbken port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional rx_seriallpbken control input port. The assertion of this signal enables the TX to RX serial loopback path within the transceiver. This is an asynchronous input signal. This signal can be enabled in Duplex or Simplex mode. If enabled in Simplex mode, you must drive the signal on both the TX and RX instances from the same source. Otherwise the design fails compilation."}\
    {number_physical_bonding_clocks               false   true          INTEGER    1                              {1 2 3 4}                                                                                                                                           enable_physical_bonding_clocks&&l_enable_pma_bonding            enable_physical_bonding_clocks          NOVAL         NOVAL         "TX PMA Optional Ports"                       "Number of physical bonding clock ports to use."                                                               1                   0                   NOVAL                                             0                   "Specifies the number of physical bonding clock ports to use."}\
    \
    {cdr_refclk_cnt                               false   true          INTEGER   1                               {1 2 3 4 5}                                                                                                                                         rx_enable                                 rx_enable                               NOVAL         NOVAL         "RX CDR Options"                              "Number of CDR reference clocks"                                                1                   1                   NOVAL                                                                             0                   "Specifies the number of input reference clocks for the RX CDRs. The same bus of reference clocks feeds all RX CDRs in the netlist."}\
    {cdr_refclk_select                            false   false         INTEGER   0                               {0}                                                                                                                                                 rx_enable                                 rx_enable                               NOVAL         NOVAL         "RX CDR Options"                              "Selected CDR reference clock"                                                  1                   0                   ::altera_xcvr_native_vi::parameters::validate_cdr_refclk_select                   0                   "Specifies the initially selected reference clock input to the RX CDRs."}\
    {set_cdr_refclk_freq                          false   false         STRING    "125.000"                       {"125.000"}                                                                                                                                         rx_enable                                 rx_enable                               NOVAL         MHz           "RX CDR Options"                              "Selected CDR reference clock frequency"                                        1                   0                   ::altera_xcvr_native_vi::parameters::validate_set_cdr_refclk_freq                 0                   "Specifies the frequency in MHz of the selected reference clock input to the CDR."}\
    {rx_ppm_detect_threshold                      false   false         STRING    "1000"                          {100 300 500 1000}                                                                                                                                  rx_enable                                 rx_enable                               NOVAL         PPM           "RX CDR Options"                              "PPM detector threshold"                                                        1                   0                   NOVAL                                                                             0                   "Specifies the tolerable difference in PPM (parts per million) between the RX CDR reference clock and the recovered clock from the RX data input."}\
    \
    {rx_pma_ctle_adaptation_mode                  false   false         STRING    "manual"                        { "manual" "one-time:triggered" }                                                                                                                   rx_enable                                 rx_enable                               NOVAL         NOVAL         "Equalization"                                "CTLE mode"                                                                     1                   0                   NOVAL                                                                             0                   "Specifies the operation mode for Continuous Time Linear Equalizer (CTLE). Options are \"manual\" (where user is expected to set CTLE through qsf assignment or DPRIO) and \"triggered\" (where CTLE is adapted at user request - (i.e. resetting adaptation and requesting adaptation start through DPRIO)). CTLE boosts the near Nyquist frequency content of the received signal."}\
    {rx_pma_dfe_adaptation_mode                   false   false         STRING    "disabled"                      { "continuous:adaptation enabled" "manual" "disabled" }                                                                                             rx_enable                                 rx_enable                               NOVAL         NOVAL         "Equalization"                                "DFE mode"                                                                      1                   0                   NOVAL                                                                             0                   "Specifies the operation mode for Decision Feedback Equalizer (DFE). Options are \"disable\" (where DFE is bypassed), \"adaptation enabled\" (where the DFE taps are adapted automatically), \"manual\" (where the DFE is expected to be configured manually by user through qsf assignments or DPRIO)."}\
    {rx_pma_dfe_fixed_taps                        false   false         INTEGER   3                               { 3 7 11}                                                                                                                                           true                                      rx_enable                               NOVAL         NOVAL         "Equalization"                                "Number of fixed dfe taps"                                                      1                   0                   ::altera_xcvr_native_vi::parameters::validate_rx_pma_dfe_fixed_taps               0                   "Specifies the number of fixed DFE taps."}\
    {enable_ports_adaptation                      false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 "rx_enable&&enable_advanced_options"    boolean       NOVAL         "Equalization"                                "Enable adaptation control ports"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional rx_adapt_reset, and rx_adapt_start ports. These ports are used to control the adaptation engine (adaptation engine can also be controlled through DPRIO interface). Even if they are exposed, the ports are not usable until they are activated through DPRIO interface. For adaptation engine control: user needs to apply the reset first, after releasing reset, assert the start. The adaptation status can be observed through DPRIO interface."}\
    \
    {enable_port_rx_analog_reset_ack              false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_analog_reset_ack port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional rx_analog_reset_ack output. This port should not be used for register mode data transfers."}\
    {enable_port_rx_pma_clkout                    false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_pma_clkout port"                                                     1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_pma_clkout           0                   "Enables the optional rx_pma_clkout output clock. This is the recovered parallel clock from the RX CDR. This port is not to be used to clock the data interface."}\
    {enable_port_rx_pma_div_clkout                false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_pma_div_clkout port"                                                 1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_pma_div_clkout       0                   "Enables the optional rx_pma_div_clkout output clock. This port should not be used for register mode data transfers."}\
    {rx_pma_div_clkout_divider                    false   false         STRING    0                               {"0:Disabled" "1" "2" "33" "40" "66"}                                                                                                               enable_port_rx_pma_div_clkout             rx_enable                               NOVAL         NOVAL         "RX PMA Optional Ports"                       "rx_pma_div_clkout division factor"                                             1                   0                   NOVAL                                                                             0                   "Specifies the divider value for the rx_pma_div_clkout clock signal."}\
    {enable_port_rx_pma_iqtxrx_clkout             false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_pma_iqtxrx_clkout port"                                              1                   1                   NOVAL                                                                             0                   "Enables the optional rx_pma_iqtxrx_clkout output clock. This clock can be used to cascade the RX PMA output clock to the input of a PLL."}\
    {enable_port_rx_pma_clkslip                   false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_pma_clkslip port"                                                    1                   1                   NOVAL                                                                             0                   "Enables the optional rx_pma_clkslip control input port. A rising edge on this signal causes the RX serializer to slip the serial data by one clock cycle (2 UI)."}\
    {enable_port_rx_pma_qpipulldn                 false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_pma_qpipulldn port (QPI)"                                            1                   1                   NOVAL                                                                             0                   "Enables the rx_pma_qpipulldn control input port. This port is used only in QPI applications."}\
    {enable_port_rx_is_lockedtodata               false   false         INTEGER   1                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_is_lockedtodata port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_is_lockedtodata status output port. This signal indicates that the RX CDR is currently in lock to data mode or is attempting to lock to the incoming data stream. This is an asynchronous output signal."}\
    {enable_port_rx_is_lockedtoref                false   false         INTEGER   1                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_is_lockedtoref port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_is_lockedtoref status output port. This signal indicates that the RX CDR is currently locked to the CDR reference clock. This is an asynchronous output signal."}\
    {enable_ports_rx_manual_cdr_mode              false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_set_locktodata and rx_set_locktoref ports"                           1                   1                   NOVAL                                                                             0                   "Enables the optional rx_set_locktodata and rx_set_locktoref control input ports. These ports are used to manually control the lock mode of the RX CDR. These are asynchonous input signals."}\
    {enable_ports_rx_manual_ppm                   false   false         INTEGER   0                               NOVAL                                                                                                                                               "rx_enable&&enable_advanced_options"      "rx_enable&&enable_advanced_options"    boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_fref and rx_clklow ports"                                            1                   1                   NOVAL                                                                             0                   "Enables the optional rx_fref and rx_clklow output ports. These ports can be used to implement an external PPM detector for clock data recovery."}\
    {enable_port_rx_signaldetect                  false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 false                                   boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_signaldetect port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional rx_signaldetect status output port. The assertion of this signal indicates detection of an input signal to the RX PMA. Refer to the user guide for applications and limitations. This is an asynchronous output signal."}\
    {enable_port_rx_seriallpbken                  false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "RX PMA Optional Ports"                       "Enable rx_seriallpbken port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional rx_seriallpbken control input port. The assertion of this signal enables the TX to RX serial loopback path within the transceiver. This is an asynchronous input signal. This signal can be enabled in Duplex or Simplex mode. If enabled in Simplex mode, you must drive the signal on both the TX and RX instances from the same source. Otherwise the design fails compilation."}\
    {enable_ports_rx_prbs                         false   false         INTEGER   0                               NOVAL                                                                                                                                               rx_enable                                 rx_enable                               boolean       NOVAL         "RX PMA Optional Ports"                       "Enable PRBS verifier control and status ports"                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_prbs_err, rx_prbs_err_clr, and rx_prbs_done ports. These ports are used to control and collect status from the internal PRBS verifier."}\
    \
    {std_pcs_pma_width                            false   false         INTEGER   10                              {8 10 16 20}                                                                                                                                        enable_std                                enable_std                              NOVAL         NOVAL         "Standard PCS"                                "Standard PCS / PMA interface width"                                            1                   0                   NOVAL                                                                             0                   "Specifies the data interface width between the 'Standard PCS' and the transceiver PMA."}\
    {display_std_tx_pld_pcs_width                 true    false         INTEGER   NOVAL                           NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std                         NOVAL         NOVAL         "Standard PCS"                                "FPGA fabric / Standard TX PCS interface width"                                 1                   0                   ::altera_xcvr_native_vi::parameters::validate_display_std_tx_pld_pcs_width        0                   "Indicates the data interface width between the Standard TX PCS datapath and the FPGA fabric. This value is determined by the current configuration of individual blocks within the Standard TX PCS datapath."}\
    {display_std_rx_pld_pcs_width                 true    false         INTEGER   NOVAL                           NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std                         NOVAL         NOVAL         "Standard PCS"                                "FPGA fabric / Standard RX PCS interface width"                                 1                   0                   ::altera_xcvr_native_vi::parameters::validate_display_std_rx_pld_pcs_width        0                   "Indicates the data interface width between the Standard RX PCS datapath and the FPGA fabric. This value is determined by the current configuration of individual blocks within the Standard RX PCS datapath."}\
    {std_low_latency_bypass_enable                false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_std                              boolean       NOVAL         "Standard PCS"                                "Enable 'Standard PCS' low latency mode"                                        1                   0                   NOVAL                                                                             0                   "Enables the low latency path for the 'Standard PCS'. Enabling this option bypasses the individual functional blocks within the 'Standard PCS' to provide the lowest latency datapath from the PMA through the 'Standard PCS'."}\
	{enable_hip                                   false   true          INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_advanced_options                 boolean       NOVAL         "Standard PCS"                                "Enable PCIe hard IP support"                                                   1                   0                   NOVAL                                                                             0                   "INTERNAL USE ONLY. Enabling this parameter indicates that the Native PHY variant will be connected to the PCIe hard IP."}\
    {enable_skp_ports                             false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_advanced_options                 boolean       NOVAL         "Standard PCS"                                "Enable SKP ports for Gen3"                                                     0                   0                   NOVAL                                                                             0                   "Enable SKP workaround ports for Gen3. This is available only in HIP mode."}\
    {enable_hard_reset                            false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_advanced_options                 boolean       NOVAL         "Standard PCS"                                "Enable hard reset controller (HIP)"                                            1                   0                   NOVAL                                                                             0                   "INTERNAL USE ONLY. Enabling this parameter enables the hard reset controller for use with PCIe HIP."}\
    {set_hip_cal_en                               false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_advanced_options                 boolean       NOVAL         "Standard PCS"                                "Enable PCIe hard IP calibration"                                               1                   0                   NOVAL                                                                             0                   "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
    {hip_cal_en                                   true    true          STRING    "disable"                       { "disable" "enable" }                                                                                                                              enable_std                                false                                   NOVAL         NOVAL         "Standard PCS"                                NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_hip_cal_en                          0                   "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
    {enable_pcie_data_mask_option                 false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_std                                enable_advanced_options                 boolean       NOVAL         "Standard PCS"                                "Enable PCIe data mask count multiplier control"                                0                   0                   NOVAL                                                                             0                   "INTERNAL USE ONLY. Enabling this parameter allows user control on the PCIe data mask count multiplier value."}\
    {std_data_mask_count_multi                    false   false         INTEGER   0                               {0 1 3}                                                                                                                                             enable_pcie_data_mask_option              enable_advanced_options                 NOVAL         NOVAL         "Standard PCS"                                "PCIe data mask count multiplier"                                               0                   0                   NOVAL                                                                             0                   "Specifies the data mask count multiplier for PCI Express configurations."}\
    \
    {std_tx_pcfifo_mode                           false   false         STRING    "low_latency"                   {low_latency register_fifo fast_register}                                                                                                           l_enable_tx_std                           l_enable_tx_std_iface                   NOVAL         NOVAL         "Standard PCS FIFO"                           "TX FIFO mode"                                                                  1                   0                   NOVAL                                                                             0                   "Specifies the mode for the 'Standard PCS' TX FIFO."}\
    {std_rx_pcfifo_mode                           false   false         STRING    "low_latency"                   {low_latency register_fifo}                                                                                                                         l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Standard PCS FIFO"                           "RX FIFO mode"                                                                  1                   0                   NOVAL                                                                             0                   "Specifies the mode for the 'Standard PCS' RX FIFO."}\
    {enable_port_tx_std_pcfifo_full               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "Standard PCS FIFO"                           "Enable tx_std_pcfifo_full port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional tx_std_pcfifo_full status output port. This signal indicates when the standard TX phase compensation FIFO has reached the full threshold. This signal is synchronous with 'tx_std_clkout'."}\
    {enable_port_tx_std_pcfifo_empty              false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "Standard PCS FIFO"                           "Enable tx_std_pcfifo_empty port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional tx_std_pcfifo_empty status output port. This signal indicates when the standard RX phase compensation FIFO has reached the empty threshold. This signal is synchronous with 'tx_std_clkout'."}\
    {enable_port_rx_std_pcfifo_full               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Standard PCS FIFO"                           "Enable rx_std_pcfifo_full port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_pcfifo_full status output port. This signal indicates when the standard RX phase compensation FIFO has reached the full threshold. This signal is synchronous with 'rx_std_clkout'."}\
    {enable_port_rx_std_pcfifo_empty              false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Standard PCS FIFO"                           "Enable rx_std_pcfifo_empty port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_pcfifo_empty status output port. This signal indicates when the standard RX phase compensation FIFO has reached the full threshold. This signal is synchronous with 'rx_std_clkout'."}\
    \
    {std_tx_byte_ser_mode                         false   false         STRING    "Disabled"                      {"Disabled" "Serialize x2" "Serialize x4"}                                                                                                          l_enable_tx_std                           l_enable_tx_std_iface                   NOVAL         NOVAL         "Byte Serializer and Deserializer"            "TX byte serializer mode"                                                       1                   0                   NOVAL                                                                             0                   "Specifies the mode for the TX byte serializer in the 'Standard PCS'. The transceiver architecture allows the 'Standard PCS' to operate at double or quadruple the data width of the PMA serializer. This allows the PCS to run at a lower internal clock frequency and accommodate a wider range of FPGA interface widths. This option is limited by the target protocol mode."}\
    {std_rx_byte_deser_mode                       false   false         STRING    "Disabled"                      {"Disabled" "Deserialize x2" "Deserialize x4"}                                                                                                      l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Byte Serializer and Deserializer"            "RX byte deserializer mode"                                                     1                   0                   NOVAL                                                                             0                   "Specifies the mode for the RX byte deserializer in the 'Standard PCS' The transceiver architecture allows the 'Standard PCS' to operate at double or quadruple the data width of the PMA deserializer. This allows the PCS to run at a lower internal clock frequency and accommodate a wider range of FPGA interface widths. This option is limited by the target protocol mode."}\
    \
    {std_tx_8b10b_enable                          false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "8B/10B Encoder and Decoder"                  "Enable TX 8B/10B encoder"                                                      1                   0                   NOVAL                                                                             0                   "Enables the 8B/10B encoder in the 'Standard PCS'."}\
    {std_tx_8b10b_disp_ctrl_enable                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "8B/10B Encoder and Decoder"                  "Enable TX 8B/10B disparity control"                                            1                   0                   NOVAL                                                                             0                   "Enables disparity control for the 8B/10B encoder. This allows you to force the disparity of the 8b10b encoder via the 'tx_forcedisp' control signal."}\
    {std_rx_8b10b_enable                          false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   boolean       NOVAL         "8B/10B Encoder and Decoder"                  "Enable RX 8B/10B decoder"                                                      1                   0                   NOVAL                                                                             0                   "Enables the 8B/10B decoder in the 'Standard PCS'."}\
    \
    {std_rx_rmfifo_mode                           false   false         STRING    "disabled"                      {"disabled:Disabled" "basic (single width):Basic 10-bit PMA" "basic (double width):Basic 20-bit PMA" "gige:GbE" "pipe:PIPE" "pipe 0ppm:PIPE 0ppm"}  l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Rate Match FIFO"                             "RX rate match FIFO mode"                                                       1                   0                   NOVAL                                                                             0                   "Specifies the operation mode of the RX rate match FIFO in the 'Standard PCS'."}\
    {std_rx_rmfifo_pattern_n                      false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   hexadecimal   NOVAL         "Rate Match FIFO"                             "RX rate match insert/delete -ve pattern (hex)"                                 1                   0                   NOVAL                                                                             0                   "Specifies the -ve (negative) disparity value for the RX rate match FIFO. The value is 20 bits and specified as a hexadecimal string."}\
    {std_rx_rmfifo_pattern_p                      false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   hexadecimal   NOVAL         "Rate Match FIFO"                             "RX rate match insert/delete +ve pattern (hex)"                                 1                   0                   NOVAL                                                                             0                   "Specifies the +ve (positive) disparity value for the RX rate match FIFO. The value is 20 bits and specified as a hexadecimal string."}\
    {enable_port_rx_std_rmfifo_full               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Rate Match FIFO"                             "Enable rx_std_rmfifo_full port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_rmfifo_full status output port. This signal indicates when the standard RX rate match FIFO has reached the full threshold."}\
    {enable_port_rx_std_rmfifo_empty              false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Rate Match FIFO"                             "Enable rx_std_rmfifo_empty port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_rmfifo_empty status output port. This signal indicates when the standard RX rate match FIFO has reached the empty threshold."}\
    {pcie_rate_match                              false   false         STRING    "Bypass"                        {"Bypass" "0 ppm" "600 ppm"}                                                                                                                        l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Rate Match FIFO"                             "PCI Express Gen 3 rate match FIFO mode"                                        1                   0                   NOVAL                                                                             0                   "Specifies the PPM tolerance mode of the PCI Express Gen 3 rate match FIFO."}\
    \
    {std_tx_bitslip_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable TX bitslip"                                                             1                   0                   NOVAL                                                                             0                   "Enables TX bitslip support. When enabled, the outgoing transmit data can be slipped a specific number of bits as specified by the 'tx_bitslipboundarysel' control signal."}\
    {enable_port_tx_std_bitslipboundarysel        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable tx_std_bitslipboundarysel port"                                         1                   0                   ::altera_xcvr_native_vi::parameters::enable_port_tx_std_bitslipboundarysel        0                   "Enables the optional tx_std_bitslipboundarysel control input port."}\
    {std_rx_word_aligner_mode                     false   false         STRING    "bitslip"                       {"bitslip" "manual (PLD controlled):manual (FPGA Fabric controlled)" "synchronous state machine" "deterministic latency"}                           l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "RX word aligner mode"                                                          1                   0                   NOVAL                                                                             0                   "Specifies the RX word aligner mode for the 'Standard PCS'."}\
    {std_rx_word_aligner_pattern_len              false   false         INTEGER   7                               {7 8 10 16 20 32 40}                                                                                                                                l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "RX word aligner pattern length"                                                1                   0                   NOVAL                                                                             0                   "Specifies the RX word alignment pattern length."}\
    {std_rx_word_aligner_pattern                  false   false         LONG      0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   hexadecimal   NOVAL         "Word Aligner and Bitslip"                    "RX word aligner pattern (hex)"                                                 1                   0                   NOVAL                                                                             0                   "Specifies the RX word alignment pattern."}\
    {std_rx_word_aligner_rknumber                 false   false         INTEGER   3                               "0:255"                                                                                                                                             l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "Number of word alignment patterns to achieve sync"                             1                   0                   NOVAL                                                                             0                   "Specifies the number of valid word alignment patterns that must be received before the word aligner achieves sync lock."}\
    {std_rx_word_aligner_renumber                 false   false         INTEGER   3                               "0:63"                                                                                                                                              l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "Number of invalid data words to lose sync"                                     1                   0                   NOVAL                                                                             0                   "Specifies the number of invalid data codes or disparity errors that must be received before the word aligner loses sync lock."}\
    {std_rx_word_aligner_rgnumber                 false   false         INTEGER   3                               "0:255"                                                                                                                                             l_enable_rx_std                           l_enable_rx_std_iface                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "Number of valid data words to decrement error count"                           1                   0                   NOVAL                                                                             0                   "Specifies the number of valid data codes that must be received to decrement the error counter. If enough valid data codes are received to decrement the error count to zero the word aligner returns to sync lock."}\
    {std_rx_word_aligner_rvnumber                 false   false         INTEGER   0                               "0:8191"                                                                                                                                            l_enable_rx_std                           false                                   NOVAL         NOVAL         "Word Aligner and Bitslip"                    "Number of valid data patterns required to achieve word alignment"              0                   0                   NOVAL                                                                             0                   "Intended to be used only for SRIO V2.1."}\
    {std_rx_word_aligner_fast_sync_status_enable  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable fast sync status reporting for deterministic latency SM"                1                   0                   NOVAL                                                                             0                   "If this parameter is selected, the word align status signal is asserted high once cycle slip operation between PCS and PMA is done. Otherwise the word align status is asserted after the cycle slip operation is done and it is detected that the word align pattern comes in aligned to the PCS. This parameter selection takes effect only if the selected protocol mode is CPRI (Auto)."}\
    {enable_port_rx_std_wa_patternalign           false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable rx_std_wa_patternalign port"                                            1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_wa_patternalign control input port. A rising edge on this signal causes the word aligner to align to the next incoming word alignment pattern when the word aligner is configured in \"manual\" mode."}\
    {enable_port_rx_std_wa_a1a2size               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable rx_std_wa_a1a2size port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_a1a2size control input port."}\
    {enable_port_rx_std_bitslipboundarysel        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable rx_std_bitslipboundarysel port"                                         1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_bitslipboundarysel status output port."}\
    {enable_port_rx_std_bitslip                   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Word Aligner and Bitslip"                    "Enable rx_bitslip port"                                                        1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_bitslip          1                   "Enables the optional rx_bitslip control input port. This is the shared RX bitslip control port for the Standard and Enhanced PCS datapaths."}\
    \
    {std_tx_bitrev_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable TX bit reversal"                                                        1                   0                   NOVAL                                                                             0                   "Enables transmitter bit order reversal. When enabled, the TX parallel data is reversed before passing to the PMA for serialization. When bit reversal is activated the transmitted TX data bit order changes to MSB->LSB rather than the normal LSB->MSB. This is a static setting and can only be dynamically changed through dynamic reconfiguration."}\
    {std_tx_byterev_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable TX byte reversal"                                                       1                   0                   NOVAL                                                                             0                   "Enables transmitter byte order reversal. When the PCS / PMA interface width is 16 or 20 bits the PCS can swap the ordering of the individual 8-bit or 10-bit words. This option is not valid under all protocol modes."}\
    {std_tx_polinv_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std                           l_enable_tx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable TX polarity inversion"                                                  1                   0                   NOVAL                                                                             0                   "Enables TX bit polarity inversion. When enabled, the 'tx_polinv' control port controls polarity inversion of the TX parallel data bits before passing to the PMA."}\
    {enable_port_tx_polinv                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable tx_polinv port"                                                         1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_polinv               0                   "Enables the optional tx_polinv control input port. When TX bit polarity inversion is enabled the assertion of this signal causes the TX bit polarity to be inverted."}\
    {std_rx_bitrev_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable RX bit reversal"                                                        1                   0                   NOVAL                                                                             0                   "Enables receiver bit order reversal. When enabled, the 'rx_std_bitrev_ena' control port controls bit reversal of the RX parallel data after passing from the PMA to the PCS. When bit reversal is activated the received RX data bit order changes to MSB->LSB rather than the normal LSB->MSB"}\
    {enable_port_rx_std_bitrev_ena                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable rx_std_bitrev_ena port"                                                 1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_bitrev_ena       0                   "Enables the optional rx_std_bitrev_ena control input port. When receiver bit order reversal is enabled the assertion of this signal causes the received RX data bit order to be changed to MSB->LSB rather than the normal LSB->MSB. This is an asynchronous input signal."}\
    {std_rx_byterev_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable RX byte reversal"                                                       1                   0                   NOVAL                                                                             0                   "Enables receiver byte order reversal. When the PCS / PMA interface width is 16 or 20 bits the PCS can swap the ordering of the individual 8- or 10-bit words. When enabled, the 'rx_std_byterev_ena' port controls byte swapping. This option is not valid under all protocol modes."}\
    {enable_port_rx_std_byterev_ena               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable rx_std_byterev_ena port"                                                1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_byterev_ena      0                   "Enables the optional rx_std_byterev_ena control input port. When receiver byte order reversal is enabled the assertion of this signal swaps the order of individual 8- or 10-bit words received from the PMA."}\
    {std_rx_polinv_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std                           l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable RX polarity inversion"                                                  1                   0                   NOVAL                                                                             0                   "Enables RX bit polarity inversion. When enabled, the 'rx_polinv' control port controls polarity inversion of the RX parallel data bits after passing from the PMA."}\
    {enable_port_rx_polinv                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable rx_polinv port"                                                         1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_polinv               0                   "Enables the optional rx_polinv control input port. When RX bit polarity inversion is enabled the assertion of this signal causes the RX bit polarity to be inverted."}\
    {enable_port_rx_std_signaldetect              false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "Bit Reversal and Polarity Inversion"         "Enable rx_std_signaldetect port"                                               1                   1                   NOVAL                                                                             0                   "Enables the optional rx_std_signaldetect status output port. The assertion of this signal indicates that a signal has been detected on the receiver. The signal detect threshold can be specified through Quartus QSF assignments."}\
    \
    {enable_ports_pipe_sw                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "PCIe Ports"                                  "Enable PCIe dynamic datarate switch ports"                                     1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_sw                0                   "Enables the pipe_rate; pipe_sw; and pipe_sw_done ports. These ports must be connected to the PLL IP instance in multi-lane PCI Express Gen 2 and Gen 3 configurations. The 'pipe_sw' and 'pipe_sw_done' ports are only exposed for multi-lane bonded configurations."}\
    {enable_ports_pipe_hclk                       false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "PCIe Ports"                                  "Enable PCIe pipe_hclk_in and pipe_hclk_out ports"                              1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_hclk              0                   "Enables the pipe_hclk_in and pipe_hclk_out ports. These ports must be connected to the PLL IP instance in PCI Express configurations."}\
    {enable_ports_pipe_g3_analog                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_std_iface                     l_enable_tx_std_iface                   boolean       NOVAL         "PCIe Ports"                                  "Enable PCIe Gen 3 analog control ports"                                        1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_g3_analog         0                   "Enables the pipe_g3_txdeemph and pipe_g3_rxpresethint ports. These ports are used to control the PMA in PCI Express Gen 3 configurations."}\
    {enable_ports_pipe_rx_elecidle                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "PCIe Ports"                                  "Enable PCIe electrical idle control and status ports"                          1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_rx_elecidle       0                   "Enables the pipe_rx_eidleinfersel and pipe_rx_elecidle ports. These ports are used for PCI Express configurations."}\
    {enable_port_pipe_rx_polarity                 false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_std_iface                     l_enable_rx_std_iface                   boolean       NOVAL         "PCIe Ports"                                  "Enable PCIe pipe_rx_polarity port"                                             1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_pipe_rx_polarity        0                   "Enables the pipe_rx_polarity input control port. This port controls channel signal polarity for PCI Express configurations. When the 'Standard PCS datapath' is configured for PCIe protocol modes, the assertion of this signal causes the RX bit polarity to be inverted. For other protocol modes the optional 'rx_polinv' port controls RX bit polarity inversion."}\
    \
    {enh_pcs_pma_width                            false   false         INTEGER   40                              {32 40 64}                                                                                                                                          enable_enh                                enable_enh                              NOVAL         NOVAL         "Enhanced PCS"                                "Enhanced PCS / PMA interface width"                                            1                   0                   NOVAL                                                                             0                   "Specifies the data interface width between the Enhanced PCS and the transceiver PMA."}\
    {enh_pld_pcs_width                            false   false         INTEGER   40                              {32 40 64 66 67}                                                                                                                                 enable_enh                                enable_enh                              NOVAL         NOVAL         "Enhanced PCS"                                "FPGA fabric / Enhanced PCS interface width"                                    1                   0                   NOVAL                                                                             0                   "Specifies the data interface width between the Enhanced PCS and the FPGA fabric."}\
    {enh_low_latency_enable                       false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_enh                                enable_enh                              boolean       NOVAL         "Enhanced PCS"                                "Enable 'Enhanced PCS' low latency mode"                                        1                   0                   NOVAL                                                                             0                   "Enables the low latency path for the 'Enhanced PCS'. Enabling this option bypasses the individual functional blocks within the 'Enhanced PCS' to provide the lowest latency datapath from the PMA through the 'Enhanced PCS'."}\
    {enh_rxtxfifo_double_width                    false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_enh                                enable_enh                              boolean       NOVAL         "Enhanced PCS"                                "Enable RX/TX FIFO double width mode"                                           1                   0                   NOVAL                                                                             0                   "Enables the double width mode for RX and TX FIFOs. Double width mode can be used to run the FPGA fabric at half clock speed."}\
    \
    {enh_txfifo_mode                              false   false         STRING    "Phase compensation"            {"Phase compensation" "Register" "Interlaken" "Basic" "Fast register"}                                                                              l_enable_tx_enh                           l_enable_tx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS TX FIFO"                        "TX FIFO mode"                                                                  1                   0                   NOVAL                                                                             0                   "Specifies the mode for the Enhanced PCS TX FIFO."}\
    {enh_txfifo_pfull                             false   false         INTEGER   11                              {0:15}                                                                                                                                              l_enable_tx_enh                           l_enable_tx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS TX FIFO"                        "TX FIFO partially full threshold"                                              1                   0                   NOVAL                                                                             0                   "Specifies the partially full threshold for the Enhanced PCS TX FIFO."}\
    {enh_txfifo_pempty                            false   false         INTEGER   2                               {0:15}                                                                                                                                              l_enable_tx_enh                           l_enable_tx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS TX FIFO"                        "TX FIFO partially empty threshold"                                             1                   0                   NOVAL                                                                             0                   "Specifies the partially empty threshold for the Enhanced PCS TX FIFO."}\
    {enable_port_tx_enh_fifo_full                 false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Enhanced PCS TX FIFO"                        "Enable tx_enh_fifo_full port"                                                  1                   1                   NOVAL                                                                             0                   "Enables the optional tx_enh_fifo_full status output port. This signal indicates when the TX FIFO has reached the specified full threshold."}\
    {enable_port_tx_enh_fifo_pfull                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Enhanced PCS TX FIFO"                        "Enable tx_enh_fifo_pfull port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional tx_enh_fifo_pfull status output port. This signal indicates when the TX FIFO has reached the specified partially full threshold."}\
    {enable_port_tx_enh_fifo_empty                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Enhanced PCS TX FIFO"                        "Enable tx_enh_fifo_empty port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional tx_enh_fifo_empty status output port. This signal indicates when the TX FIFO has reached the speciifed empty threshold."}\
    {enable_port_tx_enh_fifo_pempty               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Enhanced PCS TX FIFO"                        "Enable tx_enh_fifo_pempty port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional tx_enh_fifo_pempty status output port. This signal indicates when the TX FIFO has reached the specified partially empty threshold."}\
    {enable_port_tx_enh_fifo_cnt                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface   "l_enable_tx_enh_iface&&enable_advanced_options"          boolean       NOVAL         "Enhanced PCS TX FIFO"                        "Enable tx_enh_fifo_cnt port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional tx_enh_fifo_cnt status output port. This signal indicates the current level of the TX FIFO."}\
    \
    {enh_rxfifo_mode                              false   false         STRING    "Phase compensation"            {"Phase compensation" "Register" "Interlaken" "10GBase-R" "Basic"}                                                                                  l_enable_rx_enh                           l_enable_rx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS RX FIFO"                        "RX FIFO mode"                                                                  1                   0                   ::altera_xcvr_native_vi::parameters::validate_enh_rxfifo_mode                     0                   "Specifies the mode for the Enhanced PCS RX FIFO."}\
    {enh_rxfifo_pfull                             false   false         INTEGER   23                              {0:31}                                                                                                                                              l_enable_rx_enh                           l_enable_rx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS RX FIFO"                        "RX FIFO partially full threshold"                                              1                   0                   NOVAL                                                                             0                   "Specifies the partially full threshold for the Enhanced PCS RX FIFO."}\
    {enh_rxfifo_pempty                            false   false         INTEGER   2                               {0:31}                                                                                                                                              l_enable_rx_enh                           l_enable_rx_enh_iface                   NOVAL         NOVAL         "Enhanced PCS RX FIFO"                        "RX FIFO partially empty threshold"                                             1                   0                   NOVAL                                                                             0                   "Specifies the partially empty threshold for the Enhanced PCS RX FIFO."}\
    {enh_rxfifo_align_del                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable RX FIFO alignment word deletion (Interlaken)"                           1                   0                   NOVAL                                                                             0                   "Enables Interlaken alignment word (sync word) removal. When the Enhanced PCS RX FIFO is configured for Interlaken mode, enabling this option removes all alignment (sync) words once frame synchronization has occurred. This includes the first sync word. Enabling this option requires that you also enable control word deletion."}\
    {enh_rxfifo_control_del                       false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable RX FIFO control word deletion (Interlaken)"                             1                   0                   NOVAL                                                                             0                   "Enables Interlaken control word removal. When the Enhanced PCS RX FIFO is configured for Interlaken mode enabling this option removes all control words after frame synchronization has occurred. Enabling this option requires that you also enable alignment word deletion."}\
    {enable_port_rx_enh_data_valid                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_data_valid port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_data_valid status output port. This signal indicates when RX data from the RX FIFO is valid."}\
    {enable_port_rx_enh_fifo_full                 false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_full port"                                                  1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_full status output port. This signal indicates when the RX FIFO has reached the specified full threshold."}\
    {enable_port_rx_enh_fifo_pfull                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_pfull port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_pfull status output port. This signal indicates when the RX FIFO has reached the specified partially full threshold."}\
    {enable_port_rx_enh_fifo_empty                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_empty port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_empty status output port. This signal indicates when the RX FIFO has reached the speciifed empty threshold."}\
    {enable_port_rx_enh_fifo_pempty               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_pempty port"                                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_pempty status output port. This signal indicates when the RX FIFO has reached the specified partially empty threshold."}\
    {enable_port_rx_enh_fifo_cnt                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface   "l_enable_rx_enh_iface&&enable_advanced_options"          boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_cnt port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_cnt status output port. This signal the indicates the current level of the RX FIFO."}\
    {enable_port_rx_enh_fifo_del                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_del port (10GBASE-R)"                                       1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_del status output port. This signal indicates when a word has been deleted from the rate-match FIFO. This signal is used in 10GBASE-R mode only."}\
    {enable_port_rx_enh_fifo_insert               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_insert port (10GBASE-R)"                                    1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_insert status output port. This signal indicates when a word has been inserted into the rate-match FIFO. This signal is used in 10GBASE-R mode only."}\
    {enable_port_rx_enh_fifo_rd_en                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_rd_en port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_rd_en control input port. This port is used for Interlaken and Basic FIFO modes. Asserting this signal reads a word from the RX FIFO."}\
    {enable_port_rx_enh_fifo_align_val            false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_align_val port (Interlaken)"                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_align_val status output port. This port is used for Interlaken only."}\
    {enable_port_rx_enh_fifo_align_clr            false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Enhanced PCS RX FIFO"                        "Enable rx_enh_fifo_align_clr port (Interlaken)"                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_fifo_align_clr control input port. This port is used for Interlaken mode only."}\
    \
    {enh_tx_frmgen_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Frame Generator"                  "Enable Interlaken frame generator"                                             1                   0                   NOVAL                                                                             0                   "Enables the Interlaken frame generator in the Enhanced PCS."}\
    {enh_tx_frmgen_mfrm_length                    false   false         INTEGER   2048                            "0:8192"                                                                                                                                            l_enable_tx_enh                           l_enable_tx_enh_iface                   NOVAL         NOVAL         "Interlaken Frame Generator"                  "Frame generator metaframe length"                                              1                   0                   NOVAL                                                                             0                   "Specifies the Interlaken metaframe length for the frame generator."}\
    {enh_tx_frmgen_burst_enable                   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Frame Generator"                  "Enable frame generator burst control"                                          1                   0                   NOVAL                                                                             0                   "Enables burst control in the Interlaken frame generator. When enabled, the \"tx_enh_frame_burst_en\" port controls the burst behavior of the frame generator. Refer to the user guide for more details."}\
    {enable_port_tx_enh_frame                     false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Frame Generator"                  "Enable tx_enh_frame port"                                                      1                   1                   NOVAL                                                                             0                   "Enables the tx_enh_frame status output port. When the Interlaken frame generator is enabled this signal indicates the beginning of a new metaframe."}\
    {enable_port_tx_enh_frame_diag_status         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Frame Generator"                  "Enable tx_enh_frame_diag_status port"                                          1                   1                   NOVAL                                                                             0                   "Enables the tx_enh_frame_diag_status control input port. When the Interlaken frame generator is enabled the value of this signal contains the 'Status Message' from the framing layer 'Diagnostic Word'. Refer to the user guide for more details."}\
    {enable_port_tx_enh_frame_burst_en            false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Frame Generator"                  "Enable tx_enh_frame_burst_en port"                                             1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_enh_frame_burst_en   0                   "Enables the tx_enh_frame_burst_en control input port. When burst control is enabled for the Interlaken frame generator, the assertion of this signal controls frame generator data reads from the TX FIFO. Refer to the user guide for more details."}\
    \
    {enh_rx_frmsync_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken Frame Sync"                       "Enable Interlaken frame synchronizer"                                          1                   0                   NOVAL                                                                             0                   "Enables the Interlaken frame synchronizer in the Enhanced PCS."}\
    {enh_rx_frmsync_mfrm_length                   false   false         INTEGER   2048                            "0:8192"                                                                                                                                            l_enable_rx_enh                           l_enable_rx_enh_iface                   NOVAL         NOVAL         "Interlaken Frame Sync"                       "Frame synchronizer metaframe length"                                           1                   0                   NOVAL                                                                             0                   "Specifies the Interlaken metaframe length for the frame synchronizer."}\
    {enable_port_rx_enh_frame                     false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken Frame Sync"                       "Enable rx_enh_frame port"                                                      1                   1                   NOVAL                                                                             0                   "Enables the rx_enh_frame status output port. When the Interlaken frame synchronizer is enabled this signal indicates the beginning of a new metaframe."}\
    {enable_port_rx_enh_frame_lock                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken Frame Sync"                       "Enable rx_enh_frame_lock port"                                                 1                   1                   NOVAL                                                                             0                   "Enables the rx_enh_frame_lock status output port. When the Interlaken frame synchronizer is enabled the assertion of this signal indicates that the frame synchronizer has acheived metaframe delineation. This is an asynchronous output signal."}\
    {enable_port_rx_enh_frame_diag_status         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken Frame Sync"                       "Enable rx_enh_frame_diag_status port"                                          1                   1                   NOVAL                                                                             0                   "Enables the rx_enh_frame_diag_status status output port. When the Interlaken frame synchronizer is enabled This two-bit per lane output signal contains the value of the framing layer diagnostic word (bits\[33:32\]). This signal is latched when a valid diagnostic word is received."}\
    \
    {enh_tx_crcgen_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken CRC-32 Generator and Checker"     "Enable Interlaken TX CRC-32 generator"                                         1                   0                   NOVAL                                                                             0                   "Enables the Interlaken CRC-32 generator. This can be used as a dignostic tool. The CRC includes the entire metaframe including the diagnostic word."}\
    {enh_tx_crcerr_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken CRC-32 Generator and Checker"     "Enable Interlaken TX CRC-32 generator error insertion"                         1                   0                   NOVAL                                                                             0                   "Enables error insertion for the Interlaken CRC-32 generator. Error insertion is cycle-accurate. When enabled, the assertion of tx_control\[8\] inserts an error on that corresponding data word."}\
    {enh_rx_crcchk_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken CRC-32 Generator and Checker"     "Enable Interlaken RX CRC-32 checker"                                           1                   0                   NOVAL                                                                             0                   "Enables the Interlaken CRC-32 checker."}\
    {enable_port_rx_enh_crc32_err                 false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken CRC-32 Generator and Checker"     "Enable rx_enh_crc32_err port"                                                  1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_crc32_err status output port. When the Interlaken CRC-32 checker is enabled the assertion of this signal indicates the detection of a CRC error in the metaframe."}\
    \
    {enable_port_rx_enh_highber                   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "10GBASE-R BER Checker"                       "Enable rx_enh_highber port (10GBASE-R)"                                        1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_highber status output port. In 10GBASE-R mode the assertion of this signal indicates a bit-error rate higher then 10^-4. For the 10GBASE-R specification this occurs when there are at least 16 errors within 125us."}\
    {enable_port_rx_enh_highber_clr_cnt           false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "10GBASE-R BER Checker"                       "Enable rx_enh_highber_clr_cnt port (10GBASE-R)"                                1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_highber_clr_cnt control input port. In 10GBASE-R mode the assertion of this signal clears the internal counter for the number of times the BER state machine has entered the \"BER_BAD_SH\" state."}\
    {enable_port_rx_enh_clr_errblk_count          false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "10GBASE-R BER Checker"                       "Enable rx_enh_clr_errblk_count port (10GBASE-R & FEC)"                         1                   1                   NOVAL                                                                             0                   "Enables the optional rx_enh_clr_errblk_count control input port. In 10GBASE-R mode, the assertion of this signal clears the internal counter for the number of times the RX state machine has entered the \"RX_E\" state. In modes where the FEC block is enabled, the assertion of this signal resets the status counters within the RX FEC block."}\
    \
    {enh_tx_64b66b_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "64b/66b Encoder and Decoder"                 "Enable TX 64b/66b encoder"                                                     1                   0                   NOVAL                                                                             0                   "Enables the 64b/66b encoder."}\
    {enh_rx_64b66b_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "64b/66b Encoder and Decoder"                 "Enable RX 64b/66b decoder"                                                     1                   0                   NOVAL                                                                             0                   "Enables the 64b/66b decoder."}\
    {enh_tx_sh_err                                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "64b/66b Encoder and Decoder"                 "Enable TX sync header error insertion"                                         1                   0                   NOVAL                                                                             0                   "Enables 64b/66b sync header error insertion for 10GBASE-R or Interlaken."}\
    \
    {enh_tx_scram_enable                          false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Scrambler and Descrambler"                   "Enable TX scrambler (10GBASE-R/Interlaken)"                                    1                   0                   NOVAL                                                                             0                   "Enables the TX data scrambler for 10GBASE-R and Interlaken. Refer to the user guide for further details."}\
    {enh_tx_scram_seed                            false   false         LONG      0                               NOVAL                                                                                                                                               "l_enable_tx_enh && enh_tx_scram_enable"  l_enable_tx_enh_iface                   hexadecimal   NOVAL         "Scrambler and Descrambler"                   "TX scrambler seed (10GBASE-R/Interlaken)"                                      1                   0                   NOVAL                                                                             0                   "Specifies the initial seed for the 10GBASE-R / Interlaken scrambler."}\
    {enh_rx_descram_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Scrambler and Descrambler"                   "Enable RX descrambler (10GBASE-R/Interlaken)"                                  1                   0                   NOVAL                                                                             0                   "Enables the RX data descrambler for 10GBASE-R and Interlaken. Refer to the user guide for further details."}\
    \
    {enh_tx_dispgen_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Disparity Generator and Checker"  "Enable Interlaken TX disparity generator"                                      1                   0                   NOVAL                                                                             0                   "Enables the Interlaken disparity generator."}\
    {enh_rx_dispchk_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Interlaken Disparity Generator and Checker"  "Enable Interlaken RX disparity checker"                                        1                   0                   NOVAL                                                                             0                   "Enables the Interlaken disparity checker."}\
    {enh_tx_randomdispbit_enable                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Interlaken Disparity Generator and Checker"  "Enable Interlaken TX random disparity bit"                                     1                   0                   NOVAL                                                                             0                   "Enables the Interlaken random disparity bit. When enabled a random number is used as disparity bit which saves 1 cycle of latency."}\
    \
    {enh_rx_blksync_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Block Sync"                                  "Enable RX block synchronizer"                                                  1                   0                   NOVAL                                                                             0                   "Enables the block synchronizer for the 10G RX PCS. Primariliy used in Interlaken and 10GBASE-R modes."}\
    {enable_port_rx_enh_blk_lock                  false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Block Sync"                                  "Enable rx_enh_blk_lock port"                                                   1                   1                   NOVAL                                                                             0                   "Enables the optional enable_port_rx_enh_blk_lock status output port. When the block synchronizer is enabled the assertion of this signal indicates that block delineation has been achieved. This is an asynchronous output signal."}\
    \
    {enh_tx_bitslip_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable TX data bitslip"                                                        1                   0                   NOVAL                                                                             0                   "Enables TX bitslip support for the Enhanced TX PCS datapath. When enabled, the tx_enh_bitslip port controls the number of bit locations to slip the TX parallel data before passing to the PMA."}\
    {enh_tx_polinv_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable TX data polarity inversion"                                             1                   0                   NOVAL                                                                             0                   "Enables TX bit polarity inversion for the Enhanced TX PCS datapath. When enabled, the TX parallel data bits are inverted before passing to the PMA."}\
    {enh_rx_bitslip_enable                        false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable RX data bitslip"                                                        1                   0                   NOVAL                                                                             0                   "Enables RX bitslip support for the Enhanced RX PCS datapath. When enabled, the rising edge assertion of the rx_bitslip port causes the RX parallel data from the PMA to slip by one bit before passing to the PCS."}\
    {enh_rx_polinv_enable                         false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable RX data polarity inversion"                                             1                   0                   NOVAL                                                                             0                   "Enables RX bit polarity inversion for the Enhanced RX PCS datapath. When enabled, the RX parallel data bits are inverted before passing from the PMA to the PCS."}\
    {enable_port_tx_enh_bitslip                   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable tx_enh_bitslip port"                                                    1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_enh_bitslip          0                   "Enables the optional tx_enh_bitslip control input port. When TX bitslip support is enabled for the 10G PCS the value of this signal controls the number bit locations to slip the TX parallel data before passing to the PMA."}\
    {enable_port_rx_enh_bitslip                   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "Gearbox"                                     "Enable rx_bitslip port"                                                        1                   1                   ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_enh_bitslip          0                   "Enables the optional rx_bitslip control input port. When RX bitslip support is enabled for the 10G PCS; a rising edge on this signal causes the RX parallel data to be slipped by one bit location after passing from the PMA. This is the shared RX bitslip control port for the Standard and Enhanced PCS datapaths."}\
    \
    {enh_rx_krfec_err_mark_enable                 false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh                           l_enable_rx_enh_iface                   boolean       NOVAL         "KR-FEC"                                      "Enable RX KR-FEC error marking"                                                1                   0                   NOVAL                                                                             0                   "Enables the optional error marking feature of the KR-FEC decoder. When enabled, if an uncorrectable error is detected by the decoder, both sync data bits are asserted (2'b11) to indicate the uncorrectable error. This feature increases latency through the KR-FEC decoder."}\
    {enh_rx_krfec_err_mark_type                   false   false         STRING    "10G"                           {"10G" "40G"}                                                                                                                                       l_enable_rx_enh                           l_enable_rx_enh_iface                   NOVAL         NOVAL         "KR-FEC"                                      "Error marking type"                                                            1                   0                   NOVAL                                                                             0                   "Specifies the error marking type (10G or 40G)." }\
    {enh_tx_krfec_burst_err_enable                false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh                           l_enable_tx_enh_iface                   boolean       NOVAL         "KR-FEC"                                      "Enable KR-FEC TX error insertion"                                              1                   0                   NOVAL                                                                             0                   "Enables the optional error insertion feature of the KR-FEC encoder. This feature allows the user to insert errors by corrupting the data starting at bit 0 of the current word."}\
    {enh_tx_krfec_burst_err_len                   false   false         INTEGER   1                               {1:15}                                                                                                                                              l_enable_tx_enh                           l_enable_tx_enh_iface                   NOVAL         NOVAL         "KR-FEC"                                      "KR-FEC TX error insertion spacing"                                             1                   0                   NOVAL                                                                             0                   "Specifies the spacing of the KR-FEC TX error insertions. KR-FEC can insert 1-bit to 15-bit spaced errors."}\
    {enable_port_krfec_tx_enh_frame               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_tx_enh_iface                     l_enable_tx_enh_iface                   boolean       NOVAL         "KR-FEC"                                      "Enable tx_enh_frame port"                                                      1                   1                   NOVAL                                                                             0                   "Enables the tx_enh_frame status output port. Asynchronous status flag output of TX KRFEC that signifies the beginning of generated KRFEC frame."}\
    {enable_port_krfec_rx_enh_frame               false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "KR-FEC"                                      "Enable rx_enh_frame port"                                                      1                   1                   NOVAL                                                                             0                   "Enables the rx_enh_frame status output port. Asynchronous status flag output of RX KRFEC that signifies the beginning of a received KRFEC frame."}\
    {enable_port_krfec_rx_enh_frame_diag_status   false   false         INTEGER   0                               NOVAL                                                                                                                                               l_enable_rx_enh_iface                     l_enable_rx_enh_iface                   boolean       NOVAL         "KR-FEC"                                      "Enable rx_enh_frame_diag_status port"                                          1                   1                   NOVAL                                                                             0                   "Enables the rx_enh_frame_diag_status status output port. Asynchronous status flag output of RX KRFEC that indicates the status of the current received frame. 00: No error 01 Correctable error 10: Uncorrectable error 11: Reset condition/pre-lock condition."}\
    \
    {pcs_direct_width                             false   false         INTEGER   8                               {8 10 16 20 32 40 64}                                                                                                                               enable_pcs_dir                            enable_pcs_dir                          NOVAL         NOVAL         "PCS Direct Datapath"                         "PCS Direct interface width"                                                    1                   0                   NOVAL                                                                             0                   "Specifies the data interface width between the PLD and the transceiver PMA."}\
    \
    {generate_docs                                false   false         INTEGER   0                               NOVAL                                                                                                                                               true                                      true                                    boolean       NOVAL         "Generation Options"                          "Generate parameter documentation file"                                         0                   0                   NOVAL                                                                             0                   "When enabled, generation produces a Comma-Separated Value file (.csv) with descriptions of the Native PHY parameters."}\
    {generate_add_hdl_instance_example            false   false         INTEGER   0                               NOVAL                                                                                                                                               enable_advanced_options                   enable_advanced_options                 boolean       NOVAL         "Generation Options"                          "Generate '_hw.tcl' 'add_hdl_instance' example file"                            0                   0                   NOVAL                                                                             0                   "When enabled, generation produces a file containing an example of how to use the '_hw.tcl' 'add_hdl_instance' API. The example is correct for the current configuration of the Native PHY."}\
    \
    {validation_rule_select                       false   false         STRING    NOVAL                           NOVAL                                                                                                                                               enable_debug_options                      enable_debug_options                    NOVAL         NOVAL         "Parameter Validation Rules"                  "View validation rule for parameter"                                            0                   0                   NOVAL                                                                             0                   "Allows you to view the validation rule for the selected transceiver atom parameter."}\
    \
    {enable_advanced_options                      true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {enable_physical_bonding_clocks               true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   "Exposes bonding clock ports for switching between bonded PLLs."}\
    {enable_debug_options                         true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {enable_advanced_avmm_options                 true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {enable_odi_accelerator                       true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    \
    {l_channels                                   true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_channels                          0                   NOVAL}\
    {tx_enable                                    true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {datapath_select                              true    false         STRING    NOVAL                           NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {rx_enable                                    true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL                                                                             0                   NOVAL}\
    {l_split_iface                                true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_split_iface                       0                   NOVAL}\
    {l_pcs_pma_width                              true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_pcs_pma_width                     0                   NOVAL}\
    {l_tx_pld_pcs_width                           true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_tx_pld_pcs_width                  0                   NOVAL}\
    {l_rx_pld_pcs_width                           true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_rx_pld_pcs_width                  0                   NOVAL}\
    {l_pll_settings                               true    false         STRING    NOVAL                           NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_pll_settings                      0                   NOVAL}\
    {l_pll_settings_key                           true    false         STRING    NOVAL                           NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_pll_settings_key                  0                   NOVAL}\
    {l_enable_pma_bonding                         true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_pma_bonding                0                   NOVAL}\
    {l_enable_reve_support                        true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_reve_support               0                   NOVAL}\
	\
    {enable_std                                   true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_enable_std                          0                   NOVAL}\
    {l_enable_std_pipe                            true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_std_pipe                   0                   NOVAL}\
    {l_enable_tx_std                              true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_std                     0                   NOVAL}\
    {l_enable_rx_std                              true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_std                     0                   NOVAL}\
    {l_enable_tx_std_iface                        true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_std_iface               0                   NOVAL}\
    {l_enable_rx_std_iface                        true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_std_iface               0                   NOVAL}\
    {l_std_tx_word_count                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_tx_word_count                 0                   NOVAL}\
    {l_std_tx_word_width                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_tx_word_width                 0                   NOVAL}\
    {l_std_tx_field_width                         true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_tx_field_width                0                   NOVAL}\
    {l_std_rx_word_count                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_rx_word_count                 0                   NOVAL}\
    {l_std_rx_word_width                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_rx_word_width                 0                   NOVAL}\
    {l_std_rx_field_width                         true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_rx_field_width                0                   NOVAL}\
    {l_std_tx_pld_pcs_width                       true    false         INTEGER   NOVAL                           NOVAL                                                                                                                                               l_enable_tx_std                           false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_tx_pld_pcs_width              0                   NOVAL}\
    {l_std_rx_pld_pcs_width                       true    false         INTEGER   NOVAL                           NOVAL                                                                                                                                               l_enable_rx_std                           false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_rx_pld_pcs_width              0                   NOVAL}\
    {l_std_data_mask_count_multi                  true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_std_data_mask_count_multi         0                   NOVAL}\
    \
    {enable_enh                                   true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_enable_enh                          0                   NOVAL}\
    {l_enable_tx_enh                              true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_enh                     0                   NOVAL}\
    {l_enable_rx_enh                              true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_enh                     0                   NOVAL}\
    {l_enable_tx_enh_iface                        true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_enh_iface               0                   NOVAL}\
    {l_enable_rx_enh_iface                        true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_enh_iface               0                   NOVAL}\
    \
    {enable_pcs_dir                               true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_enable_pcs_dir                      0                   NOVAL}\
    {l_enable_tx_pcs_dir                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_pcs_dir                 0                   NOVAL}\
    {l_enable_rx_pcs_dir                          true    false         INTEGER   0                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_pcs_dir                 0                   NOVAL}\
    \
    {l_rcfg_ifaces                                true    false         INTEGER   1                               NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_rcfg_ifaces                       0                   NOVAL}\
    {l_rcfg_addr_bits                             true    false         INTEGER   10                              NOVAL                                                                                                                                               true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   ::altera_xcvr_native_vi::parameters::validate_l_rcfg_addr_bits                    0                   NOVAL}\
  }

  # Analog GUI parameters
  # All GUI params get the DEFAULT_VALUE and ALLOWED_RANGES from the Atom param (assigned during ip_declare) if they are not abstracted or restricted here.
  # For TX, most of the settings get their default values from the Analog Mode parameter update callback
  # For RX, there is no Analog Mode. Therefore, having meaningful default values here.
  set analog_parameters {\
    {NAME                                              DERIVED HDL_PARAMETER  TYPE      DEFAULT_VALUE                   ALLOWED_RANGES             ENABLED                                   VISIBLE                                 DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                                  DISPLAY_NAME                                                                    M_USED_FOR_RCFG     M_SAME_FOR_RCFG     M_CONTEXT     VALIDATION_CALLBACK                                                               M_ALWAYS_VALIDATE	  DESCRIPTION }\
    {enable_analog_settings                            false   false          INTEGER   0                               NOVAL                      rcfg_enable                               true                                    boolean       NOVAL         "Configuration Files"                         "Include PMA analog settings in configuration files"                            1                   1                   NOVAL         NOVAL                                                                             0                   "When enabled, the IP allows you to configure the analog settings for the PMA. These settings will be included in your generated configuration files. NOTE - You must still specify the analog settings for your current configuration using Quartus II Setting File (.qsf) assignments in Quartus. This option does not remove the requirement to specify Quartus II Setting File (.qsf) assignments for your analog settings."}\
    \
    {anlg_tx_analog_mode                               false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Analog Mode (Altera-recommended Default Setting Rules)"                        1                   0                   NOVAL         ::altera_xcvr_native_vi::parameters::validate_anlg_tx_analog_mode                 0                   "Selects the analog protocol mode rules to pre-select the TX pin swing settings (VOD, Pre-emphasis, and Slew Rate). After the pre-selected values get loaded in the GUI, if one or more of the individual TX pin swing settings need to be changed, then enable the option to override the Altera-recommended defaults to individually modify the settings."}\
    {anlg_enable_tx_default_ovr                        false   false          INTEGER   0                               NOVAL                      l_anlg_tx_enable                          true                                    boolean       NOVAL         "TX Analog PMA Settings"                      "Override Altera-recommended Analog Mode Default Settings"                      1                   0                   NOVAL         NOVAL                                                                             0                   "Enables the option to override the Altera-recommended settings for the selected TX Analog Mode for one or more TX analog parameters."}\
    {anlg_tx_vod_output_swing_ctrl                     false   false          INTEGER   NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Output Swing Level (VOD)"                                                      1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the transmitter programmable output differential voltage swing."}\
    {anlg_tx_pre_emp_sign_pre_tap_1t                   false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis First Pre-Tap Polarity"                                           1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the polarity of the first pre-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_switching_ctrl_pre_tap_1t         false   false          INTEGER   NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis First Pre-Tap Magnitude"                                          1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the magnitude of the first pre-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_sign_pre_tap_2t                   false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis Second Pre-Tap Polarity"                                          1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the polarity of the second pre-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_switching_ctrl_pre_tap_2t         false   false          INTEGER   NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis Second Pre-Tap Magnitude"                                         1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the magnitude of the second pre-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_sign_1st_post_tap                 false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis First Post-Tap Polarity"                                          1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the polarity of the first post-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_switching_ctrl_1st_post_tap       false   false          INTEGER   NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis First Post-Tap Magnitude"                                         1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the magnitude of the first post-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_sign_2nd_post_tap                 false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis Second Post-Tap Polarity"                                         1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the polarity of the second post-tap for pre-emphasis."}\
    {anlg_tx_pre_emp_switching_ctrl_2nd_post_tap       false   false          INTEGER   NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Pre-Emphasis Second Post-Tap Magnitude"                                        1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the magnitude of the second post-tap for pre-emphasis."}\
    {anlg_tx_slew_rate_ctrl                            false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "Slew Rate Control"                                                             1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the slew rate of the TX output signal. Valid values span from slowest to the fastest rate."}\
    {anlg_tx_compensation_en                           false   false          STRING    NOVAL                           NOVAL                      l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "High-Speed Compensation"                                                       1                   0                   NOVAL         NOVAL                                                                             0                   "Enables the power-distribution network (PDN) induced inter-symbol interference (ISI) compensation in the TX driver. When enabled, it reduces the PDN induced ISI jitter, but increases the power consumption."}\
    {anlg_tx_term_sel                                  false   false          STRING    "r_r1"                          {"r_r1" "r_r2"}            l_anlg_tx_enable                          true                                    NOVAL         NOVAL         "TX Analog PMA Settings"                      "On-Chip Termination"                                                           1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the on-chip RX differential termination."}\
    \
    {anlg_enable_rx_default_ovr                        false   false          INTEGER   0                               NOVAL                      l_anlg_rx_enable                          true                                    boolean       NOVAL         "RX Analog PMA Settings"                      "Override Altera-recommended Default Settings"                                  1                   0                   NOVAL         NOVAL                                                                             0                   "Enables the option to override the Altera-recommended settings for one or more RX analog parameters."}\
    {anlg_rx_one_stage_enable                          false   false          STRING    "s1_mode"                       NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "CTLE (Continuous Time Linear Equalizer) mode"                                  1                   0                   NOVAL         NOVAL                                                                             0                   "Selects between the RX high gain mode (non_s1_mode) or RX high data rate mode (s1_mode) for the Continuous Time Linear Equalizer (CTLE)."}\
    {anlg_rx_eq_dc_gain_trim                           false   false          STRING    "stg2_gain7"                    NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "DC Gain Control of High Gain Mode CTLE"                                        1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the DC gain of the Continuous Time Linear Equalizer (CTLE) in high gain mode."}\
    {anlg_rx_adp_ctle_acgain_4s                        false   false          STRING    "radp_ctle_acgain_4s_1"         NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "AC Gain Control of High Gain Mode CTLE"                                        1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the AC gain of the Continuous Time Linear Equalizer (CTLE) in high gain mode when CTLE is in manual mode."}\
    {anlg_rx_adp_ctle_eqz_1s_sel                       false   false          STRING    "radp_ctle_eqz_1s_sel_3"        NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "AC Gain Control of High Data Rate Mode CTLE"                                   1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the AC gain of the Continuous Time Linear Equalizer (CTLE) in high data rate mode when CTLE is in manual mode."}\
    {anlg_rx_adp_vga_sel                               false   false          STRING    "radp_vga_sel_2"                NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Variable Gain Amplifier (VGA) Voltage Swing Select"                            1                   0                   NOVAL         ::altera_xcvr_native_vi::parameters::validate_vga                                 0                   "Selects the Variable Gain Amplifier (VGA) output voltage swing when both the CTLE and DFE blocks are in manual mode."}\
    {anlg_rx_adp_dfe_fxtap1                            false   false          STRING    "radp_dfe_fxtap1_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 1 Co-efficient"                    1                   0                   1             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 1 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap2                            false   false          STRING    "radp_dfe_fxtap2_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 2 Co-efficient"                    1                   0                   2             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 2 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap3                            false   false          STRING    "radp_dfe_fxtap3_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 3 Co-efficient"                    1                   0                   3             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 3 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap4                            false   false          STRING    "radp_dfe_fxtap4_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 4 Co-efficient"                    1                   0                   4             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 4 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap5                            false   false          STRING    "radp_dfe_fxtap5_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 5 Co-efficient"                    1                   0                   5             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 5 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap6                            false   false          STRING    "radp_dfe_fxtap6_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 6 Co-efficient"                    1                   0                   6             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 6 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap7                            false   false          STRING    "radp_dfe_fxtap7_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 7 Co-efficient"                    1                   0                   7             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 7 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap8                            false   false          STRING    "radp_dfe_fxtap8_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 8 Co-efficient"                    1                   0                   8             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 8 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap9                            false   false          STRING    "radp_dfe_fxtap9_0"             NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 9 Co-efficient"                    1                   0                   9             ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 9 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap10                           false   false          STRING    "radp_dfe_fxtap10_0"            NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 10 Co-efficient"                   1                   0                   10            ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 10 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_adp_dfe_fxtap11                           false   false          STRING    "radp_dfe_fxtap11_0"            NOVAL                      l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "Decision Feedback Equalizer (DFE) Fixed Tap 11 Co-efficient"                   1                   0                   11            ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap               0                   "Selects the co-efficient of the fixed tap 11 of the Decision Feedback Equalizer (DFE) when operating in manual mode."}\
    {anlg_rx_term_sel                                  false   false          STRING    "r_r1"                          {"r_ext0" "r_r1" "r_r2"}   l_anlg_rx_enable                          true                                    NOVAL         NOVAL         "RX Analog PMA Settings"                      "On-Chip Termination"                                                           1                   0                   NOVAL         NOVAL                                                                             0                   "Selects the on-chip RX differential termination."}\
    \
    {l_anlg_tx_enable                                  true    false          INTEGER   0                               NOVAL                      true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL         ::altera_xcvr_native_vi::parameters::validate_l_anlg_tx_enable                    0                   NOVAL}\
    {l_anlg_rx_enable                                  true    false          INTEGER   0                               NOVAL                      true                                      false                                   NOVAL         NOVAL         NOVAL                                         NOVAL                                                                           0                   0                   NOVAL         ::altera_xcvr_native_vi::parameters::validate_l_anlg_rx_enable                    0                   NOVAL}\
  }
  
    set rcfg_parameters {
    {NAME                                   DERIVED HDL_PARAMETER TYPE        DEFAULT_VALUE             ALLOWED_RANGES      ENABLED                                                                   VISIBLE                   DISPLAY_HINT  DISPLAY_ITEM                  DISPLAY_NAME                                M_CONTEXT VALIDATION_CALLBACK                                                         M_ALWAYS_VALIDATE	DESCRIPTION }\
    {rcfg_enable                            false   true          INTEGER     0                         NOVAL               true                                                                      true                      boolean       "Dynamic Reconfiguration"     "Enable dynamic reconfiguration"            NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_enable                   0                   "Enables the dynamic reconfiguration interface." }\
    {rcfg_shared                            false   true          INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Dynamic Reconfiguration"     "Share reconfiguration interface"           NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_shared                   0                   "When enabled, the Native PHY presents a single Avalon-MM slave interface for dynamic reconfiguration of all channels. In this configuration the upper \[n:9\] address bits of the reconfiguration address bus specify the selected channel. Address bits \[8:0\] provide the register offset address within the reconfiguration space of the selected channel."}\
    {rcfg_jtag_enable                       false   true          INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Dynamic Reconfiguration"     "Enable Altera Debug Master Endpoint"       NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_jtag_enable              0                   "When enabled, the Native PHY includes an embedded Altera Debug Master Endpoint that connects internally Avalon-MM slave interface. The ADME can access the reconfiguration space of the transceiver. It can perform certain test and debug functions via JTAG using the System Console. This option requires you to enable the \"Share reconfiguration interface\" option for configurations using more than 1 channel and may also require that a jtag_debug link be included in the system."}\
    {rcfg_separate_avmm_busy                false   true          INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Dynamic Reconfiguration"     "Separate reconfig_waitrequest from the status of AVMM arbitration with PreSICE"  NOVAL  ::altera_xcvr_native_vi::parameters::validate_rcfg_separate_avmm_busy   0                   "When enabled, the reconfig_waitrequest will not indicate the status of AVMM arbitration with PreSICE.  The AVMM arbitration status will be reflected in a soft status register bit.  This feature requires that the \"Enable control and status registers\" feature under \"Optional Reconfiguration Logic\" be enabled.  For more information, please refer to the User Guide."}\
    {rcfg_enable_avmm_busy_port             false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               enable_advanced_avmm_options boolean    "Dynamic Reconfiguration"     "Enable avmm_busy port"                     NOVAL     NOVAL                                                                       0                   "Enable the port for avmm_busy"}\
    \
    {adme_prot_mode                         true    true          STRING      "basic_tx"                NOVAL               true                                                                      false                     NOVAL         NOVAL                         NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_adme_prot_mode                0                   NOVAL}\
    {adme_data_rate                         true    true          STRING      "5000000000"              NOVAL               true                                                                      false                     NOVAL         NOVAL                         NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_adme_data_rate                0                   NOVAL}\
    \
    {enable_pcie_dfe_ip                     false   true          BOOLEAN     0                         NOVAL               rcfg_enable                                                               enable_advanced_options   NOVAL     "Optional Reconfiguration Logic"  "Enable PICe DFE IP"                        NOVAL     NOVAL                                                                       0                   "Enable the DFE IP for the PCIe Protocol."}\
    {sim_reduced_counters                   false   true          BOOLEAN     0                         NOVAL               rcfg_enable                                                               enable_advanced_options   NOVAL     "Optional Reconfiguration Logic"  "Enable fast sim"                           NOVAL     NOVAL                                                                       0                   "Enables reduced counter values for simulation purposes.  Do not enable for compilation, as it will impact hardware."}\
    {disable_continuous_dfe                 false   true          BOOLEAN     0                         NOVAL               rcfg_enable                                                               enable_advanced_options   NOVAL     "Optional Reconfiguration Logic"  "Disable DFE Continuous"                    NOVAL     NOVAL                                                                       0                   "Disables continuous DFE mode."}\
    \
    {set_embedded_debug_enable              false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               false                     boolean   "Optional Reconfiguration Logic"  "Enable embedded debug"                     NOVAL     NOVAL                                                                       0                   "Enables the embedded debug logic in the transceiver channel and grants access to capability registers, soft prbs accumulators and control and status registers"}\
    {set_capability_reg_enable              false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean   "Optional Reconfiguration Logic"  "Enable capability registers"               NOVAL     ::altera_xcvr_native_vi::parameters::validate_set_capability_reg_enable     0                   "Enables capability registers, which provide high level information about the transceiver channel's configuration."}\
    {set_user_identifier                    false   false         INTEGER     0                         {0:255}             "set_capability_reg_enable&&rcfg_enable"                                  true                      NOVAL     "Optional Reconfiguration Logic"  "Set user-defined IP identifier"            NOVAL     NOVAL                                                                       0                   "Sets a user-defined numeric identifier that can be read from the user_identifer offset when the capability registers are enabled."}\
    {set_csr_soft_logic_enable              false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean   "Optional Reconfiguration Logic"  "Enable control and status registers"       NOVAL     ::altera_xcvr_native_vi::parameters::validate_set_csr_soft_logic_enable     0                   "Enables soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Signals include rx_is_locktoref, rx_is_locktodata, tx_cal_busy, rx_cal_busy, rx_serial_loopback, set_rx_locktodata, set_rx_locktoref, tx_analogreset, tx_digitalreset, rx_analogreset and rx_digitalreset. For more information, please refer to the User Guide."}\
    {set_prbs_soft_logic_enable             false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean   "Optional Reconfiguration Logic"  "Enable PRBS soft accumulators"             NOVAL     ::altera_xcvr_native_vi::parameters::validate_set_prbs_soft_logic_enable    0                   "Enables soft logic for doing prbs bit and error accumulation when using the hard prbs generator and checker."}\
    {set_odi_soft_logic_enable              false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               enable_odi_accelerator    boolean   "Optional Reconfiguration Logic"  "Enable ODI acceleration logic"             NOVAL     ::altera_xcvr_native_vi::parameters::validate_set_odi_soft_logic_enable     0                   "Enables soft logic for accelerating bit and error accumulation when using ODI."}\
    \
    {dbg_embedded_debug_enable              true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_embedded_debug_enable     0                   NOVAL}\
    {dbg_capability_reg_enable              true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_capability_reg_enable     0                   NOVAL}\
    {dbg_user_identifier                    true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_user_identifier           0                   NOVAL}\
    {dbg_stat_soft_logic_enable             true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_stat_soft_logic_enable    0                   NOVAL}\
    {dbg_ctrl_soft_logic_enable             true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_ctrl_soft_logic_enable    0                   NOVAL}\
    {dbg_prbs_soft_logic_enable             true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_prbs_soft_logic_enable    0                   NOVAL}\
    {dbg_odi_soft_logic_enable              true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_dbg_odi_soft_logic_enable     0                   NOVAL}\
    \
    {rcfg_file_prefix                       false   false         STRING      "altera_xcvr_native_a10"  NOVAL               rcfg_enable                                                               true                      NOVAL         "Configuration Files"         "Configuration file prefix"                 NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_file_prefix              0                   "Specifies the file prefix used for generating configuration files. Each variant of the Native PHY should use a unique prefix for configuration files."}\
    {rcfg_sv_file_enable                    false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Configuration Files"         "Generate SystemVerilog package file"       NOVAL     NOVAL                                                                       0                   "When enabled, The Native PHY generates a SystemVerilog package file, \"<rcfg_file_prefix>_reconfig_parameters.sv\", containing parameters defined with the attribute values needed for reconfiguration."}\
    {rcfg_h_file_enable                     false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Configuration Files"         "Generate C header file"                    NOVAL     NOVAL                                                                       0                   "When enabled, The Native PHY generates a C header file, \"<rcfg_file_prefix>_reconfig_parameters.h\", containing macros defined with the attribute values needed for reconfiguration."}\
    {rcfg_mif_file_enable                   false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Configuration Files"         "Generate MIF (Memory Initialization File)" NOVAL     NOVAL                                                                       0                   "When enabled, The Native PHY generates a MIF (Memory Initialization File), \"<rcfg_file_prefix>_reconfig_parameters.mif\", containing the attribute values needed for reconfiguration in a data format."}\
    \
    {rcfg_multi_enable                      false   false         INTEGER     0                         NOVAL               rcfg_enable                                                               true                      boolean       "Configuration Profiles"      "Enable multiple reconfiguration profiles"  NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_multi_enable             0                   "When enabled, you can use the GUI to store multiple configurations. This information is used by Quartus to include the necessary timing arcs for all configurations during timing driven compilation. The Native PHY generates reconfiguration files for all of the stored profiles. The Native PHY also checks your multiple reconfiguration profiles for consistency to ensure you can reconfigure between them. Among other things this checks that you have exposed the same ports for each configuration."}\
    {set_rcfg_emb_strm_enable               false   false         INTEGER     0                         NOVAL               "rcfg_enable&&rcfg_multi_enable"                                         true                      boolean       "Configuration Profiles"      "Enable embedded reconfiguration streamer"  NOVAL     ::altera_xcvr_native_vi::parameters::validate_set_rcfg_emb_strm_enable      0                   "Enables the embedded reconfiguration streamer, which automates the dynamic reconfiguration process between multiple predefined configuration profiles."}\
    {rcfg_emb_strm_enable                   true    true          INTEGER     0                         NOVAL               true                                                                      false                     NOVAL          NOVAL                        NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_emb_strm_enable          0                   NOVAL}\
    {rcfg_reduced_files_enable              false   false         INTEGER     0                         NOVAL               rcfg_multi_enable                                                         true                      boolean       "Configuration Profiles"      "Generate reduced reconfiguration files"    NOVAL     NOVAL                                                                       0                   "When enabled, The Native PHY generates reconfiguration report files containing only the attributes or RAM data that are different between the multiple configured profiles."}\
    {rcfg_profile_cnt                       false   true          INTEGER     2                         {1 2 3 4 5 6 7 8}   rcfg_multi_enable                                                         true                      NOVAL         "Configuration Profiles"      "Number of reconfiguration profiles"        NOVAL     NOVAL                                                                       0                   "Specifies the number of reconfiguration profiles to support when multiple reconfiguration profiles are enabled."}\
    {rcfg_profile_select                    false   false         INTEGER     1                         {1}                 rcfg_multi_enable                                                         true                      NOVAL         "Configuration Profiles"      "Selected reconfiguration profile"          NOVAL     ::altera_xcvr_native_vi::parameters::validate_rcfg_profile_select           0                   "Selects which reconfiguration profile to store when clicking the \"Store profile\" button."}\
    {rcfg_profile_data0                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data1                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data2                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data3                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data4                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data5                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data6                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_profile_data7                     false   false         STRING      ""                        NOVAL               false                                                                     true                      NOVAL         "Configuration Profile Data"  NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    \
    {rcfg_params                            true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    NOVAL                         NOVAL                                       NOVAL     NOVAL                                                                       0                   NOVAL}\
    {rcfg_param_labels                      true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "IP Parameters"                             NOVAL     NOVAL                                                                       1                   NOVAL}\
    {rcfg_param_vals0                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 0"                                 0         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals1                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 1"                                 1         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals2                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 2"                                 2         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals3                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 3"                                 3         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals4                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 4"                                 4         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals5                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 5"                                 5         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals6                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 6"                                 6         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    {rcfg_param_vals7                       true    false         STRING_LIST NOVAL                     NOVAL               false                                                                     false                     fixed_size    "Reconfiguration Parameters"  "Profile 7"                                 7         ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals               1                   NOVAL}\
    \
    {l_rcfg_datapath_message                true    false         INTEGER     0                         {0:1}               false                                                                     false                     NOVAL         NOVAL                         NOVAL                                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_l_rcfg_datapath_message       1                   "If user is reconfiguring between datapaths, checks if  rcfg_iface_enable is enable for all profiles"}\
  }

#[IS: NOTE for developers: M_AUTOSET->true M_AUTOWARN->false, all the rest NOVAL is the pattern used to silence unwanted warnings at the GUI]
#[IS: NOTE for developers: M_MAP_VALUES for datapath_select is set at ::declare_parameters function - for code reuse/share purposes]
#WARNING: DO NOT add M_RCFG_REPORT property in this mapping. It is handled in an algorithmic fashion in the ip_declare stage using the rcfg_report_filters_*

  set parameter_mappings {
    {NAME                                                     M_AUTOSET                                   M_AUTOWARN          M_MAPS_FROM                                                 M_MAP_DEFAULT             M_MAP_VALUES  } \
    {datapath_select                                          NOVAL                                       NOVAL               protocol_mode                                               NOVAL                     NOVAL} \
    {tx_enable                                                NOVAL                                       NOVAL               duplex_mode                                                 NOVAL                     {"duplex:1" "tx:1" "rx:0"}} \
    {rx_enable                                                NOVAL                                       NOVAL               duplex_mode                                                 NOVAL                     {"duplex:1" "tx:0" "rx:1"}} \
    {enable_analog_resets                                     NOVAL                                       NOVAL               set_disconnect_analog_resets                                NOVAL                     {"0:1" "1:0"}} \
    {enable_reset_sequence                                    NOVAL                                       NOVAL               set_disconnect_analog_resets                                NOVAL                     {"0:1" "1:0"}} \
    {cdr_pll_pma_width                                        false                                       false               l_pcs_pma_width                                             NOVAL                     NOVAL} \
    {cdr_pll_set_cdr_vco_speed                                true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_set_cdr_vco_speed_fix                            true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_chgpmp_current_pfd                               true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_chgpmp_current_pd                                true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_chgpmp_current_up_pd                             true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_chgpmp_current_dn_pd                             true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_lf_resistor_pfd                                  true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_lf_resistor_pd                                   true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {cdr_pll_pd_fastlock_mode                                 true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {hssi_10g_rx_pcs_clr_errblk_cnt_en                        !l_enable_rx_enh                            false               hssi_10g_rx_pcs_dec64b66b_clken                             NOVAL                     {"dec64b66b_clk_dis:disable" "dec64b66b_clk_en:enable"}} \
    {hssi_10g_tx_pcs_gb_tx_idwidth                            !l_enable_tx_enh                            false               enh_pld_pcs_width                                           NOVAL                     {"32:width_32" "40:width_40" "50:width_50" "64:width_64" "66:width_66" "67:width_67"}} \
    {hssi_10g_rx_pcs_gb_rx_odwidth                            !l_enable_rx_enh                            false               enh_pld_pcs_width                                           NOVAL                     {"32:width_32" "40:width_40" "50:width_50" "64:width_64" "66:width_66" "67:width_67"}} \
    {hssi_10g_tx_pcs_txfifo_mode                              !l_enable_tx_enh                            false               enh_txfifo_mode                                             NOVAL                     {"Phase compensation:phase_comp" "Register:register_mode" "Interlaken:interlaken_generic" "Basic:basic_generic" "Fast register:register_mode"}} \
    {hssi_10g_tx_pcs_txfifo_pfull                             !l_enable_tx_enh                            false               enh_txfifo_pfull                                            NOVAL                     NOVAL} \
    {hssi_10g_tx_pcs_txfifo_pempty                            !l_enable_tx_enh                            false               enh_txfifo_pempty                                           NOVAL                     NOVAL} \
    {hssi_10g_rx_pcs_rxfifo_mode                              !l_enable_rx_enh                            false               enh_rxfifo_mode                                             NOVAL                     {"Phase compensation:phase_comp" "Register:register_mode" "Interlaken:generic_interlaken" "10GBase-R:clk_comp_10g" "Basic:generic_basic" "Phase compensation (data_valid):phase_comp_dv"}} \
    {hssi_10g_rx_pcs_rxfifo_pfull                             !l_enable_rx_enh                            false               enh_rxfifo_pfull                                            NOVAL                     NOVAL} \
    {hssi_10g_rx_pcs_rxfifo_pempty                            !l_enable_rx_enh                            false               enh_rxfifo_pempty                                           NOVAL                     NOVAL} \
    {hssi_10g_rx_pcs_align_del                                !l_enable_rx_enh                            false               enh_rxfifo_align_del                                        NOVAL                     {"0:align_del_dis" "1:align_del_en"}}\
    {hssi_10g_rx_pcs_control_del                              !l_enable_rx_enh                            false               enh_rxfifo_control_del                                      NOVAL                     {"0:control_del_none" "1:control_del_all"}}\
    {hssi_10g_tx_pcs_frmgen_bypass                            !l_enable_tx_enh                            false               enh_tx_frmgen_enable                                        NOVAL                     {"0:frmgen_bypass_en" "1:frmgen_bypass_dis"}}\
    {hssi_10g_tx_pcs_frmgen_mfrm_length                       !l_enable_tx_enh                            false               enh_tx_frmgen_mfrm_length                                   NOVAL                     NOVAL} \
    {hssi_10g_tx_pcs_frmgen_burst                             !l_enable_tx_enh                            false               enh_tx_frmgen_burst_enable                                  NOVAL                     {"0:frmgen_burst_dis" "1:frmgen_burst_en"}}\
    {hssi_10g_rx_pcs_frmsync_bypass                           !l_enable_rx_enh                            false               enh_rx_frmsync_enable                                       NOVAL                     {"0:frmsync_bypass_en" "1:frmsync_bypass_dis"}}\
    {hssi_10g_rx_pcs_frmsync_mfrm_length                      !l_enable_rx_enh                            false               enh_rx_frmsync_mfrm_length                                  NOVAL                     NOVAL} \
    {hssi_10g_tx_pcs_sh_err                                   !l_enable_tx_enh                            false               enh_tx_sh_err                                               NOVAL                     {"0:sh_err_dis" "1:sh_err_en"}}\
    {hssi_10g_tx_pcs_crcgen_bypass                            !l_enable_tx_enh                            false               enh_tx_crcgen_enable                                        NOVAL                     {"0:crcgen_bypass_en" "1:crcgen_bypass_dis"}}\
    {hssi_10g_tx_pcs_crcgen_err                               !l_enable_tx_enh                            false               enh_tx_crcerr_enable                                        NOVAL                     {"0:crcgen_err_dis" "1:crcgen_err_en"}}\
    {hssi_10g_rx_pcs_crcchk_bypass                            !l_enable_rx_enh                            false               enh_rx_crcchk_enable                                        NOVAL                     {"0:crcchk_bypass_en" "1:crcchk_bypass_dis"}}\
    {hssi_10g_tx_pcs_enc_64b66b_txsm_bypass                   !l_enable_tx_enh                            false               enh_tx_64b66b_enable                                        NOVAL                     {"0:enc_64b66b_txsm_bypass_en" "1:enc_64b66b_txsm_bypass_dis"}}\
    {hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass                   !l_enable_rx_enh                            false               enh_rx_64b66b_enable                                        NOVAL                     {"0:dec_64b66b_rxsm_bypass_en" "1:dec_64b66b_rxsm_bypass_dis"}}\
    {hssi_10g_rx_pcs_descrm_bypass                            !l_enable_rx_enh                            false               enh_rx_descram_enable                                       NOVAL                     {"0:descrm_bypass_en" "1:descrm_bypass_dis"}}\
    {hssi_10g_tx_pcs_scrm_bypass                              !l_enable_tx_enh                            false               enh_tx_scram_enable                                         NOVAL                     {"0:scrm_bypass_en" "1:scrm_bypass_dis"}}\
    {hssi_10g_tx_pcs_pseudo_seed_a                            "!l_enable_tx_enh || !enh_tx_scram_enable"  false               enh_tx_scram_seed                                           NOVAL                     NOVAL} \
    {hssi_10g_tx_pcs_dispgen_bypass                           !l_enable_tx_enh                            false               enh_tx_dispgen_enable                                       NOVAL                     {"0:dispgen_bypass_en" "1:dispgen_bypass_dis"}}\
    {hssi_10g_rx_pcs_dispchk_bypass                           !l_enable_rx_enh                            false               enh_rx_dispchk_enable                                       NOVAL                     {"0:dispchk_bypass_en" "1:dispchk_bypass_dis"}}\
    {hssi_10g_tx_pcs_random_disp                              !l_enable_tx_enh                            false               enh_tx_randomdispbit_enable                                 NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_10g_rx_pcs_blksync_bypass                           !l_enable_rx_enh                            false               enh_rx_blksync_enable                                       NOVAL                     {"0:blksync_bypass_en" "1:blksync_bypass_dis"}}\
    {hssi_10g_tx_pcs_bitslip_en                               !l_enable_tx_enh                            false               enh_tx_bitslip_enable                                       NOVAL                     {"0:bitslip_dis" "1:bitslip_en"}}\
    {hssi_10g_rx_pcs_bitslip_mode                             !l_enable_rx_enh                            false               enh_rx_bitslip_enable                                       NOVAL                     {"0:bitslip_dis" "1:bitslip_en"}}\
    {hssi_10g_rx_pcs_fifo_stop_rd                             true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {hssi_10g_tx_pcs_fifo_double_write                        !l_enable_tx_enh                            false               enh_rxtxfifo_double_width                                   NOVAL                     {"0:fifo_double_write_dis" "1:fifo_double_write_en"}} \
    {hssi_10g_rx_pcs_fifo_double_read                         !l_enable_rx_enh                            false               enh_rxtxfifo_double_width                                   NOVAL                     {"0:fifo_double_read_dis" "1:fifo_double_read_en"}} \
    {hssi_10g_rx_pcs_dis_signal_ok                            !l_enable_rx_enh                            false               hssi_10g_rx_pcs_lpbk_mode                                   "dis_signal_ok_en"        {"lpbk_en:dis_signal_ok_dis"}} \
    {hssi_8g_tx_pcs_pcs_bypass                                !l_enable_tx_std                            false               std_low_latency_bypass_enable                               NOVAL                     {"0:dis_pcs_bypass" "1:en_pcs_bypass"}} \
    {hssi_8g_rx_pcs_pcs_bypass                                !l_enable_rx_std                            false               std_low_latency_bypass_enable                               NOVAL                     {"0:dis_pcs_bypass" "1:en_pcs_bypass"}} \
    {hssi_8g_tx_pcs_byte_serializer                           !l_enable_tx_std                            false               std_tx_byte_ser_mode                                        NOVAL                     {"Disabled:dis_bs" "Serialize x2:en_bs_by_2" "Serialize x4:en_bs_by_4"}} \
    {hssi_8g_rx_pcs_byte_deserializer                         !l_enable_rx_std                            false               std_rx_byte_deser_mode                                      NOVAL                     {"Disabled:dis_bds" "Deserialize x2:en_bds_by_2" "Deserialize x4:en_bds_by_4"}} \
    {hssi_8g_tx_pcs_eightb_tenb_encoder                       !l_enable_tx_std                            false               std_tx_8b10b_enable                                         NOVAL                     {"0:dis_8b10b" "1:en_8b10b_ibm"}} \
    {hssi_8g_rx_pcs_eightb_tenb_decoder                       !l_enable_rx_std                            false               std_rx_8b10b_enable                                         NOVAL                     {"0:dis_8b10b" "1:en_8b10b_ibm"}} \
    {hssi_8g_tx_pcs_eightb_tenb_disp_ctrl                     !l_enable_tx_std                            false               std_tx_8b10b_disp_ctrl_enable                               NOVAL                     {"0:dis_disp_ctrl" "1:en_disp_ctrl"}} \
    {hssi_8g_rx_pcs_rate_match                                !l_enable_rx_std                            false               std_rx_rmfifo_mode                                          NOVAL                     {"disabled:dis_rm" "basic (single width):sw_basic_rm" "basic (double width):dw_basic_rm" "gige:gige_rm" "pipe:pipe_rm" "pipe 0ppm:pipe_rm_0ppm"}} \
    {hssi_8g_rx_pcs_clkcmp_pattern_p                          !l_enable_rx_std                            false               std_rx_rmfifo_pattern_p                                     NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_clkcmp_pattern_n                          !l_enable_rx_std                            false               std_rx_rmfifo_pattern_n                                     NOVAL                     NOVAL} \
    {hssi_8g_tx_pcs_tx_bitslip                                !l_enable_tx_std                            false               std_tx_bitslip_enable                                       NOVAL                     {"0:dis_tx_bitslip" "1:en_tx_bitslip"}} \
    {hssi_8g_rx_pcs_wa_boundary_lock_ctrl                     !l_enable_rx_std                            false               std_rx_word_aligner_mode                                    NOVAL                     {"bitslip:bit_slip" "manual (PLD controlled):auto_align_pld_ctrl" "synchronous state machine:sync_sm" "deterministic latency:deterministic_latency"}} \
    {hssi_8g_rx_pcs_wa_pd_data                                !l_enable_rx_std                            false               std_rx_word_aligner_pattern                                 NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_wa_rknumber_data                          !l_enable_rx_std                            false               std_rx_word_aligner_rknumber                                NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_wa_renumber_data                          !l_enable_rx_std                            false               std_rx_word_aligner_renumber                                NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_wa_rgnumber_data                          !l_enable_rx_std                            false               std_rx_word_aligner_rgnumber                                NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_wa_rvnumber_data                          !l_enable_rx_std                            false               std_rx_word_aligner_rvnumber                                NOVAL                     NOVAL} \
    {hssi_8g_rx_pcs_wa_rosnumber_data                         !l_enable_rx_std                            false               hssi_8g_rx_pcs_wa_sync_sm_ctrl                              0                         {"gige_sync_sm:1"}} \
    {hssi_8g_rx_pcs_wa_disp_err_flag                          "!l_enable_rx_std || !std_rx_8b10b_enable"  false               std_rx_8b10b_enable                                         NOVAL                     {"0:dis_disp_err_flag" "1:en_disp_err_flag"}} \
    {hssi_8g_tx_pcs_bit_reversal                              !l_enable_tx_std                            false               std_tx_bitrev_enable                                        NOVAL                     {"0:dis_bit_reversal" "1:en_bit_reversal"}} \
    {hssi_8g_tx_pcs_symbol_swap                               !l_enable_tx_std                            false               std_tx_byterev_enable                                       NOVAL                     {"0:dis_symbol_swap" "1:en_symbol_swap"}} \
    {hssi_8g_rx_pcs_bit_reversal                              !l_enable_rx_std                            false               std_rx_bitrev_enable                                        NOVAL                     {"0:dis_bit_reversal" "1:en_bit_reversal"}} \
    {hssi_8g_rx_pcs_symbol_swap                               !l_enable_rx_std                            false               std_rx_byterev_enable                                       NOVAL                     {"0:dis_symbol_swap" "1:en_symbol_swap"}} \
    {hssi_8g_rx_pcs_auto_error_replacement                    !l_enable_rx_std                            false               hssi_8g_rx_pcs_prot_mode                                    dis_err_replace           {"pipe_g1:en_err_replace" "pipe_g2:en_err_replace" "pipe_g3:en_err_replace"}} \
    {hssi_common_pcs_pma_interface_ppmsel                     false                                       false               rx_ppm_detect_threshold                                     NOVAL                     {"62.5:ppmsel_62p5" "100:ppmsel_100" "125:ppmsel_125" "200:ppmsel_200" "250:ppmsel_250" "300:ppmsel_300" "500:ppmsel_500" "1000:ppmsel_1000" "2500:ppmsel_2500" "5000:ppmsel_5000"}} \
    {hssi_common_pcs_pma_interface_data_mask_count_multi      "!l_enable_reve_support&&!enable_pcie_data_mask_option"                      false               l_std_data_mask_count_multi                                 NOVAL                     NOVAL} \
    {hssi_common_pcs_pma_interface_bypass_pma_sw_done         true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {hssi_gen3_rx_pcs_rate_match_fifo                         !l_enable_rx_std                            false               pcie_rate_match                                             NOVAL                     {"Bypass:bypass_rm_fifo" "0 ppm:enable_rm_fifo_0ppm" "600 ppm:enable_rm_fifo_600ppm"}} \
    {hssi_krfec_rx_pcs_error_marking_en                       !l_enable_rx_enh                            false               enh_rx_krfec_err_mark_enable                                NOVAL                     {"0:err_mark_dis" "1:err_mark_en"}} \
    {hssi_krfec_rx_pcs_err_mark_type                          !l_enable_rx_enh                            false               enh_rx_krfec_err_mark_type                                  NOVAL                     {"10G:err_mark_10g" "40G:err_mark_40g"}} \
    {hssi_krfec_tx_pcs_burst_err                              !l_enable_tx_enh                            false               enh_tx_krfec_burst_err_enable                               NOVAL                     {"0:burst_err_dis" "1:burst_err_en"} } \
    {hssi_krfec_tx_pcs_burst_err_len                          !l_enable_tx_enh                            false               enh_tx_krfec_burst_err_len                                  "burst_err_len1"          {"1:burst_err_len1" "2:burst_err_len2" "3:burst_err_len3" "4:burst_err_len4" "5:burst_err_len5" "6:burst_err_len6" "7:burst_err_len7" "8:burst_err_len8" "9:burst_err_len9" "10:burst_err_len10" "11:burst_err_len11" "12:burst_err_len12" "13:burst_err_len13" "14:burst_err_len14" "15:burst_err_len15"} } \
    {hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion      !l_enable_rx_std                            false               std_rx_polinv_enable                                        NOVAL                     {"0:rx_dyn_polinv_dis" "1:rx_dyn_polinv_en"}} \
    {hssi_rx_pcs_pma_interface_rx_static_polarity_inversion   !l_enable_rx_enh                            false               enh_rx_polinv_enable                                        NOVAL                     {"0:rx_stat_polinv_dis" "1:rx_stat_polinv_en"}} \
    {hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion      !l_enable_tx_std                            false               std_tx_polinv_enable                                        NOVAL                     {"0:tx_dyn_polinv_dis" "1:tx_dyn_polinv_en"}} \
    {hssi_tx_pcs_pma_interface_tx_static_polarity_inversion   !l_enable_tx_enh                            false               enh_tx_polinv_enable                                        NOVAL                     {"0:tx_stat_polinv_dis" "1:tx_stat_polinv_en"}} \
    {hssi_tx_pld_pcs_interface_pcs_tx_clk_out_sel             !tx_enable                                  false               datapath_select                                             teng_clk_out              {"PCS Direct:pma_tx_clk" "Standard:eightg_clk_out" "Enhanced:teng_clk_out"}}\
    {hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel             !rx_enable                                  false               datapath_select                                             teng_clk_out              {"PCS Direct:pma_rx_clk" "Standard:eightg_clk_out" "Enhanced:teng_clk_out"}}\
    {hssi_tx_pld_pcs_interface_hd_chnl_hip_en                 false                                       false               enable_hip                                                  NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_rx_pld_pcs_interface_hd_chnl_hip_en                 false                                       false               enable_hip                                                  NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_rx_pld_pcs_interface_hd_8g_hip_mode                 false                                       false               enable_hip                                                  NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_tx_pld_pcs_interface_hd_chnl_hrdrstctl_en           false                                       false               enable_hard_reset                                           NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_tx_pld_pcs_interface_hd_10g_low_latency_en_tx       !l_enable_tx_enh                            false               enh_low_latency_enable                                      NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx       !l_enable_rx_enh                            false               enh_low_latency_enable                                      NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx      !l_enable_tx_enh                            false               enh_low_latency_enable                                      NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx      !l_enable_rx_enh                            false               enh_low_latency_enable                                      NOVAL                     {"0:disable" "1:enable"}} \
    {hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx             false                                       false               hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx                 NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx             false                                       false               hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx                 NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_10g_pma_dw_tx               !l_enable_tx_enh                            false               enh_pcs_pma_width                                           NOVAL                     {"32:pma_32b_tx" "40:pma_40b_tx" "64:pma_64b_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx               !l_enable_rx_enh                            false               enh_pcs_pma_width                                           NOVAL                     {"32:pma_32b_rx" "40:pma_40b_rx" "64:pma_64b_rx"}} \
    {hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx                !l_enable_tx_std                            false               std_pcs_pma_width                                           NOVAL                     {"8:pma_8b_tx" "10:pma_10b_tx" "16:pma_16b_tx" "20:pma_20b_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx                !l_enable_rx_std                            false               std_pcs_pma_width                                           NOVAL                     {"8:pma_8b_rx" "10:pma_10b_rx" "16:pma_16b_rx" "20:pma_20b_rx"}} \
    {hssi_8g_tx_pcs_pma_dw                                    !l_enable_tx_std                            false               std_pcs_pma_width                                           NOVAL                     {"8:eight_bit" "10:ten_bit" "16:sixteen_bit" "20:twenty_bit"}} \
    {hssi_8g_rx_pcs_pma_dw                                    !l_enable_rx_std                            false               std_pcs_pma_width                                           NOVAL                     {"8:eight_bit" "10:ten_bit" "16:sixteen_bit" "20:twenty_bit"}} \
    {hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx             !l_enable_tx_std                            false               std_tx_pcfifo_mode                                          NOVAL                     {"low_latency:fifo_tx" "register_fifo:reg_tx" "fast_register:fastreg_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx             !l_enable_rx_std                            false               std_rx_pcfifo_mode                                          NOVAL                     {"low_latency:fifo_rx" "register_fifo:reg_rx"}} \
    {hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx            !l_enable_tx_enh                            false               enh_txfifo_mode                                             NOVAL                     {"Phase compensation:fifo_tx" "Register:reg_tx" "Interlaken:fifo_tx" "Basic:fifo_tx" "Fast register:fastreg_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx            !l_enable_rx_enh                            false               enh_rxfifo_mode                                             NOVAL                     {"Phase compensation:fifo_rx" "Register:reg_rx" "Interlaken:fifo_rx" "10GBase-R:fifo_rx" "Basic:fifo_rx"}} \
    {hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx   !l_enable_tx_enh                            false               enh_rxtxfifo_double_width                                   NOVAL                     {"0:single_tx" "1:double_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx   !l_enable_rx_enh                            false               enh_rxtxfifo_double_width                                   NOVAL                     {"0:single_rx" "1:double_rx"}} \
    {hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode         true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode           true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_chnl_speed_grade            false                                       false               pcs_speedgrade                                              "e2"                      NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_chnl_speed_grade            false                                       false               pcs_speedgrade                                              "e2"                      NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz          !tx_enable                                  false               pma_tx_buf_xtx_path_pma_tx_divclk_hz                        NOVAL                     NOVAL } \
    {hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz          !rx_enable                                  false               pma_rx_buf_xrx_path_pma_rx_divclk_hz                        NOVAL                     NOVAL } \
    {hssi_tx_pld_pcs_interface_hd_10g_advanced_user_mode_tx   false                                       false               hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx               "disable"                 {"interlaken_mode_tx:enable"} } \
    {hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx   false                                       false               hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx               "disable"                 {"interlaken_mode_rx:disable"} } \
    {hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx     !rx_enable                                  false               enable_transparent_pcs                                      "disable"                 {"0:disable" "1:enable"} }\
    {hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en                !tx_enable                                  false               enable_parallel_loopback                                    "disable"                 {"0:disable" "1:enable"} }\
    {hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en                !rx_enable                                  false               enable_parallel_loopback                                    "disable"                 {"0:disable" "1:enable"} }\
    {pma_adapt_adp_onetime_dfe                                true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_cdr_refclk_refclk_select                             false                                       false               cdr_refclk_select                                           NOVAL                     {"0:ref_iqclk0" "1:ref_iqclk1" "2:ref_iqclk2" "3:ref_iqclk3" "4:ref_iqclk4"}} \    
    {pma_cgb_x1_div_m_sel                                     false                                       false               tx_pma_clk_div                                              NOVAL                     {"1:divbypass" "2:divby2" "4:divby4" "8:divby8"}} \
    {pma_cgb_input_select_xn                                  false                                       false               bonded_mode                                                 NOVAL                     {"not_bonded:unused" "pma_only:sel_x6_dn" "pma_pcs:sel_x6_dn"}} \
    {pma_tx_buf_xtx_path_bonding_mode                         false                                       false               bonded_mode                                                 NOVAL                     {"not_bonded:x1_non_bonded" "pma_only:x6_xn_bonded" "pma_pcs:x6_xn_bonded"}} \
    {pma_tx_buf_xtx_path_clock_divider_ratio                  false                                       false               tx_pma_clk_div                                              NOVAL                     NOVAL} \
    {pma_tx_buf_xtx_path_datawidth                            false                                       false               l_pcs_pma_width                                             NOVAL                     NOVAL} \
    {pma_rx_buf_xrx_path_datawidth                            false                                       false               l_pcs_pma_width                                             NOVAL                     NOVAL} \
    {pma_tx_buf_xtx_path_prot_mode                            false                                       false               l_protocol_mode                                             "basic_tx"                {"pipe_g1:pcie_gen1_tx" "pipe_g2:pcie_gen2_tx" "pipe_g3:pcie_gen3_tx" "sata:sata_tx" "gpon:gpon_tx" "qpi:qpi_tx"}} \
    {pma_rx_buf_xrx_path_prot_mode                            false                                       false               l_protocol_mode                                             "basic_rx"                {"pipe_g1:pcie_gen1_rx" "pipe_g2:pcie_gen2_rx" "pipe_g3:pcie_gen3_rx" "sata:sata_rx" "gpon:gpon_rx" "qpi:qpi_rx"}} \
    {pma_tx_buf_xtx_path_datarate                             !tx_enable                                  false               data_rate_bps                                               NOVAL                     NOVAL} \
    {pma_rx_buf_xrx_path_datarate                             !rx_enable                                  false               data_rate_bps                                               NOVAL                     NOVAL} \
    {pma_tx_buf_pm_speed_grade                                false                                       false               pma_speedgrade                                              "e2"                      NOVAL} \
    {pma_rx_buf_pm_speed_grade                                false                                       false               pma_speedgrade                                              "e2"                      NOVAL} \
    {cdr_pll_pm_speed_grade                                   false                                       false               pma_speedgrade                                              "e2"                      NOVAL} \
    \
    {hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx  !tx_enable                                  false               bonded_mode                                                 NOVAL                     {"not_bonded:individual_tx" "pma_only:individual_tx" "pma_pcs:ctrl_master_tx"}}\
    {hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx   !l_enable_tx_enh                            false               bonded_mode                                                 NOVAL                     {"not_bonded:individual_tx" "pma_only:individual_tx" "pma_pcs:ctrl_master_tx"}}\
    {hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx    !l_enable_tx_std                            false               bonded_mode                                                 NOVAL                     {"not_bonded:individual_tx" "pma_only:individual_tx" "pma_pcs:ctrl_master_tx"}}\
    {hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode false                                       false               duplex_mode                                                 NOVAL                     {"rx:tx_rx_independent" "tx:tx_rx_independent" "duplex:tx_rx_pair_enabled"}} \
    {hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode false                                       false               duplex_mode                                                 NOVAL                     {"rx:tx_rx_independent" "tx:tx_rx_independent" "duplex:tx_rx_pair_enabled"}} \
    {hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx           false                                       false               protocol_mode                                               NOVAL                     {"disabled:disabled_prot_mode_tx" "basic_std:basic_8gpcs_tx"            "basic_std_rm:basic_8gpcs_tx"           "cpri:cpri_8b10b_tx" "cpri_rx_tx:cpri_8b10b_tx" "gige:gige_tx" "gige_1588:gige_1588_tx" "pipe_g1:pcie_g1_capable_tx" "pipe_g2:pcie_g2_capable_tx" "pipe_g3:pcie_g3_capable_tx" "basic_enh:basic_10gpcs_tx" "interlaken_mode:interlaken_tx" "sfis_mode:sfis_tx" "teng_sdi_mode:teng_sdi_tx" "teng_baser_mode:teng_baser_tx" "teng_1588_mode:teng_1588_baser_tx" "teng_baser_krfec_mode:teng_basekr_krfec_tx" "basic_krfec_mode:basic_10gpcs_krfec_tx" "teng_1588_krfec_mode:teng_1588_basekr_krfec_tx" "fortyg_basekr_krfec_mode:fortyg_basekr_krfec_tx" "prp_krfec_mode:prp_krfec_tx" "prp_mode:prp_tx" "pcs_direct:pcs_direct_tx" "prbs:prbs_tx" "sqwave:sqwave_tx" "uhsif:uhsif_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx           false                                       false               protocol_mode                                               NOVAL                     {"disabled:disabled_prot_mode_rx" "basic_std:basic_8gpcs_rm_disable_rx" "basic_std_rm:basic_8gpcs_rm_enable_rx" "cpri:cpri_8b10b_rx" "cpri_rx_tx:cpri_8b10b_rx" "gige:gige_rx" "gige_1588:gige_1588_rx" "pipe_g1:pcie_g1_capable_rx" "pipe_g2:pcie_g2_capable_rx" "pipe_g3:pcie_g3_capable_rx" "basic_enh:basic_10gpcs_rx" "interlaken_mode:interlaken_rx" "sfis_mode:sfis_rx" "teng_sdi_mode:teng_sdi_rx" "teng_baser_mode:teng_baser_rx" "teng_1588_mode:teng_1588_baser_rx" "teng_baser_krfec_mode:teng_basekr_krfec_rx" "basic_krfec_mode:basic_10gpcs_krfec_rx" "teng_1588_krfec_mode:teng_1588_basekr_krfec_rx" "fortyg_basekr_krfec_mode:fortyg_basekr_krfec_rx" "prp_krfec_mode:prp_krfec_rx" "prp_mode:prp_rx" "pcs_direct:pcs_direct_rx" "prbs:prbs_rx"}} \
    {hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx             false                                       false               protocol_mode                                               disabled_prot_mode_tx     {"disabled:disabled_prot_mode_tx" "basic_std:basic_tx"            "basic_std_rm:basic_tx"           "cpri:cpri_tx" "cpri_rx_tx:cpri_rx_tx_tx" "gige:gige_tx" "gige_1588:gige_1588_tx" "pipe_g1:pipe_g1_tx" "pipe_g2:pipe_g2_tx" "pipe_g3:pipe_g3_tx"}} \
    {hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx             false                                       false               protocol_mode                                               disabled_prot_mode_rx     {"disabled:disabled_prot_mode_rx" "basic_std:basic_rm_disable_rx" "basic_std_rm:basic_rm_enable_rx" "cpri:cpri_rx" "cpri_rx_tx:cpri_rx_tx_rx" "gige:gige_rx" "gige_1588:gige_1588_rx" "pipe_g1:pipe_g1_rx" "pipe_g2:pipe_g2_rx" "pipe_g3:pipe_g3_rx"}} \
    \
    {hssi_rx_pld_pcs_interface_hd_chnl_sup_mode               false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_fifo_sup_mode               false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_10g_sup_mode                false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_8g_sup_mode                 false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_g3_sup_mode                 false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_krfec_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_rx_pld_pcs_interface_hd_pldif_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_chnl_sup_mode               false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_fifo_sup_mode               false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_10g_sup_mode                false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_8g_sup_mode                 false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_g3_sup_mode                 false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_krfec_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {hssi_tx_pld_pcs_interface_hd_pldif_sup_mode              false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {cdr_pll_sup_mode                                         false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_odi_sup_mode                                      false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_buf_sup_mode                                      false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_buf_xrx_path_sup_mode                             false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_tx_buf_xtx_path_sup_mode                             false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_deser_sup_mode                                    false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_adapt_sup_mode                                       false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_dfe_sup_mode                                      false                                       false               support_mode                                                NOVAL                     NOVAL} \
    {pma_rx_sd_sup_mode                                       false                                       false               support_mode                                                NOVAL                     NOVAL} \
    \
    {pma_adapt_adp_1s_ctle_bypass                             true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_4s_ctle_bypass                             true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_ctle_en                                    true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_dfe_fltap_bypass                           true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_dfe_fxtap_en                               true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_dfe_fltap_en                               true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_dfe_fxtap_bypass                           true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_dfe_fxtap_hold_en                          true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_vga_bypass                                 true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_vga_en                                     true                                        false               NOVAL                                                       NOVAL                     NOVAL} \     
    {pma_adapt_adp_vref_bypass                                true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_vref_en                                    true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_adapt_adp_ctle_adapt_cycle_window                    true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
    {pma_rx_buf_vcm_sel                                       true                                        false               NOVAL                                                       NOVAL                     NOVAL} \
  }

# Mapping between GUI and Atom parameters for all the analog parameters
# M_ANALOG           - used during parameter declaration to do specific assignments/overrides for analog parameters 
# M_RCFG_REPORT_TEMP - used as a placeholder to decide the final value of M_RCFG_REPORT in the ip_declare phase
# M_QSF              - not used currently. Intended to indicate QSF assignments and generate sample QSF
# M_QSF_NAME         - hardcoded here from user QSF doc. Ideally, it should be automated from BCM table to TCL. 
# "Optimal" settings
#     Optimal=true => default setting for PMA attributes. Optimal=false => open with expectation of user setting it.
#     -> If the user did not enable the analog settings checkbox => set the default as "true" so that the default values get properly resolved without warnings from RBC
#     -> If the user enabled the analog settings checkbox        => set the default as "true" unless the user checks the "override" checkbox. Every QSF has an "optimal" (or Altera-recommended default) value
#          --> if the user enabled "override" checkbox           => set optimal as "false" 
#     -> M_ANALOG is set to NOVAL for optimal parameters as this is not a QSF setting that we need to find dependents for all by itself.
# M_AUTOWARN         - set to "false" for all the underlying parameters as when AUTOSET is enagaged (when the analog option is not enabled, no need to report warnings from RBC as the settings are not used anywhere). 
#                    - this prevents the need for the user to go uncheck "Override" option and then go back to disable "Analog settings" option if they don't need this feature. 
#                    - When AUTOSET is false (user entering values), then AUTOWARN has not effect according to RBC style
# WARNING: DO NOT add M_RCFG_REPORT property in this mapping. It is handled in an algorithmic fashion in the ip_declare stage using the rcfg_report_filters_* using the temporary flad M_RCFG_REPORT_TEMP below
  set analog_parameter_mappings {
    {NAME                                                     M_ANALOG    M_QSF_NAME                                        M_RCFG_REPORT_TEMP  M_AUTOSET                  M_AUTOWARN    M_MAPS_FROM                                      M_MAP_DEFAULT    M_MAP_VALUES                                             VALIDATION_CALLBACK} \
    {pma_tx_buf_power_mode                                    1           XCVR_VCCR_VCCT_VOLTAGE                            l_anlg_tx_enable    false                      NOVAL         anlg_voltage                                     NOVAL            {"1_1V:high_perf" "1_0V:mid_power" "0_9V:low_power"}     ::altera_xcvr_native_vi::parameters::validate_pma_power_mode} \
    {pma_tx_buf_link                                          1           XCVR_A10_TX_LINK                                  l_anlg_tx_enable    false                      NOVAL         anlg_link                                        NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_link_tx                                       1           NOVAL                                             l_anlg_tx_enable    false                      NOVAL         anlg_link                                        NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_xtx_path_analog_mode                          1           XCVR_A10_TX_XTX_PATH_ANALOG_MODE                  l_anlg_tx_enable    false                      NOVAL         anlg_tx_analog_mode                              NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_vod_output_swing_ctrl                         1           XCVR_A10_TX_VOD_OUTPUT_SWING_CTRL                 l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_vod_output_swing_ctrl                    NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_sign_pre_tap_1t                       1           XCVR_A10_TX_PRE_EMP_SIGN_PRE_TAP_1T               l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_sign_pre_tap_1t                  NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_switching_ctrl_pre_tap_1t             1           XCVR_A10_TX_PRE_EMP_SWITCHING_CTRL_PRE_TAP_1T     l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_switching_ctrl_pre_tap_1t        NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_sign_pre_tap_2t                       1           XCVR_A10_TX_PRE_EMP_SIGN_PRE_TAP_2T               l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_sign_pre_tap_2t                  NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_switching_ctrl_pre_tap_2t             1           XCVR_A10_TX_PRE_EMP_SWITCHING_CTRL_PRE_TAP_2T     l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_switching_ctrl_pre_tap_2t        NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_sign_1st_post_tap                     1           XCVR_A10_TX_PRE_EMP_SIGN_1ST_POST_TAP             l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_sign_1st_post_tap                NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_switching_ctrl_1st_post_tap           1           XCVR_A10_TX_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP   l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_switching_ctrl_1st_post_tap      NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_sign_2nd_post_tap                     1           XCVR_A10_TX_PRE_EMP_SIGN_2ND_POST_TAP             l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_sign_2nd_post_tap                NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_pre_emp_switching_ctrl_2nd_post_tap           1           XCVR_A10_TX_PRE_EMP_SWITCHING_CTRL_2ND_POST_TAP   l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_pre_emp_switching_ctrl_2nd_post_tap      NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_slew_rate_ctrl                                1           XCVR_A10_TX_SLEW_RATE_CTRL                        l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_slew_rate_ctrl                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_compensation_en                               1           XCVR_A10_TX_COMPENSATION_EN                       l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_compensation_en                          NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_term_sel                                      1           XCVR_A10_TX_TERM_SEL                              l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_tx_term_sel                                 NOVAL            NOVAL                                                    NOVAL} \
    {pma_tx_buf_optimal                                       NOVAL       NOVAL                                             l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_enable_tx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_tx_buf_xtx_path_optimal                              NOVAL       NOVAL                                             l_anlg_tx_enable    !l_anlg_tx_enable          false         anlg_enable_tx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    \
    {pma_rx_buf_power_mode                                    1           XCVR_VCCR_VCCT_VOLTAGE                            l_anlg_rx_enable    false                      NOVAL         anlg_voltage                                     NOVAL            {"1_1V:high_perf" "1_0V:mid_power" "0_9V:low_power"}     ::altera_xcvr_native_vi::parameters::validate_pma_power_mode} \
    {pma_rx_buf_power_mode_rx                                 1           NOVAL                                             l_anlg_rx_enable    false                      NOVAL         anlg_voltage                                     NOVAL            {"1_1V:high_perf" "1_0V:mid_power" "0_9V:low_power"}     ::altera_xcvr_native_vi::parameters::validate_pma_power_mode} \
    {pma_rx_buf_link                                          1           XCVR_A10_RX_LINK                                  l_anlg_rx_enable    false                      NOVAL         anlg_link                                        NOVAL            NOVAL                                                    NOVAL} \
    {pma_rx_buf_link_rx                                       1           NOVAL                                             l_anlg_rx_enable    false                      NOVAL         anlg_link                                        NOVAL            NOVAL                                                    NOVAL} \
    {pma_rx_buf_one_stage_enable                              1           XCVR_A10_RX_ONE_STAGE_ENABLE                      l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_one_stage_enable                         NOVAL            NOVAL                                                    NOVAL} \
    {pma_rx_buf_eq_dc_gain_trim                               1           XCVR_A10_RX_EQ_DC_GAIN_TRIM                       l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_eq_dc_gain_trim                          NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_ctle_acgain_4s                             1           XCVR_A10_RX_ADP_CTLE_ACGAIN_4S                    l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_ctle_acgain_4s                       NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_ctle_eqz_1s_sel                            1           XCVR_A10_RX_ADP_CTLE_EQZ_1S_SEL                   l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_ctle_eqz_1s_sel                      NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_vga_sel                                    1           XCVR_A10_RX_ADP_VGA_SEL                           l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_vga_sel                              NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap1                                 1           XCVR_A10_RX_ADP_DFE_FXTAP1                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap1                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap2                                 1           XCVR_A10_RX_ADP_DFE_FXTAP2                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap2                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap3                                 1           XCVR_A10_RX_ADP_DFE_FXTAP3                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap3                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap4                                 1           XCVR_A10_RX_ADP_DFE_FXTAP4                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap4                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap5                                 1           XCVR_A10_RX_ADP_DFE_FXTAP5                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap5                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap6                                 1           XCVR_A10_RX_ADP_DFE_FXTAP6                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap6                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap7                                 1           XCVR_A10_RX_ADP_DFE_FXTAP7                        l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap7                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap8                                 1           NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap8                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap9                                 1           NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap9                           NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap10                                1           NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap10                          NOVAL            NOVAL                                                    NOVAL} \
    {pma_adapt_adp_dfe_fxtap11                                1           NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_adp_dfe_fxtap11                          NOVAL            NOVAL                                                    NOVAL} \
    {pma_rx_buf_term_sel                                      1           XCVR_A10_RX_TERM_SEL                              l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_rx_term_sel                                 NOVAL            NOVAL                                                    NOVAL} \
    {cdr_pll_optimal                                          NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_odi_optimal                                       NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_buf_optimal                                       NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_buf_xrx_path_optimal                              NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_deser_optimal                                     NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_adapt_optimal                                        NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_dfe_optimal                                       NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
    {pma_rx_sd_optimal                                        NOVAL       NOVAL                                             l_anlg_rx_enable    !l_anlg_rx_enable          false         anlg_enable_rx_default_ovr                       NOVAL            {"1:false" "0:true"}                                     NOVAL} \
  }

  # Override some of the analog parameters to other than their core IP defaults
  # Type of overrides implemented here:
  # 1. M_AUTOWARN for gt_enabled attributes  
  #    gt_enabled depends on speedgrade, voltage, link, and datarate (see ICD RBC). The rule is incomplete for GX device speedgrades when power_mode=high_perf assuming the ICD RBC flow where the user chooses power_mode first and then the speedgrade is resolved. This is opposite to the IP usemodel where user chooses the speedgrade first and then the power_mode. Therefore, suppressing the warning.
  # WARNING: DO NOT add M_RCFG_REPORT property in this mapping. It is handled in an algorithmic fashion in the ip_declare stage using the rcfg_report_filters_*
  set analog_parameter_overrides {
    {NAME                                     DEFAULT_VALUE M_AUTOSET   M_AUTOWARN  VALIDATION_CALLBACK} \
    {pma_rx_buf_xrx_path_gt_enabled           NOVAL         NOVAL       false       NOVAL} \ 
    \
    {pma_tx_buf_xtx_path_gt_enabled           NOVAL         NOVAL       false       NOVAL} \ 
  }

  # WARNING: DO NOT add M_RCFG_REPORT property in this mapping. It is handled in an algorithmic fashion in the ip_declare stage using the rcfg_report_filters_*
  set parameter_multi_mappings {
    {NAME                                              DERIVED   TYPE     ENABLED   VISIBLE   M_AUTOSET         M_AUTOWARN   M_MAPS_FROM                         M_MAP_CALLBACK                                                                             M_UNMAP_CALLBACK                                                                            } \
    {data_rate_bps                                     true      STRING   false     false     false             NOVAL        set_data_rate                       ::altera_xcvr_native_vi::parameters::map_data_rate_bps                                     ::altera_xcvr_native_vi::parameters::unmap_data_rate_bps                                    } \
    {cdr_pll_reference_clock_frequency                 NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        set_cdr_refclk_freq                 ::altera_xcvr_native_vi::parameters::map_cdr_pll_reference_clock_frequency                 ::altera_xcvr_native_vi::parameters::unmap_cdr_pll_reference_clock_frequency                } \
    \
    {pma_adapt_adapt_mode                              NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        rx_pma_dfe_adaptation_mode          ::altera_xcvr_native_vi::parameters::map_pma_adapt_adapt_mode                              ::altera_xcvr_native_vi::parameters::unmap_pma_adapt_adapt_mode                             } \
    {pma_adapt_adp_dfe_mode                            NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        rx_pma_dfe_fixed_taps               ::altera_xcvr_native_vi::parameters::map_pma_adapt_adp_dfe_mode                            ::altera_xcvr_native_vi::parameters::unmap_pma_adapt_adp_dfe_mode                           } \
    {pma_rx_dfe_pdb_fixedtap                           NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        rx_pma_dfe_adaptation_mode          ::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_fixedtap                           ::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_fixedtap                          } \
    {pma_rx_dfe_pdb_fxtap4t7                           NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        rx_pma_dfe_fixed_taps               ::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_fxtap4t7                           ::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_fxtap4t7                          } \
    {pma_rx_dfe_pdb_floattap                           NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        rx_pma_dfe_fixed_taps               ::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_floattap                           ::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_floattap                          } \
    \
    {pma_tx_buf_xtx_path_tx_pll_clk_hz                 NOVAL     NOVAL    NOVAL     NOVAL     !tx_enable        NOVAL        cdr_pll_output_clock_frequency      ::altera_xcvr_native_vi::parameters::map_pma_tx_buf_xtx_path_tx_pll_clk_hz                 ::altera_xcvr_native_vi::parameters::unmap_pma_tx_buf_xtx_path_tx_pll_clk_hz                } \
    {pma_tx_buf_xtx_path_pma_tx_divclk_hz              NOVAL     NOVAL    NOVAL     NOVAL     !tx_enable        false        pma_tx_buf_xtx_path_datarate        ::altera_xcvr_native_vi::parameters::map_pma_tx_buf_xtx_path_pma_tx_divclk_hz              ::altera_xcvr_native_vi::parameters::unmap_pma_tx_buf_xtx_path_pma_tx_divclk_hz             } \
    {pma_rx_buf_xrx_path_pma_rx_divclk_hz              NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        pma_rx_buf_xrx_path_datarate        ::altera_xcvr_native_vi::parameters::map_pma_rx_buf_xrx_path_pma_rx_divclk_hz              ::altera_xcvr_native_vi::parameters::unmap_pma_rx_buf_xrx_path_pma_rx_divclk_hz             } \
    {pma_rx_deser_clkdivrx_user_mode                   NOVAL     NOVAL    NOVAL     NOVAL     false             false        rx_pma_div_clkout_divider           ::altera_xcvr_native_vi::parameters::map_pma_rx_deser_clkdivrx_user_mode                   ::altera_xcvr_native_vi::parameters::unmap_pma_rx_deser_clkdivrx_user_mode                  } \
    {hssi_8g_rx_pcs_wa_pd                              NOVAL     NOVAL    NOVAL     NOVAL     !l_enable_rx_std  false        std_rx_word_aligner_pattern_len     ::altera_xcvr_native_vi::parameters::map_hssi_8g_rx_pcs_wa_pd                              ::altera_xcvr_native_vi::parameters::unmap_hssi_8g_rx_pcs_wa_pd                             } \
    {hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz   NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        cdr_pll_reference_clock_frequency   ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz   ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz  } \
    {hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz   NOVAL     NOVAL    NOVAL     NOVAL     !tx_enable        false        data_rate_bps                       ::altera_xcvr_native_vi::parameters::map_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz   ::altera_xcvr_native_vi::parameters::unmap_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  } \
    {hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz   NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        data_rate_bps                       ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz   ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  } \
    {hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx       NOVAL     NOVAL    NOVAL     NOVAL     !tx_enable        false        l_pcs_pma_width                     ::altera_xcvr_native_vi::parameters::map_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx       ::altera_xcvr_native_vi::parameters::unmap_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx      } \
    {hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx       NOVAL     NOVAL    NOVAL     NOVAL     !rx_enable        false        l_pcs_pma_width                     ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx       ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx      } \
    {l_protocol_mode                                   true      STRING   false     false     false             NOVAL        protocol_mode                       ::altera_xcvr_native_vi::parameters::map_l_protocol_mode                                   ::altera_xcvr_native_vi::parameters::unmap_l_protocol_mode                                  } \
    {pcs_speedgrade                                    true      STRING   false     false     false             NOVAL        device                              ::altera_xcvr_native_vi::parameters::map_pcs_speedgrade                                    ::altera_xcvr_native_vi::parameters::unmap_pcs_speedgrade                                   } \
    {pma_speedgrade                                    true      STRING   false     false     false             NOVAL        device                              ::altera_xcvr_native_vi::parameters::map_pma_speedgrade                                    ::altera_xcvr_native_vi::parameters::unmap_pma_speedgrade                                   } \
  }

   set static_hdl_parameters {
    {NAME                                                     M_IS_STATIC_HDL_PARAMETER M_RCFG_REPORT HDL_PARAMETER M_AUTOSET M_AUTOWARN } \
    {pma_cdr_refclk_inclk0_logical_to_physical_mapping        true                      0             false         false     NOVAL      } \
    {pma_cdr_refclk_inclk1_logical_to_physical_mapping        true                      0             false         false     NOVAL      } \
    {pma_cdr_refclk_inclk2_logical_to_physical_mapping        true                      0             false         false     NOVAL      } \
    {pma_cdr_refclk_inclk3_logical_to_physical_mapping        true                      0             false         false     NOVAL      } \
    {pma_cdr_refclk_inclk4_logical_to_physical_mapping        true                      0             false         false     NOVAL      } \
    {pma_cgb_scratch0_x1_clock_src                            true                      0             false         false     NOVAL      } \
    {pma_cgb_scratch1_x1_clock_src                            true                      0             false         false     NOVAL      } \
    {pma_cgb_scratch2_x1_clock_src                            true                      0             false         false     NOVAL      } \
    {pma_cgb_scratch3_x1_clock_src                            true                      0             false         false     NOVAL      } \
    {hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx   true                      0             false         NOVAL     NOVAL      } \
    {hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx   true                      0             false         NOVAL     NOVAL      } \
    {hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx    true                      0             false         NOVAL     NOVAL      } \
    {hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx    true                      0             false         NOVAL     NOVAL      } \
    {hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding    true                      0             false         NOVAL     NOVAL      } \
    {hssi_common_pcs_pma_interface_ctrl_plane_bonding         true                      0             false         NOVAL     NOVAL      } \
    {hssi_common_pcs_pma_interface_cp_cons_sel                true                      0             false         NOVAL     NOVAL      } \
    {hssi_common_pcs_pma_interface_cp_dwn_mstr                true                      0             false         NOVAL     NOVAL      } \
    {hssi_common_pcs_pma_interface_cp_up_mstr                 true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_ctrl_plane_bonding                       true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_comp_cnt                                 true                      0             false         false     NOVAL      } \
    {hssi_10g_tx_pcs_compin_sel                               true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_distdwn_bypass_pipeln                    true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_distdwn_master                           true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_distup_bypass_pipeln                     true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_distup_master                            true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_dv_bond                                  true                      0             false         NOVAL     NOVAL      } \
    {hssi_10g_tx_pcs_indv                                     true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_tx_pcs_ctrl_plane_bonding_consumption            true                      0             false         NOVAL     false      } \
    {hssi_8g_tx_pcs_ctrl_plane_bonding_compensation           true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_tx_pcs_ctrl_plane_bonding_distribution           true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_tx_pcs_auto_speed_nego_gen2                      true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_rx_pcs_ctrl_plane_bonding_consumption            true                      0             false         NOVAL     false      } \
    {hssi_8g_rx_pcs_ctrl_plane_bonding_compensation           true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_rx_pcs_ctrl_plane_bonding_distribution           true                      0             false         NOVAL     NOVAL      } \
    {hssi_8g_rx_pcs_auto_speed_nego                           true                      0             false         NOVAL     NOVAL      } \
    {pma_cgb_select_done_master_or_slave                      true                      0             false         NOVAL     NOVAL      } \
    {pma_tx_buf_mcgb_location_for_pcie                        true                      0             false         NOVAL     NOVAL      } \
  }

# NOTES FOR FUTURE DEVELOPER (CONTACT PERSON: ISARI)
# see FB: 180976 for - hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
# WARNING: DO NOT add M_RCFG_REPORT property in this mapping. It is handled in an algorithmic fashion in the ip_declare stage using the rcfg_report_filters_*
  set parameter_overrides {
    {NAME                                                     DEFAULT_VALUE               M_AUTOSET VALIDATION_CALLBACK                                                                               } \
    {cdr_pll_cdr_powerdown_mode                               "power_up"                  false     NOVAL                                                                                             } \
    {cdr_pll_primary_use                                      "cdr"                       false     NOVAL                                                                                             } \
    {cdr_pll_tx_pll_prot_mode                                 "txpll_unused"              false     NOVAL                                                                                             } \
    {cdr_pll_fb_select                                        "direct_fb"                 false     NOVAL                                                                                             } \
    {cdr_pll_loopback_mode                                    "loopback_disabled"         false     NOVAL                                                                                             } \
    {cdr_pll_reverse_serial_loopback                          "no_loopback"               false     NOVAL                                                                                             } \
    {cdr_pll_m_counter                                        1                           false     ::altera_xcvr_native_vi::parameters::validate_cdr_pll_m_counter                                   } \
    {cdr_pll_n_counter_scratch                                1                           false     ::altera_xcvr_native_vi::parameters::validate_cdr_pll_n_counter_scratch                           } \
    {cdr_pll_pcie_gen                                         NOVAL                       false     ::altera_xcvr_native_vi::parameters::validate_cdr_pll_pcie_gen                                    } \
    {cdr_pll_lpd_counter                                      1                           false     ::altera_xcvr_native_vi::parameters::validate_cdr_pll_lpd_counter                                 } \
    {cdr_pll_lpfd_counter                                     1                           false     ::altera_xcvr_native_vi::parameters::validate_cdr_pll_lpfd_counter                                } \
    {cdr_pll_diag_loopback_enable                             "false"                     false     NOVAL                                                                                             } \
    {hssi_10g_tx_pcs_gb_pipeln_bypass                         "disable"                   true      ::altera_xcvr_native_vi::parameters::validate_hssi_10g_tx_pcs_gb_pipeln_bypass                    } \
    {hssi_10g_tx_pcs_tx_testbus_sel                           "tx_fifo_testbus1"          false     NOVAL                                                                                             } \
    {hssi_10g_rx_pcs_rx_true_b2b                              "b2b"                       false     NOVAL                                                                                             } \
    {hssi_10g_rx_pcs_rx_testbus_sel                           "rx_fifo_testbus1"          false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_err_flags_sel                             "err_flags_wa"              false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_eidle_entry_eios                          "dis_eidle_eios"            false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_eidle_entry_iei                           "dis_eidle_iei"             false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_invalid_code_flag_only                    "dis_invalid_code_only"     false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_wa_clk_slip_spacing                       "16"                        false     NOVAL                                                                                             } \
    {hssi_8g_rx_pcs_wa_det_latency_sync_status_beh            "dont_care_assert_sync"     true      ::altera_xcvr_native_vi::parameters::validate_hssi_8g_rx_pcs_wa_det_latency_sync_status_beh       } \
    {hssi_common_pld_pcs_interface_pcs_testbus_block_sel      "pma_if"                    false     NOVAL                                                                                             } \
    {hssi_common_pcs_pma_interface_ppm_post_eidle_delay       "cnt_200_cycles"            false     NOVAL                                                                                             } \
    {hssi_common_pcs_pma_interface_testout_sel                "asn_test"                  false     NOVAL                                                                                             } \
    {hssi_krfec_rx_pcs_rx_testbus_sel                         "overall"                   false     NOVAL                                                                                             } \
    {hssi_krfec_rx_pcs_error_marking_en                       NOVAL                       NOVAL     ::altera_xcvr_native_vi::parameters::validate_hssi_krfec_rx_pcs_error_marking_en                  } \
    {hssi_krfec_tx_pcs_burst_err                              "burst_err_dis"             false     NOVAL                                                                                             } \
    {hssi_krfec_tx_pcs_tx_testbus_sel                         "overall"                   false     NOVAL                                                                                             } \
    {hssi_pipe_gen1_2_ind_error_reporting                     "dis_ind_error_reporting"   false     NOVAL                                                                                             } \
    {hssi_pipe_gen1_2_rxdetect_bypass                         "dis_rxdetect_bypass"       false     NOVAL                                                                                             } \
    {hssi_pipe_gen1_2_txswing                                 "dis_txswing"               false     ::altera_xcvr_native_vi::parameters::validate_hssi_pipe_gen1_2_txswing                            } \
    {hssi_pipe_gen3_ind_error_reporting                       "dis_ind_error_reporting"   false     NOVAL                                                                                             } \
    {hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel         "one_ff_delay"              false     ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel    } \
    {hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl             "delay1_path0"              false     ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl        } \
    {hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl             "delay2_path0"              false     ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl        } \
    \
    {hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx       NOVAL                       false     ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx  } \
    {hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx       NOVAL                       false     ::altera_xcvr_native_vi::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx  } \
    \
    {pma_cdr_refclk_xmux_refclk_src                           "refclk_iqclk"              false     NOVAL                                                                                             } \
    {pma_cdr_refclk_xpm_iqref_mux_iqclk_sel                   "power_down"                false     NOVAL                                                                                             } \
    {pma_cdr_refclk_powerdown_mode                            "powerup"                   false     NOVAL                                                                                             } \
    {pma_cgb_bonding_reset_enable                             "disallow_bonding_reset"    false     NOVAL                                                                                             } \
    {pma_cgb_input_select_gen3                                "unused"                    false     ::altera_xcvr_native_vi::parameters::validate_pma_cgb_input_select_gen3                           } \
    {pma_cgb_input_select_x1                                  "fpll_bot"                  false     ::altera_xcvr_native_vi::parameters::validate_pma_cgb_input_select_x1                             } \
    {pma_rx_deser_pcie_gen                                    NOVAL                       false     ::altera_xcvr_native_vi::parameters::validate_pma_rx_deser_pcie_gen                               } \
    {pma_rx_deser_bitslip_bypass                              NOVAL                       true      ::altera_xcvr_native_vi::parameters::validate_pma_rx_deser_bitslip_bypass                         } \
    {pma_rx_buf_cdrclk_to_cgb                                 "cdrclk_2cgb_dis"           false     NOVAL                                                                                             } \
    {pma_rx_buf_diag_lp_en                                    "dlp_off"                   false     NOVAL                                                                                             } \
    {pma_rx_buf_loopback_modes                                "lpbk_disable"              false     NOVAL                                                                                             } \
    {pma_tx_buf_dft_sel                                       "dft_disabled"              false     NOVAL                                                                                             } \
    {pma_tx_buf_lst                                           "atb_disabled"              false     NOVAL                                                                                             } \
    {pma_tx_buf_tx_powerdown                                  "normal_tx_on"              false     NOVAL                                                                                             } \
    {pma_tx_ser_ser_clk_divtx_user_sel                        NOVAL                       false     ::altera_xcvr_native_vi::parameters::validate_pma_tx_ser_ser_clk_divtx_user_sel                   } \
    \
    {hssi_rx_pld_pcs_interface_hd_chnl_func_mode              "enable"                    false     NOVAL                                                                                             } \
    {hssi_tx_pld_pcs_interface_hd_chnl_func_mode              "enable"                    false     NOVAL                                                                                             } \
    {hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en               "uhsif_lpbk_dis"            false     NOVAL                                                                                             } \
    {hssi_tx_pcs_pma_interface_pmagate_en                     "pmagate_dis"               false     NOVAL                                                                                             } \
    {hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en     "enable"                    false     NOVAL                                                                                             } \
    {hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en     "enable"                    false     NOVAL                                                                                             } \
    \
    {cdr_pll_initial_settings                                 "true"                      false     NOVAL                                                                                             } \
    {pma_rx_odi_initial_settings                              "true"                      false     NOVAL                                                                                             } \
    {pma_rx_buf_initial_settings                              "true"                      false     NOVAL                                                                                             } \
    {pma_rx_buf_xrx_path_initial_settings                     "true"                      false     NOVAL                                                                                             } \
    {pma_tx_buf_initial_settings                              "true"                      false     NOVAL                                                                                             } \
    {pma_tx_buf_xtx_path_initial_settings                     "true"                      false     NOVAL                                                                                             } \
    {pma_adapt_initial_settings                               "true"                      false     NOVAL                                                                                             } \
    {pma_cgb_initial_settings                                 "true"                      false     NOVAL                                                                                             } \
    {pma_rx_dfe_initial_settings                              "true"                      false     NOVAL                                                                                             } \
    {pma_tx_ser_initial_settings                              "true"                      false     NOVAL                                                                                             } \
  }


  # This list of pairs is used to filter which parameters are included in the M_RCFG_REPORT depending
  # on which blocks are enabled
  # NOTE - ORDER MATTERS
  set rcfg_report_filters_dyn { \
    {NAME                              REPORT          } \
    {pma_cdr_                          rx_enable       } \
    {cdr_pll                           rx_enable       } \
    {hssi_common_pcs_pma               rx_enable       } \
    {hssi_common_pld_pcs               rx_enable       } \
    {hssi_fifo_rx                      rx_enable       } \
    {pma_adapt                         rx_enable       } \
    {pma_rx_buf                        rx_enable       } \
    {pma_rx_deser                      rx_enable       } \
    {pma_rx_dfe                        rx_enable       } \
    {pma_rx_odi                        rx_enable       } \
    {hssi_rx_pcs_pma                   rx_enable       } \
    {hssi_rx_pld_pcs                   rx_enable       } \
    {pma_rx_sd                         rx_enable       } \
    {hssi_8g_rx                        l_enable_rx_std } \
    {hssi_pipe_gen1_2                  l_enable_rx_std } \
    {hssi_gen3_rx                      l_enable_rx_std } \
    {hssi_10g_rx                       l_enable_rx_enh } \
    {hssi_krfec_rx                     l_enable_rx_enh } \
    {pma_cgb_                          tx_enable       } \
    {hssi_fifo_tx                      tx_enable       } \
    {pma_tx_buf                        tx_enable       } \
    {pma_tx_cgb                        tx_enable       } \
    {hssi_tx_pcs_pma                   tx_enable       } \
    {hssi_tx_pld_pcs                   tx_enable       } \
    {pma_tx_ser                        tx_enable       } \
    {hssi_8g_tx                        l_enable_tx_std } \
    {hssi_pipe_gen3                    l_enable_tx_std } \
    {hssi_gen3_tx                      l_enable_tx_std } \
    {hssi_10g_tx                       l_enable_tx_enh } \
    {hssi_krfec_tx                     l_enable_tx_enh } \
}

  # This list of pairs is used to filter which parameters are excluded in the M_RCFG_REPORT statically
  # NOTE - ORDER MATTERS
  set rcfg_report_filters_stat { \
    {NAME                              REPORT          } \
    {uhsif                             0               } \
    {uc                                0               } \
    {micro_controller                  0               } \
    {bonding_reset_enable              0               } \
    {iqclk_mux_sel                     0               } \
    {hssi_10g_tx_pcs_pseudo_seed_a     0               } \
    {pma_rx_buf_cdrclk_to_cgb          0               } \                 
    {pma_cgb_dprio_cgb_vreg_boost      0               } \   
}

}


proc ::altera_xcvr_native_vi::parameters::get_variable { var } {
  variable display_items
  variable parameters
  variable analog_parameters
  variable rcfg_parameters
  variable parameter_mappings
  variable analog_parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable analog_parameter_overrides
  variable static_hdl_parameters

  return [set $var]

}

# Get antecedents for the given parameter
proc ::altera_xcvr_native_vi::parameters::get_antecedents { params name } {
  set ant_list {}

  if { [dict exists $params $name] } {
    set callback [dict get $params $name VALIDATION_CALLBACK ]
    if {$callback != "NOVAL"} {
      # Get antecedents from callback
	    set antecedents [info args $callback]
      # Iterate over each antecedent
	    foreach ant $antecedents {
        if {($ant != $name) && ([string first "PROP_" $ant] == -1)} {
	  	    lappend ant_list $ant
          lappend ant_list [get_antecedents $params $ant]
	      }
      }
	  }
  }
  return $ant_list
}


# IP upgrade callback
proc ::altera_xcvr_native_vi::parameters::upgrade {ip_name version old_params} {
  
  set new_params [get_upgraded_parameters $ip_name $version $old_params]

  # Special handling for multi-profile reconfiguration
  for {set i 0} {$i < 8} {incr i} {
    if {[dict exists $new_params "rcfg_profile_data${i}"]} {
      #puts "rcfg_profile_data${i} : [dict get $new_params "rcfg_profile_data${i}"]"
      dict set new_params "rcfg_profile_data${i}" [get_upgraded_parameters $ip_name $version [dict get $new_params "rcfg_profile_data${i}"]]
    }
  }

  # Set parameter values
  set declared_params [get_parameters]
  foreach {param value} $new_params {
    if { [lsearch $declared_params $param] != -1 } {
      ip_set "parameter.${param}.value" $value
    }
  }
}


proc ::altera_xcvr_native_vi::parameters::get_upgraded_parameters {ip_name version old_params} {
  set new_params $old_params
  
  # Early versions of 13.1 had a different parameter set
  if { [lsearch $new_params "datapath_select"] != -1 } {
    # Need to map datapath_select, std_protocol_mode and enh_protocol_mode to protocol_mode
    set datapath_select [dict get $new_params datapath_select]
    set std_protocol_mode [dict get $new_params std_protocol_mode]
    set enh_protocol_mode [dict get $new_params enh_protocol_mode]
    # Get the protocol mode
    set protocol_mode [expr {$datapath_select == "Standard" ? $std_protocol_mode : $enh_protocol_mode}]
    # Accomodate name changes
    set protocol_mode [expr { $protocol_mode == "basic" ? "basic_std"
                              : $protocol_mode == "basic_rm" ? "basic_std_rm"
                                : $protocol_mode == "basic_mode" ? "basic_enh"
                                  : $protocol_mode }]
    puts "Upgraded datapath_select:${datapath_select},std_protocol_mode:${std_protocol_mode},enh_protocol_mode:${enh_protocol_mode} to protocol_mode:${protocol_mode}"
    # Remove old params
    set new_params [dict remove $new_params "datapath_select"]
    set new_params [dict remove $new_params "std_protocol_mode"]
    set new_params [dict remove $new_params "enh_protocol_mode"]
    # Set new param
    dict set new_params protocol_mode $protocol_mode
  }
 
  # Starting from 15.0, option: "one-time" for parameter: rx_pma_dfe_adaptation_mode" was removed. Mapping it to continuous 
  if { [lsearch $new_params "rx_pma_dfe_adaptation_mode"] != -1 } {
    set old_rx_pma_dfe_adaptation_mode [dict get $new_params rx_pma_dfe_adaptation_mode]
    set new_rx_pma_dfe_adaptation_mode $old_rx_pma_dfe_adaptation_mode
    if {$old_rx_pma_dfe_adaptation_mode == "one-time"} {
      set new_rx_pma_dfe_adaptation_mode "continuous"
      dict set new_params rx_pma_dfe_adaptation_mode $new_rx_pma_dfe_adaptation_mode      
      puts "WARNING: Upgraded value of rx_pma_dfe_adaptation_mode from:${old_rx_pma_dfe_adaptation_mode} to:${new_rx_pma_dfe_adaptation_mode}. If this is not a desired mapping, you need to upgrade manually!"
    }  
  }
  
  # Starting from 15.1,  floating tap functionality is implemented as part of fixed taps and the parameter: enable_rx_pma_floatingtap is removed, 
  #                      since the parameter was never explicitly exposed to customers, no remapping is required --> simply remove it
  if { [lsearch $new_params "enable_rx_pma_floatingtap"] != -1 } {
    set new_params [dict remove $new_params "enable_rx_pma_floatingtap"]
    puts "WARNING: Upgraded - the parameter:enable_rx_pma_floatingtap is deprecated, hence removed. No adverse effect is expected."
  }
  
  return $new_params
}

proc ::altera_xcvr_native_vi::parameters::declare_parameters { {device_family "Arria 10"} } {
  variable display_items
  variable parameters
  variable analog_parameters
  variable rcfg_parameters
  variable parameter_mappings
  variable analog_parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable analog_parameter_overrides
  variable static_hdl_parameters
  variable CONST_DATAPATH_SELECT_MAPPING
  variable rcfg_report_filters_dyn
  variable rcfg_report_filters_stat

# ip_parse_csv "parameters.csv" "altera_xcvr_native_vi"
# set display_items [ip_get_csv_variable "altera_xcvr_native_vi" "display_items"]
# set parameters [ip_get_csv_variable "altera_xcvr_native_vi" "parameters"]
  ip_declare_parameters $parameters
  ip_declare_parameters $rcfg_parameters
  ip_declare_parameters $analog_parameters
  

  # Which parameters are included in reconfig reports is parameter dependent
  ip_add_user_property_type M_RCFG_REPORT integer
  # Tag abstract parameters for inclusion in reconfiguration report files
  ip_set "parameter.pll_select.M_RCFG_REPORT" tx_enable
  ip_set "parameter.cdr_refclk_select.M_RCFG_REPORT" rx_enable
  
  # Add Native PHY parameters
  ip_declare_parameters [::nf_xcvr_native::parameters::get_parameters]

  # Add M_AUTOSET attribute to all native phy parameters
  set nf_xcvr_native_parameters [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict [::nf_xcvr_native::parameters::get_parameters]]

  foreach param [dict keys $nf_xcvr_native_parameters] { 
    ip_set "parameter.${param}.M_AUTOSET" 1
    ip_set "parameter.${param}.DISPLAY_ITEM" "Transceiver Attributes"
    ip_set "parameter.${param}.VISIBLE" [get_quartus_ini altera_xcvr_native_a10_debug ENABLED]
    ip_set "parameter.${param}.DERIVED" 1
    ip_set "parameter.${param}.ENABLED" 0
  }

  # Provide parameter mappings from IP parameters to native transceiver parameters
  ip_declare_parameters $parameter_mappings
  ip_declare_parameters $analog_parameter_mappings
  ip_declare_parameters $parameter_multi_mappings

  ip_set "parameter.pcs_speedgrade.VALIDATION_CALLBACK" "::altera_xcvr_native_vi::parameters::validate_pcs_speedgrade"
  ip_set "parameter.datapath_select.M_MAP_VALUES" ${CONST_DATAPATH_SELECT_MAPPING}
  
  # overrides: actual values are set by direct mapping (see "parameter_mappings")
  ip_set "parameter.hssi_10g_tx_pcs_txfifo_mode.VALIDATION_CALLBACK" "::altera_xcvr_native_vi::parameters::validate_hssi_10g_tx_pcs_txfifo_mode"
  ip_set "parameter.hssi_10g_rx_pcs_rxfifo_mode.VALIDATION_CALLBACK" "::altera_xcvr_native_vi::parameters::validate_hssi_10g_rx_pcs_rxfifo_mode"

  #Convert the filter lists to dictionary
  set rcfg_report_filters_dyn  [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict $rcfg_report_filters_dyn]
  set rcfg_report_filters_stat [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict $rcfg_report_filters_stat]

  # Action callback on a drop-down for Analog Mode - to populate the TX preset swing settings in the GUI depending on Analog mode  
  set_parameter_update_callback anlg_tx_analog_mode    ::altera_xcvr_native_vi::parameters::parameter_update_action_anlg_tx_analog_mode
  # For the default case when the user is opening the GUI for the first time, calling the same parameter_update callback when the checkbox is selected
  set_parameter_update_callback enable_analog_settings ::altera_xcvr_native_vi::parameters::parameter_update_action_anlg_tx_analog_mode
  # For the case when the user is checking and unchecking the override checkbox after selecting analog mode
  set_parameter_update_callback anlg_enable_tx_default_ovr ::altera_xcvr_native_vi::parameters::parameter_update_action_anlg_tx_analog_mode

  # Mark which parameters are HDL parameters and should be included in the dynamic reconfiguration report
  # and disable validation callbacks for static hdl parameters except the ones listed in enable_callback_static_hdl_params
  set enable_callback_static_hdl_params { cdr_pll_f_min_ref cdr_pll_f_max_ref cdr_pll_f_min_vco cdr_pll_f_max_vco cdr_pll_f_min_pfd cdr_pll_f_max_pfd cdr_pll_f_min_gt_channel }
  
  # speed_grade - force disabling ICD validation callback for PMA speedgrades as we do a reverse mapping in the TCL from user speed_grade to PMA power_mode in validate_pma_power_mode according to the usemodel of user selecting speedgrade first and then power_mode
  ip_set "parameter.pma_tx_buf_pm_speed_grade.VALIDATION_CALLBACK" "NOVAL"
  ip_set "parameter.pma_rx_buf_pm_speed_grade.VALIDATION_CALLBACK" "NOVAL"
  ip_set "parameter.cdr_pll_pm_speed_grade.VALIDATION_CALLBACK"    "NOVAL"
  
  # cgb_vreg_boost  - depends only on voltage and need not go into the MIF as voltage is not reconfigured. We need not enable the validation callback as well. 
  ip_set "parameter.pma_cgb_dprio_cgb_vreg_boost.VALIDATION_CALLBACK" "NOVAL"
  
  # Exclusion list among the analog parameters to not override the validation callback from xcvr_native params database
  # power_mode      - want to preserve the callback value from parameter declaration table
  # speed_grade     - want to preserve the manually "disabled" ICD callback above as we do a reverse mapping in the TCL from speed_grade to power_mode in validate_pma_power_mode according to the usemodel of user selecting speedgrade first and then power_mode
  # cgb_vreg_boost  - depends only on voltage and need not go into the MIF as voltage is not reconfigured. We need not enable the validation callback as well. 
  set anlg_atom_params_exclusion_list { pma_tx_buf_pm_speed_grade pma_rx_buf_pm_speed_grade cdr_pll_pm_speed_grade pma_tx_buf_power_mode pma_rx_buf_power_mode pma_rx_buf_power_mode_rx pma_cgb_dprio_cgb_vreg_boost }
  
  # Get register map into a dictionary
  set regmap [::alt_xcvr::utils::device::get_arria10_regmap {pcs pma}]
 
  # Get the analog atom params defined in parameter tables
  set criteria [dict create M_ANALOG 1]
  set anlg_atom_params [ip_get_matching_parameters $criteria]
  

  #Override GUI default value and allowed ranges with atom parameter values if a specific mapping from GUI<->atom is not defined in the parameter table. 
  #Copy DEFAULT_VALUE if DEFAULT_VALUE is not defined in the GUI mapping table
  #Copy ALLOWED_RANGES if it not restricted in the GUI mapping table
  foreach anlg_atom_param $anlg_atom_params {
    if {[ip_get "parameter.${anlg_atom_param}.M_MAP_VALUES"] == "NOVAL"} {
      set anlg_gui_param [ip_get "parameter.${anlg_atom_param}.M_MAPS_FROM"]
      set anlg_gui_param_allowed_ranges [ip_get "parameter.${anlg_gui_param}.ALLOWED_RANGES"]
      set anlg_gui_param_default_value  [ip_get "parameter.${anlg_gui_param}.DEFAULT_VALUE"]
      if { [string length $anlg_gui_param_default_value] == 0 } { 
        ip_set "parameter.${anlg_gui_param}.DEFAULT_VALUE"  [ip_get "parameter.${anlg_atom_param}.DEFAULT_VALUE"] 
      }
      if { [llength $anlg_gui_param_allowed_ranges] <= 1 } { 
        ip_set "parameter.${anlg_gui_param}.ALLOWED_RANGES" [ip_get "parameter.${anlg_atom_param}.ALLOWED_RANGES"] 
      }
    }
  }
  
  dict for {param props} $nf_xcvr_native_parameters {
    #==========================================================================
    #                          IPGEN parameters
    #==========================================================================
    if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
      ip_set "parameter.${param}.HDL_PARAMETER" 1
      
      # to make reconfig_settings NOT a HDL parameter
      if { [regexp {reconfig_settings} $param] } {
        ip_set "parameter.${param}.HDL_PARAMETER" 0        
      }

      # Set it to include in the reconfig report always 
      ip_set "parameter.${param}.M_RCFG_REPORT" 1
     
      # Override it with filter to mask out certain parameters later below
      dict for {filter prop} $rcfg_report_filters_dyn {
      # Set conditions for parameter inclusion in reconfiguration report files - dynamic list
        set rcfg_report_dyn [::alt_xcvr::ip_tcl::ip_module::get_item_property $rcfg_report_filters_dyn $filter REPORT]
        if { [regexp $filter $param] } {
          ip_set "parameter.${param}.M_RCFG_REPORT" $rcfg_report_dyn
        }
      }  
       
    } else {
      #==========================================================================
      #                          NON-IPGEN parameters
      #==========================================================================
      # Get a list of antecedents for each static param  
      set antecedents [::altera_xcvr_native_vi::parameters::get_antecedents $nf_xcvr_native_parameters $param]

      # If one of the antecedents is pma_tx_buf_xtx_path_analog_mode, then set the property M_TX_ANALOG_MODE_SETTING to that analog GUI parameter
      if { [lsearch $anlg_atom_params $param] != -1 && [lsearch $antecedents "pma_tx_buf_xtx_path_analog_mode"] != -1 } {
        ip_set "parameter.${param}.M_TX_ANALOG_MODE_SETTING" 1
      }

      # Get the value of VALIDATION_CALLBACK for each param
      set xcvr_native_val_callback [dict get $nf_xcvr_native_parameters $param VALIDATION_CALLBACK]

      # Check if the antecedents exist in the analog atom param list or in the inclusion list
      # Also find one of the antecedent name that is present in the analog atom parameter table 
      #   -> this is needed to set the M_RCFG_REPORT field for parameters that are derived from analog
      set ant_exists_in_anlg_list 0
      set ant_in_anlg_list "NOVAL"
      foreach ant $antecedents {
        if {[lsearch $anlg_atom_params $ant] != -1} {
          set ant_exists_in_anlg_list 1
          set ant_in_anlg_list $ant
        }
      }

      # Only for debug 
      #if {[lsearch $anlg_atom_params $param] != -1} {
      #  puts "Parameter=$param is in the analog list"
      #} elseif {$ant_exists_in_anlg_list == 1} {
      #  puts "Parameter=$param has an antecedent in the analog list."
      #  puts "   --> Antecedents = $antecedents"
      #  puts "   --> Analog antecent in the list chosen for rcfg_report = $ant_in_anlg_list"
      #}

      # If the native atom param is in the Analog Param list or if it is dependent on any of the analog params in the list 
      #   Turn on the validation callback to set it to native callback if it is not in the exclusion list
      #   If the param has a register associated with it, set the property M_RCFG_REPORT to 1 to mark it to be written out to the reconfiguration report files
      if {([lsearch $anlg_atom_params $param] != -1 || $ant_exists_in_anlg_list == 1)} {
        if {[lsearch $anlg_atom_params_exclusion_list $param] == -1 } { 
          ip_set "parameter.${param}.VALIDATION_CALLBACK" $xcvr_native_val_callback
        } 
        if { [dict exists $regmap $param] } {
          # Analog params in the list
          #   -> analog_parameter_mapping list already has M_RCFG_REPORT_TEMP set correctly.
          # Antecedents in the analog params list
          #  -> We should manually set the M_RCFG_REPORT based on M_RCFG_REPORT_TEMP
          #     Why M_RCFG_REPORT_TEMP was needed? Answer: For case 2 below.
          #     1. If the antecedent in analog list has a register           => ip_get should have gotten the M_RCFG_REPORT value from the table. No need of TEMP.
          #     2. If none of the antecedents in analog list have a register => ip_get may not return the correct M_RCFG_REPORT as this loop might have overwritten it previously for the antecedent.
          if  { [lsearch $anlg_atom_params $param] != -1 } {
            ip_set "parameter.${param}.M_RCFG_REPORT" [ip_get "parameter.${param}.M_RCFG_REPORT_TEMP"]
          } elseif { $ant_exists_in_anlg_list } {
            ip_set "parameter.${param}.M_RCFG_REPORT" [ip_get "parameter.${ant_in_anlg_list}.M_RCFG_REPORT_TEMP"]
          }
        } 
      } else {
        # For params not in analog list or don't have antecedents in the analog list, disable validation callback if it is not in the enable_callback_static_hdl_params list
        if {[lsearch $enable_callback_static_hdl_params $param] == -1} {
          ip_set "parameter.${param}.VALIDATION_CALLBACK" "NOVAL"
        }
      } 
    }
    
    # Apply static filter to exclude certain parameters for both IPGEN and non-IPGEN parameters
    dict for {filter prop} $rcfg_report_filters_stat {
      # Set conditions for parameter inclusion in reconfiguration report files - dynamic list
      set rcfg_report_stat [::alt_xcvr::ip_tcl::ip_module::get_item_property $rcfg_report_filters_stat $filter REPORT]
      if { [regexp $filter $param] } {
        ip_set "parameter.${param}.M_RCFG_REPORT" $rcfg_report_stat
      }
    } 

  }
 
  
  ip_declare_parameters $parameter_overrides
  ip_declare_parameters $analog_parameter_overrides

  # Declare static parameters in the very end
  ip_declare_parameters $static_hdl_parameters

  # Enabling M_RCFG_REPORT for auto_speed_nego parameters
  # Only needed for A10 SKP workaround
  ip_set "parameter.hssi_8g_tx_pcs_auto_speed_nego_gen2.M_RCFG_REPORT" enable_skp_ports
  ip_set "parameter.hssi_8g_rx_pcs_auto_speed_nego.M_RCFG_REPORT" enable_skp_ports
 
  # Add display items
  ip_declare_display_items $display_items

  #Set the configuration profile data group to collapsed by default (as part of fix to FB307759)
  set_display_item_property "Configuration Profile Data" DISPLAY_HINT COLLAPSED

  # Initialize some tables row headers:
  # set criteria [dict create M_USED_FOR_RCFG 1 DERIVED 0]
  # set params [ip_get_matching_parameters $criteria]
  # ip_set "parameter.rcfg_params.default_value" $params

  # Initialize system_info type parameters
  # Initialize device information (to allow sharing of this function across device families)
  ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
  ip_set "parameter.device_family.DEFAULT_VALUE" $device_family
  # Initialize design_environment parameter
  ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT

  # Initialize part number and revision
  ip_set "parameter.device.SYSTEM_INFO" DEVICE

  ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE
  ip_set "parameter.base_device.DEFAULT_VALUE" "nightfury5es";#temporary hack once BASE_DEVICE is properly supported by qsys remove this line

  # Initialize reconfiguration profile header
  set criteria [dict create M_USED_FOR_RCFG 1 DERIVED 0]
  set params [ip_get_matching_parameters $criteria]
  ip_set "parameter.rcfg_params.default_value" $params
  set labels {}
  foreach param $params {
    lappend labels [ip_get "parameter.${param}.display_name"]
  }
  ip_set "parameter.rcfg_param_labels.default_value" $labels

  # Grab Quartus INI's
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_a10_advanced ENABLED]
  ip_set "parameter.enable_advanced_avmm_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_avmm_a10_advanced ENABLED]
  ip_set "parameter.enable_odi_accelerator.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_a10_enable_odi_acc ENABLED]
  ip_set "parameter.enable_debug_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_a10_debug ENABLED]
  ip_set "parameter.enable_physical_bonding_clocks.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_a10_enable_physical_bonding_clocks ENABLED]
    
  # Enable parameter mapping in the messaging package
  ::alt_xcvr::ip_tcl::messages::set_mapping_enabled 1
  ::alt_xcvr::ip_tcl::messages::set_message_filter_criteria {}
  ::alt_xcvr::ip_tcl::messages::set_deferred_messaging 1
  ::alt_xcvr::ip_tcl::messages::set_trace_antecedentsAtErrorMessage_to_userSettableParameters_enable 1
  # we dont want following parameters to be displayed to user as antecedents in error messages, either because user cant change them or they are not very useful 
  ip_set "parameter.base_device.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.message_level.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.duplex_mode.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.enable_transparent_pcs.M_DONT_DISPLAY_IN_ERR_MSGS" true

  # For some variables we will obtain the M_AUTOSET attribute from a variable
  ::alt_xcvr::ip_tcl::ip_module::ip_add_user_property_type M_AUTOSET boolean


  # Set mapping values for datapath select
  declare_validation_rule_select   

   
}

proc ::altera_xcvr_native_vi::parameters::check_for_unset_parameters {} {
  # Find all atom parameters that need setting
  dict set criteria VALIDATION_CALLBACK NOVAL
  dict set criteria M_IS_STATIC_HDL_PARAMETER false
  dict set criteria M_AUTOSET 1
  set params [ip_get_matching_parameters $criteria]
  foreach param $params {
    set allowed_ranges [ip_get "parameter.${param}.allowed_ranges"]
    if {[llength $allowed_ranges] > 1} {
      puts "${param} must be set! Options $allowed_ranges"
    }
  }
}
 
proc ::altera_xcvr_native_vi::parameters::declare_validation_rule_select {} {
  set ini [get_quartus_ini altera_xcvr_native_a10_debug ENABLED]
  if { $ini == "true" || $ini == 1 } {
    set params [ip_get_matching_parameters {M_IP_CORE nf_xcvr_native}]
    set validation_rule_list {}
    foreach param $params {
      if {[ip_get "parameter.${param}.VALIDATION_CALLBACK"] != "NOVAL"} {
        lappend validation_rule_list $param
      }
    }
    ip_set "parameter.validation_rule_select.allowed_ranges" $validation_rule_list
    ip_set "parameter.validation_rule_select.default_value" [lindex $validation_rule_list 0]
    set_parameter_update_callback validation_rule_select ::altera_xcvr_native_vi::parameters::validation_rule_select_callback 
  }
}

proc ::altera_xcvr_native_vi::parameters::validation_rule_select_callback { context } {
  set param [ip_get "parameter.validation_rule_select.value"]
  set callback [ip_get "parameter.${param}.VALIDATION_CALLBACK"]
  # Get the callback proc body
  set body [info body $callback]
  # Remove the non-rule stuff
  set index [string first "if \{ \$PROP_M_AUTOSET" $body]
  set body [string replace $body $index [string length $body]]
  set body [string trim $body]
  # Convert to HTML for multi-line
  set body "Rule for <b>${param}</b>:\n\n$body"
  set body [string map {"\n" "<br>"} $body]
  set body "<html>${body}</html>"
  ip_set "display_item.validation_rule_display.TEXT" $body
}

proc ::altera_xcvr_native_vi::parameters::validate {} {   
  ip_validate_parameters
  ip_validate_display_items
  ::alt_xcvr::ip_tcl::messages::issue_deferred_messages
}


proc ::altera_xcvr_native_vi::parameters::dummy_callback {} {

}

#******************************************************************************
#************************ Validation Callbacks ********************************

proc ::altera_xcvr_native_vi::parameters::validate_message_level { message_level } {
  ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"] 
}

##
# This function is used to show the user the information message about the speed grade for the selected device
proc ::altera_xcvr_native_vi::parameters::validate_pcs_speedgrade { pcs_speedgrade pma_speedgrade device } {
  set temp_pma_speed_grade [string range $pma_speedgrade 1 1];#dont show the operating temperature
  set temp_pcs_speed_grade [string range $pcs_speedgrade 1 1];#dont show the operating temperature
  #Quartus to ICD RBC mapping
  set temp_pcs_speed_grade [expr {$temp_pcs_speed_grade-1}];#local pcs speed grade is incremented version of what is selected in qsys by user, so what's shown to user is decremented
  ip_message info "For the selected device($device), transceiver speed grade is $temp_pma_speed_grade and core speed grade is $temp_pcs_speed_grade."
}

proc ::altera_xcvr_native_vi::parameters::validate_device_revision { base_device } {  
  set temp_device_revision [::nf_xcvr_native::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
	  ip_set "parameter.device_revision.value" $temp_device_revision
  } else {
	set device [ip_get parameter.DEVICE.value]
	ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_simple_interface { PROP_NAME PROP_VALUE datapath_select rcfg_iface_enable enable_hip protocol_mode enh_pld_pcs_width enh_rxtxfifo_double_width } {
  set legal_values [expr {$rcfg_iface_enable ? {0}
    : $datapath_select == "PCS Direct" ? {0 1}
    : $datapath_select == "Standard" && !$enable_hip ? {0 1}
    : $datapath_select == "Enhanced" && !$enh_rxtxfifo_double_width ? {0 1}
    : { 0 } }]

  if {$PROP_VALUE} {
    ip_message info "Simplified data interface has been enabled. The Native PHY will present the data/control interface for the current configuration only. Dynamic reconfiguration of the data interface cannot be supported. The unused_tx_parallel_data and unused_tx_control ports should be connected to 0."
  }
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { datapath_select rcfg_iface_enable enh_rxtxfifo_double_width}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_split_interface { l_channels design_environment } {
  set enabled 0
  if {$design_environment != "QSYS" && $l_channels > 1} {
    set enabled 1
  }
  ip_set "parameter.enable_split_interface.enabled" $enabled
  ip_set "parameter.enable_split_interface.visible" $enabled
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_calibration { set_enable_calibration enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_enable_calibration : 1}]
  ip_set "parameter.enable_calibration.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_hip_cal_en { set_hip_cal_en } {
  set value [expr { $set_hip_cal_en ? "enable" : "disable"}]
  ip_set "parameter.hip_cal_en.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
  if {$PROP_VALUE == "engineering_mode"} {
    ip_message $message_level "Engineering support mode has been selected. Engineering mode is for internal use only. Altera does not officially support or guarantee IP configurations for this mode."
  }
}


proc ::altera_xcvr_native_vi::parameters::validate_set_data_rate { set_data_rate protocol_mode} {

  if {![string is double $set_data_rate]} {
    ip_message error "[ip_get "parameter.set_data_rate.display_name"] \"$set_data_rate\" is improperly formatted. Should be ###.##."
  }
  
  if {$protocol_mode == "pipe_g3"} {
    ip_message info "When \"[ip_get "parameter.protocol_mode.display_name"]\" is set to \"Gen 3 PIPE\", the \"[ip_get "parameter.set_data_rate.display_name"]\" for the Standard PCS should be set for the power-on configuration of Gen1 PIPE. Under the hood, the \"[ip_get "parameter.set_data_rate.display_name"]\" for the Gen 3 PCS is set as 8000Mbps which is not reflected in the GUI."
  }
}


##
# Some RBC rules regarding bonding are found in the six-pack or subsystem level rules which 
# we cannot automatically consume. We manually create them here.
proc ::altera_xcvr_native_vi::parameters::validate_bonded_mode { bonded_mode protocol_mode l_enable_std_pipe channels } {
  set legal_values [expr { $l_enable_std_pipe && $channels > 1 ? "pma_pcs"
    : {"not_bonded" "pma_only" "pma_pcs"} }]

  auto_invalid_value_message auto bonded_mode $bonded_mode $legal_values { protocol_mode channels }
}


proc ::altera_xcvr_native_vi::parameters::validate_set_pcs_bonding_master { set_pcs_bonding_master tx_enable channels l_channels bonded_mode } {
  set range {"Auto"}
  for {set x 0} {$x < $l_channels} {incr x} {
    lappend range $x
  }

  set enabled [expr { $tx_enable && ($bonded_mode == "pma_pcs") }]

  set legal_values [expr { !$enabled ? $set_pcs_bonding_master
    : $range }]

  auto_invalid_value_message error set_pcs_bonding_master $set_pcs_bonding_master $legal_values { channels bonded_mode }

  if { [lsearch $range $set_pcs_bonding_master] == -1 } {
    lappend range $set_pcs_bonding_master
  }

  ip_set "parameter.set_pcs_bonding_master.allowed_ranges" $range
  ip_set "parameter.set_pcs_bonding_master.enabled" $enabled
}


proc ::altera_xcvr_native_vi::parameters::validate_pcs_bonding_master { tx_enable l_channels bonded_mode set_pcs_bonding_master enable_hip } {
  set value [expr { !$tx_enable || ($bonded_mode != "pma_pcs") ? 0
    : $set_pcs_bonding_master == "Auto" ?  ($enable_hip && ($l_channels < 4)) ? 0
        : ($enable_hip) ? 3
      : ($l_channels / 2)
    : $set_pcs_bonding_master }]

  ip_set "parameter.pcs_bonding_master.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_display_base_data_rate { set_data_rate tx_pma_clk_div tx_enable protocol_mode} {
  if {[string is double $set_data_rate]} {
    set pll_clk_frequency [expr {double($set_data_rate * $tx_pma_clk_div) / 2}]
    # if protocol mode is pipe_g1 the cgb will have a divide by 2 enabled (see FB:151614)
    set pll_clk_frequency [expr {$protocol_mode=="pipe_g1"? (2*$pll_clk_frequency): $pll_clk_frequency}]

    set message "<html><font color=\"blue\">Note - </font>The external TX PLL IP must be configured with an output clock frequency of <b>${pll_clk_frequency} MHz.</b></html>"
    if {$tx_enable} {
      ip_message info $message
    }
  } else {
    set message ""
  }
  ip_set "display_item.display_base_data_rate.text" $message
}

###
# Validation for the pll_select parameter
#
# @param plls - Resolved value of the plls parameter
proc ::altera_xcvr_native_vi::parameters::validate_pll_select { tx_enable plls pll_select } {
  set allowed_ranges {}
  if {!$tx_enable} {
    set allowed_ranges [list $pll_select]
  } else {
    for {set i 0} {$i < $plls} {incr i} {
      lappend allowed_ranges $i
    }
  }

  ip_set "parameter.pll_select.allowed_ranges" $allowed_ranges
}

# in disabled mode the value of rx_pma_dfe_fixed_taps does not take effect we set underlying parameter as per RBC, so the parameter is grayed out in that case.
proc ::altera_xcvr_native_vi::parameters::validate_rx_pma_dfe_fixed_taps { PROP_NAME rx_pma_dfe_adaptation_mode rx_enable} {
  if {$rx_pma_dfe_adaptation_mode=="disabled" || !$rx_enable} {
    ip_set "parameter.${PROP_NAME}.enabled" 0
  } else {
    ip_set "parameter.${PROP_NAME}.enabled" 1
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_clkout { PROP_NAME PROP_VALUE } {
  if {$PROP_VALUE} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    ip_message info "The \"tx_pma_clkout\" port is not to be used to clock the data interface (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_pma_clkout { PROP_NAME PROP_VALUE } {
  if {$PROP_VALUE} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    ip_message info "The \"rx_pma_clkout\" port is not to be used to clock the data interface (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_div_clkout { PROP_NAME PROP_VALUE } {
  if {$PROP_VALUE} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    ip_message info "The \"tx_pma_div_clkout\" port should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_pma_div_clkout { PROP_NAME PROP_VALUE } {
  if {$PROP_VALUE} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    ip_message info "The \"rx_pma_div_clkout\" port should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_pma_txdetectrx { enable_port_tx_pma_txdetectrx duplex_mode } {
  #ideally this port cannot be 1 for rx, but if the user set the port while the duplex is selected and then they switched to rx the option would dissapear while the error is there.
  set legal_values [expr {$duplex_mode == "duplex" || $duplex_mode == "rx" ? {0 1}
    : 0 }]

  auto_invalid_value_message auto enable_port_tx_pma_txdetectrx $enable_port_tx_pma_txdetectrx $legal_values {duplex_mode}
}


###
# Validation for the cdr_refclk_select parameter
#
# @param cdr_refclk_cnt - Resolved value of the cdr_refclk_cnt parameter
proc ::altera_xcvr_native_vi::parameters::validate_cdr_refclk_select { cdr_refclk_cnt } {
  set allowed_ranges {}
  for {set i 0} {$i < $cdr_refclk_cnt} {incr i} {
    lappend allowed_ranges $i
  }

  ip_set "parameter.cdr_refclk_select.allowed_ranges" $allowed_ranges
}


proc ::altera_xcvr_native_vi::parameters::validate_l_pll_settings { device_revision rx_enable set_data_rate l_enable_std_pipe cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref pma_rx_buf_xrx_path_prot_mode} {

  if {$rx_enable && [string is double $set_data_rate]} {
    set l_pll_settings [dict create]

    set allowed_ranges {}
    set pcie_mode [expr {$l_enable_std_pipe ? $pma_rx_buf_xrx_path_prot_mode : "non_pcie"}]
    set values [::altera_xcvr_cdr_pll_vi::parameters::compute_pll_settings $device_revision [expr double($set_data_rate) / 2] "CDR" $pcie_mode $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd $cdr_pll_f_max_vco $cdr_pll_f_min_vco $cdr_pll_f_max_ref $cdr_pll_f_min_ref]

    dict for {key value} $values {
      set refclk [dict get $value "refclk"]
                
      if {[lsearch $allowed_ranges $refclk] == -1} {
        lappend allowed_ranges $refclk
        dict set l_pll_settings $refclk [dict get $value]
      }
    }

    set allowed_ranges [lsort -real -unique $allowed_ranges] 
    dict set l_pll_settings "allowed_ranges" $allowed_ranges

    ip_set "parameter.l_pll_settings.value" $l_pll_settings
  } else {
    ip_set "parameter.l_pll_settings.value" "NOVAL"
  }
}


proc ::altera_xcvr_native_vi::parameters::validate_l_pll_settings_key { set_cdr_refclk_freq l_pll_settings } {
  set l_pll_settings_key "NOVAL"

  if {$l_pll_settings != "NOVAL"} {
    set allowed_ranges [dict get $l_pll_settings "allowed_ranges"]
    set idx [lsearch -real -sorted $allowed_ranges $set_cdr_refclk_freq]
    if {$idx != -1} {
      set l_pll_settings_key [lindex $allowed_ranges $idx]
    }
  }

  ip_set "parameter.l_pll_settings_key.value" $l_pll_settings_key
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_pma_bonding { tx_enable bonded_mode } {
  set value [expr { !$tx_enable || ($bonded_mode == "not_bonded") ? 0
    : 1 }]

  ip_set "parameter.l_enable_pma_bonding.value" $value
}


###
# Validation for the set_cdr_refclk_freq parameter
#
# @param device_family - Resolved value of the device_family parameter
# @param data_rate - Resolved value of the data_rate parameter
proc ::altera_xcvr_native_vi::parameters::validate_set_cdr_refclk_freq { set_cdr_refclk_freq l_pll_settings device_family message_level } {
  set allowed_ranges {}
 
  if {$l_pll_settings != "NOVAL"} {
 
    set allowed_ranges [dict get $l_pll_settings "allowed_ranges"]
 
    # Issue message if current selected value is illegal
    set idx [lsearch -real -sorted $allowed_ranges $set_cdr_refclk_freq]
    if {$idx == -1} {
      ip_invalid_param_message $message_level "The selected CDR reference clock frequency \"$set_cdr_refclk_freq\" is invalid. Please select a valid CDR reference clock frequency or choose a different data rate." set_cdr_refclk_freq
      lappend allowed_ranges $set_cdr_refclk_freq
    } elseif { [string compare [lindex $allowed_ranges $idx] $set_cdr_refclk_freq] != 0 } {
      lappend allowed_ranges $set_cdr_refclk_freq
    }
  } else {
      lappend allowed_ranges $set_cdr_refclk_freq
  }
 
  ip_set "parameter.set_cdr_refclk_freq.allowed_ranges" $allowed_ranges
}

#******************************************************************************
#********************* Mapping/Unmapping Callbacks ****************************

##
# convert set_data_rate to bps from Mbps and adds the unit
proc ::altera_xcvr_native_vi::parameters::map_data_rate_bps { set_data_rate } {
  if {[string is double $set_data_rate]} {
    set temp [expr {wide(double($set_data_rate) * 1000000)}]
  } else {
    # if the user input not formatted properly
    # setting it to '1' will return the valid range as '1' is not valid
    # setting it to '0' would do the same but it vulnarable for divide-by-zero errors (although such a division does not take place currently it might in future)
    set temp 1
  }
  return "${temp} bps"
}

##
# unmaps data_rate_bps to set_data_rate by removing the unit and converting to Mbps from bps
proc ::altera_xcvr_native_vi::parameters::unmap_data_rate_bps { data_rate_bps } {
  regsub -nocase -all {\D} $data_rate_bps "" temp
  set temp [expr {double($temp) / 1000000}]
  return $temp
}

#------------------------------

##
# convert set_cdr_refclk_freq to hz from MHz and adds the unit
proc ::altera_xcvr_native_vi::parameters::map_cdr_pll_reference_clock_frequency { set_cdr_refclk_freq } {
  set temp [expr {wide(double($set_cdr_refclk_freq) * 1000000)}]
  return "${temp} hz"
}

##
# unmaps cdr_ref_clk to set_cdr_refclk by removing the unit and converting to MHz from hz
proc ::altera_xcvr_native_vi::parameters::unmap_cdr_pll_reference_clock_frequency { cdr_pll_reference_clock_frequency } {
  regsub -nocase -all {\D} $cdr_pll_reference_clock_frequency "" temp
  set temp [expr {double($temp) / 1000000}]
  return $temp
}

#------------------------------
# see FB:278751 for changes made on the mapping table
# ALL THE FOLLOWING ADAPTATION RELATED MAP UNMAP FUNCTIONS ARE DONE BASED ON THE FOLLOWING TABLE
#  user-ctle   user-dfe    user-taps  -->   atom-adapt_mode   atom-adapt_taps  atom-en_fixed  atom-en_fixed4t7  
#   manual     disabled    3          -->   manual            radp_4           fx_pdown       4t7_pdown         
#   manual     disabled    7,11       -->   manual            radp_4           fx_pdown       4t7_pdown         
#   manual     manual      3          -->   manual            radp_4           fx_enable      4t7_pdown         
#   manual     manual      7,11       -->   manual            radp_0           fx_enable      4t7_enable        
#   manual     continuous  3          -->   dfe_vga           radp_4           fx_enable      4t7_pdown         
#   manual     continuous  7,11       -->   dfe_vga           radp_0           fx_enable      4t7_enable        
#   one-time   disabled    3          -->   ctle              radp_4           fx_enable      4t7_pdown         
#   one-time   disabled    7,11       -->   ctle              radp_4           fx_enable      4t7_pdown         
#   one-time   manual      3          -->   ctle_vga          radp_4           fx_enable      4t7_pdown         
#   one-time   manual      7,11       -->   ctle_vga          radp_0           fx_enable      4t7_enable        
#   one-time   continuous  3          -->   ctle_vga_dfe      radp_4           fx_enable      4t7_pdown         
#   one-time   continuous  7,11       -->   ctle_vga_dfe      radp_0           fx_enable      4t7_enable        
#

##
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_ctle_adaptation_mode" to "pma_adapt_adapt_mode "
#  user-ctle   user-dfe    -->   atom-adapt_mode 
#   manual     disabled    -->   manual          
#   manual     manual      -->   manual          
#   manual     continuous  -->   dfe_vga         
#   one-time   disabled    -->   ctle        
#   one-time   manual      -->   ctle_vga        
#   one-time   continuous  -->   ctle_vga_dfe    
proc ::altera_xcvr_native_vi::parameters::map_pma_adapt_adapt_mode {rx_pma_dfe_adaptation_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_ctle_adaptation_mode == "manual")   && (($rx_pma_dfe_adaptation_mode == "disabled") || ($rx_pma_dfe_adaptation_mode == "manual")     ) ) ? "manual"
    : ( ($rx_pma_ctle_adaptation_mode == "manual")   && (($rx_pma_dfe_adaptation_mode == "continuous")                                                ) ) ? "dfe_vga"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "disabled")                                                  ) ) ? "ctle"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "manual")                                                    ) ) ? "ctle_vga"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "continuous")                                                ) ) ? "ctle_vga_dfe"
    : "dfe_vga" }]
  return $value
}

##
# unmaps "pma_adapt_adapt_mode" to "rx_pma_dfe_adaptation_mode"
proc ::altera_xcvr_native_vi::parameters::unmap_pma_adapt_adapt_mode {pma_adapt_adapt_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ( $pma_adapt_adapt_mode == "manual" )      && ($rx_pma_ctle_adaptation_mode=="manual")   ) ? [list "manual" "disabled" ]
    : ( ( $pma_adapt_adapt_mode == "manual" )      && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "dfe_vga")      && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list "continuous" ]
    : ( ( $pma_adapt_adapt_mode == "dfe_vga")      && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle")         && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle")         && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "disabled" ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga")     && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga")     && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "manual" ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga_dfe") && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga_dfe") && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "continuous" ]
    : "" }]
  return $value
}

##
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_adapt_adp_dfe_mode"
# user-dfe    user-taps  -->   atom-adapt_taps  
# disabled    DONT CARE  -->   radp_4           
# manual      3          -->   radp_4           
# manual      7,11       -->   radp_0           
# continuous  3          -->   radp_4           
# continuous  7,11       -->   radp_0           
proc ::altera_xcvr_native_vi::parameters::map_pma_adapt_adp_dfe_mode {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode } {
  set value [expr { \
      $rx_pma_dfe_adaptation_mode == "disabled"                    ? "radp_dfe_mode_4"
    : $rx_pma_dfe_fixed_taps == 11 || $rx_pma_dfe_fixed_taps == 7  ? "radp_dfe_mode_0"
    : $rx_pma_dfe_fixed_taps == 3                                  ? "radp_dfe_mode_4"
    :                                                                "radp_dfe_mode_4"}]
  return $value
}

##
# unmaps "pma_adapt_adp_dfe_mode" to "rx_pma_dfe_fixed_taps"
proc ::altera_xcvr_native_vi::parameters::unmap_pma_adapt_adp_dfe_mode {pma_adapt_adp_dfe_mode rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_4") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_4") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3]
    : (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_0") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 7 11]
    : ""}]
  return $value
}

##
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_rx_dfe_pdb_floattap"
# user-dfe    user-taps  -->   atom-floattap  
# disabled    DONT CARE  -->   floattap_dfe_powerdown           
# O.W         3,7        -->   floattap_dfe_powerdown           
# O.W         11         -->   floattap_dfe_enable           
proc ::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_floattap {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode } {
  set value [expr { \
      $rx_pma_dfe_adaptation_mode == "disabled"                    ? "floattap_dfe_powerdown"
    : $rx_pma_dfe_fixed_taps == 3 || $rx_pma_dfe_fixed_taps == 7   ? "floattap_dfe_powerdown"
    : $rx_pma_dfe_fixed_taps == 11                                 ? "floattap_dfe_enable"
    :                                                                "floattap_dfe_powerdown"}]
  return $value
}

##
# unmaps "pma_rx_dfe_pdb_floattap" to "rx_pma_dfe_fixed_taps"
proc ::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_floattap {pma_rx_dfe_pdb_floattap rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_powerdown") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_powerdown") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3 7]
    : (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_enable")    && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 11]
    : ""}]
  return $value
}
 
##
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_ctle_adaptation_mode" to "pma_rx_dfe_pdb_fixedtap"
proc ::::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_fixedtap {rx_pma_dfe_adaptation_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_dfe_adaptation_mode == "disabled") && ($rx_pma_ctle_adaptation_mode == "manual") ) ? "fixtap_dfe_powerdown"
    : "fixtap_dfe_enable" }]
  return $value
}

##
# unmaps "pma_rx_dfe_pdb_fixedtap" to "rx_pma_dfe_adaptation_mode"
proc ::::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_fixedtap {pma_rx_dfe_pdb_fixedtap rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_powerdown") && ($rx_pma_ctle_adaptation_mode == "one-time")) ? ""
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_powerdown") && ($rx_pma_ctle_adaptation_mode == "manual"  )) ? [list "disabled" ]
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_enable")    && ($rx_pma_ctle_adaptation_mode == "manual"  )) ? [list "continuous" "manual" ]
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_enable")    && ($rx_pma_ctle_adaptation_mode == "one-time")) ? [list "continuous" "manual" "disabled" ]
    : "" }]
  return $value
}

##
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_rx_dfe_pdb_fxtap4t7"
proc ::::altera_xcvr_native_vi::parameters::map_pma_rx_dfe_pdb_fxtap4t7 {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_dfe_adaptation_mode == "disabled") ) ? "fxtap4t7_powerdown"
    : ( ($rx_pma_dfe_fixed_taps == "3" ) ) ? "fxtap4t7_powerdown"
    : ( ($rx_pma_dfe_fixed_taps == "7" ) ) ? "fxtap4t7_enable"
    : ( ($rx_pma_dfe_fixed_taps == "11") ) ? "fxtap4t7_enable"
    : "fxtap4t7_powerdown" }]
  return $value
}

##
# unmaps "pma_rx_dfe_pdb_fxtap4t7" to "rx_pma_dfe_fixed_taps"
proc ::::altera_xcvr_native_vi::parameters::unmap_pma_rx_dfe_pdb_fxtap4t7 {pma_rx_dfe_pdb_fxtap4t7 rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_powerdown") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_powerdown") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3]
    : (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_enable")    && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 7 11]
    : ""}]
  return $value
}

#------------------------------

##
# mapping for tx_pll_clk_hz as cdr_pll_out_freq/clock_divider_ratio (first strip off units from cdr_pll_out_freq)
proc ::altera_xcvr_native_vi::parameters::map_pma_tx_buf_xtx_path_tx_pll_clk_hz { cdr_pll_output_clock_frequency pma_tx_buf_xtx_path_clock_divider_ratio } {
  regsub -nocase -all {\D} $cdr_pll_output_clock_frequency "" temp
  return [expr {wide(double($temp)/$pma_tx_buf_xtx_path_clock_divider_ratio)}]
}

##
# unmaps tx_pll_clk_hz to cdr_pll_out_freq as tx_pll_clk_hz*clock_divider_ratio (adds units hz as well)
proc ::altera_xcvr_native_vi::parameters::unmap_pma_tx_buf_xtx_path_tx_pll_clk_hz { pma_tx_buf_xtx_path_tx_pll_clk_hz pma_tx_buf_xtx_path_clock_divider_ratio } {
  regsub -nocase -all {\D} $pma_tx_buf_xtx_tx_pll_clk_hz "" temp
  set temp [expr {wide(double($pma_tx_buf_xtx_tx_pll_clk_hz)*$pma_tx_buf_xtx_path_clock_divider_ratio)}] 
  return "${temp} hz"
}

#------------------------------

##
# mapping for chnl_clklow_clk_hz as cdr_ref_clk/clklow_div (first strip off units from cdr_ref_clk)
proc ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz { cdr_pll_reference_clock_frequency cdr_pll_fref_clklow_div } {
  regsub -nocase -all {\D} $cdr_pll_reference_clock_frequency "" temp
  set temp [expr {wide(double($temp)/$cdr_pll_fref_clklow_div)}]
  return $temp
}

##
# unmaps chnl_clklow_clk_hz to cdr_ref_clk as chnl_clklow_clk_hz*clklow_div (adds units hz as well)
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz { hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz cdr_pll_fref_clklow_div} {
  set temp [expr {wide(double($hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz)*$cdr_pll_fref_clklow_div)}]
  return "${temp} hz"
}

#------------------------------

##
# mapping for tx_divclk as datarate/datawidth (first strip off units from datarate)
proc ::altera_xcvr_native_vi::parameters::map_pma_tx_buf_xtx_path_pma_tx_divclk_hz { pma_tx_buf_xtx_path_datarate pma_tx_buf_xtx_path_datawidth } {
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  regsub -nocase -all {\D} $pma_tx_buf_xtx_path_datarate "" temp
  set val [expr {wide(double($temp)/$pma_tx_buf_xtx_path_datawidth)}]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$val > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set val $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $val
}

##
# unmaps tx_divclk to datarate as tx_divclk*datawidth (adds units bps as well)
proc ::altera_xcvr_native_vi::parameters::unmap_pma_tx_buf_xtx_path_pma_tx_divclk_hz { pma_tx_buf_xtx_path_pma_tx_divclk_hz pma_tx_buf_xtx_path_datawidth } {
  set temp [expr {wide(double($pma_tx_buf_xtx_path_pma_tx_divclk_hz)*$pma_tx_buf_xtx_path_datawidth)}] 
  return "${temp} bps"
}

##
# mapping for rx_divclk as datarate/datawidth (first strip off units from datarate)
proc ::altera_xcvr_native_vi::parameters::map_pma_rx_buf_xrx_path_pma_rx_divclk_hz { pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_datawidth } {
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" temp
  set val [expr {wide(double($temp)/$pma_rx_buf_xrx_path_datawidth)}]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$val > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set val $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $val
}

##
# unmaps rx_divclk to datarate as rx_divclk*datawidth (adds units bps as well)
proc ::altera_xcvr_native_vi::parameters::unmap_pma_rx_buf_xrx_path_pma_rx_divclk_hz { pma_rx_buf_xrx_path_pma_rx_divclk_hz pma_rx_buf_xrx_path_datawidth } {
  set temp [expr {wide(double($pma_rx_buf_xrx_path_pma_rx_divclk_hz)*$pma_rx_buf_xrx_path_datawidth)}] 
  return "${temp} bps"
}

#------------------------------

##
# mapping for pld_rx_clk as datarate/datawidth (first strip off units from datarate)
proc ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { data_rate_bps hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx l_rx_pld_pcs_width } {
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  regsub -nocase -all {\D} $data_rate_bps "" temp_datarate
  set temp_clk [expr {($hssi_tx_pld_pcs_interface_hd_chnl_hip_en == "enable" || $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx != "fifo_rx" || $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx == "gige_1588_rx")? 0 : [expr {wide(double($temp_datarate)/$l_rx_pld_pcs_width)}] } ]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $temp_clk
}

##
# unmaps pld_rx_clk to datarate as pld_rx_clk*datawidth (adds units bps as well)
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz l_rx_pld_pcs_width } {
  set temp_datarate [expr {wide(double($hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz)*$l_rx_pld_pcs_width)}] 
  return "${temp_datarate} bps"
}

##
# mapping for pld_tx_clk as datarate/datawidth (first strip off units from datarate)
proc ::altera_xcvr_native_vi::parameters::map_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { data_rate_bps hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx l_tx_pld_pcs_width } {
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  regsub -nocase -all {\D} $data_rate_bps "" temp_datarate
  set temp_clk [expr {($hssi_tx_pld_pcs_interface_hd_chnl_hip_en == "enable" || $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx != "fifo_tx" || $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx == "gige_1588_tx")? 0 : [expr {wide(double($temp_datarate)/$l_tx_pld_pcs_width)}] } ]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $temp_clk
}

##
# unmaps pld_tx_clk to datarate as pld_tx_clk*datawidth (adds units bps as well)
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz l_tx_pld_pcs_width } {
  set temp_datarate [expr {wide(double($hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz)*$l_tx_pld_pcs_width)}] 
  return "${temp_datarate} bps"
}

#------------------------------

##
# mapping for hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx based on l_pcs_pma_width and protocol_mode parameters
proc ::altera_xcvr_native_vi::parameters::map_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx {l_pcs_pma_width protocol_mode} {
  set value [ expr { $protocol_mode == "pipe_g3" ? "pcie_g3_dyn_dw_tx"
    : "pma_${l_pcs_pma_width}b_tx" }]
  return $value
}

##
# unmaps pma_dw_tx to l_pcs_pma_width based on protocol_mode
# the first case should never occur by construction but must ve there for completeness
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx {hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx} {
  set value [expr { \
      $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx == "pcie_g3_dyn_dw_tx"   ? [list 8 10 16 20 32 40 64 ]
    : [regsub {(pma_)([0-9]*)(b_tx)} $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx {\2}] }]

  return $value
}

##
# mapping for hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx based on l_pcs_pma_width and protocol_mode parameters
proc ::altera_xcvr_native_vi::parameters::map_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx {l_pcs_pma_width protocol_mode} {
  set value [ expr { $protocol_mode == "pipe_g3" ? "pcie_g3_dyn_dw_rx"
    : "pma_${l_pcs_pma_width}b_rx" }]
  return $value
}

##
# unmaps pma_dw_rx to l_pcs_pma_width based on protocol_mode
# the first case should never occur by construction but must ve there for completeness
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx {hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx} {
  set value [expr { \
      $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx == "pcie_g3_dyn_dw_rx"   ? [list 8 10 16 20 32 40 64 ]
    : [regsub {(pma_)([0-9]*)(b_rx)} $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx {\2}] }]

  return $value
}

#------------------------------

##
# Maps std_rx_word_aligner_pattern_len to hssi_8g_rx_pcs_pma_dw
proc ::altera_xcvr_native_vi::parameters::map_hssi_8g_rx_pcs_wa_pd { std_rx_word_aligner_pattern_len hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {
  set value [expr { \
      $std_rx_word_aligner_pattern_len == "7"   ? "wa_pd_7"
    : $std_rx_word_aligner_pattern_len == "8" && $hssi_8g_rx_pcs_pma_dw == "eight_bit" ? "wa_pd_8_sw"
    : $std_rx_word_aligner_pattern_len == "8" && $hssi_8g_rx_pcs_pma_dw != "eight_bit" ? "wa_pd_8_dw"
    : $std_rx_word_aligner_pattern_len == "10"  ? "wa_pd_10"
    : $std_rx_word_aligner_pattern_len == "16" && ($hssi_8g_rx_pcs_pma_dw == "eight_bit" || $hssi_8g_rx_pcs_wa_boundary_lock_ctrl == "bit_slip") ? "wa_pd_16_sw"
    : $std_rx_word_aligner_pattern_len == "16" && ($hssi_8g_rx_pcs_pma_dw != "eight_bit" && $hssi_8g_rx_pcs_wa_boundary_lock_ctrl != "bit_slip") ? "wa_pd_16_dw"
    : $std_rx_word_aligner_pattern_len == "20"  ? "wa_pd_20"
    : $std_rx_word_aligner_pattern_len == "32"  ? "wa_pd_32"
    : "wa_pd_40" }]

  return $value
}


##
# Unmaps to std_rx_word_aligner_pattern_len from hssi_8g_rx_pcs_pma_dw
proc ::altera_xcvr_native_vi::parameters::unmap_hssi_8g_rx_pcs_wa_pd { hssi_8g_rx_pcs_wa_pd } {
  set value [expr { \
      $hssi_8g_rx_pcs_wa_pd == "wa_pd_7"  ? "7"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_8_sw" ? "8"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_8_dw" ? "8"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_10" ? "10"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_16_sw" ? "16"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_16_dw" ? "16"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_20" ? "20"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_32" ? "32"
    : "40" }]

  return $value
}

#------------------------------

##
# Maps protocol_mode to l_protocol_mode
# primary role of l_protocol_mode is not to do separate mappings to tx/rx pma protocol mode parameter
# also mapping is done with map/ummap calls so that messages related to protocol_mode can trace back to user parameter
proc ::altera_xcvr_native_vi::parameters::map_l_protocol_mode {protocol_mode pma_mode} {
  set value [expr { \
      $pma_mode == "SATA" ? "sata"
    : $pma_mode == "GPON" ? "gpon"
    : $pma_mode == "QPI"  ? "qpi"
    : $protocol_mode }]

  return $value
}

##
# Unmaps to protocol_mode from l_protocol_mode
# currently there is not a rule directed for xtx/xrx pma protocol_mode parameter
# hence this function is useless in a sense
# if such a rule is implemented in future, then this function will be useful
proc ::altera_xcvr_native_vi::parameters::unmap_l_protocol_mode {l_protocol_mode pma_mode} {
  set value [expr { \
      $l_protocol_mode == "sata" ? "basic_std"
    : $l_protocol_mode == "gpon" ? [list "basic_std" "basic_enh" ]
    : $l_protocol_mode == "qpi"  ? "pcs_direct"
    : $l_protocol_mode }]

  return $value
}

#------------------------------

##
# Maps rx_pma_div_clkout_divider to pma_rx_deser_clkdivrx_user_mode
proc ::altera_xcvr_native_vi::parameters::map_pma_rx_deser_clkdivrx_user_mode { rx_pma_div_clkout_divider rx_enable enable_port_rx_pma_div_clkout  } {
  set value [expr {!$rx_enable || !$enable_port_rx_pma_div_clkout ? "clkdivrx_user_disabled"
    : $rx_pma_div_clkout_divider == "1" ?  "clkdivrx_user_clkdiv"
    : $rx_pma_div_clkout_divider == "2" ?  "clkdivrx_user_clkdiv_div2"
    : $rx_pma_div_clkout_divider == "33" ? "clkdivrx_user_div33"
    : $rx_pma_div_clkout_divider == "40" ? "clkdivrx_user_div40"
    : $rx_pma_div_clkout_divider == "66" ? "clkdivrx_user_div66"
    : "clkdivrx_user_disabled" }]

  return $value
}

##
# Unmaps to rx_pma_div_clkout_divider from pma_rx_deser_clkdivrx_user_mode
proc ::altera_xcvr_native_vi::parameters::unmap_pma_rx_deser_clkdivrx_user_mode {pma_rx_deser_clkdivrx_user_mode rx_enable enable_port_rx_pma_div_clkout  } {
  set value [expr { \
      ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_disabled")      ?  "Disabled"
    : ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_clkdiv")        ?  "1" 
    : ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_clkdiv_div2")   ?  "2" 
    : ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div33")         ?  "33" 
    : ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div40")         ?  "40" 
    : ( ($rx_enable && $enable_port_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div66")         ?  "66" 
    : ( !$rx_enable || !$enable_port_rx_pma_div_clkout )                                                                   ?  [list "Disabled" "1" "2" "33" "40" "66"] 
    : "" }]
  return $value
}

#------------------------------

##
# Maps device to pcs_speedgrade
# mapping is done with map/ummap calls so that messages related to pcs_speedgrade can trace back to corresponding user parameter (i.e selected device)
proc ::altera_xcvr_native_vi::parameters::map_pcs_speedgrade {device} {
  set operating_temperature [::alt_xcvr::utils::device::get_a10_operating_temperature $device]
  set temp_pcs_speed_grade [::alt_xcvr::utils::device::get_a10_pcs_speedgrade $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_a10_pma_speedgrade $device]
  #see case:305502
  set operating_temperature [expr { ($temp_pma_speed_grade == 4) && ($temp_pcs_speed_grade == 3) && ($operating_temperature == "m") ? "i" : $operating_temperature }]
  #Quartus to ICD RBC mapping
  set temp_pcs_speed_grade [expr {$temp_pcs_speed_grade+1}]
  set temp_pcs_speed_grade "${operating_temperature}${temp_pcs_speed_grade}" 
  return $temp_pcs_speed_grade
}

##
# Ideally we would want to have an unmap fcuntion converting pcs_speedgrade to device but the mapping is not one-to-one
# hence we simply return a message
# consequence: user might see a message in qsys: "the current selection for device(10AG4RF456) is not valid. Valid selections are: Refer to data sheet for valid device options
proc ::altera_xcvr_native_vi::parameters::unmap_pcs_speedgrade {pcs_speedgrade} {
  return "Refer to data sheet for valid device options"
}

##
# Maps device to pma_speedgrade
# mapping is done with map/ummap calls so that messages related to pma_speedgrade can trace back to corresponding user parameter (i.e selected device)
proc ::altera_xcvr_native_vi::parameters::map_pma_speedgrade {device} {
  set operating_temperature [::alt_xcvr::utils::device::get_a10_operating_temperature $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_a10_pma_speedgrade $device]
  set temp_pcs_speed_grade [::alt_xcvr::utils::device::get_a10_pcs_speedgrade $device]
  #see case:305502
  set operating_temperature [expr { ($temp_pma_speed_grade == 4) && ($temp_pcs_speed_grade == 3) && ($operating_temperature == "m") ? "i" : $operating_temperature }]
  #Quartus to ICD RBC mapping
  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}" 
  return $temp_pma_speed_grade
}

##
# Ideally we would want to have an unmap fcuntion converting pma_speedgrade to device but the mapping is not one-to-one
# hence we simply return a message
# consequence: user might see a message in qsys: "the current selection for device(10AG4RF456) is not valid. Valid selections are: Refer to data sheet for valid device options
proc ::altera_xcvr_native_vi::parameters::unmap_pma_speedgrade {pma_speedgrade} {
  return "Refer to data sheet for valid device options"
}

#############################################################################
#################### Local block enable parameters ##########################
proc ::altera_xcvr_native_vi::parameters::validate_l_channels { channels } {
  set l_channels 1
  if {[string is integer $channels]} {
    if {$channels > 0 && $channels <= 96} {
      set l_channels $channels
    }
  }

  ip_set "parameter.l_channels.value" $l_channels
}


proc ::altera_xcvr_native_vi::parameters::validate_l_split_iface { design_environment enable_split_interface l_channels} {
  set value 0
  if { $l_channels > 1 } {
    # If QSYS and more than 1 channel we have to split the interfaces
    if {$design_environment == "QSYS"} {
      set value 1
    } else {
      set value $enable_split_interface
    }
  } 

  ip_set "parameter.l_split_iface.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_l_pcs_pma_width { datapath_select std_pcs_pma_width enh_pcs_pma_width pcs_direct_width} {
  set value [ expr { $datapath_select == "Standard" ? $std_pcs_pma_width
    : $datapath_select == "Enhanced" ? $enh_pcs_pma_width
    : $pcs_direct_width } ]

  ip_set "parameter.l_pcs_pma_width.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_l_tx_pld_pcs_width { datapath_select l_std_tx_pld_pcs_width enh_pld_pcs_width pcs_direct_width enh_rxtxfifo_double_width } {
  set value [ expr {  $datapath_select == "Standard" ? $l_std_tx_pld_pcs_width
                   : ($datapath_select == "Enhanced" && !$enh_rxtxfifo_double_width) ? $enh_pld_pcs_width
                   : ($datapath_select == "Enhanced" &&  $enh_rxtxfifo_double_width) ? [expr {2*$enh_pld_pcs_width}]
                   : $pcs_direct_width } ]

  ip_set "parameter.l_tx_pld_pcs_width.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_l_rx_pld_pcs_width { datapath_select l_std_rx_pld_pcs_width enh_pld_pcs_width pcs_direct_width enh_rxtxfifo_double_width } {
  set value [ expr {  $datapath_select == "Standard" ? $l_std_rx_pld_pcs_width
                   : ($datapath_select == "Enhanced" && !$enh_rxtxfifo_double_width) ? $enh_pld_pcs_width
                   : ($datapath_select == "Enhanced" &&  $enh_rxtxfifo_double_width) ? [expr {2*$enh_pld_pcs_width}]
                   : $pcs_direct_width } ]

  ip_set "parameter.l_rx_pld_pcs_width.value" $value
}

###
# Validation for l_enable_tx_std parameter. Used to determine
# when Standard TX datapath is enabled.
#
# @param tx_enable - Resolved value of the tx_enable parameter
# @param enable_std - Resolved value of the enable_std parameter
proc ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_std { tx_enable enable_std } {
  ip_set "parameter.l_enable_tx_std.value" [expr $tx_enable && $enable_std]
}


###
# Validation for l_enable_rx_std parameter. Used to determine
# when Standard RX datapath is enabled.
#
# @param rx_enable - Resolved value of the rx_enable parameter
# @param enable_std - Resolved value of the enable_std parameter
proc ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_std { rx_enable enable_std } {
  ip_set "parameter.l_enable_rx_std.value" [expr $rx_enable && $enable_std]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_std_iface { PROP_NAME tx_enable l_enable_tx_std rcfg_iface_enable } {
# ip_set "parameter.${PROP_NAME}.value" [expr $l_enable_tx_std || ($rcfg_iface_enable && $tx_enable)]
  ip_set "parameter.${PROP_NAME}.value" $l_enable_tx_std
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_std_iface { PROP_NAME rx_enable l_enable_rx_std rcfg_iface_enable } {
# ip_set "parameter.${PROP_NAME}.value" [expr $l_enable_rx_std || ($rcfg_iface_enable && $rx_enable)]
  ip_set "parameter.${PROP_NAME}.value" $l_enable_rx_std
}


###
# Validation for l_enable_tx_enh parameter. Used to determine
# when 10G TX PCS is enabled.
#
# @param tx_enable - Resolved value of the tx_enable parameter
# @param enable_enh  - Resolved value of the enable_enh  parameter
proc ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_enh { tx_enable enable_enh  } {
  ip_set "parameter.l_enable_tx_enh.value" [expr $tx_enable && $enable_enh ]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_enh_iface { PROP_NAME tx_enable l_enable_tx_enh rcfg_iface_enable } {
# ip_set "parameter.${PROP_NAME}.value" [expr $l_enable_tx_enh || ($rcfg_iface_enable && $tx_enable)]
  ip_set "parameter.${PROP_NAME}.value" $l_enable_tx_enh
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_enh_iface { PROP_NAME rx_enable l_enable_rx_enh rcfg_iface_enable } {
# ip_set "parameter.${PROP_NAME}.value" [expr $l_enable_rx_enh || ($rcfg_iface_enable && $rx_enable)]
  ip_set "parameter.${PROP_NAME}.value" $l_enable_rx_enh
}


###
# Validation for l_enable_rx_enh parameter. Used to determine
# when 10G RX PCS is enabled.
#
# @param rx_enable - Resolved value of the rx_enable parameter
# @param enable_enh  - Resolved value of the enable_enh  parameter
proc ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_enh { rx_enable enable_enh  } {
  ip_set "parameter.l_enable_rx_enh.value" [expr $rx_enable && $enable_enh ]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_tx_pcs_dir { tx_enable enable_pcs_dir } {
  ip_set "parameter.l_enable_tx_pcs_dir.value" [expr $tx_enable && $enable_pcs_dir ]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_enable_rx_pcs_dir { rx_enable enable_pcs_dir } {
  ip_set "parameter.l_enable_rx_pcs_dir.value" [expr $rx_enable && $enable_pcs_dir ]
}


################## End local block enable parameters ########################
#############################################################################


proc ::altera_xcvr_native_vi::parameters::validate_l_rcfg_ifaces { rcfg_shared l_channels } {
  ip_set "parameter.l_rcfg_ifaces.value" [expr { $rcfg_shared ? 1 : $l_channels }]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_rcfg_addr_bits { rcfg_shared l_channels } {
  set l_channels [expr {$l_channels-1}]
  set mux_bits [::alt_xcvr::utils::common::clogb2 $l_channels]
  ip_set "parameter.l_rcfg_addr_bits.value" [expr { $rcfg_shared ? 10+$mux_bits : 10 }]
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_std { datapath_select rcfg_iface_enable } {
  set value [expr {$datapath_select == "Standard" || $rcfg_iface_enable }]

  ip_set "parameter.enable_std.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_enh  { datapath_select rcfg_iface_enable } {
  set enable_enh [expr {$datapath_select == "Enhanced" || $rcfg_iface_enable }]

  ip_set "parameter.enable_enh.value" $enable_enh
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_pcs_dir  { datapath_select rcfg_iface_enable } {
  set enable_pcs_dir [expr {$datapath_select == "PCS Direct" || $rcfg_iface_enable }]

  ip_set "parameter.enable_pcs_dir.value" $enable_pcs_dir
}

#******************************************************************************
#******************* Standard PCS validation callbacks ************************
#

proc ::altera_xcvr_native_vi::parameters::validate_l_enable_std_pipe { protocol_mode } {
  set value [expr {$protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" }]

  ip_set "parameter.l_enable_std_pipe.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_l_std_tx_pld_pcs_width { std_pcs_pma_width std_tx_byte_ser_mode } {
  set legal_value [expr { $std_tx_byte_ser_mode == "Serialize x2" ? [expr $std_pcs_pma_width * 2]
    : $std_tx_byte_ser_mode == "Serialize x4" && $std_pcs_pma_width <= 10 ? $std_pcs_pma_width * 4
    : $std_pcs_pma_width }]

  ip_set "parameter.l_std_tx_pld_pcs_width.value" $legal_value
}

proc ::altera_xcvr_native_vi::parameters::validate_l_std_rx_pld_pcs_width { std_pcs_pma_width std_rx_byte_deser_mode } {
  set legal_value [expr { $std_rx_byte_deser_mode == "Deserialize x2" ? [expr $std_pcs_pma_width * 2]
    : $std_rx_byte_deser_mode == "Deserialize x4" && $std_pcs_pma_width <= 10 ? [expr $std_pcs_pma_width * 4]
    : $std_pcs_pma_width }]

  ip_set "parameter.l_std_rx_pld_pcs_width.value" $legal_value
}

#################################
# case:445399 - For NF5, setting data_mask_count_multi for RevD and RevE to backward compatible RevD value
#               except when enable_pcie_data_mask_count_option=1 
#################################
proc ::altera_xcvr_native_vi::parameters::validate_l_enable_reve_support { device_revision } {
	set legal_value [expr {$device_revision == "20nm5" ? 1 : 0}]
	ip_set "parameter.l_enable_reve_support.value" $legal_value
}

proc ::altera_xcvr_native_vi::parameters::validate_l_std_data_mask_count_multi { enable_pcie_data_mask_option std_data_mask_count_multi enable_hip hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {
   set legal_value 0
   if {$enable_pcie_data_mask_option} {
	set legal_value $std_data_mask_count_multi
   } else {
	   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
		  if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
			 set legal_value 1
		  } else {
			 if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
			set legal_value [expr {$enable_hip ? 1 : 3}]
			 }
		  }
	   }
   }
   ip_set "parameter.l_std_data_mask_count_multi.value" $legal_value
}

proc ::altera_xcvr_native_vi::parameters::validate_display_std_tx_pld_pcs_width { l_std_tx_pld_pcs_width std_tx_8b10b_enable } {
  set legal_value [expr { $std_tx_8b10b_enable ? [expr {$l_std_tx_pld_pcs_width * 4} / 5]
    : $l_std_tx_pld_pcs_width }]

  ip_set "parameter.display_std_tx_pld_pcs_width.value" $legal_value
}

proc ::altera_xcvr_native_vi::parameters::validate_display_std_rx_pld_pcs_width { l_std_rx_pld_pcs_width std_rx_8b10b_enable } {
  set legal_value [expr { $std_rx_8b10b_enable ? [expr {$l_std_rx_pld_pcs_width * 4} / 5]
    : $l_std_rx_pld_pcs_width }]

  ip_set "parameter.display_std_rx_pld_pcs_width.value" $legal_value
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_bitrev_ena { PROP_NAME PROP_VALUE l_enable_rx_std_iface std_rx_bitrev_enable } {
  set legal_values [expr { $std_rx_bitrev_enable && $l_enable_rx_std_iface ? {1}
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_bitrev_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_byterev_ena { PROP_NAME PROP_VALUE l_enable_rx_std_iface std_rx_byterev_enable } {
  set legal_values [expr { $std_rx_byterev_enable && $l_enable_rx_std_iface ? {1}
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_byterev_enable}
}


proc ::altera_xcvr_native_vi::parameters::enable_port_tx_std_bitslipboundarysel { PROP_NAME PROP_VALUE l_enable_rx_std_iface std_tx_bitslip_enable } {
  if { $l_enable_rx_std_iface && $std_tx_bitslip_enable } {
    if { !$PROP_VALUE } {
      ip_message info "The \"tx_std_bitslipboundarysel\" port must be enabled if Standard PCS TX bitslip capability is desired."
    }
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_std_bitslip { PROP_NAME PROP_VALUE l_enable_rx_std_iface std_rx_word_aligner_mode std_low_latency_bypass_enable } {
  if { $l_enable_rx_std_iface && $std_rx_word_aligner_mode == "bitslip" } {
    if { $PROP_VALUE && $std_low_latency_bypass_enable } {
      ip_message info "The enabled <b>\"rx_std_bitslip\"</b> port has no effect when parameter [::alt_xcvr::ip_tcl::messages::get_parameter_display_string std_low_latency_bypass_enable ] is set to [::alt_xcvr::ip_tcl::messages::get_value_display_string std_low_latency_bypass_enable $std_low_latency_bypass_enable]."
    } elseif { !$PROP_VALUE && !$std_low_latency_bypass_enable } {
      ip_message info "The \"rx_std_bitslip\" port must be enabled if Standard PCS RX bitslip capability is desired."
    }
  }
# set legal_values [expr { $std_rx_word_aligner_mode == "bitslip" && !$std_low_latency_bypass_enable ? 1
#   : {0 1} }]
#
# auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { std_rx_word_aligner_mode std_low_latency_bypass_enable }
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_polinv { PROP_NAME PROP_VALUE l_enable_tx_std_iface std_tx_polinv_enable } {
  set legal_values [expr {$std_tx_polinv_enable && $l_enable_tx_std_iface ? 1
      : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_tx_polinv_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_polinv { PROP_NAME PROP_VALUE l_enable_rx_std_iface std_rx_polinv_enable } {
  set legal_values [expr {$std_rx_polinv_enable && $l_enable_rx_std_iface ? 1
      : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_polinv_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_sw { PROP_NAME PROP_VALUE protocol_mode } {
  set legal_values [expr {$protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_hclk { PROP_NAME PROP_VALUE l_enable_std_pipe protocol_mode } {
  set legal_values [expr {$l_enable_std_pipe ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_g3_analog { PROP_NAME PROP_VALUE protocol_mode } {
  set legal_values [expr {$protocol_mode == "pipe_g3" ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_ports_pipe_rx_elecidle { PROP_NAME PROP_VALUE l_enable_std_pipe enable_hip protocol_mode } {
  set legal_values [expr {$l_enable_std_pipe && !$enable_hip ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_pipe_rx_polarity { PROP_NAME PROP_VALUE l_enable_std_pipe protocol_mode } {
  set legal_values [expr {$l_enable_std_pipe ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_tx_word_count { std_pcs_pma_width std_tx_byte_ser_mode } {
  set value [expr {$std_pcs_pma_width > 10 && $std_tx_byte_ser_mode == "Disabled" ? 2
    : $std_pcs_pma_width > 10 && $std_tx_byte_ser_mode == "Serialize x2" ? 4
    : $std_tx_byte_ser_mode == "Serialize x2" ? 2
    : $std_tx_byte_ser_mode == "Serialize x4" ? 4
    : 1 }]

  ip_set "parameter.l_std_tx_word_count.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_tx_word_width { display_std_tx_pld_pcs_width l_std_tx_word_count } {
  ip_set "parameter.l_std_tx_word_width.value" [expr $display_std_tx_pld_pcs_width / $l_std_tx_word_count]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_tx_field_width { std_pcs_pma_width std_tx_byte_ser_mode } {
  set value [expr {$std_pcs_pma_width <= 10 && $std_tx_byte_ser_mode == "Serialize x2" ? 22
        : 11 }]

  ip_set "parameter.l_std_tx_field_width.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_rx_word_count { std_pcs_pma_width std_rx_byte_deser_mode } {
  set value [expr {$std_pcs_pma_width > 10 && $std_rx_byte_deser_mode == "Disabled" ? 2
    : $std_pcs_pma_width > 10 && $std_rx_byte_deser_mode == "Deserialize x2" ? 4
    : $std_rx_byte_deser_mode == "Deserialize x2" ? 2
    : $std_rx_byte_deser_mode == "Deserialize x4" ? 4
    : 1 }]

  ip_set "parameter.l_std_rx_word_count.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_rx_word_width { display_std_rx_pld_pcs_width l_std_rx_word_count } {
  ip_set "parameter.l_std_rx_word_width.value" [expr $display_std_rx_pld_pcs_width / $l_std_rx_word_count]
}


proc ::altera_xcvr_native_vi::parameters::validate_l_std_rx_field_width { std_pcs_pma_width std_rx_byte_deser_mode } {
  set value [expr {$std_pcs_pma_width <= 10 && $std_rx_byte_deser_mode == "Deserialize x2" ? 32
        : 16 }]

  ip_set "parameter.l_std_rx_field_width.value" $value
}


#******************* Standard PCS validation callbacks ************************
#******************************************************************************

#******************************************************************************
#***************** Enhanced PCS validation callbacks *********************

proc ::altera_xcvr_native_vi::parameters::validate_protocol_mode { support_mode } {
  set std_ranges {"basic_std:Basic/Custom (Standard PCS)" \
                  "basic_std_rm:Basic/Custom w/Rate Match (Standard PCS)" \
                  "cpri:CPRI (Auto)" \
                  "cpri_rx_tx:CPRI (Manual)" \
                  "gige:GbE" \
                  "gige_1588:GbE 1588" \
                  "pipe_g1:Gen 1 PIPE" \
                  "pipe_g2:Gen 2 PIPE" \
                  "pipe_g3:Gen 3 PIPE" }

  set enh_ranges {"basic_enh:Basic (Enhanced PCS)" \
                  "interlaken_mode:Interlaken" \
                  "teng_baser_mode:10GBASE-R" \
                  "teng_1588_mode:10GBASE-R 1588" \
                  "teng_baser_krfec_mode:10GBASE-R w/KR FEC" \
                  "fortyg_basekr_krfec_mode:40GBASE-R w/KR FEC" \
                  "basic_krfec_mode:Basic w/KR FEC" }
                  

  set allowed_ranges [concat $std_ranges $enh_ranges {"pcs_direct: PCS Direct"}]
  if {$support_mode == "engineering_mode"} {
    set allowed_ranges [concat $allowed_ranges {"teng_1588_krfec_mode:10GBASE-R 1588 w/KR FEC"}]
  }
 
  ip_set "parameter.protocol_mode.allowed_ranges" $allowed_ranges
}

##
# SATA can be selected only if protocol_mode is basic_std
# GPON can be selected only if protocol_mode is basic_std or basic_enh
# QPI can be selected only if protocol_mode is pcs_direct
# basic can be selected with all protocol_mode selections without any restrictions
proc ::altera_xcvr_native_vi::parameters::validate_pma_mode { PROP_NAME PROP_VALUE protocol_mode } {
  set legal_values { "basic" "SATA" "QPI" "GPON" }

  set legal_values [expr { $protocol_mode == "basic_std"       ? { "basic" "SATA" "GPON" }
                         : $protocol_mode == "basic_enh"       ? { "basic" "GPON" "QPI" }
                         : $protocol_mode == "pcs_direct"      ? { "basic" "QPI" }
                         : "basic" }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { protocol_mode }
}

proc ::altera_xcvr_native_vi::parameters::validate_duplex_mode { duplex_mode protocol_mode } {

  set legal_values [expr {$protocol_mode == "basic_std_rm" \
      || $protocol_mode == "gige" \
      || $protocol_mode == "pipe_g1" \
      || $protocol_mode == "pipe_g2" \
      || $protocol_mode == "pipe_g3" ? "duplex"
    : {duplex tx rx} }]
                  
                  
  auto_invalid_value_message auto duplex_mode $duplex_mode $legal_values {protocol_mode}
}


proc ::altera_xcvr_native_vi::parameters::validate_enh_rxfifo_mode { PROP_NAME support_mode } {
  set allowed_ranges {"Phase compensation" "Register" "Interlaken" "10GBase-R" "Basic"}
  if {$support_mode == "engineering_mode"} {
    set allowed_ranges [concat $allowed_ranges {"Phase compensation (data_valid)"}]
  }
  
  ip_set "parameter.${PROP_NAME}.allowed_ranges" $allowed_ranges
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_enh_frame_burst_en { PROP_NAME PROP_VALUE enh_tx_frmgen_burst_enable } {
  set legal_values [expr { $enh_tx_frmgen_burst_enable ? {1}
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {enh_tx_frmgen_burst_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_tx_enh_bitslip { PROP_NAME PROP_VALUE l_enable_tx_enh enh_tx_bitslip_enable } {
  set legal_values [expr { !$l_enable_tx_enh ? [list $PROP_VALUE]
    : $enh_tx_bitslip_enable == "1" ? {1}
      : {0 1} }]

  auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values {enh_tx_bitslip_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_enable_port_rx_enh_bitslip { enable_port_rx_enh_bitslip l_enable_rx_enh enh_rx_bitslip_enable } {
  set legal_values [expr { !$l_enable_rx_enh ? [list $enable_port_rx_enh_bitslip]
    : $enh_rx_bitslip_enable == "1" ? {1}
      : {0 1} }]

  auto_invalid_value_message warning enable_port_rx_enh_bitslip $enable_port_rx_enh_bitslip $legal_values {enh_rx_bitslip_enable}
}


#***************** End Enhanced PCS validation callbacks *****************
#******************************************************************************


#******************************************************************************
#*************** Dynamic reconfiguration validation callbacks *****************

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_enable { PROP_NAME PROP_VALUE rcfg_iface_enable duplex_mode} {
  if { $rcfg_iface_enable && !$PROP_VALUE } {
    set str_rcfg_enable       "\"[ip_get "parameter.${PROP_NAME}.display_name"]\" (${PROP_NAME}) (current value: $PROP_VALUE)" 
    set str_rcfg_iface_enable "\"[ip_get "parameter.rcfg_iface_enable.display_name"]\" (rcfg_iface_enable) (current value: $rcfg_iface_enable)"
    ip_message warning  "${str_rcfg_enable} should be enabled when ${str_rcfg_iface_enable} is enabled"
  }
  
  if {$PROP_VALUE} {  
    if {$duplex_mode == "tx"} {
      ip_message warning "If this TX Simplex Native PHY instance needs to be merged with an RX Simplex Native PHY instance or a CDR PLL IP instance, ensure that reconfiguration inputs of both the PHY instances are driven by the same source"      
    } elseif {  $duplex_mode == "rx"} {
      ip_message warning "If this RX Simplex Native PHY instance needs to be merged with an TX Simplex Native PHY instance, ensure that reconfiguration inputs of both the PHY instances are driven by the same source"      
    }
  }   
}

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_multi_enable { rcfg_enable } {
  if { $rcfg_enable } {
    ip_message info "<html><font color=\"blue\">Note - </font>When dynamic reconfiguration is enabled, users are recommended to enable multiple reconfiguration profiles for Quartus to perform robust timing closure"
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_shared { PROP_NAME PROP_VALUE rcfg_enable channels l_channels duplex_mode rcfg_jtag_enable set_capability_reg_enable set_csr_soft_logic_enable set_prbs_soft_logic_enable set_odi_soft_logic_enable set_rcfg_emb_strm_enable enable_pcie_dfe_ip} {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {!($rcfg_jtag_enable || $set_capability_reg_enable || $set_csr_soft_logic_enable || $set_prbs_soft_logic_enable || $set_rcfg_emb_strm_enable || $set_odi_soft_logic_enable)} {
        set additional_info "Use independent reconfiguration interface if you need merging."
        if {$duplex_mode == "tx"} {
          display_no_merging_message $PROP_NAME $PROP_VALUE 1 $additional_info
        } elseif {  $duplex_mode == "rx"} {
          display_no_merging_message $PROP_NAME $PROP_VALUE 0 $additional_info
        }
      }
    }  
  }
  
  set legal_values [expr { !$rcfg_enable ? $PROP_VALUE
    : ($l_channels == 1 )                    ? {0}
    : ($l_channels > 1 && ($rcfg_jtag_enable || $enable_pcie_dfe_ip) ) ? {1}
    : {0 1}}]
 
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { channels rcfg_jtag_enable}
}


proc ::altera_xcvr_native_vi::parameters::validate_rcfg_jtag_enable { PROP_NAME PROP_VALUE rcfg_enable l_channels duplex_mode} {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_separate_avmm_busy { PROP_NAME PROP_VALUE enable_advanced_avmm_options set_csr_soft_logic_enable rcfg_enable_avmm_busy_port } {
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

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_file_prefix { rcfg_file_prefix rcfg_enable rcfg_sv_file_enable } {
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

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_profile_select { PROP_NAME rcfg_profile_cnt } {
  set legal_values {}
  for {set x 0} {$x < $rcfg_profile_cnt} {incr x} {
    lappend legal_values $x
  }
  
  ip_set "parameter.${PROP_NAME}.allowed_ranges" $legal_values
}


proc ::altera_xcvr_native_vi::parameters::validate_rcfg_param_vals { PROP_NAME PROP_M_CONTEXT \
  rcfg_enable rcfg_multi_enable rcfg_profile_cnt rcfg_params \
  message_level } {

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
      ip_message warning "Multiple reconfiguration profile $PROP_M_CONTEXT is empty. The Native PHY will use the current configuration for profile $PROP_M_CONTEXT"
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
          ip_message $message_level "Parameter \"${param}\" ([ip_get "parameter.${param}.display_name"]) must be consistent for all reconfiguration profiles. Current value:${cur_val}; Profile${PROP_M_CONTEXT} value:${this_val}."
        }
      }

      # Add the value to the list
      lappend rcfg_param_vals $this_val
    }
    # Finished iterating over params

    # If the current configuration matches the stored configuration, issue a message
    if {$same_as_current} {
      ip_message info "Current IP configuration matches reconfiguration profile $PROP_M_CONTEXT"
    }
    
  }

  ip_set "parameter.${PROP_NAME}.value" $rcfg_param_vals
}


## 
# if the user is reconfiguring between datapath, it is necessary to set rcfg_iface_enable to 1 for all profiles 
proc ::altera_xcvr_native_vi::parameters::validate_l_rcfg_datapath_message { PROP_NAME \
  rcfg_enable rcfg_multi_enable rcfg_profile_cnt rcfg_iface_enable protocol_mode 
  rcfg_profile_data0 rcfg_profile_data1 rcfg_profile_data2 rcfg_profile_data3 rcfg_profile_data4 rcfg_profile_data5 rcfg_profile_data6 rcfg_profile_data7 \
  message_level } {

  ##
  # maps protocol_mode to datapath_select
  # this procedure only used locally, hence defined here
  proc ::altera_xcvr_native_vi::parameters::internal_map_datapath { prot_mode } {
    variable CONST_DATAPATH_SELECT_MAPPING
    set value ""
    foreach elem $CONST_DATAPATH_SELECT_MAPPING {
      #elem is a pair as "protocol_mode:datapath_select"
      set mapping [split $elem ":"]
      if {[lindex $mapping 0] == $prot_mode} {
        set value [lindex $mapping 1]
      }             
    }          
    return $value
  }
  
  # initializations
  set is_datapath_reconfigured 0
  set is_rcfg_iface_enable_set_for_all_profiles $rcfg_iface_enable
    
  if {$rcfg_enable && $rcfg_multi_enable} {    
    # save rcfg_iface_enable and datapath_select values for each profile
    set reduced_dict ""
    for {set i 0} {$i < $rcfg_profile_cnt} {incr i} {
      set rcfg_profile_data [ip_get "parameter.rcfg_profile_data${i}.value"]
      if {$rcfg_profile_data != ""} {
        if {[dict exist $rcfg_profile_data protocol_mode] && [dict exist $rcfg_profile_data rcfg_iface_enable]} {
          dict set reduced_dict $i prof_rcfg_iface_enable [dict get $rcfg_profile_data rcfg_iface_enable]          
          set prof_prot_mode  [dict get $rcfg_profile_data protocol_mode]          
          dict set reduced_dict $i prof_datapath_select [internal_map_datapath $prof_prot_mode]
        } else {
          if {![dict exist $rcfg_profile_data protocol_mode]} {
            ip_message warning "Reconfiguration profile $i is missing a value for parameter [ip_get "parameter.protocol_mode.display_name"] (protocol_mode). Altera recommends that you refresh the profile."
          }
          if {![dict exist $rcfg_profile_data rcfg_iface_enable]} {
            ip_message warning "Reconfiguration profile $i is missing a value for parameter [ip_get "parameter.rcfg_iface_enable.display_name"] (rcfg_iface_enable). Altera recommends that you refresh the profile."
          }
        }
      }
    }

    set active_datapath_select [internal_map_datapath $protocol_mode]
    set error_message "Parameter \"rcfg_iface_enable\" ([ip_get "parameter.rcfg_iface_enable.display_name"]) must be enabled for all reconfiguration profiles when reconfiguring between transceiver datapaths. Current value:${rcfg_iface_enable}"
    dict for {config params} $reduced_dict {
      dict with params {
        # running AND for rcfg_iface_enable across profiles, and error message construction
        set is_rcfg_iface_enable_set_for_all_profiles [expr {$is_rcfg_iface_enable_set_for_all_profiles && $prof_rcfg_iface_enable}]
        set error_message "${error_message}; Profile${config} value:${prof_rcfg_iface_enable}"
        if {$active_datapath_select != "" && $prof_datapath_select != ""} {
          if {$active_datapath_select != $prof_datapath_select} {
            set is_datapath_reconfigured 1
          }
        }
      }
    }
  }
  
  if {$is_datapath_reconfigured && !$is_rcfg_iface_enable_set_for_all_profiles} {
    ip_set "parameter.${PROP_NAME}.value" 1
    ip_message $message_level $error_message      
  } else {
    ip_set "parameter.${PROP_NAME}.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::action_store_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }
  set rcfg_profile_cnt [ip_get "parameter.rcfg_profile_cnt.value"]

  #puts "Constructing profile ${profile}"
  if {$profile < $rcfg_profile_cnt} {
    set rcfg_params [ip_get "parameter.rcfg_params.value"]
    set rcfg_profile_data [dict create]
    # Iterate over necessary parameters and store value
    foreach param $rcfg_params {
      dict set rcfg_profile_data $param [ip_get "parameter.${param}.value"]
    }
    ip_set "Storing profile ${profile} $rcfg_profile_data"
    #puts "Storing profile ${profile} $rcfg_profile_data"
    ip_set "parameter.rcfg_profile_data${profile}.value" $rcfg_profile_data
  }
}


proc ::altera_xcvr_native_vi::parameters::action_load_profile { {profile NOVAL} } {
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


proc ::altera_xcvr_native_vi::parameters::action_clear_profile { {profile NOVAL} } {
  if {$profile == "NOVAL"} {
    set profile [ip_get "parameter.rcfg_profile_select.value"]
  }

  ip_set "parameter.rcfg_profile_data${profile}.value" ""
}


proc ::altera_xcvr_native_vi::parameters::action_clear_profiles {} {
  for {set i 0} {$i < 8} {incr i} {
    action_clear_profile $i
  }
}


proc ::altera_xcvr_native_vi::parameters::action_refresh_profile { {profile NOVAL} } {
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

proc ::altera_xcvr_native_vi::parameters::action_refresh_profiles {} {
  #First we have to store the current profile so we can restore it when done
  set rcfg_profile_cnt [ip_get "parameter.rcfg_profile_cnt.value"] 
  for {set profile 0} {$profile < $rcfg_profile_cnt} {incr profile} {
    action_refresh_profile $profile
  }
}

## 
# this function is shared 
# used to show warning messages to user, related to merging
# called from validation callbacks of "set_capability_reg_enable" "set_csr_soft_logic_enable" "set_prbs_soft_logic_enable" "set_rcfg_emb_strm_enable" "rcfg_shared" "rcfg_jtag_enable"
proc ::altera_xcvr_native_vi::parameters::display_no_merging_message { param_name param_value isTx {additional_info ""}} {
  set common_str2 "since the parameter [::alt_xcvr::ip_tcl::messages::get_parameter_display_string ${param_name} ] is set to [::alt_xcvr::ip_tcl::messages::get_value_display_string ${param_name} ${param_value}]." 
  if {$isTx} {
    ip_message warning "This TX Simplex Native PHY instance cannot be merged with an RX Simplex Native PHY instance or a CDR PLL IP instance ${common_str2} ${additional_info}"
  } else {
    ip_message warning "This RX Simplex Native PHY instance cannot be merged with a TX Simplex Native PHY instance ${common_str2} ${additional_info}"
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_set_capability_reg_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_set_csr_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_set_prbs_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_set_odi_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_set_rcfg_emb_strm_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}


proc ::altera_xcvr_native_vi::parameters::validate_dbg_embedded_debug_enable { rcfg_enable duplex_mode set_capability_reg_enable set_csr_soft_logic_enable set_prbs_soft_logic_enable set_rcfg_emb_strm_enable set_odi_soft_logic_enable rcfg_jtag_enable enable_odi_accelerator } {
  if { $rcfg_enable } {
    set lcl_embedded_debug_enable [expr $set_capability_reg_enable || $set_csr_soft_logic_enable || $set_prbs_soft_logic_enable || $set_rcfg_emb_strm_enable || ($set_odi_soft_logic_enable && $enable_odi_accelerator) ]
    ip_set "parameter.dbg_embedded_debug_enable.value" $lcl_embedded_debug_enable        
  } else {
    ip_set "parameter.dbg_embedded_debug_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_capability_reg_enable { rcfg_enable set_capability_reg_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_capability_reg_enable.value" $set_capability_reg_enable
  } else {
    ip_set "parameter.dbg_capability_reg_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_user_identifier { rcfg_enable dbg_capability_reg_enable set_user_identifier } {
  if { $rcfg_enable && $dbg_capability_reg_enable } {
    ip_set "parameter.dbg_user_identifier.value" $set_user_identifier
  } else {
    ip_set "parameter.dbg_user_identifier.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_ctrl_soft_logic_enable { rcfg_enable set_csr_soft_logic_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_ctrl_soft_logic_enable.value" $set_csr_soft_logic_enable
  } else {
    ip_set "parameter.dbg_ctrl_soft_logic_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_stat_soft_logic_enable { rcfg_enable set_csr_soft_logic_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_stat_soft_logic_enable.value" $set_csr_soft_logic_enable
  } else {
    ip_set "parameter.dbg_stat_soft_logic_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_prbs_soft_logic_enable { rcfg_enable set_prbs_soft_logic_enable } {
  if { $rcfg_enable } {
    ip_set "parameter.dbg_prbs_soft_logic_enable.value" $set_prbs_soft_logic_enable
  } else {
    ip_set "parameter.dbg_prbs_soft_logic_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_dbg_odi_soft_logic_enable { rcfg_enable set_odi_soft_logic_enable enable_odi_accelerator } {
  if { $rcfg_enable && $enable_odi_accelerator} {
    ip_set "parameter.dbg_odi_soft_logic_enable.value" $set_odi_soft_logic_enable
  } else {
    ip_set "parameter.dbg_odi_soft_logic_enable.value" 0
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_adme_prot_mode { protocol_mode } {
  ip_set "parameter.adme_prot_mode.value" $protocol_mode
}


proc ::altera_xcvr_native_vi::parameters::validate_adme_data_rate { set_data_rate } {
  if {[string is double $set_data_rate]} {
    set temp [expr {wide(double($set_data_rate) * 1000000)}]
    ip_set "parameter.adme_data_rate.value" $temp
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_rcfg_emb_strm_enable { rcfg_enable rcfg_multi_enable set_rcfg_emb_strm_enable } {
  if { $rcfg_enable && $rcfg_multi_enable } {
    ip_set "parameter.rcfg_emb_strm_enable.value" $set_rcfg_emb_strm_enable
  } else {
    ip_set "parameter.rcfg_emb_strm_enable.value" 0
  }
}

#************* End dynamic reconfiguration validation callbacks ***************
#******************************************************************************

#******************************************************************************
#*************** Analog Settings validation and action callbacks *****************
proc ::altera_xcvr_native_vi::parameters::parameter_update_action_anlg_tx_analog_mode { context } {

  # Get the analog atom params defined in parameter tables
  set criteria [dict create M_TX_ANALOG_MODE_SETTING 1]
  set anlg_mode_params [ip_get_matching_parameters $criteria]

  # Get the GUI selection for analog mode and set the atom parameter to that explicitely 
  set analog_mode_gui_value [ip_get "parameter.anlg_tx_analog_mode.value"]
  ip_set "parameter.pma_tx_buf_xtx_path_analog_mode.value" $analog_mode_gui_value

  # Get the GUI selection for override checkbox and set the atom parameters to that explicitely
  set ovr_gui_value [ip_get "parameter.anlg_enable_tx_default_ovr.value"]
  # Do the explicit mapping again here as the atom parameter mapping (M_MAP_VALUES) in the table does not take effect yet.
  if { $ovr_gui_value } {
    set opt_atom_value "false"
  } else {
    set opt_atom_value "true"
  }
  ip_set "parameter.pma_tx_buf_xtx_path_optimal.value" $opt_atom_value
  ip_set "parameter.pma_tx_buf_optimal.value" $opt_atom_value

  # Perform the getValue and loading the GUI values only if override is not checked => optimal=true needed for converging analog mode settings 
  if { !$ovr_gui_value } {
    # Get values of each of the param that is dependent on analog_mode and load the value
    # There are few possibilities here:
    #   1. GUI params that are dependent on analog_mode    
    #          -> part of anlg_mode_params above and will be set by ip_set below. ok. 
    #   2. Non-GUI parameters are dependent on analog_mode 
    #          -> will be set by ip_set when their own validation callback runs due to change in analog_mode. Ok. 
    #   3. GUI parameters that are dependent on other gui/non-gui parameters that are dependent on analog_mode
    #          -> these wont have analog_mode as antecedent. None present. Even if it does, validation callback for that parameter will report error.
    #   4. Non-GUI parameters that are dependent on other gui/non-gui parameters that are dependent on analog_mode 
    #          -> these wont have analog_mode as antecedent.  will be set by ip_set when their own validation callback runs due to change in antecedent param due to analog_mode. Ok.
    foreach anlg_mode_param $anlg_mode_params {
    	set antecedents [info args ::nf_xcvr_native::parameters::getValue_${anlg_mode_param}]
      set antecedents_value ""
      foreach ant $antecedents {
        lappend antecedents_value [ip_get "parameter.${ant}.value"]
      }
    
      # Need to pass the list of antecedents_value to the getValue proc which accepts just independent arguments for the values. 
      # Therefore, using concat to construct the command to call the getValue proc and eval to execute it
      set cmd ""
      set cmd [concat $cmd "set anlg_mode_param_value \[::nf_xcvr_native::parameters::getValue_${anlg_mode_param} $antecedents_value\]"]
      eval $cmd

 
      # if the getValue returns more than one value (it should not, but just in case), pick index 0
      if { [llength $anlg_mode_param_value] > 1 } {
        set anlg_mode_param_value [lindex $anlg_mode_param_value 0]
      }

      #Update the atom param value
      ip_set "parameter.${anlg_mode_param}.value" $anlg_mode_param_value
      #Update the GUI param value explicitely.
      set gui_param [ip_get "parameter.${anlg_mode_param}.M_MAPS_FROM"]
      #For all the analog QSF attributes, GUI <-> atom value mapping is 1:1. Therefore, there is no need to do manual mapping.
      ip_set "parameter.${gui_param}.value" $anlg_mode_param_value
    
      set atom_param_value [ip_get "parameter.${anlg_mode_param}.value"]
      set gui_param_value [ip_get "parameter.${gui_param}.value"]
    }
  } else {
  }
}

# @param tx_enable - Resolved value of the tx_enable parameter
# @param rcfg_enable - User selected rcfg_enable value
# @param enable_analog_settings - User selected enable_analog_settings value
proc ::altera_xcvr_native_vi::parameters::validate_l_anlg_tx_enable { tx_enable rcfg_enable enable_analog_settings } {
  ip_set "parameter.l_anlg_tx_enable.value" [expr $tx_enable && $rcfg_enable && $enable_analog_settings ]
}

# @param rx_enable - Resolved value of the tx_enable parameter
# @param rcfg_enable - User selected rcfg_enable value
# @param enable_analog_settings - User selected enable_analog_settings value
proc ::altera_xcvr_native_vi::parameters::validate_l_anlg_rx_enable { rx_enable rcfg_enable enable_analog_settings } {
  ip_set "parameter.l_anlg_rx_enable.value" [expr $rx_enable && $rcfg_enable && $enable_analog_settings ]
}

#Validate DFE tap co-efficient selection
#Grey-out selection for higher taps if the number of taps selected by the user in the RX PMA tab is lesser
proc ::altera_xcvr_native_vi::parameters::validate_anlg_rx_adp_dfe_fxtap { PROP_NAME PROP_M_CONTEXT rx_pma_dfe_adaptation_mode rx_pma_dfe_fixed_taps } {
  if { $rx_pma_dfe_adaptation_mode == "manual" && $PROP_M_CONTEXT <= $rx_pma_dfe_fixed_taps } {
      ip_set "parameter.${PROP_NAME}.ENABLED" 1
  } else {
      ip_set "parameter.${PROP_NAME}.ENABLED" 0
  }
}

##
# Validate power_mode of Tx and Rx depending on speedgrade
# In ICD RBC, power_mode is user selectable and speedgrade depends on it. However, that does not work well with the IP usemodel where user selects speedgrade first and then the power mode.
# Therefore, writing a custom validation callback based on the speedgrade ICD RBC to check the other way
# Default value maintains the old optimistic value = high_perf
# NOTE: this function needs to be updated if ICD RBC rule changes
proc ::altera_xcvr_native_vi::parameters::validate_pma_power_mode { PROP_NAME PROP_VALUE PROP_M_AUTOSET PROP_M_AUTOWARN pma_speedgrade } {
   set legal_values [list "high_perf" "mid_power" "low_power"]
  
   set illegal_values_for_high_perf [list "e1" "i1" "i2" "i3" "i4"]
   if { [lsearch $illegal_values_for_high_perf $pma_speedgrade] != -1  } {
      set legal_values [::nf_xcvr_native::parameters::exclude $legal_values [list "high_perf"]]
   }

  if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.${PROP_NAME}.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter anlg_voltage cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values { pma_speedgrade }
   }

}


# Display Analog Options message for the common Voltage and Link
# Only used to display message  
proc ::altera_xcvr_native_vi::parameters::validate_display_analog_options_msg { } {
  set message "<html><font color=\"red\">Note - </font>The above options are only used for GUI rule validation. Use Quartus II Setting File (.qsf) assignments to set these parameters in your static design.</html>"
  ip_set "display_item.display_analog_options_msg.text" $message
}

# Display Analog Options message for the common Voltage and Link
# Only used to display message  
proc ::altera_xcvr_native_vi::parameters::validate_display_anlg_voltage_msg { anlg_voltage device } {
  if {[::alt_xcvr::utils::device::is_a10_gt $device] == 0 && ${anlg_voltage} == "1_1V"} {
    set message "<html><font color=\"red\">Note - </font>For Arria10 GX/SX devices, 1_1V is not a valid option for supply voltage ([ip_get "parameter.anlg_voltage.display_name"]) </html>"
    ip_set "display_item.display_anlg_voltage_msg.text" $message
    ip_message warning $message
  } else {
    ip_set "display_item.display_anlg_voltage_msg.text" ""
  }
}


# Display Analog Options message for the optional checkbox to include the settings in the MIF
# Only used to display message  
proc ::altera_xcvr_native_vi::parameters::validate_display_analog_options_mif_msg { } {
  set message "<html><font color=\"red\">Note - </font>The below analog parameters will be included in the generated configuration files. Use Quartus II Setting File (.qsf) assignments to set these parameters in your static design.</html>"
  ip_set "display_item.display_analog_options_mif_msg.text" $message
}

# Display warning message if analog_mode is changed with Override option checked => no settings will be auto-loaded in the GUI
proc ::altera_xcvr_native_vi::parameters::validate_anlg_tx_analog_mode { anlg_enable_tx_default_ovr } {
  if { $anlg_enable_tx_default_ovr } {
    ip_message warning "The TX swing settings are not loaded automatically based on the \"Analog Mode\" user selection because \"Override Altera-recommended Analog Mode Default Settings\" option is checked. Uncheck this option to have the pre-selected values loaded for the selected \"Analog Mode\"."
  }
}

#***************** End Analog Settings validation callbacks *******************
#******************************************************************************

#******************************************************************************
#******************************************************************************
#********************** RBC Validation Override Callbacks *********************
proc ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx { datapath_select hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx } {
  set value [expr {$datapath_select == "Enhanced" ? $hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx 
                 : $datapath_select == "Standard" ? $hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx 
                 : "fastreg_tx" }]

  ip_set "parameter.hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx { datapath_select hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx } {
  set value [expr {$datapath_select == "Enhanced" ? $hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx 
                 : $datapath_select == "Standard" ? $hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx 
                 : "reg_rx" }]

  ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_pma_cgb_input_select_x1 { bonded_mode pll_select } {
  set value [ expr { $bonded_mode != "not_bonded" ? "unused"
    : $pll_select == "0" ? "fpll_bot"
    : $pll_select == "1" ? "lcpll_bot"
    : $pll_select == "2" ? "fpll_top"   
    : $pll_select == "3" ? "lcpll_top"
      : "fpll_bot" }]

  ip_set "parameter.pma_cgb_input_select_x1.value" $value
}


proc ::altera_xcvr_native_vi::parameters::validate_pma_cgb_input_select_gen3 { bonded_mode l_enable_std_pipe protocol_mode } {
  set value [ expr { ($bonded_mode == "not_bonded") && $l_enable_std_pipe && ($protocol_mode == "pipe_g3") ? "lcpll_bot"
      : "unused" }]

  ip_set "parameter.pma_cgb_input_select_gen3.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_pma_rx_deser_pcie_gen { PROP_NAME set_cdr_refclk_freq l_enable_std_pipe protocol_mode } {
  # possible values {non_pcie pcie_gen1_100mhzref pcie_gen1_125mhzref pcie_gen2_100mhzref pcie_gen2_125mhzref pcie_gen3_100mhzref pcie_gen3_125mhzref}
  set value "non_pcie"
  if {$l_enable_std_pipe} {
    set pcie_str [expr {$protocol_mode == "pipe_g1" ? "pcie_gen1"
      : $protocol_mode == "pipe_g2" ? "pcie_gen2"
      : "pcie_gen3"}]
    set refclk_str [expr { [regexp {125\.} $set_cdr_refclk_freq] ? "125mhzref" : "100mhzref" }]
    set value "${pcie_str}_${refclk_str}"
  }

  ip_set "parameter.${PROP_NAME}.value" $value
}

## once rbc is fixed remove this (add here the FB case number)
proc ::altera_xcvr_native_vi::parameters::validate_pma_rx_deser_bitslip_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN pma_rx_deser_bitslip_bypass protocol_mode enable_port_rx_pma_clkslip} {
   set legal_values [list "bs_bypass_no" "bs_bypass_yes"]
   if [expr { ($protocol_mode=="cpri") || ($protocol_mode=="cpri_rx_tx") || ($enable_port_rx_pma_clkslip==1) }] {
      set legal_values [list "bs_bypass_no"]
   } else {
      set legal_values [list "bs_bypass_yes"]
   }
 
   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_bitslip_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter protocol_mode cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_bitslip_bypass $pma_rx_deser_bitslip_bypass $legal_values { protocol_mode enable_port_rx_pma_clkslip }
   }
}


proc ::altera_xcvr_native_vi::parameters::validate_pma_tx_ser_ser_clk_divtx_user_sel { tx_enable enable_port_tx_pma_div_clkout tx_pma_div_clkout_divider } {
  set value [expr {!$tx_enable || !$enable_port_tx_pma_div_clkout ? "divtx_user_off"
    : $tx_pma_div_clkout_divider == "1" ? "divtx_user_1"
    : $tx_pma_div_clkout_divider == "2" ? "divtx_user_2"
    : $tx_pma_div_clkout_divider == "33" ? "divtx_user_33"
    : $tx_pma_div_clkout_divider == "40" ? "divtx_user_40"
    : $tx_pma_div_clkout_divider == "66" ? "divtx_user_66"
    : "divtx_user_off" }]

  ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_pipe_gen1_2_txswing { protocol_mode enable_hip } {
  set value [ expr { !$enable_hip && ($protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2") ? "en_txswing"
    : "dis_txswing" }]

  ip_set "parameter.hssi_pipe_gen1_2_txswing.value" $value
}

proc ::altera_xcvr_native_vi::parameters::validate_cdr_pll_m_counter { l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.cdr_pll_m_counter.value" [dict get $l_pll_settings $l_pll_settings_key m]
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_cdr_pll_n_counter_scratch { l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.cdr_pll_n_counter_scratch.value" [dict get $l_pll_settings $l_pll_settings_key n]
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_cdr_pll_lpd_counter { l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.cdr_pll_lpd_counter.value" [dict get $l_pll_settings $l_pll_settings_key lpd]
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_cdr_pll_lpfd_counter { l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.cdr_pll_lpfd_counter.value" [dict get $l_pll_settings $l_pll_settings_key lpfd]
  }
}

proc ::altera_xcvr_native_vi::parameters::validate_cdr_pll_pcie_gen { PROP_NAME set_cdr_refclk_freq l_enable_std_pipe protocol_mode } {
  # possible values {non_pcie pcie_gen1_100mhzref pcie_gen1_125mhzref pcie_gen2_100mhzref pcie_gen2_125mhzref pcie_gen3_100mhzref pcie_gen3_125mhzref}
  set value "non_pcie"
  if {$l_enable_std_pipe} {
    set pcie_str [expr {$protocol_mode == "pipe_g1" ? "pcie_gen1"
      : $protocol_mode == "pipe_g2" ? "pcie_gen2"
      : "pcie_gen3"}]
    set refclk_str [expr { [regexp {125\.} $set_cdr_refclk_freq] ? "125mhzref" : "100mhzref" }]
    set value "${pcie_str}_${refclk_str}"
  }

  ip_set "parameter.${PROP_NAME}.value" $value
}

## once rbc is fixed remove this (FB: 180321)
proc ::altera_xcvr_native_vi::parameters::validate_hssi_10g_tx_pcs_gb_pipeln_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_10g_tx_pcs_gb_pipeln_bypass hssi_10g_tx_pcs_bitslip_en hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_low_latency_en} {
   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_10g_tx_pcs_bitslip_en=="bitslip_en")||($hssi_10g_tx_pcs_prot_mode=="disable_mode")) }] {
      set legal_values [list "disable"]
   } else {
      if [expr { (($hssi_10g_tx_pcs_low_latency_en=="enable")&&($hssi_10g_tx_pcs_prot_mode!="teng_baser_mode")) }] {
         set legal_values [list "enable"]
      } else {
         set legal_values [list "disable"]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_tx_pcs_gb_pipeln_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter hssi_10g_tx_pcs_gb_pipeln_bypass cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto hssi_10g_tx_pcs_gb_pipeln_bypass $hssi_10g_tx_pcs_gb_pipeln_bypass $legal_values { enh_low_latency_enable}
   }
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_krfec_rx_pcs_error_marking_en { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode enh_low_latency_enable} {
   set legal_values [list "err_mark_dis" "err_mark_en"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
     if {$enh_low_latency_enable == 1} {
        set legal_values [list "err_mark_dis"]
     } else {
        if { $hssi_krfec_rx_pcs_prot_mode=="basic_mode" } {
          set legal_values [list "err_mark_en" "err_mark_dis"]
        } else {
          set legal_values [list "err_mark_en"]
        }
     }
   } else {
      set legal_values [list "err_mark_dis"]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_error_marking_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter hssi_krfec_rx_pcs_error_marking_en cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_error_marking_en $hssi_krfec_rx_pcs_error_marking_en $legal_values { hssi_krfec_rx_pcs_prot_mode enh_low_latency_enable}
   }
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel { hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel datapath_select l_enable_tx_enh l_enable_tx_std l_enable_tx_pcs_dir hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx} {
   set temp "one_ff_delay"

   if {$datapath_select == "Enhanced"} {
      set temp [expr {($l_enable_tx_enh && $hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx == "fastreg_tx") ? "two_ff_delay" : "one_ff_delay"}]
   } elseif {$datapath_select == "Standard"} {
      set temp [expr {($l_enable_tx_std && $hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx == "fastreg_tx") ? "two_ff_delay" : "one_ff_delay"}]
   } elseif {$datapath_select == "PCS Direct"} {
      set temp [expr {$l_enable_tx_pcs_dir ? "two_ff_delay" : "one_ff_delay"}]
   }

   ip_set "parameter.hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel.value" $temp
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl { hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl datapath_select l_enable_tx_enh l_enable_tx_std l_enable_tx_pcs_dir hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx} {
   set temp "delay1_path0"

   if {$datapath_select == "Enhanced"} {
      set temp [expr {($l_enable_tx_enh && $hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx == "fastreg_tx") ? "delay1_path1" : "delay1_path0"}]
   } elseif {$datapath_select == "Standard"} {
      set temp [expr {($l_enable_tx_std && $hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx == "fastreg_tx") ? "delay1_path1" : "delay1_path0"}]
   } elseif {$datapath_select == "PCS Direct"} {
      set temp [expr {$l_enable_tx_pcs_dir ? "delay1_path1" : "delay1_path0"}]
   }

   ip_set "parameter.hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl.value" $temp
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl { hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl datapath_select l_enable_tx_enh l_enable_tx_std l_enable_tx_pcs_dir hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx} {
   set temp "delay2_path0"

   if {$datapath_select == "Enhanced"} {
      set temp [expr {($l_enable_tx_enh && $hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx == "fastreg_tx") ? "delay2_path3" : "delay2_path0"}]
   } elseif {$datapath_select == "Standard"} {
      set temp [expr {($l_enable_tx_std && $hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx == "fastreg_tx") ? "delay2_path3" : "delay2_path0"}]
   } elseif {$datapath_select == "PCS Direct"} {
      set temp [expr {$l_enable_tx_pcs_dir ? "delay2_path3" : "delay2_path0"}]
   }

   ip_set "parameter.hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl.value" $temp
}

proc ::altera_xcvr_native_vi::parameters::validate_hssi_8g_rx_pcs_wa_det_latency_sync_status_beh { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_8g_rx_pcs_wa_det_latency_sync_status_beh std_rx_word_aligner_fast_sync_status_enable hssi_8g_rx_pcs_prot_mode} {
   set legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm" "dont_care_assert_sync"]
   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      if {$std_rx_word_aligner_fast_sync_status_enable} {
         set legal_values [list "assert_sync_status_imm"]
      } else {
         set legal_values [list "assert_sync_status_non_imm"]
      }
   } else {
      set legal_values [list "dont_care_assert_sync"]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_det_latency_sync_status_beh.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter hssi_8g_rx_pcs_wa_det_latency_sync_status_beh cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $legal_values { std_rx_word_aligner_fast_sync_status_enable hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::altera_xcvr_native_vi::parameters::validate_vga { anlg_rx_adp_vga_sel } { 
   if [expr { $anlg_rx_adp_vga_sel=="radp_vga_sel_5" || $anlg_rx_adp_vga_sel=="radp_vga_sel_6" || $anlg_rx_adp_vga_sel=="radp_vga_sel_7" } ] {
      ip_message warning "VGA gain setting of 5, 6 or 7 is being used. Please refer to device lifetime guidance in \"Errata and design guidelines\" to ensure system requirements are met."
   } 
}

# see FB: 151704 to understand why this needs to happen
# removed the dependency to hssi_10g_tx_pcs_pld_if_type from the original rule
proc ::altera_xcvr_native_vi::parameters::validate_hssi_10g_tx_pcs_txfifo_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_tx_pcs_txfifo_mode hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [::nf_xcvr_native::parameters::convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [::nf_xcvr_native::parameters::convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "basic_generic" "interlaken_generic" "phase_comp" "register_mode"]
   
   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [list "interlaken_generic"]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="basic_mode") }] {
         if [expr { (($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67")) }] {
            set legal_values [list "basic_generic"]
         } else {
            set legal_values [list "basic_generic" "phase_comp"]
         }
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode")) }] {
            set legal_values [list "phase_comp"]
         } else {
            if [expr { ($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode") }] {
               set legal_values [list "basic_generic" "phase_comp"]
            } else {
               set legal_values [list "phase_comp"]
            }
         }
      }
   }

   # this does not mean register mode is allowed for all cases- register mode is handled at hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx
   lappend legal_values "register_mode"
   
   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_tx_pcs_txfifo_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter hssi_10g_tx_pcs_txfifo_mode cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto hssi_10g_tx_pcs_txfifo_mode $hssi_10g_tx_pcs_txfifo_mode $legal_values { hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode }
   }
}

# see FB: 151704 to understand why this needs to happen
# removed the dependency to hssi_10g_rx_pcs_pld_if_type from the original rule
proc ::altera_xcvr_native_vi::parameters::validate_hssi_10g_rx_pcs_rxfifo_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [::nf_xcvr_native::parameters::convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [::nf_xcvr_native::parameters::convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]
   
   set legal_values [list "clk_comp_10g" "generic_basic" "generic_interlaken" "phase_comp" "phase_comp_dv" "register_mode"]
   
   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [list "generic_interlaken"]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="basic_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [list "generic_basic" "phase_comp"]
            } else {
               set legal_values [list "generic_basic" "phase_comp" "phase_comp_dv"]
            }
         } else {
            if [expr { (($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")) }] {
               set legal_values [list "generic_basic"]
            } else {
               set legal_values [list "generic_basic" "phase_comp"]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [list "clk_comp_10g" "phase_comp"]
            } else {
               set legal_values [list "clk_comp_10g"]
            }
         } else {
            if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
               if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                  set legal_values [list "phase_comp" "phase_comp_dv"]
               } else {
                  set legal_values [list "phase_comp"]
               }
            } else {
               if [expr { ($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode") }] {
                  set legal_values [list "generic_basic" "phase_comp"]
               } else {
                  set legal_values [list "phase_comp"]
               }
            }
         }
      }
   }
   
   # this does not mean register mode is allowed for all cases- register mode is handled at hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx
   lappend legal_values "register_mode"
   
   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rxfifo_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter hssi_10g_rx_pcs_rxfifo_mode cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_rxfifo_mode $legal_values { hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}


#******************** End RBC Validation Override Callbacks *******************
#******************************************************************************

proc ::altera_xcvr_native_vi::parameters::auto_set_allowed_ranges { param_name param_value param_allowed_ranges } {
  if { [lsearch $param_allowed_ranges $param_value] == -1 } {
    lappend param_allowed_ranges $param_value
  }
  ip_set "parameter.${param_name}.allowed_ranges" $param_allowed_ranges
}
#********************** End Validation Callbacks ******************************
#******************************************************************************


#******************************************************************************
#*************************** Test Functions ***********************************

##
# currently unmap functions for adaptation parameters are tested only through the RBCs, (which is not extensive)
# since RBCs are changing and these functions are complex, it will be handy to have this test function available
# this is a manual test, to make it work this function must be registered as a validation callback to the parameters listed below and legal values should be changed manually
# the default is all available options are listed as valid as well as a dummy option to see the effects if there is a new enumaration is added to the parameter
proc ::altera_xcvr_native_vi::parameters::adaptation_unmap_test { PROP_NAME PROP_VALUE} {
  if {$PROP_NAME == "pma_adapt_adapt_mode"} {  
    set legal_values [list "dummy" "manual" "dfe_vga" "ctle" "ctle_vga" "ctle_vga_dfe"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_adapt_adp_dfe_mode"} {
    set legal_values [list "dummy" "radp_dfe_mode_0" "radp_dfe_mode_1" "radp_dfe_mode_2" "radp_dfe_mode_3" "radp_dfe_mode_4" "radp_dfe_mode_5" "radp_dfe_mode_6" "radp_dfe_mode_7"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_fixedtap"} {
    set legal_values [list "dummy" "fixtap_dfe_enable" "fixtap_dfe_powerdown"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_fxtap4t7"} {
    set legal_values [list "dummy" "fxtap4t7_enable" "fxtap4t7_powerdown"]  
#    set legal_values [list "dummy"]

  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_floattap"} {
    set legal_values [list "dummy" "floattap_dfe_enable" "floattap_dfe_powerdown"]  
#    set legal_values [list "dummy"]

  } else {  
    set legal_values [list "dummy"]
    
  }
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { }
}
