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



package provide alt_xcvr::de_tcl::data 18.1

package require alt_xcvr::de_tcl::framework
package require alt_xcvr::de_tcl::DE_TCL_CONSTANTS

namespace eval ::alt_xcvr::de_tcl::data:: {
  
  namespace export \
        DesignExampleFramework2DDict  \
        Parameters \
        Instances \
        Connections \
        Subrules \
        ConnectionUtilities
}

##################################################################

oo::class create ::alt_xcvr::de_tcl::data::DesignExampleFramework2DDict {
  variable resolved_data;
  variable LIST_OF_PROPERTIES_NOT_TO_BE_OVERWRITEN
  variable LIST_OF_RESOLVABLE_PROPERTIES
  variable LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITH_DOT
  variable LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITHOUT_DOT
  variable ref_to_framework
  
  constructor { data list_of_properties_not_to_be_overwriten l_ref_to_framework} {
    set resolved_data $data;#assumed 2D dictionary
    set LIST_OF_PROPERTIES_NOT_TO_BE_OVERWRITEN $list_of_properties_not_to_be_overwriten
    set LIST_OF_RESOLVABLE_PROPERTIES "";#default is nothing which means the data-field has a direct/usable value from the start
    set LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITH_DOT ""
    set LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITHOUT_DOT ""
    set ref_to_framework $l_ref_to_framework
  }
  
  method setListOfResolvableProperties { list_of_resolvable_properties } {
    set LIST_OF_RESOLVABLE_PROPERTIES ${list_of_resolvable_properties}
  }
  
  method getListOfResolvableProperties { } {
    return ${LIST_OF_RESOLVABLE_PROPERTIES}
  }
  
  method setListOfPropertiesRequiringReplaceWithDot {list_of_properties_requiring_replace_with_dot} {
    set LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITH_DOT $list_of_properties_requiring_replace_with_dot 
  }

  method setListOfPropertiesRequiringReplaceWithoutDot {list_of_properties_requiring_replace_without_dot} {
    set LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITHOUT_DOT $list_of_properties_requiring_replace_without_dot 
  }


  # \TODO *info* message --> dont exists 
  method set {name prop value} {
    set prop [string toupper $prop]
    dict set resolved_data $name $prop $value
  }
  
  method get {name prop} {
    my outMessage "Requested ${prop} of ${name}" "DEVELOPMENT"
    set prop [string toupper $prop]
    if {[dict exist $resolved_data $name $prop]} {
      return [dict get $resolved_data $name $prop]
    } else {
      my outMessage "${prop} of ${name} does not exist" "WARNING"
      return "NOVAL"
    }
  }
  
  #breaks the encapsulation but too far in development!!!
  method getData {} {
    return $resolved_data
  }
  
  method outMessage { str lvl } {
    set msg_source "([self object])([self class])([self caller])"
    set str [format "%-100s" $str]
    $ref_to_framework outMessage "${str} \[Message source: ${msg_source}\]" $lvl
  }
  
  #\TODO check if or if/else!!!
  method resolveInstanceLinks { instance_map } {

    if {[lsearch $LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITH_DOT "NAME"] != -1} {
      set resolved_data [ dict map {key val} $resolved_data {
                            set key [::alt_xcvr::de_tcl::framework::replaceInstanceLinks  ${instance_map} ${key} 1]
                            set val $val } ]    
    } 
    if {[lsearch $LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITHOUT_DOT "NAME"] != -1} {
       set resolved_data [ dict map {key val} $resolved_data {
                            set key [::alt_xcvr::de_tcl::framework::replaceInstanceLinks  ${instance_map} ${key} 0]
                            set val $val } ]
    }

    dict for {key value} $resolved_data {
      dict for {property_name property_value} $value {
        if {[lsearch $LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITH_DOT $property_name] != -1} {
          dict set resolved_data $key $property_name [::alt_xcvr::de_tcl::framework::replaceInstanceLinks  ${instance_map} ${property_value} 1];          # replace dotty
        } 
        if {[lsearch $LIST_OF_PROPERTIES_REQUIRING_REPLACE_WITHOUT_DOT $property_name] != -1} {
          dict set resolved_data $key $property_name [::alt_xcvr::de_tcl::framework::replaceInstanceLinks  ${instance_map} ${property_value} 0];          # replace dottless
        }
      }
    }  
    
  }
  
  method add {data} {
    #data assumed to be an object of class DesignExampleFramework2DDict
    set properties_dict_2D [$data getData]
    dict for {name properties} $properties_dict_2D {
      if {![dict exists $resolved_data $name]} {
        # this entry does not exist yet --> simply add to dictionary
        dict append resolved_data $name $properties
      } else {
        # this entry does exist --> need to merge
        # all dicts below is defined per $name in the loop
        set existing_properties_all [dict get $resolved_data $name]
        set incoming_properties_all $properties
        set existing_properties_with_values_NOVAL     [my GetSubDictionaryEntriesWithNOVALOnly    $existing_properties_all]
        set incoming_properties_with_values_NOVAL     [my GetSubDictionaryEntriesWithNOVALOnly    $incoming_properties_all]
        set existing_properties_without_values_NOVAL  [my GetSubDictionaryEntriesWithNOVALRemoved $existing_properties_all]
        set incoming_properties_without_values_NOVAL  [my GetSubDictionaryEntriesWithNOVALRemoved $incoming_properties_all]
        
        # 1. see if any properties belong to the dont-overwrite list
        set existing_properties_with_notto_overwrite_keys_and_without_values_NOVAL [dict create]
        foreach property_notto_overwrite $LIST_OF_PROPERTIES_NOT_TO_BE_OVERWRITEN {
          if { [dict exists $existing_properties_all $property_notto_overwrite] } { 
            if { [dict get $existing_properties_all $property_notto_overwrite] != "NOVAL"} {
              dict set existing_properties_with_notto_overwrite_keys_and_without_values_NOVAL $name $property_notto_overwrite [dict get $existing_properties_all $property_notto_overwrite]
              if {[dict exists $incoming_properties_all $property_notto_overwrite]} {
                if { [dict get $incoming_properties_all $property_notto_overwrite] != "NOVAL"} {
                  my outMessage "Value([dict get $incoming_properties_all $property_notto_overwrite]) for $property_notto_overwrite will be ignored, since it already set" "WARNING"
                }
              }
            }
          } 
        }
        
        # 2. combine all properties, the order matters!!! from left to right, new decitionary overwrites the existing fields        
        set combined_properties   [dict merge $existing_properties_with_values_NOVAL \
                                              $incoming_properties_with_values_NOVAL \
                                              $existing_properties_without_values_NOVAL \
                                              $incoming_properties_without_values_NOVAL \
                                              $existing_properties_with_notto_overwrite_keys_and_without_values_NOVAL \
                                  ]
        dict set resolved_data $name $combined_properties; # FINALLY UPDATED THE resolved_data
      }
    }        
  }
  
  method resolveProperties {} {
    foreach property $LIST_OF_RESOLVABLE_PROPERTIES {
      my ResolveProperty $property
    }
  }
  
  method ResolveProperty { property } {
    my outMessage "Started!" "DEVELOPMENT"
    set property [string toupper $property]
    
#    # early check 1
#    set list_of_resolvable_properties [list "VALUE" "KIND" "ENABLED" "ADAPT_CONNECTION" "SPLIT_CONNECTION"]
#    if {[lsearch $list_of_resolvable_properties $property] == -1} {
#      my outMessage "${property} is not a resolvable property!" "WARNING"
#      return
#    }

    # early check 2
    if {![my PropertyExists $resolved_data  ${property}] && \
        ![my PropertyExists $resolved_data "${property}_RESOLVE_CALLBACK"]  && \
        ![my PropertyExists $resolved_data "${property}_MAPS_FROM"] } {
      my outMessage "Cannot resolve, ${property} does not exists in dictionary!" "WARNING"
      return
    }
    
    dict for {name properties} $resolved_data {
      set propertyType [my GetPropertyType ${properties} ${property}]
      if       {$propertyType == "SIMPLE"}     {; # this means nothing to resolve 
        my outMessage "${name}'s ${property} property has a direct value of [dict get ${properties} ${property}]" "DEVELOPMENT"
      } elseif {$propertyType == "OVERLOADED"} {      
        my outMessage "${name}'s ${property} property is overloaded" "DEVELOPMENT"
        dict set resolved_data $name $property [my ResolveOverloadedProperty  [dict get ${properties} ${property}]]
      } elseif {$propertyType == "CALLBACK"}   {
        my outMessage "${name}'s ${property} property depends on a callback" "DEVELOPMENT"
        set callback [dict get ${properties} "${property}_RESOLVE_CALLBACK"]
        set return_value [$callback]     
        dict set resolved_data $name $property $return_value
      } elseif {$propertyType == "MAPPING"}    {
        my outMessage "${name}'s ${property} property depends on a mapping" "DEVELOPMENT"
        set maps_from [dict get ${properties} "${property}_MAPS_FROM"]
        set map_default [expr { [lsearch [dict keys ${properties}] "${property}_MAP_DEFAULT" ] == -1 ? "NOVAL" : [dict get ${properties} "${property}_MAP_DEFAULT"] } ]
        set mapping     [expr { [lsearch [dict keys ${properties}] "${property}_MAPPING"     ] == -1 ? ""      : [dict get ${properties} "${property}_MAPPING"    ] } ]
        set source_value [$ref_to_framework getData "parameter(${maps_from})" VALUE]
        dict set resolved_data $name $property [my GetMappedValue $source_value $map_default $mapping]
      } else {
        my outMessage "Dont know how to resolve ${name}'s ${property} property!" "WARNING"
      }
    }  
  }
  
  # assumes 2D dict
  method PropertyExists {properties_dict property} {
    set property [string toupper $property]
    foreach sub_dict [dict values $properties_dict] {
      if { [dict exists $sub_dict $property] } {
        return 1
      }
    }
    return 0
  }
  
  # assumes 1D dict
  method GetPropertyType { properties_dict property} {
    if { [dict exists ${properties_dict} ${property}] } {      
      if { [string first ## [dict get ${properties_dict} ${property}] ] == 0 } {
        return "OVERLOADED"
      } else {
        return "SIMPLE"
      }
    } else {
      if { [dict exists ${properties_dict} "${property}_RESOLVE_CALLBACK"] } {
        return "CALLBACK"
      }
      if { [dict exists ${properties_dict} "${property}_MAPS_FROM"] } {
        return "MAPPING"
      }
    }
    return "UNKOWN"
  }
  
  method ResolveOverloadedProperty { property_value } {
    set return_value  $property_value
    if { [string first ## $property_value ] != 0 } {
      my outMessage "property value ($property_value) is not overloaded!" "ERROR"
      return $return_value
    }    
    
    regsub -all {##} $property_value "" property_value;#strip off all ##s now it is in a dictionary form

    # MAPPING
    if {[lsearch [dict keys $property_value] MAPS_FROM] != -1 } {
      set maps_from [dict get $property_value MAPS_FROM]
      set map_default [expr { [lsearch [dict keys $property_value] MAP_DEFAULT ] == -1 ? "NOVAL" : [dict get $property_value MAP_DEFAULT] } ]
      set mapping     [expr { [lsearch [dict keys $property_value] MAPPING     ] == -1 ? ""      : [dict get $property_value MAPPING    ] } ]
      set source_value [$ref_to_framework getData "parameter(${maps_from})" VALUE]
      set return_value [my GetMappedValue $source_value $map_default $mapping]
      my outMessage "Property overloaded with mapping: mapped from ($maps_from), source value ($source_value), map result ($return_value)." "DEVELOPMENT"

    # CALLBACK
    } elseif  {[lsearch [dict keys $property_value] RESOLVE_CALLBACK] != -1} {
      set callback [dict get $property_value RESOLVE_CALLBACK]
      set return_value [$callback]     
      my outMessage "Property overloaded with resolve callback ($callback)." "DEVELOPMENT"
   
    # EXPRESSION
    } elseif  {[lsearch [dict keys $property_value] EXPRESSION] != -1} {
      set expression [dict get $property_value EXPRESSION]
      set return_value [my ResolveExpression $expression]
      my outMessage "Property overloaded with expression ($expression), which evaluates as ${return_value}." "DEVELOPMENT"
  
    # UNKNOWN
    } else {
      my outMessage "property value ($property_value) does not define a proper overloading!" "ERROR"
    }
    
   return $return_value
  }
  
  method GetMappedValue { source_value map_default mapping } {
    # mapping elements are supposed to be deliminated with (...) (...) ...
    # first remove those
    set mapping [split $mapping "()"]
    set temp ""
    foreach elem $mapping {;#previous split can create empty elements, now remove those
      if [string length [string map {" " ""} $elem]] {; #if all white spaces removed from the element and the length is 0 this means the element was empty
        set temp [linsert $temp end $elem]
      }
    }
    set mapping $temp

    # search each mapping element and see if source value matches anything, then return
    foreach elem $mapping {
      set elem [split $elem ":"]
      if {[lindex $elem 0] == $source_value} {    
        return [lindex $elem 1]
      }  
    }
  
    # if no map found return default value or source value
    if {[string toupper $map_default] != "NOVAL"} {
      return $map_default
    } else {
      return $source_value
    }
  }
  
  # \TODO: add comments
  method ResolveExpression { expression } {
    #set expression "((a.b==c.d)&&(f.g) || !(d.e)) && (h.j >= 0)&& (k.l <= 10) && (m.n <= 0)"
    regsub -all {[!~|&+-]} $expression " " new_expr
    regsub -all {[*/%<>=]} $new_expr " " new_expr
    regsub -all {[()]} $new_expr " " new_expr
    set new_expr [join $new_expr " "]
 
    set arglist [split $new_expr " "]
    if {[llength $arglist] > 1} {
      set arglist [lsort -decreasing $arglist]
    }

    # Replace args with tags
    set index 0
    foreach arg $arglist {
      if { ![string is integer -strict $arg] } {;#add float check as well
        set tag "tagtag${index}tagtag"
        regsub -all $arg $expression $tag expression
      }
      incr index
    }

    # Replace tags with calls
    set index 0
    foreach arg $arglist {
      if { ![string is integer -strict $arg] } {
        set tag "tagtag${index}tagtag"
        regsub -all $tag $expression "\[my GetParVal ${arg}\]" expression
      }
      incr index
    }
    
    set val [expr ${expression}]      
    return $val
  }
  
  #/TODO TODO fix this!!! what is this ??? comments?? 
  #change this, commonize!!!
  method GetParVal {arg} {
    my outMessage "Requested value of ${arg}" "DEVELOPMENT"
    if {![string match "*.*" $arg]} {;#no-dots// TODO: this is doene for equality expression but this is most likely not the correct place to do this ;;also split is better to make sure the dot is in the middle and there is only one dot!!!!!
      set val $arg 
    } else {
      #set val [get_item_property ${resolved_parameters} ${arg} VALUE]
      set val [$ref_to_framework getData "parameter(${arg})" VALUE];#\todo should the root getter capitalize VALUE \todo finalize how parameters should work 
    }    
    my outMessage "Returning value:${val}" "DEVELOPMENT"
    return $val
  }
  
  method GetSubDictionaryEntriesWithNOVALRemoved { data } {
    return  [dict filter $data value NOVAL]
  }
  
  method GetSubDictionaryEntriesWithNOVALOnly { data } {
    set novalRemoved [my GetSubDictionaryEntriesWithNOVALRemoved $data]
    return [dict remove $data {*}[dict keys $novalRemoved]];# this will leave us with NOVALs only
  }
  
}

##################################################################
##################################################################
##################################################################
##################################################################
##################################################################
##  SPECIALIZATIONS


oo::class create ::alt_xcvr::de_tcl::data::Parameters {
  superclass ::alt_xcvr::de_tcl::data::DesignExampleFramework2DDict;
  
  constructor { data l_ref_to_framework } {
    next $data "" $l_ref_to_framework
    my setListOfResolvableProperties [list VALUE ENABLED]
    my setListOfPropertiesRequiringReplaceWithDot [list VALUE ENABLED NAME]
    my setListOfPropertiesRequiringReplaceWithoutDot ""
  }

  method getQsysScriptReadyParameters {} {
    my variable resolved_data
    
    set qsys_parameters ""
    dict for {name props} $resolved_data {
      dict with props {
        if {$ENABLED} {
          set splitted [split $NAME "."];#\TODO make sure length is 2, \TODO check if $NAME and $VALUE exists also in other getQsysScriptReady... functions
          set parameter_info [list]
          set parameter_info [linsert $parameter_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_INSTANCE_NAME}   [lindex $splitted 0] ]
          set parameter_info [linsert $parameter_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_PARAMETER_NAME}  [lindex $splitted 1] ]
          set parameter_info [linsert $parameter_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_PARAM_PARAMETER_VALUE} $VALUE               ]
          set qsys_parameters [linsert $qsys_parameters end $parameter_info]
        }
      }
    }
    return $qsys_parameters
  }
} 

