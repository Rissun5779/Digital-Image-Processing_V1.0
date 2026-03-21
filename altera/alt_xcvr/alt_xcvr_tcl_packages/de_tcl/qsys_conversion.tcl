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


lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages

package provide alt_xcvr::de_tcl::qsys_conversion 18.1 

package require alt_xcvr::de_tcl::DE_TCL_CONSTANTS
package require -exact qsys ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::QSYS_VERSION}

namespace eval ::alt_xcvr::de_tcl::qsys_conversion:: {
  variable enable_auto_export
  set enable_auto_export "true";#default behavior is to export all dangling logic
}

#------------------------------------------------------------------
#------------------------------------------------------------------
#---- FUNCTIONS TO BE CALLED FROM RULES FOR Qsys-script Phase -----
#------------------------------------------------------------------
#------------------------------------------------------------------
proc ::alt_xcvr::de_tcl::qsys_conversion::enableAutoExport { } {
  variable enable_auto_export
  set enable_auto_export "true"
}

proc ::alt_xcvr::de_tcl::qsys_conversion::disableAutoExport { } {
  variable enable_auto_export
  set enable_auto_export "false"
}

# if an interface from an instance needs to be exported call this function
proc ::alt_xcvr::de_tcl::qsys_conversion::exportInterface { source_instance_name source_iface_name } {
  set export_iface_name "${source_instance_name}_$source_iface_name"
  set export_iface_type       [::alt_xcvr::de_tcl::qsys_conversion::getInterfaceType      ${source_instance_name} ${source_iface_name}]
  set export_iface_direction  [::alt_xcvr::de_tcl::qsys_conversion::getInterfaceDirection ${source_instance_name} ${source_iface_name}]
  set source_inst_iface_name "${source_instance_name}.$source_iface_name"
  add_interface          ${export_iface_name} ${export_iface_type} ${export_iface_direction}
  set_interface_property ${export_iface_name} EXPORT_OF ${source_inst_iface_name}
}

#------------------------------------------------------------------
#------------------------------------------------------------------
#---- SECOND LEVEL HELPERS TO THE "ADD_CONNECTIONS" PROCEDURES ----
#------------------------------------------------------------------
#------------------------------------------------------------------

# if doesnt exist, create
proc ::alt_xcvr::de_tcl::qsys_conversion::incrArrayElement { array_name key {incr 1} } {
  upvar ${array_name} ref_to_array 
  if {[info exists ref_to_array($key)]} {
    incr ref_to_array($key) $incr
  } else {
    set ref_to_array($key) $incr
  }
}

# if doesnt exist, return 0
proc ::alt_xcvr::de_tcl::qsys_conversion::getArrayElement {array_name key} {
    upvar $array_name ref_to_array 
    if {[info exists ref_to_array($key)]} {
        return $ref_to_array($key)
    } else {
        return 0
    } 
}

proc ::alt_xcvr::de_tcl::qsys_conversion::print_array {array_name {str ""}} {
  upvar $array_name ref_to_array 
  send_message INFO "start: printing array note: $str"
  foreach index [array names ref_to_array] {
    send_message INFO "ref_to_array($index): $ref_to_array($index)"
  }
  send_message INFO "end: printing array note: $str"
  send_message INFO "-----------------------------------------------------------"
}


