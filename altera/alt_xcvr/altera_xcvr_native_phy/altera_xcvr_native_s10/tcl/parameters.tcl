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


package provide altera_xcvr_native_s10::parameters 18.1

##############################
# Include package
##############################
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require ct1_xcvr_native::parameters
package require altera_xcvr_cdr_pll_s10::parameters
package require altera_xcvr_native_s10::parameters::data
package require altera_xcvr_native_s10::parameters::ct1_analog
package require altera_xcvr_native_s10::design_example
package require alt_xcvr::utils::reconfiguration_stratix10

##############################
# namespace declaration
##############################
namespace eval ::altera_xcvr_native_s10::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    get_variable \
    declare_parameters \
    validate

  variable package_name
  variable display_items
  variable display_items_group2
  variable parameters
  variable rcfg_parameters
  variable rapid_validation_parameters
  variable parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable static_hdl_parameters
  variable rcfg_report_filters
  variable design_example_parameters

  # The value of this variable is not intended to be changed, it is used to increase code readibility
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  set CONST_ALL_ONES_30_BITS_DECIMAL 1073741823
  set CONST_ALL_ONES_31_BITS_DECIMAL 2147483646

  # The value of this variable is not intended to be changed, it is used to share code accross functions
  variable CONST_DATAPATH_SELECT_MAPPING  

  # Initialize the variables
  set package_name "altera_xcvr_native_s10::parameters"
  set display_items [altera_xcvr_native_s10::parameters::data::get_variable "display_items"]
  set display_items_group2 [altera_xcvr_native_s10::parameters::data::get_variable "display_items_group2"]
  set parameters [altera_xcvr_native_s10::parameters::data::get_variable "parameters"]
  set rcfg_parameters [altera_xcvr_native_s10::parameters::data::get_variable "rcfg_parameters"]
  set rapid_validation_parameters [altera_xcvr_native_s10::parameters::data::get_variable "rapid_validation_parameters"]
  set static_hdl_parameters [altera_xcvr_native_s10::parameters::data::get_variable "static_hdl_parameters"]
  set parameter_overrides [altera_xcvr_native_s10::parameters::data::get_variable "parameter_overrides"]
  set parameter_mappings [altera_xcvr_native_s10::parameters::data::get_variable "parameter_mappings"]
  set parameter_multi_mappings [altera_xcvr_native_s10::parameters::data::get_variable "parameter_multi_mappings"]  
  set rcfg_report_filters [altera_xcvr_native_s10::parameters::data::get_variable "rcfg_report_filters"]   
  set design_example_parameters [altera_xcvr_native_s10::design_example::get_variable "design_example_parameters"]
}

##############################
# Get the namespace variable
#
# @arg var variable name
# @return Namespace variable for the given variable name
##############################
proc ::altera_xcvr_native_s10::parameters::get_variable { var } {
  variable display_items
  variable display_items_group2
  variable parameters
  variable rcfg_parameters
  variable parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable static_hdl_parameters
  variable rcfg_report_filters
  variable design_example_parameters

  return [set $var]
}

##############################
# IP upgrade callback
#
# @arg ip_name IP name
# @arg version IP version
# @arg old_params A list of old parameters
##############################
proc ::altera_xcvr_native_s10::parameters::upgrade {ip_name version old_params} {

  set new_params [get_upgraded_parameters $ip_name $version $old_params]

  # Special handling for multi-profile reconfiguration
  for {set i 0} {$i < 8} {incr i} {
    if {[dict exists $new_params "rcfg_profile_data${i}"]} {
      #puts "rcfg_profile_data${i} : [dict get $new_params "rcfg_profile_data${i}"]"
      dict set new_params "rcfg_profile_data${i}" [get_upgraded_parameters $ip_name $version [dict get $new_params "rcfg_profile_data${i}"]]
    }
  }

  # Set parameter values
  set declared_params [get_parameters]
  foreach {param value} $new_params {
    if { [lsearch $declared_params $param] != -1 } {
      ip_set "parameter.${param}.value" $value
    }
  }
}

##############################
# Update the list of parameters with new parameters
#
# @arg ip_name IP name
# @arg version IP version
# @arg old_params A list of old parameters
# @return A list of upgraded parameters
##############################
proc ::altera_xcvr_native_s10::parameters::get_upgraded_parameters {ip_name version old_params} {
  set new_params $old_params  
  # TODO: currently there is no parameter to be upgraded yet
  return $new_params
}

##############################
# Declare all the IP parameters 
#
# @arg device_family Device family
##############################
proc ::altera_xcvr_native_s10::parameters::declare_parameters { {device_family "Stratix 10"} } {
  variable display_items
  variable display_items_group2
  variable parameters
  variable rcfg_parameters
  variable rapid_validation_parameters
  variable design_example_parameters
  variable CONST_DATAPATH_SELECT_MAPPING  

  #------------------------------------------#
  # (1) Add user property type
  #------------------------------------------#
  ip_add_user_property_type M_RCFG_REPORT integer  
  ip_add_user_property_type M_AUTOSET boolean
  ip_add_user_property_type M_AUTOWARN boolean
  ip_add_user_property_type M_IGNORE boolean

  #------------------------------------------#
  # (2) Add parameters
  #------------------------------------------#  
  # Common reconfig parameters
  ::alt_xcvr::utils::reconfiguration_stratix10::declare_parameters 1

  ip_declare_parameters $parameters
  ip_declare_parameters $rcfg_parameters
  ip_declare_parameters $rapid_validation_parameters
  ip_declare_parameters $design_example_parameters
  #------------------------------------------#
  # Declare analog parameters (Expect a switch based on ct1 vs. ct2 at some point)
  #------------------------------------------#
  ::altera_xcvr_native_s10::parameters::ct1_analog::declare_ct1_analog_parameters

  # Native PHY parameters   
  ip_declare_parameters [::ct1_xcvr_native::parameters::get_parameters]
 
  #------------------------------------------#
  # (3) Add display items
  #------------------------------------------#
  ip_declare_display_items $display_items

  # Reconfig display items
  ::alt_xcvr::utils::reconfiguration_stratix10::declare_display_items "" tab 1

  ip_declare_display_items $display_items_group2

  #------------------------------------------#
  # (4) Overriding/Setting parameter properties
  #------------------------------------------#  
  override_parameter_properties $device_family
  ip_set parameter.rcfg_jtag_enable.VALIDATION_CALLBACK ::altera_xcvr_native_s10::parameters::validate_rcfg_jtag_enable

  #------------------------------------------#
  # (5) Initialize CONST_DATAPATH_SELECT_MAPPING from datapath_select.M_MAP_VALUES 
  #     This needs to happen after parameter override
  #------------------------------------------#
  set CONST_DATAPATH_SELECT_MAPPING [ip_get "parameter.datapath_select.M_MAP_VALUES" ]

  #------------------------------------------#
  # (6) Enable parameter mapping in the messaging package
  #------------------------------------------#
  ::alt_xcvr::ip_tcl::messages::set_mapping_enabled 1
  ::alt_xcvr::ip_tcl::messages::set_message_filter_criteria {}
  ::alt_xcvr::ip_tcl::messages::set_deferred_messaging 1
  ::alt_xcvr::ip_tcl::messages::set_trace_antecedentsAtErrorMessage_to_userSettableParameters_enable 1
  
  # we dont want following parameters to be displayed to user as antecedents in error messages, either because user cant change them or they are not very useful
  ip_set "parameter.base_device.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.message_level.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.duplex_mode.M_DONT_DISPLAY_IN_ERR_MSGS" true
  ip_set "parameter.enable_transparent_pcs.M_DONT_DISPLAY_IN_ERR_MSGS" true  

  #------------------------------------------#
  # (7) RAPID VALIDATION - This needs to happen at the end of parameter declaration and parameter property override
  #------------------------------------------#  
  ip_declare_parameter_dependencies rapid_non_derived_parameters_cache rapid_invalid_parameters_cache rapid_all_time_validated_parameters_cache 
  ip_declare_all_time_validated_parameters [ip_get_matching_parameters {M_ALWAYS_VALIDATE 1}]  
}

##############################
# Override properties of selected parameters
#
# @arg device_family Device family
##############################
proc ::altera_xcvr_native_s10::parameters::override_parameter_properties { device_family } {
  variable parameter_mappings
  variable parameter_multi_mappings
  variable parameter_overrides
  variable static_hdl_parameters
  variable rcfg_report_filters

  #------------------------------------------#
  # SYSTEM_INFO type parameters
  #------------------------------------------#
  ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
  ip_set "parameter.device_family.DEFAULT_VALUE" $device_family  
  ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT  
  ip_set "parameter.device.SYSTEM_INFO" DEVICE
  ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE

  set max_channels [::alt_xcvr::utils::device::get_device_family_max_channels $device_family]
  ip_set "parameter.channels.allowed_ranges" "1:$max_channels"
 
  #------------------------------------------#
  # Add M_AUTOSET attribute to all native phy parameters
  # Display native phy parameters with INI
  #------------------------------------------#
  set ct1_xcvr_native_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE ct1_xcvr_native]]
  foreach param $ct1_xcvr_native_parameters {
    ip_set "parameter.${param}.M_AUTOSET" 1
    ip_set "parameter.${param}.DISPLAY_ITEM" "Transceiver Attributes"
    ip_set "parameter.${param}.VISIBLE" [get_quartus_ini altera_xcvr_native_s10_debug ENABLED]
    ip_set "parameter.${param}.DERIVED" 1
    ip_set "parameter.${param}.ENABLED" 0
  }

  #------------------------------------------#
  # Marking HDL_PARAMETER and M_RCFG_REPORT property
  #------------------------------------------#  
  # Convert reconfig report filter list to dictionary  
  set rcfg_report_filters [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict $rcfg_report_filters]
  
  # Tag abstract parameters for inclusion in reconfiguration report files
  ip_set "parameter.pll_select.M_RCFG_REPORT" tx_enable
  ip_set "parameter.cdr_refclk_select.M_RCFG_REPORT" rx_enable

  # Mark which static HDL parameters need to be validated in the IP GUI because there are other parameters that depend on the values of these parameters 
  set enable_callback_static_hdl_params { \
		cdr_pll_f_min_ref \
		cdr_pll_f_max_ref \
		cdr_pll_f_min_vco \
		cdr_pll_f_max_vco \
		cdr_pll_f_min_pfd \
		cdr_pll_f_max_pfd \
		cdr_pll_f_min_gt_channel \
	}  

  set enable_callback_static_hdl_params_lookup {}
  convert_to_lookup_dict enable_callback_static_hdl_params_lookup $enable_callback_static_hdl_params

  foreach param $ct1_xcvr_native_parameters {    
    if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
      ip_set "parameter.${param}.HDL_PARAMETER" 1    

      # Set conditions for parameter inclusion in reconfiguration report files
      ip_set "parameter.${param}.M_RCFG_REPORT" 1
      dict for {filter prop} $rcfg_report_filters {
        set rcfg_report [::alt_xcvr::ip_tcl::ip_module::get_item_property $rcfg_report_filters $filter REPORT]
        if { [regexp $filter $param] } {
          ip_set "parameter.${param}.M_RCFG_REPORT" $rcfg_report
        }
      }
    } else {
		#------------------------------------------#
		# Disable validation callbacks for static hdl parameters except the ones listed in enable_callback_static_hdl_params
		#------------------------------------------#
		if { ![dict exists $enable_callback_static_hdl_params_lookup $param] }	{
			ip_set "parameter.${param}.VALIDATION_CALLBACK" "NOVAL"
		}		
	}
  }

  #------------------------------------------#
  # Provide parameter mappings from IP parameters to native transceiver parameters
  #------------------------------------------#
  ip_declare_parameters $parameter_mappings
  ip_declare_parameters $parameter_multi_mappings
  ip_declare_parameters $parameter_overrides
  ip_declare_parameters $static_hdl_parameters

  #------------------------------------------#
  # Provide parameter mappings for analog parameters
  #------------------------------------------#
  ::altera_xcvr_native_s10::parameters::ct1_analog::override_ct1_analog_parameters

  #------------------------------------------#
  # Set M_IGNORE property to conditionally hiding parameters
  #------------------------------------------#  
  # TODO: uncomment when crete data is available
  #  set filters {cdr_pll pma_rx_dfe pma_rx_odi pma_adapt pma_rx_deser pma_rx_buf}
  #  foreach filter $filters {
  #	set cr_params [lsearch -all -inline $ct1_xcvr_native_parameters "${filter}*" ]	
  #	foreach param $cr_params {    
  #		ip_set "parameter.${param}.M_IGNORE" "!l_crete_nf"
  #	}
  #  }
  #
  #  set cr2_params [lsearch -all -inline $ct1_xcvr_native_parameters "cr2*" ]
  #  foreach param $cr2_params {    	
  #	ip_set "parameter.${param}.M_IGNORE" "l_crete_nf"
  #  }

  #------------------------------------------#
  # Initialize reconfiguration profile header
  #------------------------------------------#
  set criteria [dict create M_USED_FOR_RCFG 1 DERIVED 0]
  set params [ip_get_matching_parameters $criteria]
  ip_set "parameter.rcfg_params.default_value" $params
  set labels {}
  foreach param $params {
    lappend labels [ip_get "parameter.${param}.display_name"]
  }
  ip_set "parameter.rcfg_param_labels.default_value" $labels

  #------------------------------------------#
  # Grab Quartus INI's
  #------------------------------------------#
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_s10_advanced ENABLED]
  ip_set "parameter.enable_internal_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_s10_internal ENABLED]
  ip_set "parameter.enable_debug_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_s10_debug ENABLED]
  ip_set "parameter.enable_physical_bonding_clocks.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_s10_enable_physical_bonding_clocks ENABLED]  
  ip_set "parameter.disable_reset_sequencer.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_native_s10_disable_reset_sequencer ENABLED]

  # INI control of rapid validation
  if { [get_quartus_ini altera_xcvr_native_s10_skip_rapid_validate ENABLED] == 1 } {
	ip_set "parameter.rapid_validate.DEFAULT_VALUE" 0
	ip_set "parameter.rapid_validate.VISIBLE" 0
	ip_set "parameter.rapid_validate.ENABLED" 0
  } else {
	ip_set "parameter.rapid_validate.VISIBLE" [get_quartus_ini altera_xcvr_native_s10_show_rapid_validate ENABLED]
	ip_set "parameter.rapid_validate.ENABLED" [get_quartus_ini altera_xcvr_native_s10_show_rapid_validate ENABLED]
  }

  #------------------------------------------#
  # Initialize validation_rule_select debug feature
  #------------------------------------------#
  declare_validation_rule_select 
}

##############################
# <Debug feature>
# Print unset parameters 
##############################
proc ::altera_xcvr_native_s10::parameters::check_for_unset_parameters {} {
  # Find all atom parameters that need setting
  dict set criteria VALIDATION_CALLBACK NOVAL
  dict set criteria M_IS_STATIC_HDL_PARAMETER false
  dict set criteria M_AUTOSET 1
  set params [ip_get_matching_parameters $criteria]
  foreach param $params {
    set allowed_ranges [ip_get "parameter.${param}.allowed_ranges"]
    if {[llength $allowed_ranges] > 1} {
      puts "${param} must be set! Options $allowed_ranges"
    }
  }
}

##############################
# <Debug feature>
# Declare validation rule select
##############################
proc ::altera_xcvr_native_s10::parameters::declare_validation_rule_select {} {
  set ini [get_quartus_ini altera_xcvr_native_s10_debug ENABLED]
  if { $ini == "true" || $ini == 1 } {
    set params [ip_get_matching_parameters {M_IP_CORE ct1_xcvr_native}]
    set validation_rule_list {}
    foreach param $params {
      if {[ip_get "parameter.${param}.VALIDATION_CALLBACK"] != "NOVAL"} {
	lappend validation_rule_list $param
      }
    }
    ip_set "parameter.validation_rule_select.allowed_ranges" $validation_rule_list
    ip_set "parameter.validation_rule_select.default_value" [lindex $validation_rule_list 0]
    set_parameter_update_callback validation_rule_select ::altera_xcvr_native_s10::parameters::validation_rule_select_callback
  }
}

##############################
# <Debug feature>
# Validation rule select callback - Display selected validation rule in IP GUI
##############################
proc ::altera_xcvr_native_s10::parameters::validation_rule_select_callback {} {
  set param [ip_get "parameter.validation_rule_select.value"]
  set callback [ip_get "parameter.${param}.VALIDATION_CALLBACK"]
  # Get the callback proc body
  set body [info body $callback]
  # Remove the non-rule stuff
  set index [string first "if \{ \$PROP_M_AUTOSET" $body]
  set body [string replace $body $index [string length $body]]
  set body [string trim $body]
  # Convert to HTML for multi-line
  set body "Rule for <b>${param}</b>:\n\n$body"
  set body [string map {"\n" "<br>"} $body]
  set body "<html>${body}</html>"
  ip_set "display_item.validation_rule_display.TEXT" $body
}

##############################
# Main validation function
##############################
proc ::altera_xcvr_native_s10::parameters::validate {} {
  set rapid_validate [ip_get "parameter.rapid_validate.value"]

  #------------------------------#
  # Check whether rapid validation is enabled via INI
  # Perform validation
  #------------------------------#
  ip_rapid_validate_parameters $rapid_validate [get_quartus_ini altera_xcvr_native_s10_skip_rapid_validate ENABLED]
  ip_validate_display_items
  ::altera_xcvr_native_s10::parameters::ct1_analog::update_analog_display_units
  ::alt_xcvr::ip_tcl::messages::issue_deferred_messages
}

##############################
# Convert list to simple lookup table
##############################
proc ::altera_xcvr_native_s10::parameters::convert_to_lookup_dict { lookup_dict_var lookup_list } {
	upvar $lookup_dict_var lookup_dict
	foreach item $lookup_list {
		dict set lookup_dict $item 1
	}
}

