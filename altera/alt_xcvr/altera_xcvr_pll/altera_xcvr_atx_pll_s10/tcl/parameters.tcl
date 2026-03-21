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


## \file parameters.tcl
# lists all the parameters used in ND ATX PLL IP GUI & HDL WRAPPER, as well as associated validation callbacks

package provide altera_xcvr_atx_pll_s10::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require ct1_atx_pll::parameters
#package require ct1_mcgb::parameters
package require altera_xcvr_atx_pll_s10::pll_calculations
package require altera_xcvr_atx_pll_s10::parameters::data
package require mcgb_package_s10::mcgb
package require alt_xcvr::utils::reconfiguration_stratix10

namespace eval ::altera_xcvr_atx_pll_s10::parameters:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace import ::altera_xcvr_atx_pll_s10::pll_calculations::*

   namespace export \
      declare_parameters \
      validate \

  variable package_name
   variable display_items_pll
   variable generation_display_items
   variable parameters
   variable mapped_parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable logical_parameters
   variable static_hdl_parameters
   set package_name "ct1_atx_pll::parameters"

    # Initialize variable
    set package_name "altera_xcvr_atx_pll_s10::parameters"
    set display_items_pll [altera_xcvr_atx_pll_s10::parameters::data::get_variable "display_items_pll"]
    set generation_display_items [altera_xcvr_atx_pll_s10::parameters::data::get_variable "generation_display_items"]
    set parameters [altera_xcvr_atx_pll_s10::parameters::data::get_variable "parameters"]
    set mapped_parameters [altera_xcvr_atx_pll_s10::parameters::data::get_variable "mapped_parameters"]
    set parameters_allowed_range [altera_xcvr_atx_pll_s10::parameters::data::get_variable "parameters_allowed_range"]
    set atom_parameters [altera_xcvr_atx_pll_s10::parameters::data::get_variable "atom_parameters"]
    set logical_parameters [altera_xcvr_atx_pll_s10::parameters::data::get_variable "logical_parameters"]
    set static_hdl_parameters [altera_xcvr_atx_pll_s10::parameters::data::get_variable "static_hdl_parameters"]
    

set gui_parameter_list [list]
set gui_parameter_values [list]
}

##################################################################################################################################################
#
##################################################################################################################################################
proc ::altera_xcvr_atx_pll_s10::parameters::declare_parameters { {device_family "Stratix 10"} } {
   variable display_items_pll
   variable generation_display_items
   variable parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable mapped_parameters
   variable logical_parameters
   variable static_hdl_parameters

   variable gui_parameter_list
   variable gui_parameter_values

   # Which parameters are included in reconfig reports is parameter dependent
   ip_add_user_property_type M_RCFG_REPORT integer

   ::alt_xcvr::utils::reconfiguration_stratix10::declare_parameters 1
   ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_atx_pll_s10"
   ip_declare_parameters [::ct1_atx_pll::parameters::get_parameters]
   
   # Mark HDL parameters
   # If parameter is static that means not set by IP but set by Quartus so don't put it in mif 
   set ct1_atx_pll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE ct1_atx_pll]]
   foreach param $ct1_atx_pll_parameters {
     if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
       ip_set "parameter.${param}.HDL_PARAMETER" 1
       ip_set "parameter.${param}.M_RCFG_REPORT" 1
     }
     
       ip_set "parameter.${param}.M_AUTOSET" "true"
       ip_set "parameter.${param}.M_AUTOWARN" "true"
   }

   ip_declare_parameters $parameters
   ip_declare_parameters $parameters_allowed_range
   ip_declare_parameters $mapped_parameters
   ip_declare_parameters $atom_parameters
   ip_declare_parameters $logical_parameters
   ip_declare_parameters $static_hdl_parameters

   ::mcgb_package_s10::mcgb::set_hip_cal_done_enable_maps_from enable_hip_cal_done_port
   ::mcgb_package_s10::mcgb::set_output_clock_frequency_maps_from output_clock_frequency
   ::mcgb_package_s10::mcgb::set_primary_pll_buffer_maps_from primary_pll_buffer
   ::mcgb_package_s10::mcgb::set_protocol_mode_maps_from prot_mode_fnl
   ::mcgb_package_s10::mcgb::set_silicon_rev_maps_from device_revision
   ::mcgb_package_s10::mcgb::declare_mcgb_parameters

   ip_declare_display_items $display_items_pll

   ::mcgb_package_s10::mcgb::set_mcgb_display_item_properties "" tab
   ::mcgb_package_s10::mcgb::declare_mcgb_display_items

   ::alt_xcvr::utils::reconfiguration_stratix10::declare_display_items "" tab 1

   ip_declare_display_items $generation_display_items

   # Initialize device information (to allow sharing of this function across device families)
   ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
   ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

   # Initialize part number & revision
   ip_set "parameter.device.SYSTEM_INFO" DEVICE
   
   ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
   ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE
   ip_set "parameter.base_device.DEFAULT_VALUE" "nd5";

    # To have a parameter displayed in the "Advanced Parameters" tab, set the M_CONTEXT property
    # of that parameter to "advanced" and set its DISPLAY_NAME property to a valid string.
   add_display_item "" "Advanced Parameters" GROUP tab   

   add_parameter gui_parameter_list STRING_LIST
   set_parameter_property gui_parameter_list DISPLAY_NAME "Parameter Names"
   set_parameter_property gui_parameter_list DERIVED true
   set_parameter_property gui_parameter_list DESCRIPTION "Shows the list of advanced PLL parameters"

   add_parameter gui_parameter_values STRING_LIST
   set_parameter_property gui_parameter_values DISPLAY_NAME "Parameter Values"
   set_parameter_property gui_parameter_values DERIVED true
   set_parameter_property gui_parameter_values DESCRIPTION "Shows the list of values for the advanced PLL parameters"

   add_display_item "Advanced Parameters" "parameterTable" GROUP TABLE 
   set_display_item_property "parameterTable" DISPLAY_HINT { table fixed_size rows:24 } 
   add_display_item "parameterTable" gui_parameter_list parameter
   add_display_item "parameterTable" gui_parameter_values parameter

  # Grab Quartus INI's
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_atx_pll_10_advanced ENABLED]
  ip_set "parameter.enable_hip_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_atx_pll_10_hip_options ENABLED]
  ip_set "parameter.enable_debug_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_atx_pll_10_debug ENABLED]
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate {} {
   ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]

    variable gui_parameter_list
    variable gui_parameter_values

    set parameter_list [list]
    set parameter_values_list [list]

    set advanced_params [ip_get_matching_parameters [dict set criteria M_CONTEXT advanced]]
    foreach param $advanced_params {
        set name [ip_get "parameter.${param}.DISPLAY_NAME"]
        if { $name != "NOVAL" } {
            lappend parameter_list $name
            lappend parameter_values_list [ip_get "parameter.${param}.value"]
        }
    }

    set_parameter_value gui_parameter_list $parameter_list
    set_parameter_value gui_parameter_values $parameter_values_list
   ip_validate_parameters
   ip_validate_display_items
}

# This callback maps the analog voltage setting to the power mode setting of the ATX PLL
proc ::altera_xcvr_atx_pll_s10::parameters::set_power_mode { usr_analog_voltage } {

	  if       { [string compare -nocase $usr_analog_voltage "1_1V"]==0 } {
	    ip_set "parameter.power_mode.value" "high_perf"
    } elseif { [string compare -nocase $usr_analog_voltage "1_0V"]==0 } {
	    ip_set "parameter.power_mode.value" "mid_power"
    } elseif { [string compare -nocase $usr_analog_voltage "0_9V"]==0 } {
	    ip_set "parameter.power_mode.value" "low_power"
    } else {
      ip_message error "The value of usr_analog_voltage cannot be decoded by this IP"
    }
   
    set message "<html><font color=\"blue\">Note - </font>All PLLs and Native PHY instances in a given tile must be configured with the same supply voltage </html>"
    ip_set "display_item.display_base_data_rate.text" $message
}


