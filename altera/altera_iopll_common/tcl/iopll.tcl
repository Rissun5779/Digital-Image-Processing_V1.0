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


## \file iopll.tcl
# Common TCL package to generate IOPLL parameters

# Need the following line so that IPs only need to know the location to this
# tcl file, and this tcl file is responible for locating all the local packages
# it depends on.
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll_common

# Package depends on additional packages in the transceiver area, but there should be
# nothing transceiver-specific about the routines being used.
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_core/nf

package provide altera_iopll_common::iopll 18.1

## \todo review below
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
#package require nf_hssi_pma_cgb_master::parameters

source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/tclpackages.tcl
package require altera_iopll::util


proc my_local_get_quartus_bindir {} {

    set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

    set PLATFORM $::tcl_platform(platform)
    if { $PLATFORM == "java" } {
        set PLATFORM $::tcl_platform(host_platform)
    }

    if { [catch {set QUARTUS_BINDIR $::quartus(binpath)} errmsg] } {
        if { $PLATFORM == "windows" } {
            set BINDIRNAME "bin"
        } else {
            set BINDIRNAME "linux"
        }

        # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
        # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
        if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
            if {[string match "*64" $::tcl_platform(machine)]} {
                set POINTERSIZE 8
            } else {
                set POINTERSIZE 4
            }
        }
        if { $POINTERSIZE == 8 } {
            set BINDIRNAME "${BINDIRNAME}64"
        }

        set QUARTUS_BINDIR "$QUARTUS_ROOTDIR/$BINDIRNAME"
    }

	return $QUARTUS_BINDIR

}


# the computation engine
package require ::altera::pll_legality

# tcl commands
package require Itcl

# ipcc functions 
#puts $env(QUARTUS_ROOTDIR)
source $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/altera_avalon_mega_common/ipcc_wrap_split.tcl

set QUARTUS_BINDIR [my_local_get_quartus_bindir]
source [file join $QUARTUS_BINDIR .. common tcl packages pll pll_legality.tcl]
package require ::quartus::pll::legality

namespace eval ::altera_iopll_common::iopll:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace import ::altera_iopll::util::*
   
   namespace export \
      init \
      set_pll_display_item_properties \
      declare_pll_display_items \
      declare_pll_parameters \
      declare_pll_physical_parameters \
      declare_pll_interfaces \
      validate \
      set_sys_info_device_family \
      set_sys_info_device \
      set_sys_info_device_speedgrade \
      set_reference_clock_frequency \
      set_vco_frequency \
      set_pll_output_clocks_info \
      set_physical_parameter_values \
      enable_pll_locked_port \
      disable_pll_locked_port \

   variable pll_display_items
   variable pll_common_parameters
   variable pll_physical_parameters
   variable mapped_parameters
   variable pll_outclk_reference_list
   variable pll_maximum_number_of_reserved_clocks
   
   variable gui_enable_advanced_mode
   variable gui_compensation_mode
   variable gui_number_of_pll_output_clocks
   variable gui_desired_outclk_frequency
   variable gui_actual_outclk_frequency
   variable hp_actual_outclk_frequency
   variable gui_outclk_phase_shift_unit
   variable gui_outclk_desired_phase_shift
   variable gui_outclk_actual_phase_shift_ps
   variable gui_outclk_actual_phase_shift_deg
   variable hp_outclk_actual_phase_shift
   variable gui_desired_outclk_duty_cycle
   variable gui_actual_outclk_duty_cycle
   variable hp_actual_outclk_duty_cycle
   
   variable mapped_sys_info_device_family    
   variable mapped_sys_info_device           
   variable mapped_sys_info_device_speedgrade
   variable mapped_reference_clock_frequency 
   variable mapped_vco_frequency             
   variable mapped_external_pll_mode         
   
   variable output_clocks_grp
   variable extra_clk0_grp
   variable extra_clk1_grp
   variable extra_clk2_grp
   variable extra_clk3_grp
   
   variable show_reserved_clks
   variable use_port_name_as_role_name
   variable hide_gui_if_disabled
   
   variable pll_input_clock_frequency
   variable pll_vco_clock_frequency
   variable m_cnt_hi_div
   variable m_cnt_lo_div
   variable n_cnt_hi_div
   variable n_cnt_lo_div
   variable m_cnt_bypass_en
   variable n_cnt_bypass_en
   variable m_cnt_odd_div_duty_en
   variable n_cnt_odd_div_duty_en
   variable pll_cp_setting
   variable pll_bw_ctrl
   variable c_cnt_hi_div
   variable c_cnt_lo_div
   variable c_cnt_prst
   variable c_cnt_ph_mux_prst
   variable c_cnt_bypass_en
   variable c_cnt_odd_div_duty_en
   variable pll_output_clock_frequency_
   variable pll_output_phase_shift_
   variable pll_output_duty_cycle_
   variable pll_clk_out_en_
   variable pll_fbclk_mux_1
   variable pll_fbclk_mux_2
   variable pll_m_cnt_in_src
   variable pll_bw_sel   
   
   variable pll_extra_clock
   variable pll_locked
}

##################################################################################################################################################
# INTERNAL UTILITY FUNCTIONS
##################################################################################################################################################

proc ::altera_iopll_common::iopll::set_property_byParameterIndex { data propertyName propertyValue parameterIndex } {

   set headers [lindex $data 0]
   set propertyIndex [lsearch $headers $propertyName]
   if { $propertyIndex == -1 } {
      ip_message error "::altera_iopll_common::iopll::set_property_byParameterIndex:: property($propertyName) does not exist"
   }

   set length [llength $data]

   if { $length <= $parameterIndex || $parameterIndex < 1 } {
      ip_message error "::altera_iopll_common::iopll::set_property_byParameterIndex:: invalid parameter index($parameterIndex)"
   }

   set parameterProperties [lindex $data $parameterIndex]
   set parameterProperties [lreplace $parameterProperties $propertyIndex $propertyIndex $propertyValue]
   set data [lreplace $data $parameterIndex $parameterIndex $parameterProperties]

   return $data
}

proc ::altera_iopll_common::iopll::set_property_byParameterName  { data propertyName propertyValue parameterName } {
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
      ip_message error "::altera_iopll_common::iopll::set_property_byParameterName:: parameter($parameterName) does not exist"
   }

   return [set_property_byParameterIndex $data $propertyName $propertyValue $parameterIndex]
}


##################################################################################################################################################
# EXPORTED FUNCTIONS
##################################################################################################################################################

