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


package provide alt_eth_ultra::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::common
package require alt_xcvr::utils::device

namespace eval ::alt_eth_ultra::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_parameters \
    validate

  variable package_name
  variable val_prefix
  variable display_items
  variable parameters

  set package_name "alt_eth_ultra::parameters"

    set display_items {\
        {NAME                                           GROUP               TYPE    ARGS    VISIBLE             }\
        {"IP"                                           ""                  GROUP   tab     true                }\
        {"Main"                                         "IP"                GROUP   tab     true                }\
        {"40GBASE-KR4"                                  "IP"                GROUP   tab     "TARGET_CHIP == 5"  }\
        {"General Options"                              "Main"              GROUP   NOVAL   true                }\
        {"PCS/PMA Options"                              "Main"              GROUP   NOVAL   true                }\
        {"Flow Control Options"                         "Main"              GROUP   NOVAL   true                }\
        {"MAC Options"                                  "Main"              GROUP   NOVAL   true                }\
        {"KR4 General Options"                          "40GBASE-KR4"       GROUP   NOVAL   "TARGET_CHIP == 5"  }\
        {"Auto-Negotiation"                             "40GBASE-KR4"       GROUP   NOVAL   "TARGET_CHIP == 5"  }\
        {"Link Training"                                "40GBASE-KR4"       GROUP   NOVAL   "TARGET_CHIP == 5"  }\
        {"FEC Options"                                  "40GBASE-KR4"       GROUP   NOVAL   "TARGET_CHIP == 5"  }\
        {"PMA parameters"                               "Link Training"     GROUP   NOVAL   "TARGET_CHIP == 5"  }\
        {"Example Design"                               ""                  GROUP   tab     "TARGET_CHIP == 5"  }\
        {"Available Example Designs"                    "Example Design"    GROUP   NOVAL   true                }\
        {"Example Design Files"                         "Example Design"    GROUP   NOVAL   true                }\
        {"Generated HDL Format"                         "Example Design"    GROUP   NOVAL   true                }\
        {"Target Development Kit"                       "Example Design"    GROUP   NOVAL   true                }\
        {"Debug"                                        ""                  GROUP   tab     SHOW_DEBUG_TAB      }\
        {"Configuration, Debug and Extension Options"   "Main"              GROUP   NOVAL   true                }\
    }
    
    set parameters {\
        {NAME                   DERIVED HDL_PARAMETER   TYPE    DEFAULT_VALUE       ALLOWED_RANGES                                                                  ENABLED                                                 VISIBLE                             DISPLAY_HINT    DISPLAY_UNITS                           DISPLAY_ITEM                    DISPLAY_NAME                                            VALIDATION_CALLBACK                                     UNITS       DESCRIPTION }\
        
        {DEVICE_FAMILY          false   false           STRING  NOVAL               {"Stratix V" "Arria 10"}                                                        false                                                   true                                "Device Family" NOVAL                                   "General Options"               "Device family"                                         ::alt_eth_ultra::parameters::v_DEV_FAM                  NOVAL       "Only Stratix V, Arria 10 devices are supported"}\
        {part_trait_bd          false   false           STRING  "Unknown"           NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   NOVAL                                                   NOVAL       NOVAL }\
        {DEVICE                 false   false           STRING  "Unknown"           NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::chk_dev_unknown            NOVAL       NOVAL }\
        {SHOW_DEBUG_TAB         true    false           STRING  "false"             NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::chk_qii_ini                NOVAL       NOVAL                                }\
        {ENABLE_ALL_ED          true    false           STRING  "false"             NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::chk_qii_ini                NOVAL       NOVAL                                }\
        {OVERRIDE_PART_NUM      false   false           integer 0                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "Debug"                         NOVAL                                                   NOVAL                                                   NOVAL       ""                                   }\
        {ES_DEVICE              true    true            INTEGER 1                   NOVAL                                                                           false                                                   false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   NOVAL                                                   NOVAL       NOVAL }\
        {SPEED_CONFIG           false   false           STRING  "100 GbE"           {"100 GbE" "40 GbE"}                                                            true                                                    true                                NOVAL           NOVAL                                   "General Options"               "Protocol speed"                                        ::alt_eth_ultra::parameters::v_SPEED_CONFIG             NOVAL       "Select Ethernet protocol speed"}\
        {SYNOPT_AVALON          false   true            integer 1                   {"0:Custom-ST" "1:Avalon-ST"}                                                   true                                                    true                                NOVAL           NOVAL                                   "General Options"               "Data interface"                                        ::alt_eth_ultra::parameters::v_SYNOPT_AVALON            NOVAL       "Select data interface"}\
        {SYNOPT_CAUI4           false   true            integer 0                   NOVAL                                                                           true                                                    "TARGET_CHIP == 5 && IS_100G"       boolean         NOVAL                                   "PCS/PMA Options"               "Enable CAUI4 PCS"                                      ::alt_eth_ultra::parameters::v_CAUI4                    NOVAL       ""}\
        {SYNOPT_CAUI4_DISABLED  true    false           integer 0                   NOVAL                                                                           false                                                   "TARGET_CHIP == 5 && !IS_100G"      boolean         NOVAL                                   "PCS/PMA Options"               "Enable CAUI4 PCS"                                      NOVAL                                                   NOVAL       ""}\
        {SYNOPT_C4_RSFEC        false   true            integer 0                   NOVAL                                                                           "SYNOPT_CAUI4 && IS_100G"                               "TARGET_CHIP == 5"                  boolean         NOVAL                                   "PCS/PMA Options"               "Enable RS-FEC for CAUI4"                               ::alt_eth_ultra::parameters::v_C4_RSFEC                 NOVAL       ""}\
        {SYNOPT_SYNC_E          false   true            integer 0                   NOVAL                                                                           "TARGET_CHIP==5"                                        true                                boolean         NOVAL                                   "PCS/PMA Options"               "Enable SyncE"                                          NOVAL                                                   NOVAL       "Enables clk_rx_recover port for synchronous Ethernet support"}\
        {PHY_PLL                false   false           STRING  "ATX"               {"ATX" "CMU"}                                                                   false                                                   "TARGET_CHIP == 2"                  "PHY PLL TYPE"  NOVAL                                   "PCS/PMA Options"               "PHY PLL type"                                          NOVAL                                                   NOVAL       "PHY PLL configuration"}\
        {PHY_REFCLK             false   true            INTEGER 1                   {1:644.53125 2:322.265625}                                                      true                                                    true                                NOVAL           NOVAL                                   "PCS/PMA Options"               "PHY reference frequency"                               NOVAL                                                   Megahertz   "PHY clk_ref reference frequency"}\
        {REF_CLK_FREQ_10G       true    true            STRING  "644.53125 MHz"     {"644.53125 MHz" "322.265625 MHz"}                                              true                                                    false                               NOVAL           NOVAL                                   "PCS/PMA Options"               "PHY reference frequency"                               ::alt_eth_ultra::parameters::v_REF_CLK_FREQ_10G         Megahertz   "PHY clk_ref reference frequency"}\
        {ADME_ENABLE            false   false           INTEGER  0                  NOVAL                                                                           true                                                    true                                boolean         NOVAL               "Configuration, Debug and Extension Options"        "Enable Altera Debug Master Endpoint (ADME)"            NOVAL                                                   NOVAL       "When on, an embedded Altera Debug Master Endpoint (ADME) connects internally to the Avalon-MM slave interface for the dynamic reconfiguration. The ADME can access the reconfiguration space of the transceiver. It can perform certain tests and debug functions via JTAG using System Console." }\
        {ODI_UNHIDE             true    false           INTEGER  0                  NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::chk_qii_ini                NOVAL       NOVAL}\
        {ODI_ENABLE             false   false           INTEGER  0                  NOVAL                                                                           true                                                    ODI_UNHIDE                          boolean         NOVAL               "Configuration, Debug and Extension Options"        "Enable ODI(On Die Instrumentation) acceleration logic" ::alt_eth_ultra::parameters::validate_odi_en            NOVAL       "Enables soft logic for accelerating bit and error accumulation when using ODI."}\
        {ODI_ENABLE_effective   true    false           INTEGER  0                  NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   NOVAL                           NOVAL                                                   NOVAL                                                   NOVAL       NOVAL}\
        {EXT_TX_PLL             false   true            integer 0                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "PCS/PMA Options"               "Use external TX MAC PLL"                               ::alt_eth_ultra::parameters::v_EXT_TX_PLL               NOVAL       "If selected, IP will use MAC TX clock from clk_txmac_in rather than from an internal PLL"}\
        {SYNOPT_PAUSE_TYPE      false   true            integer 0                   {0:No\ flow\ control 1:Standard\ flow\ control 2:Priority-based\ flow\ control} SYNOPT_AVALON                                           true                                NOVAL           NOVAL                                   "Flow Control Options"          "Flow control mode"                                     NOVAL                                                   NOVAL       ""}\
        {DISP_FCBITS            false   false           integer 8                   {1:8}                                                                           "SYNOPT_PAUSE_TYPE == 2 && SYNOPT_AVALON == 1"          true                                integer         NOVAL                                   "Flow Control Options"          "Number of PFC queues"                                  NOVAL                                                   NOVAL       ""}\
        {SYNOPT_AVG_IPG         false   true            integer 12                  {"0:Disable deficit idle counter" "8"     "12"}                                 true                                                    true                                NOVAL           NOVAL                                   "Flow Control Options"          "Average interpacket gap"                               NOVAL                                                   NOVAL       ""}\
        {SYNOPT_PTP             false   true            integer 0                   NOVAL                                                                           SYNOPT_AVALON                                           true                                boolean         NOVAL                                   "MAC Options"                   "Enable 1588 PTP"                                       NOVAL                                                   NOVAL       ""}\
        {SYNOPT_96B_PTP         false   true            integer 1                   NOVAL                                                                           "SYNOPT_AVALON && SYNOPT_PTP"                           true                                boolean         NOVAL                                   "MAC Options"                   "Enable 96b Time of Day Format"                         ::alt_eth_ultra::parameters::v_SYNOPT_B                 NOVAL       ""}\
        {SYNOPT_64B_PTP         false   true            integer 0                   NOVAL                                                                           "SYNOPT_AVALON && SYNOPT_PTP"                           true                                boolean         NOVAL                                   "MAC Options"                   "Enable 64b Time of Day Format"                         ::alt_eth_ultra::parameters::v_SYNOPT_B                 NOVAL       ""}\
        {PTP_FP_WIDTH           false   true            integer 1                   {1:16}                                                                          "SYNOPT_AVALON && SYNOPT_PTP"                           true                                integer         NOVAL                                   "MAC Options"                   "Timestamp fingerprint width:"                          NOVAL                                                   NOVAL       ""}\
        {ENA_CUSTOM_PTP         false   false           integer 0                   NOVAL                                                                           "SYNOPT_AVALON && SYNOPT_PTP"                           false                               boolean         NOVAL                                   "MAC Options"                   "Enable 1588 PTP custom interface"                      NOVAL                                                   NOVAL       ""}\
        {SYNOPT_LINK_FAULT      false   true            integer 0                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable link fault generation"                          NOVAL                                                   NOVAL       ""}\
        {SYNOPT_TXCRC_INS       false   true            integer 1                   NOVAL                                                                           "SYNOPT_PAUSE_TYPE == 0 && SYNOPT_PTP == 0"             true                                boolean         NOVAL                                   "MAC Options"                   "Enable TX CRC insertion"                               ::alt_eth_ultra::parameters::v_SYNOPT_TXCRC_INS         NOVAL       ""}\
        {SYNOPT_MAC_DIC         false   true            integer 1                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   "MAC Options"                   "Enable deficit idle counter"                           NOVAL                                                   NOVAL       ""}\
        {SYNOPT_PREAMBLE_PASS   false   true            integer 0                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable preamble passthrough"                           ::alt_eth_ultra::parameters::v_SYNOPT_PREAMBLE_PASS     NOVAL       ""}\
        {SYNOPT_ALIGN_FCSEOP    false   true            integer 1                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable alignment EOP on FCS word"                      NOVAL                                                   NOVAL       ""}\
        {SYNOPT_MAC_TXSTATS     false   true            integer 1                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable TX statistics"                                  NOVAL                                                   NOVAL       ""}\
        {SYNOPT_MAC_RXSTATS     false   true            integer 1                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable RX statistics"                                  NOVAL                                                   NOVAL       ""}\
        {SYNOPT_STRICT_SOP      false   true            integer 0                   NOVAL                                                                           true                                                    true                                boolean         NOVAL                                   "MAC Options"                   "Enable Strict SFD check"                                      NOVAL                                                   NOVAL       ""}\
        {FCBITS                 false   true            integer 1                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   "MAC Options"                   "FCBITS"                                                NOVAL                                                   NOVAL       ""}\
        {FASTSIM                true    true            integer 0                   {0     1}                                                                       true                                                    false                               NOVAL           NOVAL                                   "Main"                          "FASTSIM"                                               NOVAL                                                   NOVAL       ""}\
        {TIMING_MODE            true    true            integer 0                   {0     1}                                                                       true                                                    false                               NOVAL           NOVAL                                   "Main"                          "TIMING_MODE"                                           NOVAL                                                   NOVAL       ""}\
        {RST_CNTR               true    true            integer 16                  NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   "Main"                          "RST_CNTR"                                              NOVAL                                                   NOVAL       ""}\
        {AM_CNT_BITS            true    true            integer 14                  NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   "Main"                          "AM_CNT_BITS"                                           NOVAL                                                   NOVAL       ""}\
        {SIM_FAKE_JTAG          true    true            integer 0                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   "Main"                          "SIM_FAKE_JTAG"                                         NOVAL                                                   NOVAL       ""}\
        {CREATE_TX_SKEW         true    true            integer 0                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   "Main"                          "CREATE_TX_SKEW"                                        NOVAL                                                   NOVAL       ""}\
        {TARGET_CHIP            true    true            integer 2                   NOVAL                                                                           true                                                    false                               integer         NOVAL                                   "Main"                          "TARGET_CHIP"                                           NOVAL                                                   NOVAL       ""}\
        {IS_100G                true    false           integer 1                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::validate_IS_100G           NOVAL       ""}\
        {NOT_CAUI4              true    false           integer 1                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   NOVAL                           NOVAL                                                   NOVAL                                                   NOVAL       ""}\
        {COMPATIBLE_PORTS       false   false           integer 0                   NOVAL                                                                           true                                                    false                               boolean         NOVAL                                   NOVAL                           NOVAL                                                   NOVAL                                                   NOVAL       ""}\
        {ENA_KR4_gui            false   false           INTEGER 0                   NOVAL                                                                           false                                                   true                                BOOLEAN         NOVAL                                   "KR4 General Options"           "Enable KR4"                                            ::alt_eth_ultra::parameters::validate_ENA_KR4           NOVAL       "Enable 40GBASE-KR4 PMA, for AN, LT, FEC functionality"}\
        {ENA_KR4_OFF            true    false           INTEGER 0                   NOVAL                                                                           false                                                   false                               BOOLEAN         NOVAL                                   "KR4 General Options"           "Enable KR4"                                            ::alt_eth_ultra::parameters::validate_ENA_KR4           NOVAL       "Enable 40GBASE-KR4 PMA, for AN, LT, FEC functionality"}\
        {ENA_KR4                true    true            INTEGER 0                   NOVAL                                                                           false                                                   false                               BOOLEAN         NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::validate_ENA_KR4           NOVAL       NOVAL}\
        {UNHIDE_ADV             true    false           STRING  "false"             NOVAL                                                                           true                                                    false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::chk_qii_ini                NOVAL       NOVAL}\
        {SYNTH_SEQ              false   true            INTEGER 1                   NOVAL                                                                           ENA_KR4                                                 false                               boolean         NOVAL                                   "KR4 General Options"           "Enable KR4 Reconfiguration"                            NOVAL                                                   NOVAL       "This module controls the link-up sequence for reconfiguration into and out of the AN, LT and data modes of the 40GBASE-KR4 PHY IP Core. Must always be enabled for proper operation."}\
        {STATUS_CLK_MHZ         false   false           FLOAT   100.0               {100.0:162.0}                                                                   ENA_KR4                                                 true                                NOVAL           "MHz (Accepted range: 100.0-162.0 MHz)" "KR4 General Options"           "Status clock rate"                                     NOVAL                                                   NOVAL       "Clock rate of clk_status in MHz"}\
        {STATUS_CLK_KHZ         true    true            integer 100000              NOVAL                                                                           false                                                   false                               NOVAL           NOVAL                                   NOVAL                           NOVAL                                                   ::alt_eth_ultra::parameters::validate_STATUS_CLK_KHZ    NOVAL       NOVAL}\
        {SYNTH_FEC              false   true            INTEGER 0                   NOVAL                                                                           ENA_KR4                                                 true                                boolean         NOVAL                                   "FEC Options"                   "Include FEC sublayer"                                  NOVAL                                                   NOVAL       "This will include FEC logic for Backplane -Clause 74 implementation."}\
        {SYNTH_AN_gui           false   false           INTEGER 1                   NOVAL                                                                           "SYNTH_SEQ && ENA_KR4"                                  true                                boolean         NOVAL                                   "Auto-Negotiation"              "Enable Auto-Negotiation"                               NOVAL                                                   NOVAL       "This will include Auto-Negotiatiation for Backplane -Clause 73 implementation."}\
        {SYNTH_AN               true    true            INTEGER 1                   NOVAL                                                                           "SYNTH_SEQ && ENA_KR4"                                  false                               boolean         NOVAL                                   "Auto-Negotiation"              "Enable Auto-Negotiation"                               ::alt_eth_ultra::parameters::validate_synth_an          NOVAL       "This will include Auto-Negotiatiation for Backplane -Clause 73 implementation."}\
        {SYNTH_LT_gui           false   false           INTEGER 1                   NOVAL                                                                           "SYNTH_SEQ && ENA_KR4"                                  true                                boolean         NOVAL                                   "Link Training"                 "Enable Link Training"                                  NOVAL                                                   NOVAL       "When you turn this option On, the core includes the link training module which allows the remote link-partner TX PMD for the lowest Bit Error Rate (BER). LT is defined in Clause 72 of IEEE Std 802.3ap-2007."}\
        {SYNTH_LT               true    true            INTEGER 1                   NOVAL                                                                           "SYNTH_SEQ && ENA_KR4"                                  false                               boolean         NOVAL                                   "Link Training"                 "Enable Link Training"                                  ::alt_eth_ultra::parameters::validate_synth_lt          NOVAL       "When you turn this option On, the core includes the link training module which allows the remote link-partner TX PMD for the lowest Bit Error Rate (BER). LT is defined in Clause 72 of IEEE Std 802.3ap-2007."}\
        {LINK_TIMER_KR          false   true            INTEGER 504                 NOVAL                                                                           "SYNTH_SEQ && ENA_KR4"                                  true                                "columns:10"    ms                                      "Auto-Negotiation"              "Link fail inhibit time for 40Gb Ethernet"              ::alt_eth_ultra::parameters::validate_time_kr           NOVAL       "Timer for qualifying a link_status=FAIL indication or a link_status=OK indication when a specific technology link is first being established."}\
        {BERWIDTH_gui           false   false           INTEGER 511                 {15 31 63 127 255 511 1023}                                                     "SYNTH_LT && ENA_KR4"                                   true                                NOVAL           NOVAL                                   "Link Training"                 "Maximum bit error count"                               NOVAL                                                   NOVAL       "Specifies the expected number of bit errors for the error counter expected during each step of the link training. If the number of errors exceeds this number for each step, the core returns an error. The number of errors depends upon the amount of time for each step and the quality of the physical link media."}\
        {BERWIDTH               true    true            INTEGER 9                   {4 5 6 7 8 9 10}                                                                "SYNTH_LT && ENA_KR4"                                   false                               NOVAL           NOVAL                                   "Link Training"                 "Bit error counter width"                               ::alt_eth_ultra::parameters::calc_ber_ctr_width         NOVAL       NOVAL}\
        {TRNWTWIDTH_gui         false   false           INTEGER 127                 {127 255}                                                                       "SYNTH_LT && ENA_KR4"                                   true                                NOVAL           NOVAL                                   "Link Training"                 "Number of frames to send before sending actual data"   NOVAL                                                   NOVAL       "This timer is started when local receiver is trained and detects that the remote receiver is ready to receive data. The local PMD will deliver wait_timer additional training frames to ensure that the link partner correctly detects the local receiver state."}\
        {TRNWTWIDTH             true    true            INTEGER 7                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   false                               NOVAL           NOVAL                                   "Link Training"                 NOVAL                                                   ::alt_eth_ultra::parameters::calc_trn_ctr_width         NOVAL       NOVAL}\
        {MAINTAPWIDTH           false   true            INTEGER 5                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   false                               "columns:10"    NOVAL                                   "Link Training"                 NOVAL                                                   NOVAL                                                   NOVAL       "Width of the Main Tap control."}\
        {POSTTAPWIDTH           false   true            INTEGER 6                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   false                               "columns:10"    NOVAL                                   "Link Training"                 NOVAL                                                   NOVAL                                                   NOVAL       "Width of the Post Tap control."}\
        {PRETAPWIDTH            false   true            INTEGER 5                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   false                               "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   NOVAL                                                   NOVAL       "Width of the Pre Tap control."}\
        {VMAXRULE               false   true            INTEGER 30                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_vmaxrule          NOVAL       "Specifies the maximum VOD. The default value is 30 which represents 1200 mV."}\
        {VMINRULE               false   true            INTEGER 6                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_vminrule          NOVAL       "Specifies the minimum VOD. The default value is 6 which represents 165 mV."}\
        {VODMINRULE             false   true            INTEGER 14                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_vodrule           NOVAL       "Specifies the minimum VOD for the first tap. The default value is 14 which represents 440mV."}\
        {VPOSTRULE              false   true            INTEGER 25                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_vpostrule         NOVAL       "Specifies the maximum value that the internal algorithm for pre-emphasis will ever test in determining the optimum post-tap setting. The default value is 25."}\
        {VPRERULE               false   true            INTEGER 16                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_vprerule          NOVAL       "Specifies the maximum value that the internal algorithm for pre-emphasis will ever test in determining the optimum pre-tap setting. The default value is 16."}\
        {PREMAINVAL             false   true            INTEGER 30                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_premainrule       NOVAL       "Specifies the Preset VOD Value. Set by the Preset command as defined in Clause 72.6.10.2.3.1 of the link training protocol. This is the value from which the algorithm starts. The default value is 30."}\
        {PREPOSTVAL             false   true            INTEGER 0                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   NOVAL                                                   NOVAL       "Specifies the preset Post-tap value. The default value is 0."}\
        {PREPREVAL              false   true            INTEGER 0                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_prepostrule       NOVAL       "Specifies the preset Pre-tap Value. The default value is 0."}\
        {INITMAINVAL            false   true            INTEGER 25                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_initmainrule      NOVAL       "Specifies the Initial VOD Value. Set by the Initialize command in Clause 72.6.10.2.3.2 of the link training protocol. The default value is 25."}\
        {INITPOSTVAL            false   true            INTEGER 13                  NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   NOVAL                                                   NOVAL       "Specifies the initial Post-tap value. The default value is 13."}\
        {INITPREVAL             false   true            INTEGER 3                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   true                                "columns:10"    NOVAL                                   "PMA parameters"                NOVAL                                                   ::alt_eth_ultra::parameters::validate_initprepostrule   NOVAL       "Specifies the Initial Pre-tap Value. The default value is 3."}\
        {USE_DEBUG_CPU          false   true            INTEGER 0                   NOVAL                                                                           "SYNTH_LT && ENA_KR4"                                   UNHIDE_ADV                          boolean         NOVAL                                   "Link Training"                 "Use debug CPU"                                         NOVAL                                                   NOVAL       "Select between production CPU and DEBUG CPU."}\
        {AN_GIGE                false   false           INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               boolean         NOVAL                                   "Auto-Negotiation"              "1000 BASE-KX Technology Ability"                       NOVAL                                                   NOVAL       NOVAL}\
        {AN_XAUI                false   false           INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               boolean         NOVAL                                   "Auto-Negotiation"              "10GBASE-KX4 Technology Ability"                        NOVAL                                                   NOVAL       NOVAL}\
        {AN_BASER               false   false           INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               boolean         NOVAL                                   "Auto-Negotiation"              "10GBASE-KR Technology Ability"                         NOVAL                                                   NOVAL       NOVAL}\
        {AN_40GBP               true    false           INTEGER 1                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               boolean         NOVAL                                   "Auto-Negotiation"              "40GBASE-KR4 Technology Ability"                        ::alt_eth_ultra::parameters::validate_an_kr4            NOVAL       NOVAL}\
        {AN_40GCR               false   false           INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   true                                boolean         NOVAL                                   "Auto-Negotiation"              "Enable 40GBASE-CR4 Technology Ability"                 NOVAL                                                   NOVAL       "When you turn this option On, the AN function will advertise CR-4 capability instead of KR-4 capability."}\
        {AN_100G                false   false           INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               boolean         NOVAL                                   "Auto-Negotiation"              "100GBASE-CR10 Technology Ability"                      NOVAL                                                   NOVAL       NOVAL}\
        {AN_CHAN                false   true            INTEGER 1                   {"1:Lane 0" "2:Lane 1" "4:Lane 2" "8:Lane 3"}                                   "SYNTH_AN && ENA_KR4"                                   true                                NOVAL           NOVAL                                   "Auto-Negotiation"              "Auto-Negotiation Master"                               NOVAL                                                   NOVAL       "Selects which lane to perform auto-negotiation function on by default"}\
        {AN_PAUSE               true    true            INTEGER 0                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               "columns:10"    NOVAL                                   "Auto-Negotiation"              "Pause ability"                                         ::alt_eth_ultra::parameters::validate_an_pause          NOVAL       "Pause (C1:C0) is encoded in bits D11:D10 of base link codeword as per IEEE802.3 - 73.3.6."}\
        {AN_PAUSE_C0            false   false           INTEGER 1                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   true                                boolean         NOVAL                                   "Auto-Negotiation"              "Pause ability-C0"                                      NOVAL                                                   NOVAL       "C0 is same as PAUSE as defined in Annex 28B."}\
        {AN_PAUSE_C1            false   false           INTEGER 1                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   true                                boolean         NOVAL                                   "Auto-Negotiation"              "Pause ability-C1"                                      NOVAL                                                   NOVAL       "C1 is same as ASM_DIR as defined in Annex 28B."}\
        {AN_TECH                true    true            INTEGER 8                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               "columns:10"    NOVAL                                   "Auto-Negotiation"              NOVAL                                                   ::alt_eth_ultra::parameters::validate_an_tech           NOVAL       "Tech ability, only KR4 valid now // bit-0 = GigE, bit-1 = XAUI // bit-2 = 10G , bit-3 = 40G BP // bit 4 = 40G-CR4, bit 5 = 100G-CR10."}\
        {AN_SELECTOR            false   false           INTEGER 1                   NOVAL                                                                           "SYNTH_AN && ENA_KR4"                                   false                               NOVAL           NOVAL                                   "Auto-Negotiation"              "Selector field"                                        NOVAL                                                   NOVAL       "AN selector field 802.3 = 5'd1."}\
        {CAPABLE_FEC            false   true            INTEGER 1                   NOVAL                                                                           "SYNTH_FEC && ENA_KR4"                                  true                                boolean         NOVAL                                   "FEC Options"                   "Set FEC_Ability bit on power up or reset"              NOVAL                                                   NOVAL       "FEC ability bit power on value. This bit is defined in IEEE802.3ae - 45.2.1.84 register bit 1.170.0. Also referred in IEEE802.3ae - 73.6.5- F0"}\
        {ENABLE_FEC             false   true            INTEGER 1                   NOVAL                                                                           "SYNTH_FEC && ENA_KR4"                                  true                                boolean         NOVAL                                   "FEC Options"                   "Set FEC_Enable bit on power up or reset"               NOVAL                                                   NOVAL       "FEC enable bit power on value. This bit is defined in IEEE802.3ae - 45.2.1.85 register bit 1.171.0. Also referred in IEEE802.3ae - 73.6.5 as FEC requested bit-F1"}\
        {EXAMPLE_DESIGN         false   false           integer 1                   NOVAL                                                                           true                                                    true                                NOVAL           NOVAL                                   "Available Example Designs"     "Select design"                                         NOVAL                                                   NOVAL       ""                                   }\
        {GEN_SIMULATION         false   false           integer 1                   NOVAL                                                                           "(SYNOPT_AVALON) && (!EXT_TX_PLL)"                      true                                boolean         NOVAL                                   "Example Design Files"          "Simulation"                                            NOVAL                                                   NOVAL       ""                                   }\
        {GEN_SYNTH              false   false           integer 1                   NOVAL                                                                           "(SYNOPT_AVALON) && (!EXT_TX_PLL)"                      true                                boolean         NOVAL                                   "Example Design Files"          "Synthesis"                                             NOVAL                                                   NOVAL       ""                                   }\
        {DEV_BOARD              false   false           integer 1                   {"1:Arria 10 GX Transceiver Signal Integrity Development Kit" "0:None"}         "GEN_SYNTH == 1"                                        true                                NOVAL           NOVAL                                   "Target Development Kit"        "Select board"                                          NOVAL                                                   NOVAL       ""                                   }\
        {HDL_FORMAT             false   false           integer 0                   {"0:Verilog"}                                                                   true                                                    true                                NOVAL           NOVAL                                   "Generated HDL Format"          "Generate File Format"                                  NOVAL                                                   NOVAL       ""                                   }\
    }
}