##################################################################
oo::class create ::alt_xcvr::de_tcl::data::Instances {
  superclass ::alt_xcvr::de_tcl::data::DesignExampleFramework2DDict;
  
  constructor {data l_ref_to_framework } {
    next $data "KIND" $l_ref_to_framework
    my setListOfResolvableProperties [list KIND ENABLED]
    my setListOfPropertiesRequiringReplaceWithDot [list KIND ENABLED]
    my setListOfPropertiesRequiringReplaceWithoutDot [list NAME KIND]
  }
  
  method getQsysScriptReadyInstances {} {
    my variable resolved_data
    
    set qsys_instances ""
    dict for {name props} $resolved_data {
      dict with props {
        if {$ENABLED} {
          set instance_info [list]
          set instance_info [linsert $instance_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_INSTANCE_NAME} $NAME]
          set instance_info [linsert $instance_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_INSTANCE_TYPE} $KIND]
          set qsys_instances [linsert $qsys_instances end $instance_info]
        }
      }
    }
    return $qsys_instances
  }
}

##################################################################
oo::class create ::alt_xcvr::de_tcl::data::Connections {
  superclass ::alt_xcvr::de_tcl::data::DesignExampleFramework2DDict;
  
  constructor {data l_ref_to_framework } {
    next $data "" $l_ref_to_framework
    my setListOfResolvableProperties [list ENABLED ADAPT_CONNECTION SPLIT_CONNECTION]
    my setListOfPropertiesRequiringReplaceWithDot [list ENABLED ADAPT_CONNECTION SPLIT_CONNECTION NAME]
    my setListOfPropertiesRequiringReplaceWithoutDot "NAME"
  }
  
  method getQsysScriptReadyConnections {} {
    my variable resolved_data
    
    set qsys_connections ""
    dict for {name props} $resolved_data {
      dict with props {
        if {$ENABLED} {          
          set connection_info [list]
          set connection_info [linsert $connection_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_NAME}  $NAME]
          set connection_info [linsert $connection_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_SPLIT} [expr {[dict exists $props SPLIT_CONNECTION]?$SPLIT_CONNECTION:1}]]
          set connection_info [linsert $connection_info ${::alt_xcvr::de_tcl::DE_TCL_CONSTANTS::INDEX_OF_CONNECTION_ADAPT} [expr {[dict exists $props ADAPT_CONNECTION]?$ADAPT_CONNECTION:1}]]
          set qsys_connections [linsert $qsys_connections end $connection_info]
        } else {
          my outMessage "Connection(${NAME}) is not enabled(${ENABLED})." "DEVELOPMENT"
        }
      }
    } 
    return $qsys_connections
  }
}