proc ::altera_iopll_common::iopll::init { {overrides ""} } {

   variable pll_display_items
   variable pll_common_parameters
   variable pll_physical_parameters
   variable mapped_parameters
   variable pll_outclk_reference_list
   variable pll_maximum_number_of_reserved_clocks
   
   variable gui_enable_advanced_mode
   variable gui_compensation_mode
   variable gui_number_of_pll_output_clocks
   variable gui_desired_outclk_frequency
   variable gui_actual_outclk_frequency
   variable hp_actual_outclk_frequency
   variable gui_outclk_phase_shift_unit
   variable gui_outclk_desired_phase_shift
   variable gui_outclk_actual_phase_shift_ps
   variable gui_outclk_actual_phase_shift_deg
   variable hp_outclk_actual_phase_shift
   variable gui_desired_outclk_duty_cycle
   variable gui_actual_outclk_duty_cycle
   variable hp_actual_outclk_duty_cycle
   variable output_clocks_grp
   variable extra_clk0_grp
   variable extra_clk1_grp
   variable extra_clk2_grp
   variable extra_clk3_grp
   
   variable show_reserved_clks
   variable use_port_name_as_role_name
   variable hide_gui_if_disabled
   
   variable mapped_sys_info_device_family    
   variable mapped_sys_info_device           
   variable mapped_sys_info_device_speedgrade
   variable mapped_reference_clock_frequency 
   variable mapped_vco_frequency             
   variable mapped_external_pll_mode         
   
   variable pll_input_clock_frequency
   variable pll_vco_clock_frequency
   variable m_cnt_hi_div
   variable m_cnt_lo_div
   variable n_cnt_hi_div
   variable n_cnt_lo_div
   variable m_cnt_bypass_en
   variable n_cnt_bypass_en
   variable m_cnt_odd_div_duty_en
   variable n_cnt_odd_div_duty_en
   variable pll_cp_setting
   variable pll_bw_ctrl
   variable c_cnt_hi_div
   variable c_cnt_lo_div
   variable c_cnt_prst
   variable c_cnt_ph_mux_prst
   variable c_cnt_bypass_en
   variable c_cnt_odd_div_duty_en
   variable pll_output_clock_frequency_
   variable pll_output_phase_shift_
   variable pll_output_duty_cycle_
   variable pll_clk_out_en_
   variable pll_fbclk_mux_1
   variable pll_fbclk_mux_2
   variable pll_m_cnt_in_src
   variable pll_bw_sel   
   
   variable pll_extra_clock
   variable pll_locked
   
   # Default settings
   set gui_enable_advanced_mode            "gui_enable_advanced_mode"
   set gui_compensation_mode               "gui_compensation_mode"
   set gui_number_of_pll_output_clocks     "gui_number_of_pll_output_clocks"
   set gui_desired_outclk_frequency        "gui_desired_outclk_frequency"
   set gui_actual_outclk_frequency         "gui_actual_outclk_frequency"
   set hp_actual_outclk_frequency          "hp_actual_outclk_frequency"
   set gui_outclk_phase_shift_unit         "gui_outclk_phase_shift_unit"
   set gui_outclk_desired_phase_shift      "gui_outclk_desired_phase_shift"
   set gui_outclk_actual_phase_shift_ps    "gui_outclk_actual_phase_shift_ps"
   set gui_outclk_actual_phase_shift_deg   "gui_outclk_actual_phase_shift_deg"
   set hp_outclk_actual_phase_shift        "hp_outclk_actual_phase_shift"
   set gui_desired_outclk_duty_cycle       "gui_desired_outclk_duty_cycle"
   set gui_actual_outclk_duty_cycle        "gui_actual_outclk_duty_cycle"
   set hp_actual_outclk_duty_cycle         "hp_actual_outclk_duty_cycle"
   set text_extra_desc                     ""
   set output_clocks_grp                   "Output Clocks"
   set extra_clk0_grp                      "outclk5 (pll_extra_clock0)"
   set extra_clk1_grp                      "outclk6 (pll_extra_clock1)"
   set extra_clk2_grp                      "outclk7 (pll_extra_clock2)"
   set extra_clk3_grp                      "outclk8 (pll_extra_clock3)"
   
   set show_reserved_clks                  1
   set use_port_name_as_role_name          0
   set hide_gui_if_disabled                0
   
   set mapped_sys_info_device_family       "mapped_sys_info_device_family"
   set mapped_sys_info_device              "mapped_sys_info_device"
   set mapped_sys_info_device_speedgrade   "mapped_sys_info_device_speedgrade"
   set mapped_reference_clock_frequency    "mapped_reference_clock_frequency"
   set mapped_vco_frequency                "mapped_vco_frequency"
   set mapped_external_pll_mode            "mapped_external_pll_mode"

   set pll_input_clock_frequency           "pll_input_clock_frequency"  
   set pll_vco_clock_frequency             "pll_vco_clock_frequency"    
   set m_cnt_hi_div                        "m_cnt_hi_div"               
   set m_cnt_lo_div                        "m_cnt_lo_div"               
   set n_cnt_hi_div                        "n_cnt_hi_div"               
   set n_cnt_lo_div                        "n_cnt_lo_div"               
   set m_cnt_bypass_en                     "m_cnt_bypass_en"            
   set n_cnt_bypass_en                     "n_cnt_bypass_en"            
   set m_cnt_odd_div_duty_en               "m_cnt_odd_div_duty_en"      
   set n_cnt_odd_div_duty_en               "n_cnt_odd_div_duty_en"      
   set pll_cp_setting                      "pll_cp_setting"             
   set pll_bw_ctrl                         "pll_bw_ctrl"                
   set c_cnt_hi_div                        "c_cnt_hi_div"               
   set c_cnt_lo_div                        "c_cnt_lo_div"               
   set c_cnt_prst                          "c_cnt_prst"                 
   set c_cnt_ph_mux_prst                   "c_cnt_ph_mux_prst"          
   set c_cnt_bypass_en                     "c_cnt_bypass_en"            
   set c_cnt_odd_div_duty_en               "c_cnt_odd_div_duty_en"      
   set pll_output_clock_frequency_         "pll_output_clock_frequency_"
   set pll_output_phase_shift_             "pll_output_phase_shift_"    
   set pll_output_duty_cycle_              "pll_output_duty_cycle_"     
   set pll_clk_out_en_                     "pll_clk_out_en_"            
   set pll_fbclk_mux_1                     "pll_fbclk_mux_1"            
   set pll_fbclk_mux_2                     "pll_fbclk_mux_2"            
   set pll_m_cnt_in_src                    "pll_m_cnt_in_src"           
   set pll_bw_sel                          "pll_bw_sel"       

   set pll_extra_clock                     "pll_extra_clock"
   set pll_locked                          "pll_locked"
   
   # Override settings
   foreach key [dict keys $overrides] {
      set $key [dict get $overrides $key]
   }
   
   set pll_display_items "\
      {NAME                               GROUP                               ENABLED             VISIBLE                                                    TYPE   ARGS  }\
      {\"$output_clocks_grp\"             \"\"                                NOVAL               $gui_enable_advanced_mode                                  GROUP  NOVAL }\     
      {\"TEXT_EXTRA_DESC\"                \"$output_clocks_grp\"              NOVAL               $gui_enable_advanced_mode                                  TEXT   [list \"$text_extra_desc\"] }\
      {\"outclk0 (Reserved)\"             \"$output_clocks_grp\"              NOVAL               \"$gui_enable_advanced_mode && $show_reserved_clks\"       GROUP  NOVAL }\
      {\"outclk1 (Reserved)\"             \"$output_clocks_grp\"              NOVAL               \"$gui_enable_advanced_mode && $show_reserved_clks\"       GROUP  NOVAL }\
      {\"outclk2 (Reserved)\"             \"$output_clocks_grp\"              NOVAL               \"$gui_enable_advanced_mode && $show_reserved_clks\"       GROUP  NOVAL }\
      {\"outclk3 (Reserved)\"             \"$output_clocks_grp\"              NOVAL               \"$gui_enable_advanced_mode && $show_reserved_clks\"       GROUP  NOVAL }\
      {\"outclk4 (Reserved)\"             \"$output_clocks_grp\"              NOVAL               \"$gui_enable_advanced_mode && $show_reserved_clks\"       GROUP  NOVAL }\
      {\"$extra_clk0_grp\"                \"$output_clocks_grp\"              NOVAL               $gui_enable_advanced_mode                                  GROUP  NOVAL }\
      {\"$extra_clk1_grp\"                \"$output_clocks_grp\"              NOVAL               $gui_enable_advanced_mode                                  GROUP  NOVAL }\
      {\"$extra_clk2_grp\"                \"$output_clocks_grp\"              NOVAL               $gui_enable_advanced_mode                                  GROUP  NOVAL }\
      {\"$extra_clk3_grp\"                \"$output_clocks_grp\"              NOVAL               $gui_enable_advanced_mode                                  GROUP  NOVAL }\
   "
      
   set pll_common_parameters "\
      {NAME                                      M_CONTEXT M_USED_FOR_RCFG M_SAME_FOR_RCFG DERIVED HDL_PARAMETER TYPE      DEFAULT_VALUE         ENABLED                          VISIBLE                                                                                     DISPLAY_HINT DISPLAY_UNITS       DISPLAY_ITEM              DISPLAY_NAME                                                            ALLOWED_RANGES                                         VALIDATION_CALLBACK                                                          DESCRIPTION }\
      {$gui_enable_advanced_mode                 NOVAL     0               0               false   false         INTEGER   0                     true                             true                                                                                        BOOLEAN      NOVAL               \"\"                      \"Specify additional output clocks based on existing PLL\"                NOVAL                                                  NOVAL                                                            \"Exports additional PLL output clocks based on the specified configuration.  User can only specify output clocks that are not currently used internally to the IP; the output clocks that are used internally will not be modifiable.  User needs to be cautious when doing cross clock domain transfer with exported output clocks as they will be asynchronous to other clocks generated by the IP.\"}\
      {$gui_compensation_mode                    NOVAL     0               0               true    false         STRING    \"direct\"            true                             false                                                                                        NOVAL        NOVAL             \"\"                            \"Compensation mode\"                                           NOVAL                                                  NOVAL                                                              \"Specifies PLL compensation mode\"}\
      {$gui_number_of_pll_output_clocks          NOVAL     0               0               false   false         STRING    \"0\"                 true                             $gui_enable_advanced_mode                                                                          NOVAL        NOVAL               \"$output_clocks_grp\"                  \"Number of Additional Clocks\"                                 {0 1 2 3 4}                                      NOVAL                                                         \"Specifies the number of PLL output clocks required in the design.\"} \
      {${gui_desired_outclk_frequency}_0         NOVAL     0               0               true    false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"outclk0 (Reserved)\"                \"Desired frequency\"                                           NOVAL                                                 NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_0          NOVAL     0               0               true    false         STRING    \"100.0\"             true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"outclk0 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_0           NOVAL     0               0               true    false         STRING    \"100.0\"             true                             false                                                                                        NOVAL        NOVAL             \"outclk0 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_0          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"outclk0 (Reserved)\"                \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_0       NOVAL     0               0               true    false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"outclk0 (Reserved)\"                \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_0     NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_0 == 0\"             NOVAL        \"ps\"               \"outclk0 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_0    NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_0 == 1\"             NOVAL        NOVAL             \"outclk0 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_0         NOVAL     0               0               true    false         STRING    \"0.0\"               true                             false                                                                                        NOVAL        NOVAL               \"outclk0 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_0        NOVAL     0               0               true    false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk0 (Reserved)\"                \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_0         NOVAL     0               0               true    false         STRING    \"50.0\"              true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk0 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_0          NOVAL     0               0               true    false         STRING    \"50.0\"              true                             false                                                                                        NOVAL        %                 \"outclk0 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_1         NOVAL     0               0               true    false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"outclk1 (Reserved)\"                \"Desired frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_1          NOVAL     0               0               true    false         STRING    \"100.0\"             true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"outclk1 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_1           NOVAL     0               0               true    false         STRING    \"100.0\"             true                             false                                                                                        NOVAL        NOVAL             \"outclk1 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_1          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"outclk1 (Reserved)\"                \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_1       NOVAL     0               0               true    false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"outclk1 (Reserved)\"                \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_1     NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_1 == 0\"             NOVAL        \"ps\"               \"outclk1 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_1    NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_1 == 1\"             NOVAL        NOVAL             \"outclk1 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_1         NOVAL     0               0               true    false         STRING    \"0.0\"               true                             false                                                                                        NOVAL        NOVAL               \"outclk1 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_1        NOVAL     0               0               true    false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk1 (Reserved)\"                \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_1         NOVAL     0               0               true    false         STRING    \"50.0\"              true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk1 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_1          NOVAL     0               0               true    false         STRING    \"50.0\"              true                             false                                                                                        NOVAL        %                 \"outclk1 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_2         NOVAL     0               0               true    false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"outclk2 (Reserved)\"                \"Desired frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_2          NOVAL     0               0               true    false         STRING    \"100.0\"             true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"outclk2 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_2           NOVAL     0               0               true    false         STRING    \"100.0\"             true                             false                                                                                        NOVAL        NOVAL             \"outclk2 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_2          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"outclk2 (Reserved)\"                \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_2       NOVAL     0               0               true    false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"outclk2 (Reserved)\"                \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_2     NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_2 == 0\"             NOVAL        \"ps\"              \"outclk2 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_2    NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_2 == 1\"             NOVAL        NOVAL             \"outclk2 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_2         NOVAL     0               0               true    false         STRING    \"0.0\"               true                             false                                                                                        NOVAL        NOVAL               \"outclk2 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_2        NOVAL     0               0               true    false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk2 (Reserved)\"                \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_2         NOVAL     0               0               true    false         STRING    \"50.0\"              true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk2 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_2          NOVAL     0               0               true    false         STRING    \"50.0\"              true                             false                                                                                        NOVAL        %                 \"outclk2 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_3         NOVAL     0               0               true    false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"outclk3 (Reserved)\"              \"Desired frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_3          NOVAL     0               0               true    false         STRING    \"100.0\"             true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"outclk3 (Reserved)\"              \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_3           NOVAL     0               0               true    false         STRING    \"100.0\"             true                             false                                                                                        NOVAL        NOVAL             \"outclk3 (Reserved)\"              \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_3          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"outclk3 (Reserved)\"              \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_3       NOVAL     0               0               true    false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"outclk3 (Reserved)\"              \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_3     NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_3 == 0\"             NOVAL        \"ps\"              \"outclk3 (Reserved)\"              \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_3    NOVAL     0               0               true    false         STRING    \"0.0\"               true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_3 == 1\"             NOVAL        NOVAL             \"outclk3 (Reserved)\"              \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_3         NOVAL     0               0               true    false         STRING    \"0.0\"               true                             false                                                                                        NOVAL        NOVAL               \"outclk3 (Reserved)\"              \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_3        NOVAL     0               0               true    false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk3 (Reserved)\"              \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_3         NOVAL     0               0               true    false         STRING    \"50.0\"              true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk3 (Reserved)\"              \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_3          NOVAL     0               0               true    false         STRING    \"50.0\"              true                             false                                                                                        NOVAL        %                 \"outclk3 (Reserved)\"              \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_4         NOVAL     0               0               true    false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"outclk4 (Reserved)\"                \"Desired frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_4          NOVAL     0               0               true    false         STRING    \"100.0\"             true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"outclk4 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_4           NOVAL     0               0               true    false         STRING    \"100.0\"             true                             false                                                                                        NOVAL        NOVAL             \"outclk4 (Reserved)\"                \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_4          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"outclk4 (Reserved)\"                \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_4       NOVAL     0               0               true    false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"outclk4 (Reserved)\"                \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_4     NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_4 == 0\"             NOVAL        \"ps\"              \"outclk4 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_4    NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_4 == 1\"             NOVAL        NOVAL             \"outclk4 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_4         NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             false                                                                                        NOVAL        NOVAL               \"outclk4 (Reserved)\"                \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_4        NOVAL     0               0               true    false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk4 (Reserved)\"                \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_4         NOVAL     0               0               true    false         STRING    \"50.0\"                true                             \"$gui_number_of_pll_output_clocks >= 0 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"outclk4 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_4          NOVAL     0               0               true    false         STRING    \"50.0\"                true                             false                                                                                        NOVAL        %                 \"outclk4 (Reserved)\"                \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_5         NOVAL     0               0               false   false         FLOAT     100.0                  true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"$extra_clk0_grp\"      \"Desired frequency\"                                           {0.000001:10000}                                       NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_5          NOVAL     0               0               false   false         STRING    \"100.0\"                true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"$extra_clk0_grp\"      \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_5           NOVAL     0               0               true    false         STRING    \"100.0\"                true                             false                                                                                        NOVAL        NOVAL             \"$extra_clk0_grp\"      \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_5          NOVAL     0               0               false   false         STRING    0                      true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"$extra_clk0_grp\"      \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_5       NOVAL     0               0               false   false         FLOAT     0.0                    true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"$extra_clk0_grp\"      \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_5     NOVAL     0               0               false   false         STRING    \"0.0\"                  true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_5 == 0\"             NOVAL        \"ps\"              \"$extra_clk0_grp\"      \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_5    NOVAL     0               0               false   false         STRING    \"0.0\"                  true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_5 == 1\"             NOVAL        NOVAL             \"$extra_clk0_grp\"      \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_5         NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             false                                                                                        NOVAL        NOVAL               \"$extra_clk0_grp\"      \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_5        NOVAL     0               0               false   false         FLOAT    50.0                   true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk0_grp\"      \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_5         NOVAL     0               0               false   false         STRING   \"50.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 1 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk0_grp\"      \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_5          NOVAL     0               0               true    false         STRING    \"50.0\"                true                             false                                                                                        NOVAL        %                 \"$extra_clk0_grp\"      \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_6         NOVAL     0               0               false   false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"$extra_clk1_grp\"          \"Desired frequency\"                                           {0.000001:10000}                                       NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_6          NOVAL     0               0               false   false         STRING    \"100.0\"               true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"$extra_clk1_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_6           NOVAL     0               0               true    false         STRING   \"100.0\"                true                             false                                                                                        NOVAL        NOVAL             \"$extra_clk1_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_6          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"$extra_clk1_grp\"          \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_6       NOVAL     0               0               false   false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"$extra_clk1_grp\"          \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_6     NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_6 == 0\"             NOVAL        \"ps\"              \"$extra_clk1_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_6    NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_6 == 1\"             NOVAL        NOVAL             \"$extra_clk1_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_6         NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             false                                                                                        NOVAL        NOVAL               \"$extra_clk1_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_6        NOVAL     0               0               false   false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk1_grp\"          \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_6         NOVAL     0               0               false   false         STRING    \"50.0\"                true                             \"$gui_number_of_pll_output_clocks >= 2 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk1_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_6          NOVAL     0               0               true    false         STRING    \"50.0\"                true                             false                                                                                        NOVAL        %                 \"$extra_clk1_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_7         NOVAL     0               0               false   false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"$extra_clk2_grp\"          \"Desired frequency\"                                           {0.000001:10000}                                       NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_7          NOVAL     0               0               false   false         STRING    \"100.0\"               true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"$extra_clk2_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_7           NOVAL     0               0               true    false         STRING   \"100.0\"                true                             false                                                                                        NOVAL        NOVAL             \"$extra_clk2_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_7          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"$extra_clk2_grp\"          \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_7       NOVAL     0               0               false   false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"$extra_clk2_grp\"          \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_7     NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_7 == 0\"             NOVAL        \"ps\"              \"$extra_clk2_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_7    NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_7 == 1\"             NOVAL        NOVAL             \"$extra_clk2_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_7         NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             false                                                                                        NOVAL        NOVAL               \"$extra_clk2_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_7        NOVAL     0               0               false   false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk2_grp\"          \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_7         NOVAL     0               0               false   false         STRING    \"50.0\"                true                             \"$gui_number_of_pll_output_clocks >= 3 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk2_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_7          NOVAL     0               0               true    false         STRING    \"50.0\"                true                             false                                                                                        NOVAL        %                 \"$extra_clk2_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${gui_desired_outclk_frequency}_8         NOVAL     0               0               false   false         FLOAT     100.0                 true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        MHz                 \"$extra_clk3_grp\"          \"Desired frequency\"                                           {0.000001:10000}                                       NOVAL                                                            \"Specifies requested value for output clock frequency\"}\
      {${gui_actual_outclk_frequency}_8          NOVAL     0               0               false   false         STRING    \"100.0\"               true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        MHz               \"$extra_clk3_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for output clock frequency\"}\
      {${hp_actual_outclk_frequency}_8           NOVAL     0               0               true    false         STRING   \"100.0\"                true                             false                                                                                        NOVAL        NOVAL             \"$extra_clk3_grp\"          \"Actual frequency\"                                           NOVAL                                                  NOVAL                                                              \"Specifies actual value for output clock frequency\"}\
      {${gui_outclk_phase_shift_unit}_8          NOVAL     0               0               false   false         STRING    0                     true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        NOVAL               \"$extra_clk3_grp\"          \"Phase shift units\"                                           { \"0:ps\"  }                                            NOVAL                                                            \"Specifies phase shift in degrees or picoseconds\"} \
      {${gui_outclk_desired_phase_shift}_8       NOVAL     0               0               false   false         FLOAT     0.0                   true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        \"ps\"               \"$extra_clk3_grp\"          \"Phase shift\"                                                   NOVAL                                                  NOVAL                                                            \"Specifies requested value for phase shift\"} \
      {${gui_outclk_actual_phase_shift_ps}_8     NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_8 == 0\"             NOVAL        \"ps\"              \"$extra_clk3_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_outclk_actual_phase_shift_deg}_8    NOVAL     0               0               false   false         STRING    \"0.0\"                 true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode && ${gui_outclk_phase_shift_unit}_8 == 1\"             NOVAL        NOVAL             \"$extra_clk3_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in degrees\"}\
      {${hp_outclk_actual_phase_shift}_8         NOVAL     0               0               true    false         STRING    \"0.0\"                 true                             false                                                                                        NOVAL        NOVAL               \"$extra_clk3_grp\"          \"Actual phase shift\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for phase shift in ps\"}\
      {${gui_desired_outclk_duty_cycle}_8        NOVAL     0               0               false   false         FLOAT     50.0                  true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk3_grp\"          \"Desired duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies requested value for duty cycle\"}\
      {${gui_actual_outclk_duty_cycle}_8         NOVAL     0               0               false   false         STRING    \"50.0\"                true                             \"$gui_number_of_pll_output_clocks >= 4 && $gui_enable_advanced_mode\"                                           NOVAL        %                 \"$extra_clk3_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
      {${hp_actual_outclk_duty_cycle}_8          NOVAL     0               0               true    false         STRING    \"50.0\"                true                             false                                                                                        NOVAL        %                 \"$extra_clk3_grp\"          \"Actual duty cycle\"                                           NOVAL                                                  NOVAL                                                            \"Specifies actual value for duty cycle\"}\
   "  

   set pll_physical_parameters "\
      {NAME                                      M_CONTEXT M_USED_FOR_RCFG M_SAME_FOR_RCFG DERIVED HDL_PARAMETER TYPE      DEFAULT_VALUE                  ENABLED                                  VISIBLE                                                                                     DISPLAY_HINT DISPLAY_UNITS       DISPLAY_ITEM              DISPLAY_NAME                                                            ALLOWED_RANGES                                         VALIDATION_CALLBACK                                                          DESCRIPTION }\
      {$pll_input_clock_frequency                  NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"refclk frequency\"                                           NOVAL                                       NOVAL                                                         \"PLL refclk frequency\"} \
      {$pll_vco_clock_frequency                  NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"VCO\"                                                    NOVAL                                       NOVAL                                                         \"PLL VCO frequency\"} \
      {$m_cnt_hi_div                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"M counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {$m_cnt_lo_div                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"M counter Low value\"                                            {1:256}                                                  NOVAL                                                            \"\"}\
      {$n_cnt_hi_div                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"N counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {$n_cnt_lo_div                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"N counter Low value\"                                            {1:256}                                                  NOVAL                                                            \"\"}\
      {$m_cnt_bypass_en                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"M counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {$n_cnt_bypass_en                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"N counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {$m_cnt_odd_div_duty_en                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"M counter odd div duty\"                                        NOVAL                                                  NOVAL                                                            \"\"}\
      {$n_cnt_odd_div_duty_en                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"N counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_cp_setting                           NOVAL     0               0               true    true          STRING    \"PLL_CP_SETTING0\"              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"Charge Pump Current\"                                             NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_bw_ctrl                              NOVAL     0               0               true    true          STRING    \"PLL_BW_RES_SETTING4\"          true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"Bandwidth Setting\"                                             NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}0                         NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}0                         NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}0                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}0                     NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}0                         NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}0                   NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}1                         NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}1                         NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}1                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}1                     NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}1                         NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}1                   NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}2                         NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}2                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}2                            NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter Preset\"                                           {1:256}                                                 NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}2                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter Phase Mux Preset\"                                     {0:7}                                                 NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}2                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}2                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}3                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}3                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}3                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}3                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}3                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}3                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}4                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}4                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}4                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}4                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}4                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}4                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}5                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}5                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}5                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}5                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}5                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}5                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}6                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}6                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}6                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}6                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}6                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}6                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}7                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}7                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}7                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}7                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}7                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}7                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_hi_div}8                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter High value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_lo_div}8                        NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter Low value\"                                        {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_prst}8                           NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter Preset\"                                           {1:256}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_ph_mux_prst}8                    NOVAL     0               0               true    true          INTEGER   1                              true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter Phase Mux Preset\"                                     {0:7}                                                  NOVAL                                                            \"\"}\
      {${c_cnt_bypass_en}8                        NOVAL     0               0               true    true          STRING    \"true\"                         true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter bypass\"                                            NOVAL                                                  NOVAL                                                            \"\"}\
      {${c_cnt_odd_div_duty_en}8                  NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter odd div duty\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_output_clock_frequency_}0             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}0                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}0                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}1             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}1                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}1                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}2             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}2                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}2                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}3             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}3                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}3                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}4             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}4                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}4                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}5             NOVAL      0            0            true    true          STRING   \"100.0 MHz\"                      true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}5                 NOVAL      0            0            true    true          STRING   \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}5                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}6             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}6                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}6                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}7             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}7                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}7                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_output_clock_frequency_}8             NOVAL      0            0            true    true          STRING    \"100.0 MHz\"                  true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual frequency\"                                           NOVAL                                       NOVAL                                                         \"Specifies actual value for output clock frequency\"} \
      {${pll_output_phase_shift_}8                 NOVAL      0            0            true    true          STRING    \"0 ps\"                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual phase shift\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual value for phase shift\"} \
      {${pll_output_duty_cycle_}8                    NOVAL      0            0            true    true          INTEGER   50.0                         true                             false                                                                                       NOVAL       NOVAL               \"$output_clocks_grp\"             \"Actual duty cycle\"                                        NOVAL                                       NOVAL                                                         \"Specifies actual duty cycle value for output clock frequency\"} \
      {${pll_clk_out_en_}0                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C0 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}1                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C1 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}2                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C2 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}3                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C3 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}4                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C4 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}5                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C5 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}6                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C6 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}7                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C7 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {${pll_clk_out_en_}8                         NOVAL     0               0               true    true          STRING    \"false\"                        true                                   false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"C8 counter ouput enable\"                                         NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_fbclk_mux_1                         NOVAL     0               0               true    true          STRING    \"pll_fbclk_mux_1_glb\"          true                                     false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"Feedback mux for compensation mode\"                               NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_fbclk_mux_2                         NOVAL     0               0               true    true          STRING    \"pll_fbclk_mux_2_m_cnt\"          true                                     false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"Feedback mux for compensation mode\"                               NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_m_cnt_in_src                         NOVAL     0               0               true    true          STRING    \"c_m_cnt_in_src_ph_mux_clk\"       true                                     false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"M counter source\"                                           NOVAL                                                  NOVAL                                                            \"\"}\
      {$pll_bw_sel                            NOVAL     0               0               true    true          STRING    \"high\"                      true                                     false                                                                                        NOVAL        NOVAL               \"$output_clocks_grp\"             \"Bandwidth type\"                                              NOVAL                                                  NOVAL                                                            \"\"}\
   "
 
   # IMPORTANT NOTE: M_MAPS_FROM should be updated with external calls
   set mapped_parameters "\
      { NAME                                   TYPE       DERIVED   M_MAPS_FROM                 M_MAP_VALUES    VISIBLE    DEFAULT_VALUE                  } \
      { $mapped_sys_info_device_family         STRING     true      NOVAL                       NOVAL            false        NOVAL                       } \     
      { $mapped_sys_info_device                STRING     true      NOVAL                       NOVAL            false        NOVAL                       } \     
      { $mapped_sys_info_device_speedgrade     STRING     true      NOVAL                       NOVAL            false        NOVAL                       } \     
      { $mapped_reference_clock_frequency      STRING     true      NOVAL                       NOVAL            false        NOVAL                       } \     
      { $mapped_vco_frequency                  STRING     true      NOVAL                       NOVAL            false        NOVAL                       } \     
      { $mapped_external_pll_mode              STRING     true      NOVAL                       NOVAL            false        \"false\"                   } \     
   "

   set pll_outclk_reference_list [list]
   set pll_maximum_number_of_reserved_clocks 5
}

proc ::altera_iopll_common::iopll::set_pll_display_item_properties { group_value args_value } {
   variable pll_display_items

   set pll_display_items [set_property_byParameterIndex $pll_display_items GROUP $group_value 1]
   set pll_display_items [set_property_byParameterIndex $pll_display_items ARGS $args_value 1]
}

proc ::altera_iopll_common::iopll::declare_pll_display_items { parent_group } {
   variable pll_display_items
   variable gui_enable_advanced_mode
   variable output_clocks_grp
   
   add_display_item $parent_group $gui_enable_advanced_mode PARAMETER   
   ip_declare_display_items $pll_display_items   
   add_display_item $parent_group $output_clocks_grp GROUP
}

proc ::altera_iopll_common::iopll::declare_pll_parameters {} {
   variable pll_common_parameters
   variable mapped_parameters
   ip_declare_parameters $mapped_parameters
   ip_declare_parameters $pll_common_parameters   
}

proc ::altera_iopll_common::iopll::declare_pll_physical_parameters {} {
   variable pll_physical_parameters
   ip_declare_parameters $pll_physical_parameters
   return $pll_physical_parameters
}

proc ::altera_iopll_common::iopll::declare_pll_interfaces { } {
   variable pll_maximum_number_of_reserved_clocks
   variable gui_enable_advanced_mode
   variable gui_number_of_pll_output_clocks
   variable mapped_external_pll_mode
   variable pll_extra_clock
   variable pll_locked
      
   set external_pll_mode [get_parameter_value $mapped_external_pll_mode]
   set enable [get_parameter_value $gui_enable_advanced_mode]
   set enable_advanced_mode [expr {!($external_pll_mode == "true") && $enable}]
   set number_of_additional_clocks [get_parameter_value $gui_number_of_pll_output_clocks] 
   add_if "${pll_extra_clock}0" conduit end OUTPUT 
   add_if "${pll_extra_clock}1" conduit end OUTPUT  
   add_if "${pll_extra_clock}2" conduit end OUTPUT  
   add_if "${pll_extra_clock}3" conduit end OUTPUT  
   add_if $pll_locked conduit end OUTPUT
   
   for { set i 0 } {$i < $number_of_additional_clocks} {incr i} {
	   if { $enable_advanced_mode && $number_of_additional_clocks > $i && $number_of_additional_clocks <= 4} {
			set_interface_property ${pll_extra_clock}${i}_conduit_end ENABLED true 
	   }
   }
}

proc ::altera_iopll_common::iopll::validate {} {      	
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
	variable output_clocks_grp
	variable mapped_external_pll_mode
	variable hide_gui_if_disabled
   
	ip_validate_parameters
	ip_validate_display_items


	set show_messages 0
	::altera_iopll_common::iopll::validate_pll_output_clocks $show_messages
   
	set property_name "ENABLED"
		
	set external_pll_mode [get_parameter_value $mapped_external_pll_mode]
	set disable_advanced_mode [expr {!($external_pll_mode == "true")}]
	set_parameter_property $gui_enable_advanced_mode $property_name $disable_advanced_mode
	set_parameter_property $gui_number_of_pll_output_clocks $property_name $disable_advanced_mode
	set_display_item_property $output_clocks_grp $property_name $disable_advanced_mode
	for { set i 0 } {$i < 9} {incr i} {
		set_parameter_property ${gui_desired_outclk_frequency}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_actual_outclk_frequency}_$i $property_name $disable_advanced_mode
		set_parameter_property ${hp_actual_outclk_frequency}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_outclk_phase_shift_unit}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_outclk_desired_phase_shift}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_outclk_actual_phase_shift_ps}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_outclk_actual_phase_shift_deg}_$i $property_name $disable_advanced_mode
		set_parameter_property ${hp_outclk_actual_phase_shift}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_desired_outclk_duty_cycle}_$i $property_name $disable_advanced_mode
		set_parameter_property ${gui_actual_outclk_duty_cycle}_$i $property_name $disable_advanced_mode
		set_parameter_property ${hp_actual_outclk_duty_cycle}_$i $property_name $disable_advanced_mode
	}
	
	# Revalidate
	set show_messages 1
	::altera_iopll_common::iopll::validate_pll_output_clocks	$show_messages
}

