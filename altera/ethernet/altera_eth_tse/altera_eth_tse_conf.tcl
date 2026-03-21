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


add_parameter deviceFamilyName STRING "Cyclone IV"
set_parameter_property deviceFamilyName SYSTEM_INFO DEVICE_FAMILY
set_parameter_property deviceFamilyName DISPLAY_NAME "Device Family"
set_parameter_property deviceFamilyName VISIBLE false
set_parameter_property deviceFamilyName IS_HDL_PARAMETER false

#CASE:59071 add_parameter deviceFeaturesSystemInfo STRING 
#CASE:59071 set_parameter_property deviceFeaturesSystemInfo SYSTEM_INFO DEVICE_FEATURES
#CASE:59071 set_parameter_property deviceFeaturesSystemInfo DISPLAY_NAME "Device Features"
#CASE:59071 set_parameter_property deviceFeaturesSystemInfo VISIBLE 0

###################################################################################
# Derived parameters
###################################################################################
# A helper function to add derived parameters
# Arguments:
# parameter name
# parameter type
# parameter default value
proc add_derived_param {args} {
   set param_name [lindex $args 0]
   set param_type [lindex $args 1]
   set param_dflt [lindex $args 2]

   add_parameter $param_name $param_type $param_dflt
   set_parameter_property $param_name DERIVED 1
   set_parameter_property $param_name VISIBLE 0

}

###################################################################################
# Helper function to disable parameters
# Arguments:
# parameter name
# TODO: Check for legal parameter value before we disable the parameter.
###################################################################################
proc set_disable {args} {
   set param_name [lindex $args 0]

   set_parameter_property $param_name ENABLED 0
}

###################################################################################
# Helper function to enable parameters
# Arguments:
# parameter name
###################################################################################
proc set_enable {args} {
   set param_name [lindex $args 0]

   set_parameter_property $param_name ENABLED 1
}

# Derived parameters to decide how MACLITE should be implemented
add_derived_param enable_padding BOOLEAN 0
add_derived_param enable_lgth_check BOOLEAN 0
add_derived_param gbit_only BOOLEAN 0
add_derived_param mbit_only BOOLEAN 0
add_derived_param reduced_control BOOLEAN 0

add_derived_param core_version INTEGER 0
add_derived_param dev_version INTEGER 0
add_derived_param eg_fifo INTEGER 0
add_derived_param ing_fifo INTEGER 0
add_derived_param reduced_interface_ena BOOLEAN 0
add_derived_param synchronizer_depth INTEGER 3

# Set these parameters value in validate callback
add_derived_param deviceFamily STRING "CYCLONEIV"
add_derived_param isUseMAC BOOLEAN 1
add_derived_param isUsePCS BOOLEAN 0
add_derived_param enable_clk_sharing BOOLEAN 0

# DEVICE_FEATURES
#~~~~~~~~~~~~~~~~
#   MLAB_MEMORY
#   M4K_MEMORY
#   M144K_MEMORY
#   M512_MEMORY
#   MRAM_MEMORY
#   M9K_MEMORY
#   ADDRESS_STALL
#   DSP
#   EMUL
#   DSP_SHIFTER_BLOCK
#   ESB
#   EPCS
#   LVDS_IO
#   HARDCOPY
#   TRANSCEIVER_6G_BLOCK
#   TRANSCEIVER_3G_BLOCK
proc is_device_feature_exist {feature_name} {
#CASE:59071    array set feature_array  [get_parameter_value deviceFeaturesSystemInfo]
#CASE:59071    foreach one_feature [array names feature_array] {
#CASE:59071        if { [ expr { "$one_feature" == "$feature_name" } ] } {
#CASE:59071            return $feature_array($one_feature)
#CASE:59071        }
#CASE:59071    }
#CASE:59071    return 0

   # These device feature information are taken from DeviceFamily.java from com.altera.sopcmodel
   # as a workaround for CASE:59071 where we can't get the DEVICE_FEATURE from SYSTEM_INFO in qmegawiz flow.
   set deviceFamily [get_parameter_value deviceFamily]

   switch $feature_name {
      LVDS_IO {
         if { [expr {"$deviceFamily" == "STRATIXIII"}] ||
            [expr {"$deviceFamily" == "STRATIXGX"}] ||
            [expr {"$deviceFamily" == "CYCLONEV"}] ||
            [expr {"$deviceFamily" == "CYCLONEIVE"}] ||
            [expr {"$deviceFamily" == "STINGRAY"}] ||
            [expr {"$deviceFamily" == "STRATIXIV"}] ||
            [expr {"$deviceFamily" == "STRATIXV"}] ||
            [expr {"$deviceFamily" == "ARRIAIIGX"}] ||
            [expr {"$deviceFamily" == "HARDCOPYIII"}] ||
            [expr {"$deviceFamily" == "HARDCOPYIV"}] ||
            [expr {"$deviceFamily" == "ARRIAIIGZ"}] ||
            [expr {"$deviceFamily" == "ARRIAV"}] ||
            [expr {"$deviceFamily" == "ARRIAVGZ"}] ||
            [expr {"$deviceFamily" == "ARRIA10"}]} {
            return 1
         } else {
            return 0
         }
      }
      TRANSCEIVER_6G_BLOCK {
         if { [expr {"$deviceFamily" == "STRATIXIIGX"}] ||
            [expr {"$deviceFamily" == "CYCLONEV"}] ||
            [expr {"$deviceFamily" == "STINGRAY"}] ||
            [expr {"$deviceFamily" == "STRATIXIIGXLITE"}] ||
            [expr {"$deviceFamily" == "STRATIXIV"}] ||
            [expr {"$deviceFamily" == "STRATIXV"}] ||
            [expr {"$deviceFamily" == "ARRIAIIGX"}] ||
            [expr {"$deviceFamily" == "HARDCOPYIV"}] ||
            [expr {"$deviceFamily" == "ARRIAIIGZ"}] ||
            [expr {"$deviceFamily" == "ARRIAV"}] ||
            [expr {"$deviceFamily" == "ARRIAVGZ"}] ||
            [expr {"$deviceFamily" == "ARRIA10"}] } {
            return 1
         } else {
            return 0
         }
      }
      default {
         # We should not enter this line of code
         send_message ERROR "Internal Error: Unknown device feature: $feature_name"
         return 0
      }
   }
}

###################################################################################
# a helper function to decide if we are using phyip for the PMA
###################################################################################
proc is_use_phyip {} {
   set deviceFamily [get_parameter_value deviceFamily]
   set transceiver_type [get_parameter_value transceiver_type]

   if { [expr {"$transceiver_type" == "GXB"}] &&
        [expr {"$deviceFamily" != "STRATIXIIGX"}] && 
        [expr {"$deviceFamily" != "STRATIXIV"}] &&
        [expr {"$deviceFamily" != "STRATIXIIGXLITE"}] &&
        [expr {"$deviceFamily" != "ARRIAIIGX"}] &&
        [expr {"$deviceFamily" != "ARRIAIIGZ"}] &&
        [expr {"$deviceFamily" != "STINGRAY"}] &&
        [expr {"$deviceFamily" != "HARDCOPYIV"}] && 
        [expr {"$deviceFamily" != "ARRIA10"}] } {
      return 1
   } else {
      return 0
   }
}

###################################################################################
# a helper function to decide if we are using NightFury device family 
# phyip for the PMA
###################################################################################
proc is_use_nf_phyip {} {
   set deviceFamily [get_parameter_value deviceFamily]
   set transceiver_type [get_parameter_value transceiver_type]

   if { [expr {"$transceiver_type" == "GXB"}] &&
        [expr {"$deviceFamily" == "ARRIA10"}] } {
      return 1
   } else {
      return 0
   }
}

###################################################################################
# Core configuration parameters
###################################################################################
add_parameter core_variation STRING MAC_ONLY
set_parameter_property core_variation DISPLAY_NAME "Core variation"
set_parameter_property core_variation DESCRIPTION \
"Determines the primary blocks to include in the variation."
set_parameter_property core_variation ALLOWED_RANGES {
   "MAC_ONLY:10/100/1000Mb Ethernet MAC" 
   "MAC_PCS:10/100/1000Mb Ethernet MAC with 1000BASE-X/SGMII PCS"
   "PCS_ONLY:1000BASE-X/SGMII PCS only"
   "SMALL_MAC_GIGE:1000Mb Small MAC" 
   "SMALL_MAC_10_100:10/100Mb Small MAC"
}
set_parameter_update_callback core_variation update_core_variation

add_parameter ifGMII STRING MII_GMII
set_parameter_property ifGMII DISPLAY_NAME "Interface"
set_parameter_property ifGMII DESCRIPTION \
"<html>
Determines the Ethernet-side interface of the MAC block.
<ul>
<li><b>MII</b> - The only option available for 10/100 Mbps Small MAC core variations.
<li><b>GMII</b> - Available only for 1000 Mbps Small MAC core variations.
<li><b>RGMII</b> - Available for 10/100/1000 Mbps Ethernet MAC and 1000 Mbps Small MAC core variations. RGMII is not supported for Arria 10 devices.
<li><b>MII/GMII</b> - Available only for 10/100/1000 Mbps Ethernet MAC core variations.<br>
If this is selected, media independent interface (MII) is used for the 10/100 interface,<br>
and gigabit media independent interface (GMII) for the gigabit interface.
</ul>
</html>"

