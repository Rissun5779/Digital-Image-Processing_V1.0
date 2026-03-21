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



package provide alt_xcvr::de_tcl::framework 18.1 

package require alt_xcvr::de_tcl::data
package require alt_xcvr::de_tcl::DE_TCL_CONSTANTS

namespace eval ::alt_xcvr::de_tcl::framework:: {

  namespace export \
        DesignExampleFramework \
        replaceInstanceLinks
}


proc ::alt_xcvr::de_tcl::framework::replaceInstanceLinks { instance_map data_to_be_updated append_dot} {
    set INSTANCE_MAP_LENGTH [llength $instance_map]
    if { [expr {${INSTANCE_MAP_LENGTH}%2 !=0}] } {
      my OutMessageLocal "Argument is improper (${instance_map})" "WARNING"
      return $data_to_be_updated     
    }
    
    # STEP1: update instant_map --> instance_map is originally a list, example --> "native_phy"  "my_super_native_phy" "pll"  "my_super_pll"
    #                               append . to keys hence list will become    --> "native_phy." "my_super_native_phy" "pll." "my_super_pll"
    # everywhere instance links should be in the form of instance.sth but not for INSTANCE_PAIRS field so the caller should set append_dot parameter properly
    set updated_instance_map $instance_map
    if {$append_dot} {
      for {set i 0} {$i < ${INSTANCE_MAP_LENGTH}} {incr i 1} {
        set val [lindex ${instance_map} $i]
        set val "${val}.";#append a dot 
        set updated_instance_map [lreplace $updated_instance_map $i $i $val]
      }
    }
    
    # STEP2: update the instance links in data_to_be_updated
    return [string map ${updated_instance_map} ${data_to_be_updated}]
  }

##################################################################
##################################################################
##################################################################
oo::class create ::alt_xcvr::de_tcl::framework::Logger {
  variable message_threshold
  variable is_error_message_received
  variable log_file_name;
  variable log_file_id;
  
  #\TODO what if log file name is just a directory name!!! 
  constructor { lcl_message_threshold {lcl_log_file_name ""} } { 
    set message_threshold $lcl_message_threshold;
    set log_file_name $lcl_log_file_name
    if { $log_file_name ==""} {
      set log_file_id "stdout"
    } else {
      set log_file_id [open $log_file_name "a"]
    }
    set is_error_message_received 0;
  }

  destructor {  
    if { $log_file_name !=""} {
      close $log_file_id
    }
  }

  method closeLogger {} { 
    if { $log_file_name !=""} {
      close $log_file_id; 
    }
  }
  
  method setDisplayedMessageThreshold  { lcl_message_threshold } {set message_threshold $lcl_message_threshold; }
  method getDisplayedMessageThreshold  {                       } { return $message_threshold;}
  method clearErrorStatus              {                       } {set is_error_message_received 0; }
  method getErrorStatus                {                       } { return $is_error_message_received; }

  method outMessage {str {message_level "INFO"}} {
    if {$message_level == "ERROR"} {
      set is_error_message_received 1;
    }

    if {[my ConvertMessageLevelToInteger $message_threshold] >= [my ConvertMessageLevelToInteger $message_level] } {
      if {[my ConvertMessageLevelToInteger $message_level] == -1} {
        set message_level "UNKNOWN"
      }
      set message_level [my ShortenMessageLevel $message_level]
      my Message_out "\[$message_level\] $str"
    }
  }

  method Message_out {str} { puts  $log_file_id $str; }
  
  method ConvertMessageLevelToInteger {message_level_string} {
    set message_level_string [string toupper $message_level_string]
    return [expr { $message_level_string == "ERROR"       ? 0 :
                   $message_level_string == "WARNING"     ? 1 :
                   $message_level_string == "INFO"        ? 2 :
                   $message_level_string == "DEBUG"       ? 3 :
                   $message_level_string == "DEVELOPMENT" ? 4 :
                                                           -1   }]   
  }
  
  method ShortenMessageLevel {message_level_string} {
    set message_level_string [string toupper $message_level_string]
    return [expr { $message_level_string == "ERROR"       ? "ERRO" :
                   $message_level_string == "WARNING"     ? "WARN" :
                   $message_level_string == "INFO"        ? "INF0" :
                   $message_level_string == "DEBUG"       ? "DEBG" :
                   $message_level_string == "DEVELOPMENT" ? "DEVL" :
                                                            "UNKN"   }]   
  }
  
  method convertQsysScriptMessageLevel {message_level} {
    if {       [string  compare -nocase $message_level "Info"    ] == 0 } {
         return "INFO"
    } elseif { [string  compare -nocase $message_level "Error"   ] == 0 } {
         return "ERROR"
    } elseif { [string  compare -nocase $message_level "Warning" ] == 0 } {
         return "WARNING"
    } elseif { [string  compare -nocase $message_level "Progress"] == 0 } {
         return "INFO"
    } elseif { [string  compare -nocase $message_level "Debug"   ] == 0 } {
         return "DEBUG"
    } else {
         return "INFO"
    }
  }

  
}