###################################################################################
# Quartus ini controll for 0_9V enable, by default this voltage is hidden for user
###################################################################################
proc ::altera_xcvr_atx_pll_s10::parameters::update_power_mode { enable_advanced_options } {
	if { $enable_advanced_options} {
		ip_set 	"parameter.usr_analog_voltage.ALLOWED_RANGES" { "1_1V" "1_0V" "0_9V" }
	} else {
		ip_set	"parameter.usr_analog_voltage.ALLOWED_RANGES" { "1_1V" "1_0V"}
	}
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
  if {$PROP_VALUE == "engineering_mode"} {
  	 # FB no: 376215 changed from Error to Warning
    ip_message warning "Engineering support mode has been selected. Engineering mode is for internal use only. Altera does not officially support or guarantee IP configurations for this mode."
  }
}


##
# NOTE: this is a dummy function, for parameters that will eventually be set through a validation_callback (but the functions are not ready yet).
# The parameters are listed in the IP anyways. This is to make sure that they will be part of reconfiguration files.
# However if enumerations for those values changes due to atom map changes, existing IP variant files need to be manually edited.
# This function will enable us to prevent that
#proc ::altera_xcvr_atx_pll_s10::parameters::set_to_default { PROP_NAME } {
#   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
#   ip_set "parameter.${PROP_NAME}.value" $value
#}

##################################################################################################################################################
# functions: converting user parameters to their final form (appropriate for the hdl) 
##################################################################################################################################################

## \TODO some of these functions needs to be implemented as mapped parameters