set_parameter_property ifGMII ALLOWED_RANGES {
   "MII_GMII:MII/GMII"
   "RGMII:RGMII" 
   "MII:MII"
   "GMII:GMII"
}

add_parameter use_mac_clken BOOLEAN 0
set_parameter_property use_mac_clken DISPLAY_NAME "Use clock enable for MAC"
set_parameter_property use_mac_clken DESCRIPTION \
"If this parameter is turned on, clock enable signals are used for MACs.
This option is only applicable for 10/100/1000 Mbps Ethernet MAC and 
10/100 Mbps Ethernet MAC core variations"

add_parameter enable_use_internal_fifo BOOLEAN 1
set_parameter_property enable_use_internal_fifo DISPLAY_NAME "Use internal FIFO"
set_parameter_property enable_use_internal_fifo DESCRIPTION \
"If this parameter is turned on, internal FIFO buffers are
included in the core. You can only include internal FIFO
buffers in single-port MAC."

set_parameter_update_callback enable_use_internal_fifo update_core_variation

add_parameter enable_ecc BOOLEAN 0
set_parameter_property enable_ecc DISPLAY_NAME "Enable ECC protection"
set_parameter_property enable_ecc DESCRIPTION \
"If this parameter is turned on, ECC protection is enabled for internal memory blocks."

add_parameter max_channels INTEGER 1
set_parameter_property max_channels DISPLAY_NAME "Number of ports"
set_parameter_property max_channels DESCRIPTION \
"Specifies the number of Ethernet ports supported by the
IP core. This parameter is enabled if the parameter <b>Use
internal FIFO</b> is turned off. A multiport MAC does not
support internal FIFO buffers."
set_parameter_property max_channels ALLOWED_RANGES { 1 4 8 12 16 20 24 }

add_parameter use_misc_ports BOOLEAN 1
set_parameter_property use_misc_ports DISPLAY_NAME "Use misc ports"
# Hiding this parameter from customer, always expose it so that it is 
# compatible to existing qmegawiz flow
# Timing Adapter is always not inserted for MAC with FIFO to keep
# backward compatiblity with qmegawiz flow
set_parameter_property use_misc_ports VISIBLE false

add_parameter transceiver_type STRING "NONE"
set_parameter_property transceiver_type DISPLAY_NAME "Transceiver type"
set_parameter_property transceiver_type DESCRIPTION \
"<html>
This option is only available for variations that include
the PCS block.
<ul>
<li>When turned off, the PCS block does not include an integrated transceiver module.<br>
The PCS block implements a ten-bit interface (TBI) to an external SERDES chip.
<li>When turned on, the MegaCore function includes an integrated transceiver module<br>
to implement a 1.25 Gbps transceiver.<br>
Respective GXB module is included for target devices with GX transceivers.<br>
For target devices with LVDS I/O including Soft-CDR such as Stratix III,<br>
the ALTLVDS module is included.
</ul>
</html>"
set_parameter_property transceiver_type DISPLAY_HINT "combo"
set_parameter_property transceiver_type ALLOWED_RANGES {
   "NONE:None"
   "GXB:GXB"
   "LVDS_IO:LVDS I/O"
}

###################################################################################
# MAC options parameters
###################################################################################
add_parameter enable_hd_logic BOOLEAN 1
set_parameter_property enable_hd_logic DISPLAY_NAME "Enable MAC 10/100 half duplex support"
set_parameter_property enable_hd_logic DESCRIPTION \
"Turn on this option to include support for half duplex
operation on 10/100 Mbps connections."

add_parameter enable_gmii_loopback BOOLEAN 0
set_parameter_property enable_gmii_loopback DISPLAY_NAME "Enable local loopback on MII/GMII/RGMII*"
set_parameter_property enable_gmii_loopback DESCRIPTION \
"Turn on this option to enable local loopback on the
MAC's MII, GMII, or RGMII* interface. If you turn on this
option, the loopback function can be dynamically
enabled or disabled during system operation via the
MAC configuration register.<br>
*RGMII is not supported for Arria 10 devices."

add_parameter enable_sup_addr BOOLEAN 0
set_parameter_property enable_sup_addr DISPLAY_NAME "Enable supplemental MAC unicast addresses"
set_parameter_property enable_sup_addr DESCRIPTION \
"Turn on this option to include support for supplementary
destination MAC unicast addresses for fast hardware-based
received frame filtering."

add_parameter stat_cnt_ena BOOLEAN 1
set_parameter_property stat_cnt_ena DISPLAY_NAME "Include statistics counters"
set_parameter_property stat_cnt_ena  DESCRIPTION \
"<html>
Turn on this option to include support for simple
network monitoring protocol (SNMP) management
information base (MIB) and remote monitoring (RMON)
statistics counter registers for incoming and outgoing
Ethernet packets.
<p> By default, the width of all statistics counters are 32 bits.
</html>"

add_parameter ext_stat_cnt_ena BOOLEAN 0
set_parameter_property ext_stat_cnt_ena DISPLAY_NAME "Enable 64-bit statistics byte counters"
set_parameter_property ext_stat_cnt_ena DESCRIPTION \
"<html>
The option <b> Enable 64-bit statistics byte counters </b> allows
you to extend the width of selected statistics counters - <br>
<i>aOctetsTransmittedOK,</i><br>
<i>aOctetsReceivedOK,</i> and <br>
<i>etherStatsOctets</i> - to 64 bits.
</html>"

add_parameter ena_hash BOOLEAN 0
set_parameter_property ena_hash DISPLAY_NAME "Include multicast hashtable"
set_parameter_property ena_hash  DESCRIPTION \
"Turn on this option to implement a hash table, a fast
hardware-based mechanism to detect and filter
multicast destination MAC address in received Ethernet
packets."

add_parameter enable_shift16 BOOLEAN 1
set_parameter_property enable_shift16 DISPLAY_NAME "Align packet headers to 32-bit boundary"
set_parameter_property enable_shift16 DESCRIPTION \
"<html>
Turn on this option to include logic that aligns all packet
headers to 32-bit boundaries. This helps reduce
software overhead processing in realignment of data
buffers.<br> 
This option is only available for MAC variations with 32
bits wide internal FIFO buffers.<br> 
You must turn on this option if you intend to use the
Triple-Speed Ethernet MegaCore function with the
Interniche TCP/IP protocol stack.
</html>"

add_parameter enable_mac_flow_ctrl BOOLEAN 0
set_parameter_property enable_mac_flow_ctrl DISPLAY_NAME "Enable full-duplex flow control"
set_parameter_property enable_mac_flow_ctrl  DESCRIPTION \
"Turn on this option to include the logic for full-duplex
flow control that includes pause frames generation and
termination."

add_parameter enable_mac_vlan BOOLEAN 0
set_parameter_property enable_mac_vlan DISPLAY_NAME "Enable VLAN detection"
set_parameter_property enable_mac_vlan DESCRIPTION \
"Turn on this option to include the logic for VLAN and
stacked VLAN frame detection. When turned off, the
MAC does not detect VLAN and staked VLAN frames.
The MAC forwards these frames to the user application
without processing them."

add_parameter enable_magic_detect BOOLEAN 1
set_parameter_property enable_magic_detect DISPLAY_NAME "Enable magic packet detection"
set_parameter_property enable_magic_detect DESCRIPTION \
"Turn on this option to include logic for magic packet
detection (Wake-on LAN)."

add_parameter useMDIO BOOLEAN 0
set_parameter_property useMDIO DISPLAY_NAME "Include MDIO module (MDC/MDIO)"
set_parameter_property useMDIO DESCRIPTION \
"Turn on this option if you want to access external PHY
devices connected to the MAC function. When turned
off, the core does not include the logic or signals
associated with the MDIO interface."

add_parameter mdio_clk_div INTEGER 40
set_parameter_property mdio_clk_div ALLOWED_RANGES {2:256}
set_parameter_property mdio_clk_div DISPLAY_NAME "Host clock divisor"
set_parameter_property mdio_clk_div  DESCRIPTION \
"<html>
Clock divisor to divide the MAC control interface clock to
produce the MDC clock output on the MDIO interface.<br>
For example, if the MAC control interface clock
frequency is 100 MHz and the desired MDC clock
frequency is 2.5 MHz, a host clock divisor of 40 should
be specified. <br>
Intel recommends that the division factor is defined
such that the MDC frequency does not exceed 2.5 MHz.
</html>"

###################################################################################
# FIFO options parameters
###################################################################################
add_parameter enable_ena INTEGER 32
set_parameter_property enable_ena DISPLAY_NAME "Width"
set_parameter_property enable_ena DESCRIPTION \
"Determines the data width in bits of the transmit and
receive FIFO buffers."
set_parameter_property enable_ena DISPLAY_HINT "radio"
set_parameter_property enable_ena ALLOWED_RANGES {"32:32 Bits"
   "8:8 Bits"
}
set_parameter_update_callback enable_ena update_core_variation

add_parameter eg_addr INTEGER 11
set_parameter_property eg_addr DISPLAY_NAME "Transmit"
set_parameter_property eg_addr DESCRIPTION \
"Determines the depth of the internal FIFO buffers."
set legal_range ""
for {set i 6} {$i <= 16} {incr i} {
    set temp [expr int ([expr pow(2,$i)])]
    lappend legal_range "$i:$temp x 32 bits"
}
set_parameter_property eg_addr ALLOWED_RANGES $legal_range

