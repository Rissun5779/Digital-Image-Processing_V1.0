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


package provide altera_pcie_s10_hip_avmm_bridge::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace eval ::altera_pcie_s10_hip_avmm_bridge::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_parameters \
    validate \
    get_validated

  variable package_name
  variable validated
  variable display_items
  variable parameters
  variable mapped_parameters
  variable parameter_overrides
  variable rxm_specific_parameters
  set interface_type_integer_hwtcl 1
  set package_name "altera_pcie_s10_hip_avmm_bridge::parameters"
  set validated 0

   set display_items {\
    {NAME                                         GROUP                               ENABLED             VISIBLE                                                                                          TYPE  ARGS }\
    {"IP Settings"                                ""                                  NOVAL               True                                                                                             GROUP tab  }\
    {"Example Designs"                            ""                                  NOVAL               NOVAL                                                   GROUP tab   }\
    {"Available Example Designs"                  "Example Designs"                   NOVAL               NOVAL                                                   GROUP NOVAL }\
    {"Example Design Files"                       "Example Designs"                   NOVAL               NOVAL                                                   GROUP NOVAL }\
    {"Generated HDL Format"                       "Example Designs"                   NOVAL               NOVAL                                                   GROUP NOVAL }\
    {"Target Development Kit"                     "Example Designs"                   NOVAL               NOVAL                                                   GROUP NOVAL }\
    {"System Settings"                            "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"Avalon-MM Settings"                         "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"Base and Limit Registers for Root Ports"    "IP Settings"                       NOVAL               "(virtual_rp_ep_mode_integer_hwtcl>0) && (virtual_rp_ep_mode_integer_hwtcl<2)"                   GROUP tab  }\
    {"Base Address Registers"                     "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"BAR0"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"BAR1"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"BAR2"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"BAR3"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"BAR4"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"BAR5"                                       "Base Address Registers"            NOVAL               True                                                                                             GROUP tab  }\
    {"Device Identification Registers"            "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"Physical Function 0 IDs"                    "Device Identification Registers"   NOVAL               True                                                                                             GROUP tab  }\
    {"PCI Express / PCI Capabilities"             "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"Device"                                     "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"Link"                                       "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"MSI"                                        "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"MSI-X"                                      "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"Slot"                                       "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"Power Management"                           "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"VSEC"                                       "PCI Express / PCI Capabilities"    NOVAL               True                                                                                             GROUP tab  }\
    {"Configuration, Debug and Extension Options" "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"PHY Characteristics"                        "IP Settings"                       NOVAL               True                                                                                             GROUP tab  }\
    {"PCI Express Attributes"                     "IP Settings"                       NOVAL               False                                                                                            GROUP tab  }\
    {"Simulation Options"                         "IP Settings"                       NOVAL               False                                                                                            GROUP tab  }\
  }