########################################################################################################################
#											Validation Callbacks
########################################################################################################################

##############################
# Set the message level
##############################
proc ::altera_xcvr_native_s10::parameters::validate_message_level { message_level } {
  ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]
}

##############################
# Set l_tx_transfer_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_tx_transfer_clk_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_tx_adapt_pcs_width l_tx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_tx_adapt_pcs_width)} ]	
  } 
 
  if { $l_tx_fifo_transfer_mode != "x1" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  ip_set "parameter.${PROP_NAME}.value" $temp_clk
}

##############################
# mapping for l_rx_transfer_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rx_transfer_clk_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_rx_adapt_pcs_width l_rx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
    set temp_clk [expr {wide(double($data_rate_bps)/$l_rx_adapt_pcs_width)} ]	
  } 
 
  if { $l_rx_fifo_transfer_mode != "x1" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  ip_set "parameter.${PROP_NAME}.value" $temp_clk
}

##############################
# Show the user the information message about the speed grade for the selected device
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pcs_speedgrade { pcs_speedgrade pma_speedgrade device } {
  set temp_pma_speed_grade [string range $pma_speedgrade 1 1];#dont show the operating temperature
  set temp_pcs_speed_grade [string range $pcs_speedgrade 1 1];#dont show the operating temperature
  
  # Quartus to ICD RBC mapping (leeping: commented this out unless marketing needs this special mapping again in the future for Nadder)
  #set temp_pcs_speed_grade [expr {$temp_pcs_speed_grade-1}];#local pcs speed grade is incremented version of what is selected in qsys by user, so what's shown to user is decremented
  auto_message info pcs_speedgrade "For the selected device($device), transceiver speed grade is $temp_pma_speed_grade and core speed grade is $temp_pcs_speed_grade."
}

##############################
# Validates the base_device of the selected device
##############################
proc ::altera_xcvr_native_s10::parameters::validate_device_revision { base_device } {
  set temp_device_revision [::ct1_xcvr_native::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
	  ip_set "parameter.device_revision.value" $temp_device_revision
  } else {
	set device [ip_get parameter.DEVICE.value]
	auto_message error device_revision "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}

##############################
# Validates whether simple interface can be enabled for current configuration
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_simple_interface { PROP_NAME PROP_VALUE datapath_select rcfg_iface_enable enable_double_rate_transfer enable_hip } {
  set legal_values [expr {$rcfg_iface_enable ? {0}
    : $enable_double_rate_transfer ? {0}
    : $datapath_select == "PCS Direct" ? {0 1}
    : $datapath_select == "Standard" && !$enable_hip ? {0 1}
    : $datapath_select == "Enhanced" ? {0 1}
    : { 0 } }]

  if {$PROP_VALUE} {
    auto_message info $PROP_NAME "Simplified data interface has been enabled. The Native PHY will present the data/control interface for the current configuration only. Dynamic reconfiguration of the data interface cannot be supported. The unused_tx_parallel_data and unused_tx_control ports should be connected to 0."
  }
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { datapath_select rcfg_iface_enable enable_double_rate_transfer}
}

##############################
# Validates whether to expose split interface option
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_split_interface { l_channels design_environment } {
  set enabled 0
  if {$design_environment != "QSYS" && $l_channels > 1} {
    set enabled 1
  }
  ip_set "parameter.enable_split_interface.enabled" $enabled
  ip_set "parameter.enable_split_interface.visible" $enabled
}

##############################
# Set enable_calibration to user setting in advanced mode and disable it otherwise
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_calibration { set_enable_calibration enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_enable_calibration : 1}]
  ip_set "parameter.enable_calibration.value" $value
}

##############################
# Set l_pcs_channel_hip_en
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_pcs_channel_hip_en { PROP_NAME enable_hip l_protocol_mode } {
	set value [expr { $l_protocol_mode == "disabled" ? 0 : $enable_hip }]
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set l_pcs_channel_enable_hard_reset
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_pcs_channel_enable_hard_reset { PROP_NAME enable_hard_reset l_protocol_mode } {
	set value [expr { $l_protocol_mode == "disabled" ? 0 : $enable_hard_reset }]
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set hip_cal_en to user setting
##############################
proc ::altera_xcvr_native_s10::parameters::validate_hip_cal_en { set_hip_cal_en enable_calibration } {
  set value [expr { $set_hip_cal_en && $enable_calibration ? "enable" : "disable"}]
  ip_set "parameter.hip_cal_en.value" $value
}

##############################
# Notify user that engineering mode is for internal use only
##############################
proc ::altera_xcvr_native_s10::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
  if {$PROP_VALUE == "engineering_mode"} {
    auto_message $message_level $PROP_NAME "Engineering support mode has been selected. Engineering mode is for internal use only. Altera does not officially support or guarantee IP configurations for this mode."
  } 
}

##############################
# Set the allowed_range for anlg_voltage
##############################
proc ::altera_xcvr_native_s10::parameters::ct1_analog::validate_anlg_voltage { PROP_VALUE enable_advanced_options } {
	if {$enable_advanced_options || $PROP_VALUE == "0_9V" } {
		set allowed_ranges {1_1V 1_0V 0_9V}
	} else {
		set allowed_ranges {1_1V 1_0V}
	}
	ip_set "parameter.anlg_voltage.allowed_ranges" $allowed_ranges
}

##############################
# Set the allowed ranges for protocol mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_protocol_mode { support_mode enable_channel_powerdown } {
  set std_ranges {"basic_std:Basic/Custom (Standard PCS)" \
		  "basic_std_rm:Basic/Custom w/Rate Match (Standard PCS)" \
		  "cpri:CPRI (Auto)" \
		  "cpri_rx_tx:CPRI (Manual)" \
		  "gige:GbE" \
		  "gige_1588:GbE 1588" \
		  "pipe_g1:Gen 1 PIPE" \
		  "pipe_g2:Gen 2 PIPE" \
		  "pipe_g3:Gen 3 PIPE" }

  set enh_ranges {"basic_enh:Basic (Enhanced PCS)" \
		  "interlaken_mode:Interlaken" \
		  "teng_baser_mode:10GBASE-R" \
		  "teng_1588_mode:10GBASE-R 1588" \
		  "teng_baser_krfec_mode:10GBASE-R w/KR FEC" \
		  "fortyg_basekr_krfec_mode:40GBASE-R w/KR FEC" \
		  "basic_krfec_mode:Basic w/KR FEC" }


  set allowed_ranges [concat $std_ranges $enh_ranges {"pcs_direct: PCS Direct"}]
  if {$support_mode == "engineering_mode"} {
    set allowed_ranges [concat $allowed_ranges {"teng_1588_krfec_mode:10GBASE-R 1588 w/KR FEC"}]
  }

  if {$enable_channel_powerdown} {
	set allowed_ranges [concat {"disabled:Disabled"} $allowed_ranges]
  }

  ip_set "parameter.protocol_mode.allowed_ranges" $allowed_ranges
}

##############################
# Validate l_release_aib_reset_first
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_release_aib_reset_first { PROP_NAME l_protocol_mode enh_pld_pcs_width } {
	if { $l_protocol_mode == "interlaken_mode" ||  $l_protocol_mode == "teng_baser_mode" \
			|| $l_protocol_mode == "teng_1588_mode" || $l_protocol_mode == "teng_baser_krfec_mode" \
			|| $l_protocol_mode == "fortyg_basekr_krfec_mode" || $l_protocol_mode == "basic_krfec_mode" } {
		set value [expr {$enh_pld_pcs_width != "67"}]
	} else {
		set value 1
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Validate PMA mode
#	SATA can be selected only if protocol_mode is basic_std
#	GPON can be selected only if protocol_mode is basic_std or basic_enh
#	QPI can be selected only if protocol_mode is pcs_direct
#	basic can be selected with all protocol_mode selections without any restrictions
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_mode { PROP_NAME PROP_VALUE protocol_mode } {
  set legal_values { "basic" "SATA" "QPI" "GPON" }

  set legal_values [expr { $protocol_mode == "basic_std"       ? { "basic" "SATA" "GPON" }
			 : $protocol_mode == "basic_enh"       ? { "basic" "GPON" }
			 : $protocol_mode == "pcs_direct"      ? { "basic" "QPI" }
			 : "basic" }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { protocol_mode }
}

##############################
# Disable PCS chanel if protocol mode is set to disabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_pcs_channel { PROP_NAME protocol_mode } {
	set value [expr {$protocol_mode == "disabled" ? 0 : 1}]
	ip_set parameter.${PROP_NAME}.value $value
}

##############################
# Disable PMA chanel if pma mode is set to disabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_pma_channel { PROP_NAME protocol_mode } {
	set value [expr {$protocol_mode == "disabled" ? 0 : 1}]
	ip_set parameter.${PROP_NAME}.value $value
}

##############################
# Enable frequency rules by default except when channel is powered down
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_frequency_rules { PROP_NAME protocol_mode } {
	set value [expr {$protocol_mode == "disabled" ? 0 : 1}]
	ip_set parameter.${PROP_NAME}.value $value
}

##############################
# Validate duplex_mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_duplex_mode { duplex_mode protocol_mode } {
  set legal_values [expr {$protocol_mode == "basic_std_rm" \
      || $protocol_mode == "gige" \
      || $protocol_mode == "pipe_g1" \
      || $protocol_mode == "pipe_g2" \
      || $protocol_mode == "pipe_g3" ? "duplex"
    : {duplex tx rx} }]

  auto_invalid_value_message auto duplex_mode $duplex_mode $legal_values {protocol_mode}
}

##############################
# Set l_tx_fifo_transfer_mode based on datapath, protocol mode, data width, byte serializer and double rate transfer setting
# Notify user of the TX FIFO transfer mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_tx_fifo_transfer_mode { PROP_NAME tx_enable hip_mode datapath_select protocol_mode std_pcs_pma_width std_tx_byte_ser_mode l_tx_adapt_pcs_width enable_double_rate_transfer } {
	if { $hip_mode == "disable_hip" } {
		if { $enable_double_rate_transfer } {
			set value "x1x2"
		} elseif { $datapath_select == "Standard" } {			
			set value [ expr { ($protocol_mode == "pipe_g3") ? "x2" 
								:(($std_pcs_pma_width > 10) && ($std_tx_byte_ser_mode == "Serialize x2")) ? "x2" 
								: "x1" } ]
		} else {
			set value [ expr { ($l_tx_adapt_pcs_width > 40) ? "x2"	: "x1" } ]	
		}
	} else {
		set value [ expr { ($hip_mode == "user_chnl") ? "x2" : "x1" } ]
	}	
	ip_set "parameter.${PROP_NAME}.value" $value
	
	if {$tx_enable} {
		set fifo_mode_str [::alt_xcvr::ip_tcl::messages::get_param_display_value l_tx_fifo_transfer_mode $value]
		auto_message info $PROP_NAME "The TX PCS-Core Interface FIFO is operating in $fifo_mode_str transfer mode."	
	}
}

##############################
# Set l_rx_fifo_transfer_mod based on datapath, protocol mode, data width, byte serializer and double rate transfer setting
# Notify user of the RX FIFO transfer mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rx_fifo_transfer_mode { PROP_NAME rx_enable hip_mode datapath_select protocol_mode std_pcs_pma_width std_rx_byte_deser_mode l_rx_adapt_pcs_width enable_double_rate_transfer } {
	if { $hip_mode == "disable_hip" } {
		if { $enable_double_rate_transfer } {
			set value "x1x2"
		} elseif { $datapath_select == "Standard" } {			
			set value [ expr { ($protocol_mode == "pipe_g3") ? "x2" 
								:(($std_pcs_pma_width > 10) && ($std_rx_byte_deser_mode == "Deserialize x2")) ? "x2" 
								: "x1" } ]
		} else {
			set value [ expr { ($l_rx_adapt_pcs_width > 40) ? "x2"	: "x1" } ]	
		}
	} else {
		set value [ expr { ($hip_mode == "user_chnl") ? "x2" : "x1" } ]
	}	
	ip_set "parameter.${PROP_NAME}.value" $value	
	
	if {$rx_enable} {
		set fifo_mode_str [::alt_xcvr::ip_tcl::messages::get_param_display_value l_rx_fifo_transfer_mode $value]
		auto_message info $PROP_NAME "The RX PCS-Core Interface FIFO is operating in $fifo_mode_str transfer mode."
	}
}

##############################
# Validate the format of user-entered datarate and give error on illegal format
# Notify user of the datarate to be set in the GUI for PIPE-Gen3 protocol 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_data_rate { set_data_rate protocol_mode} {

  if {![string is double $set_data_rate]} {
    auto_message error set_data_rate "[ip_get "parameter.set_data_rate.display_name"] \"$set_data_rate\" is improperly formatted. Should be ###.##."
  }
  
  if {$protocol_mode == "pipe_g3"} {
    auto_message info set_data_rate "When \"[ip_get "parameter.protocol_mode.display_name"]\" is set to \"Gen 3 PIPE\", the \"[ip_get "parameter.set_data_rate.display_name"]\" for the Standard PCS should be set for the power-on configuration of Gen1 PIPE. Under the hood, the \"[ip_get "parameter.set_data_rate.display_name"]\" for the Gen 3 PCS is set as 8000Mbps which is not reflected in the GUI."
  }
}

##############################
# Some RBC rules regarding bonding are found in the six-pack or subsystem level rules which
# we cannot automatically consume. We manually create them here.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_bonded_mode { enable_hip bonded_mode protocol_mode l_enable_std_pipe channels } {
  if {$enable_hip} {
	set legal_values {"not_bonded" "pma_only" "pma_pcs"}
  } else {
	  set legal_values [expr { $l_enable_std_pipe && $channels > 1 ? "pma_pcs"
		: {"not_bonded" "pma_only" "pma_pcs"} }]
  }
  auto_invalid_value_message auto bonded_mode $bonded_mode $legal_values { protocol_mode channels }
}

##############################
# Set l_enable_pcs_bonding based on bonded_mode and 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_pcs_bonding { PROP_NAME tx_enable bonded_mode enable_manual_bonding_settings manual_pcs_bonding_mode } {
	if {!$tx_enable} {
		set value 0
	} elseif {$enable_manual_bonding_settings} {
		set value [expr { $manual_pcs_bonding_mode == "individual" ? 0 : 1}]
	} else {
		set value [expr { $bonded_mode == "pma_pcs" ? 1 : 0 } ]
	}

	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set l_enable_hssi_adapt_tx_indv based on:
#   manual bonding settings ON - manual_tx_hssi_aib_indv
#   manual bonding settings OFF -  AIB bonding mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_tx_hssi_aib_indv { PROP_NAME enable_manual_bonding_settings manual_tx_hssi_aib_indv hssi_adapt_tx_chnl_bonding l_tx_transfer_clk_hz } {
	if {$enable_manual_bonding_settings} {
		set value $manual_tx_hssi_aib_indv
	} elseif {$hssi_adapt_tx_chnl_bonding == "enable"} {
		set freq_limit "500000000"
		set value [expr { $l_tx_transfer_clk_hz > $freq_limit ? "indv_en" : "indv_dis" }]
	} else {
		set value "indv_en"
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set l_enable_hssi_pldadapt_tx_indv based on:
#   manual bonding settings ON - manual_tx_core_aib_indv
#   manual bonding settings OFF -  AIB bonding mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_tx_core_aib_indv { PROP_NAME pcs_speedgrade_no_temp enable_manual_bonding_settings manual_tx_core_aib_indv hssi_pldadapt_tx_chnl_bonding l_tx_transfer_clk_hz tx_fifo_mode} {	
	if {$enable_manual_bonding_settings} {
		set value $manual_tx_core_aib_indv
	} elseif { ($hssi_pldadapt_tx_chnl_bonding == "enable") && ($tx_fifo_mode == "Phase compensation" || $tx_fifo_mode == "Interlaken") } {	
		set freq_limit [expr { ($pcs_speedgrade_no_temp == "1") ? "938000000" 
								: ($pcs_speedgrade_no_temp == "2") ? "782000000"
								: "600000000" }]
		set value [expr { $l_tx_transfer_clk_hz > $freq_limit ? "indv_en" : "indv_dis" }]
	} else {
		set value "indv_en"
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set l_enable_hssi_adapt_rx_indv based on:
#   manual bonding settings ON - manual_rx_hssi_aib_indv
#   manual bonding settings OFF -  AIB bonding mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rx_hssi_aib_indv { PROP_NAME enable_manual_bonding_settings manual_rx_hssi_aib_indv hssi_adapt_rx_chnl_bonding l_rx_transfer_clk_hz } {
	if {$enable_manual_bonding_settings} {
		set value $manual_rx_hssi_aib_indv
	} elseif {$hssi_adapt_rx_chnl_bonding == "enable"} {
		set freq_limit "500000000"
		set value [expr { $l_rx_transfer_clk_hz > $freq_limit ? "indv_en" : "indv_dis" }]
	} else {
		set value "indv_en"
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set l_enable_hssi_pldadapt_rx_indv based on:
#   manual bonding settings ON - manual_rx_core_aib_indv
#   manual bonding settings OFF -  AIB bonding mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rx_core_aib_indv { PROP_NAME enable_manual_bonding_settings manual_rx_core_aib_indv hssi_pldadapt_rx_chnl_bonding l_rx_transfer_clk_hz } {
	if {$enable_manual_bonding_settings} {
		set value $manual_rx_core_aib_indv
	} elseif {$hssi_pldadapt_rx_chnl_bonding == "enable"} {
		set freq_limit "500000000"
		set value [expr { $l_rx_transfer_clk_hz > $freq_limit ? "indv_en" : "indv_dis" }]
	} else {
		set value "indv_en"
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Enable bonding master selection only if PCS bonding is enabled. This option is hidden if user enables manual PCS bonding settings
# When bonding is enabled, user can pick any channel to be the master channel or let IP auto-assign the master channel
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_pcs_bonding_master { set_pcs_bonding_master tx_enable channels l_channels l_enable_pcs_bonding } {
  set range {"Auto"}
  for {set x 0} {$x < $l_channels} {incr x} {
    lappend range $x
  }

  set legal_values [expr { !$l_enable_pcs_bonding ? $set_pcs_bonding_master : $range }]
  auto_invalid_value_message error set_pcs_bonding_master $set_pcs_bonding_master $legal_values { channels l_enable_pcs_bonding }

  ip_set "parameter.set_pcs_bonding_master.allowed_ranges" $range  
}

##############################
# Set the PCS bonding master when manual PCS bonding settings is disabled
#	1) Non bonded channel - 0
#	2) Bonded channel - user selected master channel or middle channel if user picks "Auto"
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pcs_bonding_master { tx_enable l_channels bonded_mode set_pcs_bonding_master } {
  set value [expr { !$tx_enable || ($bonded_mode != "pma_pcs") ? 0
    : $set_pcs_bonding_master == "Auto" ?  ($l_channels / 2)
	: $set_pcs_bonding_master }]

  ip_set "parameter.pcs_bonding_master.value" $value
}

##############################
# Validate PCS reset sequencing mode
#   PMA and PCS bonding - bonded
#   Others - bonded or not_bonded
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pcs_reset_sequencing_mode { PROP_NAME PROP_VALUE bonded_mode } {
  set legal_values [expr { ($bonded_mode == "pma_pcs") ? "bonded" : {"bonded" "not_bonded"} }]
   auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { bonded_mode }
}

##############################
# Notify user of the correct output clock frequency to be configured in the external TX PLL IP
##############################
proc ::altera_xcvr_native_s10::parameters::validate_display_base_data_rate { set_data_rate tx_pma_clk_div tx_enable protocol_mode} {
  if {[string is double $set_data_rate]} {
    set pll_clk_frequency [expr {double($set_data_rate * $tx_pma_clk_div) / 2}]
    # if protocol mode is pipe_g1 the cgb will have a divide by 2 enabled (see FB:151614)
    set pll_clk_frequency [expr {$protocol_mode=="pipe_g1"? (2*$pll_clk_frequency): $pll_clk_frequency}]

    set message "<html><font color=\"blue\">Note - </font>The external TX PLL IP must be configured with an output clock frequency of <b>${pll_clk_frequency} MHz.</b></html>"
    if {$tx_enable} {
      ip_message info $message
    }
  } else {
    set message ""
  }
  ip_set "display_item.display_base_data_rate.text" $message
}

##############################
# Notify user to configure PMA configuration rules to QPI if use of QPI ports are desired
##############################
proc ::altera_xcvr_native_s10::parameters::validate_display_qpi_rule {} {
	set message "<html><font color=\"blue\">Note - </font>The PMA configuration rules must be configured to <b>QPI</b> if the use of QPI signals is desired.</html>"
	ip_set "display_item.display_qpi_rule.text" $message
}

##############################
# Populate the allowed ranges for TX PLL input clock selection from the number of TX PLL clock inputs
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pll_select { tx_enable plls pll_select } {
  set allowed_ranges {}
  if {!$tx_enable} {
    set allowed_ranges [list $pll_select]
  } else {
    for {set i 0} {$i < $plls} {incr i} {
      lappend allowed_ranges $i
    }
  }

  ip_set "parameter.pll_select.allowed_ranges" $allowed_ranges
}

##############################
# Gray out rx_pma_dfe_fixed_taps if adaptation mode is set to "disabled"
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rx_pma_dfe_fixed_taps { PROP_NAME rx_pma_dfe_adaptation_mode rx_enable} {
  if {$rx_pma_dfe_adaptation_mode=="disabled" || !$rx_enable} {
    ip_set "parameter.${PROP_NAME}.enabled" 0
  } else {
    ip_set "parameter.${PROP_NAME}.enabled" 1
  }
  ip_set "parameter.${PROP_NAME}.visible" $rx_enable
}

##############################
# Set enable_tx_optimal_settings 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_tx_optimal_settings { PROP_NAME tx_enable l_enable_pma_channel } {
	set value [expr { ($tx_enable && $l_enable_pma_channel) ? 1 : 0 }]
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set enable_rx_optimal_settings 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_rx_optimal_settings { PROP_NAME rx_enable l_enable_pma_channel } {
	set value [expr { ($rx_enable && $l_enable_pma_channel) ? 1 : 0 }]
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Only allow tx_pma_qpipullup port in duplex mode
# If the user enable the port in duplex mode and switch to rx mode later, the option would dissapear while the error is there.
# The workaround is to allow 1 for rx and terminate the port in interfaces.tcl for rx mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_pma_qpipullup { PROP_NAME PROP_VALUE duplex_mode } { 
  set legal_values [expr {$duplex_mode == "tx" ? 0 : {0 1} }]
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {duplex_mode}
}

##############################
# Only allow tx_pma_qpipulldn in duplex mode
# If the user enable the port in duplex mode and switch to rx mode later, the option would dissapear while the error is there.
# The workaround is to allow 1 for rx and terminate the port in interfaces.tcl for rx mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_pma_qpipulldn { PROP_NAME PROP_VALUE duplex_mode } {
  set legal_values [expr {$duplex_mode == "tx" ? 0
  : {0 1} }]
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {duplex_mode}
}

##############################
# Only allow tx_pma_txdetectrx in duplex mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_pma_txdetectrx { enable_port_tx_pma_txdetectrx duplex_mode } { 
  set legal_values [expr {$duplex_mode == "tx" ? 0
  : {0 1} }]
  auto_invalid_value_message auto enable_port_tx_pma_txdetectrx $enable_port_tx_pma_txdetectrx $legal_values {duplex_mode}
}

##############################
# Only allow tx_pma_rxfound in duplex mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_pma_rxfound { PROP_NAME PROP_VALUE duplex_mode } {  
  set legal_values [expr {$duplex_mode == "tx" ? 0 : {0 1} }]
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {duplex_mode}
}

##############################
# Only allow rx_pma_qpipulldn in duplex mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_pma_qpipulldn { PROP_NAME PROP_VALUE duplex_mode } {  
  set legal_values [expr {$duplex_mode == "tx" ? 0 : {0 1} }]
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {duplex_mode}
}

##############################
# Only allow QPI mode in duplex mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_qpi_mode { PROP_NAME PROP_VALUE duplex_mode } {
	set legal_values [ expr { $duplex_mode == "tx" ? 0 : {0 1} } ]
	auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {duplex_mode}
}

##############################
# Populate the allowed ranges for cdr_refclk_select (CDR reference clock selection) from cdr_refclk_cnt (Number of CDR reference clocks)
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_refclk_select { cdr_refclk_cnt } {
  set allowed_ranges {}
  for {set i 0} {$i < $cdr_refclk_cnt} {incr i} {
    lappend allowed_ranges $i
  }

  ip_set "parameter.cdr_refclk_select.allowed_ranges" $allowed_ranges
}

##############################
# Compute and set the PLL settings
# The computed PLL settings contain a mapping from legal reference clock frequencies to corresponding PLL settings
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_pll_settings { PROP_NAME device_revision rx_enable l_enable_pma_channel set_data_rate l_enable_std_pipe cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref pma_rx_buf_pm_cr_rx_path_prot_mode} {

  if {$l_enable_pma_channel && $rx_enable && [string is double $set_data_rate]} {
    set l_pll_settings [dict create]

    set allowed_ranges {}
    set pcie_mode [expr {$l_enable_std_pipe ? $pma_rx_buf_pm_cr_rx_path_prot_mode : "non_pcie"}]
    set values [::altera_xcvr_cdr_pll_s10::parameters::compute_cdr_pll_settings $device_revision [expr double($set_data_rate) / 2] "CDR" $pcie_mode $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd $cdr_pll_f_max_vco $cdr_pll_f_min_vco $cdr_pll_f_max_ref $cdr_pll_f_min_ref "mid_bw"]

    dict for {key value} $values {
      set refclk [dict get $value "refclk"]

      if {[lsearch $allowed_ranges $refclk] == -1} {
		lappend allowed_ranges $refclk
		dict set l_pll_settings $refclk [dict get $value]
      }
    }

    set allowed_ranges [lsort -real -unique $allowed_ranges]
    dict set l_pll_settings "allowed_ranges" $allowed_ranges

    ip_set "parameter.${PROP_NAME}.value" $l_pll_settings
  } else {
    ip_set "parameter.${PROP_NAME}.value" "NOVAL"
  }
}

##############################
# Retrieve the PLL settings for user entered reference clock frequency and set it to l_pll_settings_key
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_pll_settings_key { set_cdr_refclk_freq l_pll_settings } {
  set l_pll_settings_key "NOVAL"

  if {$l_pll_settings != "NOVAL"} {
    set allowed_ranges [dict get $l_pll_settings "allowed_ranges"]
    set idx [lsearch -real -sorted $allowed_ranges $set_cdr_refclk_freq]
    if {$idx != -1} {
      set l_pll_settings_key [lindex $allowed_ranges $idx]
    }
  }

  ip_set "parameter.l_pll_settings_key.value" $l_pll_settings_key
}

##############################
# Set l_enable_pma_bonding to 1 if TX channels are in bonded mode, 0 otherwise
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_pma_bonding { tx_enable bonded_mode } {
  set value [expr { !$tx_enable || ($bonded_mode == "not_bonded") ? 0
    : 1 }]

  ip_set "parameter.l_enable_pma_bonding.value" $value
}

##############################
# Validation for the set_cdr_refclk_freq (CDR reference clock frequency) parameter
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_cdr_refclk_freq { set_cdr_refclk_freq l_pll_settings device_family message_level } {
  set allowed_ranges {}

  if {$l_pll_settings != "NOVAL"} {

    set allowed_ranges [dict get $l_pll_settings "allowed_ranges"]

    # Issue message if current selected value is illegal
    set idx [lsearch -real -sorted $allowed_ranges $set_cdr_refclk_freq]
    if {$idx == -1} {
	  ip_invalid_param_message $message_level "The selected CDR reference clock frequency \"$set_cdr_refclk_freq\" is invalid. Please select a valid CDR reference clock frequency or choose a different data rate." set_cdr_refclk_freq
      lappend allowed_ranges $set_cdr_refclk_freq
    } elseif { [string compare [lindex $allowed_ranges $idx] $set_cdr_refclk_freq] != 0 } {
      lappend allowed_ranges $set_cdr_refclk_freq
    }
  } else {
      lappend allowed_ranges $set_cdr_refclk_freq
  }

  ip_set "parameter.set_cdr_refclk_freq.allowed_ranges" $allowed_ranges
}

##############################
# Setup allowed_ranges for rx_ppm_detect_threshold based on protocol_mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rx_ppm_detect_threshold { enable_channel_powerdown } {
	set allowed_ranges {100 300 500 1000}
	 if { $enable_channel_powerdown } {
		set allowed_ranges [concat {other} $allowed_ranges]
	}
	ip_set "parameter.rx_ppm_detect_threshold.allowed_ranges" $allowed_ranges
}

##############################
# Notify user not to use pma_div_clkout for parallel data transfer in register mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_tx_clkout_sel { PROP_NAME PROP_VALUE tx_enable } {
  if {$tx_enable && $PROP_VALUE == "pma_div_clkout"} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    auto_message info $PROP_NAME "\"pma_div_clkout\" is selected to drive tx_clkout port and it should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

##############################
# Notify user not to use pma_div_clkout for parallel data transfer in register mode
# Validate that tx_clkout2_sel is set to "pcs_x2_clkout" if we need this clock to feed the tx_coreclkin2 port when bonding is enabled.
#   Todo: Change warning to error after we integrated the RBC changes 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_tx_clkout2_sel { PROP_NAME PROP_VALUE tx_enable enable_port_tx_clkout2 l_enable_pcs_bonding hssi_pldadapt_tx_fifo_rd_clk_sel hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting } {
  if { $tx_enable && $enable_port_tx_clkout2 } {
	if { ($hssi_pldadapt_tx_fifo_rd_clk_sel == "fifo_rd_pld_tx_clk2") && $l_enable_pcs_bonding && ($hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting != "x2_not_from_chnl") } {
		set legal_values {"pcs_x2_clkout"}
	} else {
		set legal_values {"pcs_clkout" "pcs_x2_clkout" "pma_div_clkout"}
	}	
    auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values {l_enable_pcs_bonding tx_fifo_mode}

	if { $PROP_VALUE == "pma_div_clkout" } {
		set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
		auto_message info $PROP_NAME "\"pma_div_clkout\" is selected to drive tx_clkout2 port and it should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
	}
  }
}

##############################
# Notify user not to use pma_div_clkout for parallel data transfer in register mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rx_clkout_sel { PROP_NAME PROP_VALUE rx_enable } {
  if {$rx_enable && $PROP_VALUE == "pma_div_clkout"} {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    auto_message info $PROP_NAME "\"pma_div_clkout\" is selected to drive rx_clkout port and it should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

##############################
# Notify user not to use pma_div_clkout for parallel data transfer in register mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rx_clkout2_sel { PROP_NAME PROP_VALUE rx_enable enable_port_rx_clkout2 } {
  if { $rx_enable && $enable_port_rx_clkout2 && ($PROP_VALUE == "pma_div_clkout") } {
    set temp_str "[ip_get "parameter.${PROP_NAME}.display_name"]"
    auto_message info $PROP_NAME "\"pma_div_clkout\" is selected to drive rx_clkout2 port and it should not be used for register mode data transfers (Relevant parameter: \"${temp_str}\" (${PROP_NAME}))."
  }
}

##############################
# Set l_enable_tx_pma_div_clkout to 1 if pma_div_clkout is selected to drive any of tx_clkout or tx_clkout2
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_tx_pma_div_clkout { tx_clkout_sel enable_port_tx_clkout2 tx_clkout2_sel } {
	set value [ expr { ($tx_clkout_sel == "pma_div_clkout") ? 1 
	:  ($enable_port_tx_clkout2 && ($tx_clkout2_sel == "pma_div_clkout")) ? 1 
	:  0 } ]
	ip_set "parameter.l_enable_tx_pma_div_clkout.value"	$value
}

##############################
# Set l_enable_rx_pma_div_clkout to 1 if pma_div_clkout is selected to drive any of rx_clkout or rx_clkout2
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_rx_pma_div_clkout { rx_clkout_sel enable_port_rx_clkout2 rx_clkout2_sel } {
	set value [ expr { ($rx_clkout_sel == "pma_div_clkout") ? 1 
	:  ($enable_port_rx_clkout2 && ($rx_clkout2_sel == "pma_div_clkout")) ? 1 
	:  0 } ]
	ip_set "parameter.l_enable_rx_pma_div_clkout.value"	$value
}

##############################
# Validate the device variant
# todo: default to crete_nf for now
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_crete_nf { PROP_NAME device_revision } {
	ip_set "parameters.${PROP_NAME}.value" 1
}

##############################
# Validate the number of channels entered by user
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_channels { channels device_family } {
  set l_channels 1
  if {[string is integer $channels]} {
    #set dev_max_channels [::alt_xcvr::utils::device::get_device_family_max_channels $device_family]
	set max_channels "24"
  
    if {$channels > 0 && $channels <= $max_channels} {
      set l_channels $channels
    } else {
		auto_invalid_value_message auto channels $channels "1:$max_channels" {}
	}
  }
  ip_set "parameter.l_channels.value" $l_channels
}

##############################
# When there are more than 1 channel, set l_split_interface to 1 by default in QSYS, otherwise, follow user selection
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_split_iface { design_environment enable_split_interface l_channels} {
  set value 0
  if { $l_channels > 1 } {
    # If QSYS and more than 1 channel we have to split the interfaces
    if {$design_environment == "QSYS"} {
      set value 1
    } else {
      set value $enable_split_interface
    }
  }
  ip_set "parameter.l_split_iface.value" $value
}

##############################
# Set l_pcs_pma_width according to selected datapath
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_pcs_pma_width { datapath_select std_pcs_pma_width enh_pcs_pma_width pcs_direct_width} {
  set value [ expr { $datapath_select == "Standard" ? $std_pcs_pma_width
    : $datapath_select == "Enhanced" ? $enh_pcs_pma_width
    : $pcs_direct_width } ]

  ip_set "parameter.l_pcs_pma_width.value" $value
}

##############################
# Set l_tx_adapt_pcs_width (TX adapter-PCS interface width) according to selected datapath
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_tx_adapt_pcs_width { datapath_select l_std_tx_pld_pcs_width enh_pld_pcs_width pcs_direct_width } {
  set value [ expr {  $datapath_select == "Standard" ? $l_std_tx_pld_pcs_width
		   : $datapath_select == "Enhanced" ? $enh_pld_pcs_width
		   : $pcs_direct_width } ]
  ip_set "parameter.l_tx_adapt_pcs_width.value" $value
}

##############################
# Set l_rx_adapt_pcs_width (RX adapter-PCS interface width) according to selected datapath
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rx_adapt_pcs_width { datapath_select l_std_rx_pld_pcs_width enh_pld_pcs_width pcs_direct_width } {
  set value [ expr {  $datapath_select == "Standard" ? $l_std_rx_pld_pcs_width
		   : ($datapath_select == "Enhanced") ? $enh_pld_pcs_width
		   : $pcs_direct_width } ]
  ip_set "parameter.l_rx_adapt_pcs_width.value" $value
}

##############################
# Set l_enable_tx_std parameter. Used to determine when Standard TX datapath is enabled.
##############################
# Validation for l_enable_tx_std parameter. Used to determine
# when Standard TX datapath is enabled.
#
# @arg tx_enable - Resolved value of the tx_enable parameter
# @arg enable_std - Resolved value of the enable_std parameter
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_tx_std { tx_enable enable_std } {
  ip_set "parameter.l_enable_tx_std.value" [expr $tx_enable && $enable_std]
}