proc ::altera_iopll_common::iopll::set_sys_info_device_family { mapsFrom } {
   variable mapped_parameters
   variable mapped_sys_info_device_family
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_sys_info_device_family]
}

proc ::altera_iopll_common::iopll::set_sys_info_device { mapsFrom } {
   variable mapped_parameters
   variable mapped_sys_info_device           
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_sys_info_device]
}

proc ::altera_iopll_common::iopll::set_sys_info_device_speedgrade { mapsFrom } {
   variable mapped_parameters
   variable mapped_sys_info_device_speedgrade
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_sys_info_device_speedgrade]
}

proc ::altera_iopll_common::iopll::set_reference_clock_frequency { mapsFrom } {
   variable mapped_parameters
   variable mapped_reference_clock_frequency 
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_reference_clock_frequency]
}

proc ::altera_iopll_common::iopll::set_vco_frequency { mapsFrom } {
   variable mapped_parameters
   variable mapped_vco_frequency             
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_vco_frequency]
}

proc ::altera_iopll_common::iopll::set_external_pll_mode { mapsFrom } {
   variable mapped_parameters
   variable mapped_external_pll_mode
   set mapped_parameters [set_property_byParameterName $mapped_parameters M_MAPS_FROM $mapsFrom $mapped_external_pll_mode]
}