proc ::alt_xcvr::de_tcl::qsys_conversion::parse_connection {connection_name} {
  set splitted [split $connection_name "/"]
  set splitted_source [split [lindex $splitted 0] "."]
  set splitted_target [split [lindex $splitted 1] "."]
  set splitted_source_inst  [lindex $splitted_source 0]
  set splitted_source_iface [lindex $splitted_source 1]
  set splitted_target_inst  [lindex $splitted_target 0]
  set splitted_target_iface [lindex $splitted_target 1]
  return [list $splitted_source_inst $splitted_source_iface $splitted_target_inst $splitted_target_iface]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getSourceInstance {connection_name} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_connection ${connection_name}] 0]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getSourceInterface {connection_name} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_connection ${connection_name}] 1]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getSource {connection_name} {
  return "[getSourceInstance ${connection_name}].[getSourceInterface ${connection_name}]"
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getTargetInstance {connection_name} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_connection ${connection_name}] 2]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getTargetInterface {connection_name} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_connection ${connection_name}] 3]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getTarget {connection_name} {
  return "[::alt_xcvr::de_tcl::qsys_conversion::getTargetInstance ${connection_name}].[::alt_xcvr::de_tcl::qsys_conversion::getTargetInterface ${connection_name}]"
}

proc ::alt_xcvr::de_tcl::qsys_conversion::parse_interface_class_name {instance interface} {
  set iface_type_direction [ get_instance_interface_property $instance $interface CLASS_NAME ]
  set index_of_undescore   [ string last _ ${iface_type_direction} ]
  set iface_type           [ string range ${iface_type_direction} 0                                 [expr {${index_of_undescore}-1}]  ]
  set iface_direction      [ string range ${iface_type_direction} [expr {${index_of_undescore}+1}]  end                               ]
  return [list $iface_type $iface_direction]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getInterfaceType {instance interface} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_interface_class_name ${instance} ${interface}] 0]
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getInterfaceDirection {instance interface} {
  return [lindex [::alt_xcvr::de_tcl::qsys_conversion::parse_interface_class_name ${instance} ${interface}] 1]
}
  
# \TODO use this
proc ::alt_xcvr::de_tcl::qsys_conversion::isInterfacesSinglePort { connection } {
 if { [llength [get_instance_interface_ports [getSourceInstance $connection] [getSourceInterface $connection]]] > 1 &&[llength [get_instance_interface_ports [getTargetInstance $connection] [getTargetInterface $connection]]] > 1 } {
    send_message INFO "too many signals"
    return 0
 }
 return 1
}

proc ::alt_xcvr::de_tcl::qsys_conversion::getPortbyIndex { instance interface {portIdx 0}} {
  return [lindex [get_instance_interface_ports $instance $interface] $portIdx]
}
proc ::alt_xcvr::de_tcl::qsys_conversion::getPortRolebyIndex { instance interface {portIdx 0}} {
  set port [getPortbyIndex $instance $interface $portIdx]
  set port_role [get_instance_interface_port_property $instance $interface $port ROLE]
  return $port_role
}

#-----------------------------------------------------------------
#-----------------------------------------------------------------
#---- FIRST LEVEL HELPERS TO THE "ADD_CONNECTIONS" PROCEDURES ----
#-----------------------------------------------------------------
#-----------------------------------------------------------------

proc ::alt_xcvr::de_tcl::qsys_conversion::isSourceTargetRoleMatch {connection_name} {
  set source_port_role [getPortRolebyIndex [getSourceInstance ${connection_name}] [getSourceInterface ${connection_name}] 0]
  set target_port_role [getPortRolebyIndex [getTargetInstance ${connection_name}] [getTargetInterface ${connection_name}] 0]
  if {$source_port_role != $target_port_role} {
    return 0
  }
  return 1
}