##############################
# Validation for l_enable_rx_std parameter. Used to determine when Standard RX datapath is enabled.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_rx_std { rx_enable enable_std } {
  ip_set "parameter.l_enable_rx_std.value" [expr $rx_enable && $enable_std]
}

##############################
# Validation for l_enable_tx_enh parameter. Used to determine when 10G TX PCS is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_tx_enh { tx_enable enable_enh  } {
  ip_set "parameter.l_enable_tx_enh.value" [expr $tx_enable && $enable_enh ]
}

##############################
# Validation for l_enable_rx_enh parameter. Used to determine when 10G RX PCS is enabled.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_rx_enh { rx_enable enable_enh  } {
  ip_set "parameter.l_enable_rx_enh.value" [expr $rx_enable && $enable_enh ]
}

##############################
# Validation for l_enable_tx_pcs_dir parameter. Used to determine when TX PCS direct datpath is enabled.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_tx_pcs_dir { tx_enable enable_pcs_dir } {
  ip_set "parameter.l_enable_tx_pcs_dir.value" [expr $tx_enable && $enable_pcs_dir ]
}

##############################
# Validation for l_enable_rx_pcs_dir parameter. Used to determine when RX PCS direct datpath is enabled.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_rx_pcs_dir { rx_enable enable_pcs_dir } {
  ip_set "parameter.l_enable_rx_pcs_dir.value" [expr $rx_enable && $enable_pcs_dir ]
}

##############################
# Set the number of reconfig interfaces
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rcfg_ifaces { rcfg_shared l_channels } {
  ip_set "parameter.l_rcfg_ifaces.value" [expr { $rcfg_shared ? 1 : $l_channels }]
}

##############################
# Set the width of reconfig address
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rcfg_addr_bits { rcfg_shared l_channels } {
  set l_channels [expr {$l_channels-1}]
  set mux_bits [::alt_xcvr::utils::common::clogb2 $l_channels]
  ip_set "parameter.l_rcfg_addr_bits.value" [expr { $rcfg_shared ? 11+$mux_bits : 11 }]
}

##############################
# Enable "Standard PCS" tab when standard datapath is selected or when datapath and interface reconfiguration is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_std { datapath_select rcfg_iface_enable } {
  set value [expr {$datapath_select == "Standard" || $rcfg_iface_enable }]
  ip_set "parameter.enable_std.value" $value
}

##############################
# Enable "Enhanced PCS" tab when enhanced datapath is selected or when datapath and interface reconfiguration is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_enh  { datapath_select rcfg_iface_enable } {
  set enable_enh [expr {$datapath_select == "Enhanced" || $rcfg_iface_enable }]
  ip_set "parameter.enable_enh.value" $enable_enh
}

##############################
# Enable "PCS Direct" tab when PCS direct datapath is selected or when datapath and interface reconfiguration is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_pcs_dir  { datapath_select rcfg_iface_enable } {
  set enable_pcs_dir [expr {$datapath_select == "PCS Direct" || $rcfg_iface_enable }]
  ip_set "parameter.enable_pcs_dir.value" $enable_pcs_dir
}

#******************************************************************************
#        Standard PCS validation callbacks BEGIN
#******************************************************************************

##############################
# Set l_enable_std_pipe to 1 for PIPE mode 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_std_pipe { protocol_mode } {
  set value [expr {$protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" }]

  ip_set "parameter.l_enable_std_pipe.value" $value
}

##############################
# Set l_std_tx_pld_pcs_width based on PMA-PCS width and byte serializer settings 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_tx_pld_pcs_width { std_pcs_pma_width std_tx_byte_ser_mode } {
  set legal_value [expr { $std_tx_byte_ser_mode == "Serialize x2" ? [expr $std_pcs_pma_width * 2]
    : $std_tx_byte_ser_mode == "Serialize x4" && $std_pcs_pma_width <= 10 ? $std_pcs_pma_width * 4
    : $std_pcs_pma_width }]

  ip_set "parameter.l_std_tx_pld_pcs_width.value" $legal_value
}

##############################
# Set l_std_rx_pld_pcs_width based on PMA-PCS width and byte deserializer settings 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_rx_pld_pcs_width { std_pcs_pma_width std_rx_byte_deser_mode } {
  set legal_value [expr { $std_rx_byte_deser_mode == "Deserialize x2" ? [expr $std_pcs_pma_width * 2]
    : $std_rx_byte_deser_mode == "Deserialize x4" && $std_pcs_pma_width <= 10 ? [expr $std_pcs_pma_width * 4]
    : $std_pcs_pma_width }]

  ip_set "parameter.l_std_rx_pld_pcs_width.value" $legal_value
}

##############################
# Set the display value of TX adapter-PLD data width
##############################
proc ::altera_xcvr_native_s10::parameters::validate_display_std_tx_pld_adapt_width { l_std_tx_pld_pcs_width std_tx_8b10b_enable } {  
  set legal_value [expr { $std_tx_8b10b_enable ? [expr {$l_std_tx_pld_pcs_width * 4} / 5]
    : $l_std_tx_pld_pcs_width }]

  ip_set "parameter.display_std_tx_pld_adapt_width.value" $legal_value
}

##############################
# Set the display value of RX adapter-PLD data width
##############################
proc ::altera_xcvr_native_s10::parameters::validate_display_std_rx_pld_adapt_width { l_std_rx_pld_pcs_width std_rx_8b10b_enable } {
  set legal_value [expr { $std_rx_8b10b_enable ? [expr {$l_std_rx_pld_pcs_width * 4} / 5]
    : $l_std_rx_pld_pcs_width }]

  ip_set "parameter.display_std_rx_pld_adapt_width.value" $legal_value
}

##############################
# Validate that rx_std_bitrev port is enabled when RX bitslip is enabeld
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_std_bitrev_ena { PROP_NAME PROP_VALUE l_enable_rx_std std_rx_bitrev_enable } {
  set legal_values [expr { $std_rx_bitrev_enable && $l_enable_rx_std ? {1}
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_bitrev_enable}
}

##############################
# Validate that rx_std_byterev port is enabled when RX byte reversal is enabeld
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_std_byterev_ena { PROP_NAME PROP_VALUE l_enable_rx_std std_rx_byterev_enable } {
  set legal_values [expr { $std_rx_byterev_enable && $l_enable_rx_std ? {1}
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_byterev_enable}
}

##############################
# Validate that tx_std_bitslipboundarsel port is enabled when TX bitslip is enabeld
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_std_bitslipboundarysel { PROP_NAME PROP_VALUE l_enable_tx_std std_tx_bitslip_enable } {
  if { $l_enable_tx_std && $std_tx_bitslip_enable } {
    if { !$PROP_VALUE } {
      auto_message info $PROP_NAME "The \"tx_std_bitslipboundarysel\" port must be enabled if Standard PCS TX bitslip capability is desired."
    }
  }
}

##############################
# Notify user that when bitslip is enabled in word aligner, rx_std_bitslip port must be enabled.
# However, if low latency path is enabled for Standard PCS, rx_std_bitslip port has no effect.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_std_bitslip { PROP_NAME PROP_VALUE l_enable_rx_std std_rx_word_aligner_mode std_low_latency_bypass_enable } {
  if { $l_enable_rx_std && $std_rx_word_aligner_mode == "bitslip" } {
    if { $PROP_VALUE && $std_low_latency_bypass_enable } {
      auto_message info $PROP_NAME "The enabled <b>\"rx_std_bitslip\"</b> port has no effect when parameter [::alt_xcvr::ip_tcl::messages::get_parameter_display_string std_low_latency_bypass_enable ] is set to [::alt_xcvr::ip_tcl::messages::get_value_display_string std_low_latency_bypass_enable $std_low_latency_bypass_enable]."
    } elseif { !$PROP_VALUE && !$std_low_latency_bypass_enable } {
      auto_message info $PROP_NAME "The \"rx_std_bitslip\" port must be enabled if Standard PCS RX bitslip capability is desired."
    }
  }
}

##############################
# Validate that tx_polinv port is enabled when TX polarity inversion is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_polinv { PROP_NAME PROP_VALUE l_enable_tx_std std_tx_polinv_enable } {
  set legal_values [expr {$std_tx_polinv_enable && $l_enable_tx_std ? 1
      : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_tx_polinv_enable}
}

##############################
# Validate that rx_polinv port is enabled when RX polarity inversion is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_polinv { PROP_NAME PROP_VALUE l_enable_rx_std std_rx_polinv_enable } {
  set legal_values [expr {$std_rx_polinv_enable && $l_enable_rx_std ? 1
      : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {std_rx_polinv_enable}
}

##############################
# Validate that pipe_sw port is enabled for PIPE Gen2/3 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_ports_pipe_sw { PROP_NAME PROP_VALUE protocol_mode } {
  set legal_values [expr {$protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}

##############################
# Validate that pipe_hclk port is enabled for PIPE mode 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_ports_pipe_hclk { PROP_NAME PROP_VALUE l_enable_std_pipe protocol_mode } {
  set legal_values [expr {$l_enable_std_pipe ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}

##############################
# Validate that TX equalization ports (e.g. pipe_eq_eval, pipe_eq_inprogress and pipe_eq_invalidreq) for PIPE Gen3 is enabled in PIPE Gen3 mode 
##############################
#proc ::altera_xcvr_native_s10::parameters::validate_enable_ports_pipe_g3_equalization { PROP_NAME PROP_VALUE protocol_mode } {
#  set legal_values [expr {$protocol_mode == "pipe_g3" ? 1 : 0 }]
#
#  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
#}

##############################
# Validate that analog ports (e.g. pipe_g3_txdeemph, pipe_g3_rxpresethint) for PIPE Gen3 is enabled in PIPE Gen3 mode 
##############################
#proc ::altera_xcvr_native_s10::parameters::validate_enable_ports_pipe_g3_analog { PROP_NAME PROP_VALUE protocol_mode } {
#  set legal_values [expr {$protocol_mode == "pipe_g3" ? 1 : 0 }]
#
#  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
#}

##############################
# Validate that pipe_rx_elecidle port is enabled for PIPE mode when HIP is disabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_ports_pipe_rx_elecidle { PROP_NAME PROP_VALUE l_enable_std_pipe protocol_mode enable_hip } {
  set legal_values [expr {$l_enable_std_pipe && !$enable_hip ? 1
    : {0 1} }]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
}

##############################
# Validate that pipe_rx_polarity port is enabled for PIPE mode
##############################
#proc ::altera_xcvr_native_s10::parameters::validate_enable_port_pipe_rx_polarity { PROP_NAME PROP_VALUE l_enable_std_pipe protocol_mode } {
#  set legal_values [expr {$l_enable_std_pipe ? 1
#    : {0 1} }]
#
#  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {protocol_mode}
#}

##############################
# Set the number of word count for TX Standard PCS. This parmeter is used to set the word width.
#	word width = 8 or 10
#	Serialize x4 is dedicated for PCIE mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_tx_word_count { std_pcs_pma_width std_tx_byte_ser_mode } {
  set value [expr {$std_pcs_pma_width > 10 && $std_tx_byte_ser_mode == "Disabled" ? 2
    : $std_pcs_pma_width > 10 && $std_tx_byte_ser_mode == "Serialize x2" ? 4
    : $std_tx_byte_ser_mode == "Serialize x2" ? 2
    : $std_tx_byte_ser_mode == "Serialize x4" ? 4
    : 1 }]

  ip_set "parameter.l_std_tx_word_count.value" $value
}

##############################
# Set the word width for TX Standard PCS. This parameter is used in simple interface mapping. 
#	display_std_tx_pld_adapt_width is the user HSSI-core interface data width
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_tx_word_width { display_std_tx_pld_adapt_width l_std_tx_word_count } {
  ip_set "parameter.l_std_tx_word_width.value" [expr $display_std_tx_pld_adapt_width / $l_std_tx_word_count]
}

##############################
# Set the group width. 
# There may be multiple groups within the total width that need to be mapped. 
# For example, the original port may have a width of 128 bits and the mapped port may be 16 bits but
#    it maps 8 bits each from 2 groups of 11 (i.e. bits [7:0] and bits [18:11]. The group
#    width in this case would be 11. 
#      (e.g. 1) For 80 bits of data,  pma_data_width=8, byte-ser=on, 16-bit data port maps to {18:11 7:0} ==> word_count = 2, word_width = 8, field_width = 11
#      (e.g. 2) For 80 bits of data,  pma_data_width=20, byte-ser=off, 20-bit data port maps to {20:11 9:0} ==> word_count = 2, word_width = 10, field_width = 11
#
# This is only used in data mapping provided the data groups are continuous. It can't be used in cases where the data groups are not evenly distributed.
#	e.g. For 80 bits of data, pma_data_width=20, byte-ser=on, 40-bit data port maps to {60:51 49:40 20:11 9:0}; there is no common field_width for the data groups
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_tx_field_width { std_pcs_pma_width std_tx_byte_ser_mode } {
  set value 11
  ip_set "parameter.l_std_tx_field_width.value" $value
}

##############################
# Set the number of word count for RX Standard PCS. This parmeter is used to set the word width.
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_rx_word_count { std_pcs_pma_width std_rx_byte_deser_mode } {
  set value [expr {$std_pcs_pma_width > 10 && $std_rx_byte_deser_mode == "Disabled" ? 2
    : $std_pcs_pma_width > 10 && $std_rx_byte_deser_mode == "Deserialize x2" ? 4
    : $std_rx_byte_deser_mode == "Deserialize x2" ? 2
    : $std_rx_byte_deser_mode == "Deserialize x4" ? 4
    : 1 }]

  ip_set "parameter.l_std_rx_word_count.value" $value
}

##############################
# Set the word width for RX Standard PCS. This parameter is used in simple interface mapping. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_rx_word_width { display_std_rx_pld_adapt_width l_std_rx_word_count } {
  ip_set "parameter.l_std_rx_word_width.value" [expr $display_std_rx_pld_adapt_width / $l_std_rx_word_count]
}

##############################
# Set the group width. 
# There may be multiple groups within the total width that need to be mapped. 
# For example, the original port may have a width of 128 bits and the mapped port may be 16 bits but
#    it maps 8 bits each from 2 groups of 16 (i.e. bits [7:0] and bits [23:16]. The group
#    width in this case would be 16. 
#      (e.g. 1) For 80 bits of data,  pma_data_width=8, byte-ser=on, 16-bit data port maps to {23:16 7:0} ==> word_count = 2, word_width = 8, field_width = 16
#      (e.g. 2) For 80 bits of data,  pma_data_width=20, byte-ser=off, 20-bit data port maps to {25:16 9:0} ==> word_count = 2, word_width = 10, field_width = 16
#
# This is only used in simplified data mapping provided the data groups are continuous. It can't be used in cases where the data groups are not evenly distributed.
#	e.g. For 80 bits of data, pma_data_width=20, byte-ser=on, 40-bit data port maps to {65:56 49:40 25:16 9:0}; there is no common field_width for the data groups
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_std_rx_field_width { std_pcs_pma_width std_rx_byte_deser_mode } {
  set value 16
  ip_set "parameter.l_std_rx_field_width.value" $value
}

#******************************************************************************
#        Standard PCS validation callbacks END
#******************************************************************************

#******************************************************************************
#        Enhanced PCS validation callbacks BEGIN
#******************************************************************************

##############################
# Validate that tx_enh_frame_burst_en port is enabled when TX framegen burst is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_enh_frame_burst_en { PROP_NAME PROP_VALUE enh_tx_frmgen_burst_enable } {
  set legal_values [expr { $enh_tx_frmgen_burst_enable ? {1}
    : {0 1} }]
  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values {enh_tx_frmgen_burst_enable}
}

##############################
# Validate that tx_enh_bitslip port is enabled when bitslip is enabled for Enhanced PCS
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_enh_bitslip { PROP_NAME PROP_VALUE l_enable_tx_enh enh_tx_bitslip_enable } {
  set legal_values [expr { !$l_enable_tx_enh ? [list $PROP_VALUE]
    : $enh_tx_bitslip_enable == "1" ? {1}
      : {0 1} }]

  auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values {enh_tx_bitslip_enable}
}

##############################
# Validate that tx_enh_bitslip port is enabled when bitslip is enabled for Enhanced PCS
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_rx_enh_bitslip { enable_port_rx_enh_bitslip l_enable_rx_enh enh_rx_bitslip_enable } {
  set legal_values [expr { !$l_enable_rx_enh ? [list $enable_port_rx_enh_bitslip]
    : $enh_rx_bitslip_enable == "1" ? {1}
      : {0 1} }]

  auto_invalid_value_message warning enable_port_rx_enh_bitslip $enable_port_rx_enh_bitslip $legal_values {enh_rx_bitslip_enable}
}

#******************************************************************************
#        Enhanced PCS validation callbacks END
#******************************************************************************

#******************************************************************************
#        Core Interface validation callbacks BEGIN
#******************************************************************************

##############################
# Set the allowed range of tx_fifo_mode according to selected datapath
##############################
#proc ::altera_xcvr_native_s10::parameters::validate_tx_fifo_mode { enable_std enable_enh enable_pcs_dir rcfg_iface_enable } {
#	set allowed_ranges {}
#	if {$rcfg_iface_enable} {
#		set allowed_ranges {"Phase compensation" "Register" "Interlaken" "Basic"}
#	} elseif {$enable_std} {
#		set allowed_ranges {"Phase compensation" "Register"}
#	} elseif {$enable_enh} {
#		set allowed_ranges {"Phase compensation" "Register" "Interlaken" "Basic"}
#	} else {
#		set allowed_ranges {"Phase compensation" "Register" "Basic"}
#	}
#	ip_set "parameter.tx_fifo_mode.allowed_ranges" $allowed_ranges
#}