proc ::alt_eth_ultra::parameters::declare_parameters {} {
    variable display_items
    variable parameters
    ip_declare_display_items $display_items
    ip_declare_parameters $parameters
    set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
    set_display_item_property "PMA parameters" DISPLAY_HINT COLLAPSED
    set_parameter_update_callback SYNOPT_PTP        ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback SYNOPT_PAUSE_TYPE ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback DISP_FCBITS       ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback SYNOPT_AVG_IPG    ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback SYNOPT_AVALON     ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback SPEED_CONFIG      ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback EXT_TX_PLL        ::alt_eth_ultra::parameters::change_state
    set_parameter_update_callback SYNOPT_CAUI4      ::alt_eth_ultra::parameters::change_state

    ip_set "parameter.part_trait_bd.SYSTEM_INFO_TYPE" PART_TRAIT
    ip_set "parameter.part_trait_bd.SYSTEM_INFO_ARG"  BASE_DEVICE
    ip_set "parameter.DEVICE.SYSTEM_INFO" DEVICE

    add_display_item "Target Development Kit" TARGET_DEVICE text ""

    add_display_item "Target Development Kit" TARGET_DESCRIPTION text \
    "<html>Example design supports generation, simulation, and Quartus compile flows for any <br> 
    selected device. The hardware support is provided through selected Development kit(s) <br>
    with a specific device. To exclude hardware aspects of example design, select \"None\" <br>
    from the \"Target Development Kit\" pull down menu</html>"

    ip_set "parameter.DEV_BOARD.ALLOWED_RANGES" \
        {"2:Arria 10 GX Transceiver Signal Integrity Development Kit (Engineering Sample 3)" \
         "1:Arria 10 GX Transceiver Signal Integrity Development Kit (Production Silicon)" \
         "0:None"}

    ip_set "parameter.ODI_UNHIDE.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_a10_enable_odi_acc ENABLED]
    ip_set "parameter.OVERRIDE_PART_NUM.DISPLAY_NAME"           "Override example design part number"
    ip_set "parameter.EXAMPLE_DESIGN.ALLOWED_RANGES"            {"1:Single instance of IP core"}
    
    ::alt_eth_ultra::parameters::set_descriptions
}