##################################################################
oo::class create ::alt_xcvr::de_tcl::data::Subrules {
  superclass ::alt_xcvr::de_tcl::data::DesignExampleFramework2DDict;
  
  constructor { data l_ref_to_framework } {
    next $data "" $l_ref_to_framework
    my setListOfResolvableProperties [list ENABLED]
    my setListOfPropertiesRequiringReplaceWithDot [list ENABLED]
    my setListOfPropertiesRequiringReplaceWithoutDot ""
  }
  
  #override
  method resolveInstanceLinks { instance_map } {  
    my variable resolved_data
    
    next $instance_map  
   
    dict for {key value} $resolved_data {
      dict for {property_name property_value} $value {
        if {$property_name == "INSTANCE_PAIRS"} {
          # if field is INSTANCE_PAIRS SPECIAL MODIFICATION --> replace instance links only at even indexed elements
          set LENGTH_OF_LIST [llength $property_value]
          if { [expr { ${LENGTH_OF_LIST} % 2 != 0 } ] } {
            my outMessage "Does not make sense!" "WARNING";#keep the field as it is, this is not expected
          } else {
            set property_value_updated $property_value
            for {set i 1} {$i < ${LENGTH_OF_LIST}} {incr i 2} {
              set ithElement [lindex $property_value $i]
              set property_value_updated [lreplace ${property_value_updated} $i $i [::alt_xcvr::de_tcl::framework::replaceInstanceLinks  ${instance_map} ${ithElement} 0] ]
            } 
            dict set resolved_data $key $property_name ${property_value_updated}
          }        
        }        
      }
    }
    
  }
  
  method declareSubrules { } {
    my variable resolved_data
    my variable ref_to_framework
    
    dict for {name props} $resolved_data {
      dict with props {
        if {$ENABLED} {
          set cached_instance_pairs [$ref_to_framework getInstancePairs]
          $ref_to_framework setInstancePairs $INSTANCE_PAIRS
          ${RULE_TYPE}::declare_rule
          $ref_to_framework setInstancePairs $cached_instance_pairs
        }
      }
    }  
  }
}
              