##############################
# Generate info message on the need to monitor the assertion of tx_dll_lock signal
# as part of the reset exit sequence in generic/interlaken mode 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_dll_lock { PROP_NAME PROP_VALUE tx_fifo_mode } {
	if { ($tx_fifo_mode == "Basic" || $tx_fifo_mode == "Interlaken") && ($PROP_VALUE == 0) } {
		auto_message warning $PROP_NAME "\"tx_dll_lock\" port must be enabled when \"[ip_get "parameter.tx_fifo_mode.display_name"]\" is set to \"$tx_fifo_mode\". Refer to the reset sequence for Basic/Interlaken FIFO mode in the user guide for more details about the role of this signal during reset release." 
	}
}

##############################
# Set the allowed range of rx_fifo_mode according to selected datapath
##############################
#proc ::altera_xcvr_native_s10::parameters::validate_rx_fifo_mode { enable_std enable_enh enable_pcs_dir rcfg_iface_enable } {
#	set allowed_ranges {}
#	if {$rcfg_iface_enable} {		
#		set allowed_ranges {"Phase compensation" "Phase compensation-Register" "Phase compensation-Basic" "Register" "Register-Phase compensation"  "Register-Basic" "Interlaken" "10GBase-R"}
#	} elseif {$enable_std} {
#		set allowed_ranges {"Phase compensation" "Phase compensation-Register" "Register" "Register-Phase compensation"}
#	} elseif {$enable_enh} {
#		set allowed_ranges {"Phase compensation" "Phase compensation-Register" "Phase compensation-Basic" "Register" "Register-Phase compensation"  "Register-Basic" "Interlaken" "10GBase-R"}
#	} else {
#		set allowed_ranges {"Phase compensation" "Phase compensation-Register" "Phase compensation-Basic" "Register" "Register-Phase compensation"  "Register-Basic"}
#	}
#	ip_set "parameter.rx_fifo_mode.allowed_ranges" $allowed_ranges
#}

##############################
# Validate that enable_port_latency_measurement is only allowed in duplex mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_latency_measurement { PROP_NAME PROP_VALUE duplex_mode } {
  set legal_values [ expr { ($duplex_mode == "duplex") ? {0 1} : 0 } ]
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { duplex_mode }
}

##############################
# Validate that enable_port_clock_delay_measurement is only allowed in duplex mode
# Notify user that pma_clkout port must be enabled if clock delay measurement is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_clock_delay_measurement { PROP_NAME PROP_VALUE duplex_mode } {
  set legal_values [ expr { ($duplex_mode == "duplex") ? {0 1} : 0 } ]
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { duplex_mode }  
}

##############################
# Validate that tx_clkout2 port is enabled when the read clock of TX core FIFO is to be driven by tx_clkout2
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_port_tx_clkout2 { tx_enable enable_port_tx_clkout2 l_enable_pcs_bonding hssi_pldadapt_tx_fifo_rd_clk_sel hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting } {
	set legal_values [ expr { ($hssi_pldadapt_tx_fifo_rd_clk_sel == "fifo_rd_pld_tx_clk2") && $tx_enable && $l_enable_pcs_bonding && ($hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting != "x2_not_from_chnl") ? 1 : {0 1} } ]
	auto_invalid_value_message error enable_port_tx_clkout2 $enable_port_tx_clkout2 $legal_values { l_enable_pcs_bonding }
}

#******************************************************************************
#        Core Interface validation callbacks END
#******************************************************************************

#******************************************************************************
#        Dynamic reconfiguration validation callbacks BEGIN
#******************************************************************************

##############################
# Notify user to enable dynamic reconfiguration if datapath and interface reconfiguration is enabled
# Notify user of merging restriction when dynamic reconfiguration is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rcfg_enable { PROP_NAME PROP_VALUE rcfg_iface_enable duplex_mode} {
  if { $rcfg_iface_enable && !$PROP_VALUE } {
    set str_rcfg_enable       "\"[ip_get "parameter.${PROP_NAME}.display_name"]\" (${PROP_NAME}) (current value: $PROP_VALUE)"
    set str_rcfg_iface_enable "\"[ip_get "parameter.rcfg_iface_enable.display_name"]\" (rcfg_iface_enable) (current value: $rcfg_iface_enable)"
    auto_message warning $PROP_NAME "${str_rcfg_enable} should be enabled when ${str_rcfg_iface_enable} is enabled"
  }

  if {$PROP_VALUE} {
    if {$duplex_mode == "tx"} {
      auto_message warning $PROP_NAME "If this TX Simplex Native PHY instance needs to be merged with an RX Simplex Native PHY instance or a CDR PLL IP instance, ensure that reconfiguration inputs of both the PHY instances are driven by the same source"
    } elseif {  $duplex_mode == "rx"} {
      auto_message warning $PROP_NAME "If this RX Simplex Native PHY instance needs to be merged with an TX Simplex Native PHY instance, ensure that reconfiguration inputs of both the PHY instances are driven by the same source"
    }
  }
}

##############################
# Notify user to enable multi-profile when dynamic reconfiguration is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rcfg_multi_enable { rcfg_enable rcfg_multi_enable } {
  if { $rcfg_enable && !$rcfg_multi_enable } {
    auto_message warning rcfg_multi_enable "When dynamic reconfiguration is enabled, users are recommended to enable multiple reconfiguration profiles for Quartus to perform robust timing closure"
  }
}

##############################
# this function is shared
# used to show warning messages to user, related to merging
# called from validation callbacks of "set_capability_reg_enable" "set_csr_soft_logic_enable" "set_prbs_soft_logic_enable" "set_rcfg_emb_strm_enable" "rcfg_shared" "rcfg_jtag_enable"
##############################
proc ::altera_xcvr_native_s10::parameters::display_no_merging_message { param_name param_value isTx {additional_info ""}} {
  set common_str2 "since the parameter [::alt_xcvr::ip_tcl::messages::get_parameter_display_string ${param_name} ] is set to [::alt_xcvr::ip_tcl::messages::get_value_display_string ${param_name} ${param_value}]."
  if {$isTx} {
    auto_message warning $param_name "This TX Simplex Native PHY instance cannot be merged with an RX Simplex Native PHY instance or a CDR PLL IP instance ${common_str2} ${additional_info}"
  } else {
    auto_message warning $param_name "This RX Simplex Native PHY instance cannot be merged with a TX Simplex Native PHY instance ${common_str2} ${additional_info}"
  }
}

##############################
# Notify user to use independent reconfiguration interface if they want to merge the AVMM interface for configurations that do not required shared AVMM interface
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rcfg_shared { PROP_NAME PROP_VALUE rcfg_enable channels l_channels duplex_mode rcfg_jtag_enable set_capability_reg_enable set_csr_soft_logic_enable set_prbs_soft_logic_enable set_odi_soft_logic_enable set_rcfg_emb_strm_enable} {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {!($rcfg_jtag_enable || $set_capability_reg_enable || $set_csr_soft_logic_enable || $set_prbs_soft_logic_enable || $set_rcfg_emb_strm_enable || $set_odi_soft_logic_enable)} {
		set additional_info "Use independent reconfiguration interface if you need merging."
		if {$duplex_mode == "tx"} {
			display_no_merging_message $PROP_NAME $PROP_VALUE 1 $additional_info
		} elseif {  $duplex_mode == "rx"} {
			display_no_merging_message $PROP_NAME $PROP_VALUE 0 $additional_info
		}
      }
    }
  }

  set legal_values [expr { !$rcfg_enable ? $PROP_VALUE
    : ($l_channels == 1 )                    ? {0}
    : ($l_channels > 1 && $rcfg_jtag_enable) ? {1}
    : {0 1}}]

  auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { channels rcfg_jtag_enable}
}

##############################
# If the user is reconfiguring between datapath, it is necessary to set rcfg_iface_enable to 1 for all profiles
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_rcfg_datapath_message { PROP_NAME \
  rcfg_enable rcfg_multi_enable rcfg_profile_cnt rcfg_iface_enable protocol_mode
  rcfg_profile_data0 rcfg_profile_data1 rcfg_profile_data2 rcfg_profile_data3 rcfg_profile_data4 rcfg_profile_data5 rcfg_profile_data6 rcfg_profile_data7 \
  message_level } {

  ##
  # maps protocol_mode to datapath_select
  # this procedure only used locally, hence defined here
  proc ::altera_xcvr_native_s10::parameters::internal_map_datapath { prot_mode } {
    variable CONST_DATAPATH_SELECT_MAPPING
    set value ""
    foreach elem $CONST_DATAPATH_SELECT_MAPPING {
      #elem is a pair as "protocol_mode:datapath_select"
      set mapping [split $elem ":"]
      if {[lindex $mapping 0] == $prot_mode} {
	set value [lindex $mapping 1]
      }
    }
    return $value
  }

  # initializations
  set is_datapath_reconfigured 0
  set is_rcfg_iface_enable_set_for_all_profiles $rcfg_iface_enable

  if {$rcfg_enable && $rcfg_multi_enable} {
    # save rcfg_iface_enable and datapath_select values for each profile
    set reduced_dict ""
    for {set i 0} {$i < $rcfg_profile_cnt} {incr i} {
      set rcfg_profile_data [ip_get "parameter.rcfg_profile_data${i}.value"]
      if {$rcfg_profile_data != ""} {
		if {[dict exist $rcfg_profile_data protocol_mode] && [dict exist $rcfg_profile_data rcfg_iface_enable]} {
		  dict set reduced_dict $i prof_rcfg_iface_enable [dict get $rcfg_profile_data rcfg_iface_enable]
		  set prof_prot_mode  [dict get $rcfg_profile_data protocol_mode]
		  dict set reduced_dict $i prof_datapath_select [internal_map_datapath $prof_prot_mode]
		} else {
		  if {![dict exist $rcfg_profile_data protocol_mode]} {
			auto_message warning $PROP_NAME "Reconfiguration profile $i is missing a value for parameter [ip_get "parameter.protocol_mode.display_name"] (protocol_mode). Altera recommends that you refresh the profile."
		  }
		  if {![dict exist $rcfg_profile_data rcfg_iface_enable]} {
			auto_message warning $PROP_NAME "Reconfiguration profile $i is missing a value for parameter [ip_get "parameter.rcfg_iface_enable.display_name"] (rcfg_iface_enable). Altera recommends that you refresh the profile."
		  }
		}
      }
    }

    set active_datapath_select [internal_map_datapath $protocol_mode]
    set error_message "Parameter \"rcfg_iface_enable\" ([ip_get "parameter.rcfg_iface_enable.display_name"]) must be enabled for all reconfiguration profiles when reconfiguring between transceiver datapaths. Current value:${rcfg_iface_enable}"
    dict for {config params} $reduced_dict {
      dict with params {
		# running AND for rcfg_iface_enable across profiles, and error message construction
		set is_rcfg_iface_enable_set_for_all_profiles [expr {$is_rcfg_iface_enable_set_for_all_profiles && $prof_rcfg_iface_enable}]
		set error_message "${error_message}; Profile${config} value:${prof_rcfg_iface_enable}"
		if {$active_datapath_select != "" && $prof_datapath_select != ""} {
		  if {$active_datapath_select != $prof_datapath_select} {
			set is_datapath_reconfigured 1
		  }
		}
      }
    }
  }

  if {$is_datapath_reconfigured && !$is_rcfg_iface_enable_set_for_all_profiles} {
    ip_set "parameter.${PROP_NAME}.value" 1
    auto_message $message_level $PROP_NAME $error_message
  } else {
    ip_set "parameter.${PROP_NAME}.value" 0
  }
}

##############################
# Notify user that current simplex channel cannot be merged
##############################
proc ::altera_xcvr_native_s10::parameters::generate_simplex_merging_message { PROP_NAME PROP_VALUE rcfg_enable duplex_mode} {
  if {$PROP_VALUE && $rcfg_enable} {
     set is_tx [expr {$duplex_mode == "tx"}]    
     if {$duplex_mode == "tx" || $duplex_mode == "rx"} {
		display_no_merging_message $PROP_NAME $PROP_VALUE $is_tx
     } 
  }
}

##############################
# Notify user that current simplex channel cannot be merged when reconfiguration jtag interface is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rcfg_jtag_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode} {
	generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Notify user that merging of current simplex channel is no possible when capability register is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_capability_reg_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Notify user that merging of current simplex channel is no possible when CSR soft logic is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_csr_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Notify user that merging of current simplex channel is no possible when PRBS soft logic is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_prbs_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Notify user that merging of current simplex channel is no possible when ODI soft logic is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_odi_soft_logic_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Notify user that merging of current simplex channel is no possible when reconfiguration embedded streamer is enabled. 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_set_rcfg_emb_strm_enable { PROP_NAME PROP_VALUE rcfg_enable duplex_mode } {
  generate_simplex_merging_message $PROP_NAME $PROP_VALUE $rcfg_enable $duplex_mode
}

##############################
# Set dbg_embedded_debug_enable to 1 if any of the embedded debug logic is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_dbg_embedded_debug_enable { rcfg_enable duplex_mode set_capability_reg_enable set_csr_soft_logic_enable set_prbs_soft_logic_enable set_rcfg_emb_strm_enable set_odi_soft_logic_enable rcfg_jtag_enable } {
  if { $rcfg_enable } {
    set lcl_embedded_debug_enable [expr $set_capability_reg_enable || $set_csr_soft_logic_enable || $set_prbs_soft_logic_enable || $set_rcfg_emb_strm_enable || $set_odi_soft_logic_enable]
    ip_set "parameter.dbg_embedded_debug_enable.value" $lcl_embedded_debug_enable
  } else {
    ip_set "parameter.dbg_embedded_debug_enable.value" 0
  }
}

##############################
# Set dbg_ctrl_soft_logic_enable 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_dbg_prbs_soft_logic_enable { rcfg_enable set_prbs_soft_logic_enable } {
  set value [expr { $rcfg_enable ? $set_prbs_soft_logic_enable : 0 }]
  ip_set "parameter.dbg_prbs_soft_logic_enable.value" $value
}

##############################
# Set dbg_odi_soft_logic_enable 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_dbg_odi_soft_logic_enable { rcfg_enable set_odi_soft_logic_enable } {
  set value [expr { $rcfg_enable ? $set_odi_soft_logic_enable : 0 }]
  ip_set "parameter.dbg_odi_soft_logic_enable.value" $value
}

##############################
# Set adme_prot_mode 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_adme_prot_mode { protocol_mode } {
  ip_set "parameter.adme_prot_mode.value" $protocol_mode
}

##############################
# Set adme_data_rate 
##############################
proc ::altera_xcvr_native_s10::parameters::validate_adme_data_rate { set_data_rate } {
  if {[string is double $set_data_rate]} {
    set temp [expr {wide(double($set_data_rate) * 1000000)}]
    ip_set "parameter.adme_data_rate.value" $temp
  }
}

#******************************************************************************
#        Dynamic reconfiguration validation callbacks END
#******************************************************************************

#******************************************************************************
#        RBC Validation Override Callbacks BEGIN
#		 Override ICD RBC
#******************************************************************************

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


##############################
# Set pma_cgb_input_select_x1 based on pll_select
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_cgb_input_select_x1 { bonded_mode pll_select } {
  set value [ expr { $bonded_mode != "not_bonded" ? "unused"
    : $pll_select == "0" ? "fpll_bot"
    : $pll_select == "1" ? "lcpll_bot"
    : $pll_select == "2" ? "fpll_top"
    : $pll_select == "3" ? "lcpll_top"
      : "fpll_bot" }]

  ip_set "parameter.pma_cgb_input_select_x1.value" $value
}

##############################
# Set pma_cgb_input_select_gen3 for PIPE Gen3 channels
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_cgb_input_select_gen3 { bonded_mode l_enable_std_pipe protocol_mode } {
  set value [ expr { ($bonded_mode == "not_bonded") && $l_enable_std_pipe && ($protocol_mode == "pipe_g3") ? "lcpll_bot"
      : "unused" }]

  ip_set "parameter.pma_cgb_input_select_gen3.value" $value
}

##############################
# Set pma_rx_deser_pm_cr_tx_rx_pcie_gen for PIPE mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_rx_deser_pm_cr_tx_rx_pcie_gen { PROP_NAME set_cdr_refclk_freq l_enable_std_pipe protocol_mode } {
  # possible values {non_pcie pcie_gen1_100mhzref pcie_gen1_125mhzref pcie_gen2_100mhzref pcie_gen2_125mhzref pcie_gen3_100mhzref pcie_gen3_125mhzref}
  set value "non_pcie"
  if {$l_enable_std_pipe} {
    set pcie_str [expr {$protocol_mode == "pipe_g1" ? "pcie_gen1"
      : $protocol_mode == "pipe_g2" ? "pcie_gen2"
      : "pcie_gen3"}]
    set refclk_str [expr { [regexp {125\.} $set_cdr_refclk_freq] ? "125mhzref" : "100mhzref" }]
    set value "${pcie_str}_${refclk_str}"
  }

  ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set pma_rx_buf_pm_cr_tx_rx_pcie_gen for PIPE mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_rx_buf_pm_cr_tx_rx_pcie_gen { PROP_NAME set_cdr_refclk_freq l_enable_std_pipe protocol_mode } {
  # possible values {non_pcie pcie_gen1_100mhzref pcie_gen1_125mhzref pcie_gen2_100mhzref pcie_gen2_125mhzref pcie_gen3_100mhzref pcie_gen3_125mhzref}
  set value "non_pcie"
  if {$l_enable_std_pipe} {
    set pcie_str [expr {$protocol_mode == "pipe_g1" ? "pcie_gen1"
      : $protocol_mode == "pipe_g2" ? "pcie_gen2"
      : "pcie_gen3"}]
    set refclk_str [expr { [regexp {125\.} $set_cdr_refclk_freq] ? "125mhzref" : "100mhzref" }]
    set value "${pcie_str}_${refclk_str}"
  }

  ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set pma_rx_deser_bitslip_bypass
##############################
## once rbc is fixed remove this (add here the FB case number)
proc ::altera_xcvr_native_s10::parameters::validate_pma_rx_deser_bitslip_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN PROP_NAME PROP_VALUE protocol_mode enable_port_rx_pma_clkslip} {
   set legal_values [list "bs_bypass_no" "bs_bypass_yes"]
   if [expr { ($protocol_mode=="cpri") || ($protocol_mode=="cpri_rx_tx") || ($enable_port_rx_pma_clkslip==1) }] {
      set legal_values [list "bs_bypass_no"]
   } else {
      set legal_values [list "bs_bypass_yes"]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
	 ip_set "parameter.${PROP_NAME}.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
		auto_legal_value_warning_message protocol_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto $PROP_NAME $PROP_VALUE $legal_values { protocol_mode enable_port_rx_pma_clkslip }
   }
}