proc ::altera_xcvr_atx_pll_s10::parameters::validate_pma_speedgrade { device } {
  set operating_temperature [::alt_xcvr::utils::device::get_s10_operating_temperature $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_s10_pma_speedgrade $device]
  ip_message info "For the selected device($device), PLL speed grade is $temp_pma_speed_grade."

  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}"
  ip_set "parameter.pma_speedgrade.value" $temp_pma_speed_grade
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate_device_revision { base_device device} { 
  set temp_device_revision [ct1_atx_pll::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
	  ip_set "parameter.device_revision.value" $temp_device_revision
  } else {
#	set device [ip_get parameter.DEVICE.value]
	ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}

proc ::altera_xcvr_atx_pll_s10::parameters::convert_dsm_mode { enable_fractional } {
   set temp_dsm_mode "dsm_mode_integer"
   
   switch $enable_fractional {
      1   {set temp_dsm_mode "dsm_mode_phase"}
      0   {set temp_dsm_mode "dsm_mode_integer"}
      default  {set temp_dsm_mode "dsm_mode_integer"}
   }
   ip_set "parameter.dsm_mode.value" $temp_dsm_mode    
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_enable_8G_buffer_fnl { primary_pll_buffer } {
   if {       [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
      ip_set "parameter.enable_8G_buffer_fnl.value" "true"
   } elseif { [string compare -nocase $primary_pll_buffer "GXT clock output buffer"]==0 } { 
      ip_set "parameter.enable_8G_buffer_fnl.value" "false"
   } else {
       ## This else condition will not happen in normal case so user will not see this warning so ok to have custom messgae
      ip_set "parameter.enable_8G_buffer_fnl.value" "true"
      ip_message warning "Unexpected primary_pll_buffer($primary_pll_buffer), enabling 8G buffer"              
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_enable_16G_buffer_fnl { primary_pll_buffer } {
   if {       [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
      ip_set "parameter.enable_16G_buffer_fnl.value" "false"
   } elseif { [string compare -nocase $primary_pll_buffer "GXT clock output buffer"]==0 } { 
      ip_set "parameter.enable_16G_buffer_fnl.value" "true"    
   } else {
       ## This else condition will not happen in normal case so user will not see this warning so ok to have custom messgae       
      ip_set "parameter.enable_16G_buffer_fnl.value" "false"    
      ip_message warning "Unexpected primary_pll_buffer($primary_pll_buffer), disabling 16G buffer"              
   }
}


proc  ::altera_xcvr_atx_pll_s10::parameters::convert_fb_select { hssi_pma_cgb_master_cgb_enable_iqtxrxclk} {
   if { [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk enable_iqtxrxclk]==0 } {         
      ip_set "parameter.fb_select_fnl.value" "iqtxrxclk_fb"
   } elseif {  [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk disable_iqtxrxclk]==0} {
      ip_set "parameter.fb_select_fnl.value" "direct_fb"
   } else {
       ## This parameter is not visible and this else condition will not happen in normal case so user will not see this warning so ok to have custom messgae
      ip_set "parameter.fb_select_fnl.value" "direct_fb"
      ip_message warning "Unexpected feedback mode selecting direct_fb"
   }
}  

### MOdify add BW warning in validate_bw_mode
## prot_mode parameter is only for GUI which is stripped down version of prot_mode_fnl (maps to atx_pll_prot_mode atom parameter) which is actual atom parameter 
proc ::altera_xcvr_atx_pll_s10::parameters::validate_prot_mode { PROP_NAME PROP_VALUE prot_mode device_revision device } {
    set device_supports_cascade [::altera_xcvr_atx_pll_s10::parameters::does_this_device_support_cascade $device_revision ]
    set legal_values [list "Basic" "PCIe Gen 1"  "PCIe Gen 2"  "PCIe Gen 3"]
    if { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
	if { !$device_supports_cascade} {
	    auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { device }
	} else {
	    ip_message warning "There are no user selectable bandwidth settings when in cascade mode.Appropriate bandwidth setting will be set by IP"
	}
    } elseif { [string compare -nocase $prot_mode "OTN_cascade"]==0 } {
	if { !$device_supports_cascade} {
	    auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { device }
	} else {
	    ip_message warning "There are no user selectable bandwidth settings when in cascade mode.Appropriate bandwidth setting will be set by IP"
	}
    }
}


## following procedure conevrts gui prot_mode to actual prot_mode
proc ::altera_xcvr_atx_pll_s10::parameters::convert_prot_mode { PROP_NAME PROP_VALUE prot_mode device_revision device } {
   if {       [string compare -nocase $prot_mode Basic]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 1"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen1_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 2"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen2_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 3"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen3_tx"
   } elseif { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
       ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } elseif { [string compare -nocase $prot_mode "OTN_cascade"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } else {
       ## This else condition will not happen in normal case so user will not see this warning so ok to have custom messgae
       ip_set "parameter.prot_mode_fnl.value" "basic_tx"
       ip_message warning "Unexpected prot_mode($prot_mode), selecting basic_tx"
   }       
}    

proc ::altera_xcvr_atx_pll_s10::parameters::update_refclk_index { refclk_cnt } { 
   # update refclk_index allowed range from 0 to refclk_cnt-1
   set new_range 0
   for {set N 1} {$N < $refclk_cnt} {incr N} {
      lappend new_range $N
   }
   ip_set "parameter.refclk_index.ALLOWED_RANGES" $new_range
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_refclk_auto { select_manual_config enable_fractional auto_list set_auto_reference_clock_frequency } {
    
	if {$enable_fractional} {
      # prevent the set_auto_reference_clock_frequency (integer mode) from throwing an illegal range error
      # keep set_auto_reference_clock_frequency's allowed values to the current legal value
      set all_freqs [dict keys $auto_list]
      ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $set_auto_reference_clock_frequency      
    } elseif {!$select_manual_config} {#auto-config
            #get all frequencies
            set all_freqs [dict keys $auto_list]
            #update set_auto_reference_clock_frequency range
            ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $all_freqs 
        } else {#manual-config
            #setting allowed range to anything will prevent user getting meaningless range errors while working in manual mode
            ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" ""
        }
}

##
# feedback_clock_frequency_fnl is the parameter used in calculations
# \todo enable_fb_comp_bonding is directly referenced BAD !!!
proc ::altera_xcvr_atx_pll_s10::parameters::update_fbclk_freq { PROP_NAME select_manual_config enable_fb_comp_bonding_fnl atx_pll_cgb_div atx_pll_pma_width set_output_clock_frequency } {
   if {$enable_fb_comp_bonding_fnl} {
      if { !$select_manual_config } {
         # this is feedback comp bonding mode, in auto configuration --> user cannot set feedback frequency it is calculated
         set temp [expr ($set_output_clock_frequency*2)/($atx_pll_cgb_div*$atx_pll_pma_width)]
         ip_set "parameter.${PROP_NAME}.value" $temp
      } else {
         # manual configuration does not implemented external feecback mode (as well as feedback compensation mode)
         #catched else where do not message
         #ip_message error "::altera_xcvr_atx_pll_s10::parameters::update_fbclk_freq:: (external feedback)/(feedback compensation bonding) not supported in manual configuration mode"
         # set to default anyways
         set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
         ip_set "parameter.${PROP_NAME}.value" $value
      }
   } else {
      # irrelevant hence set to default anyways
      # neither set nor fnl feedback clock frequencies are shown to the user in non external feedback modes and the value itself is irrelevant to the pll calculations
      set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
      ip_set "parameter.${PROP_NAME}.value" $value
   }
}

##
# check enable_mcgb before propagating pma_width selection to atom parameter
proc ::altera_xcvr_atx_pll_s10::parameters::convert_pma_width {PROP_NAME enable_mcgb pma_width} {
   set temp $pma_width
   if {!$enable_mcgb} {
      # do not propogate user selection if cgb not enabled
      set temp [ip_get "parameter.pma_width.DEFAULT_VALUE"]
   }

   ip_set "parameter.${PROP_NAME}.value" $temp
}


##
# check enable_mcgb and enable_bonding_clks before propagating enable_fb_comp_bonding selection to atom parameter
proc ::altera_xcvr_atx_pll_s10::parameters::convert_fb_comp_bonding {PROP_NAME enable_mcgb enable_bonding_clks enable_fb_comp_bonding} {
   if {$enable_mcgb && $enable_bonding_clks && $enable_fb_comp_bonding} {
      # do propogate user selection 
      ip_set "parameter.${PROP_NAME}.value" 1
   } else {
      ip_set "parameter.${PROP_NAME}.value" 0
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate_hip_cal_en { set_hip_cal_en calibration_en } {
  set value [expr { $set_hip_cal_en && $calibration_en == "enable" ? "enable" : "disable"}]
  ip_set "parameter.hip_cal_en.value" $value
}

##################################################################################################################################################
# functions: manual checks
##################################################################################################################################################

##
# checks the output port usage 
# while mcgb is not there and having no output ports in PLL would not make sense
# if both PLL outputs are selected inform user that one will be active only
proc ::altera_xcvr_atx_pll_s10::parameters::validate_check_output_ports_pll {enable_8G_path enable_16G_path enable_mcgb primary_pll_buffer message_level} {
   if {!$enable_mcgb && !$enable_8G_path && !$enable_16G_path } {
      set port_name1  [ip_get "parameter.enable_8G_path.display_name"]
      set port_name2  [ip_get "parameter.enable_16G_path.display_name"]
      ip_message $message_level "Enable at least one output port for PLL using checkbox \"$port_name1\" and/or \"$port_name2\" when Master CGB is not enabled."
   }

   if {$enable_8G_path && $enable_16G_path } {
      set port_name1  [ip_get "parameter.enable_8G_path.display_name"]
      set port_name2  [ip_get "parameter.enable_16G_path.display_name"]
      set buffer_name  [ip_get "parameter.primary_pll_buffer.display_name"]
      ip_message info "Enabling both outputs (\"$port_name1\" and \"$port_name2\") is intended for reconfiguration purposes only. GX and GT outputs are mutually exclusive. Either GX or GT output port will be driven at a time depending on \"$buffer_name\" selection."
   }
}

##
# check the primary pll buffer usage
proc ::altera_xcvr_atx_pll_s10::parameters::validate_primary_pll_buffer {PROP_NAME PROP_VALUE enable_8G_path enable_16G_path prot_mode } {
   # if user enables 8G port but selects the primary buffer as GT this is problematic  - how is this ever be useful for a customer?
   # if user enables 16G port but selects the primary buffer as GX this is problematic - how is this ever be useful for a customer?
   set legal_values [expr { $enable_8G_path && !$enable_16G_path ? { "GX clock output buffer" }
                         :  !$enable_8G_path && $enable_16G_path ? { "GXT clock output buffer" }
                         :                                         { "GX clock output buffer" "GXT clock output buffer" } }]

   auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values { enable_8G_path enable_16G_path }
}

##
# check the users setting for output clock frequency vs the primary buffer
proc ::altera_xcvr_atx_pll_s10::parameters::validate_set_output_clock_frequency { set_output_clock_frequency primary_pll_buffer atx_pll_f_min_vco atx_pll_f_max_vco atx_pll_f_max_x1 primary_use select_manual_config} {
set f_max_in_lc_to_fpll_l_counter "700000000"
#$atx_pll_f_max_x1
   #32 is the max L cascade counter
   ## Check in Auto mode the pll output clock frequency is within a range, differenr rules for cascade and non-cascade mode
    if {!$select_manual_config} {
	if {$primary_use == "hssi_cascade"} {
	    set legal_values [list [format "%0.6f" [expr ([omit_units $atx_pll_f_min_vco]/(31*1000000.0))]]:[expr ([omit_units $f_max_in_lc_to_fpll_l_counter]/1000000.0)]]
	} else {
### Now Channel minimum restriction of 1G - Channel runs at 1000 Mhz (1G) min so need to add restriction on the ATX PLL output clock frequency to be >=500 Mhz
#	    set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr ([omit_units $atx_pll_f_min_vco]/(16*1000000.0))]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
#				     :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
	    set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr 500.0]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
				     :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
	}
	auto_value_out_of_range_message error set_output_clock_frequency $set_output_clock_frequency $legal_values { primary_pll_buffer }
    }
}


##################################################################################################################################################
# functions: making pll calculations
################################################################################################################################################## 

#omit units (Hz) and return the integer converted value
proc ::altera_xcvr_atx_pll_s10::parameters::omit_units { freq } { 
  regsub -nocase -all {\D} $freq "" temp
  return [expr (wide($temp))]
}

#convert range lists to standard TCL lists
proc ::altera_xcvr_atx_pll_s10::parameters::scrub_list_values { my_list } {
  set new_list {}
  set my_list_len [llength $my_list]
  for {set list_index 0} {$list_index < $my_list_len} { incr list_index } {
    set this_value [lindex $my_list $list_index]
    if [ regexp {:} $this_value ] then {
      regsub -all ":" $this_value " " temp_list
      set start_value [lindex $temp_list 0]
      set end_value [lindex $temp_list 1]
      for {set index $start_value} {$index <= $end_value} { incr index } {
        lappend new_list $index
      }
    } else {
      lappend new_list $this_value
    }
  }
  return $new_list
}
## If in auto-configuration mode, the procedure makes RBC call. 
# result is copied into parameter.auto_list   
proc ::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto { select_manual_config test_mode \
                                                                \
                                                                pma_speedgrade enable_8G_buffer_fnl enable_16G_buffer_fnl enable_fb_comp_bonding_fnl prot_mode_fnl device_revision bw_sel_fnl \
                                                                \
                                                                enable_fractional set_fref_clock_frequency set_output_clock_frequency  feedback_clock_frequency_fnl atx_pll_cgb_div atx_pll_pma_width \
								\
                                   				atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_f_max_ref atx_pll_f_min_ref \
								\
								prot_mode dsm_mode mcgb_div_fnl fb_select_fnl \
								\
								atx_pll_f_max_x1 atx_pll_f_max_tank_0 atx_pll_f_min_tank_0 atx_pll_f_max_tank_1 atx_pll_f_min_tank_1 atx_pll_f_max_tank_2 atx_pll_f_min_tank_2\
                                \ enable_atx_to_fpll_cascade_out primary_use\
                                message_level } {

   #ip_message warning "Enable fractional in auto is $enable_fractional ref clock is $set_fref_clock_frequency";																	
   #start with empty lists
   set legality_return ""
   ip_set "parameter.auto_list.value" ""
  
   #prepare counter lists 

   set n_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl]
   set l_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]

   set allow_cascade_path [::altera_xcvr_atx_pll_s10::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]

   if { $allow_cascade_path } {
      set l_cascade_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
   } else {
      set l_cascade_counter_list 0
   }
   set temp_l_counter [lindex $l_counter_list 0 ]
   set m_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]

   #set frquency and list constants for PLL calculations 
   set_calc_constants [omit_units $atx_pll_f_max_pfd] \
                      [omit_units $atx_pll_f_min_pfd] \
                      [omit_units $atx_pll_f_max_vco] \
                      [omit_units $atx_pll_f_min_vco] \
                      [omit_units $atx_pll_f_max_ref] \
                      [omit_units $atx_pll_f_min_ref] \
                      [omit_units $atx_pll_f_max_x1] \
                      [omit_units $atx_pll_f_min_tank_0] \
                      [omit_units $atx_pll_f_max_tank_0] \
                      [omit_units $atx_pll_f_min_tank_1] \
                      [omit_units $atx_pll_f_max_tank_1] \
                      [omit_units $atx_pll_f_min_tank_2] \
                      [omit_units $atx_pll_f_max_tank_2] \
					  $m_counter_list \
					  $n_counter_list \
					  $l_counter_list \
					  $l_cascade_counter_list

   if {$select_manual_config} {#manual-config
      ip_set "parameter.auto_list.value" ""
   } elseif {$enable_fractional} {
       if { $enable_fb_comp_bonding_fnl } {
          ip_message $message_level "Feedback compensation bonding is not available in fractional PLL mode. To use feedback compensation bonding, please uncheck \"Enable fractional mode\" under the PLL tab." 
       }

       set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
       set temp_ref_freq [expr $set_fref_clock_frequency*1000000]; #convert from MHz to Hz
       ########### Calling fractional computation here ################
       #
       set legality_return [legality_check_fract $temp_out_freq $temp_ref_freq $allow_cascade_path $device_revision]
       #
       ################################################################
       set temp_size [dict size $legality_return]

	   set is_freq_found_intmode [ expr 0]
	   set is_freq_found_fractmode [ expr 0]
       #ip_message info "legality returned here $legality_return"

      if { $temp_size==0 } {
         #ip_message error "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency."
		 set is_freq_found_fractmode 0
      } else {
         set status_reported [dict get $legality_return status]
		 #what if output freq not obtained using fractional mode ?
         if { $status_reported != "good" } { 
             #ip_message error "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz)."
		     set is_freq_found_fractmode 0
			 
			 #check if the frequency is available through integer mode
       ########### Calling integer computation here ################
             set legality_return [legality_check_auto $temp_out_freq $enable_8G_buffer_fnl $allow_cascade_path $device_revision 1 $temp_ref_freq]
       #
       ################################################################
             set temp_size [dict size $legality_return]
             if { $temp_size==0 } {
                 #ip_message error "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency in int mode"
				 set is_freq_found_intmode 0
             } else {
                 set status_reported [dict get $legality_return status]
                 if { $status_reported != "good" } {
                       #ip_message warning "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: A valid setting found for the specified output frequency in int mode"
				       set is_freq_found_intmode 0
                 } else {
                       #ip_message warning "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: A valid setting found for the specified output frequency in int mode"
				       set is_freq_found_intmode 1
			     }
            }
         } else {
		      set is_freq_found_fractmode 1

            set legality_return [dict remove $legality_return status]
            #update auto-list              
            #sort by reference clock frequencies
            set legality_return [dictsort $legality_return]
            ip_set "parameter.auto_list.value" $legality_return
			#puts "legality return is $legality_return"
		 } 
      }

	  if { $is_freq_found_fractmode==1 } {
             ip_message info "A valid setting for the specified output frequency ($set_output_clock_frequency MHz) is available in fractional mode."
	  } elseif { $is_freq_found_intmode==1 } {
             ip_message $message_level "The specified output frequency ($set_output_clock_frequency MHz) is available only in integer mode"
      } else {
             ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz) is available"
	  }
	  return
   } else {#auto-config
      #ip_message info "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto"
      if {!$test_mode} {
         if { !$enable_fb_comp_bonding_fnl  } {
            ## \todo how about all these parameters
            #set legality_check_argument "$pma_speedgrade   $enable_16G_buffer_fnl  $prot_mode_fnl  $device_revision $bw_sel_fnl \
            #                             $enable_fractional $set_output_clock_frequency MHz"
            #set legality_return [::altera_xcvr_atx_pll_s10::pll_calculations::legality_check_auto $set_output_clock_frequency 0]
            set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
            set legality_return [legality_check_auto $temp_out_freq $enable_8G_buffer_fnl $allow_cascade_path $device_revision 0 0]; #$enable_8G_buffer_fnl will determine whether calculations made for GX or GT
         } else {
            set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
            set temp_fb_freq [expr $feedback_clock_frequency_fnl*1000000]; #convert from MHz to Hz
            #TODO Can user set the L cascade counter in feedback compensation mode? Until we make that decision, set 'set_l_cascade_counter' to 1
            set set_l_cascade_counter 4
            set legality_return [legality_check_feedback_auto $temp_out_freq $temp_fb_freq $enable_fb_comp_bonding_fnl $l_counter_list $l_cascade_counter_list $set_l_cascade_counter $allow_cascade_path $device_revision]
         }
      } else {
         if {!$enable_fb_comp_bonding_fnl} {
            set legality_check_argument "$pma_speedgrade   $enable_8G_buffer_fnl $enable_16G_buffer_fnl  $ext_fb  $enable_fb_comp_bonding_fnl  $prot_mode_fnl  $device_revision $bw_sel_fnl \
                                         $enable_fractional $set_output_clock_frequency MHz"
            set legality_return [legality_check_auto_mockup $legality_check_argument]
         } else {
            ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: Test mode does not implement pll computations for feedback compensation bonding."
         }
      }
   
      set temp_size [dict size $legality_return]
      if { $temp_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency."
      } else {
         set status_reported [dict get $legality_return status]
         if { $status_reported != "good" } {
            if {!$enable_fb_comp_bonding_fnl} {
               ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz)."
            } else {
               ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz), pma width($atx_pll_pma_width) and Master CGB division factor($atx_pll_cgb_div)"
            }
         } else {
            #remove first element - status
            set legality_return [dict remove $legality_return status]
            #sort by reference clock frequencies
            set legality_return [dictsort $legality_return]
            ip_set "parameter.auto_list.value" $legality_return
         }
      }
   }
}

#sort a dictionary by keys
proc dictsort {dict args} {
    set list [lsort -real -increasing [dict keys $dict]]
    set res {}
    foreach key $list {
        dict set res $key [dict get $dict $key] 
    }
    set res
    return $res
}

## If in manual-configuration mode, the procedure makes RBC call. 
# result is copied into parameter.manual_list
proc ::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual { select_manual_config test_mode enable_fractional\
                                                                  \
                                                                  pma_speedgrade enable_8G_buffer_fnl enable_16G_buffer_fnl enable_fb_comp_bonding_fnl prot_mode_fnl device_revision bw_sel_fnl \
                                                                  \
                                                                  set_manual_reference_clock_frequency set_m_counter set_ref_clk_div set_l_counter set_k_counter feedback_clock_frequency_fnl\
                                                                  \
                                                                  message_level\
                                                                  \
                                                                  atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_f_max_ref atx_pll_f_min_ref atx_pll_f_max_x1 atx_pll_f_min_tank_0 atx_pll_f_min_tank_1 atx_pll_f_min_tank_2 atx_pll_f_max_tank_0 atx_pll_f_max_tank_1 atx_pll_f_max_tank_2\
                                                                  \
                                                                  fb_select_fnl mcgb_div_fnl dsm_mode atx_pll_pma_width \
																  set_l_cascade_counter set_l_cascade_predivider \
																  enable_atx_to_fpll_cascade_out primary_use\
														  } {
   set n_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl]
   set l_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]

   set allow_cascade_path [::altera_xcvr_atx_pll_s10::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]

   if { $allow_cascade_path } {
      set l_cascade_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
   } else {
      set l_cascade_counter_list 0
   }
   set temp_l_counter [lindex $l_counter_list 0 ]
   set m_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]
   
   set_calc_constants [omit_units $atx_pll_f_max_pfd] \
                      [omit_units $atx_pll_f_min_pfd] \
                      [omit_units $atx_pll_f_max_vco] \
                      [omit_units $atx_pll_f_min_vco] \
                      [omit_units $atx_pll_f_max_ref] \
                      [omit_units $atx_pll_f_min_ref] \
                      [omit_units $atx_pll_f_max_x1] \
                      [omit_units $atx_pll_f_min_tank_0] \
                      [omit_units $atx_pll_f_max_tank_0] \
                      [omit_units $atx_pll_f_min_tank_1] \
                      [omit_units $atx_pll_f_max_tank_1] \
                      [omit_units $atx_pll_f_min_tank_2] \
                      [omit_units $atx_pll_f_max_tank_2] \
					  $m_counter_list \
					  $n_counter_list \
					  $l_counter_list \
					  $l_cascade_counter_list                                                                      
   #start with empty lists
   set legality_return ""
   ip_set "parameter.manual_list.value" ""
   if {!$select_manual_config} {#auto-config
      ip_set "parameter.manual_list.value" ""
   } else {#manual-config
      ip_message info "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual"
      if {!$test_mode} {
         if      { !$enable_fb_comp_bonding_fnl  } {
            ## \todo how about all other related parameters
            set temp_ref_freq [expr $set_manual_reference_clock_frequency*1000000]; #convert from MHz to Hz         
            set legality_return [legality_check_manual $enable_fractional $temp_ref_freq $set_l_counter $set_m_counter $set_ref_clk_div $set_k_counter $set_l_cascade_counter $set_l_cascade_predivider $allow_cascade_path $device_revision]
         } else {
            #set temp_ref_freq [expr $set_manual_reference_clock_frequency*1000000]; #convert from MHz to Hz      
            #set temp_fb_freq [expr $feedback_clock_frequency_fnl*1000000]; #convert from MHz to Hz   
            # n is inferred, m does not matter (only allow '1')
            #set legality_return [legality_check_feedback_manual $temp_ref_freq $temp_fb_freq $set_l_counter $enable_fb_comp_bonding_fnl]
            ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual:: feedback compensation bonding not supported in manual configuration mode"
         }
      } else {
         if {!$enable_fb_comp_bonding_fnl} {
            set legality_check_argument "$pma_speedgrade                           $enable_8G_buffer_fnl  $enable_16G_buffer_fnl  $ext_fb         $enable_fb_comp_bonding_fnl        $prot_mode_fnl  $device_revision $bw_sel_fnl \
                                         $set_manual_reference_clock_frequency MHz  $set_m_counter         $set_ref_clk_div        $set_l_counter  $set_k_counter $set_l_cascade_counter"
            set legality_return [legality_check_manual_mockup $legality_check_argument]
         } else {
            ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual:: test mode does not implement pll computations for feedback compensation bonding"
         }
      }
   
      set temp_size [dict size $legality_return]
      if { $temp_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual:: argument size 0"
      } else {
         set status_reported [dict get $legality_return status]
         if { $status_reported != "good" } {
            ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::calculate_pll_manual:: invalid calculation result  $status_reported"
         } else {
            #remove first element - status
            set legality_return [dict remove $legality_return status]
            #update manual-list
            ip_set "parameter.manual_list.value" $legality_return
         }
      }
   }
}