# analyze the connections and group the connections that have the common source with the same group id
# stage 1: analyze connections and give each multi-taget source a unique ID (if split is allowed)
# stage 2: update the connection list based on the analyzsis of stage 1
proc ::alt_xcvr::de_tcl::qsys_conversion::group_multitarget_connections { connections } {
  set NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_NAME}
  set SPLIT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_SPLIT}
  set ADAPT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_ADAPT}
  set GROUP_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_GROUP}
  
  # determine how many target interfaces exists for each source interface
  # and give unique IDs for each multi target connections
  array set number_of_targets_for_each_source {};# keeps track of how many target's exists for this source interface (for the connections that marked as split is ok!)
  array set ids_for_each_source_with_multiple_targets {}      ;# keeps track of a unique ID for each source interface if there are more than 1 connection targets for this source interface
  set available_source_id 1    ;# ID 0 is reserved for single target and non-split connections, and will be incremented by 1 each time
  foreach connection $connections {
    set connection_name [ lindex $connection ${NAME_INDEX} ]
    set isSplitAllowedForConnection [lindex $connection ${SPLIT_INDEX}] 
    if { $isSplitAllowedForConnection } {
      set connection_source [::alt_xcvr::de_tcl::qsys_conversion::getSource $connection_name]
      ::alt_xcvr::de_tcl::qsys_conversion::incrArrayElement number_of_targets_for_each_source $connection_source 1
      if { $number_of_targets_for_each_source($connection_source) == 2 } {
        # this source interface is a multi-target connection so needs a unique ID
        set ids_for_each_source_with_multiple_targets($connection_source) $available_source_id
        incr available_source_id
      }
    }
  }
  set max_source_id [expr {$available_source_id -1}]
  #::alt_xcvr::de_tcl::qsys_conversion::print_array number_of_targets_for_each_source "source_histogram"
  #::alt_xcvr::de_tcl::qsys_conversion::print_array ids_for_each_source_with_multiple_targets "source_IDs"

  # for each connection, if the connections's source occurrance frequency is marked as 0 or 1 or of split is not allowed --> append a group id info to the connection as 0
  #                      o.w  add a group id to the connection from the source_IDs corresponding tho the source of this connection
  set updated_connections [list]
  foreach connection $connections { 
    set connection_name [ lindex $connection ${NAME_INDEX} ]
    set connection_source [::alt_xcvr::de_tcl::qsys_conversion::getSource $connection_name]
    set number_of_targets_for_connection_source [::alt_xcvr::de_tcl::qsys_conversion::getArrayElement number_of_targets_for_each_source $connection_source]
    set isSplitAllowedForConnection [lindex $connection ${SPLIT_INDEX}] 
    if { !$isSplitAllowedForConnection || $number_of_targets_for_connection_source <= 1 } {
      set connection_group_id 0
    } else {
      set connection_group_id [::alt_xcvr::de_tcl::qsys_conversion::getArrayElement ids_for_each_source_with_multiple_targets $connection_source]
    }
    set temp [linsert $connection ${GROUP_INDEX} ${connection_group_id}];# update connection with group id 
    set updated_connections [linsert $updated_connections end $temp]    
  }
  
  # make the first element of the return value "max_source_id"   
  set updated_connections [linsert $updated_connections 0 $max_source_id]  
  return $updated_connections
}

# simply return the connections with the same group ID
proc ::alt_xcvr::de_tcl::qsys_conversion::get_connection_group { connections group_id } {
  set temp ""
  set GROUP_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_GROUP}
  foreach connection $connections {
    if { [lindex $connection ${GROUP_INDEX}] == $group_id } {
      set temp [linsert $temp end $connection]
    }
  }
  return $temp
}