##############################
# Set pma_tx_ser_ser_clk_divtx_user_sel
##############################
proc ::altera_xcvr_native_s10::parameters::validate_pma_tx_ser_ser_clk_divtx_user_sel { tx_enable l_enable_tx_pma_div_clkout tx_pma_div_clkout_divider } {
  set value [expr {!$tx_enable || !$l_enable_tx_pma_div_clkout ? "divtx_user_off"
    : $tx_pma_div_clkout_divider == "1" ? "divtx_user_1"
    : $tx_pma_div_clkout_divider == "2" ? "divtx_user_2"
    : $tx_pma_div_clkout_divider == "33" ? "divtx_user_33"
    : $tx_pma_div_clkout_divider == "40" ? "divtx_user_40"
    : $tx_pma_div_clkout_divider == "66" ? "divtx_user_66"
    : "divtx_user_off" }]

  ip_set "parameter.pma_tx_ser_ser_clk_divtx_user_sel.value" $value
}

##############################
# Set cdr_pll_mcnt_div
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_pll_mcnt_div { PROP_NAME l_enable_pma_channel rx_enable l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.${PROP_NAME}.value" [dict get $l_pll_settings $l_pll_settings_key m]
  } elseif { $rx_enable && !$l_enable_pma_channel } {
	# PCIE unused channel
	ip_set "parameter.${PROP_NAME}.value" 8
  }
}

##############################
# Set cdr_pll_ncnt_div
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_pll_n_counter { PROP_NAME l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
	set temp [dict get $l_pll_settings $l_pll_settings_key n]
	ip_set "parameter.${PROP_NAME}.value" $temp
  }
}

##############################
# Set cdr_pll_lpd_counter
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_pll_lpd_counter { PROP_NAME l_enable_pma_channel rx_enable l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.${PROP_NAME}.value" [dict get $l_pll_settings $l_pll_settings_key lpd]
  } elseif { $rx_enable && !$l_enable_pma_channel } {
	# PCIE unused channel
	ip_set "parameter.${PROP_NAME}.value" 0
  }
}

##############################
# Set cdr_pll_lpfd_counter
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_pll_lpfd_counter { PROP_NAME l_enable_pma_channel rx_enable l_pll_settings l_pll_settings_key } {
  if {$l_pll_settings != "NOVAL" && $l_pll_settings_key != "NOVAL"} {
    ip_set "parameter.${PROP_NAME}.value" [dict get $l_pll_settings $l_pll_settings_key lpfd]
  } elseif { $rx_enable && !$l_enable_pma_channel } {
	# PCIE unused channel
	ip_set "parameter.${PROP_NAME}.value" 0
  }
}

##############################
# Set cdr_pll_pcie_gen
##############################
proc ::altera_xcvr_native_s10::parameters::validate_cdr_pll_pcie_gen { PROP_NAME set_cdr_refclk_freq l_enable_std_pipe protocol_mode } {
  # possible values {non_pcie pcie_gen1_100mhzref pcie_gen1_125mhzref pcie_gen2_100mhzref pcie_gen2_125mhzref pcie_gen3_100mhzref pcie_gen3_125mhzref}
  set value "non_pcie"
  if {$l_enable_std_pipe} {
    set pcie_str [expr {$protocol_mode == "pipe_g1" ? "pcie_gen1"
      : $protocol_mode == "pipe_g2" ? "pcie_gen2"
      : "pcie_gen3"}]
    set refclk_str [expr { [regexp {125\.} $set_cdr_refclk_freq] ? "125mhzref" : "100mhzref" }]
    set value "${pcie_str}_${refclk_str}"
  }

  ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Set hssi_pipe_gen1_2_txswing
##############################
proc ::altera_xcvr_native_s10::parameters::validate_hssi_pipe_gen1_2_txswing { protocol_mode enable_hip } {
  set value [ expr { !$enable_hip && ($protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2") ? "en_txswing"
    : "dis_txswing" }]

  ip_set "parameter.hssi_pipe_gen1_2_txswing.value" $value
}

##############################
# Set hssi_10g_tx_pcs_gb_pipeln_bypass
##############################
proc ::altera_xcvr_native_s10::parameters::validate_hssi_10g_tx_pcs_gb_pipeln_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_10g_tx_pcs_gb_pipeln_bypass hssi_10g_tx_pcs_bitslip_en hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_low_latency_en} {
   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_10g_tx_pcs_bitslip_en=="bitslip_en")||($hssi_10g_tx_pcs_prot_mode=="disable_mode")) }] {
      set legal_values [list "disable"]
   } else {
      if [expr { (($hssi_10g_tx_pcs_low_latency_en=="enable")&&($hssi_10g_tx_pcs_prot_mode!="teng_baser_mode")) }] {
	 set legal_values [list "enable"]
      } else {
	 set legal_values [list "disable"]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
	 ip_set "parameter.hssi_10g_tx_pcs_gb_pipeln_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
		auto_legal_value_warning_message hssi_10g_tx_pcs_gb_pipeln_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_tx_pcs_gb_pipeln_bypass $hssi_10g_tx_pcs_gb_pipeln_bypass $legal_values { enh_low_latency_enable}
   }
}

##############################
# Set hssi_krfec_rx_pcs_error_marking_en
##############################
proc ::altera_xcvr_native_s10::parameters::validate_hssi_krfec_rx_pcs_error_marking_en { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode enh_low_latency_enable} {
   set legal_values [list "err_mark_dis" "err_mark_en"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") || ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
     if {$enh_low_latency_enable == 1} {
		set legal_values [list "err_mark_dis"]
     } else {
		if { $hssi_krfec_rx_pcs_prot_mode=="basic_mode" } {
			set legal_values [list "err_mark_en" "err_mark_dis"]
		} else {
			set legal_values [list "err_mark_en"]
		}
    }
   } else {
      set legal_values [list "err_mark_dis"]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
	 ip_set "parameter.hssi_krfec_rx_pcs_error_marking_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
		auto_legal_value_warning_message hssi_krfec_rx_pcs_error_marking_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_error_marking_en $hssi_krfec_rx_pcs_error_marking_en $legal_values { hssi_krfec_rx_pcs_prot_mode enh_low_latency_enable}
   }
}

##############################
# Set hssi_8g_rx_pcs_wa_det_latency_sync_status_beh
##############################
proc ::altera_xcvr_native_s10::parameters::validate_hssi_8g_rx_pcs_wa_det_latency_sync_status_beh { PROP_M_AUTOSET PROP_M_AUTOWARN hssi_8g_rx_pcs_wa_det_latency_sync_status_beh std_rx_word_aligner_fast_sync_status_enable hssi_8g_rx_pcs_prot_mode} {
   set legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm" "dont_care_assert_sync"]
   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      if {$std_rx_word_aligner_fast_sync_status_enable} {
		set legal_values [list "assert_sync_status_imm"]
      } else {
		set legal_values [list "assert_sync_status_non_imm"]
      }
   } else {
      set legal_values [list "dont_care_assert_sync"]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
	 ip_set "parameter.hssi_8g_rx_pcs_wa_det_latency_sync_status_beh.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
		auto_legal_value_warning_message hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $legal_values { std_rx_word_aligner_fast_sync_status_enable hssi_8g_rx_pcs_prot_mode }
   }
}

##############################
# Validate rcfg_jtag_enable
##############################
proc ::altera_xcvr_native_s10::parameters::validate_rcfg_jtag_enable { PROP_NAME PROP_VALUE rcfg_enable l_channels duplex_mode} {
  if {$PROP_VALUE} {
    if {$rcfg_enable} {
      if {$duplex_mode == "tx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 1
      } elseif {  $duplex_mode == "rx"} {
        display_no_merging_message $PROP_NAME $PROP_VALUE 0
      }
    }  
  }
}

##############################
# Validate l_enable_loopback_mode
##############################
proc ::altera_xcvr_native_s10::parameters::validate_l_enable_loopback_mode { PROP_NAME PROP_VALUE parallel_loopback_mode } {
	set value [expr {$parallel_loopback_mode == "disable" ? 0 : 1}]
	ip_set "parameter.${PROP_NAME}.value" $value
}

##############################
# Validate enable_tx_x2_coreclkin_port
#  Expose tx_x2_coreclkin in HIP mode or when loopback is enabled
##############################
proc ::altera_xcvr_native_s10::parameters::validate_enable_tx_x2_coreclkin_port { PROP_NAME PROP_VALUE enable_hip parallel_loopback_mode } {	
	if { $enable_hip || $parallel_loopback_mode != "disable" } {
		set value 1
	} else {
		set value 0
	}
	ip_set "parameter.${PROP_NAME}.value" $value
}

#******************************************************************************
#        RBC Validation Override Callbacks END
#******************************************************************************

########################################################################################################################
#											Mapping/Unmapping Callbacks
########################################################################################################################

##############################
# convert set_data_rate to bps from Mbps and adds the unit
##############################
proc ::altera_xcvr_native_s10::parameters::map_data_rate_bps { set_data_rate } {
  if {[string is double $set_data_rate]} {
    set temp [expr {wide(double($set_data_rate) * 1000000)}]
  } else {
    # if the user input not formatted properly
    # setting it to '1' will return the valid range as '1' is not valid
    # setting it to '0' would do the same but it vulnarable for divide-by-zero errors (although such a division does not take place currently it might in future)
    set temp 1
  }
  return $temp
}

##############################
# unmaps data_rate_bps to set_data_rate by removing the unit and converting to Mbps from bps
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_data_rate_bps { data_rate_bps } {
  regsub -nocase -all {\D} $data_rate_bps "" temp
  set temp [expr {double($temp) / 1000000}]
  return $temp
}

##############################
# convert set_cdr_refclk_freq to hz from MHz and adds the unit
##############################
proc ::altera_xcvr_native_s10::parameters::map_cdr_pll_reference_clock_frequency { set_cdr_refclk_freq } {
  set temp [expr {wide(double($set_cdr_refclk_freq) * 1000000)}]
  return $temp
}

##############################
# unmaps cdr_ref_clk to set_cdr_refclk by removing the unit and converting to MHz from hz
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_cdr_pll_reference_clock_frequency { cdr_pll_reference_clock_frequency } {
  regsub -nocase -all {\D} $cdr_pll_reference_clock_frequency "" temp
  set temp [expr {double($temp) / 1000000}]
  return $temp
}

##############################
# see FB:278751 for changes made on the mapping table
# ALL THE FOLLOWING ADAPTATION RELATED MAP UNMAP FUNCTIONS ARE DONE BASED ON THE FOLLOWING TABLE
#---------------------------------------------------------------------------------------------------------------
#  user-ctle   user-dfe    user-taps  -->   atom-adapt_mode   atom-adapt_taps  atom-en_fixed  atom-en_fixed4t7  
#---------------------------------------------------------------------------------------------------------------
#   manual     disabled    3          -->   manual            radp_4           fx_pdown       4t7_pdown         
#   manual     disabled    7,11       -->   manual            radp_4           fx_pdown       4t7_pdown         
#   manual     manual      3          -->   manual            radp_4           fx_enable      4t7_pdown         
#   manual     manual      7,11       -->   manual            radp_0           fx_enable      4t7_enable        
#   manual     continuous  3          -->   dfe_vga           radp_4           fx_enable      4t7_pdown         
#   manual     continuous  7,11       -->   dfe_vga           radp_0           fx_enable      4t7_enable        
#   one-time   disabled    3          -->   ctle              radp_4           fx_enable      4t7_pdown         
#   one-time   disabled    7,11       -->   ctle              radp_4           fx_enable      4t7_pdown         
#   one-time   manual      3          -->   ctle_vga          radp_4           fx_enable      4t7_pdown         
#   one-time   manual      7,11       -->   ctle_vga          radp_0           fx_enable      4t7_enable        
#   one-time   continuous  3          -->   ctle_vga_dfe      radp_4           fx_enable      4t7_pdown         
#   one-time   continuous  7,11       -->   ctle_vga_dfe      radp_0           fx_enable      4t7_enable        
#

# Maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_ctle_adaptation_mode" to "pma_adapt_adapt_mode "
#---------------------------------------------------------------------------------------------------------------
#  user-ctle   user-dfe    -->   atom-adapt_mode
#---------------------------------------------------------------------------------------------------------------
#   manual     disabled    -->   manual
#   manual     manual      -->   manual
#   manual     continuous  -->   dfe_vga
#   one-time   disabled    -->   ctle
#   one-time   manual      -->   ctle_vga
#   one-time   continuous  -->   ctle_vga_dfe
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_adapt_adapt_mode {rx_pma_dfe_adaptation_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_ctle_adaptation_mode == "manual")   && (($rx_pma_dfe_adaptation_mode == "disabled") || ($rx_pma_dfe_adaptation_mode == "manual")     ) ) ? "manual"
    : ( ($rx_pma_ctle_adaptation_mode == "manual")   && (($rx_pma_dfe_adaptation_mode == "continuous")                                                ) ) ? "dfe_vga"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "disabled")                                                  ) ) ? "ctle"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "manual")                                                    ) ) ? "ctle_vga"
    : ( ($rx_pma_ctle_adaptation_mode == "one-time") && (($rx_pma_dfe_adaptation_mode == "continuous")                                                ) ) ? "ctle_vga_dfe"
    : "dfe_vga" }]
  return $value
}

##############################
# unmaps "pma_adapt_adapt_mode" to "rx_pma_dfe_adaptation_mode"
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_adapt_adapt_mode {pma_adapt_adapt_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ( $pma_adapt_adapt_mode == "manual" )      && ($rx_pma_ctle_adaptation_mode=="manual")   ) ? [list "manual" "disabled" ]
    : ( ( $pma_adapt_adapt_mode == "manual" )      && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "dfe_vga")      && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list "continuous" ]
    : ( ( $pma_adapt_adapt_mode == "dfe_vga")      && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle")         && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle")         && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "disabled" ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga")     && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga")     && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "manual" ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga_dfe") && ($rx_pma_ctle_adaptation_mode=="manual"  ) ) ? [list ]
    : ( ( $pma_adapt_adapt_mode == "ctle_vga_dfe") && ($rx_pma_ctle_adaptation_mode=="one-time") ) ? [list "continuous" ]
    : "" }]
  return $value
}

##############################
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_adapt_adp_dfe_mode"
# The valid range for rx_pma_dfe_fixed_taps is set to {3, 7, 11} because fxtap[1-3] and fixtap[4-7] are in two blocks and fixtap[4-7] can be power-down when not used.
# Secondly, fixtap[8-11] are actually floating taps that are turned into fixed-tap and located in another block. Therefore, users are provided the options to choose between 3 taps, 7 taps or 11 taps
#
# user-dfe    user-taps  -->   atom-adapt_taps  
# disabled    DONT CARE  -->   radp_4           
# manual      3          -->   radp_4           
# manual      7,11       -->   radp_0           
# continuous  3          -->   radp_4           
# continuous  7,11       -->   radp_0           
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_adapt_adp_dfe_mode {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode } {
  set value [expr { \
      $rx_pma_dfe_adaptation_mode == "disabled"                    ? "radp_dfe_mode_4"
    : $rx_pma_dfe_fixed_taps == 11 || $rx_pma_dfe_fixed_taps == 7  ? "radp_dfe_mode_0"
    : $rx_pma_dfe_fixed_taps == 3                                  ? "radp_dfe_mode_4"
    :                                                                "radp_dfe_mode_4"}]
  return $value
}

##############################
# unmaps "pma_adapt_adp_dfe_mode" to "rx_pma_dfe_fixed_taps"
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_adapt_adp_dfe_mode {pma_adapt_adp_dfe_mode rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_4") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_4") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3]
    : (  ($pma_adapt_adp_dfe_mode == "radp_dfe_mode_0") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 7 11]
    : ""}]
  return $value
}

##############################
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_rx_dfe_pdb_floattap"
# user-dfe    user-taps  -->   atom-floattap  
# disabled    DONT CARE  -->   floattap_dfe_powerdown           
# O.W         3,7        -->   floattap_dfe_powerdown           
# O.W         11         -->   floattap_dfe_enable     
##############################      
proc ::altera_xcvr_native_s10::parameters::map_pma_rx_dfe_pdb_floattap {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode } {
  set value [expr { \
      $rx_pma_dfe_adaptation_mode == "disabled"                    ? "floattap_dfe_powerdown"
    : $rx_pma_dfe_fixed_taps == 3 || $rx_pma_dfe_fixed_taps == 7   ? "floattap_dfe_powerdown"
    : $rx_pma_dfe_fixed_taps == 11                                 ? "floattap_dfe_enable"
    :                                                                "floattap_dfe_powerdown"}]
  return $value
}

##############################
# unmaps "pma_rx_dfe_pdb_floattap" to "rx_pma_dfe_fixed_taps"
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_rx_dfe_pdb_floattap {pma_rx_dfe_pdb_floattap rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_powerdown") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_powerdown") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3 7]
    : (  ($pma_rx_dfe_pdb_floattap == "floattap_dfe_enable")    && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 11]
    : ""}]
  return $value
}
 