proc ::altera_iopll_common::iopll::enable_pll_locked_port { } {
   set_interface_property pll_locked_conduit_end ENABLED true 
}

proc ::altera_iopll_common::iopll::disable_pll_locked_port { } {
   set_interface_property pll_locked_conduit_end ENABLED false
}

##################################################################################################################################################
# Callback FUNCTIONS
##################################################################################################################################################
proc ::altera_iopll_common::iopll::validate_pll_output_clocks {{show_messages 1}} {
	variable pll_outclk_reference_list
	variable pll_maximum_number_of_reserved_clocks	
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
	
	set phase_shift_in_ps_without_unit 0
	set phase_shift_in_degree_without_unit 0

	update_hp_actual_values
	
	# each output clock info set includes output clock frequency, phase shift and duty cycle
	set index 0
	set num_of_clocks_info [llength $pll_outclk_reference_list]
	for { set i 0 } {$i < $num_of_clocks_info} {incr i 3} {
		set output_freq 	  			[lindex $pll_outclk_reference_list $i]
		set phase_shift_in_ps 			[lindex $pll_outclk_reference_list $i+1]
		set phase_shift_in_degree 		[lindex [ps_to_degrees $phase_shift_in_ps $output_freq] 0]
		set phase_shift_unit 			[get_parameter_value ${gui_outclk_phase_shift_unit}_$index]
		set duty_cycle 		  			[lindex $pll_outclk_reference_list $i+2]

		# outclk frequency
		regexp {([-0-9.]+)} $output_freq output_freq_without_unit 
		set gui_freq_range [list]
		lappend gui_freq_range $output_freq_without_unit
		set_parameter_value ${gui_desired_outclk_frequency}_$index $output_freq
		set_parameter_value ${gui_actual_outclk_frequency}_$index $output_freq_without_unit
		map_allowed_range ${gui_actual_outclk_frequency}_$index $gui_freq_range $output_freq_without_unit
        
		# phase shift
		regexp {([-0-9.]+)} $phase_shift_in_degree phase_shift_in_degree_without_unit 
		regexp {([-0-9.]+)} $phase_shift_in_ps phase_shift_in_ps_without_unit 
		set gui_deg_range [list]
		set gui_ps_range [list]
		lappend gui_deg_range $phase_shift_in_degree_without_unit
		lappend gui_ps_range $phase_shift_in_ps_without_unit
		if { $phase_shift_unit == 1 } {
			set_parameter_value ${gui_outclk_desired_phase_shift}_$index $phase_shift_in_degree
		} else {
			set_parameter_value ${gui_outclk_desired_phase_shift}_$index $phase_shift_in_ps
		}
		set_parameter_value ${gui_outclk_actual_phase_shift_ps}_$index $phase_shift_in_ps_without_unit
		set_parameter_value ${gui_outclk_actual_phase_shift_deg}_$index $phase_shift_in_degree_without_unit
		map_allowed_range ${gui_outclk_actual_phase_shift_ps}_$index $gui_ps_range $phase_shift_in_ps_without_unit
		map_allowed_range ${gui_outclk_actual_phase_shift_deg}_$index $gui_deg_range $phase_shift_in_degree_without_unit
        
		# duty cycle
		set gui_duty_cycle_range [list]
		lappend gui_duty_cycle_range $duty_cycle
		set_parameter_value ${gui_desired_outclk_duty_cycle}_$index $duty_cycle
		set_parameter_value ${gui_actual_outclk_duty_cycle}_$index $duty_cycle
		map_allowed_range ${gui_actual_outclk_duty_cycle}_$index $gui_duty_cycle_range $duty_cycle
        
		incr index
        
	}	
    
	
	for { set i $pll_maximum_number_of_reserved_clocks } {$i < 9} {incr i} {
		set gui_freq_range [list]
		set gui_ps_range [list]
		set gui_duty_cycle_range [list]
		lappend gui_freq_range "100.0"
		map_allowed_range ${gui_actual_outclk_frequency}_$i $gui_freq_range "100.0"
		lappend gui_ps_range "0.0"
		map_allowed_range ${gui_outclk_actual_phase_shift_ps}_$i $gui_ps_range "0.0"
		lappend gui_duty_cycle_range "50"
		map_allowed_range ${gui_actual_outclk_duty_cycle}_$i $gui_duty_cycle_range "50"
	}

	# validate VCO
	if {[validate_fixed_vco_freq] == "TCL_ERROR"} {
		return TCL_ERROR
	}
	
	# validate the extra output clocks
	set num_clocks [expr {[get_parameter_value $gui_number_of_pll_output_clocks] + $pll_maximum_number_of_reserved_clocks}]
	#---freq
	for {set i 0} {$i < $num_clocks} {incr i} {
		if {[validate_clock_frequency $i] == "TCL_ERROR"} {
			return TCL_ERROR
		}
		if {$i > 4} {
			set hp1 [get_parameter_value ${hp_actual_outclk_frequency}_$i]
			set hp [round_freq $hp1]
			set desired [get_parameter_value ${gui_desired_outclk_frequency}_$i]
			if {$show_messages && $hp != $desired} {
				iopll_send_message WARNING "Able to implement PLL, but Actual Frequency Settings ($hp) differ from Requested Settings ($desired) for additional clock"
			}
		}
	}
	
	#---phase
	for {set i 0} {$i < $num_clocks} {incr i} {
		if {[validate_clock_phase $i] == "TCL_ERROR"} {
			return TCL_ERROR
		}
		if {$i > 4} {
			set hp1 [get_parameter_value ${hp_outclk_actual_phase_shift}_$i]
			set hp [round_phase $hp1]
			set desired [get_parameter_value ${gui_outclk_desired_phase_shift}_$i]
			if {$show_messages && $hp != $desired} {
				iopll_send_message WARNING "Able to implement PLL, but Actual Phase Shift Settings ($hp) differ from Requested Settings ($desired) for additional clock"
			}
		}
	}
	#---duty
	for {set i 0} {$i < $num_clocks} {incr i} {
		if {[validate_clock_duty $i] == "TCL_ERROR"} {
			return TCL_ERROR
		}
		if {$i > 4} {
			set hp1 [get_parameter_value ${hp_actual_outclk_duty_cycle}_$i]
			set hp [round_duty $hp1]
			set desired [get_parameter_value ${gui_desired_outclk_duty_cycle}_$i]
			if {$show_messages && $hp != $desired} {
				iopll_send_message WARNING "Able to implement PLL, but Actual Duty Cycle Settings ($hp) differ from Requested Settings ($desired) for additional clock"
			}
		}
	}	
	
	set gui_range [list]
	lappend gui_range "N/A"
	for { set i $index } {$i < $pll_maximum_number_of_reserved_clocks} {incr i} {
		set_parameter_value ${gui_desired_outclk_frequency}_$i "N/A"
		set_parameter_value ${gui_actual_outclk_frequency}_$i "N/A"
		set_parameter_value ${gui_outclk_desired_phase_shift}_$i "N/A"
		set_parameter_value ${gui_outclk_actual_phase_shift_ps}_$i "N/A"
		set_parameter_value ${gui_outclk_actual_phase_shift_deg}_$i "N/A"
		set_parameter_value ${gui_desired_outclk_duty_cycle}_$i "N/A"
		set_parameter_value ${gui_actual_outclk_duty_cycle}_$i "N/A"
		
		map_allowed_range ${gui_actual_outclk_frequency}_$i $gui_range "N/A"
		map_allowed_range ${gui_outclk_actual_phase_shift_ps}_$i $gui_range "N/A"
		map_allowed_range ${gui_outclk_actual_phase_shift_deg}_$i $gui_range "N/A"
		map_allowed_range ${gui_actual_outclk_duty_cycle}_$i $gui_range "N/A"
	}
}