# when this procedure is called it means, for the connection passed as an argument, and interface adaptor need to be inserted in between the source and target
#     and the connection to the adaptor and the connection from the adaptor needs to be returned  
proc ::alt_xcvr::de_tcl::qsys_conversion::add_adaptor {connection} {
  set NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_NAME}
  set SPLIT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_SPLIT}
  set ADAPT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_ADAPT}
  set GROUP_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_GROUP}
  
  # STAGE 1: ADD THE ADAPTOR AND PARAMETRIZE IT
  set connection_name [ lindex $connection ${NAME_INDEX} ]
    
  set source_instance   [::alt_xcvr::de_tcl::qsys_conversion::getSourceInstance  $connection_name                 ]
  set source_iface      [::alt_xcvr::de_tcl::qsys_conversion::getSourceInterface $connection_name                 ]
  set source_iface_type [::alt_xcvr::de_tcl::qsys_conversion::getInterfaceType   $source_instance  $source_iface  ]
  set source_port       [::alt_xcvr::de_tcl::qsys_conversion::getPortbyIndex     $source_instance  $source_iface 0]
  set source_port_role  [::alt_xcvr::de_tcl::qsys_conversion::getPortRolebyIndex $source_instance  $source_iface 0]
 
  set target_instance   [::alt_xcvr::de_tcl::qsys_conversion::getTargetInstance  $connection_name                 ]
  set target_iface      [::alt_xcvr::de_tcl::qsys_conversion::getTargetInterface $connection_name                 ]
  set target_iface_type [::alt_xcvr::de_tcl::qsys_conversion::getInterfaceType   $target_instance  $target_iface  ]
  set target_port       [::alt_xcvr::de_tcl::qsys_conversion::getPortbyIndex     $target_instance  $target_iface 0]
  set target_port_role  [::alt_xcvr::de_tcl::qsys_conversion::getPortRolebyIndex $target_instance  $target_iface 0]

  set instance_name    "${source_instance}_${source_iface}_${target_instance}_${target_iface}_adaptor" 
  set port_width [get_instance_interface_port_property $source_instance $source_iface $source_port WIDTH];
  add_instance $instance_name alt_xcvr_if_adapter; # QSYS-CALL
  set_instance_parameter_value $instance_name "port_width" $port_width;
  set_instance_parameter_value $instance_name "i_iface_type"      $source_iface_type; 
  set_instance_parameter_value $instance_name "i_role"            $source_port_role;  
  set_instance_parameter_value $instance_name "o_iface_type"      $target_iface_type; 
  set_instance_parameter_value $instance_name "o_role"            $target_port_role; 

  # STAGE 2: BUILD AND RETURN THE CONNECTIONS AROUND THE ADAPTOR  
  set return_connections ""
  set connection_to_adaptor ""
  set connection_to_adaptor   [linsert ${connection_to_adaptor}   $NAME_INDEX  "${source_instance}.${source_iface}/${instance_name}.port_i"]
  set connection_to_adaptor   [linsert ${connection_to_adaptor}   $SPLIT_INDEX 0];# single connection from now on
  set connection_to_adaptor   [linsert ${connection_to_adaptor}   $ADAPT_INDEX 0];# adaptor will match the role of the source anyways so set it to 0
  set connection_to_adaptor   [linsert ${connection_to_adaptor}   $GROUP_INDEX 0];# single connection from now on
  set return_connections [linsert  $return_connections end ${connection_to_adaptor}]
 
  set connection_from_adaptor ""
  set connection_from_adaptor [linsert ${connection_from_adaptor} $NAME_INDEX  "${instance_name}.port_o/${target_instance}.${target_iface}"]
  set connection_from_adaptor [linsert ${connection_from_adaptor} $SPLIT_INDEX 0];# single connection from now on
  set connection_from_adaptor [linsert ${connection_from_adaptor} $ADAPT_INDEX 0];# adaptor will match the role of the source anyways so set it to 0
  set connection_from_adaptor [linsert ${connection_from_adaptor} $GROUP_INDEX 0];# single connection from now on
  set return_connections [linsert  $return_connections end ${connection_from_adaptor}]  
  
  return ${return_connections}
}