################################################################## 
oo::class create ::alt_xcvr::de_tcl::data::ConnectionUtilities {;#use as an mixin \TODO why??? --> There is a specific moment the function --> executeExpandCallbacks should be called. so caller needs to add the mixin first
##\TODO hard coding here !!! for native PHY needs to be changed  ==> channels, split_interfaces
 
  method executeExpandCallbacks { } {
    my variable resolved_data
    
    dict for {name props} $resolved_data {
      dict with props {
        if { [dict exists $props EXPAND_CALLBACK] } {
          if { [string toupper $EXPAND_CALLBACK] != "NOVAL" } {
            set EXPAND_CALLBACK_ARGUMENTS [info args $EXPAND_CALLBACK]
            if { [llength $EXPAND_CALLBACK_ARGUMENTS] == 0 } {
              set val [eval $EXPAND_CALLBACK]; # no return expected but maybe for future \TODO get fancy in future pass some info regarding the PROP_M staff??              
            } elseif { [llength $EXPAND_CALLBACK_ARGUMENTS] == 1 && [string toupper [lindex $EXPAND_CALLBACK_ARGUMENTS 0]] == "CONNECTION_NAME" } {
              set val [eval $EXPAND_CALLBACK $NAME];
            } else {
              ::alt_xcvr::de_tcl::de_api::de_sendMessage "Do not know how to call the callback ($EXPAND_CALLBACK) with arguments ($EXPAND_CALLBACK_ARGUMENTS)" "WARNING" 
            }
          }
        }
      }
    }  
  }
}