proc ::altera_iopll_common::iopll::validate_clock_frequency {n_clock} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	set i $n_clock
		
	#get the previously validated counter values (higher precedence)
	array set c_cnt_array [make_validated_c_counter_array freq $i]
	
	#get the current clock's desired values (produce a list for this)
	array set desired_array [make_desired_c_counter_array freq $i]
	
	#get the new list
	set result [get_output_counter_freq_dropdown_list [array get c_cnt_array] [array get desired_array]]
	if {$result == "TCL_ERROR"} {
		return TCL_ERROR
	}
	array set result_array $result
	
	#now update the actual values
	
	#first determine what the new actual value should be (ie what to select from the list)
	set existing_range [get_parameter_property ${hp_actual_outclk_frequency}_$i ALLOWED_RANGES]
	set existing_value [get_parameter_value ${hp_actual_outclk_frequency}_$i]
	set new_closest_value $result_array(closest_freq)
	set new_range $result_array(freq)
	set new_gui_range [round_freq $new_range]
	
	set new_value [determine_new_hp_value $existing_range $existing_value $new_range $new_closest_value $new_gui_range]	
	
	#second, actually set the new values
	set_parameter_value ${hp_actual_outclk_frequency}_$i $new_value
	set_parameter_property ${hp_actual_outclk_frequency}_$i ALLOWED_RANGES $new_range
	map_allowed_range ${gui_actual_outclk_frequency}_$i $new_gui_range [round_freq $new_value]

	return TCL_OK
}

proc ::altera_iopll_common::iopll::validate_clock_phase {n_clock} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	set i $n_clock
	
	#get the previously validated counter values (higher precedence)
	array set c_cnt_array [make_validated_c_counter_array phase $i]
	
	#get the current clock's desired values (produce a list for this)
	array set desired_array [make_desired_c_counter_array phase $i]

	#get the new list
	set result [get_output_counter_phase_dropdown_list [array get c_cnt_array] [array get desired_array]]	
	if {$result == "TCL_ERROR"} {
		return TCL_ERROR
	}
	array set result_array $result
	
	#now update the actual values
	set existing_range [get_parameter_property ${hp_outclk_actual_phase_shift}_$i ALLOWED_RANGES]
	set existing_value [get_parameter_value ${hp_outclk_actual_phase_shift}_$i]
	set new_closest_value $result_array(closest_phase)
	set new_range $result_array(phase)
	set new_gui_range [round_phase $new_range]
	
	set new_value [determine_new_hp_value $existing_range $existing_value $new_range $new_closest_value $new_gui_range]	
	
	#now update the actual values
	set_parameter_value ${hp_outclk_actual_phase_shift}_$i $new_value
	set_parameter_property ${hp_outclk_actual_phase_shift}_$i ALLOWED_RANGES $new_range
	
	#setting the visible range
	set gui_ps_unit [get_parameter_value ${gui_outclk_phase_shift_unit}_$i]
	if { $gui_ps_unit == 0} {
		map_allowed_range ${gui_outclk_actual_phase_shift_ps}_$i $new_gui_range [round_phase $new_value]
	} else {
		#now get the new phase shift value in degrees
		set index [::altera_iopll::util::search_range_with_tolerance $new_range $new_value 8]
		if {$index == -1} {
			error "IE: you have selected an illegal value..."
		}
		set new_deg_range $result_array(phase_deg)
		set new_deg_gui_range [round_phase $new_deg_range]
		set new_deg_value [lindex $new_deg_range $index]	
		map_allowed_range ${gui_outclk_actual_phase_shift_deg}_$i $new_deg_gui_range [round_phase $new_deg_value]
	}	
	
	return TCL_OK
}

proc ::altera_iopll_common::iopll::validate_clock_duty {n_clock} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	set i $n_clock
	
	#get the previously validated counter values (higher precedence)
	array set c_cnt_array [make_validated_c_counter_array duty $i]
	
	#get the current clock's desired values (produce a list for this)
	array set desired_array [make_desired_c_counter_array duty $i]

	#get the new list
	set result [get_output_counter_duty_dropdown_list [array get c_cnt_array] [array get desired_array]]	
	if {$result == "TCL_ERROR"} {
		return TCL_ERROR
	}
	array set result_array $result
	
	#now update the actual values
	set existing_range [get_parameter_property ${hp_actual_outclk_duty_cycle}_$i ALLOWED_RANGES]
	set existing_value [get_parameter_value ${hp_actual_outclk_duty_cycle}_$i]
	set new_closest_value $result_array(closest_duty)
	set new_range $result_array(duty)
	set new_gui_range [round_duty $new_range]
	
	set new_value [determine_new_hp_value $existing_range $existing_value $new_range $new_closest_value $new_gui_range]	

	#now update the actual values
	set_parameter_value ${hp_actual_outclk_duty_cycle}_$i $new_value
	set_parameter_property ${hp_actual_outclk_duty_cycle}_$i ALLOWED_RANGES $new_range
	map_allowed_range ${gui_actual_outclk_duty_cycle}_$i $new_gui_range [round_duty $new_value]	
	
	return TCL_OK
}

proc ::altera_iopll_common::iopll::validate_fixed_vco_freq {} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle

	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         

	set family [get_parameter_value $mapped_sys_info_device_family]
	set speedgrade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set type IOPLL
	set is_fractional false
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set fixed_vco_freq [get_vco_freq_int]

	##vco range
	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode]

	
	if {[catch {::quartus::pll::legality::get_legal_vco_range $ref_list} result]} {
		iopll_send_message ERROR "$result"
		iopll_send_message ERROR "Unable to retrieve legal vco range"
		return TCL_ERROR
	} 

	array set result_array $result
	set vco_min $result_array(vco_min)
	set vco_max $result_array(vco_max)
	if {$fixed_vco_freq < $vco_min || $fixed_vco_freq > $vco_max} {
		iopll_send_message ERROR "Desired VCO frequency of $fixed_vco_freq MHz is out of range ($vco_min MHz - $vco_max MHz)"
		return TCL_ERROR
	}

	set validated_c_cnts {}
	set desired_c_cnt [make_validated_c_counter_array freq 0]
	set result [get_output_counter_freq_dropdown_list_for_vco $validated_c_cnts $desired_c_cnt]
	
	return TCL_OK
}

