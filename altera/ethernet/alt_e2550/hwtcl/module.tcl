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


package provide alt_e2550::module 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_e2550::parameters
package require alt_e2550::interfaces
package require alt_e2550::fileset

namespace eval ::alt_e2550::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  variable ip_dir [file join .. .. alt_e2550]

  variable module {\
    {NAME       VERSION                     SUPPORTED_DEVICE_FAMILIES  HIDE_FROM_QSYS  HIDE_FROM_QUARTUS  INTERNAL  EDITABLE  VALIDATION_CALLBACK                  ELABORATION_CALLBACK            PARAMETER_UPGRADE_CALLBACK             DISPLAY_NAME        GROUP                           AUTHOR                DESCRIPTION  DATASHEET_URL}\
    {alt_e2550  18.1      { "Arria 10" }             true            false              true      true      ::alt_e2550::parameters::validate    ::alt_e2550::module::elaborate  ::alt_e2550::module::upgrade_callback  "25G/50G Ethernet Intel FPGA IP"  "Interface Protocols/Ethernet"  "Intel Corporation"  "25G/50G"    ""           }\
    {alt_e50    18.1      { "Arria 10" }             true            false              true      true      ::alt_e2550::parameters::validate    ::alt_e2550::module::elaborate  ::alt_e2550::module::upgrade_callback  "50G Ethernet Intel FPGA IP"  "Interface Protocols/Ethernet"  "Intel Corporation"  "50G"    ""           }\
    {alt_e25    18.1      { "Arria 10" }             true            false              true      true      ::alt_e2550::parameters::validate    ::alt_e2550::module::elaborate  ::alt_e2550::module::upgrade_callback  "25G Ethernet Intel FPGA IP"  "Interface Protocols/Ethernet"  "Intel Corporation"  "25G"    ""           }\
  }
}

proc ::alt_e2550::module::declare_module { { speed 2550 } } {
    variable module

    ip_declare_module $module

    if {$speed == 25} {
        ip_set "module.NAME.value" alt_e25
        ip_set "module.DISPLAY_NAME.value" "25G Ethernet Intel FPGA IP"
        ip_set "module.DESCRIPTION.value" "25G"
        ip_set "module.INTERNAL.value" false
        ::alt_e2550::parameters::replace_parameter SPEED_CONFIG DEFAULT_VALUE 25
        ::alt_e2550::parameters::replace_parameter SPEED_CONFIG VISIBLE false
        ::alt_e2550::parameters::replace_parameter SYNOPT_STRICT_SOP VISIBLE false
    }

    if {$speed == 50} {
        ip_set "module.NAME.value" alt_e50
        ip_set "module.DISPLAY_NAME.value" "50G Ethernet Intel FPGA IP"
        ip_set "module.DESCRIPTION.value" "50G"
        ip_set "module.INTERNAL.value" false
        ::alt_e2550::parameters::replace_parameter SPEED_CONFIG DEFAULT_VALUE 50
        ::alt_e2550::parameters::replace_parameter SPEED_CONFIG VISIBLE false

        ::alt_e2550::parameters::replace_parameter SYNOPT_MAC_STATS_COUNTERS DEFAULT_VALUE 0
        ::alt_e2550::parameters::replace_parameter SYNOPT_MAC_STATS_COUNTERS VISIBLE false

        ::alt_e2550::parameters::replace_parameter SYNOPT_FLOW_CONTROL  VISIBLE false
        ::alt_e2550::parameters::replace_parameter SYNOPT_NUMPRIORITY   VISIBLE false
        ::alt_e2550::parameters::replace_parameter SYNOPT_TXCRC_PASS    VISIBLE false
        ::alt_e2550::parameters::replace_parameter SYNOPT_READY_LATENCY ALLOWED_RANGES {0}
    }
    
    ::alt_e2550::fileset::declare_filesets
    ::alt_e2550::parameters::declare_parameters
}

proc ::alt_e2550::module::elaborate {} {
    ::alt_e2550::interfaces::elaborate
    ::alt_e2550::fileset::add_instances
}

# UPGRADE CALLBACK
proc ::alt_e2550::module::upgrade_callback {ip_core_type version parameters} {
    send_message INFO "::alt_e2550::module::upgrade_callback $ip_core_type $version"
    if {($ip_core_type == "alt_e2550") || ($ip_core_type == "alt_e50") || ($ip_core_type == "alt_e25")} {
        if {$version == "14.0"} {
            set_parameter_value COMPATIBLE_PORTS 1
            send_message INFO "setting compatible ports"
        }

        foreach { name value } $parameters {
            set_parameter_value $name $value
            send_message INFO "setting parameter $name $value"
        }
    }
}