# Function to set GUI control descriptions
# This helps with parameters table clutter
proc ::alt_eth_ultra::parameters::set_descriptions {} {
    ip_set "parameter.EXAMPLE_DESIGN.DESCRIPTION" \
    "<b>Single Instance of IP Core</b><br>
    Example designs instantiate a single instance of the IP core.<br>
    <br>
    The Synthesis project is a project designed to run on a development 
    kit and includes the necessary supporting hardware including JTAG master 
    and PLLs.<br>
    <br>
    The Simulation project is a testbench which demonstrates basic core 
    interfacing and usage.<br>
    <br>
    <b>None</b><br>
    If neither the Simulation or Synthesis designs are available, 
    this option will be set to None. In this case, only a compilation 
    design will be generated which instantiates the IP and assigns its I/O 
    to virtual pins."

    ip_set "parameter.GEN_SYNTH.DESCRIPTION" \
    "When the synthesis box is checked, all necessary filesets required for 
    the hardware example design will be generated. <br>
    <br>
    When Synthesis box is NOT 
    checked, files required for Synthesis will be NOT be generated."

    ip_set "parameter.GEN_SIMULATION.DESCRIPTION" \
    "When Synthesis box is checked, all necessary filesets required for 
    synthesis will be generated.<br>
    <br>
    When Synthesis box is NOT checked, files required for Synthesis will 
    be NOT generated."

    ip_set "parameter.HDL_FORMAT.DESCRIPTION" \
    "Please select an HDL format for the generated Example Design filesets."

    ip_set "parameter.DEV_BOARD.DESCRIPTION" \
    "This option provides supports for various Development Kits listed. The 
    details of Intel FPGA Development kits can be found on the 
    <a href=\"https://www.altera.com/products/boards_and_kits/all-development-kits.html\">
    Intel FPGA website</a>. If this menu is greyed out, it is because no board is supported 
    for the options selected such as synthesis checked off. If an Intel FPGA Development 
    board is selected, the Target Device used for generation will be the one that 
    matches the device on the Development Kit."
}