# argument passed to this procedures --> are the connections that stems from the same source and goes to multiple targets so
# 1) add a splitter fro the connection group_id
# 2) build and return new connections around the 'splitter'
proc ::alt_xcvr::de_tcl::qsys_conversion::add_splitter { connections } { 
  set NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_NAME}
  set SPLIT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_SPLIT}
  set ADAPT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_ADAPT}
  set GROUP_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_GROUP}
  
  # STAGE 1: ADD THE SPLITTER AND PARAMETRIZE IT
  set first_connection_name                [lindex [lindex $connections 0] $NAME_INDEX]
  set first_connection_source              [::alt_xcvr::de_tcl::qsys_conversion::getSource          $first_connection_name]
  set first_connection_source_instance     [::alt_xcvr::de_tcl::qsys_conversion::getSourceInstance  $first_connection_name]
  set first_connection_source_iface        [::alt_xcvr::de_tcl::qsys_conversion::getSourceInterface $first_connection_name]
  set first_connection_source_iface_type   [::alt_xcvr::de_tcl::qsys_conversion::getInterfaceType   $first_connection_source_instance $first_connection_source_iface]
  set first_connection_source_port         [::alt_xcvr::de_tcl::qsys_conversion::getPortbyIndex     $first_connection_source_instance $first_connection_source_iface 0]
  set first_connection_source_port_role    [::alt_xcvr::de_tcl::qsys_conversion::getPortRolebyIndex $first_connection_source_instance $first_connection_source_iface 0]
 
  set splitter_name  "${first_connection_source_instance}_${first_connection_source_iface}_splitter" 
  set number_of_outputs_from_splitter [llength $connections]
  set first_connection_port_width [get_instance_interface_port_property $first_connection_source_instance $first_connection_source_iface $first_connection_source_port WIDTH];
  add_instance $splitter_name "alt_xcvr_if_fanout"; # QSYS-CALL
  set_instance_parameter_value $splitter_name "num_bcast_outputs" $number_of_outputs_from_splitter;
  set_instance_parameter_value $splitter_name "port_width"        $first_connection_port_width;
  set_instance_parameter_value $splitter_name "i_iface_type"      $first_connection_source_iface_type; 
  set_instance_parameter_value $splitter_name "i_role"            $first_connection_source_port_role;    

  # STAGE 2: BUILD AND RETURN THE CONNECTIONS AROUND THE SPLITTER    
  # A) BUILD CONNECTION TO SPLITTER
  set return_connections ""
  set connection_to_splitter ""
  set connection_to_splitter     [linsert ${connection_to_splitter}   $NAME_INDEX  "${first_connection_source}/${splitter_name}.port_i"]
  set connection_to_splitter     [linsert ${connection_to_splitter}   $SPLIT_INDEX 0];# single connection from now on
  set connection_to_splitter     [linsert ${connection_to_splitter}   $ADAPT_INDEX 0];# splitter will match the role of the source anyways so no need to adapt
  set connection_to_splitter     [linsert ${connection_to_splitter}   $GROUP_INDEX 0];# single connection from now on anyways
  set return_connections [linsert  $return_connections end ${connection_to_splitter}]

  # B) BUILD CONNECTIONS FROM SPLITTER
  set connection_index 0
  foreach connection $connections {
    set connection_from_splitter ""
    set connection_from_splitter [linsert ${connection_from_splitter} $NAME_INDEX "${splitter_name}.port_o${connection_index}/[::alt_xcvr::de_tcl::qsys_conversion::getTarget [lindex $connection $NAME_INDEX]]"]
    set connection_from_splitter [linsert ${connection_from_splitter} $SPLIT_INDEX 0];# single connection from now on
    set connection_from_splitter [linsert ${connection_from_splitter} $ADAPT_INDEX [lindex $connection $ADAPT_INDEX]];# carry from original connection
    set connection_from_splitter [linsert ${connection_from_splitter} $GROUP_INDEX 0];# single connection from now on anyways
    set return_connections [linsert  $return_connections end ${connection_from_splitter}]
    incr connection_index
  }
  return $return_connections    
}

#------------------------------------------------------------
#------------------------------------------------------------
#--------- FIRST LEVEL HELPERS TO THE MAIN SCRIPT -----------
#------------------------------------------------------------
#------------------------------------------------------------