##################################################################################################################################################
# Private FUNCTIONS
##################################################################################################################################################
proc ::altera_iopll_common::iopll::set_pll_output_clocks_info { compensation_mode reference_list } {
	variable pll_outclk_reference_list
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
	
	set pll_outclk_reference_list $reference_list
	set_parameter_value $gui_compensation_mode $compensation_mode

	set ouput_clock_frequency_list			[list]
	set phase_shift_list					[list]
	set duty_cycle_list						[list]
	set num_clocks_list						[list]
	
	for { set i 0 } {$i < [llength $reference_list]} {incr i 3} {
		# retreive all the used output clocks info
		set output_freq [lindex $reference_list $i]
		set phase_shift [lindex $reference_list $i+1]
		set duty_cycle [lindex $reference_list $i+2]
		if { $output_freq != "0" } {
			lappend ouput_clock_frequency_list $output_freq
			lappend phase_shift_list $phase_shift
			lappend duty_cycle_list $duty_cycle
		}
	}
}

proc ::altera_iopll_common::iopll::degrees_to_ps {phase_array freq} {
    set return_phase_array [list]
	set phase_value 0
	set freq_value 0

    foreach phase_val $phase_array {
        regexp {([-0-9.]+)} $phase_val phase_value 
        regexp {([-0-9.]+)} $freq freq_value 
        #convert negative phase shift to positive phase shift
        if {$phase_value < 0} {
            set phase_value [expr {360 - abs($phase_value)}]
        }
        set phase_in_ps [expr {$phase_value /(360*$freq_value)}]
        #convert to ps
        set phase_in_ps [expr {$phase_in_ps * 1000000.0}]
        set phase_in_ps [expr {round($phase_in_ps)}]
        lappend return_phase_array $phase_in_ps
    }
    return $return_phase_array

}

proc ::altera_iopll_common::iopll::ps_to_degrees {phase_array freq} {
    set return_phase_array [list]
	set phase_value 0
	set freq_value 0
	
    foreach phase_val $phase_array {
        regexp {([-0-9.]+)} $phase_val phase_value 
        regexp {([-0-9.]+)} $freq freq_value 
        set phase_in_deg [expr {$phase_value*360.0*$freq_value/1000000.0}]
        set phase_in_deg_int [expr {round($phase_in_deg)}]
        set phase_in_deg_mod [expr {$phase_in_deg_int%360}]
		set phase_in_deg [expr $phase_in_deg + $phase_in_deg_mod - $phase_in_deg_int]
		set phase_in_deg [format "%.1f" $phase_in_deg]
        set phase_in_deg "$phase_in_deg deg"
        lappend return_phase_array $phase_in_deg
    }
    return $return_phase_array


}

proc ::altera_iopll_common::iopll::find_closest_value { desired available } {
    
    set least_diff "infinity"
    set closest ""
	set actual_val 0
	set desired_val 0
    
    # Strip units, if any
    regexp {([0-9.]+)} $desired desired_val
    
    foreach val $available {
        regexp {([0-9.]+)} $val actual_val
        set diff [expr abs($desired_val - $actual_val)]
        if {$diff < $least_diff} {
            set closest $val
            set least_diff $diff
        }
    }
    return $closest
}

proc ::altera_iopll_common::iopll::round_freq {input_list} {
	set n_decimals 6
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc ::altera_iopll_common::iopll::round_phase {input_list} {
	set n_decimals 1
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc ::altera_iopll_common::iopll::round_duty {input_list} {
	set n_decimals 2
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc ::altera_iopll_common::iopll::make_validated_c_counter_array {param counter_index {using_adv_mode false}} {	
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	array set c_cnt_array [list]
	set array_index 0
	set current_freq 0 
	set current_phase 0.0
	set current_duty 50.0
	set current_freq_without_unit 0
	set current_phase_without_unit 0
	set current_duty_without_unit 0
	set current_cascade false
	set fixed_vco [get_vco_freq_int]

	#get vco first
	if {!$using_adv_mode} {
		set c_cnt_array($array_index) 	[list -type wire -index 0 -freq $fixed_vco -phase 0.0 -is_degrees false -duty 50.0]
		incr array_index
	}
	
	for {set i 0} {$i < $counter_index} {incr i} {
		set current_freq [get_parameter_value ${hp_actual_outclk_frequency}_$i] 
		set current_phase [get_parameter_value ${hp_outclk_actual_phase_shift}_$i]
		set current_duty [get_parameter_value ${hp_actual_outclk_duty_cycle}_$i]
		
		if { $current_freq == "N/A" } {
			# this particular output clock is not used in the PLL so set it to the VCO
			set current_freq [get_vco_freq_int]
		}
		if { $current_phase == "N/A" } {
			# this particular output clock is not used in the PLL so set it to the VCO
			set current_phase 0.0
		}
		if { $current_duty == "N/A" } {
			# this particular output clock is not used in the PLL so set it to the VCO
			set current_duty 50.0
		}
		
		regexp {([-0-9.]+)} $current_freq current_freq_without_unit
		regexp {([-0-9.]+)} $current_phase current_phase_without_unit
		regexp {([-0-9.]+)} $current_duty current_duty_without_unit
		
		if {$using_adv_mode} {
			set output_freq $current_freq_without_unit
			set current_freq_without_unit [expr { int(round($fixed_vco / $output_freq)) }]
		}
		
		switch $param {
			freq {
				set current_ps_unit_is_degrees false
				set current_phase_without_unit 0.0
				set current_duty_without_unit 50.0
			}
			phase {
				set current_ps_unit_is_degrees false
				set current_duty_without_unit 50.0
			} 
			duty {
				set current_ps_unit_is_degrees false		
			}
			default {
				error "BAD PARAMETER TYPE"
			}
		}
		
		if {$using_adv_mode} {
			set c_cnt_array($array_index) [list -type c -index $i -cdiv $current_freq_without_unit -phase $current_phase_without_unit -is_cascade $current_cascade -is_degrees $current_ps_unit_is_degrees -duty $current_duty_without_unit]
		} else {
			set c_cnt_array($array_index) [list -type c -index $i -freq $current_freq_without_unit -phase $current_phase_without_unit -is_degrees $current_ps_unit_is_degrees -duty $current_duty_without_unit]		
		}
		
		incr array_index
	}
	
	return [array get c_cnt_array]
}

proc ::altera_iopll_common::iopll::make_desired_c_counter_array {param counter_index} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	set i $counter_index
	array set c_cnt_array [list]
	set current_freq_without_unit 0
	set index [expr {$counter_index + 1}]
	
	switch $param {
		freq {
			set current_freq [get_parameter_value ${gui_desired_outclk_frequency}_$i] 
			if { $current_freq == "N/A" || $current_freq == "0.0"} {
				# this particular output clock is not used in the PLL so set it to the VCO
				set current_freq [get_vco_freq_int]
			}
			regexp {([-0-9.]+)} $current_freq current_freq_without_unit
			set current_freq $current_freq_without_unit
			set current_ps_unit_is_degrees false
			set current_phase 0.0
			set current_duty 50.0
		}
		phase {
			set current_freq [get_parameter_value ${hp_actual_outclk_frequency}_$i] 	
			set current_phase_unit [get_parameter_value ${gui_outclk_phase_shift_unit}_$i]
			set current_phase [get_parameter_value ${gui_outclk_desired_phase_shift}_$i]
			if {$current_phase_unit == 0} {	
				set current_ps_unit_is_degrees false
			} else {
				set current_ps_unit_is_degrees true
			}	
			set current_duty 50.0		
		}
		duty {
			set current_freq [get_parameter_value ${hp_actual_outclk_frequency}_$i] 	
			set current_phase [get_parameter_value ${hp_outclk_actual_phase_shift}_$i]
			set current_ps_unit_is_degrees false	
			set current_duty [get_parameter_value ${gui_desired_outclk_duty_cycle}_$i]	
		}
		default {
			error "BAD PARAMETER NAME"
		}
	} 
	
	set c_cnt_array($index) [list -type c -index $i -freq $current_freq -phase $current_phase -is_degrees $current_ps_unit_is_degrees -duty $current_duty]	
	return [array get c_cnt_array]
}

proc ::altera_iopll_common::iopll::get_output_counter_freq_dropdown_list {validated_c_cnts desired_c_cnt} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle

	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         
   
	set family [get_parameter_value $mapped_sys_info_device_family]
	set speedgrade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set refclk_freq [compute_refclk_frequency]
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set is_counter_cascading_enabled false
	set x 32
	set is_fractional false
	set freq_value 0
	
	regexp {([-0-9.]+)} $refclk_freq freq_value
	  			
	set ref_list [list 	-family $family \
						-speedgrade $speedgrade \
						-refclk_freq $freq_value \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-x $x \
						-validated_counter_values $validated_c_cnts \
						-desired_counter_values $desired_c_cnt]
	
	array set des_c_cnt [lindex $desired_c_cnt 1]
	if {$des_c_cnt(-freq) <= 0} {
		iopll_send_message ERROR "Please enter positive output counter frequencies"
		return TCL_ERROR
	}
	
	if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list $ref_list} result]} {
		iopll_send_message ERROR "$result"
		iopll_send_message ERROR "Please enter valid output counter frequencies"
		return TCL_ERROR
	}

	return $result
}

proc ::altera_iopll_common::iopll::get_output_counter_phase_dropdown_list {validated_c_cnts desired_c_cnt} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle

	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         

	set family [get_parameter_value $mapped_sys_info_device_family]
	set speedgrade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set refclk_freq [compute_refclk_frequency]
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set is_counter_cascading_enabled false
	set x 32
	set is_fractional false
	set freq_value 0
	
	regexp {([-0-9.]+)} $refclk_freq freq_value
	
	set ref_list [list 	-family $family \
						-speedgrade $speedgrade \
						-refclk_freq $freq_value \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-x $x \
						-validated_counter_values $validated_c_cnts \
						-desired_counter_values $desired_c_cnt]
						
	if {[catch {::quartus::pll::legality::retrieve_output_clock_phase_list $ref_list} result]} {
		iopll_send_message ERROR "$result"
		iopll_send_message ERROR "Please enter valid output counter phase shifts"
		return TCL_ERROR
	}	

	return $result
}

