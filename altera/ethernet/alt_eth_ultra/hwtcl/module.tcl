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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package provide alt_eth_ultra::module 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_eth_ultra::parameters
package require alt_eth_ultra::interfaces
package require alt_eth_ultra::fileset

namespace eval ::alt_eth_ultra::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_module

  # Internal variables
  variable module {\
    {NAME           VERSION                 SUPPORTED_DEVICE_FAMILIES   HIDE_FROM_QSYS HIDE_FROM_QUARTUS INTERNAL   EDITABLE    VALIDATION_CALLBACK                 ELABORATION_CALLBACK               PARAMETER_UPGRADE_CALLBACK                        DISPLAY_NAME                          GROUP                                 AUTHOR                           DESCRIPTION DATASHEET_URL}\
    {alt_eth_ultra  18.1  { "Arria 10" }              true           false             true       true        ::alt_eth_ultra::module::validate   ::alt_eth_ultra::module::elaborate ::alt_eth_ultra::module::upgrade_callback        "Low Latency 40G/100G Ethernet Intel FPGA IP"        "Interface Protocols/Ethernet"      "Intel Corporation"             "Low Latency 40G/100GE and 40GBASE-KR4 MAC & PHY"     "http://www.altera.com/literature/ug/ug_ll_40_100gbe.pdf" }\
  }
}


proc ::alt_eth_ultra::module::declare_module { { speed 40100 } } {
    variable module
    ip_declare_module $module

    if {$speed == 40} {
        ip_set "module.NAME.value" alt_eth_ultra_40
        ip_set "module.DISPLAY_NAME.value" "Low Latency 40G Ethernet Intel FPGA IP"
        ip_set "module.DESCRIPTION.value" "Low Latency 40G and 40GBASE-KR4 MAC & PHY"
        ip_set "module.INTERNAL.value" false
        ::alt_eth_ultra::parameters::set_parameter SPEED_CONFIG DEFAULT_VALUE "40 GbE"
        ::alt_eth_ultra::parameters::set_parameter SPEED_CONFIG VISIBLE false
        ::alt_eth_ultra::parameters::set_parameter SYNOPT_CAUI4 VISIBLE false
        ::alt_eth_ultra::parameters::set_parameter SYNOPT_CAUI4_DISABLED VISIBLE false
        ::alt_eth_ultra::parameters::set_parameter SYNOPT_C4_RSFEC VISIBLE false
    }

    if {$speed == 100} {
        ip_set "module.NAME.value" alt_eth_ultra_100
        ip_set "module.DISPLAY_NAME.value" "Low Latency 100G Ethernet Intel FPGA IP"
        ip_set "module.DESCRIPTION.value" "Low Latency 100G MAC & PHY"
        ip_set "module.INTERNAL.value" false
        ::alt_eth_ultra::parameters::set_parameter SPEED_CONFIG DEFAULT_VALUE "100 GbE"
        ::alt_eth_ultra::parameters::set_parameter SPEED_CONFIG VISIBLE false
        ::alt_eth_ultra::parameters::set_parameter SYNOPT_STRICT_SOP VISIBLE false
        ::alt_eth_ultra::parameters::set_display_item "40GBASE-KR4" VISIBLE false
    }

    ::alt_eth_ultra::fileset::declare_filesets
    ::alt_eth_ultra::parameters::declare_parameters
    ::alt_eth_ultra::interfaces::declare_interfaces
}

proc ::alt_eth_ultra::module::validate {} {
  ::alt_eth_ultra::parameters::validate
}

proc ::alt_eth_ultra::module::elaborate {} {
  ::alt_eth_ultra::interfaces::elaborate
  ::alt_eth_ultra::fileset::add_instances
}

#+--------------------------------
#| UPGRADE CALLBACK
#|
proc ::alt_eth_ultra::module::upgrade_callback {ip_core_type version parameters} {
    send_message INFO "::alt_eth_ultra::module::upgrade_callback $ip_core_type $version"
    if {($ip_core_type == "alt_eth_ultra") ||
        ($ip_core_type == "alt_eth_ultra_40") ||
        ($ip_core_type == "alt_eth_ultra_100") } {

        if {$version == "14.0"} {
            set_parameter_value COMPATIBLE_PORTS 1
            send_message INFO "setting compatible ports"
        }

        foreach { name value } $parameters {
            if {$name == "HARD_PRBS_ENABLE" && $value == 1} {
                set_parameter_value ADME_ENABLE 1
                set_parameter_value ODI_ENABLE 1
                send_message INFO "IP Upgrade: Hard PRBS Option Enabled -- translating to ADME/ODI Enabled"
            } elseif {$name != "HARD_PRBS_ENABLE"} {
                set_parameter_value $name $value
            }
        }
    }
}
