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


# Design example framework by default exports all the unconnected ports. 
# Ideally all the ports should be connected other than the ports expected to be driven from outside of this system
# this rule first changes default behavior of exporting all the ports and then lists the interfaces to be exported

package provide altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces 18.1

package require alt_xcvr::de_tcl::de_api

namespace eval ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces:: {
  namespace export declare_rule \
}

##################################################################
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces::declare_rule {  } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
 
  # by default everything exported - disable it
  ::alt_xcvr::de_tcl::de_api::de_declareQsysScriptCommands [list "::alt_xcvr::de_tcl::qsys_conversion::disableAutoExport"]

  # list interfaces to be exported
  # !!! references should be passed as part of INSTANCE_PAIRS to this rule
  #                      INSTANCE_REF                    INTERFACE_NAME 
  set to_be_exported { {"reset_controller_ref"            "clock"}\
                       {"reset_sync_ref"                  "clk"}\
                       {"protocol_tester_ref"             "clock"}\
                       {"frequency_checker_txclkout_ref"  "ref_clock"}\
                       {"frequency_checker_rxclkout_ref"  "ref_clock"}\
                       {"rx_native_phy_ref"               "rx_cdr_refclk0"}\
                       {"pll_ref"                         "pll_refclk0"}\
                       {"reset_sync_ref"                  "reset_req"}\
                       {"protocol_tester_ref"             "pass"}\
                     }

  # add multichannel interfaces
  set to_be_exported [concat ${to_be_exported} \
                             [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces::CreateMultiChannelNames "rx_native_phy_ref" "rx_serial_data"] \
                             [::altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces::CreateMultiChannelNames "tx_native_phy_ref" "tx_serial_data"] \
                     ]

  # Final step to add the export commands          
  foreach export_interface ${to_be_exported} {
    set source_instance_ref   [lindex ${export_interface} 0]
    set source_iface_name     [lindex ${export_interface} 1]
    if {[::alt_xcvr::de_tcl::de_api::de_isInstanceExist ${source_instance_ref}]} {
      set source_instance_name [::alt_xcvr::de_tcl::de_api::de_getInstanceName ${source_instance_ref}];#source_instance_ref should be passed as part of INSTANCE_PAIRS
      ::alt_xcvr::de_tcl::de_api::de_declareQsysScriptCommands [list "::alt_xcvr::de_tcl::qsys_conversion::exportInterface ${source_instance_name} ${source_iface_name}"];# THIS WILL BE RUN AT QSYS-SCRIPT COMMANDS PHASE
    } else {
      ::alt_xcvr::de_tcl::de_api::de_sendMessage "${source_instance_ref} does not exists" WARNING;
    }
  }
}

##################################################################
# Adding suffixes to interface names such as --> tx_serial_data could become --> tx_serial_data_ch0 tx_serial_data_ch1...
# example input                       {"tx_nphy_ref" "tx_serial_data"} 
# example return (a list of lists)  { {"tx_nphy_ref" "tx_serial_data_ch0"} {"tx_nphy_ref" "tx_serial_data_ch1"}}
proc ::altera_xcvr_native_s10::design_example_rules::common_rules::rule_export_interfaces::CreateMultiChannelNames { source_instance_ref  source_iface_name } {
  set ret ""
  if {[::alt_xcvr::de_tcl::de_api::de_isInstanceExist ${source_instance_ref}]} {
    set source_instance_name [::alt_xcvr::de_tcl::de_api::de_getInstanceName ${source_instance_ref}]
    set suffix   [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${source_instance_name}.split_suffix)"  VALUE ]
    set channels [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${source_instance_name}.channels)"  VALUE ]
    for {set i 0} {$i < $channels} {incr i} {
      set ret [linsert $ret end [list ${source_instance_ref}  "${source_iface_name}${suffix}${i}"]]
    }
  }
  return ${ret}
}