proc ::altera_iopll_common::iopll::get_output_counter_duty_dropdown_list {validated_c_cnts desired_c_cnt} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle

	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         

	set family [get_parameter_value $mapped_sys_info_device_family]
	set speedgrade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set refclk_freq [compute_refclk_frequency]
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set is_counter_cascading_enabled false
	set x 32
	set is_fractional false
	set freq_value 0
	
	regexp {([-0-9.]+)} $refclk_freq freq_value
	
	set ref_list [list 	-family $family \
						-speedgrade $speedgrade \
						-refclk_freq $freq_value \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-x $x \
						-validated_counter_values $validated_c_cnts \
						-desired_counter_values $desired_c_cnt]
									
	if {[catch {::quartus::pll::legality::retrieve_output_clock_duty_list $ref_list} result]} {
		iopll_send_message ERROR "Please enter valid output counter duty cycles"
		return TCL_ERROR
	}

	return $result
}

proc ::altera_iopll_common::iopll::get_output_counter_freq_dropdown_list_for_vco {validated_c_cnts desired_c_cnt} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle

	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         

	set family [get_parameter_value $mapped_sys_info_device_family]
	set speedgrade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set refclk_freq [get_refclk_freq_int]
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set is_counter_cascading_enabled false
	set x 32
	set is_fractional false
	set freq_value 0
	
	regexp {([-0-9.]+)} $refclk_freq freq_value

	set ref_list [list 	-family $family \
					-speedgrade $speedgrade \
					-refclk_freq $freq_value \
					-is_fractional $is_fractional \
					-compensation_mode $compensation_mode \
					-is_counter_cascading_enabled $is_counter_cascading_enabled \
					-x $x \
					-validated_counter_values $validated_c_cnts \
					-desired_counter_values $desired_c_cnt]
	
	array set des_c_cnt [lindex $desired_c_cnt 1]
	if {$des_c_cnt(-freq) <= 0} {
		pll_send_message ERROR "Please enter positive output counter frequencies"
		return TCL_ERROR
	}
	pll_send_message DEBUG "---retrieve_output_clock_frequency_list:\ $ref_list"
	if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list $ref_list} result]} {
		pll_send_message ERROR "$result"
		pll_send_message ERROR "Failed to validate fixed VCO frequency"
		return TCL_ERROR
	} 
		
	array set result_array $result
	set closest_freq $result_array(closest_freq)
	set_parameter_value $mapped_vco_frequency "$closest_freq MHz"

		
	pll_send_message DEBUG "---\n result:$result\n---"
	return TCL_OK
}

proc ::altera_iopll_common::iopll::update_hp_actual_values {} {
	variable pll_maximum_number_of_reserved_clocks
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	#Step 1: update all the hp parameters if required
	set num_clocks [expr {[get_parameter_value $gui_number_of_pll_output_clocks] + $pll_maximum_number_of_reserved_clocks}]
    
	for {set i 0} {$i < $num_clocks} {incr i} {
		
		#freq
		set user_selected_gui_value [get_parameter_value ${gui_actual_outclk_frequency}_$i]
		if { $user_selected_gui_value == "N/A" } {
			# this particular output clock is not used in the PLL so set it to the VCO
			set user_selected_gui_value [get_vco_freq_int]
		}
		set hp_range_list [get_parameter_property ${hp_actual_outclk_frequency}_$i ALLOWED_RANGES]
		set index [search_mapped_range ${gui_actual_outclk_frequency}_$i $user_selected_gui_value]
		set hp_corresponding_value [lindex $hp_range_list $index]
		set_parameter_value ${hp_actual_outclk_frequency}_$i $hp_corresponding_value
        set desired [get_parameter_value ${gui_desired_outclk_frequency}_$i]
        
		#phase
		set gui_ps_unit [get_parameter_value ${gui_outclk_phase_shift_unit}_$i]
		if {$gui_ps_unit == 0} {
			set user_selected_gui_value [get_parameter_value ${gui_outclk_actual_phase_shift_ps}_$i]
		} else {
			set user_selected_gui_value [get_parameter_value ${gui_outclk_actual_phase_shift_deg}_$i]	
		}	
		set hp_range_list [get_parameter_property ${hp_outclk_actual_phase_shift}_$i ALLOWED_RANGES]		
		if {$gui_ps_unit == 0} {
			set index [search_mapped_range ${gui_outclk_actual_phase_shift_ps}_$i $user_selected_gui_value]
		} else {
			set index [search_mapped_range ${gui_outclk_actual_phase_shift_deg}_$i $user_selected_gui_value]		
		}	
		set hp_corresponding_value [lindex $hp_range_list $index]
		set_parameter_value ${hp_outclk_actual_phase_shift}_$i $hp_corresponding_value
        set desired [get_parameter_value ${gui_outclk_desired_phase_shift}_$i]
        
		#duty
		set user_selected_gui_value [get_parameter_value ${gui_actual_outclk_duty_cycle}_$i]		
		set hp_range_list [get_parameter_property ${hp_actual_outclk_duty_cycle}_$i ALLOWED_RANGES]
		set index [search_mapped_range ${gui_actual_outclk_duty_cycle}_$i $user_selected_gui_value]		
		set hp_corresponding_value [lindex $hp_range_list $index]
		set_parameter_value ${hp_actual_outclk_duty_cycle}_$i $hp_corresponding_value	
        set desired [get_parameter_value ${gui_desired_outclk_duty_cycle}_$i]
  
	}
}

proc ::altera_iopll_common::iopll::determine_new_hp_value {existing_range existing_value new_range new_closest_value new_gui_range} {
	if {[llength $existing_range] == 0} {
		#CASE 1: STARTUP
		#this means that we've never updated anything before... 
		#get the closest value to our desired value in the new list
		set index [lsearch $new_gui_range $existing_value]
		if {$index == -1} {
			set new_value $new_closest_value
		} else {
			set new_value $existing_value
		}
	} elseif {![altera_iopll::util::are_actual_ranges_equal $new_range $existing_range]} {
		#CASE 2: New range != old range -> we need to select the closest-to-desired value
		#then we want to select the closest
		set new_value $new_closest_value
	} elseif { $existing_value == "" } {
		set new_value $new_closest_value
	} else {
		#CASE 3: New range == old range -> user clicked something in this box or below it
		#so keep the current value if it exists in the new range
		#set index [lsearch $existing_range $new_closest_value]
		set new_value $existing_value
	}	
	return $new_value
}

