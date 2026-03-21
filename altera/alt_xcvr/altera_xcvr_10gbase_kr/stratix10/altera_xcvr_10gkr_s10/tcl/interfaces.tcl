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


package provide altera_xcvr_10gkr_s10::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace eval ::altera_xcvr_10gkr_s10::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_interfaces \
    elaborate

  variable interfaces

  set interfaces {\
    {NAME                         DIRECTION UI_DIRECTION  WIDTH_EXPR                ROLE                       TERMINATION                             TERMINATION_VALUE IFACE_NAME                 IFACE_TYPE        IFACE_DIRECTION  ELABORATION_CALLBACK                                                         }\
    {tx_serial_clk_10g            input     input         1                         clk                        NOVAL                                   NOVAL             tx_serial_clk_10g          hssi_serial_clock sink             NOVAL                                                                        }\
    {rx_cdr_ref_clk_10g           input     input         1                         clk                        NOVAL                                   NOVAL             rx_cdr_ref_clk_10g         clock             sink             NOVAL                                                                        }\
    {xgmii_tx_clk                 input     input         1                         clk                        NOVAL                                   NOVAL             xgmii_tx_clk               clock             sink             NOVAL                                                                        }\
    {xgmii_rx_clk                 input     input         1                         clk                        NOVAL                                   NOVAL             xgmii_rx_clk               clock             sink             NOVAL                                                                        }\
    {tx_clkout                    output    output        1                         clk                        "!OPTIONAL_TX_CLKOUT"                   NOVAL             tx_clkout                  clock             source           NOVAL                                                                        }\
    {rx_clkout                    output    output        1                         clk                        "!OPTIONAL_RX_CLKOUT"                   NOVAL             rx_clkout                  clock             source           NOVAL                                                                        }\
    {tx_pma_div_clkout            output    output        1                         clk                        "!OPTIONAL_TX_DIV33CLK"                 NOVAL             tx_pma_div_clkout          clock             source           NOVAL                                                                        }\
    {rx_pma_div_clkout            output    output        1                         clk                        "!OPTIONAL_RX_DIV33CLK"                 NOVAL             rx_pma_div_clkout          clock             source           NOVAL                                                                        }\
    \
    {tx_analogreset               input     input         1                         tx_analogreset             NOVAL                                   NOVAL             tx_analogreset             conduit           end              NOVAL                                                                        }\
    {tx_digitalreset              input     input         1                         tx_digitalreset            NOVAL                                   NOVAL             tx_digitalreset            conduit           end              NOVAL                                                                        }\
    {rx_analogreset               input     input         1                         rx_analogreset             NOVAL                                   NOVAL             rx_analogreset             conduit           end              NOVAL                                                                        }\
    {rx_digitalreset              input     input         1                         rx_digitalreset            NOVAL                                   NOVAL             rx_digitalreset            conduit           end              NOVAL                                                                        }\
    {tx_analogreset_stat          output    output        1                         export                     NOVAL                                   NOVAL             tx_analogreset_stat        conduit           end              NOVAL                                                                        }\
    {tx_digitalreset_stat         output    output        1                         export                     NOVAL                                   NOVAL             tx_digitalreset_stat       conduit           end              NOVAL                                                                        }\
    {rx_analogreset_stat          output    output        1                         export                     NOVAL                                   NOVAL             rx_analogreset_stat        conduit           end              NOVAL                                                                        }\
    {rx_digitalreset_stat         output    output        1                         export                     NOVAL                                   NOVAL             rx_digitalreset_stat       conduit           end              NOVAL                                                                        }\
    {usr_seq_reset                input     input         1                         usr_seq_reset              "!SYNTH_SEQ"                            NOVAL             usr_seq_reset              conduit           end              NOVAL                                                                        }\
    {rc_busy                      output    output        1                         rc_busy                    "SYNTH_SEQ || !SYNTH_RCFG"              NOVAL             rc_busy                    conduit           end              NOVAL                                                                        }\
    {start_pcs_reconfig           input     input         1                         start_pcs_reconfig         "SYNTH_SEQ || !SYNTH_RCFG"              NOVAL             start_pcs_reconfig         conduit           end              NOVAL                                                                        }\
    {mode_1g_10gbar               input     input         1                         export                     "SYNTH_SEQ || !SYNTH_GIGE"              NOVAL             mode_1g_10gbar             conduit           end              NOVAL                                                                        }\
    {pcs_mode_rc                  output    output        6                         export                     "!SYNTH_SEQ || !ENABLE_PCS_MODE"        NOVAL             pcs_mode_rc                conduit           end              NOVAL                                                                        }\
    \
    {mgmt_clk                     input     input         1                         clk                        NOVAL                                   NOVAL             mgmt_clk                   clock             sink             NOVAL                                                                        }\
    {mgmt_clk_reset               input     input         1                         reset                      NOVAL                                   NOVAL             mgmt_clk_reset             reset             sink             ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_address                 input     input         11                        address                    NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_read                    input     input         1                         read                       NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_readdata                output    output        32                        readdata                   NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_waitrequest             output    output        1                         waitrequest                NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_write                   input     input         1                         write                      NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {mgmt_writedata               input     input         32                        writedata                  NOVAL                                   NOVAL             phy_mgmt                   avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    \
    {reconfig_address             input     input         11                        address                    NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {reconfig_read                input     input         1                         read                       NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {reconfig_readdata            output    output        32                        readdata                   NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {reconfig_waitrequest         output    output        1                         waitrequest                NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {reconfig_write               input     input         1                         write                      NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    {reconfig_writedata           input     input         32                        writedata                  NOVAL                                   NOVAL             xcvr_rcfg                  avalon            slave            ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock             }\
    \
    {xgmii_tx_dc                  input     input         72                        export                     NOVAL                                   NOVAL             xgmii_tx_dc                conduit           end              NOVAL                                                                       }\
    {xgmii_rx_dc                  output    output        72                        export                     NOVAL                                   NOVAL             xgmii_rx_dc                conduit           end              NOVAL                                                                       }\
    {rx_is_lockedtodata           output    output        1                         export                     NOVAL                                   NOVAL             rx_is_lockedtodata         conduit           end              NOVAL                                                                        }\
    {tx_cal_busy                  output    output        1                         export                     NOVAL                                   NOVAL             tx_cal_busy                conduit           end              NOVAL                                                                        }\
    {rx_cal_busy                  output    output        1                         export                     NOVAL                                   NOVAL             rx_cal_busy                conduit           end              NOVAL                                                                        }\
    {rx_data_ready                output    output        1                         export                     NOVAL                                   NOVAL             rx_data_ready              conduit           end              NOVAL                                                                        }\
    {rx_block_lock                output    output        1                         export                     "!OPTIONAL_10G"                         NOVAL             rx_block_lock              conduit           end              NOVAL                                                                        }\
    {rx_hi_ber                    output    output        1                         export                     "!OPTIONAL_10G"                         NOVAL             rx_hi_ber                  conduit           end              NOVAL                                                                        }\
    {tx_serial_data               output    output        1                         export                     NOVAL                                   NOVAL             tx_serial_data             conduit           end              NOVAL                                                                        }\
    {rx_serial_data               input     input         1                         export                     NOVAL                                   NOVAL             rx_serial_data             conduit           end              NOVAL                                                                        }\
    {rx_latency_adj_10g           output    output        16                        data                       "!SYNTH_1588_10G"                       NOVAL             rx_latency_adj_10g         conduit           end              NOVAL                                                                        }\
    {tx_latency_adj_10g           output    output        16                        data                       "!SYNTH_1588_10G"                       NOVAL             tx_latency_adj_10g         conduit           end              NOVAL                                                                        }\
    \
    {lcl_rf                       input     input         1                         export                     "!SYNTH_AN"                             NOVAL             lcl_rf                     conduit           end              NOVAL                                                                        }\
    {rx_prbs_err_clr              input     input         1                         export                     "!HARD_PRBS_ENABLE_PORT"                NOVAL             rx_prbs_err_clr            conduit           end              NOVAL                                                                        }\
    {rx_prbs_done                 output    output        1                         export                     "!HARD_PRBS_ENABLE_PORT"                NOVAL             rx_prbs_done               conduit           end              NOVAL                                                                        }\
    {rx_prbs_err                  output    output        1                         export                     "!HARD_PRBS_ENABLE_PORT"                NOVAL             rx_prbs_err                conduit           end              NOVAL                                                                        }\
  }

}

proc ::altera_xcvr_10gkr_s10::interfaces::declare_interfaces {} {
  variable interfaces
  ip_declare_interfaces $interfaces
}

proc ::altera_xcvr_10gkr_s10::interfaces::elaborate {} {
  ip_elaborate_interfaces
}

proc ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock {PROP_IFACE_NAME} {
  ip_set "interface.${PROP_IFACE_NAME}.associated_clock" mgmt_clk
}

# Comment out following proc since XGMII is not avalon-streaming anymore- hence no need of associated clock 
#proc ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock_xgmii_tx {PROP_IFACE_NAME} {
#  ip_set "interface.${PROP_IFACE_NAME}.associated_clock" xgmii_tx_clk
#  set_interface_property ${PROP_IFACE_NAME} dataBitsPerSymbol 72
#}
#
#proc ::altera_xcvr_10gkr_s10::interfaces::elaborate_associated_clock_xgmii_rx {PROP_IFACE_NAME} {
#  ip_set "interface.${PROP_IFACE_NAME}.associated_clock" xgmii_rx_clk
#  set_interface_property ${PROP_IFACE_NAME} dataBitsPerSymbol 72
#}