add_parameter ing_addr INTEGER 11
set_parameter_property ing_addr DISPLAY_NAME "Receive"
set_parameter_property ing_addr DESCRIPTION \
"Determines the depth of the internal FIFO buffers."
set legal_range ""
for {set i 6} {$i <= 16} {incr i} {
    set temp [expr int ([expr pow(2,$i)])]
    lappend legal_range "$i:$temp x 32 bits"
}
set_parameter_property ing_addr ALLOWED_RANGES $legal_range

###################################################################################
# PCS options parameters
###################################################################################
add_parameter phy_identifier INTEGER 0
set_parameter_property phy_identifier DISPLAY_NAME "PHY ID (32 bit)"
set_parameter_property phy_identifier DESCRIPTION \
"Configures the PHY ID of the PCS block."
set_parameter_property phy_identifier DISPLAY_HINT "hexadecimal" 

add_parameter enable_sgmii BOOLEAN 0
set_parameter_property enable_sgmii DISPLAY_NAME "Enable SGMII bridge"
set_parameter_property enable_sgmii DESCRIPTION \
"<html>
Turn on this option to add the SGMII clock and
rate-adaptation logic to the PCS block. If your
application only requires 1000BASE-X PCS, turning off
this option reduces resource usage.<br>
In Cyclone IV GX devices, <i> REFCLK\[0,1\]</i> and
<i> REFCLK\[4,5\]</i>  cannot connect directly to the GCLK
network. If you enable the SGMII bridge, you must
connect <i> ref_clk </i> to an alternative dedicated clock
input pin.
</html>"

add_parameter export_pwrdn BOOLEAN 0
set_parameter_property export_pwrdn DISPLAY_NAME "Export transceiver powerdown signal"
set_parameter_property export_pwrdn DESCRIPTION \
"<html>
This option is not supported in Stratix V, Arria V,
Cyclone V and Arria 10 devices.<br>
Turn on this option to export the powerdown signal of
the GX transceiver to the top-level of your design.
Powerdown is shared among the transceivers in a quad.
Therefore, turning on this option in multiport Ethernet
configurations maximizes efficient use of transceivers
within the quad.<br>
Turn off this option to connect the powerdown signal
internally to the PCS control register interface. This
connection allows the host processor to control the
transceiver powerdown in your system.<br>
For UNH-IOL certification purposes, you must set the
embedded transceiver to use 7-bit word alignment
pattern length to recognize the comma character found
in /K28.1/, /K28.5/, and /K28.7/. Use the MegaWizard
Plug-in Manager to edit the megafunction and change
the default word alignment setting to 7 bits.
</html>" 


add_parameter enable_alt_reconfig BOOLEAN 0
set_parameter_property enable_alt_reconfig DISPLAY_NAME "Enable transceiver dynamic reconfiguration"
set_parameter_property enable_alt_reconfig DESCRIPTION \
"<html>
This option is always turned on in devices other than
Arria GX and Stratix II GX. When this option is turned
on, the MegaCore function includes the dynamic
reconfiguration signals.<br>
For designs targeting devices other than Stratix V and
Arria V, Intel recommends that you instantiate the
ALTGX_RECONFIG megafunction and connect the
megafunction to the dynamic reconfiguration signals to
enable offset cancellation.<br>
For Stratix V and Arria V designs, Intel recommends
that you instantiate the Transceiver Reconfiguration
Controller megafunction and connect the megafunction
to the dynamic reconfiguration signals to enable offset
cancellation. The transceivers in the Stratix V and
Arria V designs are configured with Intel Custom PHY
IP core. The Custom PHY IP core require two
reconfiguration interfaces for external reconfiguration
controller. For more information on the reconfiguration
interfaces required, refer to the <i> Intel Transceiver PHY
IP Core User Guide </i> and the respective device handbook.<br>
For more information about quad sharing
considerations, refer to \"Sharing PLLs in Devices with
GIGE PHY\".
</html>"

add_parameter starting_channel_number INTEGER 0
set_parameter_property starting_channel_number DISPLAY_NAME "Starting channel number"
set_parameter_property starting_channel_number DESCRIPTION \
"<html>
Specifies the channel number for the GXB transceiver
block. In a multiport MAC, this parameter specifies the
channel number for the first port. Subsequent channel
numbers are in four increments.<br>
In designs with multiple instances of GXB transceiver
block (multiple instances of Triple-Speed Ethernet IP
core with GXB transceiver block or a combination of
Triple-Speed Ethernet IP core and other IP cores), Intel
recommends that you set a unique starting channel
number for each instance to eliminate conflicts when the
GXB transceiver blocks share a transceiver quad.<br>   
This option is not supported in Stratix V devices. For
Stratix V devices, the channel numbers depends on the
dynamic reconfiguration controller.
</html>"

set_parameter_property starting_channel_number DISPLAY_HINT "COMBO"
set legal_range ""
for {set i 0} {$i < 288} {incr i 4} {
   lappend legal_range "$i"
}
set_parameter_property starting_channel_number ALLOWED_RANGES $legal_range

add_parameter phyip_pll_type STRING "CMU"
set_parameter_property phyip_pll_type DISPLAY_NAME "TX PLLs type"
set_parameter_property phyip_pll_type DESCRIPTION \
"<html>
This option is only available for variations that include
the PCS block for Stratix V and Arria V GZ device families.<br>
Specifies types of TX phase-locked loops (CMU/ATX) in the GXB transceiver for Series V device families.
</html>"
set_parameter_property phyip_pll_type ALLOWED_RANGES {
   "CMU:CMU"
   "ATX:ATX"
}

add_parameter phyip_pll_base_data_rate STRING "1250 Mbps"
set_parameter_property phyip_pll_base_data_rate DISPLAY_NAME "TX PLL Base Data Rate"
set_parameter_property phyip_pll_base_data_rate DESCRIPTION \
"<html>
Specifies TX PLL base data rate in the GXB transceiver for Series V device families.
</html>"
set_parameter_property phyip_pll_base_data_rate ALLOWED_RANGES {
   "1250 Mbps"
}

add_parameter phyip_en_synce_support BOOLEAN 0
set_parameter_property phyip_en_synce_support DISPLAY_NAME "Enable SyncE Support"
set_parameter_property phyip_en_synce_support DESCRIPTION \
"<html>
Enabling SyncE support by seperating TX PLL and RX PLL reference clock
</html>"

add_parameter phyip_pma_bonding_mode STRING "x1"
set_parameter_property phyip_pma_bonding_mode DISPLAY_NAME "TX PLL clock network"
set_parameter_property phyip_pma_bonding_mode DESCRIPTION \
"<html>
This option is only available for variations that include
the PCS block for Arria V and Cyclone V device families.<br>
Specifies types of TX PLL clock network. By selecting xN, TX PLL is allowed to be place within or out of six-pack.
</html>"
set_parameter_property phyip_pma_bonding_mode ALLOWED_RANGES {
   "x1:x1"
   "xN:xN"
}

add_parameter nf_phyip_rcfg_enable BOOLEAN 0
set_parameter_property nf_phyip_rcfg_enable DISPLAY_NAME "Enable Arria 10 transceiver dynamic reconfiguration"
set_parameter_property nf_phyip_rcfg_enable DESCRIPTION \
"<html>
Enable Arria 10 transceiver dynamic reconfiguration
</html>"


add_parameter XCVR_RCFG_JTAG_ENABLE INTEGER 0
set_parameter_property XCVR_RCFG_JTAG_ENABLE DISPLAY_NAME "Enable Intel FPGA Debug Master Endpoint"
set_parameter_property XCVR_RCFG_JTAG_ENABLE DESCRIPTION "When enabled, the Native PHY includes an embedded Intel FPGA Debug Master Endpoint that connects internally Avalon-MM slave interface. The ADME can access the reconfiguration space of the transceiver. It can perform certain test and debug functions via JTAG using the System Console."
set_parameter_property XCVR_RCFG_JTAG_ENABLE DISPLAY_HINT "boolean"
set_parameter_property XCVR_RCFG_JTAG_ENABLE HDL_PARAMETER false
set_parameter_property XCVR_RCFG_JTAG_ENABLE VISIBLE true

add_parameter XCVR_SET_CAPABILITY_REG_ENABLE INTEGER 0
set_parameter_property XCVR_SET_CAPABILITY_REG_ENABLE DISPLAY_NAME "Enable capability registers"
set_parameter_property XCVR_SET_CAPABILITY_REG_ENABLE DESCRIPTION "Enables capability registers, which provide high level information about the transceiver channel's configuration."
set_parameter_property XCVR_SET_CAPABILITY_REG_ENABLE DISPLAY_HINT "boolean"
set_parameter_property XCVR_SET_CAPABILITY_REG_ENABLE HDL_PARAMETER false
set_parameter_property XCVR_SET_CAPABILITY_REG_ENABLE VISIBLE true