proc ::altera_iopll_common::iopll::set_physical_parameter_values {{is_package_use_for_lvds "false"}} {
	variable pll_maximum_number_of_reserved_clocks
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	variable mapped_sys_info_device_family    
	variable mapped_sys_info_device           
	variable mapped_sys_info_device_speedgrade
	variable mapped_reference_clock_frequency 
	variable mapped_vco_frequency             
	variable mapped_external_pll_mode         

	variable pll_input_clock_frequency
	variable pll_vco_clock_frequency
	variable m_cnt_hi_div
	variable m_cnt_lo_div
	variable n_cnt_hi_div
	variable n_cnt_lo_div
	variable m_cnt_bypass_en
	variable n_cnt_bypass_en
	variable m_cnt_odd_div_duty_en
	variable n_cnt_odd_div_duty_en
	variable pll_cp_setting
	variable pll_bw_ctrl
	variable c_cnt_hi_div
	variable c_cnt_lo_div
	variable c_cnt_prst
	variable c_cnt_ph_mux_prst
	variable c_cnt_bypass_en
	variable c_cnt_odd_div_duty_en
	variable pll_output_clock_frequency_
	variable pll_output_phase_shift_
	variable pll_output_duty_cycle_
	variable pll_clk_out_en_
	variable pll_fbclk_mux_1
	variable pll_fbclk_mux_2
	variable pll_m_cnt_in_src
	variable pll_bw_sel      
   
	set device_family [get_parameter_value $mapped_sys_info_device_family]
	set speed_grade [get_parameter_value $mapped_sys_info_device_speedgrade]
	set vco_freq [get_vco_freq_int]
	set compensation_mode [get_parameter_value $gui_compensation_mode]
	set is_counter_cascading_enabled false
	set x 32
	set is_fractional false
	set bw_preset "High"
	array set c_counters_desired_settings {}
	array set dont_recalculate_me_freq {}
	array set dont_recalculate_me_phase {}
	array set dont_recalculate_me_duty {}
	set usr_num_clocks [expr {[get_parameter_value $gui_number_of_pll_output_clocks] + $pll_maximum_number_of_reserved_clocks}]
	set n 1
	set k 1
	set is_fractional false
	set usr_enabled_counter_cascading false
		
	if { $is_package_use_for_lvds == "false" } {
		set refclk_freq [compute_refclk_frequency]
		set refclk_value 0
		regexp {([-0-9.]+)} $refclk_freq refclk_value
		set m [expr { int(round($vco_freq / $refclk_value)) }]
		set usr_enabled_adv_params true
	} else {
		set refclk_value [get_refclk_freq_int]
		set m 1
		set usr_enabled_adv_params false
	}
	array set c_counters_desired_settings [make_validated_c_counter_array duty $usr_num_clocks $usr_enabled_adv_params]
	
	if { [catch {get_physical_parameters_for_generation \
				-using_adv_mode $usr_enabled_adv_params \
				-device_family $device_family \
				-device_speedgrade $speed_grade \
				-compensation_mode $compensation_mode \
				-refclk_freq $refclk_value \
				-is_fractional $is_fractional \
				-x $x \
				-m $m \
				-n $n \
				-k $k \
				-bw_preset $bw_preset \
				-is_counter_cascading_enabled $usr_enabled_counter_cascading \
				-validated_counter_settings [array get c_counters_desired_settings]} \
		result] } {
		iopll_send_message ERROR "$result"
		#pll_send_message DEBUG "Failed in get_physical_parameters_for_generation"
		return TCL_ERROR
	}

	#pll_send_message DEBUG "---" 
	#pll_send_message DEBUG "mnc settings result: $result"
	array set result_array $result
	
	#- -----now set values based on output parameters
	
	if {$result_array(vco_freq) == 0.0} {
		iopll_send_message ERROR "Unable to implement physical PLL settings based on specified VCO frequency of $vco_freq MHz and reference clock frequency of $refclk_value MHz"
	} else {
		# VCO & refclk
		set vco_value_ps [expr {int(1000000.0 / $result_array(vco_freq))}]
		if { $is_package_use_for_lvds == "false" } {
		if {[expr {$vco_value_ps % 2}] != 0} {
		   incr vco_value_ps
		}
		   
		set_parameter_value $pll_vco_clock_frequency "$vco_value_ps ps"
		set refclk_value_ps [expr {$vco_value_ps * $m}]
		set_parameter_value $pll_input_clock_frequency "$refclk_value_ps ps"
		} else {
			set refclk_value_mhz [get_refclk_freq_int]
			set_parameter_value $pll_vco_clock_frequency "$vco_freq MHz"
			set_parameter_value $pll_input_clock_frequency "$refclk_value_mhz MHz"
		}
		
		# bw 
		set_parameter_value $pll_bw_ctrl $result_array(bw)
		
		# cp
		set_parameter_value $pll_cp_setting $result_array(cp)
		
		# vco
		#set_parameter_value pll_output_clk_frequency "[round_to_atom_precision $result_array(vco_freq)] MHz"
		
		# m values
		array set m_array $result_array(m)
		set_parameter_value $m_cnt_hi_div $m_array(m_high)
		set_parameter_value $m_cnt_lo_div $m_array(m_low)
		if { $m_array(m_bypass_en) == 0 } {
			set_parameter_value $m_cnt_bypass_en "false"
		} else {
			set_parameter_value $m_cnt_bypass_en "true"
		}
		if { $m_array(m_tweak) == 0 } {
			set_parameter_value $m_cnt_odd_div_duty_en "false"
		} else {
			set_parameter_value $m_cnt_odd_div_duty_en "true"
		}
		
		# n values
		array set n_array $result_array(n)
		set_parameter_value $n_cnt_hi_div $n_array(n_high)
		set_parameter_value $n_cnt_lo_div $n_array(n_low)
		if { $n_array(n_bypass_en) == 0 } {
			set_parameter_value $n_cnt_bypass_en "false"
		} else {
			set_parameter_value $n_cnt_bypass_en "true"
		}
		if { $n_array(n_tweak) == 0 } {
			set_parameter_value $n_cnt_odd_div_duty_en "false"
		} else {
			set_parameter_value $n_cnt_odd_div_duty_en "true"
		}

	#	# c values
		array set c_array $result_array(c)
		foreach {c_index_raw c_param_list} [array get c_array] {
			if {$c_index_raw == 0 && $usr_enabled_adv_params == false } {
			} else {
				set c_index $c_index_raw		
				if {$usr_enabled_adv_params == false} {
					incr c_index -1
				}
				array set c_cnt_array $c_param_list
				
				set current_freq [get_parameter_value ${gui_actual_outclk_frequency}_$c_index] 
				if { $current_freq == "N/A" } {
					set_parameter_value ${c_cnt_hi_div}${c_index} 256
					set_parameter_value ${c_cnt_lo_div}${c_index} 256
					set_parameter_value ${c_cnt_prst}${c_index} 1
					set_parameter_value ${c_cnt_ph_mux_prst}${c_index} 0
					set_parameter_value ${c_cnt_bypass_en}${c_index} "true"
					set_parameter_value ${c_cnt_odd_div_duty_en}${c_index} "false"
				} else {
					set_parameter_value ${c_cnt_hi_div}${c_index} $c_cnt_array(c_high)
					set_parameter_value ${c_cnt_lo_div}${c_index} $c_cnt_array(c_low)
					set_parameter_value ${c_cnt_prst}${c_index} $c_cnt_array(c_prst)
					set_parameter_value ${c_cnt_ph_mux_prst}${c_index} $c_cnt_array(c_ph_mux_tap)
					if { $c_cnt_array(c_bypass_en) == 0 } {
						set_parameter_value ${c_cnt_bypass_en}${c_index} "false"
					} else {
						set_parameter_value ${c_cnt_bypass_en}${c_index} "true"
					}
					if { $c_cnt_array(c_tweak) == 0 } {
						set_parameter_value ${c_cnt_odd_div_duty_en}${c_index} "false"
					} else {
						set_parameter_value ${c_cnt_odd_div_duty_en}${c_index} "true"
					}
				}
			}
		}

		# c values (virtual)
		array set c_array $result_array(c)
		foreach {c_index_raw c_param_list} [array get c_array] {
			if {$c_index_raw == 0 && $usr_enabled_adv_params == false} {
			} else {
				set c_index $c_index_raw		
				if {$usr_enabled_adv_params == false} {
					incr c_index -1
				}
				array set c_cnt_array $c_param_list
				
				set current_freq [get_parameter_value ${gui_actual_outclk_frequency}_$c_index] 
				if { $current_freq == "N/A" } {
					set_parameter_value ${pll_output_clock_frequency_}$c_index "0.0 MHz"
					set_parameter_value ${pll_output_phase_shift_}$c_index "0 ps"
					set_parameter_value ${pll_output_duty_cycle_}$c_index 	"50"
					set_parameter_value ${pll_clk_out_en_}$c_index "false"
				} else {
					if {$c_cnt_array(freq) == 0} {
						set_parameter_value ${pll_output_clock_frequency_}$c_index "0.0 MHz"
						set_parameter_value ${pll_clk_out_en_}$c_index "false"
					} else {
						set counter_high_value $c_cnt_array(c_high)
						set counter_low_value  $c_cnt_array(c_low)
						set counter_value      [expr {$counter_high_value + $counter_low_value}]
						set counter_bypss      [expr {$c_cnt_array(c_bypass_en) == 0 ? "false" : "true"}]
						if { $is_package_use_for_lvds == "false" } {
							if { $counter_bypss == "true" } {
								set outclk_freq_value_ps [expr {$vco_value_ps * 1}]
							} else {
								set outclk_freq_value_ps [expr {$vco_value_ps * $counter_value}]
							}
							set_parameter_value ${pll_output_clock_frequency_}$c_index "$outclk_freq_value_ps ps"
						} else {
                            set rounded_outclk_freq [round_freq $c_cnt_array(freq)]
							set_parameter_value ${pll_output_clock_frequency_}$c_index "$rounded_outclk_freq MHz"
						}
						set_parameter_value ${pll_clk_out_en_}$c_index "true"
					}
                    
					if { $is_package_use_for_lvds == "false" } {
						set_parameter_value ${pll_output_phase_shift_}$c_index "[::altera_iopll::util::round_to_n_decimals $c_cnt_array(phase) 0] ps"
					} else {
						set rounded_phase_int [expr {int($c_cnt_array(phase) / 1.0)}]
						set_parameter_value ${pll_output_phase_shift_}$c_index "$rounded_phase_int ps"
					}
					set_parameter_value ${pll_output_duty_cycle_}$c_index 	"[::altera_iopll::util::round_to_n_decimals $c_cnt_array(duty) 0]"
				}
			}
		}
		
		# feedback parameters
		set_feedback_params
	}
}

proc ::altera_iopll_common::iopll::set_feedback_params {} {
	variable gui_enable_advanced_mode
	variable gui_compensation_mode
	variable gui_number_of_pll_output_clocks
	variable gui_desired_outclk_frequency
	variable gui_actual_outclk_frequency
	variable hp_actual_outclk_frequency
	variable gui_outclk_phase_shift_unit
	variable gui_outclk_desired_phase_shift
	variable gui_outclk_actual_phase_shift_ps
	variable gui_outclk_actual_phase_shift_deg
	variable hp_outclk_actual_phase_shift
	variable gui_desired_outclk_duty_cycle
	variable gui_actual_outclk_duty_cycle
	variable hp_actual_outclk_duty_cycle
   
	variable pll_input_clock_frequency
	variable pll_vco_clock_frequency
	variable m_cnt_hi_div
	variable m_cnt_lo_div
	variable n_cnt_hi_div
	variable n_cnt_lo_div
	variable m_cnt_bypass_en
	variable n_cnt_bypass_en
	variable m_cnt_odd_div_duty_en
	variable n_cnt_odd_div_duty_en
	variable pll_cp_setting
	variable pll_bw_ctrl
	variable c_cnt_hi_div
	variable c_cnt_lo_div
	variable c_cnt_prst
	variable c_cnt_ph_mux_prst
	variable c_cnt_bypass_en
	variable c_cnt_odd_div_duty_en
	variable pll_output_clock_frequency_
	variable pll_output_phase_shift_
	variable pll_output_duty_cycle_
	variable pll_clk_out_en_
	variable pll_fbclk_mux_1
	variable pll_fbclk_mux_2
	variable pll_m_cnt_in_src
	variable pll_bw_sel   

	#INPUTS
	set pll_compensation_mode [get_parameter_value $gui_compensation_mode]
	switch $pll_compensation_mode {
		"direct" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_glb"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_m_cnt"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"
		}
        "emif" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_glb"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_m_cnt"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"
		}
		"normal" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_glb"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"		
		}
		"source synchronous" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_glb"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"		
		}
		"zero delay buffer" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_zbd"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"		
		}
		"external feedback" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_zbd"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"	
		}
		"lvds" {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_lvds"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"
		}
		default {
			set_parameter_value $pll_fbclk_mux_1 "pll_fbclk_mux_1_glb"
			set_parameter_value $pll_fbclk_mux_2 "pll_fbclk_mux_2_fb_1"
			set_parameter_value $pll_m_cnt_in_src "c_m_cnt_in_src_ph_mux_clk"	
		}
	}		
}

proc ::altera_iopll_common::iopll::compute_refclk_frequency {} {
	set refclk_freq [get_refclk_freq_int]
	set vco_freq [get_vco_freq_int]
	set m_counter [expr { int(round($vco_freq / $refclk_freq)) }]
	
	# recompute refclk freq with more precision
	set refclk_freq [expr {$vco_freq / $m_counter}]
	
	return $refclk_freq
}

proc ::altera_iopll_common::iopll::get_refclk_freq_int {} {
	variable mapped_reference_clock_frequency
	set refclk_freq [get_parameter_value $mapped_reference_clock_frequency]
	set refclk_freq_int 0
	regexp {([-0-9.]+)} $refclk_freq refclk_freq_int
	
	return $refclk_freq_int
}

proc ::altera_iopll_common::iopll::get_vco_freq_int {} {
	variable mapped_vco_frequency
	set vco_freq [get_parameter_value $mapped_vco_frequency]
	set vco_freq_int 0
	regexp {([-0-9.]+)} $vco_freq vco_freq_int
	
	return $vco_freq_int
}

proc iopll_send_message {type message} {
	send_message $type $message
}

proc pll_send_message {type message} {
}

proc ::altera_iopll_common::iopll::add_if {\
   name \
   type \
   qsys_dir \
   dir \
   {width 0} \
   {term "none"}
} {
   variable use_port_name_as_role_name

   set if_name "${name}_${type}_${qsys_dir}"

   add_interface $if_name $type $qsys_dir
   set_interface_property $if_name ENABLED false 
   
   set_interface_assignment $if_name "ui.blockdiagram.direction" $dir

   # If width was set to default, set to 1, and assume STD_LOGIC
   # If width was overridden (even if set to 1), set to STD_LOGIC_VECTOR
   if { $width == 0 } {
         set width 1
		 set port_vhdl_type STD_LOGIC
   } else {
         set port_vhdl_type STD_LOGIC_VECTOR
   }
   
   if { $type == "clock" } {
        add_interface_port $if_name $name clk $dir $width
   } else {
        set role_name [expr {$use_port_name_as_role_name ? $name : "export"}]
        add_interface_port $if_name $name $role_name $dir $width
   }

   set_port_property $name VHDL_TYPE $port_vhdl_type

   if { [string_compare $term "none"] == 0 } {
        set_port_property $name TERMINATION true
        set_port_property $name TERMINATION_VALUE $term
   }     
}

proc ::altera_iopll_common::iopll::string_compare {string_1 string_2} {
    return [expr {[string compare -nocase $string_1 $string_2] == 0}] 
}