## Whether in manual-configuration or auto-configuration mode, the procedure creates one common pll_setting to be copied into hdl parameters. 
# depending on the configuration mode the logic populating pll_setting changes
proc ::altera_xcvr_atx_pll_s10::parameters::update_pll_setting { select_manual_config auto_list manual_list set_auto_reference_clock_frequency \
                                                                \
                                                                set_manual_reference_clock_frequency set_m_counter set_ref_clk_div set_l_counter set_k_counter \
                                                                \
                                                                enable_fractional set_fref_clock_frequency set_output_clock_frequency \
                                                                \
                                                                message_level \
																set_l_cascade_counter \
																set_l_cascade_predivider \
														        } {
   # starting with an empty list	
   ip_set "parameter.pll_setting.value" ""
   
   # eventually temp will be copied into parameter.pll_setting
   set temp ""
  
   if {$select_manual_config} {#manual-config
      set manual_list_size [dict size $manual_list]
      if { $manual_list_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_pll_setting::  argument size 0"
      } else {
         # populate temp from user input
         # if we are in this point user input is already validated
#         dict set temp refclk "$set_manual_reference_clock_frequency MHz"
         dict set temp refclk "$set_manual_reference_clock_frequency"
         dict set temp m_cnt  $set_m_counter
         dict set temp n_cnt  $set_ref_clk_div
         dict set temp l_cnt  $set_l_counter
         dict set temp k_cnt  $set_k_counter
         dict set temp l_cascade $set_l_cascade_counter
         dict set temp l_cascade_predivider $set_l_cascade_predivider
         
         # populate temp with output frequency information from calculation result 
         # with Mhz appended
         set valid_config [dict get $manual_list config]                     
         dict set temp outclk [dict get $valid_config out_freq]
         
         # populate other related calculation results
#         dict set temp tank_sel [dict get $valid_config tank_sel]
#         dict set temp tank_band [dict get $valid_config tank_band]
		 #dict set temp fractional_value_ready "pll_k_not_ready"
		 #dict set temp dsm_out_sel "pll_dsm_disable"
            
      }
   } elseif {$enable_fractional} {

      set auto_list_size [dict size $auto_list]
      if { $auto_list_size==0 } {
         # no need to print this has already been detected
         #ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_pll_setting::  argument size 0"
      } else {
         set ref_clk_freq_formatted [format "%.6f" $set_fref_clock_frequency]
         if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
            ip_message $message_level "Selected reference clock frequency ($set_auto_reference_clock_frequency MHz) is not valid."
         } else {
	        
	        # get the line in dictionary with slected frequency  
            set selected_item [dict get $auto_list $ref_clk_freq_formatted]
            
            # populate temp with info from calculation result 
##            dict set temp refclk     "$ref_clk_freq_formatted MHz"
            dict set temp refclk     "$ref_clk_freq_formatted"
            dict set temp m_cnt      [dict get $selected_item m]
            dict set temp n_cnt      [dict get $selected_item n]
            dict set temp l_cnt      [dict get $selected_item l]
            dict set temp k_cnt      [dict get $selected_item k]
            dict set temp l_cascade  [dict get $selected_item l_cascade]
            dict set temp l_cascade_predivider  [dict get $selected_item l_cascade_predivider]

#            dict set temp tank_sel [dict get $selected_item tank_sel]
#            dict set temp tank_band [dict get $selected_item tank_band]
			#dict set temp fractional_value_ready "pll_k_ready"
			#dict set temp dsm_out_sel "pll_dsm_3rd_order"
            
            # populate temp with output frequency using user input 
            # if we are in this point user input is already validated
            # with Mhz appended
            set user_out_freq $set_output_clock_frequency
            dict set temp outclk "$user_out_freq MHz"
         }
      }

  } else {#auto-config
      set auto_list_size [dict size $auto_list]
      if { $auto_list_size==0 } {
         # no need to print this has already been detected
         #ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_pll_setting::  argument size 0"
      } else {
         set ref_clk_freq_formatted [format "%.6f" $set_auto_reference_clock_frequency]
         if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
            ip_message $message_level "Selected reference clock frequency ($set_auto_reference_clock_frequency MHz) is not valid."
         } else {
	        
	        # get the line in dictionary with slected frequency  
            set selected_item [dict get $auto_list $ref_clk_freq_formatted]
            
            # populate temp with info from calculation result 
#            dict set temp refclk "$ref_clk_freq_formatted MHz"
            dict set temp refclk "$ref_clk_freq_formatted"
            dict set temp m_cnt  [dict get $selected_item m]
            dict set temp n_cnt  [dict get $selected_item n]
            dict set temp l_cnt  [dict get $selected_item l]
            dict set temp k_cnt  [dict get $selected_item k]
            dict set temp l_cascade  [dict get $selected_item l_cascade]
            dict set temp l_cascade_predivider  [dict get $selected_item l_cascade_predivider]
#            dict set temp tank_sel [dict get $selected_item tank_sel]
#            dict set temp tank_band [dict get $selected_item tank_band]
			#dict set temp fractional_value_ready "pll_k_not_ready"
			#dict set temp dsm_out_sel "pll_dsm_disable"
            
            # populate temp with output frequency using user input 
            # if we are in this point user input is already validated
            # with Mhz appended
            set user_out_freq $set_output_clock_frequency
            dict set temp outclk "$user_out_freq MHz"
         }
      }
   }
   
   ip_set "parameter.pll_setting.value" $temp
}