set parameters {\
{NAME                                             DERIVED AFFECTS_VALIDATION  HDL_PARAMETER           TYPE      DEFAULT_VALUE                   ALLOWED_RANGES                                                                                                                                 ENABLED                                  VISIBLE                                                                                               DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                                  DISPLAY_NAME                                                            VALIDATION_CALLBACK                                                               DESCRIPTION }\
{interface_type_hwtcl                             true    true                false                   STRING    "Avalon-MM"                     {"Avalon-MM" }                                                                                                                    true                                     true                                                                                                  NOVAL         NOVAL         "System Settings"                             "Application interface type"                                            NOVAL                                                                            "Selects either the Avalon Streaming or Avalon Memory Map interface, Avalon Memory Map interface only supported within Qsys"}\
{app_interface_width_hwtcl                        true    true                false                   STRING    "256-bit"                       { "256-bit"}                                                                                                                                   true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "Application interface width"                                           NOVAL                                                                            "Selects the width of the data interface between the transaction layer and the application layer implemented in the PLD fabric. The IP core supports interfaces of 256 bits."}\
{wrala_hwtcl                                      false   true                false                   STRING    "Gen1x1, Interface - 256 bit, 125 MHz"   { "Gen3x16, Interface - 256 bit, 500 MHz"  \
                                                                                                                                                           "Gen3x8, Interface - 256 bit, 250 MHz"  \
                                                                                                                                                           "Gen3x4, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen3x2, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen3x1, Interface - 256 bit, 125 MHz"   \
                                                                                                                                                           "Gen2x16, Interface - 256 bit, 250 MHz"   \
                                                                                                                                                           "Gen2x8, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen2x4, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen2x2, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen2x1, Interface - 256 bit, 125 MHz"   \
                                                                                                                                                           "Gen1x16, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen1x8, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen1x4, Interface - 256 bit, 125 MHz" \
                                                                                                                                                           "Gen1x2, Interface - 256 bit, 125 MHz"  \
                                                                                                                                                           "Gen1x1, Interface - 256 bit, 125 MHz"   }                                                                                          true                                     true                                                                                                  NOVAL         NOVAL         "System Settings"                             "HIP Mode"                                                              ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_wrala_hwtcl                          "Selects the width of the data interface between the transaction layer and the application layer implemented in the PLD fabric, the lane data rate and the lane rate "}\
{wrala_integer_hwtcl                              true    true                false                   INTEGER   14                              {0:14}                                                                                                                                         true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "HIP Mode Integer"                                                      NOVAL                                                                            "Integer Mapping of wrala_hwtcl"}\
\
{virtual_rp_ep_mode_hwtcl                         false   true                false                   STRING    "Native endpoint"               {"Native endpoint" "Root port" }                                                                                                               true                                     true                                                                                                  NOVAL         NOVAL         "System Settings"                             "Port type"                                                             NOVAL                                                                            "Selects the port type. Native endpoints and root ports are supported."}\
{virtual_rp_ep_mode_integer_hwtcl                 true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{virtual_link_width_hwtcl                         true    true                false                   STRING    "x1"                            {"x1" "x2" "x4" "x8" "x16"}                                                                                                                    true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "Number of lanes"                                                       NOVAL                                                                            "Selects the maximum number of lanes supported. The IP core supports 1, 2, 4, or 8 lanes."}\
{virtual_link_width_integer_hwtcl                 true    true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{virtual_link_rate_hwtcl                          true    true                false                   STRING    "Gen1 (2.5 Gbps)"               {"Gen1 (2.5 Gbps)" "Gen2 (5.0 Gbps)" "Gen3 (8.0 Gbps)"}                                                                                        true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "Lane rate"                                                             NOVAL                                                                            "Selects the maximum data rate of the link. Gen1 (2.5 Gbps), Gen2 (5.0 Gbps) and Gen3 (8.0 Gbps) are supported."}\
{virtual_link_rate_integer_hwtcl                  true    true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{interface_type_integer_hwtcl                     true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
\
{enable_rx_buffer_limit_ports_hwtcl               false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "System Settings"                             "Enable Rx Buffer Limit Ports "                                         NOVAL                                                                            "When selected, RX buffer limit ports will be exported for User to control RX Posted, Non-Posted and CplD Packets. Else Max Buffer Size will be used"}\
{rx_np_buffer_limit_bypass_hwtcl                  false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "System Settings"                             "Enable Non-Posted Rx Buffer Limit Bypass"                              NOVAL                                                                            "When selected, RX buffer limit selected for Non-Posted packets will be bypassed"}\
{rx_p_buffer_limit_bypass_hwtcl                   false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "System Settings"                             "Enable Posted Rx Buffer Limit Bypass"                                  NOVAL                                                                            "When selected, RX buffer limit selected for Posted packets will be bypassed"}\
{rx_cpl_buffer_limit_bypass_hwtcl                 false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "System Settings"                             "Enable Completion Rx Buffer Limit Bypass"                              NOVAL                                                                            "When selected, RX buffer limit selected for Completion packets will be bypassed" }\
\
\
{pf0_bar0_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pf0_bar1_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pf0_bar2_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pf0_bar3_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pf0_bar4_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pf0_bar5_type_integer_hwtcl                      true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
\
{pf0_bar0_type_hwtcl                              false   true                false                   STRING    "64-bit prefetchable memory"    { "Disabled" "64-bit prefetchable memory" "32-bit non-prefetchable memory" \
                                                                                                                                                       }                                                                                                                                       true                                     true                                                                                                  NOVAL         NOVAL         "BAR0"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar0_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR0"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar0_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar0_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR0"                                        "Enable burst capability for Avalon-MM BAR0 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar0_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR0 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_bar1_type_hwtcl                              false   true                false                   STRING    "Disabled"                      { "Disabled" "32-bit non-prefetchable memory" \
                                                                                                                                                       }                                                                                                                                       true                                     true                                                                                                  NOVAL         NOVAL         "BAR1"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar1_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR1"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar1_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar1_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR1"                                        "Enable burst capability for RXM Avalon-MM BAR1 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar1_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR1 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_bar2_type_hwtcl                              false   true                false                   STRING    "Disabled"                      { "Disabled" "64-bit prefetchable memory" "32-bit non-prefetchable memory" \
                                                                                                                                                       }                                                                                                                                       true                                     true                                                                                                  NOVAL         NOVAL         "BAR2"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar2_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR2"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar2_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar2_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR2"                                        "Enable burst capability for RXM Avalon-MM BAR2 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar2_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR2 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_bar3_type_hwtcl                              false   true                false                   STRING    "Disabled"                      { "Disabled" "32-bit non-prefetchable memory" \
                                                                                                                                                      }                                                                                                                                        true                                     true                                                                                                  NOVAL         NOVAL         "BAR3"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar3_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR3"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar3_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar3_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR3"                                        "Enable burst capability for RXM Avalon-MM BAR3 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar3_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR3 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_bar4_type_hwtcl                              false   true                false                   STRING    "Disabled"                      { "Disabled" "64-bit prefetchable memory" "32-bit non-prefetchable memory" \
                                                                                                                                                       }                                                                                                                                       true                                      true                                                                                                 NOVAL         NOVAL         "BAR4"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar4_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR4"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar4_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar4_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR4"                                        "Enable burst capability for RXM Avalon-MM BAR4 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar4_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR4 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_bar5_type_hwtcl                              false   true                false                   STRING    "Disabled"                      { "Disabled" "32-bit non-prefetchable memory" \
                                                                                                                                                       }                                                                                                                                       true                                     true                                                                                                  NOVAL         NOVAL         "BAR5"                                        "Type"                                                                  NOVAL                                                                            "Sets the BAR type."}\
{pf0_bar5_address_width_hwtcl                     true    true                true                    INTEGER   28                              NOVAL                                                                                                                                          true                                     true          NOVAL         "bit"         "BAR5"                                        "Size"                                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar5_address_width_hwtcl             "Number of bits per base address register (BAR)."} \
{pf0_bar5_enable_rxm_burst_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                 boolean       NOVAL          "BAR5"                                        "Enable burst capability for RXM Avalon-MM BAR5 Master port"                            ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar5_enable_rxm_burst_hwtcl  "Enable burst capabilities for the BAR5 RXM. If this option is set to true,the RXM port will be a bursting master. Otherwise, this RXM will be a single DW master."}\
\
{pf0_expansion_base_address_register_hwtcl        false   true                true                    INTEGER   0                               { "0:Disabled" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" \
                                                                                                                                                       "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" \
                                                                                                                                                       "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits"}                                   !interface_type_integer_hwtcl            false                                                                                                 NOVAL         NOVAL         "Expansion ROM"                               "Size"                                                                  NOVAL                                                                            "Specifies an expansion ROM from 4 KBytes - 16 MBytes when enabled."}\
\
{pf0_rom_bar_enabled_hwtcl                        true    true                false                   STRING    "disable"                       {"disable" "enable"}                                                                                                                           true                                     false                                                                                                 NOVAL         NOVAL         "Expansion ROM"                               "Enable Expansion ROM"                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_rom_bar_enabled_hwtcl                                                                             "Enable or Disable Expansion ROM "}\
\
{avmm_addr_width_hwtcl                            false   true                true                    INTEGER   64                              {"32:32-bit" "64:64-bit"}                                                                                                                      true                                     true                                                                                                  NOVAL         NOVAL         "Avalon-MM Settings"                   "Avalon-MM address width"                                               ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_avmm_addr_width_hwtcl                 "Selects the Avalon-MM address width"}\
{dma_enabled_hwtcl                                false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Enable Avalon-MM DMA."                                                  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_include_dma_hwtcl                     "Enable Avalon-MM DMA.If this option is set to true, read and write data mover will be included."}\
{enable_cra_slave_port_hwtcl                      false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Enable control register access (CRA) Avalon-MM slave port"             ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_cg_impl_cra_av_slave_port_hwtcl       "Enable/Disable the Control Register Access port"}\
{enable_advanced_interrupt_hwtcl                  false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Export Interrupt conduit interfaces"                                   NOVAL                                                                             "Export internal signals to support generation of Legacy Interrupts/multiple MSI/MSI-X"}\
{enable_hip_status_for_avmm_hwtcl                 false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Enable Hard IP Status Bus when using the AVMM interface"               NOVAL                                                                             "Enable/Disable HIP Status signals in your top-level AVMM design."}\
{dma_controller_enabled_hwtcl                     false   true                true                    INTEGER   1                               NOVAL                                                                                                                                          true                                     dma_enabled_hwtcl                                                                                     boolean       NOVAL         "Avalon-MM Settings"                   "Instantiate internal descriptor controller"                            NOVAL                                                                             "Instantiate a descriptor controller within this variant. If this option is set to true, this variant will provide a descriptor controller along with read and write DMA engines. The descriptor controller will utilize BAR0 and BAR1. Otherwise, DMA engine ports will be exposed to allow for custom descriptor controllers."}\
{txs_enabled_hwtcl                                false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Enable  non-bursting Avalon-MM Slave interface with individual byte access. (TXS)."                    ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_txs_enabled_hwtcl                 "Enable TX Slave interface which supports single DW Write/Read for smaller area utilization."} \
{user_txs_address_width_hwtcl                        false   true                false                   INTEGER   22                              {20:64}                                                                                                                                        true                                     "(avmm_addr_width_hwtcl > 32 && txs_enabled_hwtcl)"                                                    NOVAL         NOVAL         "Avalon-MM Settings"                   "Address width of accessible PCIe memory space(TXS)"                         NOVAL                                                                             "The address width of accessible memory space"}\
{hptxs_enabled_hwtcl                              false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Avalon-MM Settings"                   "Enable High Performance bursting Avalon-MM Slave interface (HPTXS)."                       ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_hptxs_enabled_hwtcl                "Enable TX Slave interface with burst capabilities"} \
{user_hptxs_address_width_hwtcl                      false   true                false                   INTEGER   22                              {20:64}                                                                                                                                        true                                     "(avmm_addr_width_hwtcl > 32 && hptxs_enabled_hwtcl)"                                                  NOVAL         NOVAL         "Avalon-MM Settings"                   "Address width of accessible PCIe memory space(HPTXS)"                         NOVAL                                                                             "The address width of accessible memory space"}\
{hptxs_address_translation_table_address_width_hwtcl                false   true                true                    INTEGER   2                               {"2" "4" "8" "16" "32" "64" "128" "256" "512"}                                                                                                 true                                     "(avmm_addr_width_hwtcl < 64 && hptxs_enabled_hwtcl)"                                                                        NOVAL         NOVAL         "Avalon-MM Settings"                   "Number of address pages(HPTXS)"                                               NOVAL                                                                             "Sets the number of in-consecutive address ranges of the PCI Express system that can be accessed"}\
{hptxs_address_translation_window_address_width_hwtcl             false   true                true                    INTEGER   12                              {"12:4 KByte - 12 bits" "13:8 KByte - 13 bits" "14:16 KByte - 14 bits" "15:32 KBytes - 15 bits" "16:64 KBytes - 16 bits" \
                                                                                                                                                     "17:128 KBytes - 17 bits" "18:256 KBytes - 18 bits" "19:512 KBytes - 19 bits" "20:1 MByte - 20 bits" "21:2 MByte - 21 bits" \
                                                                                                                                                     "22:4 MByte - 22 bits" "23:8 MByte - 23 bits" "24:16 MByte - 24 bits" "25:32 MBytes - 25 bits" "26:64 MBytes - 26 bits" \
                                                                                                                                                     "27:128 MBytes - 27 bits" "28:256 MBytes - 28 bits" "29:512 MBytes - 29 bits" "30:1 GByte - 30 bits" "31:2 GByte - 31 bits" \
                                                                                                                                                     "32:4 GByte - 32 bits"}                                                                                                                   true                                     "(avmm_addr_width_hwtcl < 64 && hptxs_enabled_hwtcl)"                                                                        NOVAL         NOVAL         "Avalon-MM Settings"                   "Size of address pages(HPTXS)"                                                 NOVAL                                           "Sets the size of the PCI Express system pages. All pages must be the same size"}\
\
\
{txs_address_width_hwtcl                             true    true                true                    INTEGER   15                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_txs_addr_width                                                                                  NOVAL}\
{hptxs_address_width_hwtcl                           true    true                true                    INTEGER   15                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_hptxs_addr_width                                                                                NOVAL}\
{data_width_integer_rxm0_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm0_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm0_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm0_hwtcl                                                                                 NOVAL}\
{data_width_integer_rxm1_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm1_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm1_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm1_hwtcl                                                                                 NOVAL}\
{data_width_integer_rxm2_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm2_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm2_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm2_hwtcl                                                                                 NOVAL}\
{data_width_integer_rxm3_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm3_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm3_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm3_hwtcl                                                                                 NOVAL}\
{data_width_integer_rxm4_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm4_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm4_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm4_hwtcl                                                                                 NOVAL}\
{data_width_integer_rxm5_hwtcl                     true    true                false                    INTEGER   32                              NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm5_hwtcl                                                                              NOVAL}\
{data_byte_width_integer_rxm5_hwtcl                true    true                false                   INTEGER   4                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm5_hwtcl                                                                                 NOVAL}\
\
{virtual_maxpayload_size_hwtcl                    false   true                false                   STRING    "128"                           { "128:128 Bytes" "256:256 Bytes" "512:512 Bytes" "1024:1024 Bytes" }                                                                          true                                     true                                                                                                  NOVAL         NOVAL         "Device"                                      "Maximum payload size"                                                  NOVAL                                                                            "Sets the read-only value of the max payload size of the Device Capabilities register and optimizes for this payload size."}\
{pf0_pcie_cap_ext_tag_supp_hwtcl                  false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          !interface_type_integer_hwtcl            !interface_type_integer_hwtcl                                                                         boolean       NOVAL         "Device"                                      "Support Extended Tag Field"                                            NOVAL                                                                            "Sets the Extended Tag Field Supported bit in Configuration Space Device Capabilities Register."}\
\
{pf0_pcie_cap_port_num_hwtcl                      false   true                false                   INTEGER   1                               { 0:255 }                                                                                                                                      true                                     true                                                                                                  NOVAL         NOVAL         "Link"                                        "Link port number(Root Port only)"                                      NOVAL                                                                            "Sets the read-only value of the port number field in the Link Capabilities register."}\
{pf0_pcie_cap_slot_clk_config_hwtcl               false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Link"                                        "Slot clock configuration"                                              NOVAL                                                                            "Set the read-only value of the slot clock configuration bit in the link status register."}\
\
{pf0_pci_msi_multiple_msg_cap_hwtcl               false   true                false                   STRING    "4"                             { "1" "2" "4" "8" "16" "32"}                                                                                                                   true                                     true                                                                                                  NOVAL         NOVAL         "MSI"                                         "Number of MSI messages requested"                                      NOVAL                                                                            "Sets the number of messages that the application can request in the multiple message capable field of the Message Control register."}\
\
{virtual_pf0_msix_enable_hwtcl                    false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "MSI-X"                                       "Implement MSI-X"                                                       NOVAL                                                                            "Enables or disables the MSI-X capability."}\
{pf0_pci_msix_table_size_hwtcl                    false   true                false                   INTEGER   0                               { 0:2047 }                                                                                                                                     true                                     true                                                                                                  NOVAL         NOVAL         "MSI-X"                                       "Table size"                                                            NOVAL                                                                            "Sets the number of entries in the MSI-X table."}\
{pf0_pci_msix_table_offset_hwtcl                  false   true                false                   LONG      0                               { 0:4294967295 }                                                                                                                               true                                     true                                                                                                  hexadecimal   NOVAL         "MSI-X"                                       "Table offset"                                                          NOVAL                                                                            "Sets the read-only base address of the MSI-X table. The low-order 3 bits are automatically set to 0."}\
{pf0_pci_msix_bir_hwtcl                           false   true                false                   INTEGER   0                               { 0:5 }                                                                                                                                        true                                     true                                                                                                  NOVAL         NOVAL         "MSI-X"                                       "Table BAR indicator"                                                   NOVAL                                                                            "Specifies which one of a function's base address registers, located beginning at 0x10 in the Configuration Space, maps the MSI-X table into memory space. This field is read-only."}\
{pf0_pci_msix_pba_offset_hwtcl                    false   true                false                   LONG      0                               { 0:4294967295 }                                                                                                                               true                                     true                                                                                                  hexadecimal   NOVAL         "MSI-X"                                       "Pending bit array (PBA) offset"                                        NOVAL                                                                            "Specifies the offset from the address stored in one of the function's base address registers the points to the base of the MSI-X PBA. This field is read-only."}\
{pf0_pci_msix_pba_hwtcl                           false   true                false                   INTEGER   0                               { 0:5 }                                                                                                                                        true                                     true                                                                                                  NOVAL         NOVAL         "MSI-X"                                       "PBA BAR Indicator"                                                     NOVAL                                                                            "Indicates which of a function's base address registers, located beginning at 0x10 in the Configuration Space, maps the function's MSI-X PBA into memory space. This field is read-only."}\
\
{pf0_pcie_slot_imp_hwtcl                          false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Slot"                                        "Use Slot Power registers (Root Port only)"                             NOVAL                                                                            "Enables the slot register when Enabled. This register is required for root ports if a slot is implemented on the port. Slot status is recorded in the PCI Express Capabilities register."}\
{pf0_pcie_cap_slot_power_limit_value_hwtcl        false   true                false                   INTEGER   0                               { 0:3 }                                                                                                                                        true                                     true                                                                                                  NOVAL         NOVAL         "Slot"                                        "Slot power scale"                                                      NOVAL                                                                            "Sets the scale used for the Slot power limit value, as follows: 0=1.0<n>, 1=0.1<n>, 2=0.01<n>, 3=0.001<n>."}\
{pf0_pcie_cap_slot_power_limit_scale_hwtcl        false   true                false                   INTEGER   0                               { 0:255 }                                                                                                                                      true                                     true                                                                                                  NOVAL         NOVAL         "Slot"                                        "Slot power limit"                                                      NOVAL                                                                            "Sets the upper limit (in Watts) of power supplied by the slot in conjunction with the slot power scale register. For more information, refer to the PCI Express Base Specification."}\
{pf0_pcie_cap_phy_slot_num_hwtcl                  false   true                false                   INTEGER   0                               { 0:8191 }                                                                                                                                     true                                     true                                                                                                  NOVAL         NOVAL         "Slot"                                        "Slot number"                                                           NOVAL                                                                            "Specifies the physical slot number associated with a port."}\
\
{pf0_pcie_cap_ep_l0s_accpt_latency_hwtcl          false   true                false                   INTEGER   0                               { "0:Maximum of 64 ns" "1:Maximum of 128 ns" "2:Maximum of 256 ns" "3:Maximum of 512 ns" "4:Maximum of 1 us" "5:Maximum of 2 us" \
                                                                                                                                                       "6:Maximum of 4 us" "7:No limit" }                                                                                                      true                                     true                                                                                                  NOVAL         NOVAL         "Power Management"                            "Endpoint L0s acceptable latency"                                       NOVAL                                                                            "Sets the read-only value of the endpoint L0s acceptable latency field of the Device Capabilities register. This value should be based on the latency that the application layer can tolerate. This setting is disabled for root ports."}\
{pf0_pcie_cap_ep_l1_accpt_latency_hwtcl           false   true                false                   INTEGER   0                               { "0:Maximum of 1 us" "1:Maximum of 2 us" "2:Maximum of 4 us" "3:Maximum of 8 us" "4:Maximum of 16 us" "5:Maximum of 32 us" \
                                                                                                                                                       "6:Maximum of 4 us" "7:No limit" }                                                                                                      true                                     true                                                                                                  NOVAL         NOVAL         "Power Management"                            "Endpoint L0s acceptable latency"                                       NOVAL                                                                            "Sets the read-only value of the endpoint L0s acceptable latency field of the Device Capabilities register. This value should be based on the latency that the application layer can tolerate. This setting is disabled for root ports."}\
\
{cvp_user_id_hwtcl                                false   true                false                   INTEGER   0                               { 0:65534 }                                                                                                                                    true                                     true                                                                                                  hexadecimal   NOVAL         "VSEC"                                        "User ID register from the Vendor Specific Extended Capability"         NOVAL                                                                            "Sets the read-only value of the 16-bit User ID register from the Vendor Specific Extended Capability"}\
\
{hip_reconfig_hwtcl                               false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     true                                                                                                  boolean       NOVAL         "Configuration, Debug and Extension Options"  "Enable dynamic reconfiguration of PCIe read-only registers"            NOVAL                                                                            "When on, creates an Avalon-MM slave interface that software can drive to update global configuration registers which are read-only at run time."}\
{xcvr_reconfig_hwtcl                              false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "Configuration, Debug and Extension Options"  "Enable Transceiver dynamic reconfiguration"                            NOVAL                                                                            "When on, creates an Avalon-MM slave interface that software can drive to update Transceiver reconfiguration registers"}\
\
{pf0_pcie_cap_sel_deemphasis_hwtcl                false   true                false                   STRING    "6dB"                           { "6dB" "3.5dB" }                                                                                                                              true                                     true                                                                                                  NOVAL         NOVAL         "PHY Characteristics"                         "Gen 2 TX de-emphasis"                                                  NOVAL                                                                            "Changes the de-emphasis level on Gen 2 TX. Applies only to Gen2 variants."}\
\
{ceb_extend_pcie_hwtcl                            false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "Use PCI Express extended space"                                        NOVAL                                                                            "When enabled, addresses 0xC00-0xFFC in the PCI Express Configuration Space Header are reserved for PCI Express extensions"}\
\
{pf0_pci_type0_vendor_id_hwtcl                    false   true                false                   INTEGER   4466                            { 0:65534 }                                                                                                                                    true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Vendor ID"                                                             NOVAL                                                                            "Sets the read-only value of the Vendor ID register."}\
{pf0_pci_type0_device_id_hwtcl                    false   true                false                   INTEGER   0                               { 0:65534 }                                                                                                                                    true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Device ID"                                                             NOVAL                                                                            "Sets the read-only value of the Device ID register."}\
{pf0_revision_id_hwtcl                            false   true                false                   INTEGER   1                               { 0:255 }                                                                                                                                      true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Revision ID"                                                           NOVAL                                                                            "Sets the read-only value of the Revision ID register."}\
{pf0_class_code_hwtcl                             false   true                false                   INTEGER   0                               { 0:16777215 }                                                                                                                                 true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Class code"                                                            NOVAL                                                                            "Sets the read-only value of the Class code register."}\
{pf0_base_class_code_hwtcl                        true    true                false                   INTEGER   0                               { 0:255 }                                                                                                                                      true                                     false                                                                                                 hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Base Class code"                                                       ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_base_class_code_hwtcl            NOVAL}\
{pf0_subclass_code_hwtcl                          ture    true                false                   INTEGER   0                               { 0:255 }                                                                                                                                      true                                     false                                                                                                 hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Sub class code"                                                        ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_subclass_code_hwtcl              NOVAL}\
{pf0_program_interface_hwtcl                      ture    true                false                   INTEGER   0                               { 0:255 }                                                                                                                                      true                                     false                                                                                                 hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Program Interface code"                                                ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_program_interface_hwtcl          NOVAL}\
{pf0_subsys_vendor_id_hwtcl                       false   true                false                   INTEGER   0                               { 0:65534 }                                                                                                                                    true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Subsystem Vendor ID"                                                   NOVAL                                                                            "Sets the read-only value of the Subsystem Vendor ID register."}\
{pf0_subsys_dev_id_hwtcl                          false   true                false                   INTEGER   0                               { 0:65534 }                                                                                                                                    true                                     true                                                                                                  hexadecimal   NOVAL         "Physical Function 0 IDs"                     "Subsystem Device ID"                                                   NOVAL                                                                            "Sets the read-only value of the Subsystem Device ID register."}\
\
{pll_refclk_freq_hwtcl                            false   true                false                   STRING    "100 MHz"                       {"100 MHz"}                                                                                                                                    true                                     false                                                                                                 NOVAL         NOVAL         "System Settings"                             "Reference clock frequency"                                             NOVAL                                                                            "Selects the reference clock frequency for the transceiver block. Both 100 Mhz and 125 MHz are supported."}\
{data_width_integer_hwtcl                         true    true                false                   INTEGER   256                             NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
{pld_clk_mhz_integer_hwtcl                        true    true                false                   INTEGER   125                             NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pld_clk_mhz_integer_hwtcl            NOVAL}\
\
{apps_type_hwtcl                                  false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         "Example Designs"                            "Set apps_type_hwtcl BFM driver value"                                   NOVAL                                                                            "When on, override the default testbench partner apps_type_hwtcl bfm " }\
{bfm_drive_interface_clk_hwtcl                    false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{bfm_drive_interface_npor_hwtcl                   false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{bfm_drive_interface_pipe_hwtcl                   false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{bfm_drive_interface_control_hwtcl                false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{serial_sim_hwtcl                                 false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{enable_pipe32_phyip_ser_driver_hwtcl             false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            NOVAL}\
{use_rpbfm_pro                                    false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            "Use CPU Based BFM"}\
{use_pll_lock_hwtcl                               false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            "Use CPU Based BFM"}\
{enable_test_out_hwtcl                            false   true                true                    INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            "Export Test Out Signals to top level"}\
{enable_pld_warm_rst_rdy_hwtcl                    false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                        NOVAL                                                                    NOVAL                                                                            "Export pld_warm_rst_rdy and link_req_rst_n interface to top level"}\
{enable_avst_deskew_hwtcl                         true    true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                                                                                 boolean       NOVAL         "Avalon-ST Settings"                          "Enable Deskew logic for Gen3x16"                       ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_enable_avst_deskew_hwtcl                         "Enables or disables Deskew Logic on Avalon-ST interface. When on, deskew circuit will be enabled for the Avalon-ST Interface "}\
\
}


  set rxm_specific_parameters {
    {NAME                        TYPE            DEFAULT_VALUE      AFFECTS_VALIDATION       system_info_type      system_info_arg                           VISIBLE                    }\
    {slave_address_map_0_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar0                                  false                      }\
    {slave_address_map_1_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar1                                  false                      }\
    {slave_address_map_2_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar2                                  false                      }\
    {slave_address_map_3_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar3                                  false                      }\
    {slave_address_map_4_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar4                                  false                      }\
    {slave_address_map_5_hwtcl         INTEGER         0                  true                     ADDRESS_WIDTH         rxm_bar5                                  false                      }\
   }



 set mapped_parameters {\
    {NAME                                     M_AUTOSET M_MAPS_FROM                                  M_MAP_VALUES                                                          }\
    {virtual_link_rate                        false     virtual_link_rate_hwtcl                      {"Gen1 (2.5 Gbps):gen1" "Gen2 (5.0 Gbps):gen2" "Gen3 (8.0 Gbps):gen3"}}\
    {virtual_link_rate_integer_hwtcl          false     virtual_link_rate                            {"gen1:1" "gen2:2" "gen3:3"}}\
    {virtual_link_width                       false     virtual_link_width_hwtcl                     {"x1:x1" "x2:x2" "x4:x4" "x8:x8" "x16:x16"}}\
    {virtual_link_width_integer_hwtcl         false     virtual_link_width                           {"x1:1" "x2:2" "x4:4" "x8:8" "x16:16" }}\
    {virtual_rp_ep_mode                       false     virtual_rp_ep_mode_hwtcl                     {"Native endpoint:ep" "Root port:rp"}}\
    {virtual_rp_ep_mode_integer_hwtcl         false     virtual_rp_ep_mode                           {"ep:0" "rp:1" }}\
    {wrala_integer_hwtcl                      false     wrala_hwtcl                                  { "0:Gen3x16, Interface - 256 bit, 500 MHz"  \
                                                                                                       "1:Gen3x8, Interface - 256 bit, 250 MHz"  \
                                                                                                       "2:Gen3x4, Interface - 256 bit, 125 MHz"  \
                                                                                                       "3:Gen3x2, Interface - 256 bit, 125 MHz"  \
                                                                                                       "4:Gen3x1, Interface - 256 bit, 125 MHz"   \
                                                                                                       "5:Gen2x16, Interface - 256 bit, 250 MHz"   \
                                                                                                       "6:Gen2x8, Interface - 256 bit, 125 MHz"  \
                                                                                                       "7:Gen2x4, Interface - 256 bit, 125 MHz"  \
                                                                                                       "8:Gen2x2, Interface - 256 bit, 125 MHz"  \
                                                                                                       "9:Gen2x1, Interface - 256 bit, 125 MHz"   \
                                                                                                       "10:Gen1x16, Interface - 256 bit, 125 MHz"  \
                                                                                                       "11:Gen1x8, Interface - 256 bit, 125 MHz"  \
                                                                                                       "12:Gen1x4, Interface - 256 bit, 125 MHz" \
                                                                                                       "13:Gen1x2, Interface - 256 bit, 125 MHz"  \
                                                                                                       "14:Gen1x1, Interface - 256 bit, 125 MHz"   } }\
\
    {pld_rx_np_bufflimit_bypass                false     rx_np_buffer_limit_bypass_hwtcl             {"0:false" "1:true"}}\
    {pld_rx_posted_bufflimit_bypass            false     rx_p_buffer_limit_bypass_hwtcl              {"0:false" "1:true"}}\
    {pld_rx_cpl_bufflimit_bypass               false     rx_cpl_buffer_limit_bypass_hwtcl            {"0:false" "1:true"}}\
\
    {pf0_pci_type0_bar0_enabled               false     pf0_bar0_type_hwtcl                                 {"Disabled:disable" "64-bit prefetchable memory:enable" "32-bit non-prefetchable memory:enable" }} \
    {pf0_pci_type0_bar1_enabled               false     pf0_bar1_type_hwtcl                                 {"Disabled:disable" "32-bit non-prefetchable memory:enable" }} \
    {pf0_pci_type0_bar2_enabled               false     pf0_bar2_type_hwtcl                                 {"Disabled:disable" "64-bit prefetchable memory:enable" "32-bit non-prefetchable memory:enable" }} \
    {pf0_pci_type0_bar3_enabled               false     pf0_bar3_type_hwtcl                                 {"Disabled:disable" "32-bit non-prefetchable memory:enable"}} \
    {pf0_pci_type0_bar4_enabled               false     pf0_bar4_type_hwtcl                                 {"Disabled:disable" "64-bit prefetchable memory:enable" "32-bit non-prefetchable memory:enable" }} \
    {pf0_pci_type0_bar5_enabled               false     pf0_bar5_type_hwtcl                                 {"Disabled:disable" "32-bit non-prefetchable memory:enable"}} \
\
    {pf0_bar0_type                            false     pf0_bar0_type_hwtcl                         {"Disabled:pf0_bar0_mem32" "64-bit prefetchable memory:pf0_bar0_mem64" "32-bit non-prefetchable memory:pf0_bar0_mem32" }}\
    {pf0_bar2_type                            false     pf0_bar2_type_hwtcl                         {"Disabled:pf0_bar2_mem32" "64-bit prefetchable memory:pf0_bar2_mem64" "32-bit non-prefetchable memory:pf0_bar2_mem32" }}\
    {pf0_bar4_type                            false     pf0_bar4_type_hwtcl                         {"Disabled:pf0_bar4_mem32" "64-bit prefetchable memory:pf0_bar4_mem64" "32-bit non-prefetchable memory:pf0_bar4_mem32" }}\
\
    {pf0_bar0_prefetch                        false     pf0_bar0_type_hwtcl                         {"Disabled:false" "64-bit prefetchable memory:true" "32-bit non-prefetchable memory:false" }}\
    {pf0_bar2_prefetch                        false     pf0_bar2_type_hwtcl                         {"Disabled:false" "64-bit prefetchable memory:true" "32-bit non-prefetchable memory:false" }}\
    {pf0_bar4_prefetch                        false     pf0_bar4_type_hwtcl                         {"Disabled:false" "64-bit prefetchable memory:true" "32-bit non-prefetchable memory:false" }}\
\
    {pf0_rom_bar_enabled                      false     pf0_rom_bar_enabled_hwtcl                   {"disable:disable" "enable:enable"}} \
\
\
    {pf0_bar0_type_integer_hwtcl               false     pf0_bar0_type_hwtcl                                {"Disabled:0" "64-bit prefetchable memory:1" "32-bit non-prefetchable memory:2" }} \
    {pf0_bar1_type_integer_hwtcl               false     pf0_bar1_type_hwtcl                                {"Disabled:0" "32-bit non-prefetchable memory:2" }} \
    {pf0_bar2_type_integer_hwtcl               false     pf0_bar2_type_hwtcl                                {"Disabled:0" "64-bit prefetchable memory:1" "32-bit non-prefetchable memory:2" }} \
    {pf0_bar3_type_integer_hwtcl               false     pf0_bar3_type_hwtcl                                {"Disabled:0" "32-bit non-prefetchable memory:2"}} \
    {pf0_bar4_type_integer_hwtcl               false     pf0_bar4_type_hwtcl                                {"Disabled:0" "64-bit prefetchable memory:1" "32-bit non-prefetchable memory:2" }} \
    {pf0_bar5_type_integer_hwtcl               false     pf0_bar5_type_hwtcl                                {"Disabled:0" "32-bit non-prefetchable memory:2"}} \    \
\
    {virtual_maxpayload_size                  false     virtual_maxpayload_size_hwtcl                {"128:max_payload_128" "256:max_payload_256" "512:max_payload_512" "1024:max_payload_1024" }}\
    {pf0_pcie_cap_ext_tag_supp                false     pf0_pcie_cap_ext_tag_supp_hwtcl              {"0:pf0_supported" "1:pf0_not_supported"}}\
\
    {pf0_pcie_cap_port_num                    false     pf0_pcie_cap_port_num_hwtcl                  NOVAL}\
    {pf0_pcie_cap_slot_clk_config             false     pf0_pcie_cap_slot_clk_config_hwtcl           {"1:true" "0:false"}}\
\
    {pf0_pci_msi_multiple_msg_cap             false     pf0_pci_msi_multiple_msg_cap_hwtcl           {"1:pf0_msi_vec_1" "2:pf0_msi_vec_2" "4:pf0_msi_vec_4" "8:pf0_msi_vec_8" "16:pf0_msi_vec_16" "32:pf0_msi_vec_32"}}\
\
    {virtual_pf0_msix_enable                  false     virtual_pf0_msix_enable_hwtcl                {"1:enable" "0:disable"}}\
    {pf0_pci_msix_table_size                  false     pf0_pci_msix_table_size_hwtcl                NOVAL}\
    {pf0_pci_msix_bir                         false     pf0_pci_msix_bir_hwtcl                       NOVAL}\
    {pf0_pci_msix_pba                         false     pf0_pci_msix_pba_hwtcl                       NOVAL}\
    {pf0_pci_msix_table_offset                false     pf0_pci_msix_table_offset_hwtcl              NOVAL}\
    {pf0_pci_msix_pba_offset                  false     pf0_pci_msix_pba_offset_hwtcl                NOVAL}\
\
    {pf0_pcie_slot_imp                        false     pf0_pcie_slot_imp_hwtcl                      {"1:pf0_implemented" "0:pf0_not_implemented"}}\
    {pf0_pcie_cap_slot_power_limit_value      false     pf0_pcie_cap_slot_power_limit_value_hwtcl    NOVAL}\
    {pf0_pcie_cap_slot_power_limit_scale      false     pf0_pcie_cap_slot_power_limit_scale_hwtcl    NOVAL}\
    {pf0_pcie_cap_phy_slot_num                false     pf0_pcie_cap_phy_slot_num_hwtcl              NOVAL}\
\
    {pf0_pcie_cap_ep_l0s_accpt_latency        false     pf0_pcie_cap_ep_l0s_accpt_latency_hwtcl      NOVAL}\
    {pf0_pcie_cap_ep_l1_accpt_latency         false     pf0_pcie_cap_ep_l1_accpt_latency_hwtcl       NOVAL}\
\
    {cvp_user_id                              false     cvp_user_id_hwtcl                            NOVAL}\
\
    {pf0_pci_type0_vendor_id                  false     pf0_pci_type0_vendor_id_hwtcl                NOVAL}\
    {pf0_pci_type0_device_id                  false     pf0_pci_type0_device_id_hwtcl                NOVAL}\
    {pf0_revision_id                          false     pf0_revision_id_hwtcl                        NOVAL}\
    {pf0_base_class_code                      false     pf0_base_class_code_hwtcl                    NOVAL}\
    {pf0_subclass_code                        false     pf0_subclass_code_hwtcl                      NOVAL}\
    {pf0_program_interface                    false     pf0_program_interface_hwtcl                  NOVAL}\
    {pf0_subsys_vendor_id                     false     pf0_subsys_vendor_id_hwtcl                   NOVAL}\
    {pf0_subsys_dev_id                        false     pf0_subsys_dev_id_hwtcl                      NOVAL}\
\
    {pf0_pcie_cap_sel_deemphasis              false     pf0_pcie_cap_sel_deemphasis_hwtcl            {"6dB:pf0_minus_6db" "3.5dB:pf0_minus_3db"}}\
\
    {interface_type_integer_hwtcl             false     interface_type_hwtcl                         {"Avalon-MM:1"}}\
\
    {tx_avst_dsk_en                           false     enable_avst_deskew_hwtcl                     {"0:disable" "1:enable" }}\
  }

  set parameter_overrides {\
    {NAME                                      DEFAULT_VALUE         M_AUTOSET}\
    {func_mode                                 "enable"              false}\
    {sup_mode                                  "user_mode"           false}\
    {virtual_pf0_msi_enable                    "enable"              false}\
    {pld_tx_parity_ena                         "enable"              false}\
    {pld_rx_parity_ena                         "enable"              false}\
\  }
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::declare_parameters { {device_family "Stratix 10"} } {
  variable display_items
  variable parameters
  variable rxm_specific_parameters
  variable mapped_parameters

  variable parameter_overrides

  ip_declare_parameters $parameters
  ip_declare_parameters $rxm_specific_parameters

  #Add common parameters
  ip_declare_parameters [::altera_pcie_s10_hip_common::parameters::get_parameters]

  # Add ND_HIP parameters
  ip_declare_parameters [::ct1_hip::parameters::get_parameters]
  # Add M_AUTOSET attribute to all NF_HIP parameters
  set ct1_hip_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE nd_hip]]
  foreach param $ct1_hip_parameters {
    ip_set "parameter.${param}.M_AUTOSET" 1
    ip_set "parameter.${param}.DISPLAY_ITEM" "PCI Express Attributes"
    ip_set "parameter.${param}.HDL_PARAMETER" true
    ip_set "parameter.${param}.VISIBLE" false
    if {[regexp {bar\d{1}_mask_31_1} $param]} {
      ip_set "parameter.${param}.HDL_PARAMETER" false
    } elseif {[regexp {bar\d{1}_mask_bit0} $param]} {
      ip_set "parameter.${param}.HDL_PARAMETER" false
    } elseif {[regexp {rom_mask} $param]} {
      ip_set "parameter.${param}.HDL_PARAMETER" false
    } elseif {[regexp {msix.*offset} $param]} {
      ip_set "parameter.${param}.HDL_PARAMETER" false
    }

    ip_set "parameter.${param}.M_AUTOWARN" 0
  }

  #over-constraining these parameters in order to resolve to 1 value
  foreach param {
        virtual_gen2_pma_pll_usage
  } {
        ip_set "parameter.${param}.M_AUTOSET" 1
        ip_set "parameter.${param}.VALIDATION_CALLBACK" "::ct1_hip::parameters::validate_${param}_override"
  }

  # Provide parameter mappings from IP parameters to PCI Express atom parameters
  ip_declare_parameters $mapped_parameters;
  ip_declare_parameters $parameter_overrides;

  # Add display items
  ip_declare_display_items $display_items

  # Initialize device information (to allow sharing of this function across device families)
  ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
  ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

  # Pass down base_device
  ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.base_device.SYSTEM_INFO_ARG"  BASE_DEVICE

  # Pass down part_trait_device
  ip_set "parameter.part_trait_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.part_trait_device.SYSTEM_INFO_ARG"  DEVICE

  # Pass down design_environment
  ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT
  # Pass down device
  ip_set "parameter.device.SYSTEM_INFO" DEVICE

  # Enable parameter mapping in the messaging package
  set_mapping_enabled 1
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate {} {
  variable validated

  #::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]
  ip_validate_parameters
  ip_validate_display_items
  # validate non rbc rules after validating all other parameters using rbc
  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_non_rbc_rules

  set validated 1
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::get_validated {} {
  variable validated

  return $validated
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_non_rbc_rules { } {

   # Do not set any HDL parameters here
   set interface_type_integer_hwtcl [ip_get "parameter.interface_type_integer_hwtcl.value"]
   set virtual_rp_ep_mode_hwtcl [ip_get "parameter.virtual_rp_ep_mode_hwtcl.value"]

   set pf0_bar_type_integer_hwtcl(0) [ip_get "parameter.pf0_bar0_type_integer_hwtcl.value"]
   set pf0_bar_type_integer_hwtcl(1) [ip_get "parameter.pf0_bar1_type_integer_hwtcl.value"]
   set pf0_bar_type_integer_hwtcl(2) [ip_get "parameter.pf0_bar2_type_integer_hwtcl.value"]
   set pf0_bar_type_integer_hwtcl(3) [ip_get "parameter.pf0_bar3_type_integer_hwtcl.value"]
   set pf0_bar_type_integer_hwtcl(4) [ip_get "parameter.pf0_bar4_type_integer_hwtcl.value"]
   set pf0_bar_type_integer_hwtcl(5) [ip_get "parameter.pf0_bar5_type_integer_hwtcl.value"]
   set pf0_expansion_base_address_register_hwtcl [ip_get "parameter.pf0_expansion_base_address_register_hwtcl.value"]



   set  pf0_bar_size_mask_hwtcl(0) [ip_get "parameter.pf0_bar0_address_width_hwtcl.value"]
   set  pf0_bar_size_mask_hwtcl(1) [ip_get "parameter.pf0_bar1_address_width_hwtcl.value"]
   set  pf0_bar_size_mask_hwtcl(2) [ip_get "parameter.pf0_bar2_address_width_hwtcl.value"]
   set  pf0_bar_size_mask_hwtcl(3) [ip_get "parameter.pf0_bar3_address_width_hwtcl.value"]
   set  pf0_bar_size_mask_hwtcl(4) [ip_get "parameter.pf0_bar4_address_width_hwtcl.value"]
   set  pf0_bar_size_mask_hwtcl(5) [ip_get "parameter.pf0_bar5_address_width_hwtcl.value"]

   set dma_enabled_hwtcl                 [ip_get "parameter.dma_enabled_hwtcl.value"]
   set dma_controller_enabled_hwtcl      [ip_get "parameter.dma_controller_enabled_hwtcl.value"]

   set DISABLE_BAR             0
   set PREFETACHBLE_64_BAR     1
   set NON_PREFETCHABLE_32_BAR 2
   set PREFETCHABLE_32_BAR     3


   if { [ regexp endpoint $virtual_rp_ep_mode_hwtcl ] } {
      if { [expr {! [expr {($pf0_bar_type_integer_hwtcl(0) || $pf0_bar_type_integer_hwtcl(1) || $pf0_bar_type_integer_hwtcl(2) || $pf0_bar_type_integer_hwtcl(3) || $pf0_bar_type_integer_hwtcl(4) || $pf0_bar_type_integer_hwtcl(5))}]}] } {
        ip_message error "An endpoint design must have at least one enabled <b>\"Base Address Register\"</b>."
      }
   } else {
      if { $pf0_expansion_base_address_register_hwtcl > 0 } {
        set legal_values 0
        auto_invalid_value_message auto pf0_expansion_base_address_register_hwtcl $pf0_expansion_base_address_register_hwtcl $legal_values { port_type_hwtcl }
      }
      #TODO check bar validations for rootport
   }

   for {set i 0} {$i < 6} {incr i 1} {
      if { $pf0_bar_type_integer_hwtcl($i)== $DISABLE_BAR } {
         if { ($dma_enabled_hwtcl == 1 ) && ( $dma_controller_enabled_hwtcl == 1 ) && ( $i==0 )} {
             ip_message error "BAR0 must be enabled when using DMA with Internal Descriptor Controller"
         }

         if { $pf0_bar_size_mask_hwtcl($i)!=0 } {
            ip_message error "The value of parameter <b>\"Size\"</b> of BAR$i must be set to <b>\"N/A\"</b> since BAR$i is <b>\"Disabled\"</b>."
         }
      } elseif { $pf0_bar_type_integer_hwtcl($i) == $PREFETACHBLE_64_BAR } {
         if { $pf0_bar_size_mask_hwtcl($i)<7 } {
            if { ($dma_enabled_hwtcl != 1 ) || ( $dma_controller_enabled_hwtcl != 1 ) || ( $i!=0 )} {
               ip_message error "The value of parameter <b>\"Size\"</b> of the 64-bit prefetchable BAR$i must be greater than or equal to 7 bits."
            }
         }
      } elseif { $pf0_bar_type_integer_hwtcl($i) == $NON_PREFETCHABLE_32_BAR } {
         if { $pf0_bar_size_mask_hwtcl($i)>31 } {
            if { ($dma_enabled_hwtcl != 1 ) || ( $dma_controller_enabled_hwtcl != 1 ) || ( $i!=0 )} {
               ip_message error "The value of parameter <b>\"Size\"</b> of the 32-bit non-prefetchable BAR$i must be less than or equal to 31 bits."
            }
         }
         if { $pf0_bar_size_mask_hwtcl($i)<7 } {
            if { ($dma_enabled_hwtcl != 1 ) || ( $dma_controller_enabled_hwtcl != 1 ) || ( $i!=0 )} {
               ip_message error "The value of parameter <b>\"Size\"</b> of the 32-bit non-prefetchable BAR$i must be greater than or equal to 7 bits."
            }
         }
      }
   }
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_rom_bar_enabled_hwtcl {PROP_NAME PROP_VALUE pf0_expansion_base_address_register_hwtcl} {
        if { $pf0_expansion_base_address_register_hwtcl ==0  }  {
                ip_set "parameter.pf0_rom_bar_enabled_hwtcl.value" "disable"
        } else {
                        ip_set "parameter.pf0_rom_bar_enabled_hwtcl.value" "enable"
        }

}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_wrala_hwtcl { PROP_NAME PROP_VALUE } {
       #ip_set "parameter.virtual_link_rate_hwtcl.value" $virtual_link_rate_hwtcl
       #ip_set "parameter.app_interface_width_hwtcl.value" $app_interface_width_hwtcl
       #ip_set "parameter.virtual_link_width_hwtcl.value" $virtual_link_width_hwtcl


       #"0:Gen3:x16, Interface: 256-bit, 500 MHz"
       #"1:Gen3:x8, Interface: 256 bit, 250 MHz"
       #"2:Gen3:x4, Interface: 256 bit, 125 MHz"
       #"3:Gen3:x2, Interface: 256 bit, 125 MHz"
       #"4:Gen3:x1, Interface: 256-bit, 125 MHz"
       #"5:Gen2:x16, Interface: 256-bit, 250 MHz"
       #"6:Gen2:x8, Interface: 256-bit, 125 MHz"
       #"7:Gen2:x4, Interface: 256 bit, 125 MHz"
       #"8:Gen2:x2, Interface: 256 bit, 125 MHz"
       #"9:Gen2:x1, Interface: 256-bit, 125 MHz"
       #"10:Gen1:x16, Interface: 256-bit, 125 MHz"
       #"11:Gen1:x8, Interface: 256-bit, 125 MHz"
       #"12:Gen1:x4, Interface: 256-bit, 125 MHz"
       #"13:Gen1:x2, Interface: 256-bit, 125 MHz"
       #"14:Gen1:x1, Interface: 256--bit, 125 MHz"

   set wrala_hwtcl    [ip_get "parameter.wrala_hwtcl.value" ]
   ip_set "parameter.app_interface_width_hwtcl.value" "256-bit"


   #    "Gen1 (2.5 Gbps)" "Gen2 (5.0 Gbps)" "Gen3 (8.0 Gbps)"
   if { [regexp "Gen3" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_rate_hwtcl.value" "Gen3 (8.0 Gbps)"
   } elseif { [regexp "Gen2" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_rate_hwtcl.value" "Gen2 (5.0 Gbps)"
   } else {
      ip_set "parameter.virtual_link_rate_hwtcl.value" "Gen1 (2.5 Gbps)"
   }

   #   "x1" "x2" "x4" "x8" "x16"
   if { [regexp "x16" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_width_hwtcl.value" "x16"
   } elseif { [regexp "x2" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_width_hwtcl.value" "x2"
   } elseif { [regexp "x4" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_width_hwtcl.value" "x4"
   } elseif { [regexp "x8" $wrala_hwtcl]} {
      ip_set "parameter.virtual_link_width_hwtcl.value" "x8"
   } else {
      ip_set "parameter.virtual_link_width_hwtcl.value" "x1"
   }

   set virtual_link_rate_hwtcl [ ip_get "parameter.virtual_link_rate_hwtcl.value"]
   set virtual_link_width_hwtcl [ ip_get "parameter.virtual_link_width_hwtcl.value"]
   set app_interface_width_hwtcl [ ip_get "parameter.app_interface_width_hwtcl.value"]
   send_message info "${virtual_link_rate_hwtcl} ${virtual_link_width_hwtcl} ${app_interface_width_hwtcl}"
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_base_device { PROP_NAME PROP_VALUE } {
   if { [string compare -nocase $PROP_VALUE "unknown"] == 0 } {
      send_message error "The current selected device \"$PROP_VALUE\" is invalid, please select a valid device to generate the IP."
   }
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pld_clk_mhz_integer_hwtcl { PROP_NAME PROP_VALUE  clkmod_pld_clk_out_sel   } {
        if { $clkmod_pld_clk_out_sel == "div4" } {
                ip_set "parameter.pld_clk_mhz_integer_hwtcl.value" "125"
        } elseif { $clkmod_pld_clk_out_sel == "div2" } {
                ip_set "parameter.pld_clk_mhz_integer_hwtcl.value" "250"
        } elseif { $clkmod_pld_clk_out_sel == "div1" } {
                ip_set "parameter.pld_clk_mhz_integer_hwtcl.value" "500"
        } else {
                ip_message error "clkmod_pld_clk_out_sel is selected incorrectly"
        }

}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_base_class_code_hwtcl { PROP_NAME PROP_VALUE  pf0_class_code_hwtcl   } {

   set pf0_base_class_code_hwtcl [expr [expr $pf0_class_code_hwtcl & 16711680]  >> 16 ]
   ip_set "parameter.${PROP_NAME}.value" $pf0_base_class_code_hwtcl
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_subclass_code_hwtcl { PROP_NAME PROP_VALUE  pf0_class_code_hwtcl   } {


   set pf0_subclass_code_hwtcl [expr [expr $pf0_class_code_hwtcl & 65280]  >> 8 ]
   ip_set "parameter.${PROP_NAME}.value" $pf0_subclass_code_hwtcl
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_program_interface_hwtcl { PROP_NAME PROP_VALUE  pf0_class_code_hwtcl   } {

   set pf0_program_interface_hwtcl [expr $pf0_class_code_hwtcl & 255 ]
   ip_set "parameter.${PROP_NAME}.value" $pf0_program_interface_hwtcl
}

#AVMM Parameter Validation
proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_include_dma_hwtcl { PROP_NAME PROP_VALUE   } {
    set legal_values [list 1 0]
    auto_invalid_value_message auto ${PROP_NAME}  ${PROP_VALUE} $legal_values {  }
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_avmm_addr_width_hwtcl { PROP_NAME PROP_VALUE    virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
      if { ($virtual_rp_ep_mode_hwtcl=="Root port") } {
        set legal_values [list 32 64]
      } elseif  { $dma_enabled_hwtcl==1} {
        set legal_values 64
      } else {
          set legal_values [list 32 64]
      }
      auto_invalid_value_message auto ${PROP_NAME}  ${PROP_VALUE} $legal_values  {dma_enabled_hwtcl }

}




proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar0_address_width_hwtcl { PROP_NAME PROP_VALUE dma_enabled_hwtcl dma_controller_enabled_hwtcl slave_address_map_0_hwtcl   } {
     if { ($dma_enabled_hwtcl == 1 ) && ( $dma_controller_enabled_hwtcl == 1 ) } {
         ip_set "parameter.${PROP_NAME}.value" 9
         } else {
         ip_set "parameter.${PROP_NAME}.value" $slave_address_map_0_hwtcl
                 }
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar1_address_width_hwtcl { PROP_NAME PROP_VALUE slave_address_map_1_hwtcl   } {
    ip_set "parameter.${PROP_NAME}.value" $slave_address_map_1_hwtcl
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar2_address_width_hwtcl { PROP_NAME PROP_VALUE slave_address_map_2_hwtcl   } {
    ip_set "parameter.${PROP_NAME}.value" $slave_address_map_2_hwtcl
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar3_address_width_hwtcl { PROP_NAME PROP_VALUE slave_address_map_3_hwtcl   } {
    ip_set "parameter.${PROP_NAME}.value" $slave_address_map_3_hwtcl
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar4_address_width_hwtcl { PROP_NAME PROP_VALUE slave_address_map_4_hwtcl   } {
    ip_set "parameter.${PROP_NAME}.value" $slave_address_map_4_hwtcl
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar5_address_width_hwtcl { PROP_NAME PROP_VALUE slave_address_map_5_hwtcl   } {
    ip_set "parameter.${PROP_NAME}.value" $slave_address_map_5_hwtcl
}





proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar0_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar1_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}
proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar2_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}
proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar3_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}
proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar4_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}
proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_pf0_bar5_enable_rxm_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_enable_rxm_bar2_burst_hwtcl { PROP_NAME PROP_VALUE  virtual_rp_ep_mode_hwtcl  interface_type_hwtcl dma_enabled_hwtcl } {
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_txs_enabled_hwtcl { PROP_NAME PROP_VALUE   avmm_addr_width_hwtcl } {
   if {$avmm_addr_width_hwtcl==32} {
      set legal_values 0
   } else {
      set legal_values [list 0 1]
   }
   auto_invalid_value_message auto  ${PROP_NAME}  ${PROP_VALUE} $legal_values { avmm_addr_width_hwtcl}

}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_hptxs_enabled_hwtcl { PROP_NAME PROP_VALUE   avmm_addr_width_hwtcl } {
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_cg_impl_cra_av_slave_port_hwtcl { PROP_NAME PROP_VALUE  avmm_addr_width_hwtcl} {

   if {$avmm_addr_width_hwtcl==32} {
      set legal_values 1
   } else {
      set legal_values [list 0 1]
   }
   auto_invalid_value_message auto  ${PROP_NAME}  ${PROP_VALUE} $legal_values { avmm_addr_width_hwtcl}
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_txs_addr_width { PROP_NAME PROP_VALUE avmm_addr_width_hwtcl user_txs_address_width_hwtcl} {

    ip_set "parameter.${PROP_NAME}.value" $user_txs_address_width_hwtcl
}


proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_hptxs_addr_width { PROP_NAME PROP_VALUE avmm_addr_width_hwtcl hptxs_address_translation_table_address_width_hwtcl hptxs_address_translation_window_address_width_hwtcl user_hptxs_address_width_hwtcl} {

  if {$avmm_addr_width_hwtcl == 32} {
    set temp $hptxs_address_translation_window_address_width_hwtcl
    switch $hptxs_address_translation_table_address_width_hwtcl {
       1     {}
       2     {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 1]}
       4     {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 2]}
       8     {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 3]}
       16    {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 4]}
       32    {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 5]}
       64    {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 6]}
       128   {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 7]}
       256   {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 8]}
       512   {set temp [expr $hptxs_address_translation_window_address_width_hwtcl + 9]}
       default { }
    }
    ip_set "parameter.${PROP_NAME}.value" $temp
  } else {
    ip_set "parameter.${PROP_NAME}.value" $user_hptxs_address_width_hwtcl
  }
}

proc ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_enable_avst_deskew_hwtcl   { PROP_NAME PROP_VALUE virtual_link_rate virtual_link_width } {
   if { ($virtual_link_rate == "gen3" ) && ( $virtual_link_width == "x16")} {
      ip_set "parameter.${PROP_NAME}.value" 1 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 0 ;
   }
}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm0_hwtcl { PROP_NAME PROP_VALUE pf0_bar0_enable_rxm_burst_hwtcl } {

   if { $pf0_bar0_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm0_hwtcl { PROP_NAME PROP_VALUE pf0_bar0_enable_rxm_burst_hwtcl } {

   if { $pf0_bar0_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm1_hwtcl { PROP_NAME PROP_VALUE pf0_bar1_enable_rxm_burst_hwtcl } {

   if { $pf0_bar1_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm1_hwtcl { PROP_NAME PROP_VALUE pf0_bar1_enable_rxm_burst_hwtcl } {

   if { $pf0_bar1_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm2_hwtcl { PROP_NAME PROP_VALUE pf0_bar2_enable_rxm_burst_hwtcl } {

   if { $pf0_bar2_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm2_hwtcl { PROP_NAME PROP_VALUE pf0_bar2_enable_rxm_burst_hwtcl } {

   if { $pf0_bar2_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm3_hwtcl { PROP_NAME PROP_VALUE pf0_bar3_enable_rxm_burst_hwtcl } {

   if { $pf0_bar3_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm3_hwtcl { PROP_NAME PROP_VALUE pf0_bar3_enable_rxm_burst_hwtcl } {

   if { $pf0_bar3_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm4_hwtcl { PROP_NAME PROP_VALUE pf0_bar4_enable_rxm_burst_hwtcl } {

   if { $pf0_bar4_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm4_hwtcl { PROP_NAME PROP_VALUE pf0_bar4_enable_rxm_burst_hwtcl } {

   if { $pf0_bar4_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_width_integer_rxm5_hwtcl { PROP_NAME PROP_VALUE pf0_bar5_enable_rxm_burst_hwtcl } {

   if { $pf0_bar5_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 256 ;
   }

}


proc  ::altera_pcie_s10_hip_avmm_bridge::parameters::validate_data_byte_width_integer_rxm5_hwtcl { PROP_NAME PROP_VALUE pf0_bar5_enable_rxm_burst_hwtcl } {

   if { $pf0_bar5_enable_rxm_burst_hwtcl ==0 } {
      ip_set "parameter.${PROP_NAME}.value" 4 ;
   } else {
      ip_set "parameter.${PROP_NAME}.value" 32 ;
   }

}

#Override paramters validation

proc ::ct1_hip::parameters::validate_virtual_gen2_pma_pll_usage_override { PROP_M_AUTOSET PROP_M_AUTOWARN virtual_gen2_pma_pll_usage func_mode virtual_hrdrstctrl_en virtual_link_rate } {

   set legal_values [list "not_applicable" "use_ffpll" "use_lcpll"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "use_lcpll"]]
   } else {
      if [expr { (($virtual_hrdrstctrl_en=="enable")&&(($virtual_link_rate=="gen1")||($virtual_link_rate=="gen2"))) }] {
         set legal_values [intersect $legal_values [list "use_ffpll"]]
      } else {
         set legal_values [intersect $legal_values [list "not_applicable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.virtual_gen2_pma_pll_usage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message virtual_gen2_pma_pll_usage $legal_values
      }
   } else {
      auto_invalid_value_message auto virtual_gen2_pma_pll_usage $virtual_gen2_pma_pll_usage $legal_values { func_mode virtual_hrdrstctrl_en virtual_link_rate }
   }
}







proc ::altera_pcie_s10_hip_avmm_bridge::parameters::setup_testbench {} {

   set use_rpbfm_pro [ip_get "parameter.use_rpbfm_pro.value"]
   if { $use_rpbfm_pro == 1 } {
      set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_rp_bfm
      send_message info "Using Testbench partner altera_pcie_rp_bfm"
      set serial_sim_hwtcl [ip_get "parameter.serial_sim_hwtcl.value"]
      set use_pll_lock_hwtcl [ip_get "parameter.use_pll_lock_hwtcl.value"]
      if { $serial_sim_hwtcl == 1 } {
         send_message error "Stratix 10:  Currently only Pipe simulation is supported"
      }
      set_module_assignment testbench.partner.pcie_tb.parameter.lane_mask_hwtcl  [ip_get "parameter.virtual_link_width_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.serial_sim_hwtcl  $serial_sim_hwtcl
      set_module_assignment testbench.partner.pcie_tb.parameter.use_pll_lock_hwtcl $use_pll_lock_hwtcl
      set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl  10
      set_module_assignment testbench.partner.pcie_tb.parameter.add_A10_HSSI_simlib_files  1
      set_module_assignment testbench.partner.map.refclk     pcie_tb.refclk
      set_module_assignment testbench.partner.map.npor       pcie_tb.npor
      set_module_assignment testbench.partner.map.hip_pipe   pcie_tb.hip_pipe
      set_module_assignment testbench.partner.map.hip_ctrl   pcie_tb.hip_ctrl
      if {$use_pll_lock_hwtcl ==1 } {
          set_module_assignment testbench.partner.map.xcvr_lock   pcie_tb.xcvr_lock
      }

      if { ${use_rpbfm_pro} == 1 } {
         # Use A10 G3:X8 BFM
         set_module_assignment testbench.partner.pcie_tb.parameter.hip_rp_bfm_hwtcl  0
      } else {
         # Use A10 G3:X16 BFM
         set_module_assignment testbench.partner.pcie_tb.parameter.hip_rp_bfm_hwtcl  1
      }

   } else {
      set interface_type_integer_hwtcl [ip_get "parameter.interface_type_integer_hwtcl.value"]
      set data_width_integer_hwtcl [ip_get "parameter.data_width_integer_hwtcl.value"]
      set dma_enabled_hwtcl [ip_get "parameter.dma_enabled_hwtcl.value"]

      set_module_assignment testbench.partner.pcie_tb.parameter.lane_mask_hwtcl                       [ip_get "parameter.virtual_link_width_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.pll_refclk_freq_hwtcl                 [ip_get "parameter.pll_refclk_freq_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.port_type_hwtcl                       [ip_get "parameter.virtual_rp_ep_mode_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.gen123_lane_rate_mode_hwtcl           [ip_get "parameter.virtual_link_rate_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.serial_sim_hwtcl                      [ip_get "parameter.serial_sim_hwtcl.value"]
 #     set_module_assignment testbench.partner.pcie_tb.parameter.enable_pipe32_phyip_ser_driver_hwtcl  [ip_get "parameter.enable_pipe32_phyip_ser_driver_hwtcl.value"]

      set_module_assignment testbench.partner.pcie_tb.parameter.bfm_drive_interface_clk_hwtcl      [ip_get "parameter.bfm_drive_interface_clk_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.bfm_drive_interface_npor_hwtcl     [ip_get "parameter.bfm_drive_interface_npor_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.bfm_drive_interface_pipe_hwtcl     [ip_get "parameter.bfm_drive_interface_pipe_hwtcl.value"]
      set_module_assignment testbench.partner.pcie_tb.parameter.bfm_drive_interface_control_hwtcl  [ip_get "parameter.bfm_drive_interface_control_hwtcl.value"]

      if  { [ip_get "parameter.bfm_drive_interface_clk_hwtcl.value"] == 1 } {
         set_module_assignment testbench.partner.map.refclk     pcie_tb.refclk
      }

      if { [ip_get "parameter.bfm_drive_interface_npor_hwtcl.value"] == 1 } {
         set_module_assignment testbench.partner.map.npor       pcie_tb.npor
      }

      if { [ip_get "parameter.bfm_drive_interface_pipe_hwtcl.value"] == 1 } {
         set_module_assignment testbench.partner.map.hip_pipe   pcie_tb.hip_pipe
      }

      if { [ip_get "parameter.bfm_drive_interface_control_hwtcl.value"] == 1 } {
         set_module_assignment testbench.partner.map.hip_ctrl   pcie_tb.hip_ctrl
      }

      if { [ip_get "parameter.apps_type_hwtcl.value" ] > 0 } {
         set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl [ip_get "parameter.apps_type_hwtcl.value"]
      } else {
        if { $dma_enabled_hwtcl == 1 } {
            set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 6
         } else {
            set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 3
             #"1:Link training and configuration"
             #"3:Link training and configuration and downstream_loop"
             #"6:AVMM PCIE DMA with Descriptor Controller"
        }
      }
   }

}