proc ::alt_eth_ultra::parameters::change_state {PROP_NAME} {
    set PTP             [ip_get "parameter.SYNOPT_PTP.value"]
    set PAUSE           [ip_get "parameter.SYNOPT_PAUSE_TYPE.value"]
    set DISP_FCBITS     [ip_get "parameter.DISP_FCBITS.value"]
    set AVG_IPG         [ip_get "parameter.SYNOPT_AVG_IPG.value"]
    set SYNOPT_AVALON   [ip_get "parameter.SYNOPT_AVALON.value"]
    set IS_100G         [ip_get "parameter.IS_100G.value"]
    set EXT_TX_PLL      [ip_get "parameter.EXT_TX_PLL.value"]
    set SYNOPT_CAUI4    [ip_get "parameter.SYNOPT_CAUI4.value"]
    set ENABLE_ALL_ED   [ip_get "parameter.ENABLE_ALL_ED.value"]

    if {$SYNOPT_AVALON == 0} {
        ip_set "parameter.SYNOPT_PAUSE_TYPE.value" 0
        ip_set "parameter.SYNOPT_PTP.value" 0
    }

    if {!$ENABLE_ALL_ED} {
        # Disable unsupported example design generation
        set hw_example_available 1
        set testbench_available  1

        # Custom interface not supported by example designs
        if {$SYNOPT_AVALON == 0} {
            set hw_example_available 0
            set testbench_available  0
        }

        # External TX PLL not supported by example designs
        if {$EXT_TX_PLL == 1} {
            set hw_example_available 0
            set testbench_available  0
        }

        ip_set "parameter.GEN_SIMULATION.value" $testbench_available
        ip_set "parameter.GEN_SYNTH.value"      $hw_example_available

        # Set available designs to None if both testbench and hw design disabled
        # Usability requirement
        if {!$hw_example_available && !$testbench_available} {
            ip_set "parameter.EXAMPLE_DESIGN.value" 0
        } else {
            ip_set "parameter.EXAMPLE_DESIGN.value" 1
        }
    }

    if {($PTP != 0) || ($PAUSE != 0)} {
        set old_crc_value [ip_get "parameter.SYNOPT_TXCRC_INS.value"]
        ip_set "parameter.SYNOPT_TXCRC_INS.value" 1
    }
    
    if {$PAUSE != 2} {
        ip_set "parameter.FCBITS.value" 1
    } else {
        ip_set "parameter.FCBITS.value" $DISP_FCBITS
    }
    
    if {$AVG_IPG == 0} {
        ip_set "parameter.SYNOPT_MAC_DIC.value" 0
    } else {
        ip_set "parameter.SYNOPT_MAC_DIC.value" 1
    }

    if { [string compare $PROP_NAME SYNOPT_PTP] == 0 } {
        if {$PTP} {
            ip_set "parameter.SYNOPT_96B_PTP.value" 1
        } else {
            ip_set "parameter.SYNOPT_96B_PTP.value" 0
            ip_set "parameter.SYNOPT_64B_PTP.value" 0
        }
    }
}