## copy effective m from pll computation 
proc ::altera_xcvr_atx_pll_s10::parameters::update_effective_m_counter { PROP_NAME enable_fb_comp_bonding_fnl select_manual_config auto_list set_auto_reference_clock_frequency} {
   # set the value to default at the beginning, to prevent any unexpected outside the range errors 
   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
   ip_set "parameter.${PROP_NAME}.value" $value

   if {$enable_fb_comp_bonding_fnl} {#this is the only case we want this function to be executed, in other cases effective m does not matter
      if {$select_manual_config} {#manual-config
         #catched elsewhere
         #ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_effective_m_counter:: (external feedback)/(feedback compensation bonding) not supported in manual configuration mode""
      } else {#auto-config
         set auto_list_size [dict size $auto_list]
         if { $auto_list_size==0 } {
            # no need to print this has already been detected
            #ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_effective_m_counter::  argument size 0"
         } else {
            set ref_clk_freq_formatted [format "%.6f" $set_auto_reference_clock_frequency]
            if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
               # no need to print this has already been detected
               # ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_effective_m_counter:: no entry can be found in dictionary"
            } else {
               # get the line in dictionary with selected frequency  
               set selected_item [dict get $auto_list $ref_clk_freq_formatted]
               ip_set "parameter.${PROP_NAME}.value" [dict get $selected_item effective_m]
            }
         }
      }
   }
}

