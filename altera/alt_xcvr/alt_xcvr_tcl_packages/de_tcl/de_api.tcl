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



package provide alt_xcvr::de_tcl::de_api 18.1

package require alt_xcvr::de_tcl::framework


namespace eval ::alt_xcvr::de_tcl::de_api:: {

  namespace export \
        de_sendMessage \
        de_getMainInstanceName \
        de_buildQsysSystem \
        de_initializeFramework \
        de_declareInstances \
        de_declareParameters \
        de_declareConnections \
        de_declareRules \
        de_declareSingleRule \
        de_getData \
        de_setData \
        de_declareQsysScriptCommands \
        de_isInstanceExist \
        de_getInstanceName \
        de_convertToQsys \
        de_registerData \
        de_getRegisteredData \
        de_getErrorStatus \
        de_getQsysPath \
        de_closeLogger
        
  variable global_framework;#\TODO static mi?
}

proc ::alt_xcvr::de_tcl::de_api::de_closeLogger { } {
  variable global_framework;
  $global_framework closeLogger
}

proc ::alt_xcvr::de_tcl::de_api::de_getErrorStatus { } {
  variable global_framework;
  return [$global_framework getErrorStatus]
}

#\TODO lvl list here
proc ::alt_xcvr::de_tcl::de_api::de_sendMessage {str lvl} {
  variable global_framework;
  
  set msg_source "([uplevel {namespace current}])([lindex [info level -1] 0])"
  set str [format "%-100s" $str]
  set str "${str} \[Message source: ${msg_source}\]"     
    
  if {[info exists global_framework]} {
    $global_framework outMessage $str $lvl
  } else {
    puts "\[....\] $str"
  }
}

proc ::alt_xcvr::de_tcl::de_api::de_constructMainInstanceTable {main_instance_name enabled} {
  # includes a _hw.tcl call
  return [list [list NAME KIND ENABLED] [list $main_instance_name [get_module_property NAME] ${enabled}]]
}
  
proc ::alt_xcvr::de_tcl::de_api::de_constructMainInstanceParametersTable {main_instance_name enabled} {
  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started" DEVELOPMENT
  # includes a _hw.tcl call
  set all_parameters [get_parameters]
  set non_derived_parameters ""
  set derived_parameters ""
  foreach parameter $all_parameters {
    if {![get_parameter_property $parameter DERIVED]} {
      set non_derived_parameters [linsert $non_derived_parameters end $parameter]
    } else {
      set derived_parameters [linsert $derived_parameters end $parameter]
    }
  }
  
  set temp [list {NAME VALUE ENABLED}]
  foreach parameter $non_derived_parameters {
    set var1 "$main_instance_name.${parameter}"
    set var2 [get_parameter_value $parameter]
    set elem ""
    set elem [linsert $elem 0 $var1]
    set elem [linsert $elem 1 $var2]
    set elem [linsert $elem 2 ${enabled}];#this is ENABLED field --> ENABLE
    set temp [linsert $temp end $elem]
  }
  foreach parameter $derived_parameters {
    set var1 "$main_instance_name.${parameter}"
    set var2 [get_parameter_value $parameter]
    set elem ""
    set elem [linsert $elem 0 $var1]
    set elem [linsert $elem 1 $var2]
    set elem [linsert $elem 2 0];#this is ENABLED field --> DISABLE dont try to set it 
    set temp [linsert $temp end $elem]
  }
  return $temp
}

proc ::alt_xcvr::de_tcl::de_api::de_getMainInstanceName {} {
  variable global_framework;
  return [$global_framework getMainInstanceName]
}

proc ::alt_xcvr::de_tcl::de_api::de_buildQsysSystem { useQsysPro root_dir qsys_file_name log_file_name main_instance_name main_instance_enabled rule_name rule_path rule_map device_family device  qsys_script_search_path } {
  ::alt_xcvr::de_tcl::de_api::de_initializeFramework ${useQsysPro}  ${root_dir}    ${qsys_file_name}   ${log_file_name}   ${main_instance_name}   ${main_instance_enabled}  

  ::alt_xcvr::de_tcl::de_api::de_declareSingleRule   ${rule_name}   ${rule_path}   ${rule_map}

  set files [::alt_xcvr::de_tcl::de_api::de_convertToQsys   ${device_family}   ${device}   ${qsys_script_search_path}]                                      
  if {[::alt_xcvr::de_tcl::de_api::de_getErrorStatus]} {
   set error_dir "failed"
   ::alt_xcvr::ip_tcl::messages::ip_message error "Design example generation failed!";#printing message to ip_message will show up in generation window
  } else {
   set error_dir ""
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "Generated succesfully " DEVELOPMENT
  }

  ::alt_xcvr::de_tcl::de_api::de_closeLogger

  dict for {fullpath_filename subdir} $files {
     set filename [file tail $fullpath_filename]
     add_fileset_file [file join $error_dir $subdir $filename] OTHER PATH ${fullpath_filename}
  }

  return [::alt_xcvr::de_tcl::de_api::de_getQsysPath]
}