proc ::alt_eth_ultra::parameters::validate {} {
    set SYNOPT_AVALON   [ip_get "parameter.SYNOPT_AVALON.value"]
    set EXT_TX_PLL      [ip_get "parameter.EXT_TX_PLL.value"]
    set SYNOPT_CAUI4    [ip_get "parameter.SYNOPT_CAUI4.value"]
    set ENABLE_ALL_ED   [ip_get "parameter.ENABLE_ALL_ED.value"]

    if {!$ENABLE_ALL_ED} {
        # Set Example design drop-down based on current parameter selection
        set allowed_designs { "1:Single instance of IP core" }
        if {$EXT_TX_PLL    == 1} { set allowed_designs  { "0:None" } }
        if {$SYNOPT_AVALON == 0} { set allowed_designs  { "0:None" } }
        ip_set "parameter.EXAMPLE_DESIGN.ALLOWED_RANGES" $allowed_designs
    }

    ip_validate_parameters
    ip_validate_display_items

    set TARGET_DEVICE [ ::alt_eth_ultra::fileset::get_board_safe_part ]

    set_display_item_property TARGET_DEVICE text "Target device: $TARGET_DEVICE"
}

proc ::alt_eth_ultra::parameters::chk_dev_unknown {part_trait_bd DEVICE DEVICE_FAMILY} {
  if { ([string compare -nocase $DEVICE_FAMILY "Arria 10"] == 0) & ([string compare -nocase $part_trait_bd "unknown"] == 0) } {
     send_message error "The current selected device \"$DEVICE\" is invalid, please select a valid device to generate the IP."
  }

  if {[regexp {^.*(ES|ES2)\S*$} $part_trait_bd matched]} {
      ip_set "parameter.ES_DEVICE.value" 1          
  } else {
      ip_set "parameter.ES_DEVICE.value" 0          
  }
}

proc ::alt_eth_ultra::parameters::v_SYNOPT_PREAMBLE_PASS {PROP_VALUE} {
    if {$PROP_VALUE == 1} {
        send_message warning "Hardware example design does not support preamble passthrough and may not function correctly"
    }
}