#proc ::altera_xcvr_atx_pll_s10::parameters::validate_hclk_divide { m_counter } {
#   set hclk_divide_factor [get_hclk_divide $m_counter]
#   # \todo fix this mapping
#   set hclk_divide_factor 1
#   ip_set "parameter.hclk_divide.value" $hclk_divide_factor
#}
##################################################################################################################################################
# functions: copying calculated pll settings to corresponding hdl parameters 
################################################################################################################################################## 

proc ::altera_xcvr_atx_pll_s10::parameters::update_reflk_freq { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {      
      if { ![dict exists $pll_setting refclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_reflk_freq cannot find the entry"
      } else {
         ip_set "parameter.reference_clock_frequency_fnl.value" [dict get $pll_setting refclk]
      }
   }
}
                

proc ::altera_xcvr_atx_pll_s10::parameters::update_output_clock_frequency { pll_setting primary_pll_buffer atx_pll_f_min_vco atx_pll_f_max_vco atx_pll_f_max_x1 primary_use select_manual_config } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting outclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_output_clock_frequency cannot find the entry"
      } else {
	  set output_clock_frequency_val [dict get $pll_setting outclk]
	  regsub -nocase -all {\D} $output_clock_frequency_val "" output_clock_frequency_val 
	  set temp_out_freq [expr $output_clock_frequency_val/1000000]; #convert from Hz to MHz
	  ip_set "parameter.output_clock_frequency.value" [dict get $pll_setting outclk]
          ## Check in manual mode the pll output clock frequency is within a range, differenr rules for cascade and non-cascade mode
	  set f_max_in_lc_to_fpll_l_counter "700000000"
	  #$atx_pll_f_max_x1
	  #32 is the max L cascade counter
	  if {$select_manual_config} {
	      if {$primary_use == "hssi_cascade"} {
		  set legal_values [list [format "%0.6f" [expr ([omit_units $atx_pll_f_min_vco]/(31*1000000.0))]]:[expr ([omit_units $f_max_in_lc_to_fpll_l_counter]/1000000.0)]]
	      } else {
### Now Channel minimum restriction of 1G - Channel runs at 1000 Mhz (1G) min so need to add restriction on the ATX PLL output clock frequency to be >=500 Mhz
#		  set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr ([omit_units $atx_pll_f_min_vco]/(16*1000000.0))]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
#					   :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
		  set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr 500.0]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
					   :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]

	      }
	      manual_value_out_of_range_message error output_clock_frequency $temp_out_freq $legal_values
	  }

      }
   }
}


proc ::altera_xcvr_atx_pll_s10::parameters::update_vco_freq { l_counter l_cascade_counter l_cascade_predivider set_output_clock_frequency output_clock_frequency enable_8G_buffer_fnl enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
           regsub -nocase -all {\m(\D)} $output_clock_frequency "" output_clock_frequency
           set temp [expr ($output_clock_frequency * $l_cascade_counter * $l_cascade_predivider) ]
           ip_set "parameter.vco_freq.value" "$temp MHz"
	} else {
       if { $enable_8G_buffer_fnl=="false" } {
           set temp $set_output_clock_frequency
           ip_set "parameter.vco_freq.value" "$temp MHz"
   	} else {
           set temp [expr ($set_output_clock_frequency * $l_counter) ]
           ip_set "parameter.vco_freq.value" "$temp MHz"
   	}
	}
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_datarate { set_output_clock_frequency} {
    set temp [ expr ($set_output_clock_frequency*2) ] 
	ip_set "parameter.datarate.value" "$temp Mbps"
}


proc ::altera_xcvr_atx_pll_s10::parameters::update_output_clock_datarate { pll_setting set_output_clock_frequency message_level} {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting outclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_output_clock_datarate cannot find the entry"
      } else {
         ip_set "parameter.output_clock_datarate.value" [ expr ($set_output_clock_frequency*2) ]
      }
   }
}


