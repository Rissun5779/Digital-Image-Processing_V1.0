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


package provide dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks 18.1

package require alt_xcvr::de_tcl::de_api

namespace eval ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks:: {
  namespace export ExpandCommon_UseSourceSuffix_UseTargetSuffix \
                   ExpandCommon_UseSourceSuffix_NoTargetSuffix  \
                   ExpandCommon_NoSourceSuffix_UseTargetSuffix  \
                   ExpandCommon_NoSourceSuffix_NoTargetSuffix
}

##################################################################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_UseTargetSuffix { connection_name } {
  ExpandCommon $connection_name 1 1
}
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_UseSourceSuffix_NoTargetSuffix  { connection_name } {
  ExpandCommon $connection_name 1 0
}
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_UseTargetSuffix  { connection_name } {
  ExpandCommon $connection_name 0 1
}
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon_NoSourceSuffix_NoTargetSuffix   { connection_name } {
  ExpandCommon $connection_name 0 0
}

##################################################################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::ExpandCommon { connection_name use_source_suffix use_target_suffix } {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "ExpandCommon  connection_name:${connection_name} use_source_suffix:${use_source_suffix} use_target_suffix:${use_target_suffix}" DEVELOPMENT
  if { [::alt_xcvr::de_tcl::de_api::de_getData "parameter([::alt_xcvr::de_tcl::de_api::de_getMainInstanceName].enable_split_interface)" VALUE] } {
    set splitted_connection_name [split $connection_name "/"];#\TODO add a check if split occured sucessfully
    set source_connection [lindex ${splitted_connection_name} 0]
    set target_connection [lindex ${splitted_connection_name} 1]
    set source_instance [lindex [split ${source_connection} "."] 0]
    set target_instance [lindex [split ${target_connection} "."] 0]
    set source_suffix [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${source_instance}.split_suffix)"  VALUE ]
    set target_suffix [::alt_xcvr::de_tcl::de_api::de_getData "parameter(${target_instance}.split_suffix)"  VALUE ]
    set source_suffix [ expr { ${source_suffix}=="NOVAL" ? "" : ${source_suffix} } ]
    set target_suffix [ expr { ${target_suffix}=="NOVAL" ? "" : ${target_suffix} } ]
    set number_of_channels             [::alt_xcvr::de_tcl::de_api::de_getData "parameter([::alt_xcvr::de_tcl::de_api::de_getMainInstanceName].channels)" VALUE];# assumption Native phy so, will be good to have a kind check
    set is_original_connection_enabled [::alt_xcvr::de_tcl::de_api::de_getData "connection($connection_name)"  ENABLED];# !!!!!!!!!!!! this assumes the connection already part of framework!!!!
      
    #disable the existing connection
    ::alt_xcvr::de_tcl::de_api::de_setData "connection($connection_name)"  ENABLED  0
    set new_connections [GetSplittedConnections $source_connection $target_connection $number_of_channels $source_suffix $target_suffix $use_source_suffix $use_target_suffix]
   
    # add new expanded connections to this data element 
    foreach connection $new_connections {
      ::alt_xcvr::de_tcl::de_api::de_setData "connection($connection)"  NAME              ${connection}
      ::alt_xcvr::de_tcl::de_api::de_setData "connection($connection)"  ENABLED           ${is_original_connection_enabled}
      set adapt_connection [::alt_xcvr::de_tcl::de_api::de_getData "connection($connection_name)"  ADAPT_CONNECTION]
      set split_connection [::alt_xcvr::de_tcl::de_api::de_getData "connection($connection_name)"  SPLIT_CONNECTION]
      ::alt_xcvr::de_tcl::de_api::de_setData "connection($connection)"  ADAPT_CONNECTION  [expr { ${adapt_connection}=="NOVAL" ? 1 : ${adapt_connection} }]
      ::alt_xcvr::de_tcl::de_api::de_setData "connection($connection)"  SPLIT_CONNECTION  [expr { ${split_connection}=="NOVAL" ? 1 : ${split_connection} }] 
    }

    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is ExpandCommon: connection_name(${connection_name})" "DEVELOPMENT"
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is ExpandCommon: source_connection(${source_connection}) target_connection(${target_connection})" "DEVELOPMENT"    
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is ExpandCommon: source_suffix(${source_suffix}) target_suffix(${target_suffix})" "DEVELOPMENT"    
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is ExpandCommon: number_of_channels(${number_of_channels}) is_original_connection_enabled(${is_original_connection_enabled})" "DEVELOPMENT"    
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is ExpandCommon: new_connections(${new_connections})" "DEVELOPMENT"
  } else {
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "Interfaces are not split" "INFO"      
  }
}

##################################################################
proc ::dx_altera_xcvr_native_a10::design_example_rules::common_rules::native_phy_connection_expansion_callbacks::GetSplittedConnections {source_connection target_connection number_of_channels source_suffix target_suffix use_source_suffix use_target_suffix} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "source_connection:${source_connection} target_connection:${target_connection} number_of_channels:${number_of_channels} source_suffix:${source_suffix} target_suffix:${target_suffix} use_source_suffix:${use_source_suffix} use_target_suffix:${use_target_suffix}" "DEVELOPMENT" 
  set new_connections [list]
  for {set i 0} {$i < $number_of_channels} {incr i} {
    set updated_source_suffix [expr { $use_source_suffix ? "${source_suffix}${i}": "" }]
    set updated_target_suffix [expr { $use_target_suffix ? "${target_suffix}${i}": "" }]
    set connection "${source_connection}${updated_source_suffix}/${target_connection}${updated_target_suffix}"
    set new_connections [linsert $new_connections end $connection]
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "This is GetSplittedConnections: connection(${connection})" "DEVELOPMENT"
  }
  return $new_connections
}
