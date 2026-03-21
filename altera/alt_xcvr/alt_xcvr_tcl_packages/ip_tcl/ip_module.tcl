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



package provide alt_xcvr::ip_tcl::ip_module 13.0

package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::common

namespace eval ::alt_xcvr::ip_tcl::ip_module:: {
  namespace export \
    ip_set_debug \
    ip_declare_module \
    ip_declare_display_items \
    ip_declare_parameters \
    ip_declare_interfaces \
    ip_declare_filesets \
    ip_validate_parameters \
    ip_validate_display_items \
    ip_elaborate_interfaces \
    ip_upgrade \
    ip_add \
    ip_set \
    ip_get \
    ip_get_matching_parameters \
    ip_add_user_property_type \
    ip_parse_csv \
    ip_get_csv_variable \
    ip_set_standalone_mode \
    ip_set_iface_split_suffix \
    ip_set_property_byParameterIndex \
    ip_set_property_byParameterName \
    ip_set_auto_conduit_in_native_mode \
    ip_declare_parameter_dependencies \
    ip_rapid_validate_parameters \
    ip_log_invalid_parameter \
    ip_log_parameter \
    ip_declare_all_time_validated_parameters \
    ip_get_userSettableParameters

  variable debug 1
  variable state
  variable alist
  variable alength
  variable i_parameters
  variable i_standalone_parameters
  variable i_interfaces
  variable i_display_items
  variable validated_stack
  variable dynamic_elab "NOVAL"
  variable lasttime 0
  variable port_ignore_list
  variable param_ignore_list
  variable param_bool_list
  variable user_property_type_dict
  variable csv_data
  variable standalone
  variable split_suffix
  variable auto_conduit_in_native_mode

  variable system_info_parameters  
  variable non_derived_parameters  
  variable all_time_validated_parameters
  variable static_all_time_validated_parameters
  variable invalid_parameters_cache
  variable parameter_cache_name  
  variable all_time_validated_parameter_cache_name
  variable invalid_parameter_cache_name
    
  set port_ignore_list {NAME ROLE SPLIT SPLIT_COUNT SPLIT_WIDTH IFACE_NAME IFACE_TYPE IFACE_DIRECTION DYNAMIC ELABORATION_CALLBACK UI_DIRECTION}
  set param_ignore_list {NAME TYPE VALIDATION_CALLBACK}
  set param_bool_list {ENABLED VISIBLE}
  set i_parameters [dict create]
  set i_interfaces [dict create]
  set i_standalone_parameters [dict create]
  set user_property_type_dict [dict create]
  set csv_data [dict create]    
  set standalone 0
  set split_suffix ""
  set state "DECLARE"
  set auto_conduit_in_native_mode 0
}

###
# Enable debug statements
# @param val - 0-disable debug statements, 1-enable
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_debug { val } {
  variable debug
  if { $val != 0 } {
    set val 1
  }

  set debug $val
}

##
# Registers the type of user defined property so that user defined property can accept boolean/integer expressions
# @param user_property_name 
# @param property_type - integer/boolean
proc ::alt_xcvr::ip_tcl::ip_module::ip_add_user_property_type { user_property_name property_type} {
  variable user_property_type_dict
  dict set user_property_type_dict $user_property_name TYPE $property_type
}


##
# Set standalone mode. In this mode no calls to the underlying QSYS "_hw.tcl" package are made. All data is maintained internally.
# @param enable - 0=Disable standalone mode, 1=Enable standalone mode
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_standalone_mode { enable } {
  variable standalone
  variable i_parameters

  if { $enable != 0 && $enable != 1 } {
    error "\[ip_set_standalone_mode\] Invalid value \"${enable}\" for argument \"enable.\""
    return
  }
  
  # whenever there is a request to set/reset standalone_mode, refresh the parameters and properties
  # this is necessary for the systems with multiple Native phy instances. see case:298097 for details.  
  set standalone 0;                                # this will make sure that subsequent calls to ip_get will get the values from _hw.tcl
  set params [ip_get_matching_parameters ""]
  foreach param $params {
    ip_get "parameter.${param}.value";             # refreshing the parameter values
    set props [dict get $i_parameters $param]
    dict for {prop val} $props {
      if {$prop != "VALIDATED" && $prop != "DISPLAY_ITEM"} {
        ip_get "parameter.${param}.$prop";         # refreshing the parameter properties        
      }
    }
  }
  
  set standalone $enable  
}


##
# The IPUTF "_hw.tcl" framework does some rather ridiculous things. Some IP cores have interfaces
# that must be presented as buses in "native" or "standalone IP" mode. This does not work with
# QSys for clock, reset, or avmm interfaces. Setting this option will instruct the "IP TCL"
# framework to automatically declare all interfaces as conduits. If enabled, any interfaces that
# are not naturally conduits must:
# 1) Be declared dynamically
# 2) Must not set interface properties not consistent with conduit interfaces.
#
# @param enable - 0=disable auto declaration of conduit interfaces. 1=enable auto-declaration
# of conduit interfaces
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_auto_conduit_in_native_mode { enable } {
  variable auto_conduit_in_native_mode

  if { $enable != 0 && $enable != 1 } {
    error "\[ip_set_auto_conduit_in_native_mode\] Invalid value \"${enable}\" for argument \"enable.\""
    return
  }

  set auto_conduit_in_native_mode $enable
}


###
# Set the "split_suffix" to be used when automatically splitting interfaces
# @param suffix - The new suffix to be used for interface splitting.
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_iface_split_suffix { suffix } {
  variable split_suffix
  set split_suffix $suffix
}


###
# Declare a module and its properties
# @param module - A nested list of module properties
proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_module { module } {
  
  state_check "DECLARE" ip_declare_module

  #dprint "\[ip_declare_module\] module:${module}"
  # First sublist to contain headers
  set length [llength [lindex $module 0]]
  for {set i 0} {$i < $length} {incr i} {
    set name [lindex [lindex $module 0] $i]
    set val [lindex [lindex $module 1] $i]
   #dprint "\[ip_declare_module\] name:${name} val:${val}"
    if { $val != "NOVAL"} {
      ip_set "module.${name}" [lindex [lindex $module 1] $i]
    }
  }
}

###
# Declare a module's display items
# @param display_items - A nested list of display items
proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_display_items { display_items } {
  variable i_display_items

  state_check "DECLARE" ip_declare_display_items

  set display_items [convert_data_to_dict $display_items]

  #dprint "\[ip_declare_display_items\] display_items:${display_items}"
  # First sublist to contain headers
  dict for {name props} $display_items {
    set type [get_item_property $display_items $name TYPE]
    set group [get_item_property $display_items $name GROUP]
    set args [get_item_property $display_items $name ARGS]

    if { $group == "NOVAL" } {
      set group ""
    }
    if { $args == "NOVAL" } {
      set args {}
    }
    set command "ip_add \"display_item.${group}.${name}\" ${type}"

    foreach arg $args {
      set command "${command} \"${arg}\""
    }
    #dprint "\[ip_declare_display_items\] evaluating: $command -"
    eval $command

    # Add items to dictionary for later usage
    dict for {prop val} $props {
      if {[get_item_property $display_items $name $prop] != "NOVAL"} {
        dict set i_display_items $name $prop $val
      }
    }
  }

}

###
# Declare a module's parameters
# @param parameters - A nested list of parameters and their properties.
proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_parameters { parameters } {
  variable i_parameters

  state_check "DECLARE" ip_declare_parameters

  set parameters [convert_data_to_dict $parameters]

  # Add the parameters
  dict for {name props} $parameters {
    # Add the parameter if not already added
    set type [get_item_property $parameters $name TYPE]
    if {[get_item_property $i_parameters $name TYPE] == "NOVAL" && $type != "NOVAL"} {
      # Retrieve parameter type
      dict set i_parameters $name TYPE $type
      ip_add "parameter.${name}" $type
    }

    # Retrieve and set all parameter properties from list
    dict for {prop val} $props {
      if {$val != "NOVAL"} {
        dict set i_parameters $name $prop $val
        # These properties do not get set during declaration
        if { [is_iputf_param_prop $prop] && ![is_bool_param_prop $prop] } {
          ip_set "parameter.${name}.${prop}" $val
        }
      }
    }
  }
}


proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_interfaces { interfaces } {
  variable i_interfaces
  variable dynamic_elab

  state_check "DECLARE" ip_declare_interfaces

  set interfaces [convert_data_to_dict $interfaces]

  # append each interface to i_interfaces for future if not already appended
  dict for {prop val} $interfaces {
     if { ![dict exists $i_interfaces $prop] } {
        dict append i_interfaces $prop $val
     }
  }

  set dynamic_elab false
  ip_elaborate_interfaces
  set dynamic_elab NOVAL
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_filesets { filesets } {
  # Convert to dictionary
  set i_filesets [convert_data_to_dict $filesets]

  state_check "DECLARE" ip_declare_filesets

  # Iterate over fileset entries
  dict for {name props} $i_filesets {
    # We require the name, type, and callback to add the fileset
    set type      [get_item_property $i_filesets $name TYPE]
    set callback  [get_item_property $i_filesets $name CALLBACK]

    if { $type == "NOVAL" || $callback == "NOVAL" } {
      error "\[ip_declare_filesets\] NAME:${name} TYPE:${type} CALLBACK:${callback}"
      return
    }
    ip_add "fileset.${name}" $type $callback

    # Iterate over and set properties
    dict for {prop val} $props {
      # Ignore special cases
      if { [lsearch {NAME TYPE CALLBACK} $prop] == -1 } {
        ip_set "fileset.${name}.${prop}" $val
      }
    }
  }
}


proc ::alt_xcvr::ip_tcl::ip_module::ip_validate {} {
  ip_validate_parameters
  ip_validate_display_items
}

#+===============================================
#
# This procedure checks whether rapid_validate is enabled
#		rapid_validate (0) - Run full validation all the time
#       rapid_validate (1) - Run rapid validation all the time except for the following conditions
#								o SYSTEM_INFO parameter has changed
#								o IPUTF has reset the allowed_ranges property of the non-derived parameters
#
#+===============================================
proc ::alt_xcvr::ip_tcl::ip_module::ip_rapid_validate_parameters { rapid_validate skip_rapid } {
  variable parameter_cache_name  
  variable invalid_parameter_cache_name  
  variable invalid_parameters_cache      
  variable all_time_validated_parameter_cache_name
  variable all_time_validated_parameters
  variable static_all_time_validated_parameters
  
  if { $skip_rapid == 1 } {
	#puts "Rapid validation is turned OFF -- run normal validation"
	ip_validate_parameters
	return
  }

  set tainted_parameters {}
  set parameters_under_validation {}

  set temp_invalid_parameters_cache [ip_get "parameter.${invalid_parameter_cache_name}.value"]  
  set temp_all_time_validated_parameters [list {*}[ip_get "parameter.${all_time_validated_parameter_cache_name}.value"] {*}$static_all_time_validated_parameters]  
  set non_derived_param_values_cache [ip_get "parameter.${parameter_cache_name}.value"]

  if { $non_derived_param_values_cache == "" } {
	#puts "(FULL) non_derived_param_values_cache is empty"
	init_parameter_cache
	set run_full_validation 1		
  } elseif { $rapid_validate == 0 } {
	set run_full_validation 1
	#puts "(FULL) Rapid validation has been turned OFF."
  } else {
	# Collect parameters that change from previous call and check whether full validation is required	
	set run_full_validation [collect_tainted_parameters tainted_parameters]
	
	if { $run_full_validation == 0 } {									
		set parameters_under_validation [list  $tainted_parameters [dict keys $temp_invalid_parameters_cache]]
		set parameters_under_validation [concat {*}$parameters_under_validation]

		#puts "(partial) Partial parameters changes"	
		#if { [llength $parameters_under_validation] > 0 } {												
			#puts "	Changed parameters: $tainted_parameters"			
			#puts "	Parameters to be revalidated: $parameters_under_validation"
		#}			
	}
  }
  
  # Unset invalid_parameters_cache before any validation happens, this array will be updated with parameters that are found invalid during validation
  set invalid_parameters_cache {}
  # Unset all_time_validated_parameters before any validation happens, this array will be updated with parameters that posted info/warning message during validation
  set all_time_validated_parameters {}
 
  if { $run_full_validation == 1 } {
	ip_validate_parameters
  } else {    
	validate_tainted_parameters $parameters_under_validation [dict keys $temp_all_time_validated_parameters]
  }  

  #------------
  # Update parameter cache after validation for both value and allowed_ranges
  #------------
  if { $run_full_validation == 0 && [llength $tainted_parameters] == 0 } {									
		return
  }
  
  set non_derived_param_values_cache [ip_get "parameter.${parameter_cache_name}.value"]

  dict for {name props} $non_derived_param_values_cache {	
	set cur_value [ip_get "parameter.${name}.value"]
	set cur_allowed_ranges [ip_get "parameter.${name}.allowed_ranges"]		

	dict set non_derived_param_values_cache $name value $cur_value
	dict set non_derived_param_values_cache $name allowed_ranges $cur_allowed_ranges
  }
  
  ip_set "parameter.${parameter_cache_name}.value" $non_derived_param_values_cache
  ip_set "parameter.${invalid_parameter_cache_name}.value" $invalid_parameters_cache  
  ip_set "parameter.${all_time_validated_parameter_cache_name}.value" $all_time_validated_parameters
}

proc ::alt_xcvr::ip_tcl::ip_module::init_parameter_cache {} {
	variable system_info_parameters
	variable non_derived_parameters
	variable parameter_cache_name

	set non_derived_param_values_cache [dict create]

	#-------------------------------------
	# Initialize non_derived_param_values_cache to "NOVAL"
	# non_derived_param_values_cache is used to keep the values of non-derived parameters from previous validation callbacks
	#-------------------------------------	
	foreach name [dict keys $non_derived_parameters] { 
		dict set non_derived_param_values_cache $name {value "NOVAL" allowed_ranges "NOVAL" full_validation 0}		
	}
	
	foreach system_info_param [lsort -unique $system_info_parameters] {
		dict set non_derived_param_values_cache $system_info_param {value "NOVAL" allowed_ranges "NOVAL" full_validation 1}
	}
	
	ip_set "parameter.${parameter_cache_name}.value" $non_derived_param_values_cache		
}

proc ::alt_xcvr::ip_tcl::ip_module::validate_tainted_parameters { tainted_parameters all_time_validated_parameters } {
	variable i_parameters
	variable validated_stack			
  
	set validated_stack {}
	set parameters_under_validation {}	
	
	foreach param $tainted_parameters {
		lappend parameters_under_validation $param
		foreach name [get_item_property $i_parameters $param M_DERIVED_PARAMS] {		
			lappend parameters_under_validation $name			
		}
	}
	
	#-------------------------------------
	# Alway run validation for parameters with M_ALWAYS_VALIDATE set to 1
	#   This is to cater for cases where we want to show an info message to users all the time (e.g. transcever datarate given the select part)
	#-------------------------------------
	set parameters_under_validation [list $parameters_under_validation $all_time_validated_parameters]
	set parameters_under_validation [lsort -unique [concat {*}$parameters_under_validation]]

	set active_parameters {}
	foreach name $parameters_under_validation {
		set ignore [get_item_property $i_parameters $name M_IGNORE]
		if {$ignore == 1} {
		 dict set i_parameters $name VALIDATED 1
		} else {
			dict set i_parameters $name VALIDATED 0
			lappend active_parameters $name
		}		
	}
	
	foreach name $active_parameters {				
		validate_parameter $name
	}			
	
	# Revalidate the ENABLE and VISIBLE properties for parameters which the property values are controlled by parameters that are re-validated due to recent parameter changes 
	foreach control_param $active_parameters {
		set param_list [get_item_property $i_parameters $control_param M_CONTROL_DERIVED_PARAMS]
		if {$param_list != "NOVAL"} {
			foreach name $param_list {
				validate_param_accessibility_prop $i_parameters $name		
			}
		}
	}
}

proc ::alt_xcvr::ip_tcl::ip_module::collect_tainted_parameters { tainted_parameters_var } {	
	variable invalid_parameter_cache_name	
	variable parameter_cache_name
	upvar tainted_parameters $tainted_parameters_var			
	
	set full_validation_flag 0
	set non_derived_param_values_cache [ip_get "parameter.${parameter_cache_name}.value"]		
	
	# (1) Check if any of the SYSTEM_INFO parameters(parameters with full_validation=1) has changed which valls for full validation 
	# (2) Check if the allowed_ranges of any of the parameters has changed which calls for full validation
	# (3) Check if the value of any of the parameters has changed which calls for partial validation
	dict for {name props} $non_derived_param_values_cache {		
		set cur_allowed_ranges [ip_get "parameter.${name}.allowed_ranges"]
		set allowed_ranges [dict get $props allowed_ranges]			
		if {$cur_allowed_ranges != $allowed_ranges} {				
			set full_validation_flag 1	
			#puts "(FULL) allowed_ranges of $name has been reset"		
			break
		}

		set value [dict get $props value]
		set cur_value [ip_get "parameter.${name}.value"]
		if {$cur_value != $value} {
			if [dict get $props full_validation] {
				set full_validation_flag 1	
				#puts "(FULL) system Parameter $name has changed"										
				break
			} else {
				lappend tainted_parameters $name
			}						
		}
	}

	return $full_validation_flag
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_validate_parameters {} {
  variable i_parameters
  variable validated_stack
  
  # Clear validated list
  set validated_stack {}

  set active_parameters {}
  dict for {name props} $i_parameters {
	set ignore [get_item_property $i_parameters $name M_IGNORE]		
	if {$ignore == 1} {
		 dict set i_parameters $name VALIDATED 1
	} else {
		dict set i_parameters $name VALIDATED 0
		lappend active_parameters $name
	}
  }

  foreach name $active_parameters {
    #dprint "\[ip_validate_parameters\] name:$name"
    validate_parameter $name
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_all_time_validated_parameters { params } {	
	variable static_all_time_validated_parameters	
	foreach param $params {
		dict set static_all_time_validated_parameters $param 1
	}
}

#========================================================
# Given a set of non-derived parameters, find out the list of parameters that are dependent on each of them
#========================================================
proc ::alt_xcvr::ip_tcl::ip_module::ip_declare_parameter_dependencies { cache_name invalid_cache_name all_time_validated_cache_name } {
	variable parameter_cache_name
	variable invalid_parameter_cache_name
	variable all_time_validated_parameter_cache_name
	variable alist
	variable i_parameters	
	variable user_property_type_dict
	variable non_derived_parameters
	
	array set ant_deps_map {}
	array set dep_ants_map {}
	array set non_derived_ant_deps_map {}
	array set control_ant_deps_map {}	

	#-------------------------------------
	# Set the names of the cache parameters passed in by caller
	#-------------------------------------
	set parameter_cache_name $cache_name
	set invalid_parameter_cache_name $invalid_cache_name
	set all_time_validated_parameter_cache_name $all_time_validated_cache_name
	
	#-------------------------------------
	# For each parameter, collect the list of parameters that are derived from it
	# 	M_DERIVED_PARAMS keeps parameters which value depends on the parameter
	#	M_CONTROL_DERIVED_PARAMS keeps parameters which accessibility (VISIBLE, ENABLED) depends on the parameter
	#-------------------------------------
	dict for {name props} $i_parameters {
		dict set i_parameters $name M_DERIVED_PARAMS {}
		dict set i_parameters $name M_CONTROL_DERIVED_PARAMS {}

		# Keeps the list of non-derived parameters in non_derived_parameters
		set derived [get_item_property $i_parameters $name DERIVED]
		if {$derived == "false"} {
			dict set non_derived_parameters $name 1		
		}

		# Setting up the {antecedent:dependents} map for accessibility control
		foreach prop {VISIBLE ENABLED} {
			set prop_value [get_item_property $i_parameters $name $prop]
			if { $prop_value != "NOVAL" } {
				foreach param [regexp -all -inline {\w+} $prop_value] {
					if {$param == "true" || $param == "false" } { 
						continue
					}	
					lappend control_ant_deps_map($param) $name
				}
			}
		}		

		# Setting up the map from antecedent parameter to derived parameters that are linked to antecedent parameter through user defined property
		#   e.g. M_AUTO_SET in altera_xcvr_native_a10
		set property_list [dict keys $user_property_type_dict]
		lappend property_list M_MAPS_FROM

		foreach property [lsort -unique $property_list] {
			set value [get_item_property $i_parameters $name $property 1]			
			foreach param [regexp -all -inline {\w+} $value] {
				if [ dict exists $i_parameters $param ] {				
					lappend ant_deps_map($param) $name						
				}
			}			
		}		

		# Setting up the map from antecedent parameter to derived parameters by looking up the argument list in M_MAP_CALLBACK and VALIDATION_CALLBACK
		foreach prop {M_MAP_CALLBACK VALIDATION_CALLBACK} {
			set callback [get_item_property $i_parameters $name $prop]
			if {$callback != "NOVAL"} {
				set antecedents [info args $callback]
				foreach ant $antecedents {
					if {($ant != $name) && ([string first "PROP_" $ant] == -1)} {
						lappend ant_deps_map($ant) $name
					}
				}
			}
		}
	}

	#-------------------------------------
	# (1) Set the M_DERIVED_PARAMS property for non-derived parameters and recursively search through second-level depedencies
	# (2) Using the antecedent to derived parameters map that is setup above, create a reverse map that maps 
	#     derived parameter to antecedent parameters	
	#-------------------------------------
	foreach param [dict keys $non_derived_parameters] {	
		set derived_param_list {}	
		get_dependencies $param ant_deps_map derived_param_list
		set derived_param_list [lsort -unique $derived_param_list]

		dict set i_parameters $param M_DERIVED_PARAMS $derived_param_list

		foreach derived_param $derived_param_list {
			lappend dep_ants_map($derived_param) $param
		}
	}

	#-------------------------------------
	# Use the reverse map created above, find out the top level non-derived parameter that controls the accessibility of a parameter
	#     In some cases, the accessibility of a parameter may be controlled by another derived parameter, we want to find out the top level
	#     non-derived parameter that actually controls the parameter accessibility
	#-------------------------------------
	array set top_control_ant_deps_map {}
	foreach control_ant [array names control_ant_deps_map] {
		set derived_param_list {}
				
		if [dict exists $non_derived_parameters $control_ant] {
			lappend top_control_ant_deps_map($control_ant) $control_ant_deps_map($control_ant)
		} elseif [info exists dep_ants_map($control_ant)] {			
			foreach ant [lsort -unique $dep_ants_map($control_ant)] {
				if [dict exists $non_derived_parameters $ant] {
					lappend top_control_ant_deps_map($ant) [lsort -unique $control_ant_deps_map($control_ant)]
				}
			}
		}
	}

	#-------------------------------------
	# Set the M_CONTROL_DERIVED_PARAMS property for non-derived parameters
	#-------------------------------------
	foreach {ant deps} [array get top_control_ant_deps_map] {		
		dict set i_parameters $ant M_CONTROL_DERIVED_PARAMS [lsort -unique [concat {*}$deps]]
	}
}

proc ::alt_xcvr::ip_tcl::ip_module::get_dependencies { param ant_deps_map_var derived_param_list_var } {
	upvar ant_deps_map $ant_deps_map_var
	upvar derived_param_list $derived_param_list_var

	if [info exists ant_deps_map($param)] {
		foreach derived_param [lsort -unique $ant_deps_map($param)] {
			lappend derived_param_list $derived_param
			get_dependencies $derived_param ant_deps_map derived_param_list
		}
	}
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_log_invalid_parameter { param } {
	variable invalid_parameters_cache	
	dict set invalid_parameters_cache $param 1		
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_log_parameter { param } {
	variable all_time_validated_parameters	
	dict set all_time_validated_parameters $param 1		
}

# Validation routine for display items allows automatic resolution of boolean parameters
# and calling of callback functions for display items
proc ::alt_xcvr::ip_tcl::ip_module::ip_validate_display_items {} {
  variable i_display_items

  foreach {name props} $i_display_items {
    # Handle boolean properties
    foreach {prop val} $props {
      if { [is_bool_param_prop $prop] } {
        set val [validate_prop_from_param $i_display_items $name $prop boolean]
        if { $val != "NOVAL" } {
          ip_set "display_item.${name}.${prop}" $val
        }
      }
    }

    # Call callback function if specified
    set callback [get_item_property $i_display_items $name VALIDATION_CALLBACK]
    if {$callback != "NOVAL"} {
      set antecedents [info args $callback]
      set vals {}
      foreach ant $antecedents {
        lappend vals [validate_parameter $ant]
      }
      # Call the callback function
      eval $callback $vals
    }
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_elaborate_interfaces {} {
  variable i_interfaces
  variable dynamic_elab

  if { $dynamic_elab == "NOVAL" } {
    set dynamic_elab true
  }

  dict for {name props} $i_interfaces {
    #dprint "\[ip_elaborate_interfaces\] name:$name"
    elaborate_interface $name
  }
}


proc ::alt_xcvr::ip_tcl::ip_module::ip_upgrade { ip_name ip_version old_params param_map } {

  set declared_param_list [get_parameters]
  set headers       [lindex $param_map 0]
  set version_index [lsearch $headers "VERSION"]
  set parameter_index [lsearch $headers "PARAMETER"]
  set old_parameter_index [lsearch $headers "OLD_PARAMETER"]
  set val_map_index [lsearch $headers "VAL_MAP"]

  if { [expr {$version_index == -1 || $parameter_index == -1 || $old_parameter_index == -1}] } {
    error "\[ip_upgrade\] invalid headers in param_map: ${param_map}"
    return
  }

  # Iterate over old parameters
  foreach {param_name param_value} $old_params {
    set param_value [string trim $param_value]
    # Default to existing parameter name and value
    set new_param_name $param_name
    set new_param_value $param_value

    # Iterate over parameter map looking for replacement
    for {set i 1 } { $i < [llength $param_map] } { incr i } {
      set data [lindex $param_map $i]
      set version [lindex $data $version_index]
      set parameter [lindex $data $parameter_index]
      set old_parameter [lindex $data $old_parameter_index]
      # Grab value map if it exists
      set val_map NOVAL
      if {[expr {$val_map_index != -1 }]} {
        set val_map [lindex $data $val_map_index] 
      }
      # Check for version match
      if {$version == $ip_version} {
        # Check for parameter match
        if {$old_parameter == $param_name} {
          # Replace old parameter name with new parameter name
          set new_param_name $parameter
          # Check for value remapping
          if { $val_map != "NOVAL" } {
            foreach {old_map_val new_map_val} $val_map {
              if {[string compare $old_map_val $param_value] == 0} {
                # Replace old parameter value with new parameter value
                set new_param_value $new_map_val
              }
            }
          }
          ::alt_xcvr::ip_tcl::messages::ip_message info "Upgrade from ${ip_name} v${ip_version} ${param_name}(${param_value}) -> ${new_param_name}(${new_param_value})."
        }
      }
    }
    # Finished iterating over parameter map
    #
    # See if the parameter still exists. If not, remove it.
    if { [lsearch $declared_param_list $new_param_name] == -1 } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Upgrade from ${ip_name} v${ip_version}. Removing parameter ${new_param_name}"
      set new_param_name NOVAL
    }
    # Set the new parameter name and value unless it was removed
    if {$new_param_name != "NOVAL"} {
      ip_set "parameter.${new_param_name}.value" $new_param_value
    }
  }
}


# Add a display_item or parameter
proc ::alt_xcvr::ip_tcl::ip_module::ip_add { attribute args} {
  variable alist
  variable alength

 #dprint "\[ip_add\] attribute:${attribute} args:${args}"
  parse_alist $attribute
  set type [get_alist_index 0]
  set name [get_alist_index 1]
  set command "" 
  if {$type == "parameter"} {
    # Parameters
    set command "add_parameter \"$name\""
  } elseif {$type == "display_item"} {
    # Display items
    # Must be of format "display_item.<group>.<display_item_name>"
    set group $name
    set name [get_alist_index 2]
    set command "add_display_item \"${group}\" \"${name}\""
  } elseif {$type == "interface"} {
    # Interfaces
    set command "add_interface \"${name}\""
  } elseif {$type == "port"} {
    # Ports
    set iface_name $name
    set name [get_alist_index 2]
    set command "add_interface_port \"${iface_name}\" \"${name}\""
  } elseif {$type == "fileset"} {
    # Filesets
    set command "add_fileset \"${name}\""
  } else {
    return
  }
  foreach arg $args {
    set command "${command} \"${arg}\""
  }
  eval $command
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_set { attribute {value NOVAL} } {
  variable alist
  variable alength
  variable i_parameters

  #dprint "\[ip_set\] attribute:${attribute} value:${value}"
  parse_alist $attribute

  set type [get_alist_index 0]
  set name [get_alist_index 1]
  set prop ""
  if {$alength > 2} {
    set prop [string toupper [get_alist_index 2]]
  }

  if {$type == "module"} {
    # Module properties
    set_module_property $name $value
  } elseif {$type == "parameter"} {
    # Parameters
    if { $prop == "DISPLAY_ITEM" } {
      add_display_item $value $name parameter
    } elseif { $prop == "VALUE" } {
      ip_set_parameter_value $name $value
    } elseif { [is_iputf_param_prop $prop] && ($value != "NOVAL")} {
      # set the value of IPUTF properties
      ip_set_parameter_property $name $prop $value
	  if [regexp -nocase "SYSTEM_INFO*" $prop] {
		register_system_info_parameter $name 
	  }
    } else {
      # set the value of non-IPUTF properties
      dict set i_parameters $name $prop $value
    }
	
  } elseif {$type == "display_item"} {
    set_display_item_property $name $prop $value
  } elseif {$type == "interface"} {
    # Interfaces
    if {$prop == "ASSIGNMENT"} {
      eval set_interface_assignment $name $value
    } else {
      set_interface_property $name $prop $value
    }
  } elseif {$type == "port"} {
    set_port_property $name $prop $value
  } elseif {$type == "fileset"} {
    set_fileset_property $name $prop $value
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_get { attribute } {
  variable alist
  variable alength
  variable i_parameters
  parse_alist $attribute


 #dprint "\[ip_get\] attribute:${attribute}"
  parse_alist $attribute

  set type [get_alist_index 0]
  set name [get_alist_index 1]
  if {$type == "module"} {
    return [get_module_property $name]
  } elseif {$type == "parameter"} {
    set prop [string toupper [get_alist_index 2]]
    if {$prop == "VALUE"} {
      return [ip_get_parameter_value $name]
    } elseif { [is_iputf_param_prop $prop] } {
      return [ip_get_parameter_property $name $prop]
    } else {
      return [get_item_property $i_parameters $name $prop]
    }
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_debug_print_tree{ } {
}


# Returns a list of all parameters that match the specified criteria
#
# @param criteria - A dictionary containing any number of criteria where each entry
#                   in the dictionary is a property:value pair
# For example:
#   ip_get_matching_parameters "DERIVED:false" "ENABLED:true" "M_DATA:hello"
proc ::alt_xcvr::ip_tcl::ip_module::ip_get_matching_parameters { criteria } {
  variable i_parameters

  set ret_val {}

  dict for {name props} $i_parameters {
    set valid 1
    dict for {c_prop c_val} $criteria {
      # Retrieve the property value
      set value [ip_get "parameter.${name}.${c_prop}"]
      if {$value != $c_val} {
        set valid 0
      }
    }

    if {$valid} {
      lappend ret_val $name
    }
  }

  return $ret_val
}

##
# Returns a list of all parameters that affect param_name, and are user settable
#
# @param_name - Dependencies for pram_name will be returned as a list
proc ::alt_xcvr::ip_tcl::ip_module::ip_get_userSettableParameters {param_name} {

  variable i_parameters
  
  set isUserParameter [expr ![ip_get "parameter.${param_name}.derived"] ]  
  set callback [get_item_property $i_parameters $param_name VALIDATION_CALLBACK]
  set map_callback [get_item_property $i_parameters $param_name M_MAP_CALLBACK]
  
  set callback_dependencies [list]
  if { $callback != "NOVAL"} {
    set callback_dependencies [info args $callback]
  }
  
  set map_callback_dependencies [list] 
    if { $map_callback != "NOVAL"} {
    set map_callback_dependencies [info args $map_callback]
  }
  
  #concat the 2 lists, also in case this antecedent was "directly" mapped from another one - add that one to the list as well
  set dependencies_temp [concat $callback_dependencies $map_callback_dependencies [list [ip_get_mapped_parameter_name $param_name 0]]]  
  #it is possible to have repetitions here - get rid of them
  set dependencies_temp [lsort -unique $dependencies_temp]

  #remove the param_name and antecedent listed with PROP_* from the antecedents list
  set dependencies [list]
  foreach antecedent $dependencies_temp {
    if {!($antecedent==$param_name || [regexp -nocase "PROP_*" $antecedent])} {
      set dependencies [linsert $dependencies end $antecedent]
    }
  }
  
  set return_value [list]
  if {[llength $dependencies]>0} {
    
    #a user settable parameter can have more dependencies but it needs to be added to the list itself
    if {$isUserParameter} {
      set return_value [linsert $return_value end $param_name];
    }

    # for each antecedent trace it back to user settable parameters   
    foreach elem $dependencies {
      set return_value [concat $return_value [ip_get_userSettableParameters $elem]]
    }
    
  } else {
  
    # if there is no dependencies and this is a user settable parameter than return the param_name itself
    if {$isUserParameter} {
      set return_value [list $param_name]
    }
    
  }
    
  return $return_value
}

##
# Returns updated list of the form {{NAME propertyName1 propertyName2 ...} {parameterName1 value1_1 value1_2 ...} {parameterName2 value2_1 value2_2 ...} ...}
#
# @param data          - list to be updated and returned of the form  {{NAME Property1 Property2 ...} {parameterName1 value1_1 value1_2 ...} {parameterName2 value2_1 value2_2 ...} ...}
# @param parameterName - whose property value to be updated in the list
# @param propertyName  - property to be updated
# @param propertyValue - new value for the property
#
# @return updated list 
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_property_byParameterName  { data propertyName propertyValue parameterName } {
   # find the index of parameter
   set parameterIndex -1
   set headers [lindex $data 0]
   set parameterNameIndex [lsearch $headers NAME]
   set length [llength $data]
   for {set i 1} {$i < $length} {incr i} {
      set this_entry [lindex $data $i]
      if { [lindex $this_entry $parameterNameIndex] == $parameterName } {
         set parameterIndex $i
      }
   }

   if {$parameterIndex == -1} {
      ip_message error ":alt_xcvr::ip_tcl::ip_module::ip_set_property_byParameterIndex:: parameter($parameterName) does not exist"
   }

   return [ip_set_property_byParameterIndex $data $propertyName $propertyValue $parameterIndex]
}

##
# Returns updated list of the form {{NAME propertyName1 propertyName2 ...} {parameterName1 value1_1 value1_2 ...} {parameterName2 value2_1 value2_2 ...} ...}
#
# @param data           - list to be updated and returned of the form  {{NAME Property1 Property2 ...} {parameterName1 value1_1 value1_2 ...} {parameterName2 value2_1 value2_2 ...} ...}
# @param parameterIndex - at which row parameter exists
# @param propertyName   - property to be updated
# @param propertyValue  - new value for the property
#
# @return updated list 
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_property_byParameterIndex { data propertyName propertyValue parameterIndex } {

   set headers [lindex $data 0]
   set propertyIndex [lsearch $headers $propertyName]
   if { $propertyIndex == -1 } {
      ip_message error ":alt_xcvr::ip_tcl::ip_module::ip_set_property_byParameterIndex:: property($propertyName) does not exist"
   }

   set length [llength $data]

   if { $length <= $parameterIndex || $parameterIndex < 1 } {
      ip_message error ":alt_xcvr::ip_tcl::ip_module::ip_set_property_byParameterIndex:: invalid parameter index($parameterIndex)"
   }

   set parameterProperties [lindex $data $parameterIndex]
   set parameterProperties [lreplace $parameterProperties $propertyIndex $propertyIndex $propertyValue]
   set data [lreplace $data $parameterIndex $parameterIndex $parameterProperties]

   return $data
}

##############################################################################
############################ Internal Functions ##############################
proc ::alt_xcvr::ip_tcl::ip_module::parse_alist { arg } {
  variable alist
  variable alength

 #dprint "\[parse_alist\] arg:$arg"
  set alist [split $arg "."]
  set alength [llength $alist]
 #dprint "\[parse_alist\] alist:${alist} alength:${alength}"
}

proc ::alt_xcvr::ip_tcl::ip_module::get_alist_index { index } {
  variable alist
  variable alength

  if { [expr {$alength <= $index}] } {
    error "\[get_alist_index\] Invalid index:$index"
  } else {
    return [lindex $alist $index]
  }
}

# Perform validation for the parameter specified by name
# This function recursively validates any antecedent parameters
#
# @param name - The name of the parameter to validate
proc ::alt_xcvr::ip_tcl::ip_module::validate_parameter { name } {
  variable i_parameters
  variable validated_stack

  #dprint "\[ip_module::validate_parameter\] ${name}"

  # Throw an error if the parameter is already on the stack (cyclical dependency)
  if {[lsearch $validated_stack $name] != -1} {
      error "\[ip_module::validate_parameter\] Cyclical parameter dependency! Parameter stack (top->bottom): ${name} ${validated_stack}"
  } else {
      set validated_stack [linsert $validated_stack 0 $name]
  }

  set thisvalue [ip_get "parameter.${name}.value"]

  # Return current value if already validated
  if {[get_item_property $i_parameters $name VALIDATED] == 1} {
    set validated_stack [lreplace $validated_stack 0 0]
    return $thisvalue
  }

  # Mark this parameter as validated
  dict set i_parameters $name VALIDATED 1

  # Special cases
  validate_param_accessibility_prop $i_parameters $name

  # special case-mapping
  set maps_from [get_item_property $i_parameters $name M_MAPS_FROM]
  set map_callback [get_item_property $i_parameters $name M_MAP_CALLBACK]
  if { $map_callback != "NOVAL" } {
  # if there is a mapping callback set the value of this parameter from the mapping callback
    set thisvalue [call_callback $name $thisvalue $map_callback 1]
    ip_set "parameter.${name}.value" $thisvalue
  } elseif { $maps_from != "NOVAL" } {
    # If the parameter is tagged as being mapped, grab the value of the mapped parameter
    # and set the value of this parameter from the mapping.
    set mapped_param_val [validate_parameter $maps_from]
    set thisvalue [ip_get_mapped_parameter_value $name $mapped_param_val]
    ip_set "parameter.${name}.value" $thisvalue
  }

  # Retrieve the callback
  set callback [get_item_property $i_parameters $name VALIDATION_CALLBACK]

  # Call the callback function (will return current value if no callback defined)
  set thisvalue [call_callback $name $thisvalue $callback]

  set validated_stack [lreplace $validated_stack 0 0]
  return $thisvalue
}

proc ::alt_xcvr::ip_tcl::ip_module::validate_param_accessibility_prop { parameters name } {
  validate_prop_from_param $parameters $name "ENABLED" boolean 1
  validate_prop_from_param $parameters $name "VISIBLE" boolean 1
}

###
# Given a parameter name, it's current value, and the name of it's callback function;
# do the following:
#
# 1 - If no callback exists, simply return the current value.
# 2 - If the callback exists, retrieve the list of antecedents by analyzying the callback's arg list
# 3 - Obtain the validated value for each antecedent.
# 4 - Call the callback procedure and pass the requested antecedents
proc ::alt_xcvr::ip_tcl::ip_module::call_callback { name thisvalue callback {callback_return 0} } {
  variable i_parameters
  # Retrieve the antecedents and call the callback
  if {$callback != "NOVAL"} {
    set antecedents [info args $callback]
    set vals {}
    foreach ant $antecedents {
      if {$ant == $name || $ant == "PROP_VALUE"} {
        lappend vals $thisvalue
      } elseif { [string first "PROP_" $ant] == 0 } {
        set prop [string replace $ant 0 4]
        # Obtain the property value from the table
        lappend vals [get_item_property $i_parameters $name $prop]
      } else {
        lappend vals [validate_parameter $ant]
      }
    }
    # Call the callback function
    #dprint "\[validate_parameter\] Calling ${callback} ${vals}"
    set temp [eval $callback $vals]
    if { $callback_return } {
      set thisvalue $temp
    } else {
      set thisvalue [ip_get "parameter.${name}.value"]
    }
  }
  return $thisvalue
}


proc ::alt_xcvr::ip_tcl::ip_module::elaborate_interface { name } {
  variable i_interfaces
  variable dynamic_elab
  variable split_suffix
  variable auto_conduit_in_native_mode

  # Grab this interface properties for later use
  set iface_name        [get_item_property $i_interfaces $name IFACE_NAME]
  set iface_type        [get_item_property $i_interfaces $name IFACE_TYPE]
  set iface_direction   [get_item_property $i_interfaces $name IFACE_DIRECTION]
  set callback          [get_item_property $i_interfaces $name ELABORATION_CALLBACK]
  set iface_dynamic     [get_item_property $i_interfaces $name DYNAMIC]
  set ui_direction      [get_item_property $i_interfaces $name UI_DIRECTION]
  set iface_split       false
  set iface_split_width NOVAL
  set iface_split_count 1
  
  # Don't elaborate a dynamic interface during static declaration
  if {$iface_dynamic == "NOVAL"} {
    set iface_dynamic false
  }

  if {$dynamic_elab == "false" && $iface_dynamic == "true"} {
    return
  }

  # Use the port name as the interface name IF there is no callback
  if {$iface_name == "NOVAL" && $callback == "NOVAL"} {
    set iface_name $name
  }
  
  set base_iface_name $iface_name
  # If the IFACE has not been specified there must be a callback
  if {$iface_name == "NOVAL" || $iface_type == "NOVAL" || $iface_direction == "NOVAL"} {
    if {$callback == "NOVAL"} {
      error "\[elaborate_interface\] Invalid values IFACE_NAME:$iface_name IFACE_TYPE:$iface_type IFACE_DIRECTION:$iface_direction"
      return
    }
  } else {
    # We're here because sufficient information was provided to declare the interface

    # Determine if splitting is requested
    set iface_split [validate_prop_from_param $i_interfaces $name SPLIT boolean]
    if {$iface_split == "true" } {
      set iface_split_count [validate_prop_from_param $i_interfaces $name SPLIT_COUNT integer]
      set iface_split_width [validate_prop_from_param $i_interfaces $name SPLIT_WIDTH integer]
      if { $iface_split_count == "NOVAL" || $iface_split_width == "NOVAL" } {
        error "\[elaborate_interface\] Invalid values IFACE_NAME:${iface_name} SPLIT:$iface_split SPLIT_COUNT:$iface_split_count SPLIT_WIDTH:$iface_split_width"
        return
      }
      # We don't really want to split if the interface is terminated
      set termination [validate_prop_from_param $i_interfaces $name TERMINATION boolean]
      if {$termination} {
        set iface_split "false"
        set iface_split_count 1
      }
    } else {
      set iface_split_count 1
    }

    for {set i 0} {$i < $iface_split_count} {incr i} {
      if {$iface_split == "true"} {
        set iface_name "${base_iface_name}${split_suffix}${i}"
      }

      # Only continue if elaboration phase matches
      if { $dynamic_elab == $iface_dynamic } {
        # Add the interface if not already declared
        # TODO - replace get_interfaces call
        if {[lsearch [get_interfaces] $iface_name] == -1} {
          if {$auto_conduit_in_native_mode && $iface_dynamic} {
            if {[get_parameter_value design_environment] != "QSYS"} {
              set iface_type "conduit"
              set iface_direction "end"
            }
          }
          ip_add "interface.${iface_name}" $iface_type $iface_direction
        }
      }
  
      # Now elaborate the port
      elaborate_port $iface_name $name $iface_split $i $iface_split_width
      if { $ui_direction != "NOVAL" } {
        ip_set "interface.${iface_name}.assignment" [list "ui.blockdiagram.direction" $ui_direction]
      }
    }
  }
  # Done adding interface
  
  # Call elaboration callback (only in dynamic phase)
  if {$callback != "NOVAL" && $dynamic_elab == "true" } {
    for {set i 0} {$i < $iface_split_count} {incr i} {
      if {$iface_split == "true"} {
        set iface_name "${base_iface_name}${split_suffix}${i}"
      }
      execute_interface_callback $iface_name $i $name $callback
    }
  }
}

###
# Elaborate an interface port. The interface must already exist.
#
# @param iface
proc ::alt_xcvr::ip_tcl::ip_module::elaborate_port { iface_name name {split_port false} {split_index 0} {split_width 0}} {
  variable i_interfaces
  variable dynamic_elab
  variable port_ignore_list
  variable split_suffix

  # List properties ignored by port assignment
  set boolean_props    {TERMINATION}
  set integer_props    {TERMINATION_VALUE}

  # Get the port role
  set role  [get_item_property $i_interfaces $name ROLE]
  if {$role != "NOVAL"} {
    # We're here because sufficient information was provided to declare the port
    set pname $name
    if {$split_port == "true" } {
      set pname "${pname}${split_suffix}${split_index}"
    }
    # Add the port to the interface
    ip_add "port.${iface_name}.${pname}" $role

    # Special handling for split ports
    if {$split_port == "true" } {
      # Set the width if the port is split
      ip_set "port.${pname}.WIDTH_EXPR" $split_width

      # Set the fragment list
      set frag_base [expr {$split_index * $split_width}]
      set frag_top [expr {$split_index * $split_width + $split_width - 1}]

      set port_temp "${name}(${frag_top}:${frag_base})"
      #for {set w 0} {$w < $split_width} {incr w} {
      #  lappend port_temp ${name}@[expr $frag_base + $w]
      #}

      #set port_flipped [lrange $port_temp $frag_base $frag_top]

      ip_set "port.${pname}.FRAGMENT_LIST" $port_temp
    }
  
    # We can only elaborate further during elaboration (not static)
    if {$dynamic_elab == "true"} {
      # Retrieve and set all port properties from list
      dict for {prop val} [dict get $i_interfaces $name] { 
  
       #dprint "\[elaborate_port\] j:${j} prop:${prop} val:${val}"
  
        # Special property handling
        if { $split_port == "true" && $prop == "WIDTH_EXPR" } {
          set val NOVAL
        }

        if { [lsearch $port_ignore_list $prop] != -1 } {
          # These properties do not get set
          set val NOVAL
        } elseif { [string first "M_" $prop] == 0 } {
          # Ignore custom metadata attributes (prefix with "M_")
          set val NOVAL
        } elseif { [lsearch $boolean_props $prop] != -1 } {
          # Boolean properties may be associated with a parameter
          set val [validate_prop_from_param $i_interfaces $name $prop boolean]
        } elseif { [lsearch $integer_props $prop] != -1 } {
          set val [validate_prop_from_param $i_interfaces $name $prop integer]
        }
  
        # Set the port property
        if { $val != "NOVAL" } {
          ip_set "port.${pname}.${prop}" $val
        }
      }
    }
  }
  # Done adding port
}



###
# Execute an interface's callback function
proc ::alt_xcvr::ip_tcl::ip_module::execute_interface_callback { iface_name iface_split_index name callback } {
  variable i_interfaces

  set antecedents [info args $callback]
  set vals {}
  foreach ant $antecedents {
    # If the argument calls for a property value
    if { [string first "PROP_" $ant] == 0 } {
      set prop [string replace $ant 0 4]
      # Special properties
      if { $prop == "IFACE_NAME" } {
        # For IFACE_NAME, pass the resolved value
        lappend vals $iface_name
      } elseif { $prop == "IFACE_SPLIT_INDEX" } {
        lappend vals $iface_split_index
      } else { 
        # Obtain the property value from the table
        lappend vals [get_item_property $i_interfaces $name $prop]
      }
    } else {
      lappend vals [ip_get "parameter.${ant}.value"]
    }
  }
  # Call the callback function
 #dprint "\[elaborate_interfaces\] Calling ${callback} ${vals}"
  eval $callback $vals
}


###
# Obtain a property's value from a parameter if appropriate
#
# @param data - The data structure containing the properties and values
# @param name - The name of the element of interest.
# @param prop - The property of interest for thte element of interest
# @param type - The property type (boolean or integer)
# @param set_param - Optional - for parameters only. Set the parameter's value once obtained
# @param val - Optional - used if the parameter value is obtained prior to function call. Intended to be used for user defined properties.
proc ::alt_xcvr::ip_tcl::ip_module::validate_prop_from_param { data name prop type {set_param 0} {val _DEFAULT}} {

  if { $val == "_DEFAULT" } {
    # if the value is not passed, get the property value
    set val [get_item_property $data $name $prop]
  }
 
 #dprint "\[validate_prop_from_param\] name:${name} prop:${prop} val:${val}"
  if {$val != "NOVAL"} {

    # See if value is known
    set known [string is $type -strict [string tolower $val]]
   #dprint "\[validate_prop_from_param\] prop:${prop} val:${val} known:${known}"

    # If the value is unknown, assume parameter expression
    if { $known == 0 } {
      # get value from expression
      set val [convert_param_expr $val]
      set val [expr $val]
      if {$type == "boolean"} {
        if {$val == 0} {
          set val false
        } elseif {$val == 1} {
          set val true
        }
      }
    }
  }
  # Set the value if requested
  if {$val != "NOVAL" && $set_param == 1} {
    ip_set "parameter.${name}.${prop}" $val
  }
  return $val
}


proc ::alt_xcvr::ip_tcl::ip_module::get_item_property { data name prop {raw_text 0}} {
 #dprint "\[get_item_property\] name:${name} prop:${prop}"
  variable user_property_type_dict
  if {[dict exist $data $name $prop]} {
    set val [dict get $data $name $prop]
    if {($raw_text == 0) && [dict exist $user_property_type_dict $prop]} {
      #resolve the user defined property
      set prop_type [dict get $user_property_type_dict $prop TYPE]
      set val [validate_prop_from_param $data $name $prop $prop_type 0 $val]
    }
    return $val
  } else {
    return "NOVAL"
  }
}


proc ::alt_xcvr::ip_tcl::ip_module::is_iputf_param_prop { prop } {
  variable param_ignore_list

  set prop [string toupper $prop]
  if { [lsearch $param_ignore_list $prop] == -1 && [string first "M_" $prop] != 0 } {
    return 1
  }
  return 0
}

proc ::alt_xcvr::ip_tcl::ip_module::is_bool_param_prop { prop } {
  variable param_bool_list

  set prop [string toupper $prop]
  if { [lsearch $param_bool_list $prop] == -1 } {
    return 0
  }
  return 1
}


# Modifies the expression passed to replace all reference to parameters with calls to validate that parameter
proc ::alt_xcvr::ip_tcl::ip_module::convert_param_expr { old_expr } {
  regsub -all {[!~|&+-]} $old_expr " " new_expr
  regsub -all {[*/%<>=]} $new_expr " " new_expr
  regsub -all {[()]} $new_expr " " new_expr
  set new_expr [join $new_expr " "]

  set arglist [split $new_expr " "]

  # Replace parameter references with validation calls
  # We have to watch out for args whose strings are a subexpression of another arg.
  if {[llength $arglist] > 1} {
    set arglist [lsort -decreasing $arglist]
  }

  # Replace args with tags
  set index 0
  foreach arg $arglist {
    if { ![string is integer -strict $arg] } {
      set tag "tagtag${index}tagtag"
      regsub -all $arg $old_expr $tag old_expr
    }
    incr index
  }

  # Replace tags with calls
  set index 0
  foreach arg $arglist {
    if { ![string is integer -strict $arg] } {
      # The "__p" prefix is a key 
      #regsub "__p:" $arg "" arg
      set tag "tagtag${index}tagtag"
      regsub -all $tag $old_expr "\[validate_parameter ${arg}\]" old_expr
    }
    incr index
  }

  return $old_expr
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_get_mapped_parameter_name { param_name { recursive 0} } {
  set maps_from ""
  while {$maps_from != "NOVAL"} {
    set maps_from [ip_get "parameter.${param_name}.M_MAPS_FROM"]
    if {$maps_from != "NOVAL"} {
      set param_name $maps_from
    }
    if { $recursive == 0 } {
      break;
    }
  }

  return $param_name
}


proc ::alt_xcvr::ip_tcl::ip_module::ip_get_mapped_from_values_recursive { param_name param_vals } {
  #puts "\[ip_get_mapped_from_values_recursive\] Mapping param_name:${param_name} param_vals:${param_vals}"
  # If no mapping just return the value
  set maps_from [ip_get "parameter.${param_name}.M_MAPS_FROM"]
  if {$maps_from == "NOVAL"} {
    return $param_vals
  }

  set maps_from_list {}
  set unmap_callback [ip_get "parameter.${param_name}.M_UNMAP_CALLBACK"]
  if {$unmap_callback != "NOVAL"} {
    # if an unmap_callback is defined retrieve the value by calling unmap_callback
    set maps_from_list ""
    #param_vals can be like 1 4 5 7:10 12 18:20 ie combination of values and ranges
    #for each value we first test if it is a value or range by looking at the number of colons in the value
    foreach valid_values $param_vals {
      set numColons [expr {[string length $valid_values] - [string length [regsub -all ":" $valid_values ""]]}]
      if { $numColons == 0 } {
        #if it is a value we call the unmap_callback
        lappend maps_from_list [call_callback $param_name $valid_values $unmap_callback 1]
      } elseif { $numColons == 1 } {
        #if it is a range we call unmap_callback both for the low and high limits and reconstruct the range
        set low  [call_callback $param_name [regsub ":.*" $valid_values ""] $unmap_callback 1]
        set high [call_callback $param_name [regsub ".*:" $valid_values ""] $unmap_callback 1]
        lappend maps_from_list "$low:$high"
      } else {
        internal_error "::alt_xcvr::ip_tcl::ip_module::ip_get_mapped_from_values_recursive unexpected range structure"
      }
    }
  } elseif {[ip_get "parameter.${param_name}.M_MAP_VALUES"] == "NOVAL"} {
      # If the mapping is direct just return the value
      set maps_from_list $param_vals
  } else {
    # Find each value from the mapped parameter that maps to this value and add it to the list
    set allowed_ranges [ip_get "parameter.${maps_from}.allowed_ranges"]
    foreach map_value $allowed_ranges {
      set map_value [regsub ":.*" $map_value ""]
      set value [ip_get_mapped_parameter_value $param_name $map_value]
      #puts "\[ip_get_mapped_from_values_recursive\] map_value:${map_value} maps to $value"
      if { [lsearch $param_vals $value] != -1 && [lsearch $maps_from_list $map_value] == -1 } {
        lappend maps_from_list $map_value
      }
    }
    #puts "\[ip_get_mapped_from_values_recursive\] maps_from_list:${maps_from_list}"
  }

  return [ip_get_mapped_from_values_recursive $maps_from $maps_from_list]
}

###
# ip_get_mapped_parameter is used for parameters that are tagged with the M_MAPS_FROM and
# M_MAP_VALUES properties. These properties allow the developer to map one parameter to another.
# 
# Given a parameter name, and the current value of the parameter that this parameter maps to,
# this function will retrieve the M_MAP_VALUES list and return the associated value for this
# parameter that corresponds to the mapped_param_val.
#
# @param param_name - The parameter to obtain the mapping for.
# @param mapped_param_val - The current value of the parameter this parameter maps to.
proc ::alt_xcvr::ip_tcl::ip_module::ip_get_mapped_parameter_value { param_name mapped_param_val {reverse_map 0} {recursive 0} } {
  variable i_parameters

  #puts "\[ip_get_mapped_parameter_value\] Mapping param_name:${param_name} mapped_param_val:${mapped_param_val}" 
  # the M_MAP_VALUES property is expected to contain a list of strings containing the parameter mappings:
  # i.e { "<mapped_param_val0>:<this_param_val0>" "<mapped_param_val1>:<this_param_val1>" }
  # If it does not contain the list, assume a 1:1 mapping
  set map [get_item_property $i_parameters $param_name M_MAP_VALUES]
  if {$map == "NOVAL"} {
    return $mapped_param_val
  }
  
  foreach mapping $map {
    set mapping [split $mapping ":"]
    if {[lindex $mapping 0] == $mapped_param_val} {
      return [lindex $mapping 1]
    }
  }

  # Return the default (If there is one)
  return [get_item_property $i_parameters $param_name M_MAP_DEFAULT]

}


###
# Internal version of set parameter value
#
# @param name - Parameter to set
# @param value - Parameter value to set
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_parameter_value { name value } {
  variable standalone
  variable i_standalone_parameters
  # Setting parameter value
  if {!$standalone} {
    set_parameter_value $name $value
  }
  dict set i_standalone_parameters $name VALUE $value
}


###
# Internal version of get_parameter_value
#
# @param name - Parameter to get
proc ::alt_xcvr::ip_tcl::ip_module::ip_get_parameter_value { name } {
  variable standalone
  variable i_standalone_parameters
  if {!$standalone} {
    dict set i_standalone_parameters $name VALUE [get_parameter_value $name]
  }
  return [dict get $i_standalone_parameters $name VALUE]
}


###
# Internal version of set_parameter_property
#
# @param name - Parameter to set property for
# @param prop - Property to set
# @param value - Property value value to set
proc ::alt_xcvr::ip_tcl::ip_module::ip_set_parameter_property { name prop value } {
  variable standalone
  variable i_standalone_parameters

  # Set parameter property
  if {!$standalone} {
    set_parameter_property $name $prop $value
  }
  dict set i_standalone_parameters $name $prop $value
  if {$prop == "DEFAULT_VALUE"} {
    dict set i_standalone_parameters $name VALUE $value
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::register_system_info_parameter { name } {	
	variable system_info_parameters	
	lappend system_info_parameters $name
}

###
# Internal version of get_parameter_property
#
# @param name - Parameter to get property for
# @param prop - Property to get
proc ::alt_xcvr::ip_tcl::ip_module::ip_get_parameter_property { name prop } {
  variable standalone
  variable i_standalone_parameters

  if {!$standalone} {
    dict set i_standalone_parameters $name $prop [get_parameter_property $name $prop]
  }

  if { [dict exists $i_standalone_parameters $name $prop] } {
    return [dict get $i_standalone_parameters $name $prop]
  } else {
    return "NOVAL"
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::ip_parse_csv { filename tag } {
  variable csv_data

  set fid ""

  if { [catch {set fid [open $filename "r"]}] } {
    error "\[ip_parse_csv\] Could not open file $filename! : $fid"
    return
  }

  set state "search"
  set varname ""
  set value {}

  #puts "starting"
  while {1} {
    set line ""
    set ln 0
    set data {}
    while { [llength $data] == 0 && ![eof $fid]} {
      incr ln
      set line [gets $fid];   # get line
      set line [string trim $line];  # remove leading and trailing spaces
      #puts "$line"
      if {[string index $line 0] == "#"} {
        set line ""
      } else {
        # Convert csv to list
        set data [csv2list $line]
        #puts "$data"
        # Remove empty entries (can only be at ends of lines)
        for {set x [expr [llength $data] - 1]} {$x >= 0} {set x [expr $x - 1]} {
          if { [llength [lindex $data $x]] == 0 } {
            set data [lreplace $data $x $x]
          } else {
            set x -1
          }
        }
      }
    }
    # Finish if end of file
    if [eof $fid] {
      close $fid
      return
    }

    if { $state == "search" } {
      #puts "Searching $data"
      if { [lindex [lindex $data 0] 0] == "variable" } {
        set varname [lindex [lindex $data 0] 1]
        #puts "Found variable $varname"
        set value {}
        set state "data"
      } else {
        error "\[ip_parse_csv\] Unexpected text \"$line\" at line # $ln of file $filename. Expected \"variable <variable_name>\""
      }
    } elseif { $state == "data" } {
      if { [lindex [lindex $data 0] 0] == "endvariable" } {
        dict set csv_data $tag $varname $value
        set state "search"
      } else {
        lappend value $data
      }
    }
  }
  
}


proc ::alt_xcvr::ip_tcl::ip_module::csv2list {str {sepChar ,}} {
    regsub -all {(\A\"|\"\Z)} $str \0 str
    set str [string map [list $sepChar\"\"\" $sepChar\0\" \
                              \"\"\"$sepChar \"\0$sepChar \
                              $sepChar\"\"$sepChar $sepChar$sepChar \
                              \"\" \" \" \0 ] $str]
    set end 0
    while {[regexp -indices -start $end {(\0)[^\0]*(\0)} $str \
            -> start end]} {
        set start [lindex $start 0]
        set end   [lindex $end 0]
        set range [string range $str $start $end]
        set first [string first $sepChar $range]
        if {$first >= 0} {
            set str [string replace $str $start $end \
                [string map [list $sepChar \1] $range]]
        }
        incr end
    }
    set str [string map [list $sepChar \0 \1 $sepChar \0 {} ] $str]
    #dprint "\[csv2list\] converted string: $str"
    #set lst {}
    ## Convert to list
    #while { [llength $str] > 0 } {
    #  set end [string first "\0" $str]
    #  if { $end == -1 } {
    #    set end [llength $str]
    #  }
    #  # Get element
    #  puts $end
    #  set this_str [string range $str 0 [expr $end - 1]]
    #  puts $this_str
    #  lappend lst $this_str
    #  set str [string replace $str 0 $end]
    #}

    #dprint "\[csv2list\] converted list: $lst"
    return [split $str \0]
 }



proc ::alt_xcvr::ip_tcl::ip_module::ip_get_csv_variable { tag varname } {
  variable csv_data

  return [dict get $csv_data $tag $varname]

}


proc ::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict { data } {
  
  set this_dict [dict create]

  set headers [lindex $data 0]  
  set length [llength $data]
  set nameindex [lsearch $headers NAME]
  for {set i 1} {$i < $length} {incr i} {
    set this_entry [lindex $data $i]
    set key [lindex $this_entry $nameindex]
    for {set j 0} {$j < [llength $this_entry]} {incr j} {
      dict set this_dict $key [lindex $headers $j] [lindex $this_entry $j]
    }
  }
  return $this_dict
}


proc ::alt_xcvr::ip_tcl::ip_module::print_dict { data } {

  #puts "\[ip_module::print_dict\] Dictionary: $data"
  puts "Dictionary size: [dict size $data]"
  dict for {name attribs} $data {
      puts "Attribute $name:"
      dict for {attrib value} $attribs {
        puts "   Property: $attrib:$value"
      }
  }
  
}
  

proc ::alt_xcvr::ip_tcl::ip_module::dprint { str } {
  variable debug
  variable lasttime

  if { $debug == 1 } {
    set time [clock clicks -milliseconds]
    puts "$str : $time [expr $time - $lasttime]"
    set lasttime $time
  }
}

proc ::alt_xcvr::ip_tcl::ip_module::state_check { expected_state func_name } {
  variable state

  if {$state != $expected_state} {
    error "${func_name} cannot be called during state ${state}!"
  }
}
########################## End Internal Functions ############################
##############################################################################