add_parameter XCVR_SET_USER_IDENTIFIER INTEGER 0
set_parameter_property XCVR_SET_USER_IDENTIFIER DISPLAY_NAME "Set user-defined IP identifier"
set_parameter_property XCVR_SET_USER_IDENTIFIER DESCRIPTION "Sets a user-defined numeric identifier that can be read from the user_identifer offset when the capability registers are enabled."
set_parameter_property XCVR_SET_USER_IDENTIFIER ALLOWED_RANGES {0:255}
set_parameter_property XCVR_SET_USER_IDENTIFIER HDL_PARAMETER false
set_parameter_property XCVR_SET_USER_IDENTIFIER VISIBLE true

add_parameter XCVR_SET_CSR_SOFT_LOGIC_ENABLE INTEGER 0
set_parameter_property XCVR_SET_CSR_SOFT_LOGIC_ENABLE DISPLAY_NAME "Enable control and status registers"
set_parameter_property XCVR_SET_CSR_SOFT_LOGIC_ENABLE DESCRIPTION "Enables soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Signals include rx_is_locktoref, rx_is_locktodata, tx_cal_busy, rx_cal_busy, rx_serial_loopback, set_rx_locktodata, set_rx_locktoref, tx_analogreset, tx_digitalreset, rx_analogreset and rx_digitalreset. For more information, please refer to the User Guide."
set_parameter_property XCVR_SET_CSR_SOFT_LOGIC_ENABLE DISPLAY_HINT "boolean"
set_parameter_property XCVR_SET_CSR_SOFT_LOGIC_ENABLE HDL_PARAMETER false
set_parameter_property XCVR_SET_CSR_SOFT_LOGIC_ENABLE VISIBLE true

add_parameter XCVR_SET_PRBS_SOFT_LOGIC_ENABLE INTEGER 0
set_parameter_property XCVR_SET_PRBS_SOFT_LOGIC_ENABLE DISPLAY_NAME "Enable PRBS soft accumulators"
set_parameter_property XCVR_SET_PRBS_SOFT_LOGIC_ENABLE DESCRIPTION "Enables soft logic for doing PRBS bit and error accumulation when using the hard PRBS generator and checker."
set_parameter_property XCVR_SET_PRBS_SOFT_LOGIC_ENABLE DISPLAY_HINT "boolean"
set_parameter_property XCVR_SET_PRBS_SOFT_LOGIC_ENABLE HDL_PARAMETER false
set_parameter_property XCVR_SET_PRBS_SOFT_LOGIC_ENABLE VISIBLE true


add_parameter nf_lvds_iopll_num_channels INTEGER 4
set_parameter_property nf_lvds_iopll_num_channels DISPLAY_NAME "IO PLL sharing among LVDS channels"
set_parameter_property nf_lvds_iopll_num_channels DESCRIPTION \
"<html>
IO PLL sharing among LVDS channels. <br>
This option is only applicable for 10/100/1000Mb Ethernet MAC with 1000BASE-X/SGMII PCS core variation and without internal FIFO.
</html>"
set_parameter_property nf_lvds_iopll_num_channels ALLOWED_RANGES {
   1
   4
   8
   10
   12
}
set_parameter_property nf_lvds_iopll_num_channels DERIVED 1
set_parameter_property nf_lvds_iopll_num_channels VISIBLE 0

###################################################################################
# Timestamp options parameters
###################################################################################
add_parameter enable_timestamping BOOLEAN 0
set_parameter_property enable_timestamping DISPLAY_NAME "Enable timestamping"
set_parameter_property enable_timestamping DESCRIPTION \
"Turn on this parameter to enable time stamping on the transmitted and received
frames."

add_parameter enable_ptp_1step BOOLEAN 0
set_parameter_property enable_ptp_1step DISPLAY_NAME "Enable PTP 1-step clock"
set_parameter_property enable_ptp_1step DESCRIPTION \
"<html>
Turn on this parameter to insert time stamp on PTP messages for 1-step clock based
on the TX Egress Timestamp Insert Control interface.<br>
This parameter is disabled if you do not turn on <b>Enable Time Stamping</b>.
</html>"

add_parameter tstamp_fp_width INTEGER 4
set_parameter_property tstamp_fp_width DISPLAY_NAME "Timestamp fingerprint width"
set_parameter_property tstamp_fp_width DESCRIPTION \
"Use this parameter to set the width in bits for the time stamp fingerprint on the TX
path. The default value is 4 bits."

###################################################################################
# GUI pages
###################################################################################
set CORE_PAGE        "Core Configurations"
set CORE_GRP_0       "Core Variations"
set CORE_GRP_1       "10/100/1000Mb Ethernet MAC"
set CORE_GRP_2       "1000BASE-X/SGMII PCS"

set MAC_PAGE         "MAC Options"
set MAC_GRP_0        "Ethernet MAC Options"
set MAC_GRP_1        "MDIO Module"

set FIFO_PAGE        "FIFO Options"
set FIFO_GRP_0       "Width"
set FIFO_GRP_1       "Depth"

set TIMESTAMP_PAGE   "Timestamp Options"
set TIMESTAMP_GRP_0  "Timestamp"

set PCS_PAGE         "PCS/Transceiver Options"
set PCS_GRP_0        "PCS Options"
set PCS_GRP_1        "Transceiver Options"
set PCS_GRP_2        "Series V GXB Transceiver Options"
set PCS_GRP_3        "Arria 10 GXB Transceiver Options"

# Core Configurations page
add_display_item ""           "$CORE_PAGE"   GROUP tab
add_display_item "$CORE_PAGE" "$CORE_GRP_0"  GROUP
add_display_item "$CORE_PAGE" "$CORE_GRP_1"  GROUP
add_display_item "$CORE_PAGE" "$CORE_GRP_2"  GROUP

add_display_item "$CORE_GRP_0"   core_variation             parameter
add_display_item "$CORE_GRP_0"   enable_ecc                 parameter
add_display_item "$CORE_GRP_1"   ifGMII                     parameter
add_display_item "$CORE_GRP_1"   use_mac_clken              parameter
add_display_item "$CORE_GRP_1"   enable_use_internal_fifo   parameter
add_display_item "$CORE_GRP_1"   max_channels               parameter
add_display_item "$CORE_GRP_1"   use_misc_ports             parameter
add_display_item "$CORE_GRP_2"   transceiver_type           parameter
# MAC Options page
add_display_item ""           "$MAC_PAGE"   GROUP tab
add_display_item "$MAC_PAGE"  "$MAC_GRP_0"  GROUP
add_display_item "$MAC_PAGE"  "$MAC_GRP_1"  GROUP

add_display_item "$MAC_GRP_0"    enable_hd_logic            parameter
add_display_item "$MAC_GRP_0"    enable_gmii_loopback       parameter
add_display_item "$MAC_GRP_0"    enable_sup_addr            parameter
add_display_item "$MAC_GRP_0"    stat_cnt_ena               parameter
add_display_item "$MAC_GRP_0"    ext_stat_cnt_ena           parameter
add_display_item "$MAC_GRP_0"    ena_hash                   parameter
add_display_item "$MAC_GRP_0"    enable_shift16             parameter
add_display_item "$MAC_GRP_0"    enable_mac_flow_ctrl       parameter
add_display_item "$MAC_GRP_0"    enable_mac_vlan            parameter
add_display_item "$MAC_GRP_0"    enable_magic_detect        parameter

add_display_item "$MAC_GRP_1"    useMDIO                   parameter
add_display_item "$MAC_GRP_1"    mdio_clk_div               parameter

# FIFO Options page
add_display_item ""           "$FIFO_PAGE"   GROUP tab
add_display_item "$FIFO_PAGE" "$FIFO_GRP_0"  GROUP
add_display_item "$FIFO_PAGE" "$FIFO_GRP_1"  GROUP

add_display_item "$FIFO_GRP_0"   enable_ena                 parameter

add_display_item "$FIFO_GRP_1"   eg_addr                    parameter
add_display_item "$FIFO_GRP_1"   ing_addr                   parameter

# Timestamp Options page
add_display_item ""           "$TIMESTAMP_PAGE"   GROUP tab
add_display_item "$TIMESTAMP_PAGE"  "$TIMESTAMP_GRP_0"  GROUP

add_display_item "$TIMESTAMP_GRP_0"  enable_timestamping    parameter
add_display_item "$TIMESTAMP_GRP_0"  enable_ptp_1step       parameter
add_display_item "$TIMESTAMP_GRP_0"  tstamp_fp_width        parameter

# PCS/Tranceiver Options page
add_display_item ""           "$PCS_PAGE"   GROUP tab
add_display_item "$PCS_PAGE"  "$PCS_GRP_0"  GROUP
add_display_item "$PCS_PAGE"  "$PCS_GRP_1"  GROUP
add_display_item "$PCS_PAGE"  "$PCS_GRP_2"  GROUP
add_display_item "$PCS_PAGE"  "$PCS_GRP_3"  GROUP

add_display_item "$PCS_GRP_0"  phy_identifier               parameter
add_display_item "$PCS_GRP_0"  enable_sgmii                 parameter