proc ::alt_eth_ultra::parameters::v_SYNOPT_B {PROP_VALUE} {
    set SYNOPT_PTP [ip_get "parameter.SYNOPT_PTP.value"]
    set SYNOPT_96B_PTP [ip_get "parameter.SYNOPT_96B_PTP.value"]
    set SYNOPT_64B_PTP [ip_get "parameter.SYNOPT_64B_PTP.value"]

    if {$SYNOPT_PTP} {
        if {(!$SYNOPT_96B_PTP) && (!$SYNOPT_64B_PTP)} {
            send_message error "Enable at least one Time of Day formats when enabling 1588 PTP"
        }
    }
}

#proc ::alt_eth_ultra::parameters::v_RX_PLL_TYPE {PROP_VALUE} {
#    set SYNOPT_CAUI4 [ip_get "parameter.SYNOPT_CAUI4.value"]
#    if {($SYNOPT_CAUI4) && ($PROP_VALUE == 0)} {
#        send_message error "IO PLL not available for CAUI4. Change RX PLL Type to fPLL"
#    }
#}

proc ::alt_eth_ultra::parameters::v_SYNOPT_TXCRC_INS {PROP_VALUE} {
    if {$PROP_VALUE == 0} {
        send_message warning "Hardware example design does not support non-TX CRC insertion and may not function correctly"
    }
}

proc ::alt_eth_ultra::parameters::v_SYNOPT_AVALON {PROP_VALUE} {
    if {$PROP_VALUE == 0} {
        send_message warning "Example designs can only be generated with the Avalon-ST interface"
    }
}

proc ::alt_eth_ultra::parameters::v_EXT_TX_PLL {PROP_VALUE} {
    if {$PROP_VALUE == 1} {
        send_message warning "Example designs cannot be generated using the external TX MAC PLL"
    }
}

proc ::alt_eth_ultra::parameters::v_REF_CLK_FREQ_10G {PHY_REFCLK} {
    if {$PHY_REFCLK == 1} {
        ip_set "parameter.REF_CLK_FREQ_10G.value" "644.53125 MHz"
    } else {
        ip_set "parameter.REF_CLK_FREQ_10G.value" "322.265625 MHz"
        send_message warning "SI kit reference clock frequency may need to be reconfigured to 322.265625 MHz"
    }
}

proc ::alt_eth_ultra::parameters::v_SPEED_CONFIG {PROP_NAME PROP_VALUE} {
    if {$PROP_VALUE == "100 GbE"} {
        ip_set "parameter.IS_100G.value" 1
    } else {
        ip_set "parameter.IS_100G.value" 0
    }
}

proc ::alt_eth_ultra::parameters::v_DEV_FAM {PROP_NAME PROP_VALUE} {
    if {$PROP_VALUE == "Stratix V"} {
        ip_set "parameter.TARGET_CHIP.value" 2
    } elseif {$PROP_VALUE == "Arria 10"} {
        ip_set "parameter.TARGET_CHIP.value" 5
    } else {
        ip_set "parameter.TARGET_CHIP.value" 0
    }
}

proc ::alt_eth_ultra::parameters::v_CAUI4 {PROP_VALUE TARGET_CHIP} {
    if {$PROP_VALUE == 1} {
        if {$TARGET_CHIP == 5} {
            ip_set "parameter.NOT_CAUI4.value" 0
        } else {
            ip_set "parameter.NOT_CAUI4.value" 1
        }
    } else {
        ip_set "parameter.NOT_CAUI4.value" 1
    }
}

proc ::alt_eth_ultra::parameters::v_C4_RSFEC { SYNOPT_C4_RSFEC EXT_TX_PLL }  {
    if {$SYNOPT_C4_RSFEC && $EXT_TX_PLL} {    
        ip_message error  "CAUI4 RS-FEC Requires Internal TX MAC PLL"  
    }
}

proc ::alt_eth_ultra::parameters::calc_ber_ctr_width { BERWIDTH_gui }  {
if {$BERWIDTH_gui==15} {
 ip_set "parameter.BERWIDTH.value" 4
 } elseif {$BERWIDTH_gui==31} {
 ip_set "parameter.BERWIDTH.value" 5
 } elseif {$BERWIDTH_gui==63} {
 ip_set "parameter.BERWIDTH.value" 6
 } elseif {$BERWIDTH_gui==127} {
 ip_set "parameter.BERWIDTH.value" 7
 } elseif {$BERWIDTH_gui==255} {
 ip_set "parameter.BERWIDTH.value" 8
 } elseif {$BERWIDTH_gui==511} {
 ip_set "parameter.BERWIDTH.value" 9
 } elseif {$BERWIDTH_gui==1023} {
 ip_set "parameter.BERWIDTH.value" 10
 } elseif {$BERWIDTH_gui==2047} {
 ip_set "parameter.BERWIDTH.value" 11
 } elseif {$BERWIDTH_gui==4095} {
 ip_set "parameter.BERWIDTH.value" 12
 } elseif {$BERWIDTH_gui==8191} {
 ip_set "parameter.BERWIDTH.value" 13
 } else {
 ip_set "parameter.BERWIDTH.value" 14
 }            
}      

proc ::alt_eth_ultra::parameters::calc_trn_ctr_width { TRNWTWIDTH_gui }  {
    if {$TRNWTWIDTH_gui==127} {
        ip_set "parameter.TRNWTWIDTH.value" 7
    } else {
        ip_set "parameter.TRNWTWIDTH.value" 8
    }            
}