proc ::alt_xcvr::de_tcl::de_api::de_initializeFramework {   isQsysPro   root_dir   qsys_file_name   log_file_name   main_instance_name   {main_instance_enabled 1}   } {
  variable global_framework;#\TODO how to prevent double call? \TODO how to do for Native Phy specialization etc...
  set global_framework [::alt_xcvr::de_tcl::framework::DesignExampleFramework new ${isQsysPro} ${root_dir} ${qsys_file_name} ${log_file_name} ${main_instance_name}]
  $global_framework declareInstances  [de_constructMainInstanceTable           ${main_instance_name} ${main_instance_enabled}]
  $global_framework declareParameters [de_constructMainInstanceParametersTable ${main_instance_name} ${main_instance_enabled}]
}

proc ::alt_xcvr::de_tcl::de_api::de_getQsysPath { } {
  variable global_framework;
  return [$global_framework getQsysPath]
}

proc ::alt_xcvr::de_tcl::de_api::de_declareInstances { instances } {
  variable global_framework;
  $global_framework declareInstances ${instances}
}

proc ::alt_xcvr::de_tcl::de_api::de_declareParameters { parameters } {
  variable global_framework;
  $global_framework declareParameters ${parameters}
}

proc ::alt_xcvr::de_tcl::de_api::de_declareConnections { connections } {
  variable global_framework;
  $global_framework declareConnections ${connections}  
}

proc ::alt_xcvr::de_tcl::de_api::de_declareQsysScriptCommands { commands } {
  variable global_framework;
  $global_framework declareQsysScriptCommands ${commands}  
}

proc ::alt_xcvr::de_tcl::de_api::de_isInstanceExist { reference_name } {
  variable global_framework;
  return [$global_framework isInstanceExist ${reference_name}]
}

proc ::alt_xcvr::de_tcl::de_api::de_getInstanceName { reference_name } {
  variable global_framework;
  $global_framework getInstanceName ${reference_name}  
}

proc ::alt_xcvr::de_tcl::de_api::de_declareRules { rules } {
  variable global_framework;
  $global_framework declareRules ${rules}  
}

proc ::alt_xcvr::de_tcl::de_api::de_declareSingleRule { rule_name rule_type instance_pairs } {
  variable global_framework;

  ::alt_xcvr::de_tcl::de_api::de_sendMessage "Started!" DEVELOPMENT
  set length [llength ${instance_pairs}]
  if { [expr {${length}%2}] } {
    ::alt_xcvr::de_tcl::de_api::de_sendMessage "Improperly formatted argument (${instance_pairs})" ERROR
    return;#\TODO return error code 0 etc ??
  }
  
  set rule  [ list \
            [ list NAME         RULE_TYPE    ENABLED   INSTANCE_PAIRS         ] \
            [ list $rule_name   $rule_type   1         $instance_pairs        ] \
  ]    
  $global_framework declareRules ${rule}  
}

proc ::alt_xcvr::de_tcl::de_api::de_getData { data_type property_type } {
  variable global_framework;
  return [$global_framework getData ${data_type} ${property_type}]
}

proc ::alt_xcvr::de_tcl::de_api::de_setData { data_type property_type data_value} {
  variable global_framework;
  return [$global_framework setData ${data_type} ${property_type} ${data_value}];#\TODO any return expected
}

proc ::alt_xcvr::de_tcl::de_api::de_convertToQsys { device_family device qsys_search_path} {
  variable global_framework;
  return [$global_framework convertToQsys ${device_family} ${device} ${qsys_search_path}];#\TODO a return error etc...
}

proc ::alt_xcvr::de_tcl::de_api::de_registerData { data_name data_value } {
  variable global_framework;
  $global_framework registerData ${data_name} ${data_value}
}


proc ::alt_xcvr::de_tcl::de_api::de_getRegisteredData { data_name } {
  variable global_framework;
  return [$global_framework getRegisteredData ${data_name}];#\TODO a return error etc...
}