# UPDATE PROJECT SETTINGS
proc ::alt_xcvr::de_tcl::qsys_conversion::update_project_settings { qsys_project_settings } {
  set NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_NAME}
  set VALUE_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_VALUE}  
  foreach project_setting $qsys_project_settings {
    set_project_property [lindex ${project_setting} ${NAME_INDEX}] [lindex ${project_setting} ${VALUE_INDEX}]
  }
}

# ADD INSTANCES
proc ::alt_xcvr::de_tcl::qsys_conversion::add_instances { instances } {
  set NAME_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_INSTANCE_NAME}
  set TYPE_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_INSTANCE_TYPE}  
  foreach instance $instances {
    add_instance [lindex $instance ${NAME_INDEX}] [lindex $instance ${TYPE_INDEX}]
  }
}

# UPDATE PARAMETER VALUES
proc ::alt_xcvr::de_tcl::qsys_conversion::set_parameters { parameters } {
  set INSTANCE_NAME_INDEX   ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_INSTANCE_NAME}
  set PARAMETER_NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_PARAMETER_NAME}
  set PARAMETER_VALUE_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_PARAMETER_VALUE}  
  foreach parameter $parameters {
    set_instance_parameter_value   [lindex $parameter ${INSTANCE_NAME_INDEX}] [lindex $parameter ${PARAMETER_NAME_INDEX}] [lindex $parameter ${PARAMETER_VALUE_INDEX}]
  }
}

# ADD THE CONNECTIONS
proc ::alt_xcvr::de_tcl::qsys_conversion::add_connections { connections } {
  set NAME_INDEX  ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_NAME}
  set ADAPT_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_ADAPT}
  set GROUP_INDEX ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_GROUP}
  
  # add a new field to the list 0 means single target 1,2,3,....N shows multitarget group
  set grouped_connections [::alt_xcvr::de_tcl::qsys_conversion::group_multitarget_connections $connections]
  set number_of_multitarget_groups [lindex $grouped_connections 0]; # first element is the number_of_multitarget_groups
  set grouped_connections [lrange $grouped_connections 1 end];      # the rest of the elements are connections 
  
  # 1) store single_target_connections
  set pre_final_connections [::alt_xcvr::de_tcl::qsys_conversion::get_connection_group $grouped_connections 0]; 
  
  # 2) add a splitter for each multi-target connection group, and update the list of connections around the splitter
  for {set multi_target_group_index 1} {$multi_target_group_index <= $number_of_multitarget_groups} {incr multi_target_group_index} {
    set current_connection_group [::alt_xcvr::de_tcl::qsys_conversion::get_connection_group $grouped_connections $multi_target_group_index]
    set updated_connections_around_splitter [::alt_xcvr::de_tcl::qsys_conversion::add_splitter ${current_connection_group}]
    set pre_final_connections [concat $pre_final_connections $updated_connections_around_splitter]      
  }

  # 3) analyze all connections 1-more time to add adaptor for each connection (that must be adapted), and update the list of connections around the adaptor
  set final_connections ""
  foreach connection $pre_final_connections {
    if { [isSourceTargetRoleMatch [lindex $connection ${NAME_INDEX}]] } {; # this means adaptor is NOT required
      set final_connections [linsert $final_connections end $connection]; # simply add this connection to final list
    } else {; # this means adaptor is NOT required
      if { ![lindex $connection ${ADAPT_INDEX}] } {; # if the adoptor is specifically NOT requested by the connection --> simply add this connection to final list
        set final_connections [linsert $final_connections end $connection]
      } else {
        set final_connections [concat $final_connections [::alt_xcvr::de_tcl::qsys_conversion::add_adaptor $connection]]; # add the adaptor, return value will be list of connections around the adaptor, add them to the final list
      }
    }
    
  }
  
  # 4) call to qsys to make the connections
  foreach connection $final_connections {
    set connection_name [lindex $connection $NAME_INDEX]
    add_connection $connection_name
  }
}