##################################################################
##################################################################
##################################################################
oo::class create ::alt_xcvr::de_tcl::framework::DesignExampleFramework {
  variable design_example_logger;
  variable parameters;
  variable instances;
  variable connections;
  variable qsys_script_commands;
  variable main_instance;
  variable instance_pairs;
  variable registered_data;
  variable isQsysPro;
  variable system_dir;
  variable root_dir;
  variable qsys_file_name;
  variable fullpath_qsys_filename;

  constructor {   l_isQsysPro   l_root_dir   l_qsys_file_name   l_log_file_name   l_main_instance   } { 
    set root_dir               ${l_root_dir}
    set qsys_file_name         ${l_qsys_file_name}
    #\TODO system_dir assumption holds check?
    set system_dir             [create_temp_file ""];                                             # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  THIS IS A _HW.TCL CALL  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    set fullpath_log_filename ""
    if { ${l_log_file_name} !=""} {  
       set fullpath_log_filename  [create_temp_file [file join  ${l_root_dir} ${l_log_file_name}]];  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  THIS IS A _HW.TCL CALL  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    }
    set fullpath_qsys_filename [create_temp_file [file join  ${l_root_dir} ${l_qsys_file_name}]]; # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  THIS IS A _HW.TCL CALL  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    set design_example_logger [::alt_xcvr::de_tcl::framework::Logger  new "DEVELOPMENT" ${fullpath_log_filename}]

    set files [glob -nocomplain -directory [file join  ${system_dir} ${l_root_dir} ] *] 
    if {(${fullpath_log_filename} != "" && [lsearch ${files} ${fullpath_log_filename}] == -1) || [lsearch ${files} ${fullpath_qsys_filename}] == -1 } {
      puts "ERROR: Files cannot be created!";#should not happen ever
      puts "ERROR-INFO1: ${files}"
      puts "ERROR-INFO2: [file join  ${system_dir} ${l_root_dir}]"
      puts "ERROR-INFO3: ${fullpath_log_filename}"
      puts "ERROR-INFO4: ${fullpath_qsys_filename}"
      my OutMessageLocal "Files cannot be created!"  "WARNING"
    } elseif { [llength $files] > 2 } {
      my OutMessageLocal "Directory(${l_root_dir}) not empty"  "WARNING"      
    } 

    set parameters     [::alt_xcvr::de_tcl::data::Parameters    new "" [self object]]
    set instances      [::alt_xcvr::de_tcl::data::Instances     new "" [self object]]
    set connections    [::alt_xcvr::de_tcl::data::Connections   new "" [self object]]
    set qsys_script_commands  [list]

    set instance_pairs ""
    set main_instance $l_main_instance
    set registered_data [dict create]
    set isQsysPro ${l_isQsysPro}
  }

  method getQsysPath {} {
    return ${fullpath_qsys_filename}
  } 
  
  method registerData {data_name data_value} {
    dict set registered_data ${data_name} ${data_value};# if exists etc
  } 

  method getRegisteredData {data_name} {
    return [dict get $registered_data $data_name];# what if it does not exists, check it
  }
  
  method getMainInstanceName { } {
    return $main_instance
  }
  
  method setInstancePairs { pairs } {
    set instance_pairs $pairs
  }
  
  method getInstancePairs { } { 
    return $instance_pairs
  }

  method isInstanceExist { reference_name } {
    return [dict exists $instance_pairs $reference_name]
  }

  method getInstanceName { reference_name } {
    if { ![dict exists $instance_pairs $reference_name] } {
      my OutMessageLocal "$reference_name does not exists in dictionary!"  "ERROR"
      return "InstanceDoesNotExist"    
    }
    return [dict get $instance_pairs $reference_name]
  }
  
  method setData { data_type property_type data_value} {
    
    my OutMessageLocal "Set requested ($data_type) ($property_type) ($data_value)."  "DEVELOPMENT" 
    
    #expected data_type structure: something(someotherthing)
    set data_type_updated [my CheckDataTypeFormat ${data_type}]    
    if { ${data_type_updated} == "NOVAL" } {
      return
    }
    
    # EXTREMELY IMPORTANT \TODO: replaceInstanceLinks --> make this part of data!!!!!!!!!!!!!!!!
    # now data_type is a 2 element list --> example "parameter" "native_phy.pll_type" 
    # this is required because originall caller make the call without knowing the system level instance names
    # for example "parameter" "native_phy.pll_type"  might end up being --> "parameter" my_native_phy_instance.pll_type"

    # at this point data_type_updated is of format {something someotherthing}    
    if       { [string toupper [lindex ${data_type_updated} 0]] == "PARAMETER"  } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 1];
      $parameters set [lindex ${data_type_updated} 1] ${property_type} ${data_value};        # \TODO should we check if [lindex ${data_type_updated} 1] is properly formatted instance_name.parameter_name, here??
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "CONNECTION" } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 0];
      $connections set [lindex ${data_type_updated} 1] ${property_type} ${data_value};       # \TODO should we check if [lindex ${data_type_updated} 1] is properly formatted instance_name.interface_name/instance_name.interface_name, here??
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "INSTANCE"   } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 0];
      $instances set [lindex ${data_type_updated} 1] ${property_type} ${data_value};         # \TODO should we check if [lindex ${data_type_updated} 1] is proper?
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "SYSTEM" } {
      my OutMessageLocal "$[string toupper [lindex ${data_type_updated} 0]] is not supported!"  "WARNING" 
    } else {
      my OutMessageLocal "$[string toupper [lindex ${data_type_updated} 0]] is not supported!"  "WARNING" 
    }
  }
  
  method getData { data_type property_type } {  
    
    #expected data_type structure: something(someotherthing)
    set data_type_updated [my CheckDataTypeFormat ${data_type}]    
    if { ${data_type_updated} == "NOVAL" } {
      return "NOVAL"
    }
    
    # at this point data_type_updated is of format {something someotherthing}    
    set return_value "NOVAL"
    if       { [string toupper [lindex ${data_type_updated} 0]] == "PARAMETER"  } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 1];    
      set return_value [$parameters get [lindex ${data_type_updated} 1] ${property_type}];        # \TODO should we check if [lindex ${data_type_updated} 1] is properly formatted instance_name.parameter_name, here??
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "CONNECTION" } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 0];
      set return_value [$connections get [lindex ${data_type_updated} 1] ${property_type}];       # \TODO should we check if [lindex ${data_type_updated} 1] is properly formatted instance_name.interface_name/instance_name.interface_name, here??
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "INSTANCE"   } {
      set data_type_updated [::alt_xcvr::de_tcl::framework::replaceInstanceLinks ${instance_pairs} ${data_type_updated} 0];
      set return_value [$instances get [lindex ${data_type_updated} 1] ${property_type}];         # \TODO should we check if [lindex ${data_type_updated} 1] is proper?
    } elseif { [string toupper [lindex ${data_type_updated} 0]] == "SYSTEM" } {
      my OutMessageLocal "$[string toupper [lindex ${data_type_updated} 0]] is not supported!"  "WARNING" 
    } else {
      my OutMessageLocal "$[string toupper [lindex ${data_type_updated} 0]] is not supported!"  "WARNING" 
    }
    
    return ${return_value}
}

  # expected format example: parameter(native_phy.pll_type)
  method CheckDataTypeFormat { data_type } {
    #expected data_type structure: something(someotherthing)

    # early check #1 make sure input ends with )
    if { [string first ) ${data_type} end] == -1 } {
       my OutMessageLocal "${data_type} is not properly formatted-1!"  "WARNING" 
       return "NOVAL"
    }
     
    set data_type [string range ${data_type} 0 end-1]; # remove the final )
    set data_type [string map {"(" " "} ${data_type}]; # replace ( with " "

    # early check #2 make sure now data_type is a list as {something someotherthing}
    if { [llength ${data_type}] != 2 } {
       my OutMessageLocal "${data_type} is not properly formatted-2!"  "WARNING" 
       return "NOVAL"
    }
    return ${data_type}    
  }  
  
  method ParseQsysScriptMessage {line} {
    set timestamp ""
    set message_level ""
    if {[regexp -nocase {(\d{4}\.\d{2}\.\d{2}\.\d{2}:\d{2}:\d{2} )(Info|Error|Warning|Progress|Debug):*} $line -> timestamp message_level]} {
      set message_level [$design_example_logger convertQsysScriptMessageLevel $message_level]     
    } else {
      set message_level "INFO"    
    }
     
    return [list $line $message_level]
  }
  
  method getErrorStatus { } {
     return [$design_example_logger getErrorStatus]
  }

  method closeLogger { } {
     $design_example_logger closeLogger
  }
 
  method convertToQsys { device_family device qsys_search_path} {
    my OutMessageLocal "Started!" "INFO"
    
    set qsys_project_settings ""
    set project_setting ""
    set project_setting [linsert ${project_setting} ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_NAME}   DEVICE_FAMILY]
    set project_setting [linsert ${project_setting} ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_VALUE}  ${device_family}]
    set qsys_project_settings [linsert ${qsys_project_settings} end ${project_setting}]
    set project_setting ""
    set project_setting [linsert ${project_setting} ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_NAME}   DEVICE]
    set project_setting [linsert ${project_setting} ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PROJ_SETTING_VALUE}  ${device}]
    set qsys_project_settings [linsert ${qsys_project_settings} end ${project_setting}]

    set qsys_command ""
    set qsys_command "${qsys_command} set qsys_project_settings  [list ${qsys_project_settings}];" 
    set qsys_command "${qsys_command} set qsys_instances         [list [$instances   getQsysScriptReadyInstances]];"      
    set qsys_command "${qsys_command} set qsys_parameters        [list [$parameters  getQsysScriptReadyParameters]];"
    set qsys_command "${qsys_command} set qsys_connections       [list [$connections getQsysScriptReadyConnections]];"   
    set qsys_command "${qsys_command} set qsys_script_commands   [list ${qsys_script_commands}];"   
    #----------------------------------------------------    
    set qsys_command "${qsys_command} set qsys_filename \"${fullpath_qsys_filename}\";"
      
    set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set qsys_script_path "$::env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages/de_tcl/qsys_conversion.tcl"
           
    #\TODO linux vs WINDOWS!!! modify single quotes
    #\TODO for now create a new quartus project with the same name of the qsys project. Later we might get the project name from user
    set fullpath_project_filename  [file join  ${system_dir} ${root_dir} "[lindex [split ${qsys_file_name} "\\."] 0 ].qpf" ];
    set cmd [concat [list exec $qsys_script_exe_path [expr {${isQsysPro} ? "--pro": "" }] --script=$qsys_script_path --cmd=$qsys_command --search-path=${qsys_search_path} [expr {${isQsysPro} ? "--new-quartus-project=${fullpath_project_filename}": "" }]]]
    set cmd_fail [catch { eval $cmd } tempresult]

    set tempresult [split $tempresult "\n"]
    foreach line $tempresult {
      set parsed_line [my ParseQsysScriptMessage $line]
      my OutMessageLocal [lindex $parsed_line 0] [lindex $parsed_line 1]      
    }

    set filelist [dict create]
    foreach fullpath_filename [my GetListofFilesInDirectory [file join  ${system_dir} ${root_dir} ]] {
        dict set filelist ${fullpath_filename} "."
    } 
    if { ${isQsysPro} } {
       set temp_split [split ${qsys_file_name} "\\."]
       if { [llength $temp_split] == 2 } {
          set ip_dir  [file join "ip" [lindex $temp_split 0]]
       } else {
          set ip_dir  [file join "ip" ${qsys_file_name}]
          my OutMessageLocal "Qsys file name seems unexpected (${qsys_file_name}) - most likely things will fail" "WARNING"
       }
       foreach fullpath_filename [my GetListofFilesInDirectory [file join  ${system_dir} ${root_dir} ${ip_dir}]] {
          dict set filelist ${fullpath_filename} ${ip_dir}
       } 
    }

    return ${filelist}
  }  

  #\TODO in future could be a utility function
  method GetListofFilesInDirectory { dir } {
    set files_folders [glob -nocomplain -directory ${dir} *]
    set folders       [glob -nocomplain -directory ${dir} -type d *]
    set temp ""
    foreach file_folder $files_folders {
      if {[lsearch $folders $file_folder]<0} {
        set temp [linsert $temp end $file_folder]
      }
    }
    return $temp
  }
  
  method declareRules { subrule_properties_table } {
    set subrules [my ConvertToRulesDictionary $subrule_properties_table]
    $subrules resolveInstanceLinks $instance_pairs
    $subrules resolveProperties
    $subrules declareSubrules    
    $subrules destroy   
  }
  
  method declareInstances {instance_properties_table } {    
    set temp [my ConvertToInstancesDictionary $instance_properties_table]
    $temp resolveInstanceLinks $instance_pairs
    $temp resolveProperties
    $instances add $temp    
    $temp destroy
  } 

  method declareParameters { parameter_properties_table } {   
    set temp [my ConvertToParametersDictionary $parameter_properties_table]
    $temp resolveInstanceLinks $instance_pairs  
    $temp resolveProperties
    $parameters add $temp    
    $temp destroy
  } 

  method declareConnections { connection_properties_table } {
    set temp [my ConvertToConnectionsDictionary $connection_properties_table]
    $temp resolveInstanceLinks $instance_pairs
    $temp resolveProperties   
    $connections add $temp;
    oo::objdefine $temp {mixin ::alt_xcvr::de_tcl::data::ConnectionUtilities}
    $temp executeExpandCallbacks
    #$connections add $temp;
    $temp destroy  
  } 

  method declareQsysScriptCommands { commands } {
    foreach command $commands {
      set qsys_script_commands [linsert ${qsys_script_commands} end  ${command} ]
    }
  }

  method outMessage {str {lvl "INFO"}} {
    $design_example_logger outMessage $str $lvl
  }
  
  # this is to append the message with message source information withing framework context
  method OutMessageLocal { str lvl } {
    set msg_source "([self object])([self class])([self caller])"
    set str [format "%-100s" $str]
    my outMessage "${str} \[Message source: ${msg_source}\]" $lvl
  }
  
  method ConvertToRulesDictionary {properties_table} {
    return [::alt_xcvr::de_tcl::data::Subrules new [my ConvertTable2Dict $properties_table] [self object]]
  }
  
  method ConvertToInstancesDictionary {properties_table} {
    return [::alt_xcvr::de_tcl::data::Instances new [my ConvertTable2Dict $properties_table] [self object]]
  }
  
  method ConvertToParametersDictionary {properties_table} {
    return [::alt_xcvr::de_tcl::data::Parameters new [my ConvertTable2Dict $properties_table] [self object]]
  }
  
  method ConvertToConnectionsDictionary {properties_table} {
    return [::alt_xcvr::de_tcl::data::Connections new [my ConvertTable2Dict $properties_table] [self object]]
  }
  
  method DeclareCommon {properties_table instance_map} {
    my OutMessageLocal "Started!" "DEVELOPMENT"    
   # return [my ResolveSymbolikInstanceLinks [my ConvertTable2Dict $properties_table] $instance_map]    
  }
  
  method ConvertTable2Dict { table } {
    my OutMessageLocal "Started!" "DEVELOPMENT"
    set this_dict [dict create]
    set headers [string toupper [lindex $table 0] ] 
    set length [llength $table]
    set nameindex [lsearch $headers NAME]
    for {set i 1} {$i < $length} {incr i} {
      set this_entry [lindex $table $i]
      set key [lindex $this_entry $nameindex]
      for {set j 0} {$j < [llength $this_entry]} {incr j} {
        dict set this_dict $key [lindex $headers $j] [lindex $this_entry $j]
      }
    }
    return $this_dict
  }  
 
};#class
##################################################################
##################################################################
##################################################################