##############################
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_ctle_adaptation_mode" to "pma_rx_dfe_pdb_fixedtap"
##############################
proc ::::altera_xcvr_native_s10::parameters::map_pma_rx_dfe_pdb_fixedtap {rx_pma_dfe_adaptation_mode rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_dfe_adaptation_mode == "disabled") && ($rx_pma_ctle_adaptation_mode == "manual") ) ? "fixtap_dfe_powerdown"
    : "fixtap_dfe_enable" }]
  return $value
}

##############################
# unmaps "pma_rx_dfe_pdb_fixedtap" to "rx_pma_dfe_adaptation_mode"
##############################
proc ::::altera_xcvr_native_s10::parameters::unmap_pma_rx_dfe_pdb_fixedtap {pma_rx_dfe_pdb_fixedtap rx_pma_ctle_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_powerdown") && ($rx_pma_ctle_adaptation_mode == "one-time")) ? ""
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_powerdown") && ($rx_pma_ctle_adaptation_mode == "manual"  )) ? [list "disabled" ]
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_enable")    && ($rx_pma_ctle_adaptation_mode == "manual"  )) ? [list "continuous" "manual" ]
    : (  ($pma_rx_dfe_pdb_fixedtap == "fixtap_dfe_enable")    && ($rx_pma_ctle_adaptation_mode == "one-time")) ? [list "continuous" "manual" "disabled" ]
    : "" }]
  return $value
}

##############################
# maps user selections on "rx_pma_dfe_adaptation_mode" and "rx_pma_dfe_fixed_taps" to "pma_rx_dfe_pdb_fxtap4t7"
##############################
proc ::::altera_xcvr_native_s10::parameters::map_pma_rx_dfe_pdb_fxtap4t7 {rx_pma_dfe_fixed_taps rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      ( ($rx_pma_dfe_adaptation_mode == "disabled") ) ? "fxtap4t7_powerdown"
    : ( ($rx_pma_dfe_fixed_taps == "3" ) ) ? "fxtap4t7_powerdown"
    : ( ($rx_pma_dfe_fixed_taps == "7" ) ) ? "fxtap4t7_enable"
    : ( ($rx_pma_dfe_fixed_taps == "11") ) ? "fxtap4t7_enable"
    : "fxtap4t7_powerdown" }]
  return $value
}

##############################
# unmaps "pma_rx_dfe_pdb_fxtap4t7" to "rx_pma_dfe_fixed_taps"
##############################
proc ::::altera_xcvr_native_s10::parameters::unmap_pma_rx_dfe_pdb_fxtap4t7 {pma_rx_dfe_pdb_fxtap4t7 rx_pma_dfe_adaptation_mode} {
  set value [expr { \
      (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_powerdown") && ($rx_pma_dfe_adaptation_mode == "disabled" ) ) ? [list 3 7 11]
    : (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_powerdown") && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 3]
    : (  ($pma_rx_dfe_pdb_fxtap4t7 == "fxtap4t7_enable")    && ($rx_pma_dfe_adaptation_mode != "disabled" ) ) ? [list 7 11]
    : ""}]
  return $value
}

##############################
# mapping for tx_pll_clk_hz as cdr_pll_out_freq/clock_divider_ratio (first strip off units from cdr_pll_out_freq)
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_tx_buf_pm_cr_tx_path_tx_pll_clk_hz { cdr_pll_out_freq pma_tx_buf_pm_cr_tx_path_clock_divider_ratio } {
  regsub -nocase -all {\D} $cdr_pll_out_freq "" temp
  return [expr {wide(double($temp)/$pma_tx_buf_pm_cr_tx_path_clock_divider_ratio)}]
}

##############################
# unmaps tx_pll_clk_hz to cdr_pll_out_freq as tx_pll_clk_hz*clock_divider_ratio (adds units hz as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_tx_buf_pm_cr_tx_path_tx_pll_clk_hz { pma_tx_buf_pm_cr_tx_path_tx_pll_clk_hz pma_tx_buf_pm_cr_tx_path_clock_divider_ratio } {
  regsub -nocase -all {\D} $pma_tx_buf_pm_cr_tx_path_tx_pll_clk_hz "" temp
  set temp [expr {wide(double($pma_tx_buf_pm_cr_tx_path_tx_pll_clk_hz)*$pma_tx_buf_pm_cr_tx_path_clock_divider_ratio)}]
  return "${temp} hz"
}

##############################
# mapping for chnl_clklow_clk_hz as cdr_ref_clk/clklow_div (first strip off units from cdr_ref_clk)
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_rx_pld_pcs_interface_hd_pcs_channel_clklow_clk_hz { cdr_pll_reference_clock_frequency cdr_pll_fref_clklow_div } {
  regsub -nocase -all {\D} $cdr_pll_reference_clock_frequency "" temp
  set temp [expr {wide(double($temp)/$cdr_pll_fref_clklow_div)}]
  return $temp
}

##############################
# unmaps chnl_clklow_clk_hz to cdr_ref_clk as chnl_clklow_clk_hz*clklow_div (adds units hz as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_rx_pld_pcs_interface_hd_pcs_channel_clklow_clk_hz { hssi_rx_pld_pcs_interface_hd_pcs_channel_clklow_clk_hz cdr_pll_fref_clklow_div} {
  set temp [expr {wide(double($hssi_rx_pld_pcs_interface_hd_pcs_channel_clklow_clk_hz)*$cdr_pll_fref_clklow_div)}]
  return "${temp} hz"
}

##############################
# mapping for tx_divclk as datarate/datawidth (first strip off units from datarate)
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_tx_buf_pm_cr_tx_path_pma_tx_divclk_hz { pma_tx_buf_pm_cr_tx_path_datarate_bps pma_tx_buf_pm_cr_tx_path_datawidth } {
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  set val [expr {wide(double($pma_tx_buf_pm_cr_tx_path_datarate_bps)/$pma_tx_buf_pm_cr_tx_path_datawidth)}]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$val > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set val $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $val
}

##############################
# unmaps tx_divclk to datarate as tx_divclk*datawidth (adds units bps as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_tx_buf_pm_cr_tx_path_pma_tx_divclk_hz { pma_tx_buf_pm_cr_tx_path_pma_tx_divclk_hz pma_tx_buf_pm_cr_tx_path_datawidth } {
  set temp [expr {wide(double($pma_tx_buf_pm_cr_tx_path_pma_tx_divclk_hz)*$pma_tx_buf_pm_cr_tx_path_datawidth)}]
  return "${temp} bps"
}

##############################
# mapping for rx_divclk as datarate/datawidth (first strip off units from datarate)
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_rx_buf_pm_cr_rx_path_pma_rx_divclk_hz { pma_rx_buf_pm_cr_rx_path_datarate_bps pma_rx_buf_pm_cr_rx_path_datawidth } {  
  variable CONST_ALL_ONES_30_BITS_DECIMAL
  set val [expr {wide(double($pma_rx_buf_pm_cr_rx_path_datarate_bps)/$pma_rx_buf_pm_cr_rx_path_datawidth)}]
  #the error messages would not make sense if we dont limit the assigned value to upper limit
  if {$val > $CONST_ALL_ONES_30_BITS_DECIMAL} {
    set val $CONST_ALL_ONES_30_BITS_DECIMAL
  }
  return $val
}

##############################
# unmaps rx_divclk to datarate as rx_divclk*datawidth (adds units bps as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_rx_buf_pm_cr_rx_path_pma_rx_divclk_hz { pma_rx_buf_pm_cr_rx_path_pma_rx_divclk_hz pma_rx_buf_pm_cr_rx_path_datawidth } {
  set temp [expr {wide(double($pma_rx_buf_pm_cr_rx_path_pma_rx_divclk_hz)*$pma_rx_buf_pm_cr_rx_path_datawidth)}]
}

##############################
# mapping for l_tx_transfer_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_l_tx_transfer_clk_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_tx_adapt_pcs_width l_tx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_tx_adapt_pcs_width)} ]	
  } 
 
  if { $l_tx_fifo_transfer_mode != "x1" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps l_tx_transfer_clk_hz to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_l_tx_transfer_clk_hz { PROP_NAME l_tx_transfer_clk_hz datapath_select l_pcs_pma_width l_tx_adapt_pcs_width l_tx_fifo_transfer_mode } {

  if {$datapath_select == "Enhanced"} {
	set temp_datarate [expr {wide(double($l_tx_transfer_clk_hz)*$l_pcs_pma_width)} ]
  } else {
	set temp_datarate [expr {wide(double($l_tx_transfer_clk_hz)*$l_tx_adapt_pcs_width)} ]	
  } 
 
  if { $l_tx_fifo_transfer_mode != "x1" } {
	set temp_datarate [expr {$temp_datarate / 2}]
  }

  return $temp_datarate
}

##############################
# mapping for l_rx_transfer_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_l_rx_transfer_clk_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_rx_adapt_pcs_width l_rx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
    set temp_clk [expr {wide(double($data_rate_bps)/$l_rx_adapt_pcs_width)} ]	
  } 
 
  if { $l_rx_fifo_transfer_mode != "x1" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps l_rx_transfer_clk_hz to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_l_rx_transfer_clk_hz { PROP_NAME l_rx_transfer_clk_hz datapath_select l_pcs_pma_width l_rx_adapt_pcs_width l_rx_fifo_transfer_mode } {

  if {$datapath_select == "Enhanced"} {
	set temp_datarate [expr {wide(double($l_rx_transfer_clk_hz)*$l_pcs_pma_width)} ]
  } else {
    set temp_datarate [expr {wide(double($l_rx_transfer_clk_hz)*$l_rx_adapt_pcs_width)} ]	
  } 
 
  if { $l_rx_fifo_transfer_mode != "x1" } {
	set temp_datarate [expr {$temp_datarate / 2}]
  }

  return $temp_datarate
}

##############################
# mapping for hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz { PROP_NAME data_rate_bps enable_hip l_tx_adapt_pcs_width l_tx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } else {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_tx_adapt_pcs_width)} ]	
  } 
 
  if { $l_tx_fifo_transfer_mode == "x1x2" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz { hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz l_tx_adapt_pcs_width l_tx_fifo_transfer_mode } {
  
  set temp_datarate [expr {wide(double($hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz)*$l_tx_adapt_pcs_width)}]
  
  if { $l_tx_fifo_transfer_mode == "x1x2" } {
	set temp_datarate [expr {$temp_datarate / 2}]
  }

  return $temp_datarate
}

##############################
# mapping for hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz { PROP_NAME enable_hip l_tx_transfer_clk_hz tx_fifo_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip || ($tx_fifo_mode == "Register") } {
	set temp_clk 0
  } else {
	set temp_clk $l_tx_transfer_clk_hz
  } 

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz to l_tx_transfer_clk
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz { hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz } {
  return $hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz
}

##############################
# mapping for hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_tx_adapt_pcs_width } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_tx_adapt_pcs_width)} ]	
  } 

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz { hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz datapath_select l_pcs_pma_width l_tx_adapt_pcs_width } {
  if {$datapath_select == "Enhanced"} {
	set temp_datarate [expr {wide(double($hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz)*$l_pcs_pma_width)} ]
  } else {
	set temp_datarate [expr {wide(double($hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz)*$l_tx_adapt_pcs_width)} ]	
  } 
  return $temp_datarate
}

##############################
# mapping for hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz { PROP_NAME data_rate_bps enable_hip rx_fifo_mode l_rx_adapt_pcs_width l_rx_fifo_transfer_mode } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip || $rx_fifo_mode == "Phase compensation-Register" || $rx_fifo_mode == "Register"} {
	set temp_clk 0
  } else {
    set temp_clk [expr {wide(double($data_rate_bps)/$l_rx_adapt_pcs_width)} ]	
  } 
 
  if { $l_rx_fifo_transfer_mode == "x1x2" } {
	set temp_clk [expr {$temp_clk * 2}]
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps pld_rx_clk to datarate as pld_rx_clk*datawidth (adds units bps as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz { hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz l_rx_adapt_pcs_width l_rx_fifo_transfer_mode } {
  set temp_datarate [expr {wide(double($hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz)*$l_rx_adapt_pcs_width)}]

  if { $l_rx_fifo_transfer_mode == "x1x2" } {
	set temp_datarate [expr {$temp_datarate / 2}]
  }

  return $temp_datarate
}

##############################
# mapping for hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz { PROP_NAME data_rate_bps datapath_select enable_hip l_pcs_pma_width l_rx_adapt_pcs_width } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  if {$enable_hip} {
	set temp_clk 0
  } elseif {$datapath_select == "Enhanced"} {
	set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
  } else {
    set temp_clk [expr {wide(double($data_rate_bps)/$l_rx_adapt_pcs_width)} ]	
  }  

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps pld_rx_clk to datarate as pld_rx_clk*datawidth (adds units bps as well)
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz { hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz datapath_select l_pcs_pma_width l_rx_adapt_pcs_width } {

  if {$datapath_select == "Enhanced"} {
	set temp_datarate [expr {wide(double($hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz)*$l_pcs_pma_width)} ]
  } else {
    set temp_datarate [expr {wide(double($hssi_adapt_rx_hd_hssiadapt_pld_pcs_rx_clk_out_hz)*$l_rx_adapt_pcs_width)} ]	
  }  

  return $temp_datarate
}

##############################
# mapping for hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz { PROP_NAME data_rate_bps l_pcs_pma_width hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz hssi_adapt_tx_aib_clk_sel hssi_adapt_tx_pma_aib_tx_clk_expected_setting } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL

  set legal_values [list "dynamic" "unused" "x1" "x2" "x2_not_from_chnl"]

  if { $hssi_adapt_tx_aib_clk_sel == "aib_clk_pma_aib_tx_clk" } {
	if { $hssi_adapt_tx_pma_aib_tx_clk_expected_setting == "x1" } {
	    set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
	} elseif { $hssi_adapt_tx_pma_aib_tx_clk_expected_setting == "x2" || $hssi_adapt_tx_pma_aib_tx_clk_expected_setting == "x2_not_from_chnl" } {
		set temp_clk [expr {wide(double($data_rate_bps)*2/$l_pcs_pma_width)} ]
	} else {
		set temp_clk 0
	}	
  } else {
	set temp_clk $hssi_adapt_tx_hd_hssiadapt_pld_pcs_tx_clk_out_hz
  }
	
  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps pld_rx_clk to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz { hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz l_pcs_pma_width l_tx_adapt_pcs_width hssi_adapt_tx_aib_clk_sel datapath_select} {

  if { $hssi_adapt_tx_aib_clk_sel == "aib_clk_pma_aib_tx_clk" } {		
	set temp_datarate [expr {wide(double($hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz)*$l_pcs_pma_width/2)} ]
  } elseif {$datapath_select == "Enhanced"} {
	set temp_datarate [expr {wide(double($hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz)*$l_pcs_pma_width)} ]
  } else {
	set temp_datarate [expr {wide(double($hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz)*$l_tx_adapt_pcs_width)} ]	
  } 

  return $temp_datarate
}

##############################
# mapping for hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz { PROP_NAME data_rate_bps enable_hip l_pcs_pma_width hssi_adapt_rx_pma_aib_rx_clk_expected_setting } {
  variable CONST_ALL_ONES_31_BITS_DECIMAL
  	
  if {$enable_hip} {
	set temp_clk 0
  } else {
	if { $hssi_adapt_rx_pma_aib_rx_clk_expected_setting == "x1" } {
		set temp_clk [expr {wide(double($data_rate_bps)/$l_pcs_pma_width)} ]
	} elseif { $hssi_adapt_rx_pma_aib_rx_clk_expected_setting == "x2" } {
		set temp_clk [expr {wide(double($data_rate_bps)*2/$l_pcs_pma_width)} ]	
	} else {
		set temp_clk 0
	}
  }

  #The error messages would not make sense if we dont limit the assigned value to upper limit
  if {$temp_clk > $CONST_ALL_ONES_31_BITS_DECIMAL} {
    set temp_clk $CONST_ALL_ONES_31_BITS_DECIMAL
  }

  return $temp_clk
}

##############################
# unmaps hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz to datarate
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz { hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz l_pcs_pma_width } {
	set temp_datarate [expr {wide(double($hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz)*$l_pcs_pma_width/2)} ]
	return $temp_datarate
}

##############################
# mapping for hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_hd_hssiadapt_hip_aib_clk_2x_hz { PROP_NAME hip_mode hip_prot_mode hip_channels } {
  if {$hip_mode == "disable_hip"} {
	set temp_clk 0
  } elseif {$hip_mode == "debug_chnl"} {
 	set temp_clk "500000000"
  } else {
	if {$hip_prot_mode == "gen1"} {
		set temp_clk "250000000"
	} elseif {$hip_prot_mode == "gen2"} {
		set temp_clk [expr {$hip_channels == "x16" ? "500000000" : "250000000"}]
	} else {
		set temp_clk [expr {$hip_channels == "x16" ? "1000000000" 
							: $hip_channels == "x8" ? "500000000"
							: "250000000" }]
	}
  }  
  return $temp_clk
}

##############################
# mapping for hssi_adapt_rx_hd_hssiadapt_pma_aib_rx_clk_hz
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_tx_hd_hssiadapt_hip_aib_clk_2x_hz { PROP_NAME hip_mode hip_prot_mode hip_channels } {
  if {$hip_mode == "disable_hip"} {
	set temp_clk 0
  } elseif {$hip_mode == "debug_chnl"} {
	set temp_clk "500000000"
  } else {
	if {$hip_prot_mode == "gen1"} {
		set temp_clk "250000000"
	} elseif {$hip_prot_mode == "gen2"} {
		set temp_clk [expr {$hip_channels == "x16" ? "500000000" : "250000000"}]
	} else {
		set temp_clk [expr {$hip_channels == "x16" ? "1000000000" 
							: $hip_channels == "x8" ? "500000000"
							: "250000000" }]
	}
  }  
  return $temp_clk
}