proc ::altera_xcvr_atx_pll_s10::parameters::update_m_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting m_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_m_counter cannot find the entry"
      } else {
         ip_set "parameter.m_counter.value" [dict get $pll_setting m_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_n_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting n_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_n_counter cannot find the entry"
      } else {
         ip_set "parameter.ref_clk_div.value" [dict get $pll_setting n_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_l_cascade_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cascade ] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_l_cascade_counter cannot find the entry"
      } else {
         ip_set "parameter.l_cascade_counter.value" [dict get $pll_setting l_cascade]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_l_cascade_predivider { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cascade_predivider ] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_l_cascade_predivider cannot find the entry"
      } else {
         ip_set "parameter.l_cascade_predivider.value" [dict get $pll_setting l_cascade_predivider]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_l_counter { pll_setting message_level primary_use } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_l_counter cannot find the entry"
      } else {
# We are forcing the value of the l_counter to be 1 to match RBC default when in cascade mode.  l_counter is not being used in this configuration 
# so it is only important to match the RBC default.  Doing this because when we start in non-cascade mode and switch over to cascade the L counter
# is hidden ... but the value that was set prior to hiding is retained when configuring in manual mode.  If this value is not set to '1' prior to
# being hidden then the value set is used and can cause an issue if it does not match the default specified in the RBC rules.
# This is a hack.  I would prefer to make a call to '::altera_xcvr_atx_pll_s10::parameters::obtain_l_counter_values' but for some reason this 
# does not have the dependency on primary_use .. it should ... so we need to determine why this is not happening.
         if {$primary_use == "hssi_cascade"} {
            ip_set "parameter.l_counter.value" 1
         } else {
            ip_set "parameter.l_counter.value" [dict get $pll_setting l_cnt]
         }
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_k_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting k_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_k_counter cannot find the entry"
      } else {
		 set value_k [dict get $pll_setting k_cnt]
         ip_set "parameter.k_counter.value" [dict get $pll_setting k_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_tank_sel { pll_setting message_level} {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting tank_sel] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_tank_sel cannot find the entry"
      } else {
         ip_set "parameter.tank_sel.value" [dict get $pll_setting tank_sel]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_fractional_value_ready { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting fractional_value_ready] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_fractional_value cannot find the entry"
      } else {
         ip_set "parameter.fractional_value_ready.value" [dict get $pll_setting fractional_value_ready]
      }
   }
}


proc ::altera_xcvr_atx_pll_s10::parameters::update_dsm_out_sel { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting dsm_out_sel] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_dsm_out_sel cannot find the entry"
      } else {
         ip_set "parameter.dsm_out_sel.value" [dict get $pll_setting dsm_out_sel]
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_tank_band { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting tank_band] } {
         ip_message $message_level "::altera_xcvr_atx_pll_s10::parameters::update_tank_band cannot find the entry"
      } else {
         ip_set "parameter.tank_band.value" [dict get $pll_setting tank_band]
      }
   }
}

##################################################################################################################################################
# functions: mocking rbc calls - these functions are temporary 
##################################################################################################################################################
proc ::altera_xcvr_atx_pll_s10::parameters::legality_check_auto_mockup { temp } {
   
   # example dictionary structure:	
   #      set ret { { status    good} \
   #                { "1" { {m 2} {n 3} {l 4} {k 6} {lf_resistance lf_setting0} }... }\
   #                { "2" { {m 1} {n 3} {l 4} {k 6} {lf_resistance lf_setting0} }... }\
   #              }
   
   set test_mode_lcl 1
   if { $test_mode_lcl==1 } {
      dict set ret status good
      
      set temp_set_output_clock_frequency    [ip_get "parameter.set_output_clock_frequency.value"]
      
      set refclk1 [expr  $temp_set_output_clock_frequency/10]
      set refclk1 [format "%.6f" $refclk1]
      set m_1 [expr int($refclk1/10)]
      set refclk1_str "$refclk1"
      dict set ret $refclk1_str m $m_1
      dict set ret $refclk1_str n [expr 2*$m_1]
      dict set ret $refclk1_str l [expr 3*$m_1]
      dict set ret $refclk1_str k [expr 4*$m_1]
      dict set ret $refclk1_str tank_sel "lctank0"
      dict set ret $refclk1_str tank_band "lc_band0"
      
      set refclk2 [expr  $temp_set_output_clock_frequency/5]
      set refclk2 [format "%.6f" $refclk2]
      set m_2 [expr int($refclk2/10)]
      set refclk2_str "$refclk2"
      dict set ret $refclk2_str m $m_2
      dict set ret $refclk2_str n [expr 2*$m_2]
      dict set ret $refclk2_str l [expr 3*$m_2]
      dict set ret $refclk2_str k [expr 4*$m_2]
      dict set ret $refclk2_str tank_sel "lctank1"
      dict set ret $refclk2_str tank_band "lc_band1"
   } else {
      dict set ret status bad
   }
   return $ret     
}
    
proc ::altera_xcvr_atx_pll_s10::parameters::legality_check_manual_mockup { temp } {
	
   # example dictionary structure:
   #      set ret { { status    good} \
   #                { config   { {out_freq 2520.0 MHz} {lf_resistance lf_setting0}... } } \
   #              }
	
   #   dict set ret status error

   set test_mode_lcl 1
   if { $test_mode_lcl==1 } {
              
      dict set ret status good
      
      set temp_reference_clock_frequency [ip_get "parameter.set_manual_reference_clock_frequency.value"]  
      set temp_set_m_counter             [ip_get "parameter.set_m_counter.value"]            
      set temp_set_ref_clk_div           [ip_get "parameter.set_ref_clk_div.value"]          
      set temp_set_l_counter             [ip_get "parameter.set_l_counter.value"]            
      set temp_set_k_counter             [ip_get "parameter.set_k_counter.value"]
      set temp_set_l_cascade_counter     [ip_get "parameter.set_l_cascade_counter.value"]
      
      set k_factor "1.$temp_set_k_counter" 
      
	  if { $temp_set_cascade_counter != 0 } {
	     set out_freq [expr (($k_factor)*($temp_reference_clock_frequency)*($temp_set_m_counter))/(($temp_set_ref_clk_div)*($temp_set_l_cascade_counter))]
	  } else {
      set out_freq [expr (($k_factor)*($temp_reference_clock_frequency)*($temp_set_m_counter))/(($temp_set_ref_clk_div)*($temp_set_l_counter))]
	  }
      
      dict set ret config out_freq "$out_freq MHz"
      dict set ret config tank_sel "lctank0"
      dict set ret config tank_band "lc_band0"
   } else {
      dict set ret status bad
   }
   return $ret     
} 

#convert units in mega (10^6) to base (10^0)
proc ::altera_xcvr_atx_pll_s10::parameters::mega_to_base { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  return $temp
}

proc ::altera_xcvr_atx_pll_s10::parameters::convert_mhz_to_hz { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
#  ip_set "parameter.${PROP_NAME}.value" "$temp Hz"
  ip_set "parameter.${PROP_NAME}.value" "$temp"
}

proc ::altera_xcvr_atx_pll_s10::parameters::convert_mbps_to_bps { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
#  ip_set "parameter.${PROP_NAME}.value" "$temp bps"
  ip_set "parameter.${PROP_NAME}.value" "$temp"
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate_enable_calibration { set_altera_xcvr_atx_pll_s10_calibration_en enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_altera_xcvr_atx_pll_s10_calibration_en:1}]
  if { $value } {
    ip_set "parameter.calibration_en.value" "enable"
  } else {
    ip_set "parameter.calibration_en.value" "disable"
  }
}

proc ::altera_xcvr_atx_pll_s10::parameters::update_manual_config { select_manual_config enable_fractional device_revision fb_select_fnl prot_mode_fnl mcgb_div_fnl dsm_mode fb_select_fnl atx_pll_pma_width prot_mode_fnl primary_use} {
  # TODO Do these RBC calls return automatic counter ranges appropriate for fractional and integer modes ?
  if { $select_manual_config } {
   set n_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl]
   set l_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]
   set l_cascade_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
   set temp_l_counter [lindex $l_counter_list 0 ]
   set m_counter_list [::altera_xcvr_atx_pll_s10::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]
    ip_set "parameter.set_m_counter.ALLOWED_RANGES" $m_counter_list
    ip_set "parameter.set_ref_clk_div.ALLOWED_RANGES" $n_counter_list
    ip_set "parameter.set_l_counter.ALLOWED_RANGES" $l_counter_list
    ip_set "parameter.set_l_cascade_counter.ALLOWED_RANGES" $l_cascade_counter_list
    ip_set "parameter.enable_fractional.value" "1"

  }
}

