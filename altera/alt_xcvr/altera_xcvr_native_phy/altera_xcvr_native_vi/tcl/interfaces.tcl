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


package provide altera_xcvr_native_vi::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages

namespace eval ::altera_xcvr_native_vi::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_interfaces \
    elaborate

  variable interfaces

  set interfaces {\
    {NAME                         DIRECTION UI_DIRECTION  WIDTH_EXPR                            ROLE                      TERMINATION                                                                                                         TERMINATION_VALUE IFACE_NAME                  IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT                   SPLIT_WIDTH         SPLIT_COUNT   ELABORATION_CALLBACK }\
    {tx_analogreset               input     input         l_channels                            tx_analogreset            !tx_enable                                                                                                          NOVAL             tx_analogreset              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_analogreset_ack           output    output        l_channels                            tx_analogreset_ack        "!tx_enable || !enable_port_tx_analog_reset_ack"                                                                    NOVAL             tx_analogreset_ack          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_digitalreset              input     input         l_channels                            tx_digitalreset           !tx_enable                                                                                                          NOVAL             tx_digitalreset             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_analogreset               input     input         l_channels                            rx_analogreset            !rx_enable                                                                                                          NOVAL             rx_analogreset              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_analogreset_ack           output    output        l_channels                            rx_analogreset_ack        "!rx_enable || !enable_port_rx_analog_reset_ack"                                                                    NOVAL             rx_analogreset_ack          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_digitalreset              input     input         l_channels                            rx_digitalreset           !rx_enable                                                                                                          NOVAL             rx_digitalreset             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_cal_busy                  output    output        l_channels                            tx_cal_busy               !tx_enable                                                                                                          NOVAL             tx_cal_busy                 conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_cal_busy                  output    output        l_channels                            rx_cal_busy               !rx_enable                                                                                                          NOVAL             rx_cal_busy                 conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_serial_clk0               input     input         l_channels                            clk                       "!tx_enable || l_enable_pma_bonding || (plls < 1)"                                                                  NOVAL             tx_serial_clk0              hssi_serial_clock end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_serial_clk1               input     input         l_channels                            clk                       "!tx_enable || l_enable_pma_bonding || (plls < 2)"                                                                  NOVAL             tx_serial_clk1              hssi_serial_clock end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_serial_clk2               input     input         l_channels                            clk                       "!tx_enable || l_enable_pma_bonding || (plls < 3)"                                                                  NOVAL             tx_serial_clk2              hssi_serial_clock end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_serial_clk3               input     input         l_channels                            clk                       "!tx_enable || l_enable_pma_bonding || (plls < 4)"                                                                  NOVAL             tx_serial_clk3              hssi_serial_clock end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_bonding_clocks            input     input         l_channels*6                          clk                       !l_enable_pma_bonding                                                                                               NOVAL             tx_bonding_clocks           hssi_bonded_clock end             true    l_split_iface           6                   l_channels    NOVAL       }\
    {tx_bonding_clocks1           input     input         l_channels*6                          clk                       "!(l_enable_pma_bonding&&(number_physical_bonding_clocks > 1))"                                                        NOVAL             tx_bonding_clocks1          hssi_bonded_clock end             true    l_split_iface           6                   l_channels    NOVAL       }\
    {tx_bonding_clocks2           input     input         l_channels*6                          clk                       "!(l_enable_pma_bonding&&(number_physical_bonding_clocks > 2))"                                                        NOVAL             tx_bonding_clocks2          hssi_bonded_clock end             true    l_split_iface           6                   l_channels    NOVAL       }\
    {tx_bonding_clocks3           input     input         l_channels*6                          clk                       "!(l_enable_pma_bonding&&(number_physical_bonding_clocks > 3))"                                                        NOVAL             tx_bonding_clocks3          hssi_bonded_clock end             true    l_split_iface           6                   l_channels    NOVAL       }\
    \
    {rx_cdr_refclk0               input     input         1                                     clk                       "!rx_enable || (cdr_refclk_cnt < 1)"                                                                                0                 rx_cdr_refclk0              clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {rx_cdr_refclk1               input     input         1                                     clk                       "!rx_enable || (cdr_refclk_cnt < 2)"                                                                                0                 rx_cdr_refclk1              clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {rx_cdr_refclk2               input     input         1                                     clk                       "!rx_enable || (cdr_refclk_cnt < 3)"                                                                                0                 rx_cdr_refclk2              clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {rx_cdr_refclk3               input     input         1                                     clk                       "!rx_enable || (cdr_refclk_cnt < 4)"                                                                                0                 rx_cdr_refclk3              clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {rx_cdr_refclk4               input     input         1                                     clk                       "!rx_enable || (cdr_refclk_cnt < 5)"                                                                                0                 rx_cdr_refclk4              clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    \
    {tx_serial_data               output    output        l_channels                            tx_serial_data            !tx_enable                                                                                                          NOVAL             tx_serial_data              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_serial_data               input     input         l_channels                            rx_serial_data            !rx_enable                                                                                                          NOVAL             rx_serial_data              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_pma_clkslip               input     input         l_channels                            rx_pma_clkslip            "!rx_enable || !enable_port_rx_pma_clkslip"                                                                         NOVAL             rx_pma_clkslip              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_seriallpbken              input     input         l_channels                            rx_seriallpbken           "!(tx_enable && enable_port_rx_seriallpbken_tx) && !(rx_enable && enable_port_rx_seriallpbken)"                     NOVAL             rx_seriallpbken             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_set_locktodata            input     input         l_channels                            rx_set_locktodata         "!rx_enable || !enable_ports_rx_manual_cdr_mode"                                                                    NOVAL             rx_set_locktodata           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_set_locktoref             input     input         l_channels                            rx_set_locktoref          "!rx_enable || !enable_ports_rx_manual_cdr_mode"                                                                    NOVAL             rx_set_locktoref            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_is_lockedtoref            output    output        l_channels                            rx_is_lockedtoref         "!rx_enable || !enable_port_rx_is_lockedtoref"                                                                      NOVAL             rx_is_lockedtoref           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_is_lockedtodata           output    output        l_channels                            rx_is_lockedtodata        "!rx_enable || !enable_port_rx_is_lockedtodata"                                                                     NOVAL             rx_is_lockedtodata          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_pma_qpipulldn             input     input         l_channels                            rx_pma_qpipulldn          "!rx_enable || !enable_port_rx_pma_qpipulldn"                                                                       NOVAL             rx_pma_qpipulldn            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_qpipulldn             input     input         l_channels                            tx_pma_qpipulldn          "!tx_enable || !enable_port_tx_pma_qpipulldn"                                                                       NOVAL             tx_pma_qpipulldn            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_qpipullup             input     input         l_channels                            tx_pma_qpipullup          "!tx_enable || !enable_port_tx_pma_qpipullup"                                                                       NOVAL             tx_pma_qpipullup            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_txdetectrx            input     input         l_channels                            tx_pma_txdetectrx         "!tx_enable || !enable_port_tx_pma_txdetectrx"                                                                      NOVAL             tx_pma_txdtectrx            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_elecidle              input     input         l_channels                            tx_pma_elecidle           "!tx_enable || !enable_port_tx_pma_elecidle"                                                                        NOVAL             tx_pma_elecidle             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_rxfound               output    output        l_channels                            tx_pma_rxfound            "!tx_enable || !enable_port_tx_pma_rxfound"                                                                         NOVAL             tx_pma_rxfound              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_clklow                    output    output        l_channels                            rx_clklow                 "!rx_enable || !enable_ports_rx_manual_ppm"                                                                         NOVAL             rx_clklow                   conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_fref                      output    output        l_channels                            rx_fref                   "!rx_enable || !enable_ports_rx_manual_ppm"                                                                         NOVAL             rx_fref                     conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_coreclkin                 input     input         l_channels                            clk                       "!tx_enable || enable_hip"                                                                                          NOVAL             tx_coreclkin                clock             sink            true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_coreclkin                 input     input         l_channels                            clk                       "!rx_enable || enable_hip"                                                                                          NOVAL             rx_coreclkin                clock             sink            true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_clkout                    output    output        l_channels                            clk                       "!tx_enable || enable_hip"                                                                                          NOVAL             tx_clkout                   clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_clkout                    output    output        l_channels                            clk                       "!rx_enable || (enable_hip && !enable_skp_ports)"                                                                   NOVAL             rx_clkout                   clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_clkout                output    output        l_channels                            clk                       "!tx_enable || !enable_port_tx_pma_clkout"                                                                          NOVAL             tx_pma_clkout               clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_div_clkout            output    output        l_channels                            clk                       "!tx_enable || !enable_port_tx_pma_div_clkout"                                                                      NOVAL             tx_pma_div_clkout           clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_pma_iqtxrx_clkout         output    output        l_channels                            clk                       "!tx_enable || !enable_port_tx_pma_iqtxrx_clkout"                                                                   NOVAL             tx_pma_iqtxrx_clkout        clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_pma_clkout                output    output        l_channels                            clk                       "!rx_enable || !enable_port_rx_pma_clkout"                                                                          NOVAL             rx_pma_clkout               clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_pma_div_clkout            output    output        l_channels                            clk                       "!rx_enable || !enable_port_rx_pma_div_clkout"                                                                      NOVAL             rx_pma_div_clkout           clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_pma_iqtxrx_clkout         output    output        l_channels                            clk                       "!rx_enable || !enable_port_rx_pma_iqtxrx_clkout"                                                                   NOVAL             rx_pma_iqtxrx_clkout        clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_parallel_data             input     input         l_channels*128                        tx_parallel_data          "!tx_enable || enable_hip"                                                                                          NOVAL             tx_parallel_data            conduit           end             true    l_split_iface           128                 l_channels    ::altera_xcvr_native_vi::interfaces::elaborate_tx_parallel_data}\
    {tx_control                   input     input         l_channels*18                         tx_control                "!l_enable_tx_enh_iface || (l_enable_tx_enh && enable_simple_interface && enh_pld_pcs_width <= 64)"                 NOVAL             tx_control                  conduit           end             true    l_split_iface           18                  l_channels    ::altera_xcvr_native_vi::interfaces::elaborate_tx_control}\
    {unused_tx_parallel_data      input     input         NOVAL                                 NOVAL                     NOVAL                                                                                                               NOVAL             NOVAL                       conduit           end             true    NOVAL                   NOVAL               NOVAL         ::altera_xcvr_native_vi::interfaces::elaborate_unused_tx_parallel_data}\
    {unused_tx_control            input     input         NOVAL                                 NOVAL                     NOVAL                                                                                                               NOVAL             NOVAL                       conduit           end             true    NOVAL                   NOVAL               NOVAL         ::altera_xcvr_native_vi::interfaces::elaborate_unused_tx_control}\
    \
    {rx_parallel_data             output    output        l_channels*128                        rx_parallel_data          "!rx_enable || (enable_hip && !enable_skp_ports)"                                                                   NOVAL             rx_parallel_data            conduit           end             true    l_split_iface           128                 l_channels    ::altera_xcvr_native_vi::interfaces::elaborate_rx_parallel_data}\
    {rx_control                   output    output        l_channels*20                         rx_control                "!l_enable_rx_enh_iface || (l_enable_rx_enh && enable_simple_interface && enh_pld_pcs_width <= 64)"                 NOVAL             rx_control                  conduit           end             true    l_split_iface           20                  l_channels    ::altera_xcvr_native_vi::interfaces::elaborate_rx_control}\
    {unused_rx_parallel_data      output    output        NOVAL                                 NOVAL                     NOVAL                                                                                                               NOVAL             NOVAL                       conduit           end             true    NOVAL                   NOVAL               NOVAL         ::altera_xcvr_native_vi::interfaces::elaborate_unused_rx_parallel_data}\
    {unused_rx_control            output    output        NOVAL                                 NOVAL                     NOVAL                                                                                                               NOVAL             NOVAL                       conduit           end             true    NOVAL                   NOVAL               NOVAL         ::altera_xcvr_native_vi::interfaces::elaborate_unused_rx_control}\
    \
    {rx_bitslip                   input     input         l_channels                            rx_bitslip                "(!l_enable_rx_std_iface||!enable_port_rx_std_bitslip)&&(!l_enable_rx_enh_iface||!enable_port_rx_enh_bitslip)"      NOVAL             rx_bitslip                  conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_adapt_reset               input     input         l_channels                            rx_adapt_reset            "!rx_enable || !enable_ports_adaptation"                                                                            NOVAL             rx_adapt_reset              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_adapt_start               input     input         l_channels                            rx_adapt_start            "!rx_enable || !enable_ports_adaptation"                                                                            NOVAL             rx_adapt_start              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_prbs_err_clr              input     input         l_channels                            rx_prbs_err_clr           "!rx_enable || !enable_ports_rx_prbs"                                                                               NOVAL             rx_prbs_err_clr             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_prbs_done                 output    output        l_channels                            rx_prbs_done              "!rx_enable || !enable_ports_rx_prbs"                                                                               NOVAL             rx_prbs_done                conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_prbs_err                  output    output        l_channels                            rx_prbs_err               "!rx_enable || !enable_ports_rx_prbs"                                                                               NOVAL             rx_prbs_err                 conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_uhsif_clk                 input     input         l_channels                            clk                       true                                                                                                                NOVAL             tx_uhsif_clk                clock             sink            true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_uhsif_clkout              output    output        l_channels                            clk                       true                                                                                                                NOVAL             tx_uhsif_clkout             clock             source          true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_uhsif_lock                output    output        l_channels                            tx_uhsif_lock             true                                                                                                                NOVAL             tx_uhsif_lock               conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_std_pcfifo_full           output    output        l_channels                            tx_std_pcfifo_full        "!l_enable_tx_std_iface || !enable_port_tx_std_pcfifo_full"                                                         NOVAL             tx_std_pcfifo_full          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_std_pcfifo_empty          output    output        l_channels                            tx_std_pcfifo_empty       "!l_enable_tx_std_iface || !enable_port_tx_std_pcfifo_empty"                                                        NOVAL             tx_std_pcfifo_empty         conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_std_pcfifo_full           output    output        l_channels                            rx_std_pcfifo_full        "!l_enable_rx_std_iface || !enable_port_rx_std_pcfifo_full"                                                         NOVAL             rx_std_pcfifo_full          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_std_pcfifo_empty          output    output        l_channels                            rx_std_pcfifo_empty       "!l_enable_rx_std_iface || !enable_port_rx_std_pcfifo_empty"                                                        NOVAL             rx_std_pcfifo_empty         conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_std_bitrev_ena            input     input         l_channels                            rx_std_bitrev_ena         "!l_enable_rx_std_iface || !enable_port_rx_std_bitrev_ena"                                                          NOVAL             rx_std_bitrev_ena           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_std_byterev_ena           input     input         l_channels                            rx_std_byterev_ena        "!l_enable_rx_std_iface || !enable_port_rx_std_byterev_ena"                                                         NOVAL             rx_std_byterev_ena          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_polinv                    input     input         l_channels                            tx_polinv                 "!l_enable_tx_std_iface || !enable_port_tx_polinv"                                                                  NOVAL             tx_polinv                   conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_polinv                    input     input         l_channels                            rx_polinv                 "!l_enable_rx_std_iface || !enable_port_rx_polinv"                                                                  NOVAL             rx_polinv                   conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_std_bitslipboundarysel    input     input         l_channels*5                          tx_std_bitslipboundarysel "!l_enable_tx_std_iface || !enable_port_tx_std_bitslipboundarysel"                                                  NOVAL             tx_std_bitslipboundarysel   conduit           end             true    l_split_iface           5                   l_channels    NOVAL       }\
    {rx_std_bitslipboundarysel    output    output        l_channels*5                          rx_std_bitslipboundarysel "!l_enable_rx_std_iface || !enable_port_rx_std_bitslipboundarysel"                                                  NOVAL             rx_std_bitslipboundarysel   conduit           end             true    l_split_iface           5                   l_channels    NOVAL       }\
    \
    {rx_std_wa_patternalign       input     input         l_channels                            rx_std_wa_patternalign    "!l_enable_rx_std_iface || !enable_port_rx_std_wa_patternalign"                                                     NOVAL             rx_std_wa_patternalign      conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_std_wa_a1a2size           input     input         l_channels                            rx_std_wa_a1a2size        "!l_enable_rx_std_iface || !enable_port_rx_std_wa_a1a2size"                                                         NOVAL             rx_std_wa_a1a2size          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_std_rmfifo_full           output    output        l_channels                            rx_std_rmfifo_full        "!l_enable_rx_std_iface || !enable_port_rx_std_rmfifo_full"                                                         NOVAL             rx_std_rmfifo_full          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_std_rmfifo_empty          output    output        l_channels                            rx_std_rmfifo_empty       "!l_enable_rx_std_iface || !enable_port_rx_std_rmfifo_empty"                                                        NOVAL             rx_std_rmfifo_empty         conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_std_signaldetect          output    output        l_channels                            rx_std_signaldetect       "!l_enable_rx_std_iface || !enable_port_rx_std_signaldetect"                                                        NOVAL             rx_std_signaldetect         conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_enh_data_valid            input     input         l_channels                            tx_enh_data_valid         !l_enable_tx_enh_iface                                                                                              NOVAL             tx_enh_data_valid           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_fifo_full             output    output        l_channels                            tx_enh_fifo_full          "!l_enable_tx_enh_iface || !enable_port_tx_enh_fifo_full"                                                           NOVAL             tx_enh_fifo_full            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_fifo_pfull            output    output        l_channels                            tx_enh_fifo_pfull         "!l_enable_tx_enh_iface || !enable_port_tx_enh_fifo_pfull"                                                          NOVAL             tx_enh_fifo_pfull           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_fifo_empty            output    output        l_channels                            tx_enh_fifo_empty         "!l_enable_tx_enh_iface || !enable_port_tx_enh_fifo_empty"                                                          NOVAL             tx_enh_fifo_empty           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_fifo_pempty           output    output        l_channels                            tx_enh_fifo_pempty        "!l_enable_tx_enh_iface || !enable_port_tx_enh_fifo_pempty"                                                         NOVAL             tx_enh_fifo_pempty          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_fifo_cnt              output    output        l_channels*4                          tx_enh_fifo_cnt           "!l_enable_tx_enh_iface || !enable_port_tx_enh_fifo_cnt"                                                            NOVAL             tx_enh_fifo_cnt             conduit           end             true    l_split_iface           4                   l_channels    NOVAL       }\
    \
    {rx_enh_fifo_rd_en            input     input         l_channels                            rx_enh_fifo_rd_en         "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_rd_en"                                                          NOVAL             rx_enh_fifo_rd_en           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_data_valid            output    output        l_channels                            rx_enh_data_valid         "!l_enable_rx_enh_iface || !enable_port_rx_enh_data_valid"                                                          NOVAL             rx_enh_data_valid           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_full             output    output        l_channels                            rx_enh_fifo_full          "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_full"                                                           NOVAL             rx_enh_fifo_full            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_pfull            output    output        l_channels                            rx_enh_fifo_pfull         "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_pfull"                                                          NOVAL             rx_enh_fifo_pfull           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_empty            output    output        l_channels                            rx_enh_fifo_empty         "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_empty"                                                          NOVAL             rx_enh_fifo_empty           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_pempty           output    output        l_channels                            rx_enh_fifo_pempty        "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_pempty"                                                         NOVAL             rx_enh_fifo_pempty          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_del              output    output        l_channels                            rx_enh_fifo_del           "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_del"                                                            NOVAL             rx_enh_fifo_del             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_insert           output    output        l_channels                            rx_enh_fifo_insert        "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_insert"                                                         NOVAL             rx_enh_fifo_insert          conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_cnt              output    output        l_channels*5                          rx_enh_fifo_cnt           "!l_enable_tx_enh_iface || !enable_port_rx_enh_fifo_cnt"                                                            NOVAL             rx_enh_fifo_cnt             conduit           end             true    l_split_iface           5                   l_channels    NOVAL       }\
    {rx_enh_fifo_align_val        output    output        l_channels                            rx_enh_fifo_align_val     "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_align_val"                                                      NOVAL             rx_enh_fifo_align_val       conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_fifo_align_clr        input     input         l_channels                            rx_enh_fifo_align_clr     "!l_enable_rx_enh_iface || !enable_port_rx_enh_fifo_align_clr"                                                      NOVAL             rx_enh_fifo_align_clr       conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_enh_frame                 output    output        l_channels                            tx_enh_frame              "!l_enable_tx_enh_iface || (!enable_port_tx_enh_frame && !enable_port_krfec_tx_enh_frame)"                          NOVAL             tx_enh_frame                conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_frame_burst_en        input     input         l_channels                            tx_enh_frame_burst_en     "!l_enable_tx_enh_iface || !enable_port_tx_enh_frame_burst_en"                                                      NOVAL             tx_enh_burst_en             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {tx_enh_frame_diag_status     input     input         l_channels*2                          tx_enh_frame_diag_status  "!l_enable_tx_enh_iface || !enable_port_tx_enh_frame_diag_status"                                                   NOVAL             tx_enh_frame_diag_status    conduit           end             true    l_split_iface           2                   l_channels    NOVAL       }\
    \
    {rx_enh_frame                 output    output        l_channels                            rx_enh_frame              "!l_enable_rx_enh_iface || (!enable_port_rx_enh_frame && !enable_port_krfec_rx_enh_frame)"                          NOVAL             rx_enh_frame                conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_frame_lock            output    output        l_channels                            rx_enh_frame_lock         "!l_enable_rx_enh_iface || !enable_port_rx_enh_frame_lock"                                                          NOVAL             rx_enh_frame_lock           conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_frame_diag_status     output    output        l_channels*2                          rx_enh_frame_diag_status  "!l_enable_rx_enh_iface || (!enable_port_rx_enh_frame_diag_status && !enable_port_krfec_rx_enh_frame_diag_status)"  NOVAL             rx_enh_frame_diag_status    conduit           end             true    l_split_iface           2                   l_channels    NOVAL       }\
    \
    {rx_enh_crc32_err             output    output        l_channels                            rx_enh_crc32err           "!l_enable_rx_enh_iface || !enable_port_rx_enh_crc32_err"                                                           NOVAL             rx_enh_crc32err             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_enh_highber               output    output        l_channels                            rx_enh_highber            "!l_enable_rx_enh_iface || !enable_port_rx_enh_highber"                                                             NOVAL             rx_enh_highber              conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_highber_clr_cnt       input     input         l_channels                            rx_enh_highber_clr_cnt    "!l_enable_rx_enh_iface || !enable_port_rx_enh_highber_clr_cnt"                                                     NOVAL             rx_enh_highber_clr_cnt      conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {rx_enh_clr_errblk_count      input     input         l_channels                            rx_enh_clr_errblk_count   "!l_enable_rx_enh_iface || !enable_port_rx_enh_clr_errblk_count"                                                    NOVAL             rx_enh_clr_errblk_count     conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {rx_enh_blk_lock              output    output        l_channels                            rx_enh_blk_lock           "!l_enable_rx_enh_iface || !enable_port_rx_enh_blk_lock"                                                            NOVAL             rx_enh_blk_lock             conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {tx_enh_bitslip               input     input         l_channels*7                          tx_enh_bitslip            "!l_enable_tx_enh_iface || !enable_port_tx_enh_bitslip"                                                             NOVAL             tx_enh_bitslip              conduit           end             true    l_split_iface           7                   l_channels    NOVAL       }\
    \
    {tx_hip_data                  input     input         l_channels*64                         tx_hip_data               !enable_hip                                                                                                         NOVAL             tx_hip_data                 conduit           end             true    l_split_iface           64                  l_channels    NOVAL       }\
    {rx_hip_data                  output    output        l_channels*51                         rx_hip_data               !enable_hip                                                                                                         NOVAL             rx_hip_data                 conduit           end             true    l_split_iface           51                  l_channels    NOVAL       }\
    {hip_pipe_pclk                output    output        1                                     hip_pipe_pclk             !enable_hip                                                                                                         NOVAL             hip_pipe_pclk               conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {hip_fixedclk                 output    output        1                                     hip_fixedclk              !enable_hip                                                                                                         NOVAL             hip_fixedclk                conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {hip_frefclk                  output    output        l_channels                            hip_frefclk               !enable_hip                                                                                                         NOVAL             hip_frefclk                 conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {hip_ctrl                     output    output        l_channels*8                          hip_ctrl                  !enable_hip                                                                                                         NOVAL             hip_ctrl                    conduit           end             true    l_split_iface           8                   l_channels    NOVAL       }\
    {hip_cal_done                 output    output        l_channels                            hip_cal_done              !enable_hip                                                                                                         NOVAL             hip_cal_done                conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {ltssm_detect_quiet           input     input         1                                     ltssm_detect_quiet        "!(enable_pcie_dfe_ip || enable_hip)"                                                                               NOVAL             ltssm_detect_quiet          conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {ltssm_detect_active          input     input         1                                     ltssm_detect_active       "!(enable_pcie_dfe_ip || enable_hip)"                                                                               NOVAL             ltssm_detect_active         conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {ltssm_rcvr_phase_two         input     input         1                                     ltssm_rcvr_phase_two      "!(enable_pcie_dfe_ip || enable_hip)"                                                                               NOVAL             ltssm_rcvr_phase_two        conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {hip_reduce_counters          input     input         1                                     hip_reduce_counters       "!enable_hip"                                                                                                      NOVAL             hip_reduce_counters         conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pcie_rate                    input     input         2                                     pcie_rate                 "!enable_hip"                                                                                                       NOVAL             pcie_rate                   conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_rate                    input     input         "2+((l_channels-1)*enable_hip*2)"     pipe_rate                 "!l_enable_tx_std_iface || !enable_ports_pipe_sw"                                                                   NOVAL             pipe_rate                   conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_sw_done                 input     input         2                                     pipe_sw_done              "!l_enable_tx_std_iface || !enable_ports_pipe_sw"                                                                   NOVAL             pipe_sw_done                conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_sw                      output    output        2                                     pipe_sw                   "!l_enable_tx_std_iface || !enable_ports_pipe_sw"                                                                   NOVAL             pipe_sw                     conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_hclk_in                 input     input         1                                     clk                       "!l_enable_tx_std_iface || !enable_ports_pipe_hclk"                                                                 NOVAL             pipe_hclk_in                clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_hclk_out                output    output        1                                     clk                       "!l_enable_tx_std_iface || !enable_ports_pipe_hclk || enable_hip"                                                   NOVAL             pipe_hclk_out               clock             source          true    NOVAL                   NOVAL               NOVAL         NOVAL       }\
    {pipe_g3_txdeemph             input     input         l_channels*18                         pipe_g3_txdeemph          "!l_enable_tx_std_iface || !enable_ports_pipe_g3_analog"                                                            NOVAL             pipe_g3_txdeemph            conduit           end             true    l_split_iface           18                  l_channels    NOVAL       }\
    {pipe_g3_rxpresethint         input     input         l_channels*3                          pipe_g3_rxpresethint      "!l_enable_tx_std_iface || !enable_ports_pipe_g3_analog"                                                            NOVAL             pipe_g3_rxpresethint        conduit           end             true    l_split_iface           3                   l_channels    NOVAL       }\
    {pipe_rx_eidleinfersel        input     input         l_channels*3                          pipe_rx_eidleinfersel     "!l_enable_tx_std_iface || !enable_ports_pipe_rx_elecidle"                                                          NOVAL             pipe_rx_eidleinfersel       conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {pipe_rx_elecidle             output    output        l_channels                            pipe_rx_elecidle          "!l_enable_tx_std_iface || !enable_ports_pipe_rx_elecidle"                                                          NOVAL             pipe_rx_elecidle            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    {pipe_rx_polarity             input     input         l_channels                            pipe_rx_polarity          "!l_enable_tx_std_iface || !enable_port_pipe_rx_polarity"                                                           NOVAL             pipe_rx_polarity            conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
    \
    {reconfig_clk                 input     input         "l_rcfg_ifaces"                       clk                       !rcfg_enable                                                                                                        NOVAL             reconfig_clk                clock             sink            true    l_split_iface           1                   l_rcfg_ifaces NOVAL       }\
    {reconfig_reset               input     input         "l_rcfg_ifaces"                       reset                     !rcfg_enable                                                                                                        NOVAL             reconfig_reset              reset             sink            true    l_split_iface           1                   l_rcfg_ifaces ::altera_xcvr_native_vi::interfaces::elaborate_reconfig_reset  }\
    {reconfig_write               input     input         "l_rcfg_ifaces"                       write                     !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           1                   l_rcfg_ifaces ::altera_xcvr_native_vi::interfaces::elaborate_reconfig_avmm   }\
    {reconfig_read                input     input         "l_rcfg_ifaces"                       read                      !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           1                   l_rcfg_ifaces NOVAL       }\
    {reconfig_address             input     input         "l_rcfg_ifaces*l_rcfg_addr_bits"      address                   !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           l_rcfg_addr_bits    l_rcfg_ifaces NOVAL       }\
    {reconfig_writedata           input     input         "l_rcfg_ifaces*32"                    writedata                 !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           32                  l_rcfg_ifaces NOVAL       }\
    {reconfig_readdata            output    input         "l_rcfg_ifaces*32"                    readdata                  !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           32                  l_rcfg_ifaces NOVAL       }\
    {reconfig_waitrequest         output    input         "l_rcfg_ifaces"                       waitrequest               !rcfg_enable                                                                                                        NOVAL             reconfig_avmm               avalon            slave           true    l_split_iface           1                   l_rcfg_ifaces NOVAL       }\
    {avmm_busy                    output    input         l_channels                            avmm_busy                 "!rcfg_enable || !rcfg_enable_avmm_busy_port || !enable_advanced_avmm_options"                                      NOVAL             avmm_busy                   conduit           end             true    l_split_iface           1                   l_channels    NOVAL       }\
  }

}


proc ::altera_xcvr_native_vi::interfaces::declare_interfaces {} {
  variable interfaces
  # We want our interfaces declared as conduits in native mode
  ip_set_auto_conduit_in_native_mode 1
  ip_set_iface_split_suffix "_ch"
  ip_declare_interfaces $interfaces
}


proc ::altera_xcvr_native_vi::interfaces::elaborate {} {
  ip_elaborate_interfaces
}


###############################################################################
########################## TX parallel data elaboration #######################
proc ::altera_xcvr_native_vi::interfaces::elaborate_tx_parallel_data { PROP_IFACE_SPLIT_INDEX rcfg_iface_enable datapath_select l_split_iface l_enable_tx_std l_enable_tx_enh \
    l_enable_tx_pcs_dir enable_hip l_enable_std_pipe protocol_mode l_std_tx_word_width l_std_tx_word_count l_std_tx_field_width \
    enable_simple_interface l_channels std_tx_8b10b_enable std_tx_8b10b_disp_ctrl_enable enh_pld_pcs_width pcs_direct_width enh_rxtxfifo_double_width } {

  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr 128 * $PROP_IFACE_SPLIT_INDEX]
  
  # modify values of "l_enable_tx_std" "l_enable_tx_enh" "l_enable_tx_pcs_dir" based on rcfg_iface_enable --> datapath and interface reconfiguration
  set l_enable_tx_std       [expr {$rcfg_iface_enable ? ( $datapath_select == "Standard"   && $l_enable_tx_std     ) : $l_enable_tx_std}]
  set l_enable_tx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_tx_enh     ) : $l_enable_tx_enh}]
  set l_enable_tx_pcs_dir   [expr {$rcfg_iface_enable ? ( $datapath_select == "PCS Direct" && $l_enable_tx_pcs_dir ) : $l_enable_tx_pcs_dir}]

  if {$l_enable_tx_std && !$enable_hip} {
    # Standard PCS datapath
    create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count $l_std_tx_word_width 0 used $add_offset "tx_parallel_data"
    # tx_datak
    if {$std_tx_8b10b_enable} {
      create_fragmented_interface $enable_simple_interface "tx_datak${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 8 used $add_offset "tx_datak"
    }
    # tx_forcedisp
    if {!$l_enable_std_pipe && $std_tx_8b10b_enable && $std_tx_8b10b_disp_ctrl_enable} {
      create_fragmented_interface $enable_simple_interface "tx_forcedisp${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 9 used $add_offset "tx_forcedisp"
    }
    # tx_dispval
    if {!$l_enable_std_pipe && $std_tx_8b10b_enable && $std_tx_8b10b_disp_ctrl_enable} {
      create_fragmented_interface $enable_simple_interface "tx_dispval${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 10 used $add_offset "tx_dispval"
    }
    if {$l_enable_std_pipe} {
      create_fragmented_interface $enable_simple_interface "pipe_tx_compliance${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 9 used $add_offset "pipe_tx_compliance"
      create_fragmented_interface $enable_simple_interface "pipe_tx_elecidle${sfx}" "tx_parallel_data" input $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 10 used $add_offset "pipe_tx_elecidle"
      create_fragmented_interface $enable_simple_interface "pipe_tx_detectrx_loopback${sfx}" "tx_parallel_data" input $l_channels 128 128 1 1 46 used $add_offset "pipe_tx_detectrx_loopback"
      create_fragmented_interface $enable_simple_interface "pipe_powerdown${sfx}" "tx_parallel_data" input $l_channels 128 128 1 2 47 used $add_offset "pipe_powerdown"
      create_fragmented_interface $enable_simple_interface "pipe_tx_margin${sfx}" "tx_parallel_data" input $l_channels 128 128 1 3 49 used $add_offset "pipe_tx_margin"
      if {$protocol_mode == "pipe_g2"} {
        create_fragmented_interface $enable_simple_interface "pipe_tx_deemph${sfx}" "tx_parallel_data" input $l_channels 128 128 1 1 52 used $add_offset "pipe_tx_deemph"
      }
      create_fragmented_interface $enable_simple_interface "pipe_tx_swing${sfx}" "tx_parallel_data" input $l_channels 128 128 1 1 53 used $add_offset "pipe_tx_swing"
      if {$protocol_mode == "pipe_g3"} {
        create_fragmented_interface $enable_simple_interface "pipe_tx_sync_hdr${sfx}" "tx_parallel_data" input $l_channels 128 128 1 2 54 used $add_offset "pipe_tx_sync_hdr"
        create_fragmented_interface $enable_simple_interface "pipe_tx_blk_start${sfx}" "tx_parallel_data" input $l_channels 128 128 1 1 56 used $add_offset "pipe_tx_blk_start"
        create_fragmented_interface $enable_simple_interface "pipe_tx_data_valid${sfx}" "tx_parallel_data" input $l_channels 128 128 1 1 60 used $add_offset "pipe_tx_data_valid"
      }
    }
  } elseif {$l_enable_tx_enh} {
    # Enhanced PCS datapath
    if {!$enh_rxtxfifo_double_width} {
       set width $enh_pld_pcs_width
       if { $enh_pld_pcs_width > 64 } {
         set width 64
       }
       create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels 128 $width 1 $width 0 used $add_offset "tx_parallel_data"
    } else {
        ip_message info "Follow user manual to determine proper connections for \"tx_parallel_data port\" in double width fifo mode."
    }
  } elseif {$l_enable_tx_pcs_dir} {
    # PCS Direct datapath
    create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels 128 $pcs_direct_width 1 $pcs_direct_width 0 used $add_offset "tx_parallel_data"
  }
  
  
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_tx_control { PROP_IFACE_SPLIT_INDEX rcfg_iface_enable datapath_select l_split_iface l_enable_tx_enh l_channels enable_simple_interface enh_pld_pcs_width protocol_mode } {

  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr 18 * $PROP_IFACE_SPLIT_INDEX]
  
  # modify value of "l_enable_tx_enh" based on rcfg_iface_enable --> datapath and interface reconfiguration
  set l_enable_tx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_tx_enh     ) : $l_enable_tx_enh}]

  if {$l_enable_tx_enh && $enable_simple_interface && $enh_pld_pcs_width > 64} {
    if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
      set width 8
    } else {
      set width [expr {$enh_pld_pcs_width - 64}]
    }
    create_fragmented_interface $enable_simple_interface "tx_control${sfx}" "tx_control" input $l_channels 18 $width 1 $width 0 used $add_offset "tx_control"
    #tx_err_ins
    if {($protocol_mode == "teng_baser_mode"  || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode" || $protocol_mode == "interlaken_mode")} {
       create_fragmented_interface $enable_simple_interface "tx_err_ins${sfx}" "tx_control" input $l_channels 18 18 1 1 8 used $add_offset "tx_err_ins"
    }
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_unused_tx_parallel_data { l_enable_tx_std l_enable_tx_enh l_enable_tx_pcs_dir enable_hip l_enable_std_pipe protocol_mode l_std_tx_word_width l_std_tx_word_count l_std_tx_field_width enable_simple_interface l_channels std_tx_8b10b_enable std_tx_8b10b_disp_ctrl_enable enh_pld_pcs_width pcs_direct_width } {
  if {$enable_simple_interface} {
    set unused_list {}
    if {$l_enable_tx_std && !$enable_hip } {
      set width $l_std_tx_word_width
      if {$std_tx_8b10b_enable || $l_enable_std_pipe } {
        set width 9
        if {$std_tx_8b10b_disp_ctrl_enable || $l_enable_std_pipe} {
          set width 11
        }
      }
      set unused_list [create_expanded_index_list $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count $width 0 unused]
      if {$l_enable_std_pipe} {
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 9 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_tx_field_width $l_std_tx_word_count 1 10 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 46 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 2 47 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 3 49 unused]]
        if {$protocol_mode == "pipe_g2"} {
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 52 unused]]
        }
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 53 unused]]
        if {$protocol_mode == "pipe_g3"} {
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 2 54 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 56 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 60 unused]]
        }
      }
    } elseif {$l_enable_tx_enh && $enable_simple_interface} {
      set width $enh_pld_pcs_width
      if {$enh_pld_pcs_width > 64} {
        set width 64
      }
      set unused_list [create_expanded_index_list $l_channels 128 128 1 $width 0 unused]
    } elseif {$l_enable_tx_pcs_dir} {
      set unused_list [create_expanded_index_list $l_channels 128 128 1 $pcs_direct_width 0 unused]
    }
    if {[llength $unused_list] > 0} {
      create_fragmented_conduit "unused_tx_parallel_data" [add_fragment_prefix $unused_list "tx_parallel_data"] input input
    }
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_unused_tx_control { PROP_IFACE_SPLIT_INDEX l_split_iface l_enable_tx_enh l_channels enable_simple_interface enh_pld_pcs_width protocol_mode } {
  if {$l_enable_tx_enh && $enable_simple_interface} {
    if {$enh_pld_pcs_width > 64} {
      if {$protocol_mode == "interlaken_mode" } {
        # Interlaken
        # 3 bits of tx_control
        set unused_list [create_expanded_index_list $l_channels 18 3 1 3 0 unused]
        # 1 bit of tx_err_ins
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 18 18 1 1 8 unused]]
      } else {
        # All other protocols
        if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
          # 8 bits of tx_control and 1 bit of tx_err_ins
          set width 9
        } else {
          set width [expr {$enh_pld_pcs_width - 64}]
        }
        # Create unused list
        set unused_list [create_expanded_index_list $l_channels 18 18 1 $width 0 unused]
      }
      create_fragmented_conduit "unused_tx_control" [add_fragment_prefix $unused_list "tx_control"] input input
    }
  }
}
######################## End TX parallel data elaboration #####################
###############################################################################


###############################################################################
########################## RX parallel data elaboration #######################
proc ::altera_xcvr_native_vi::interfaces::elaborate_rx_parallel_data { PROP_IFACE_SPLIT_INDEX rcfg_iface_enable datapath_select l_split_iface l_enable_rx_std l_enable_rx_enh l_enable_rx_pcs_dir enable_hip l_enable_std_pipe protocol_mode l_std_rx_word_width l_std_rx_word_count l_std_rx_field_width enable_simple_interface l_channels std_rx_8b10b_enable std_rx_word_aligner_mode std_rx_rmfifo_mode enh_pld_pcs_width pcs_direct_width enh_rxtxfifo_double_width } {

  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr 128 * $PROP_IFACE_SPLIT_INDEX]
  
  # modify values of "l_enable_rx_std" "l_enable_rx_enh" "l_enable_rx_pcs_dir" based on rcfg_iface_enable --> datapath and interface reconfiguration
  set l_enable_rx_std       [expr {$rcfg_iface_enable ? ( $datapath_select == "Standard"   && $l_enable_rx_std     ) : $l_enable_rx_std}]
  set l_enable_rx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_rx_enh     ) : $l_enable_rx_enh}]
  set l_enable_rx_pcs_dir   [expr {$rcfg_iface_enable ? ( $datapath_select == "PCS Direct" && $l_enable_rx_pcs_dir ) : $l_enable_rx_pcs_dir}]

  if {$l_enable_rx_std && !$enable_hip} {
    create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count $l_std_rx_word_width 0 used $add_offset "rx_parallel_data"
    if {$std_rx_8b10b_enable} {
      create_fragmented_interface $enable_simple_interface "rx_datak${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 8 used $add_offset "rx_datak"
    }
    if {!$l_enable_std_pipe} {
      if {$std_rx_8b10b_enable} {
        create_fragmented_interface $enable_simple_interface "rx_errdetect${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 9 used $add_offset "rx_errdetect"
        create_fragmented_interface $enable_simple_interface "rx_disperr${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 11 used $add_offset "rx_disperr"
        create_fragmented_interface $enable_simple_interface "rx_runningdisp${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 15 used $add_offset "rx_runningdisp"
      }
      if {$std_rx_word_aligner_mode != "bitslip" } {
        create_fragmented_interface $enable_simple_interface "rx_patterndetect${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 12 used $add_offset "rx_patterndetect"
      }
      if {$std_rx_rmfifo_mode != "disabled" } {
        create_fragmented_interface $enable_simple_interface "rx_rmfifostatus${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 2 13 used $add_offset "rx_rmfifostatus"
      }
    }
    if {$std_rx_word_aligner_mode != "bitslip" } {
      create_fragmented_interface $enable_simple_interface "rx_syncstatus${sfx}" "rx_parallel_data" output $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 10 used $add_offset "rx_syncstatus"
    }
    if {$l_enable_std_pipe} {
      create_fragmented_interface $enable_simple_interface "pipe_phy_status${sfx}" "rx_parallel_data" output $l_channels 128 128 1 1 65 used $add_offset "pipe_phy_status"
      create_fragmented_interface $enable_simple_interface "pipe_rx_valid${sfx}" "rx_parallel_data" output $l_channels 128 128 1 1 66 used $add_offset "pipe_rx_valid"
      create_fragmented_interface $enable_simple_interface "pipe_rx_status${sfx}" "rx_parallel_data" output $l_channels 128 128 1 3 67 used $add_offset "pipe_rx_status"
      if {$protocol_mode == "pipe_g3"} {
        create_fragmented_interface $enable_simple_interface "pipe_rx_sync_hdr${sfx}" "rx_parallel_data" output $l_channels 128 128 1 2 70 used $add_offset "pipe_rx_sync_hdr"
        create_fragmented_interface $enable_simple_interface "pipe_rx_blk_start${sfx}" "rx_parallel_data" output $l_channels 128 128 1 1 72 used $add_offset "pipe_rx_blk_start"
        create_fragmented_interface $enable_simple_interface "pipe_rx_data_valid${sfx}" "rx_parallel_data" output $l_channels 128 128 1 1 76 used $add_offset "pipe_rx_data_valid"
      }
    }
  } elseif {$l_enable_rx_enh} {
    if {!$enh_rxtxfifo_double_width} {
       set width $enh_pld_pcs_width
       if { $enh_pld_pcs_width > 64 } {
         set width 64
       }
       create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels 128 $width 1 $width 0 used $add_offset "rx_parallel_data"
    } else {
        ip_message info "Follow user manual to determine proper connections for \"rx_parallel_data port\" in double width fifo mode."
    }
  } elseif {$l_enable_rx_pcs_dir} {
    create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels 128 $pcs_direct_width 1 $pcs_direct_width 0 used $add_offset "rx_parallel_data"
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_rx_control { PROP_IFACE_SPLIT_INDEX rcfg_iface_enable datapath_select l_split_iface l_enable_rx_enh l_channels enable_simple_interface enh_pld_pcs_width protocol_mode } {

  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr 128 * $PROP_IFACE_SPLIT_INDEX]
  
  # modify value of "l_enable_rx_enh" based on rcfg_iface_enable --> datapath and interface reconfiguration
  set l_enable_rx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_rx_enh     ) : $l_enable_rx_enh}]

  if {$l_enable_rx_enh && $enable_simple_interface && $enh_pld_pcs_width > 64} {
    if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
      set width 8 
    } elseif {$protocol_mode == "interlaken_mode"} {
      set width 10
    } else {
      set width [expr {$enh_pld_pcs_width - 64}]
    }
    create_fragmented_interface $enable_simple_interface "rx_control${sfx}" "rx_control" output $l_channels 20 $width 1 $width 0 used $add_offset "rx_control"
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_unused_rx_parallel_data { l_enable_rx_std l_enable_rx_enh l_enable_rx_pcs_dir enable_hip l_enable_std_pipe protocol_mode l_std_rx_word_width l_std_rx_word_count l_std_rx_field_width enable_simple_interface l_channels std_rx_8b10b_enable std_rx_word_aligner_mode std_rx_rmfifo_mode enh_pld_pcs_width pcs_direct_width } {
  if {$enable_simple_interface} {
    set unused_list {}
    if {$l_enable_rx_std && !$enable_hip} {
      set unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count $l_std_rx_word_width 0 unused]
      if {$std_rx_8b10b_enable} {
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 8 unused]]
        if {!$l_enable_std_pipe} {
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 9 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 11 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 15 unused]]
        }
      }
      if {$std_rx_word_aligner_mode != "bitslip"} {
        if {!$l_enable_std_pipe} {
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 10 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 1 12 unused]]
        }
      }
      if {$std_rx_rmfifo_mode != "disabled" && !$l_enable_std_pipe} {
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 $l_std_rx_field_width $l_std_rx_word_count 2 13 unused]]
      }

      if {$l_enable_std_pipe} {
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 65 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 66 unused]]
        set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 3 67 unused]]
        if {$protocol_mode == "pipe_g3"} {
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 2 70 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 72 unused]]
          set unused_list [::alt_xcvr::utils::common::intersect $unused_list [create_expanded_index_list $l_channels 128 128 1 1 76 unused]]
        }
      }
      
    } elseif {$l_enable_rx_enh} {
      set width $enh_pld_pcs_width
      if {$enh_pld_pcs_width > 64} {
        set width 64
      }
      set unused_list [create_expanded_index_list $l_channels 128 128 1 $width 0 unused]
    } elseif {$l_enable_rx_pcs_dir} {
      set unused_list [create_expanded_index_list $l_channels 128 128 1 $pcs_direct_width 0 unused]
    }
    if {[llength $unused_list] > 0} {
      create_fragmented_conduit "unused_rx_parallel_data" [add_fragment_prefix $unused_list "rx_parallel_data"] output output
    }
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_unused_rx_control { l_enable_rx_enh l_channels enable_simple_interface enh_pld_pcs_width protocol_mode } {
  if {$l_enable_rx_enh && $enable_simple_interface} {
    if {$enh_pld_pcs_width > 64} {
      if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
        set width 8
      } elseif {$protocol_mode == "interlaken_mode"} {
        set width 10
      } else {
        set width [expr {$enh_pld_pcs_width - 64}]
      }
      set unused_list [create_expanded_index_list $l_channels 20 20 1 $width 0 unused]
      create_fragmented_conduit "unused_rx_control" [add_fragment_prefix $unused_list "rx_control"] output output
    }
  }
}

######################## End RX parallel data elaboration #####################
###############################################################################
proc ::altera_xcvr_native_vi::interfaces::elaborate_reconfig_reset { PROP_IFACE_NAME design_environment l_split_iface } {
  if { $design_environment != "NATIVE" } {
    set reconfig_clk "reconfig_clk"
    if {$l_split_iface} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_clk\1} reconfig_clk  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $reconfig_clk
  }
}


proc ::altera_xcvr_native_vi::interfaces::elaborate_reconfig_avmm { PROP_IFACE_NAME design_environment l_split_iface device_revision} {
  if { $design_environment != "NATIVE" } {
    set reconfig_clk "reconfig_clk"
    set reconfig_reset "reconfig_reset"
    if {$l_split_iface} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_clk\1} reconfig_clk  
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_reset\1} reconfig_reset  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $reconfig_clk
    ip_set "interface.${PROP_IFACE_NAME}.associatedreset" $reconfig_reset
    ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "debug.typeName" "altera_xcvr_native_a10.slave"]
	ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "debug.param.device_revision" $device_revision]
  }
}