# EXECUTE QSYS-SCRIPTS COMMANDS
proc ::alt_xcvr::de_tcl::qsys_conversion::execute_commands { commands } {
  foreach command $commands {
    send_message INFO "Cmd: ${command}"
  }
  foreach command $commands {
    eval $command
  }
}

#------------------------------------------------------------
#------------------------------------------------------------
#------------ THIS IS THE MAIN SCRIPT PORTION ---------------
#------------------------------------------------------------
#------------------------------------------------------------

# expected inputs:
#   qsys_project_settings ---- example ---->
#   qsys_instances        ---- example ---->
#   qsys_parameters       ---- example ---->
#   qsys_connections      ---- example ---->
#   qsys_script_commands  ---- example ---->
#   qsys_filename         ---- example ----> final system name --> assumed no .qsys at the and

# PROCESS PROJECT SETTING PARAMETERS
if {[info exists qsys_project_settings]} {
  send_message INFO "Project settings passed for conversion: $qsys_project_settings"
  ::alt_xcvr::de_tcl::qsys_conversion::update_project_settings ${qsys_project_settings}
  send_message INFO "Project settings are updated!"
} else {
  send_message ERROR "No project settings passed to conversion script!"
}

# PROCESS INSTANCES
if {[info exists qsys_instances]} {
  send_message INFO "Instances passed for conversion: $qsys_instances"
  ::alt_xcvr::de_tcl::qsys_conversion::add_instances $qsys_instances
  send_message INFO "Instances are converted!"
} else {
  send_message ERROR "No instances passed to conversion script!"
}

# PROCESS PARAMETERS
if {[info exists qsys_parameters]} {
  send_message INFO "Parameters passed for conversion: $qsys_parameters"
  ::alt_xcvr::de_tcl::qsys_conversion::set_parameters $qsys_parameters
  send_message INFO "Parameters are converted!"
} else {
  send_message WARNING "No parameters passed to conversion script!"
}

# PROCESS CONNECTIONS
if {[info exists qsys_connections]} {
  send_message INFO "Connections passed for conversion: $qsys_connections"
  ::alt_xcvr::de_tcl::qsys_conversion::add_connections $qsys_connections
  send_message INFO "Connections are converted!"
} else {
  send_message WARNING "No connections passed to conversion script!"
}

# EXECUTE QSYS-SCRIPTS COMMANDS
if {[info exists qsys_script_commands]} {
  send_message INFO "Qsys-script commands passed for execution: ${qsys_script_commands}"
  ::alt_xcvr::de_tcl::qsys_conversion::execute_commands ${qsys_script_commands}
  send_message INFO "Qsys-script commands are executed!"
} else {
  send_message INFO "No qsys-script commands passed for execution!"
}

# EXPORT DANGLING LOGIC --> DEFAULT BEHAVIOR IS TO EXPORT ALL DANGLING --> THIS IS FOR BACKWORD COMPATIBILITY
if { ${::alt_xcvr::de_tcl::qsys_conversion::enable_auto_export} == "true"} {
  foreach instance [get_instances] { 
    set_instance_property $instance AUTO_EXPORT "true" 
  }
}

# CALL SYSTEM VALIDATION, this is qsys-script call
set validation_output [validate_system]
foreach message_string $validation_output {
  set message_level ""
  set message_string_parsed ""
  if {![regexp -nocase {(Info|Error|Warning|Progress|Debug):(.*)} $message_string -> message_level message_string_parsed]} {
    set message_level "INFO";
    set message_string_parsed $message_string
  }
  send_message $message_level "validate_system output: $message_string_parsed"
}
#\TODO: analyze return value


# CHECK FILENAME AND SAVE SYSTEM
if {![info exists qsys_filename]} {
  set qsys_filename "no_name_specified"
  send_message WARNING "No file name specified, for qsys-system! ${qsys_filename} will be used as the default name."
}
file delete "${qsys_filename}"
save_system "${qsys_filename}"
send_message INFO "Temporary system saved as ${qsys_filename}" 