##############################
# mapping for hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx based on l_pcs_pma_width and protocol_mode parameters
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx {l_pcs_pma_width protocol_mode} {
  set value [ expr { $protocol_mode == "pipe_g3" ? "pcie_g3_dyn_dw_tx"
    : "pma_${l_pcs_pma_width}b_tx" }]
  return $value
}

##############################
# unmaps pma_dw_tx to l_pcs_pma_width based on protocol_mode
# the first case should never occur by construction but must ve there for completeness
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx {hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx} {
  set value [expr { \
      $hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx == "pcie_g3_dyn_dw_tx"   ? [list 8 10 16 20 32 40 64 ]
    : [regsub {(pma_)([0-9]*)(b_tx)} $hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_dw_tx {\2}] }]

  return $value
}

##############################
# mapping for hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx based on l_pcs_pma_width and protocol_mode parameters
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx {l_pcs_pma_width protocol_mode} {
  set value [ expr { $protocol_mode == "pipe_g3" ? "pcie_g3_dyn_dw_rx"
    : "pma_${l_pcs_pma_width}b_rx" }]
  return $value
}

##############################
# unmaps pma_dw_rx to l_pcs_pma_width based on protocol_mode
# the first case should never occur by construction but must ve there for completeness
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx {hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx} {
  set value [expr { \
      $hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx == "pcie_g3_dyn_dw_rx"   ? [list 8 10 16 20 32 40 64 ]
    : [regsub {(pma_)([0-9]*)(b_rx)} $hssi_rx_pld_pcs_interface_hd_pcs_channel_pma_dw_rx {\2}] }]

  return $value
}

##############################
# Maps std_rx_word_aligner_pattern_len to hssi_8g_rx_pcs_pma_dw
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_8g_rx_pcs_wa_pd { std_rx_word_aligner_pattern_len hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {
  set value [expr { \
      $std_rx_word_aligner_pattern_len == "7"   ? "wa_pd_7"
    : $std_rx_word_aligner_pattern_len == "8" && $hssi_8g_rx_pcs_pma_dw == "eight_bit" ? "wa_pd_8_sw"
    : $std_rx_word_aligner_pattern_len == "8" && $hssi_8g_rx_pcs_pma_dw != "eight_bit" ? "wa_pd_8_dw"
    : $std_rx_word_aligner_pattern_len == "10"  ? "wa_pd_10"
    : $std_rx_word_aligner_pattern_len == "16" && ($hssi_8g_rx_pcs_pma_dw == "eight_bit" || $hssi_8g_rx_pcs_wa_boundary_lock_ctrl == "bit_slip") ? "wa_pd_16_sw"
    : $std_rx_word_aligner_pattern_len == "16" && ($hssi_8g_rx_pcs_pma_dw != "eight_bit" && $hssi_8g_rx_pcs_wa_boundary_lock_ctrl != "bit_slip") ? "wa_pd_16_dw"
    : $std_rx_word_aligner_pattern_len == "20"  ? "wa_pd_20"
    : $std_rx_word_aligner_pattern_len == "32"  ? "wa_pd_32"
    : "wa_pd_40" }]

  return $value
}

##############################
# Unmaps to std_rx_word_aligner_pattern_len from hssi_8g_rx_pcs_pma_dw
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_hssi_8g_rx_pcs_wa_pd { hssi_8g_rx_pcs_wa_pd } {
  set value [expr { \
      $hssi_8g_rx_pcs_wa_pd == "wa_pd_7"  ? "7"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_8_sw" ? "8"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_8_dw" ? "8"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_10" ? "10"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_16_sw" ? "16"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_16_dw" ? "16"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_20" ? "20"
    : $hssi_8g_rx_pcs_wa_pd == "wa_pd_32" ? "32"
    : "40" }]

  return $value
}

##############################
# Maps protocol_mode to l_protocol_mode
# primary role of l_protocol_mode is not to do separate mappings to tx/rx pma protocol mode parameter
# also mapping is done with map/ummap calls so that messages related to protocol_mode can trace back to user parameter
##############################
proc ::altera_xcvr_native_s10::parameters::map_l_protocol_mode {protocol_mode pma_mode} {
  set value [expr { \
      $protocol_mode == "disabled" ? "disabled"
    : $pma_mode == "SATA" ? "sata"
    : $pma_mode == "GPON" ? "gpon"
    : $pma_mode == "QPI"  ? "qpi"	
    : $protocol_mode }]

  return $value
}

##############################
# Unmaps to protocol_mode from l_protocol_mode
# currently there is not a rule directed for xtx/xrx pma protocol_mode parameter
# hence this function is useless in a sense
# if such a rule is implemented in future, then this function will be useful
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_l_protocol_mode {l_protocol_mode} {
  set value [expr { \
      $l_protocol_mode == "sata" ? "basic_std"
    : $l_protocol_mode == "gpon" ? [list "basic_std" "basic_enh" ]
    : $l_protocol_mode == "qpi"  ? "pcs_direct"
	: $l_protocol_mode == "disabled" ? "disabled"
    : $l_protocol_mode }]

  return $value
}

##############################
# Maps l_protocol_mode to pma_rx_buf_term_tri_enable
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_rx_buf_term_tri_enable { l_protocol_mode } {
	set value "disable_tri"
	return $value
}

##############################
# Maps rx_pma_div_clkout_divider to pma_rx_deser_clkdivrx_user_mode
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_rx_deser_clkdivrx_user_mode { rx_pma_div_clkout_divider rx_enable l_enable_rx_pma_div_clkout  } {
  set value [expr {!$rx_enable || !$l_enable_rx_pma_div_clkout ? "clkdivrx_user_disabled"
    : $rx_pma_div_clkout_divider == "1" ?  "clkdivrx_user_clkdiv"
    : $rx_pma_div_clkout_divider == "2" ?  "clkdivrx_user_clkdiv_div2"
    : $rx_pma_div_clkout_divider == "33" ? "clkdivrx_user_div33"
    : $rx_pma_div_clkout_divider == "40" ? "clkdivrx_user_div40"
    : $rx_pma_div_clkout_divider == "66" ? "clkdivrx_user_div66"
    : "clkdivrx_user_disabled" }]

  return $value
}

##############################
# Unmaps to rx_pma_div_clkout_divider from pma_rx_deser_clkdivrx_user_mode
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_rx_deser_clkdivrx_user_mode {pma_rx_deser_clkdivrx_user_mode rx_enable l_enable_rx_pma_div_clkout  } {
  set value [expr { \
      ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_disabled")      ?  "Disabled"
    : ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_clkdiv")        ?  "1"
    : ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_clkdiv_div2")   ?  "2"
    : ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div33")         ?  "33"
    : ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div40")         ?  "40"
    : ( ($rx_enable && $l_enable_rx_pma_div_clkout) && $pma_rx_deser_clkdivrx_user_mode=="clkdivrx_user_div66")         ?  "66"
    : ( !$rx_enable || !$l_enable_rx_pma_div_clkout )                                                                   ?  [list "Disabled" "1" "2" "33" "40" "66"]
    : "" }]
  return $value
}

##############################
# Maps device to pcs_speedgrade
# mapping is done with map/ummap calls so that messages related to pcs_speedgrade can trace back to corresponding user parameter (i.e selected device)
##############################
proc ::altera_xcvr_native_s10::parameters::map_pcs_speedgrade {device_family device} {
  set operating_temperature [::alt_xcvr::utils::device::get_operating_temperature $device_family $device]
  set temp_pcs_speed_grade [::alt_xcvr::utils::device::get_pcs_speedgrade $device_family $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_pma_speedgrade $device_family $device]
  
  #TODO: case:317750 (leeping: commented this out unless marketing needs this special mapping again in the future for Nadder)
  #set operating_temperature [expr { ($temp_pma_speed_grade == 4) && ($temp_pcs_speed_grade == 3) && ($operating_temperature == "m") ? "i" : $operating_temperature }]
  #Quartus to ICD RBC mapping
  #set temp_pcs_speed_grade [expr {$temp_pcs_speed_grade+1}]
  set temp_pcs_speed_grade "${operating_temperature}${temp_pcs_speed_grade}" 
  return $temp_pcs_speed_grade
}

##############################
# Ideally we would want to have an unmap fcuntion converting pcs_speedgrade to device but the mapping is not one-to-one
# hence we simply return a message
# consequence: user might see a message in qsys: "the current selection for device(10AG4RF456) is not valid. Valid selections are: Refer to data sheet for valid device options
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pcs_speedgrade {pcs_speedgrade} {
  return "Refer to data sheet for valid device options"
}

##############################
# Maps device to core speedgrade
##############################
proc ::altera_xcvr_native_s10::parameters::map_pcs_speedgrade_no_temp {device_family device} {  
  set temp_pcs_speed_grade [::alt_xcvr::utils::device::get_pcs_speedgrade $device_family $device]
  return $temp_pcs_speed_grade
}

##############################
# Maps device to pma speedgrade
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_speedgrade_no_temp {device_family device} {    
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_pma_speedgrade $device_family $device]
  return $temp_pma_speed_grade
}

##############################
# Maps device to pma_speedgrade
# mapping is done with map/ummap calls so that messages related to pma_speedgrade can trace back to corresponding user parameter (i.e selected device)
##############################
proc ::altera_xcvr_native_s10::parameters::map_pma_speedgrade {device_family device} {
  set operating_temperature [::alt_xcvr::utils::device::get_operating_temperature $device_family $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_pma_speedgrade $device_family $device]
  #set temp_pcs_speed_grade [::alt_xcvr::utils::device::get_pcs_speedgrade $device_family $device]
  #TODO: case:317750 (leeping: commented this out unless marketing needs this special mapping again in the future for Nadder)
  #set operating_temperature [expr { ($temp_pma_speed_grade == 4) && ($temp_pcs_speed_grade == 3) && ($operating_temperature == "m") ? "i" : $operating_temperature }]
  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}" 
  return $temp_pma_speed_grade
}

##############################
# Ideally we would want to have an unmap fcuntion converting pma_speedgrade to device but the mapping is not one-to-one
# hence we simply return a message
# consequence: user might see a message in qsys: "the current selection for device(10SX280X3) is not valid. Valid selections are: Refer to data sheet for valid device options
##############################
proc ::altera_xcvr_native_s10::parameters::unmap_pma_speedgrade {pma_speedgrade} {
  return "Refer to data sheet for valid device options"
}

##############################
# If TX/RX channel and manual bonding settings are enabled , map chnl_bonding settings to manual_aib_bonding_mode
# else map chnl_bonding settings to disable --> dummy setting since M_AUTOSET is set to true in this case for RBC rules to auto-set the settings
##############################
proc ::altera_xcvr_native_s10::parameters::map_adapt_chnl_bonding {enable_manual_bonding_settings manual_aib_bonding_mode} {
	if { $enable_manual_bonding_settings } {
		set value [expr { $manual_aib_bonding_mode == "individual" ? "disable" : "enable" } ]		
	} else {
		# Dummy setting since M_AUTOSET is set to true in this case for RBC rules to auto-set the settings
		set value "disable"
	}
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_chnl_bonding {enable_manual_bonding_settings manual_rx_hssi_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_chnl_bonding $enable_manual_bonding_settings $manual_rx_hssi_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_tx_chnl_bonding {enable_manual_bonding_settings manual_tx_hssi_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_chnl_bonding $enable_manual_bonding_settings $manual_tx_hssi_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_rx_chnl_bonding {enable_manual_bonding_settings manual_rx_core_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_chnl_bonding $enable_manual_bonding_settings $manual_rx_core_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_chnl_bonding {enable_manual_bonding_settings manual_tx_core_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_chnl_bonding $enable_manual_bonding_settings $manual_tx_core_aib_bonding_mode]
	return $value
}

##############################
# If TX/RX channel and manual bonding settings are enabled , map ctrl_plane_bonding settings to manual_aib_bonding_mode
# else map ctrl_plane_bonding settings to "individual" --> dummy setting since M_AUTOSET is set to true in this case for RBC rules to auto-set the settings
##############################
proc ::altera_xcvr_native_s10::parameters::map_adapt_ctrl_plane_bonding {enable_manual_bonding_settings manual_aib_bonding_mode} {
	if { $enable_manual_bonding_settings } {	
		set value $manual_aib_bonding_mode				
	} else {
		set value "individual"
	}	
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_ctrl_plane_bonding {enable_manual_bonding_settings manual_rx_hssi_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_ctrl_plane_bonding $enable_manual_bonding_settings $manual_rx_hssi_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_tx_ctrl_plane_bonding {enable_manual_bonding_settings manual_tx_hssi_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_ctrl_plane_bonding $enable_manual_bonding_settings $manual_tx_hssi_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_rx_ctrl_plane_bonding {enable_manual_bonding_settings manual_rx_core_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_ctrl_plane_bonding $enable_manual_bonding_settings $manual_rx_core_aib_bonding_mode]
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_ctrl_plane_bonding {enable_manual_bonding_settings manual_tx_core_aib_bonding_mode} {
	set value [::altera_xcvr_native_s10::parameters::map_adapt_ctrl_plane_bonding $enable_manual_bonding_settings $manual_tx_core_aib_bonding_mode]
	return $value
}

##############################
# Map hssi_adapt_rx_txeq_mode based on protocol_mode and l_crete_nf
# case:312000
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_txeq_mode { protocol_mode l_crete_nf } {
	set value [expr { ($protocol_mode == "pipe_g3") ? 
				$l_crete_nf ? "eq_legacy_mode" : "eq_pipe_dir_mode" 
				: "eq_disable" } ]	
	return $value	
}

##############################
# Map hssi_rx_pld_pcs_interface_hd_pcs_channel_ctrl_plane_bonding_rx from bonded_mode
# Related FB case:354109
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_rx_pld_pcs_interface_hd_pcs_channel_ctrl_plane_bonding_rx { bonded_mode tx_enable protocol_mode } {
	if { $tx_enable } {
		if { $protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" } {
			set value [expr { $bonded_mode == "pma_pcs" ? "ctrl_master_rx" : "individual_rx" } ]
		} else {
			set value "individual_rx"
		}		
	} else {
		set value "individual_rx"
	}
	return $value
}

##############################
# Map hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_if_ctrl_plane_bonding from bonded_mode
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_tx_pld_pcs_interface_hd_pcs_channel_pma_if_ctrl_plane_bonding { bonded_mode protocol_mode } {
	if { $protocol_mode == "pipe_g1" || $protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3" } {
		set value [expr { $bonded_mode == "pma_pcs" ? "ctrl_master" : "individual" } ]
	} else {
		set value "individual"
	}		
	return $value
}

##############################
# Map hssi_pldadapt_tx_fifo_rd_clk_sel in loopback mode
#  otherwise, the value will be autoset by validation callback
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_fifo_rd_clk_sel { loopback_tx_clk_sel hssi_pldadapt_tx_loopback_mode } {
	if { $hssi_pldadapt_tx_loopback_mode == "enable" } {		
		set value [expr { $loopback_tx_clk_sel == "external_clk" ? "fifo_rd_pld_tx_clk2" : "fifo_rd_pma_aib_tx_clk" } ]
	} else {
		set value "fifo_rd_pma_aib_tx_clk"
	}		
	return $value
}

##############################
# Map adapter sup_mode 
##############################
proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_tx_sup_mode { support_mode enable_advanced_user_mode } {
	if {$enable_advanced_user_mode} {
		set value "advanced_user_mode"
	} else {
		set value $support_mode
	}
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_pldadapt_rx_sup_mode { support_mode enable_advanced_user_mode } {
	if {$enable_advanced_user_mode} {
		set value "advanced_user_mode"
	} else {
		set value $support_mode
	}
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_tx_sup_mode { support_mode enable_advanced_user_mode } {
	if {$enable_advanced_user_mode} {
		set value "advanced_user_mode"
	} else {
		set value $support_mode
	}
	return $value
}

proc ::altera_xcvr_native_s10::parameters::map_hssi_adapt_rx_sup_mode { support_mode enable_advanced_user_mode } {
	if {$enable_advanced_user_mode} {
		set value "advanced_user_mode"
	} else {
		set value $support_mode
	}
	return $value
}

########################################################################################################################
#											Test Functions
########################################################################################################################

##############################
# currently unmap functions for adaptation parameters are tested only through the RBCs, (which is not extensive)
# since RBCs are changing and these functions are complex, it will be handy to have this test function available
# this is a manual test, to make it work this function must be registered as a validation callback to the parameters listed below and legal values should be changed manually
# the default is all available options are listed as valid as well as a dummy option to see the effects if there is a new enumaration is added to the parameter
##############################
proc ::altera_xcvr_native_s10::parameters::adaptation_unmap_test { PROP_NAME PROP_VALUE} {
  if {$PROP_NAME == "pma_adapt_adapt_mode"} {  
    set legal_values [list "dummy" "manual" "dfe_vga" "ctle" "ctle_vga" "ctle_vga_dfe"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_adapt_adp_dfe_mode"} {
    set legal_values [list "dummy" "radp_dfe_mode_0" "radp_dfe_mode_1" "radp_dfe_mode_2" "radp_dfe_mode_3" "radp_dfe_mode_4" "radp_dfe_mode_5" "radp_dfe_mode_6" "radp_dfe_mode_7"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_fixedtap"} {
    set legal_values [list "dummy" "fixtap_dfe_enable" "fixtap_dfe_powerdown"]  
#    set legal_values [list "dummy"]
    
  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_fxtap4t7"} {
    set legal_values [list "dummy" "fxtap4t7_enable" "fxtap4t7_powerdown"]  
#    set legal_values [list "dummy"]

  } elseif {$PROP_NAME == "pma_rx_dfe_pdb_floattap"} {
    set legal_values [list "dummy" "floattap_dfe_enable" "floattap_dfe_powerdown"]  
#    set legal_values [list "dummy"]

  } else {  
    set legal_values [list "dummy"]
    
  }
  auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { }
}