proc ::altera_xcvr_atx_pll_s10::parameters::determine_if_cascade_path_legal { device_revision enable_atx_to_fpll_cascade_out } {
   set device_supports_cascade [::altera_xcvr_atx_pll_s10::parameters::does_this_device_support_cascade $device_revision ]
   if { $device_supports_cascade && $enable_atx_to_fpll_cascade_out } {
      return "true"
   } else {
      return "false"
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::does_this_device_support_cascade { device_revision } {
    if { [regexp {es} $device_revision]} {
      return "false"
   } else {
      return "true"
   }
}



 proc ::altera_xcvr_atx_pll_s10::parameters::update_enable_atx_to_fpll_cascade_out { PROP_NAME PROP_VALUE device_revision enable_atx_to_fpll_cascade_out device prot_mode} {
    set device_supports_cascade [::altera_xcvr_atx_pll_s10::parameters::does_this_device_support_cascade $device_revision ]
     if { !$device_supports_cascade} {
	 auto_invalid_value_message error $PROP_NAME $PROP_VALUE 0 { device }
     }
     if { [string compare -nocase $prot_mode "OTN_cascade"] ==0  || [string compare -nocase $prot_mode "SDI_cascade"] ==0 } {
     } else {
        auto_invalid_value_message error $PROP_NAME $PROP_VALUE 0 { prot_mode }
     }

 }


proc ::altera_xcvr_atx_pll_s10::parameters::determine_primary_use { device_revision enable_atx_to_fpll_cascade_out primary_pll_buffer } {
   set allow_cascade_path [::altera_xcvr_atx_pll_s10::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]
   if { $allow_cascade_path } {
      ip_set "parameter.primary_use.value" "hssi_cascade"
   } else {
      if { [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
         ip_set "parameter.primary_use.value" "hssi_x1"
      } else {
         ip_set "parameter.primary_use.value" "hssi_hf"
      }
   }
}

proc ::altera_xcvr_atx_pll_s10::parameters::obtain_n_counter_values { device_revision fb_select_fnl prot_mode_fnl } {
   return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::getValue_atx_pll_n_counter $device_revision $fb_select_fnl $prot_mode_fnl]]]
}

proc ::altera_xcvr_atx_pll_s10::parameters::obtain_m_counter_values { device_revision mcgb_div_fnl dsm_mode fb_select_fnl temp_l_counter atx_pll_pma_width prot_mode_fnl primary_use} {
#   return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::validate_atx_pll_mcnt_divide 1 1 $device_revision $mcgb_div_fnl $fb_select_fnl $dsm_mode $temp_l_counter $atx_pll_pma_width $primary_use $prot_mode_fnl]]]
   return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::getValue_atx_pll_mcnt_divide $device_revision $mcgb_div_fnl $fb_select_fnl $dsm_mode $temp_l_counter $atx_pll_pma_width $primary_use $prot_mode_fnl]]]


}

proc ::altera_xcvr_atx_pll_s10::parameters::obtain_l_counter_values { device_revision prot_mode_fnl } {
#   return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::validate_atx_pll_l_counter 1 1 $device_revision $prot_mode_fnl]]]
   return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::getValue_atx_pll_l_counter $device_revision $prot_mode_fnl]]]
}

proc ::altera_xcvr_atx_pll_s10::parameters::obtain_l_cascade_counter_values { device_revision prot_mode_fnl } {
#      return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::validate_atx_pll_lc_to_fpll_l_counter_scratch 1 1 $device_revision "hssi_cascade" $prot_mode_fnl "user_mode"]]]

      return [lsort -integer -increasing [scrub_list_values [::ct1_atx_pll::parameters::getValue_atx_pll_lc_to_fpll_l_counter_scratch $device_revision "hssi_cascade" $prot_mode_fnl "user_mode"]]]
}

### Max K value supported is < 2^32 so validate that for manual mode
 proc ::altera_xcvr_atx_pll_s10::parameters::validate_k_counter { enable_fractional select_manual_config set_k_counter } {
     ## for 2^32 expression following can be used [expr 2**32-1] But it desn't work with some of the TCL interpreters so hardcoding 2^32 value
     set max_k_counter "4294967295"
     if { $enable_fractional} {
	 if {$select_manual_config} {
	     if {$set_k_counter > $max_k_counter} {
		 ip_message error "k counter is $set_k_counter, legal range is 0:$max_k_counter"
	     }
	 }
     }
 }

##################################################################################################################################################
# Following Functions are added to support GUI parameter l_cascade_predivider.
# l_cascade_predivider is the GUI parameter added for MUX selection between "select_vco_output" and "select_div_by_2", mux selection is based
# on the attribute "atx_pll_fpll_erfclk_selection"
# 
################################################################################################################################################## 

proc ::altera_xcvr_atx_pll_s10::parameters::validate_atx_pll_fpll_refclk_selection { set_l_cascade_predivider } {
   if {$set_l_cascade_predivider == 1} {
      set val "select_vco_output"
   } else {
      set val "select_div_by_2"
   }
   ip_set "parameter.atx_pll_fpll_refclk_selection.value" $val
}

###
proc ::altera_xcvr_atx_pll_s10::parameters::manual_value_out_of_range_message { message_level param_name param_value param_legal_values } {
    # See if the value is within the specified range
    foreach range $param_legal_values {
 	set min_max [split $range ":"]
 	set min [lindex $min_max 0]
 	set max $min
 	if {[llength $min_max] == 2} {
 	    set max [lindex $min_max 1]
 	}
 	if {$param_value <= $max && $param_value >= $min} {
 	    # The value is legal. Return
 	    return
 	} else {
 	    ip_message $message_level "$param_name is $param_value, legal range is $param_legal_values"
	    
 	}
	
     }
}

proc ::altera_xcvr_atx_pll_s10::parameters::validate_enable_sdi_rule_checks { prot_mode enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
	if { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
	    ip_set "parameter.atx_pll_is_sdi.value" "true"	    
	} else {
	    ip_set "parameter.atx_pll_is_sdi.value" "false"
	}
    } else {
	ip_set "parameter.atx_pll_is_sdi.value" "false"
    }
}   

proc ::altera_xcvr_atx_pll_s10::parameters::validate_enable_otn_rule_checks { prot_mode enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
	if { [string compare -nocase $prot_mode "OTN_cascade"] == 0 } {
	    ip_set "parameter.atx_pll_is_otn.value" "true"  
	} else {
	    ip_set "parameter.atx_pll_is_otn.value" "false"
	}
    } else {   
	ip_set "parameter.atx_pll_is_otn.value" "false"
    }
}   

proc ::altera_xcvr_atx_pll_s10::parameters::validate_enable_hclk { enable_pcie_clk } {
    if { $enable_pcie_clk } {
        ip_set "parameter.atx_pll_enable_hclk.value" "true"  
    } else {
        ip_set "parameter.atx_pll_enable_hclk.value" "false"
    }
} 

## Procedure converts bw_sel GUI value to atom map values
proc ::altera_xcvr_atx_pll_s10::parameters::convert_bw_sel { bw_sel } {
   if {$bw_sel == "low"} {
        ip_set "parameter.bw_sel_fnl.value" "low_bw"	
   } elseif {$bw_sel == "medium"} {
        ip_set "parameter.bw_sel_fnl.value" "mid_bw"	
   } else { 
        ip_set "parameter.bw_sel_fnl.value" "high_bw"
   }   
} 

proc ::altera_xcvr_atx_pll_s10::parameters::update_in_pcie_hip_mode { enable_pcie_hip_connectivity  } {
   if {$enable_pcie_hip_connectivity==1 } {
     ip_set "parameter.in_pcie_hip_mode.value" 1
   } else   {
     ip_set "parameter.in_pcie_hip_mode.value" 0
   }
}