proc ::alt_eth_ultra::parameters::validate_IS_100G {IS_100G} {

    if {!$IS_100G} {
        #parameters exposed only in e40 wrapper for KR4
        ip_set "parameter.REF_CLK_FREQ_10G.HDL_PARAMETER" true
        ip_set "parameter.ENA_KR4.HDL_PARAMETER" true
        ip_set "parameter.ES_DEVICE.HDL_PARAMETER" true
        ip_set "parameter.SYNTH_SEQ.HDL_PARAMETER" true
        ip_set "parameter.STATUS_CLK_KHZ.HDL_PARAMETER" true
        ip_set "parameter.SYNTH_FEC.HDL_PARAMETER" true
        ip_set "parameter.SYNTH_AN.HDL_PARAMETER" true
        ip_set "parameter.SYNTH_LT.HDL_PARAMETER" true
        ip_set "parameter.LINK_TIMER_KR.HDL_PARAMETER" true
        ip_set "parameter.BERWIDTH.HDL_PARAMETER" true
        ip_set "parameter.TRNWTWIDTH.HDL_PARAMETER" true
        ip_set "parameter.MAINTAPWIDTH.HDL_PARAMETER" true
        ip_set "parameter.POSTTAPWIDTH.HDL_PARAMETER" true
        ip_set "parameter.POSTTAPWIDTH.HDL_PARAMETER" true
        ip_set "parameter.PRETAPWIDTH.HDL_PARAMETER" true
        ip_set "parameter.VMAXRULE.HDL_PARAMETER" true
        ip_set "parameter.VMINRULE.HDL_PARAMETER" true
        ip_set "parameter.VODMINRULE.HDL_PARAMETER" true
        ip_set "parameter.VPOSTRULE.HDL_PARAMETER" true
        ip_set "parameter.VPRERULE.HDL_PARAMETER" true
        ip_set "parameter.PREMAINVAL.HDL_PARAMETER" true
        ip_set "parameter.PREPOSTVAL.HDL_PARAMETER" true
        ip_set "parameter.PREPREVAL.HDL_PARAMETER" true
        ip_set "parameter.INITMAINVAL.HDL_PARAMETER" true
        ip_set "parameter.INITPOSTVAL.HDL_PARAMETER" true
        ip_set "parameter.INITPREVAL.HDL_PARAMETER" true
        ip_set "parameter.USE_DEBUG_CPU.HDL_PARAMETER" true
        ip_set "parameter.AN_CHAN.HDL_PARAMETER" true
        ip_set "parameter.AN_PAUSE.HDL_PARAMETER" true
        ip_set "parameter.AN_TECH.HDL_PARAMETER" true
        ip_set "parameter.CAPABLE_FEC.HDL_PARAMETER" true
        ip_set "parameter.ENABLE_FEC.HDL_PARAMETER" true
    } else {
        #parameters exposed only in e40 wrapper for KR4
        ip_set "parameter.REF_CLK_FREQ_10G.HDL_PARAMETER" false
        ip_set "parameter.ENA_KR4.HDL_PARAMETER" false
        ip_set "parameter.ES_DEVICE.HDL_PARAMETER" false
        ip_set "parameter.SYNTH_SEQ.HDL_PARAMETER" false
        ip_set "parameter.STATUS_CLK_KHZ.HDL_PARAMETER" false
        ip_set "parameter.SYNTH_FEC.HDL_PARAMETER" false
        ip_set "parameter.SYNTH_AN.HDL_PARAMETER" false
        ip_set "parameter.SYNTH_LT.HDL_PARAMETER" false
        ip_set "parameter.LINK_TIMER_KR.HDL_PARAMETER" false
        ip_set "parameter.BERWIDTH.HDL_PARAMETER" false
        ip_set "parameter.TRNWTWIDTH.HDL_PARAMETER" false
        ip_set "parameter.MAINTAPWIDTH.HDL_PARAMETER" false
        ip_set "parameter.POSTTAPWIDTH.HDL_PARAMETER" false
        ip_set "parameter.POSTTAPWIDTH.HDL_PARAMETER" false
        ip_set "parameter.PRETAPWIDTH.HDL_PARAMETER" false
        ip_set "parameter.VMAXRULE.HDL_PARAMETER" false
        ip_set "parameter.VMINRULE.HDL_PARAMETER" false
        ip_set "parameter.VODMINRULE.HDL_PARAMETER" false
        ip_set "parameter.VPOSTRULE.HDL_PARAMETER" false
        ip_set "parameter.VPRERULE.HDL_PARAMETER" false
        ip_set "parameter.PREMAINVAL.HDL_PARAMETER" false
        ip_set "parameter.PREPOSTVAL.HDL_PARAMETER" false
        ip_set "parameter.PREPREVAL.HDL_PARAMETER" false
        ip_set "parameter.INITMAINVAL.HDL_PARAMETER" false
        ip_set "parameter.INITPOSTVAL.HDL_PARAMETER" false
        ip_set "parameter.INITPREVAL.HDL_PARAMETER" false
        ip_set "parameter.USE_DEBUG_CPU.HDL_PARAMETER" false
        ip_set "parameter.AN_CHAN.HDL_PARAMETER" false
        ip_set "parameter.AN_PAUSE.HDL_PARAMETER" false
        ip_set "parameter.AN_TECH.HDL_PARAMETER" false
        ip_set "parameter.CAPABLE_FEC.HDL_PARAMETER" false
        ip_set "parameter.ENABLE_FEC.HDL_PARAMETER" false
    }
}


proc ::alt_eth_ultra::parameters::validate_ENA_KR4 {PROP_NAME ENA_KR4_gui TARGET_CHIP IS_100G SYNOPT_PTP ADME_ENABLE ODI_ENABLE_effective ODI_UNHIDE} {
  if {$TARGET_CHIP == 5 && !$IS_100G} {  
        set_parameter_property ENA_KR4_gui ENABLED true
        ip_set "parameter.ENA_KR4_gui.visible"     true
        ip_set "parameter.ENA_KR4_OFF.visible" false
        ip_set "parameter.ENA_KR4.value" $ENA_KR4_gui
        
        if {$PROP_NAME == "ENA_KR4" && $ENA_KR4_gui && $SYNOPT_PTP} {
          ip_message error "1588 PTP not supported in KR4 mode"
        }
        if {$ODI_UNHIDE} {
           if {$PROP_NAME == "ENA_KR4" && $ENA_KR4_gui && ($ODI_ENABLE_effective && !$ADME_ENABLE || $ADME_ENABLE && !$ODI_ENABLE_effective)} {
             ip_message error "In KR4 mode, both ODI and ADME must be enabled simultaneously"
           }
        }
    } else {
        set_parameter_property ENA_KR4_gui ENABLED false
        ip_set "parameter.ENA_KR4_gui.visible"     false
        ip_set "parameter.ENA_KR4_OFF.visible" true
        ip_set "parameter.ENA_KR4.value" 0
    }
}

proc ::alt_eth_ultra::parameters::validate_an_pause { AN_PAUSE_C0 AN_PAUSE_C1 SYNOPT_PAUSE_TYPE ENA_KR4} {
    ip_set "parameter.AN_PAUSE.value" [expr $AN_PAUSE_C1*2+ $AN_PAUSE_C0*1  ]

    if {($AN_PAUSE_C1 || $AN_PAUSE_C0) && ($SYNOPT_PAUSE_TYPE == 0) && $ENA_KR4} {
        ip_message warning "Pause ability AN bits set but Flow Control disabled in MAC"
    }
}

proc ::alt_eth_ultra::parameters::validate_an_kr4   { AN_40GCR } {
    if {$AN_40GCR} {	
          ip_set "parameter.AN_40GBP.value" 0
    } else {
          ip_set "parameter.AN_40GBP.value" 1
    }  	    
}

proc ::alt_eth_ultra::parameters::validate_an_tech  { AN_GIGE AN_XAUI AN_BASER AN_40GBP AN_40GCR AN_100G } {
    ip_set "parameter.AN_TECH.value" [expr $AN_100G*32+ $AN_40GCR*16+ $AN_40GBP*8+ $AN_BASER*4+ $AN_XAUI*2+ $AN_GIGE*1  ]
}

proc ::alt_eth_ultra::parameters::validate_an_fec { CAPABLE_FEC ENABLE_FEC SYNTH_FEC } {
 if {$SYNTH_FEC} {
  ip_set "parameter.AN_FEC.value" [expr $ENABLE_FEC*2+ $CAPABLE_FEC*1  ]
 } else { 
  ip_set "parameter.AN_FEC.value" 0
 }
}

proc ::alt_eth_ultra::parameters::validate_synth_an {SYNTH_SEQ SYNTH_AN_gui } {
 if {$SYNTH_SEQ} {
  ip_set "parameter.SYNTH_AN.value" $SYNTH_AN_gui
 } else { 
  ip_set "parameter.SYNTH_AN.value" 0
 }
}

proc ::alt_eth_ultra::parameters::validate_synth_lt {SYNTH_SEQ SYNTH_LT_gui } {
 if {$SYNTH_SEQ} {
  ip_set "parameter.SYNTH_LT.value" $SYNTH_LT_gui
 } else { 
  ip_set "parameter.SYNTH_LT.value" 0
 }
}

proc ::alt_eth_ultra::parameters::validate_STATUS_CLK_KHZ { STATUS_CLK_MHZ } {
    ip_set "parameter.STATUS_CLK_KHZ.value" [expr int($STATUS_CLK_MHZ * 1000.0)]
}

proc ::alt_eth_ultra::parameters::validate_time_kr  {LINK_TIMER_KR  STATUS_CLK_KHZ SYNTH_SEQ ENA_KR4 }  {
    if {$SYNTH_SEQ && $ENA_KR4} {
        set min_val [expr 1000*1000.0/$STATUS_CLK_KHZ]
        set max_val [expr 1000*1000.0/$STATUS_CLK_KHZ*127]
        out_of_range_message $min_val $max_val $LINK_TIMER_KR error "Link Fail Time for KR" 0 ""
        out_of_range_message 500 510 $LINK_TIMER_KR warning "Link Fail Time for KR" 1 "The current Link Fail Timer for KR  value does not meet IEEE802.3ba specification. IEEE802.3ba specifies this timer value to be between 500mS and 510mS" 
    }
}

proc ::alt_eth_ultra::parameters::validate_vmaxrule { VMAXRULE SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message  0 31 $VMAXRULE  error  "VMAXRULE" 1 "Current value of VMAXRULE is not valid. 0 &lt; VMAXRULE &lt; 31."  
        out_of_range_message  0 30 $VMAXRULE  warning "VMAXRULE" 1 "Recommended VMAXRULE values is 30 to meet IEEE specification of 1200 mV."  
    }
}    

