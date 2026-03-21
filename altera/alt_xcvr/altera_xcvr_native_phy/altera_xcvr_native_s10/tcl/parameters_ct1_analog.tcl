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


package provide altera_xcvr_native_s10::parameters::ct1_analog 18.1

##############################
# Include package
##############################
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require altera_xcvr_native_s10::parameters::data

##############################
# namespace declaration
##############################
namespace eval ::altera_xcvr_native_s10::parameters::ct1_analog {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    get_variable \
    declare_parameters \
    validate

  variable package_name
  variable ct1_analog_parameters
  variable ct1_analog_mappings
  variable ct1_analog_overrides

  # Initialize the variables
  variable package_name "altera_xcvr_native_s10::parameters::ct1_analog"
  set ct1_analog_parameters [altera_xcvr_native_s10::parameters::data::get_variable "ct1_analog_parameters"]
  set ct1_analog_mappings [altera_xcvr_native_s10::parameters::data::get_variable "ct1_analog_mappings"]
  set ct1_analog_overrides [altera_xcvr_native_s10::parameters::data::get_variable "ct1_analog_overrides"]

}

##############################
# Get the namespace variable
#
# @arg var variable name
# @return Namespace variable for the given variable name
##############################
proc ::altera_xcvr_native_s10::parameters::ct1_analog::get_variable { var } {
  variable display_items

  return [set $var]
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::declare_ct1_analog_parameters { } {
  variable ct1_analog_parameters

  ip_declare_parameters $ct1_analog_parameters
}


proc  ::altera_xcvr_native_s10::parameters::ct1_analog::tag_ct1_analog_parameters { } {
  # Get antecedents for the given parameter
  proc get_antecedents { params name } {
    set ant_list {}
  
    if { [dict exists $params $name] } {
      set callback [dict get $params $name VALIDATION_CALLBACK ]
      if {$callback != "NOVAL"} {
        # Get antecedents from callback
  	    set antecedents [info args $callback]
        # Iterate over each antecedent
  	    foreach ant $antecedents {
          if {($ant != $name) && ([string first "PROP_" $ant] == -1)} {
  	  	    lappend ant_list $ant
            lappend ant_list [get_antecedents $params $ant]
  	      }
        }
  	  }
    }
    return $ant_list
  }
 
  set native_parameters [::ct1_xcvr_native::parameters::get_parameters]
  set native_parameters [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict $native_parameters]
 
  # Iterate over each parameter and see if an analog parameter exists in its antecedents
  # If so, tag it with the same type
  dict for {param props} $native_parameters {
    set antecedents [get_antecedents $native_parameters $param]
    foreach ant $antecedents {
      set analog_type [ip_get "parameter.${ant}.M_ANALOG_TYPE"]
      if {$analog_type != "NOVAL" } {
        ip_set "parameter.${param}.M_ANALOG_TYPE" $analog_type
        # This will give priority to TX or RX. The ant list will likely contain both TXRX and (TX or RX).
        # Primarily because things like voltage affect all parameters. But we only want to tag something TXRX
        # if it doesn't explicitly belong to TX only or RX only. Meaning it's only dependency is on a TXRX
        if { $analog_type == "TX" || $analog_type == "RX" } {
          break
        }
      }
    }
  }
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_qsf_assignment_display { tx_enable rx_enable qsf_assignments_enable} {
  ip_set "display_item.qsf_assignment_display.visible" $qsf_assignments_enable
  if { !$qsf_assignments_enable } {
    return
  }

  # Get the list of analog parameters
  set analog_params [ip_get_matching_parameters {M_ANALOG_TYPE TXRX}]
  if { $tx_enable } {
    set analog_params [concat $analog_params [ip_get_matching_parameters {M_ANALOG_TYPE TX}]] 
  }
  if { $rx_enable } {
    set analog_params [concat $analog_params [ip_get_matching_parameters {M_ANALOG_TYPE RX}]]
  }

  set values {}
  lappend values "#These QSF assignments are provided for your reference."
  lappend values "#Normally you do not need these assignments. The IP will"
  lappend values "#make these settings for you."

  lappend values "set pin_name \"your_pin_name_here\""

  foreach param $analog_params {
    set param_value [ip_get "parameter.${param}.value"]
    lappend values "set_instance_assignment -name HSSI_PARAMETER \"${param}=${param_value}\" -to \${pin_name}"
  }
  ip_set "parameter.qsf_assignments_list.value" $values
  
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::update_analog_display_units { } {
  set analog_params [ip_get_matching_parameters {M_ANALOG 1}]
  foreach param $analog_params {
    set maps_from [ip_get "parameter.${param}.M_MAPS_FROM"]
    if { $maps_from != "NOVAL" } {
      set visible [ip_get "parameter.${maps_from}.visible"]
      if { $visible } {
        set param_value [ip_get "parameter.${param}.value"]
        set maps_from_value [::alt_xcvr::ip_tcl::ip_module::ip_get_mapped_from_values_recursive $param [list $param_value]]
        #ip_set "parameter.${maps_from}.DISPLAY_UNITS" $maps_from_value
      }
    }
  }
}



proc ::altera_xcvr_native_s10::parameters::ct1_analog::override_ct1_analog_parameters { } {
  variable ct1_analog_parameters
  variable ct1_analog_mappings
  variable ct1_analog_overrides

  ip_declare_parameters $ct1_analog_mappings
  ip_declare_parameters $ct1_analog_overrides

   # Get the analog atom params defined in parameter tables
  set criteria [dict create M_ANALOG 1]
  set anlg_atom_params [ip_get_matching_parameters $criteria]
  

  #Override GUI default value and allowed ranges with atom parameter values if a specific mapping from GUI<->atom is not defined in the parameter table. 
  #Copy DEFAULT_VALUE if DEFAULT_VALUE is not defined in the GUI mapping table
  #Copy ALLOWED_RANGES if it not restricted in the GUI mapping table
  foreach anlg_atom_param $anlg_atom_params {
    if {[ip_get "parameter.${anlg_atom_param}.M_MAP_VALUES"] == "NOVAL"} {
      set anlg_gui_param [ip_get "parameter.${anlg_atom_param}.M_MAPS_FROM"]
      set anlg_gui_param_allowed_ranges [ip_get "parameter.${anlg_gui_param}.ALLOWED_RANGES"]
      set anlg_gui_param_default_value  [ip_get "parameter.${anlg_gui_param}.DEFAULT_VALUE"]
      if { [string length $anlg_gui_param_default_value] == 0 } { 
        ip_set "parameter.${anlg_gui_param}.DEFAULT_VALUE"  [ip_get "parameter.${anlg_atom_param}.DEFAULT_VALUE"] 
      }
      if { [llength $anlg_gui_param_allowed_ranges] <= 1 } { 
        set allowed_ranges [ip_get "parameter.${anlg_atom_param}.ALLOWED_RANGES"]
        set allowed_ranges [lsort -dictionary $allowed_ranges]

        # If the M_MAP_NUMERIC property is 1, we're going to map an integer param to a string
        if { [ip_get "parameter.${anlg_atom_param}.M_MAP_NUMERIC"] } {
          # Determine and set the numeric default
          set num_def [lsearch $allowed_ranges [ip_get "parameter.${anlg_atom_param}.DEFAULT_VALUE"]]
          ip_set "parameter.${anlg_gui_param}.DEFAULT_VALUE" $num_def

          # Construct the numeric list of allowed ranges
          # Create the M_MAP_VALUES pairs 
          set map_values {}
          set num_list {}
          set num_values [llength $allowed_ranges]
          for {set i 0} {$i<$num_values} {incr i} {
            set map_val [lindex ${allowed_ranges} $i]
            lappend map_values "${i}:${map_val}"
            lappend num_list $i
          }
          ip_set "parameter.${anlg_atom_param}.M_MAP_VALUES" $map_values
          
          # If the GUI parameter is to displayed as a slider, make it a range, otherwise a list
          if { [string tolower [ip_get "parameter.${anlg_gui_param}.DISPLAY_HINT"]] == "slider" } {
            set allowed_ranges "0:${num_values}"
          } else {
            set allowed_ranges $num_list
          }
        }
        # set the allowed ranges
        ip_set "parameter.${anlg_gui_param}.ALLOWED_RANGES" $allowed_ranges
      }
    }
  }

  tag_ct1_analog_parameters
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_l_tx_pma_enable_rcfg_report { PROP_NAME tx_enable pma_enable_rcfg_report } {
  set value 0
  if { $tx_enable && $pma_enable_rcfg_report } {
    set value 1
  }
  ip_set "parameter.${PROP_NAME}.value" $value
}

proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_l_rx_pma_enable_rcfg_report { PROP_NAME rx_enable pma_enable_rcfg_report } {
  set value 0
  if { $rx_enable && $pma_enable_rcfg_report } {
    set value 1
  }
  ip_set "parameter.${PROP_NAME}.value" $value
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_l_pma_optimal_settings { PROP_NAME PROP_M_AUTOSET } {
  if { $PROP_M_AUTOSET } {
    ip_set "parameter.${PROP_NAME}.value" true
  }
}

##############################
# Validate power_mode of Tx and Rx depending on speedgrade
# In ICD RBC, power_mode is user selectable and speedgrade depends on it. However, that does not work well with the IP usemodel where user selects speedgrade first and then the power mode.
# Therefore, writing a custom validation callback based on the speedgrade ICD RBC to check the other way
# Default value maintains the old optimistic value = high_perf
# NOTE: this function needs to be updated if ICD RBC rule changes
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_power_mode { PROP_NAME PROP_VALUE PROP_M_AUTOSET PROP_M_AUTOWARN pma_speedgrade } {
   set legal_values [list "high_perf" "mid_power" "low_power"]
  
   set illegal_values_for_high_perf [list "e1" "i1" "i2" "i3" "i4"]
   if { [lsearch $illegal_values_for_high_perf $pma_speedgrade] != -1  } {
      set legal_values [::ct1_xcvr_native::parameters::exclude $legal_values [list "high_perf"]]
   }

  if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.${PROP_NAME}.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         ip_message warning "The value of parameter anlg_voltage cannot be automatically resolved. Valid values are: ${legal_values}."
      }
   } else {
      auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values { pma_speedgrade }
   }
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_l_rx_pma_dfe_optimal_4to7 { l_rx_pma_optimal_settings rx_pma_adapt_dfe_fxtap_4to7 } {
  set value 0
  if { $l_rx_pma_optimal_settings || !$rx_pma_adapt_dfe_fxtap_4to7 } {
    set value 1
  }

  ip_set "parameter.l_rx_pma_dfe_optimal_4to7.value" $value
}


proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_l_rx_pma_dfe_optimal_8to11 { l_rx_pma_optimal_settings rx_pma_adapt_dfe_fxtap_8to11 } {
  set value 0
  if { $l_rx_pma_optimal_settings || !$rx_pma_adapt_dfe_fxtap_8to11 } {
    set value 1
  }

  ip_set "parameter.l_rx_pma_dfe_optimal_8to11.value" $value
}