add_display_item "$PCS_GRP_1"  export_pwrdn                 parameter
add_display_item "$PCS_GRP_1"  enable_alt_reconfig          parameter
add_display_item "$PCS_GRP_1"  starting_channel_number      parameter
add_display_item "$PCS_GRP_2"  phyip_pll_type               parameter
add_display_item "$PCS_GRP_2"  phyip_pll_base_data_rate     parameter
add_display_item "$PCS_GRP_2"  phyip_en_synce_support       parameter
add_display_item "$PCS_GRP_2"  phyip_pma_bonding_mode       parameter
add_display_item "$PCS_GRP_3"  nf_phyip_rcfg_enable         parameter
add_display_item "$PCS_GRP_3"  nf_lvds_iopll_num_channels   parameter
##edmond add
add_display_item "$PCS_GRP_3"  XCVR_RCFG_JTAG_ENABLE                  parameter
add_display_item "$PCS_GRP_3"  XCVR_SET_CAPABILITY_REG_ENABLE         parameter
add_display_item "$PCS_GRP_3"  XCVR_SET_USER_IDENTIFIER               parameter
add_display_item "$PCS_GRP_3"  XCVR_SET_CSR_SOFT_LOGIC_ENABLE         parameter
add_display_item "$PCS_GRP_3"  XCVR_SET_PRBS_SOFT_LOGIC_ENABLE        parameter
   
###################################################################################
# Callback for parameter update
# We are using this callback to set certain core parameters as parameter change
###################################################################################
proc update_core_variation {arg} {
   set core_variation [get_parameter_value core_variation]
   set enable_use_internal_fifo [get_parameter_value enable_use_internal_fifo]
   set enable_ena [get_parameter_value enable_ena]
   set ifGMII [get_parameter_value ifGMII]

   # Local parameters
   set rangeMiiGmii "MII_GMII:MII/GMII"
   set rangeMii "MII:MII"
   set rangeGmii "GMII:GMII"
   set rangeRgmii "RGMII:RGMII"

   # Update the ifGMII range based on core_variation parameter
   switch $core_variation {
      SMALL_MAC_10_100 {
         # Small MAC 10/100 only has MII
         set_parameter_value ifGMII "MII"

         # The following MAC options are used with small MAC
         set_parameter_value enable_gmii_loopback 0
         set_parameter_value enable_sup_addr 0
         set_parameter_value stat_cnt_ena 0
         set_parameter_value ext_stat_cnt_ena 0
         set_parameter_value ena_hash 0
         set_parameter_value enable_mac_flow_ctrl 0
         set_parameter_value enable_mac_vlan 0
         set_parameter_value enable_magic_detect 0

         # Small MAC is only applicable with internal fifo
         set_parameter_value enable_use_internal_fifo 1

         # Fifo width must be 32-bits
         set_parameter_value enable_ena 32

         # Force the transceiver_type parameter that we disabled to NONE. This is to make sure that
         # when we switch device, the parameter value is always correct.
         set_parameter_value transceiver_type "NONE"

      }
      SMALL_MAC_GIGE {
         # Small MAC 1000 can have either GMII or RGMII
         if { [expr {$ifGMII != "GMII"}] && [expr {$ifGMII != "RGMII"}] } {
            set_parameter_value ifGMII "GMII"
         }
         
         # Small MAC GIGE don't use clken
         set_parameter_value use_mac_clken 0

         # The following MAC options are used with small MAC
         set_parameter_value enable_gmii_loopback 0
         set_parameter_value enable_sup_addr 0
         set_parameter_value stat_cnt_ena 0
         set_parameter_value ext_stat_cnt_ena 0
         set_parameter_value ena_hash 0
         set_parameter_value enable_mac_flow_ctrl 0
         set_parameter_value enable_mac_vlan 0
         set_parameter_value enable_magic_detect 0
         set_parameter_value enable_hd_logic 0

         # Small MAC is only applicable with internal fifo
         set_parameter_value enable_use_internal_fifo 1

         # Fifo width must be 32-bits
         set_parameter_value enable_ena 32

         # Force the transceiver_type parameter that we disabled to NONE. This is to make sure that
         # when we switch device, the parameter value is always correct.
         set_parameter_value transceiver_type "NONE"

      }
      MAC_ONLY {
         # MAC can have either MII/GMII or MII/RGMII
         if { [expr {$ifGMII != "MII_GMII"}] && [expr {$ifGMII != "RGMII"}] } {
            set_parameter_value ifGMII "MII_GMII"
         }
         
         # Enable shift 16 is not applicable for FIFO 8 bit interface
         if {$enable_use_internal_fifo} {
            if {[expr $enable_ena == 8]} {
               set_parameter_value enable_shift16 0
            }
         }

         # Force the transceiver_type parameter that we disabled to NONE. This is to make sure that
         # when we switch device, the parameter value is always correct.
         set_parameter_value transceiver_type "NONE"

      }
      PCS_ONLY {
         # PCS only don't use MAC clken
         set_parameter_value use_mac_clken 0

         # PCS can have MII/GMII Only
         if { [expr {$ifGMII != "MII_GMII"}] } {
            set_parameter_value ifGMII "MII_GMII"
         }
      }
      MAC_PCS {
         # MAC_PCS always internally enable MAC clken
         # This GUI option is ignored.
         set_parameter_value use_mac_clken 0

         # MAC+PCS can have MII/GMII Only
         if { [expr {$ifGMII != "MII_GMII"}] } {
            set_parameter_value ifGMII "MII_GMII"
         }
         
         # Enable shift 16 is not applicable for FIFO 8 bit interface
         if {$enable_use_internal_fifo} {
            if {[expr $enable_ena == 8]} {
               set_parameter_value enable_shift16 0
            }
         }

         set_parameter_value enable_hd_logic 0
      }
   }
}

###################################################################################
# Called during validate callback to get the deviceFamily derived parameter value
# based on deviceFamilyName
###################################################################################
proc get_device_family {} {
   set deviceFamilyName [get_parameter_value deviceFamilyName]

   switch $deviceFamilyName {
      "MAX 10" {
         set_parameter_value deviceFamily MAX10
      }
      "Arria 10" {
         set_parameter_value deviceFamily ARRIA10
      }
      "Stratix V" {
         set_parameter_value deviceFamily STRATIXV
      }
      "Stratix IV" {
         set_parameter_value deviceFamily STRATIXIV
      }
      "Stratix III" {
         set_parameter_value deviceFamily STRATIXIII
      }
      "Stratix II GX" {
         set_parameter_value deviceFamily STRATIXIIGX
      }
      "Stratix II" {
         set_parameter_value deviceFamily STRATIXII
      }
      "HardCopy IV" {
         set_parameter_value deviceFamily HARDCOPYIV
      }
      "HardCopy III" {
         set_parameter_value deviceFamily HARDCOPYIII
      }
      "HardCopy II" {
         set_parameter_value deviceFamily HARDCOPYII
      }
      "Arria GX" {
         set_parameter_value deviceFamily STRATIXIIGXLITE
      }
      "Arria II GX" {
         set_parameter_value deviceFamily ARRIAIIGX
      }
      "Arria II GZ" {
         set_parameter_value deviceFamily ARRIAIIGZ
      }
      "Arria V" {
         set_parameter_value deviceFamily ARRIAV
      }
      "Arria V GZ" {
         set_parameter_value deviceFamily ARRIAVGZ
      }
      "Cyclone V" {
         set_parameter_value deviceFamily CYCLONEV
      }
      "Cyclone IV E" {
         set_parameter_value deviceFamily CYCLONEIVE
      }
      "Cyclone IV GX" {
         set_parameter_value deviceFamily STINGRAY
      }
      "Cyclone 10 LP" {
         set_parameter_value deviceFamily CYCLONE10LP
      }
      "Cyclone III LS" {
         set_parameter_value deviceFamily TARPON
      }
      "Cyclone III" {
         set_parameter_value deviceFamily CYCLONEIII
      }
      "Cyclone II" {
         set_parameter_value deviceFamily CYCLONEII
      }
   }
}

###################################################################################
# Called during validate callback to calculate the core_version 
# and dev_version value
###################################################################################
proc validate_version {} {

   set version_val [get_module_property VERSION]
   set version_items [split $version_val "."]
   set version_num [lindex $version_items 0]
   set version_dot_num [lindex $version_items 1]

   set version_number [expr [expr $version_num << 8] | $version_dot_num]
   
   set_parameter core_version $version_number
   set_parameter dev_version $version_number
}