proc ::alt_eth_ultra::parameters::validate_vminrule { VMAXRULE VMINRULE SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message  0   $VMAXRULE $VMINRULE  error  "VMINRULE" 1 "Current value of VMINRULE is not valid. 0 &lt; VMINRULE &lt; VMAXRULE &lt; 31."  
    }
}    

proc ::alt_eth_ultra::parameters::validate_vodrule { VMAXRULE VMINRULE VODMINRULE SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message  $VMINRULE $VMAXRULE $VODMINRULE  error  "VODMINRULE" 1 "Current value of VODMINRULE is not valid. VMINRULE &lt; VODMINRULE &lt; VMAXRULE."  
        out_of_range_message  14 31 $VODMINRULE  warning "VODMINRULE" 1 "Recommended VODMINRULE values is 14 or greater to meet IEEE specification of 440 mV."  
    }    
}

proc ::alt_eth_ultra::parameters::validate_vpostrule { VPOSTRULE SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
    }    
    out_of_range_message 0 25 $VPOSTRULE  error  "VPOSTRULE" 0 ""  
}

proc ::alt_eth_ultra::parameters::validate_vprerule { VPRERULE SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message 0 16 $VPRERULE  error  "VPRERULE" 0 ""  
    }    
}

proc ::alt_eth_ultra::parameters::validate_premainrule { VMAXRULE VODMINRULE PREMAINVAL SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message $VODMINRULE $VMAXRULE $PREMAINVAL  error  "PREMAINVAL" 1 "Current value of PREMAINVAL is not valid. VODMIN &lt; PREMAINVAL &lt; VMAXRULE."  
    }    
}

proc ::alt_eth_ultra::parameters::validate_prepostrule { VMINRULE PREMAINVAL PREPOSTVAL PREPREVAL SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        set invalid1  [expr { $PREMAINVAL + [expr {0.25 * $PREPOSTVAL}] + [expr {0.25 * $PREPREVAL}] <= 41 ? {0} : {1} } ]
        set invalid2  [expr { $PREMAINVAL - $PREPOSTVAL - $PREPREVAL >= $VMINRULE ? {0} : {1} } ]
        if { [expr $invalid1 || $invalid2 ] } {
            ip_message error "Current values for  PREMAINVAL, PREPOSTVAL, PREPREVAL are not correct. Follow \n  PREMAINVAL + 0.25*PREPOSTVAL + 0.25*PREPREVAL &lt;= 41 \n PREMAINVAL - PREPOSTVAL - PREPREVAL >= VMINRULE."
        } 
        if { [expr  $PREPOSTVAL ||  $PREPREVAL ] } {
            ip_message warning "Recommended IEEE values for PREPOSTVAL, and PREPREVAL are zero."
        }
    }   
}

proc ::alt_eth_ultra::parameters::validate_initmainrule { VMAXRULE VODMINRULE INITMAINVAL SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message $VODMINRULE $VMAXRULE $INITMAINVAL  error  "INITMAINVAL" 1 "Current value of INITMAINVAL is not valid. VODMIN &lt; INITMAINVAL &lt; VMAXRULE."  
    }   
}

proc ::alt_eth_ultra::parameters::validate_initprepostrule { VMINRULE VPOSTRULE INITMAINVAL INITPOSTVAL INITPREVAL SYNTH_LT ENA_KR4 }  {
    if {$SYNTH_LT && $ENA_KR4} {
        out_of_range_message  0 $VPOSTRULE $INITPOSTVAL  error  "INITPOSTVAL" 1 "Current value of INITPOSTVAL is not valid. 0 &lt; INITPOSTVAL &lt; VPOSTRULE."  
        set invalid1  [expr { $INITMAINVAL + [expr {0.25 * $INITPOSTVAL}] + [expr {0.25 * $INITPREVAL}] <= 41 ? {0} : {1} } ]
        set invalid2  [expr { $INITMAINVAL - $INITPOSTVAL - $INITPREVAL >= $VMINRULE ? {0} : {1} } ]
        if { [expr $invalid1 || $invalid2] } {
            ip_message error "Current values for  INITMAINVAL, INITPOSTVAL, INITPREVAL are not correct. Follow \n  INITMAINVAL + 0.25*INITPOSTVAL + 0.25*INITPREVAL &lt; 41 \n INITMAINVAL - INITPOSTVAL - INITPREVAL > VMINRULE."
        } 
        if { $INITPOSTVAL != 13 } {
            ip_message warning "Recommended IEEE value for INITPOSTVAL is 13."
        }
        if { $INITPREVAL != 3 } {
            ip_message warning "Recommended IEEE value for INITPREVAL is 3."
        }
    }   
}

proc ::alt_eth_ultra::parameters::out_of_range_message {min_val max_val current_val severity field customized c_message} {

    set illegal [expr {$current_val < $min_val ? {1}
        : $current_val > $max_val ? {1}
        : {0}  }  ]

    if {[expr $illegal & !$customized]} {
        ip_message $severity "The selected ${field} is not supported. Valid ${field} range is ${min_val} to ${max_val}."
    }
    if {[expr $illegal & $customized]} {
        ip_message $severity "$c_message"
    }
}

proc ::alt_eth_ultra::parameters::validate_odi_en { ODI_UNHIDE ODI_ENABLE}  {
   if {$ODI_UNHIDE} {      
     ip_set "parameter.ODI_ENABLE_effective.value" $ODI_ENABLE     
   } else {
     ip_set "parameter.ODI_ENABLE_effective.value" "false"          
   }
}
	
proc ::alt_eth_ultra::parameters::chk_qii_ini { }  {
    set unhide_val                  [get_quartus_ini "altera_xcvr_10gbase_kr_arria10_advanced"]
    set unhide_ultra_val            [get_quartus_ini "altera_ethernet_ultra_arria10_advanced"]
    set show_debug_tab              [get_quartus_ini "show_debug_tab"]
    set enable_all_example_designs  [get_quartus_ini "enable_all_designs"]

    if {$unhide_val || $unhide_ultra_val} {
        ip_set "parameter.UNHIDE_ADV.value" "true"          
    } else {
        ip_set "parameter.UNHIDE_ADV.value" "false"         
    }      

    if {$show_debug_tab} {
        ip_set "parameter.SHOW_DEBUG_TAB.value" "true"
    } else {
        ip_set "parameter.SHOW_DEBUG_TAB.value" "false"
    }

    if {$enable_all_example_designs} {
        ip_set "parameter.ENABLE_ALL_ED.value" "true"
    } else {
        ip_set "parameter.ENABLE_ALL_ED.value" "false"
    }
}

proc ::alt_eth_ultra::parameters::set_parameter { param prop newval } {
    variable parameters
    ::alt_eth_ultra::parameters::set_array_element parameters $param $prop $newval
}

proc ::alt_eth_ultra::parameters::set_display_item { param prop newval } {
    variable display_items
    ::alt_eth_ultra::parameters::set_array_element display_items $param $prop $newval
}

proc ::alt_eth_ultra::parameters::set_array_element { array param prop newval } {
    upvar 1 $array arr
    set row_num [get_row $arr $param]
    set col_num [get_column $arr $prop]
    set row [lindex $arr $row_num]
    lset row $col_num $newval
    lset arr $row_num $row
}

proc ::alt_eth_ultra::parameters::get_column { array name } {
    set col_num 0
    set header [lindex $array 0]
    foreach col_name $header {
        if { [string compare $name $col_name] == 0 } {
            return $col_num
        }
        incr col_num
    }
    return -1
}

proc ::alt_eth_ultra::parameters::get_row { array name } {
    set row_num 0
    foreach row $array {
        set row_name [lindex $row 0]
        if { [string compare $name $row_name] == 0 } {
            return $row_num
        }
        incr row_num
    }
    return -1
}