###################################################################################
# Called to update the TX PLL base data rate parameter range
###################################################################################
proc update_phyip_pll_base_data_rate_range {} {
   set deviceFamily [get_parameter_value deviceFamily]
   set transceiver_type [get_parameter_value transceiver_type]
   set core_variation [get_parameter_value core_variation]
   set phyip_pll_type [get_parameter_value phyip_pll_type]

   if {[expr {"$transceiver_type" == "GXB"}] &&
       [expr {"$core_variation" == "MAC_PCS"} || \
       {"$core_variation" == "PCS_ONLY"}]} {

      if {[expr {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAVGZ"}]} {
         if {[expr {"$phyip_pll_type" == "CMU"}]} {
            set_parameter_property phyip_pll_base_data_rate ALLOWED_RANGES {
               "1250 Mbps" "2500 Mbps" "5000 Mbps" "10000 Mbps"
            }
         } else {
            set_parameter_property phyip_pll_base_data_rate ALLOWED_RANGES {
               "2500 Mbps" "5000 Mbps" "10000 Mbps"
            }
         }
      } elseif {[expr {"$deviceFamily" == "ARRIAV"}]} {
         # Arria V device supports CMU PLL options only
         set_parameter_property phyip_pll_base_data_rate ALLOWED_RANGES {
            "1250 Mbps" "2500 Mbps" "5000 Mbps" "10000 Mbps"
         }
      } elseif {[expr {"$deviceFamily" == "CYCLONEV"}]} {
         set_parameter_property phyip_pll_base_data_rate ALLOWED_RANGES {
            "1250 Mbps" "2500 Mbps" "5000 Mbps"
         }
      }
   }
}

###################################################################################
# A common callback to validate core parameters, calculate derived parameters
# and even disable certain GUI options.
###################################################################################
proc validate_parameters {} {
   set ing_addr [get_parameter_value ing_addr]
   set eg_addr [get_parameter_value eg_addr]
   set ifGMII [get_parameter_value ifGMII]
   set stat_cnt_ena [get_parameter_value stat_cnt_ena]
   set deviceFamily [get_parameter_value deviceFamily]
   set core_variation [get_parameter_value core_variation]
   set useMDIO [get_parameter_value useMDIO]
   set enable_use_internal_fifo [get_parameter_value enable_use_internal_fifo]
   set max_channels [get_parameter_value max_channels]
   set enable_shift16 [get_parameter_value enable_shift16]
   set enable_sgmii [get_parameter_value enable_sgmii]
   set transceiver_type [get_parameter_value transceiver_type]
   set enable_timestamping [get_parameter_value enable_timestamping]
   set phyip_pll_base_data_rate [get_parameter_value phyip_pll_base_data_rate]
   set phyip_pll_type [get_parameter_value phyip_pll_type]
   set enable_ecc [get_parameter_value enable_ecc]
   set nf_phyip_rcfg_enable [get_parameter_value nf_phyip_rcfg_enable]
   # Local parameters (only use these parameters for the range setting, 
   # not for parameter value comparison)
   set rangeMiiGmii "MII_GMII:MII/GMII"
   set rangeMii "MII:MII"
   set rangeGmii "GMII:GMII"
   set rangeRgmii "RGMII:RGMII"

   # Update ing_fifo and eg_fifo value
   set_parameter_value ing_fifo [expr pow(2,$ing_addr)]
   set_parameter_value eg_fifo [expr pow(2,$eg_addr)]

   # Update the FIFO width in combo box for ing_addr and eg_addr parameter
   set legal_range ""
   set enable_ena [get_parameter_value enable_ena]
   for {set i 6} {$i <= 16} {incr i} {
      set temp [expr int ([expr pow(2,$i)])]
      lappend legal_range "$i:$temp x $enable_ena bits"
   }
   set_parameter_property eg_addr ALLOWED_RANGES $legal_range
   set_parameter_property ing_addr ALLOWED_RANGES $legal_range

   # Update the core_variation parameter range
   # as MAX 10 device family is not supporing PCS_ONLY and MAC_PCS core variations
   if {[expr {"$deviceFamily" == "MAX10"}]} {
      set_parameter_property core_variation ALLOWED_RANGES {
         "MAC_ONLY:10/100/1000Mb Ethernet MAC" 
         "SMALL_MAC_GIGE:1000Mb Small MAC" 
         "SMALL_MAC_10_100:10/100Mb Small MAC"
      }
   } else {
      set_parameter_property core_variation ALLOWED_RANGES {
         "MAC_ONLY:10/100/1000Mb Ethernet MAC" 
         "MAC_PCS:10/100/1000Mb Ethernet MAC with 1000BASE-X/SGMII PCS"
         "PCS_ONLY:1000BASE-X/SGMII PCS only"
         "SMALL_MAC_GIGE:1000Mb Small MAC" 
         "SMALL_MAC_10_100:10/100Mb Small MAC"
      }
   }

   # Update the transceiver_type parameter range
   set transceiver_type_range "NONE:None"
   if {[is_device_feature_exist LVDS_IO] || 
      [is_device_feature_exist TRANSCEIVER_6G_BLOCK] } {

      if {[is_device_feature_exist LVDS_IO] && 
      [ expr {"$deviceFamily" != "STINGRAY"} && {"$deviceFamily" != "CYCLONEIVE"} && {"$deviceFamily" != "CYCLONEV"} && {"$deviceFamily" != "CYCLONE10LP"}]} {
         lappend transceiver_type_range "LVDS_IO:LVDS I/O"
      }
      
      if {[is_device_feature_exist TRANSCEIVER_6G_BLOCK]} {
         lappend transceiver_type_range "GXB:GXB"
      }
   }

   set_parameter_property transceiver_type ALLOWED_RANGES $transceiver_type_range


   # Enable all the parameters that we might disable later
   set_enable use_mac_clken
   set_enable max_channels
   set_enable enable_use_internal_fifo
   set_enable use_misc_ports

   set_enable enable_gmii_loopback
   set_enable enable_sup_addr
   set_enable stat_cnt_ena
   set_enable ena_hash
   set_enable enable_mac_flow_ctrl
   set_enable enable_mac_vlan
   set_enable enable_magic_detect
   set_enable enable_hd_logic
   set_enable enable_shift16

   set_enable enable_ena
   set_enable eg_addr
   set_enable ing_addr
   
   set_enable useMDIO
   set_enable mdio_clk_div

   set_enable transceiver_type
   set_enable phy_identifier
   set_enable enable_sgmii
   set_enable export_pwrdn
   set_enable enable_alt_reconfig
   set_enable starting_channel_number
   
   #Disable all timestamp option and only enabled it for the certain variant
   set_enable enable_timestamping
   set_enable enable_ptp_1step
   set_enable tstamp_fp_width
   set_enable phyip_pll_type
   set_enable phyip_pll_base_data_rate
   set_enable phyip_en_synce_support
   set_enable phyip_pma_bonding_mode
   set_enable nf_phyip_rcfg_enable
   set_disable XCVR_RCFG_JTAG_ENABLE
   set_disable XCVR_SET_CAPABILITY_REG_ENABLE
   set_disable XCVR_SET_USER_IDENTIFIER
   set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
   set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
   set_enable nf_lvds_iopll_num_channels

   # Based on core_variation value
   # Update the following derived parameter value
   # Update certain GUI options
   switch $core_variation {
      MAC_ONLY {
         set_parameter enable_padding 1
         set_parameter enable_lgth_check 1
         set_parameter gbit_only 1
         set_parameter mbit_only 1
         set_parameter reduced_control 0

         set_parameter isUseMAC 1
         set_parameter isUsePCS 0

	# MAC can have either MII/GMII or MII/RGMII
         if [expr {"$deviceFamily" == "ARRIA10"}] {
            # Hide RGMII support for Arria 10
            set_parameter_property ifGMII ALLOWED_RANGES "$rangeMiiGmii"
         } else {
            set_parameter_property ifGMII ALLOWED_RANGES "$rangeMiiGmii $rangeRgmii"
         }

         # MAC can have either MII/GMII or MII/RGMII
         #set_parameter_property ifGMII ALLOWED_RANGES "$rangeMiiGmii $rangeRgmii"

         # Multichannel only supported if we are selecting fifoless variant
         if {$enable_use_internal_fifo} {
            set_disable max_channels
         }
         
         # Enable shift 16 is not applicable for FIFO 8 bit interface
         if {$enable_use_internal_fifo} {
            if {[expr $enable_ena == 8]} {
               set_disable enable_shift16
            }
         }

         # Disable all PCS options
         set_disable transceiver_type
         set_disable phy_identifier
         set_disable enable_sgmii
         set_disable export_pwrdn
         set_disable enable_alt_reconfig
         set_disable starting_channel_number
         set_disable phyip_pll_type
         set_disable phyip_pll_base_data_rate
         set_disable phyip_en_synce_support
         set_disable phyip_pma_bonding_mode
         set_disable nf_phyip_rcfg_enable
         set_disable XCVR_RCFG_JTAG_ENABLE
         set_disable XCVR_SET_CAPABILITY_REG_ENABLE
         set_disable XCVR_SET_USER_IDENTIFIER
         set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
         set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
         set_disable nf_lvds_iopll_num_channels
          
         # Set enable_clk_sharing to 0
         set_parameter_value enable_clk_sharing 0
         
         #Enable timestamp option
         if {[expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "MAX10"} || {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}  || {"$deviceFamily" == "CYCLONEV"}]} {
            set_enable enable_timestamping
         } else {
            set_disable enable_timestamping
         }
          
         if {$enable_timestamping && 
            [expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "MAX10"} || {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}  || {"$deviceFamily" == "CYCLONEV"}]} {		 
            set_enable enable_ptp_1step
            set_enable tstamp_fp_width
         } else {
            set_disable enable_ptp_1step
            set_disable tstamp_fp_width
         }         
         
      }
      SMALL_MAC_10_100 {
         set_parameter enable_padding 0
         set_parameter enable_lgth_check 0
         set_parameter gbit_only 0
         set_parameter mbit_only 1
         set_parameter reduced_control 1

         set_parameter isUseMAC 1
         set_parameter isUsePCS 0

         # Small MAC 10/100 only has MII
         set_parameter_property ifGMII ALLOWED_RANGES "$rangeMii"

         # Small MAC options don't support multi channel
         # and only applicable in mac with fifo variant
         set_disable max_channels
         set_disable enable_use_internal_fifo

         # FIFO width must be 32 bits
         set_disable enable_ena

         set_disable enable_gmii_loopback
         set_disable enable_sup_addr
         set_disable stat_cnt_ena
         set_disable ena_hash
         set_disable enable_mac_flow_ctrl
         set_disable enable_mac_vlan
         set_disable enable_magic_detect

         # Disable all PCS options
         set_disable transceiver_type
         set_disable phy_identifier
         set_disable enable_sgmii
         set_disable export_pwrdn
         set_disable enable_alt_reconfig
         set_disable starting_channel_number
         set_disable phyip_pll_type
         set_disable phyip_pll_base_data_rate
         set_disable phyip_en_synce_support
         set_disable phyip_pma_bonding_mode
         set_disable nf_phyip_rcfg_enable
         set_disable XCVR_RCFG_JTAG_ENABLE
         set_disable XCVR_SET_CAPABILITY_REG_ENABLE
         set_disable XCVR_SET_USER_IDENTIFIER
         set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
         set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
         set_disable nf_lvds_iopll_num_channels

         #Disable all timestamp option
         set_disable enable_timestamping
         set_disable enable_ptp_1step
         set_disable tstamp_fp_width
          
         # Set enable_clk_sharing to 0
         set_parameter_value enable_clk_sharing 0
          
      }
      SMALL_MAC_GIGE {
         set_parameter enable_padding 0
         set_parameter enable_lgth_check 0
         set_parameter gbit_only 1
         set_parameter mbit_only 0
         set_parameter reduced_control 1

         set_parameter isUseMAC 1
         set_parameter isUsePCS 0

         # Small MAC 1000 can have either GMII or RGMII
         if [expr {"$deviceFamily" == "ARRIA10"}] {
            # Hide RGMII support for Arria 10
            set_parameter_property ifGMII ALLOWED_RANGES "$rangeGmii"
         } else {
            set_parameter_property ifGMII ALLOWED_RANGES "$rangeGmii $rangeRgmii"
         }

         # Small MAC 1000 can have either GMII or RGMII
         #set_parameter_property ifGMII ALLOWED_RANGES "$rangeGmii $rangeRgmii"

         # Small MAC GIGE don't use clken
         set_disable use_mac_clken

         # Small MAC options don't support multi channel
         # and only applicable in mac with fifo variant
         set_disable max_channels
         set_disable enable_use_internal_fifo

         # FIFO width must be 32 bits
         set_disable enable_ena

         set_disable enable_hd_logic
         set_disable enable_gmii_loopback
         set_disable enable_sup_addr
         set_disable stat_cnt_ena
         set_disable ena_hash
         set_disable enable_mac_flow_ctrl
         set_disable enable_mac_vlan
         set_disable enable_magic_detect

         # Disable all PCS options
         set_disable transceiver_type
         set_disable phy_identifier
         set_disable enable_sgmii
         set_disable export_pwrdn
         set_disable enable_alt_reconfig
         set_disable starting_channel_number
         set_disable phyip_pll_type
         set_disable phyip_pll_base_data_rate
         set_disable phyip_en_synce_support
         set_disable phyip_pma_bonding_mode
         set_disable nf_phyip_rcfg_enable
         set_disable XCVR_RCFG_JTAG_ENABLE
         set_disable XCVR_SET_CAPABILITY_REG_ENABLE
         set_disable XCVR_SET_USER_IDENTIFIER
         set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
         set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
         set_disable nf_lvds_iopll_num_channels
          
         #Disable all timestamp option
         set_disable enable_timestamping
         set_disable enable_ptp_1step
         set_disable tstamp_fp_width

         # Set enable_clk_sharing to 0
         set_parameter_value enable_clk_sharing 0
      }
      PCS_ONLY {
         set_parameter isUseMAC 0
         set_parameter isUsePCS 1
         
         # Update the ifGMII to MII/GMII only
         set_parameter_property ifGMII ALLOWED_RANGES "$rangeMiiGmii"

         # PCS only don't use MAC clken
         set_disable use_mac_clken

         # Disable all MAC Only options
         set_disable enable_use_internal_fifo
         set_disable max_channels
         set_disable use_misc_ports

         set_disable enable_ena
         set_disable ing_addr
         set_disable eg_addr

         set_disable ext_stat_cnt_ena
         set_disable enable_shift16
         set_disable enable_hd_logic
         set_disable enable_gmii_loopback
         set_disable enable_sup_addr
         set_disable stat_cnt_ena
         set_disable ena_hash
         set_disable enable_mac_flow_ctrl
         set_disable enable_mac_vlan
         set_disable enable_magic_detect

         set_disable useMDIO
         set_disable mdio_clk_div
          
         #Disable all timestamp option
         set_disable enable_timestamping
         set_disable enable_ptp_1step
         set_disable tstamp_fp_width

         # Set enable_clk_sharing to 0
         set_parameter_value enable_clk_sharing 0

         # Enable pll_type to CMU and ATX for device families of Arria V GZ and Stratix V with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAVGZ"}]} { 
            set_enable phyip_pll_type
         } else {
            set_disable phyip_pll_type
         }

         # Enable syncE support for Stratix V, Arria V GZ, Arria V and Cyclone V with transceiver type is GXB
         # Enable TX PLL base data rate setting for Stratix V, Arria V GZ, Arria V and Cyclone V with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "STRATIXV"} || \
               {"$deviceFamily" == "ARRIAVGZ"} || \
               {"$deviceFamily" == "ARRIAV"} || \
               {"$deviceFamily" == "CYCLONEV"}]} { 
            set_enable phyip_en_synce_support
            set_enable phyip_pll_base_data_rate
         } else {
            set_disable phyip_en_synce_support
            set_disable phyip_pll_base_data_rate
         }

         # Enable TX PLL clock network selection Arria V and Cyclone V with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIAV"} || \
               {"$deviceFamily" == "CYCLONEV"}]} { 
            set_enable phyip_pma_bonding_mode
         } else {
            set_disable phyip_pma_bonding_mode
         }

         # Enable dynamic reconfiguration for Arria 10 with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIA10"}]} { 
            set_enable nf_phyip_rcfg_enable
         } else {
            set_disable nf_phyip_rcfg_enable        
         }
          
   	if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIA10"}]} { 
            
            if {$nf_phyip_rcfg_enable} {
               set_enable XCVR_RCFG_JTAG_ENABLE
               set_enable XCVR_SET_CAPABILITY_REG_ENABLE
               set_enable XCVR_SET_USER_IDENTIFIER
               set_enable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
               set_enable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
		}
         } else {
           
               set_disable XCVR_RCFG_JTAG_ENABLE
               set_disable XCVR_SET_CAPABILITY_REG_ENABLE
               set_disable XCVR_SET_USER_IDENTIFIER
               set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
               set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE             
         }

         set_disable nf_lvds_iopll_num_channels
      }
      MAC_PCS {
         set_parameter isUseMAC 1
         set_parameter isUsePCS 1

         set_parameter enable_padding 1
         set_parameter enable_lgth_check 1
         set_parameter gbit_only 1
         set_parameter mbit_only 1
         set_parameter reduced_control 0

         # MAC_PCS only option will always internally enable MAC clken
         # Thus, user GUI option are not used
         set_disable use_mac_clken

         # Multichannel only supported if we are selecting fifoless variant
         if {$enable_use_internal_fifo} {
            set_disable max_channels
         }

         # Set enable_clk_sharing for multichannel MAC_PCS
         if { [expr {"$enable_use_internal_fifo" == "false"}] } {
            set_parameter_value enable_clk_sharing 1
         } else {
            set_parameter_value enable_clk_sharing 0
         }
         
         # Enable shift 16 is not applicable for FIFO 8 bit interface
         if {$enable_use_internal_fifo} {
            if {[expr $enable_ena == 8]} {
               set_disable enable_shift16
            }
         }

         # Update the ifGMII to MII/GMII only
         set_parameter_property ifGMII ALLOWED_RANGES "$rangeMiiGmii"    

         # Halfduplex mode for MAC is only applicable if SGMII bridge is enabled
         if {"$enable_sgmii" == "false"} {
            set_disable enable_hd_logic
         }
          
         # Enable pll_type to CMU and ATX for device families of Stratix V and Arria V GZ with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAVGZ"}]} { 
            set_enable phyip_pll_type
          } else {
            set_disable phyip_pll_type
         }

         # Enable syncE support for Stratix V, Arria V GZ, Arria V and Cyclone V with transceiver type is GXB
         # Enable TX PLL base data rate setting for Stratix V, Arria V GZ, Arria V and Cyclone V with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "STRATIXV"} || \
               {"$deviceFamily" == "ARRIAVGZ"} || \
               {"$deviceFamily" == "ARRIAV"} || \
               {"$deviceFamily" == "CYCLONEV"}]} { 
            set_enable phyip_en_synce_support
            set_enable phyip_pll_base_data_rate
         } else {
            set_disable phyip_en_synce_support
            set_disable phyip_pll_base_data_rate
         }

         # Enable TX PLL clock network selection Arria V and Cyclone V with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIAV"} || \
               {"$deviceFamily" == "CYCLONEV"}]} { 
            set_enable phyip_pma_bonding_mode
         } else {
            set_disable phyip_pma_bonding_mode
         }
 
         # Enable dynamic reconfiguration for Arria 10 with transceiver type is GXB
         if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIA10"}]} { 
            set_enable nf_phyip_rcfg_enable
         } else {
            set_disable nf_phyip_rcfg_enable
         }
            
   	if {[expr {"$transceiver_type" == "GXB"}] &&
            [expr {"$deviceFamily" == "ARRIA10"}]} { 
            
            if {$nf_phyip_rcfg_enable} {
               set_enable XCVR_RCFG_JTAG_ENABLE
               set_enable XCVR_SET_CAPABILITY_REG_ENABLE
               set_enable XCVR_SET_USER_IDENTIFIER
               set_enable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
               set_enable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE
         	}
         } else {
           
               set_disable XCVR_RCFG_JTAG_ENABLE
               set_disable XCVR_SET_CAPABILITY_REG_ENABLE
               set_disable XCVR_SET_USER_IDENTIFIER
               set_disable XCVR_SET_CSR_SOFT_LOGIC_ENABLE
               set_disable XCVR_SET_PRBS_SOFT_LOGIC_ENABLE      
         }

         # Enable IO PLL sharing option for Arria 10 with transceiver type is LVDS
         if {[expr {"$transceiver_type" == "LVDS_IO"}] &&
            [expr {"$deviceFamily" == "ARRIA10"}] &&
            [expr {"$enable_use_internal_fifo" == "false"}]} { 
            set_enable nf_lvds_iopll_num_channels

            # Update the value for this parameter based on max_channels
            if {$max_channels == 1} {
               set_parameter_value nf_lvds_iopll_num_channels 1
            } elseif {$max_channels == 4} {
               set_parameter_value nf_lvds_iopll_num_channels 4
            } elseif {$max_channels == 8} {
               set_parameter_value nf_lvds_iopll_num_channels 8
            } elseif {$max_channels == 12} {
               set_parameter_value nf_lvds_iopll_num_channels 12
            } elseif {$max_channels == 16} {
               set_parameter_value nf_lvds_iopll_num_channels 8
            } elseif {$max_channels == 20} {
               set_parameter_value nf_lvds_iopll_num_channels 10
            } else {
               set_parameter_value nf_lvds_iopll_num_channels 12
            }

         } else {
            set_disable nf_lvds_iopll_num_channels
         }

         #Enable timestamp option
         if {$enable_sgmii && 
            ([expr {"$transceiver_type" == "GXB"}]) &&
            [expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}  || {"$deviceFamily" == "CYCLONEV"}]} {
            set_enable enable_timestamping
         } elseif {$enable_sgmii && 
            ([expr {"$transceiver_type" == "LVDS_IO"}]) &&
            [expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}]} {
            set_enable enable_timestamping			
         } else {
            set_disable enable_timestamping
         }
          
         if {$enable_timestamping && $enable_sgmii && 
            ([expr {"$transceiver_type" == "GXB"}]) &&
            [expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}  || {"$deviceFamily" == "CYCLONEV"}]} {		 
            set_enable enable_ptp_1step
            set_enable tstamp_fp_width
         } elseif {$enable_timestamping && $enable_sgmii && 
            ([expr {"$transceiver_type" == "LVDS_IO"}]) &&
            [expr {"$enable_use_internal_fifo" == "false"}] &&
            [expr {"$deviceFamily" == "ARRIA10"} || {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAV"}  || {"$deviceFamily" == "ARRIAVGZ"}]} {		 
            set_enable enable_ptp_1step
            set_enable tstamp_fp_width			
         } else {
            set_disable enable_ptp_1step
            set_disable tstamp_fp_width
         }
      }
   }

   # Update MAC only related GUI options
   if {[get_parameter_value isUseMAC]} {
      # Enable extended statistic counter parameter only if we enable the statistic counter
      if {$stat_cnt_ena} {
         set_enable ext_stat_cnt_ena
      } else {
         set_disable ext_stat_cnt_ena
      }

      # Enable the mdio_clk_div parameter only if we enable the mdio module
      if {$useMDIO} {
         set_enable mdio_clk_div
      } else {
         set_disable mdio_clk_div
      }

      # Disable fifo related options if fifo is not enabled
      if {$enable_use_internal_fifo} { 
         # Do nothing if FIFO is enabled
      } else {
         set_disable enable_ena
         set_disable eg_addr
         set_disable ing_addr
      }
   }

   # Update PCS only related GUI options
   if {[get_parameter_value isUsePCS]} {
      # Enable transceiver related options only if we are using GXB transceiver (non-phyip version)
      if {[expr {"$transceiver_type" != "GXB"}] || 
         [expr {[expr {"$transceiver_type" == "GXB"}] && [expr {[is_use_phyip] || [is_use_nf_phyip]}] } ]} {
         set_disable export_pwrdn
         set_disable enable_alt_reconfig
         set_disable starting_channel_number
      } elseif {[expr {"$transceiver_type" == "GXB"}]} {
         # enable_alt_reconfig is only available for STRATIXIIGX and STRATIXIIGXLITE
         if {[expr {"$deviceFamily" != "STRATIXIIGX"} && {"$deviceFamily" != "STRATIXIIGXLITE"}]} {
            set_disable enable_alt_reconfig
         }
      }
   }

   # Update the reduced_interface_ena value based on ifGMII value
   if {[expr {"$ifGMII" == "RGMII"}]} {
      set_parameter_value reduced_interface_ena 1
   } else {
      set_parameter_value reduced_interface_ena 0
   }

   # Update the synchronizer depth value based on deviceFamily value
   if { [ expr {"$deviceFamily" == "STRATIXIV"} || {"$deviceFamily" == "ARRIAII"} ] } {
      set_parameter_value synchronizer_depth 4
   } else {
      set_parameter_value synchronizer_depth 3
   }

   # Update the PHYIP TX PLL base data rate range
   update_phyip_pll_base_data_rate_range

   ######################################################################
   # Messages
   #######################################################################

   # Multichannel fifoless MAC option message
   if {[get_parameter_value isUseMAC]} {
      if {$enable_use_internal_fifo} {
      } else {

         # Multi channel MAC message
         if {$max_channels > 1} {
            send_message INFO "MAC options apply to all MAC instances "
         }

         if {$enable_shift16} {
            send_message INFO "Parameter \"Align packet headers to 32-bit boundary\" cannot be changed during runtime in selected configuration"
         }
      }
   }

   if {[get_parameter_value isUsePCS] && [get_parameter_value isUseMAC]} {
      send_message INFO "MII/GMII is automatically selected in 10/100/1000 Mb Ethernet MAC with 1000BASE-X/SGMII PCS core variations"
      
      if {$enable_use_internal_fifo} {
      } else {
         # Multi channel MAC+PCS message
         if {$max_channels > 1} {
            send_message INFO "All PCS instances use the same PHY ID"
         }
      }
   }

   # Info message about TX PLL type and base data rate setting for Series V transceiver
   if {[expr {"$transceiver_type" == "GXB"}] &&
       [expr {"$core_variation" == "MAC_PCS"} || \
       {"$core_variation" == "PCS_ONLY"}]} {

      if {[expr {"$deviceFamily" == "STRATIXV"} || {"$deviceFamily" == "ARRIAVGZ"}]} {
         if {[expr {"$phyip_pll_type" == "CMU"}]} {
            send_message INFO "TX PLL is set to CMU with base data rate $phyip_pll_base_data_rate"
         } else {
            send_message INFO "TX PLL is set to ATX with base data rate $phyip_pll_base_data_rate"
         }
      } elseif {[expr {"$deviceFamily" == "ARRIAV"}]} {
         # Arria V device supports CMU PLL options only
         send_message INFO "TX PLL is set to CMU with base data rate $phyip_pll_base_data_rate"
      } elseif {[expr {"$deviceFamily" == "CYCLONEV"}]} {
         send_message INFO "TX PLL is set to CMU with base data rate $phyip_pll_base_data_rate"
      }
   }

 # Error out if number of ports exceed 8 for LVDS I/O variant due to A10 device limitation
   if {[expr {"$transceiver_type" == "LVDS_IO"}] && [expr {"$core_variation" == "MAC_PCS"}] && [expr {"$deviceFamily" == "ARRIA10"}]} {
      if {$max_channels > 8} {
            send_message ERROR "The maximum channels supported is 8 for LVDS variant. Please refer to the TSE user guide for more info."
       }
   }  

   # Error out if ECC is not supported
   # This feature is only supported with core variation MAC_ONLY and MAC_PCS
   # with family ARRIAVGZ, STRATIXV, ARRIA10, STRATIX10
   if {$enable_ecc} {
      if {[expr {"$core_variation" == "PCS_ONLY"}] && [expr {"$enable_sgmii" == "false"}]} {
         send_message ERROR "ECC protection is not needed for core variation 1000BASE-X/SGMII PCS only and SGMII bridge disabled"
      } else {
         if {[expr {"$deviceFamily" != "ARRIAVGZ"}] &&
            [expr {"$deviceFamily" != "STRATIXV"}] &&
            [expr {"$deviceFamily" != "ARRIA10"}]
         } {
            send_message ERROR "ECC protection is not supported with selected device family.Please refer to the TSE user guide for more info."
         }
      }
   }

   if {[expr {"$deviceFamily" == "ARRIA10"}]}  {
    send_message INFO "RGMII is not supported for Arria 10 devices."
   }

}
