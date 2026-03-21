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


## \file mcgb.tcl
# lists all the parameters used in Master CGB, as well as associated validation callbacks

package provide mcgb_package_s10::mcgb 18.1

## \todo review below
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require ct1_hssi_pma_cgb_master::parameters


namespace eval ::mcgb_package_s10::mcgb:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::messages::*

   namespace export \
      set_mcgb_display_item_properties \
      declare_mcgb_display_items \
      set_protocol_mode_maps_from \
      set_silicon_rev_maps_from \
      set_output_clock_frequency_maps_from \
      set_primary_pll_buffer_maps_from \
      set_hip_cal_done_enable_maps_from \
      declare_mcgb_parameters \
      declare_mcgb_interfaces \

   variable mcgb_display_items
 
   variable mcgb_parameters
   variable mapped_parameters
   variable pll_parameters_used_in_mcgb_validation_callbacks
   variable mcgb_atom_parameters
   variable mcgb_parameters_to_be_removed

   variable mcgb_interfaces

   set mcgb_display_items {\
      {NAME                             GROUP                              ENABLED             VISIBLE   TYPE   ARGS  }\
      {"Master Clock Generation Block"  ""                                 NOVAL               NOVAL     GROUP  TAB   }\
      {"MCGB"                           "Master Clock Generation Block"    NOVAL               NOVAL     GROUP  NOVAL }\
      {"Bonding"                        "Master Clock Generation Block"    NOVAL               NOVAL     GROUP  NOVAL }\
   }

   set mcgb_parameters {\
      {NAME                                      M_CONTEXT M_USED_FOR_RCFG M_SAME_FOR_RCFG DERIVED HDL_PARAMETER TYPE      DEFAULT_VALUE         ENABLED                                VISIBLE DISPLAY_HINT DISPLAY_UNITS DISPLAY_ITEM  DISPLAY_NAME                                            ALLOWED_RANGES                                         VALIDATION_CALLBACK                                           DESCRIPTION }\
      {enable_mcgb                               NOVAL     1               1               false   true          INTEGER   0                     true                                   true    BOOLEAN      NOVAL         "MCGB"        "Include Master Clock Generation Block"                 NOVAL                                                  ::mcgb_package_s10::mcgb::validate_enable_mcgb                 "When enabled Master CGB will be included as part of the IP. PLL output will feed the Master CGB input."}\
      {mcgb_div                                  NOVAL     1               1               false   false         INTEGER   1                     enable_mcgb                            true    NOVAL        NOVAL         "MCGB"        "Clock division factor"                                 { 1 2 4 8 }                                            NOVAL                                                         "Divides the Master CGB clock input before generating bonding clocks."}\
      {mcgb_div_fnl                              NOVAL     0               0               true    false         INTEGER   1                     true                                   false   NOVAL        NOVAL         NOVAL         NOVAL                                                   { 1 2 4 8 }                                            ::mcgb_package_s10::mcgb::convert_mcgb_div                     NOVAL }\
      {enable_hfreq_clk                          NOVAL     1               1               false   false         INTEGER   0                     enable_mcgb                            true    BOOLEAN      NOVAL         "MCGB"        "Enable x6/xN non-bonded high-speed clock output port"  NOVAL                                                  NOVAL                                                         "This output port can be used to access x6/xN clock lines for non-bonded designs"}\
      {enable_mcgb_pcie_clksw                    NOVAL     1               1               false   false         INTEGER   0                     enable_mcgb                            true    BOOLEAN      NOVAL         "MCGB"        "Enable PCIe clock switch interface"                    NOVAL                                                  ::mcgb_package_s10::mcgb::validate_enable_mcgb_pcie_clksw      "Enables the control signals for PCIe clock switch circuitry"}\
      {mcgb_aux_clkin_cnt                        NOVAL     1               1               false   false         INTEGER   0                     enable_mcgb                            true    NOVAL        NOVAL         "MCGB"        "Number of auxiliary MCGB clock input ports."            { 0 1 }                                               ::mcgb_package_s10::mcgb::update_mcgb_aux_clkin_cnt            "Auxiliary input is intended for PCIe Gen3, hence not available in FPLL"}\
      {mcgb_in_clk_freq                          NOVAL     0               0               true    false         FLOAT     0                     true                                   true    NOVAL        MHz           "MCGB"        "MCGB input clock frequency"                            NOVAL                                                  ::mcgb_package_s10::mcgb::update_mcgb_in_clk_freq              "This parameter is not settable by user."}\
      {mcgb_out_datarate                         NOVAL     0               0               true    false         FLOAT     2500.000000           true                 					        true    NOVAL        Mbps          "MCGB"        "MCGB output data rate"                                 NOVAL                                                  ::mcgb_package_s10::mcgb::update_mcgb_out_datarate             "This parameter is not settable by user. The value is calculated based on \"MCGB input clock frequency\" and \"Master CGB clock division factor\""}\
      {enable_bonding_clks                       NOVAL     1               1               false   false         INTEGER   0                     enable_mcgb           					        true    BOOLEAN      NOVAL         "Bonding"     "Enable bonding clock output ports"                     NOVAL                                                  NOVAL                                                         "Should be enable for bonded designs"}\
      {enable_fb_comp_bonding                    NOVAL     1               1               false   false         INTEGER   0                     "enable_mcgb && enable_bonding_clks"   true    BOOLEAN      NOVAL         "Bonding"     "Enable feedback compensation bonding"                  NOVAL                                                  ::mcgb_package_s10::mcgb::validate_enable_fb_comp_bonding      "NOVAL"}\
      {mcgb_enable_iqtxrxclk                     NOVAL     0               0               true    false         STRING    "disable_iqtxrxclk"   "enable_mcgb && enable_bonding_clks"   false   NOVAL        NOVAL         NOVAL         NOVAL                                                   { "disable_iqtxrxclk" "enable_iqtxrxclk"}              ::mcgb_package_s10::mcgb::convert_enable_fb_comp_bonding       "NOVAL"}\
      {pma_width                                 NOVAL     1               1               false   false         INTEGER   64                    "enable_mcgb && enable_bonding_clks"   true    NOVAL        NOVAL         "Bonding"     "PMA interface width"                                   { 8 10 16 20 32 40 64 }                                NOVAL                                                         "PMA-PCS Interface width. Proper value must be selected for bonding clocks to be generated properly for Native PHY IP."}\
      {enable_mcgb_debug_ports_parameters        NOVAL     0               0               true    true          INTEGER   0                     false                                  false   NOVAL        NOVAL         NOVAL         NOVAL                                                   { 0 1 }                                                NOVAL                                                         NOVAL}\
      {enable_pld_mcgb_cal_busy_port             NOVAL     1               1               false   false         INTEGER   0                     false                                  false   BOOLEAN      NOVAL         NOVAL         NOVAL                                                   { 0 1 }                                                NOVAL                                                         NOVAL}\
      {check_output_ports_mcgb                   NOVAL     0               0               true    false         INTEGER   0                     false                                  false   NOVAL        NOVAL         NOVAL         NOVAL                                                   NOVAL                                                  ::mcgb_package_s10::mcgb::validate_check_output_ports_mcgb     NOVAL}\
   }

   # IMPORTANT NOTE: M_MAPS_FROM should be updated with external calls
   set pll_parameters_used_in_mcgb_validation_callbacks {\
      { NAME                            TYPE       DERIVED   M_MAPS_FROM     M_MAP_VALUES VISIBLE DEFAULT_VALUE}\
      { mapped_output_clock_frequency   STRING     true      NOVAL           NOVAL        false   NOVAL}\
      { mapped_primary_pll_buffer       STRING     true      NOVAL           NOVAL        false   "N/A"}\
      { mapped_hip_cal_done_port        INTEGER    true      NOVAL           NOVAL        false   NOVAL}\
   }

   set mapped_parameters {\
      { NAME                     TYPE       DERIVED   M_MAPS_FROM                  ALLOWED_RANGES   VISIBLE   M_MAP_VALUES                         }\
      { is_protocol_PCIe         INTEGER    true      hssi_pma_cgb_master_prot_mode     {0 1 }           false     {"basic_tx:0" "pcie_gen1_tx:1" "pcie_gen2_tx:1" "pcie_gen3_tx:1"}   }\
  }

## \note: hssi_pma_cgb_master_cgb_enable_iqtxrxclk is used in ATX PLL validations
# eventually fpll might need to the same
   set mcgb_atom_parameters {\
      { NAME                                        M_RCFG_REPORT                                          TYPE       DERIVED   M_MAPS_FROM                     HDL_PARAMETER   ENABLED   VISIBLE VALIDATION_CALLBACK                                 M_MAP_VALUES }\
      { hssi_pma_cgb_master_prot_mode               "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      NOVAL                           true            false     false   NOVAL                                               NOVAL }\
      { hssi_pma_cgb_master_silicon_rev             "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      NOVAL                           true            false     false   NOVAL                                               NOVAL }\
      { hssi_pma_cgb_master_x1_div_m_sel            "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      mcgb_div_fnl                    true            false     false   NOVAL                                               {"1:divbypass" "2:divby2" "4:divby4" "8:divby8"} }\
      { hssi_pma_cgb_master_cgb_enable_iqtxrxclk    "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      mcgb_enable_iqtxrxclk           true            false     false   NOVAL                                               NOVAL }\
      { hssi_pma_cgb_master_ser_mode                "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      NOVAL                           true            false     false   ::mcgb_package_s10::mcgb::convert_mcgb_ser_mode     NOVAL }\
      { hssi_pma_cgb_master_datarate_bps            "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      mcgb_out_datarate               true            false     false   ::mcgb_package_s10::mcgb::mega_to_base              NOVAL }\
   }

# IMPORTANT NOTES
# 1) hssi_hssi_pma_cgb_master_cgb_power_down       default in atom is power_down_cgb, but normal_cgb is used as default in IP and wrappers
# 2) hssi_hssi_pma_cgb_master_input_select         default in atom is unused,         but lcpll_top  is used as default in IP and wrappers

#-----------------------------------------------------------------------------------------
# The following changes are for PLL sharing for PCIe mode
# Changes found in 
# hssi_pma_cgb_master_input_select      - the default value is changed to "fpll_top" from "lcpll_top"
# hssi_pma_cgb_master_input_select_gen3 - the default value remains "unused"
# The physical connections in the FPLL IP has been changed to reflect this 
#-----------------------------------------------------------------------------------------
   set mcgb_parameters_to_be_removed {\
      { NAME                                                M_RCFG_REPORT                                          TYPE       DERIVED   HDL_PARAMETER   ENABLED   VISIBLE   DEFAULT_VALUE                VALIDATION_CALLBACK }\
      { hssi_pma_cgb_master_cgb_power_down                  "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "normal_cgb"                 ::mcgb_package_s10::mcgb::set_to_default }\
      { hssi_pma_cgb_master_observe_cgb_clocks              "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "observe_nothing"            ::mcgb_package_s10::mcgb::set_to_default }\
      { hssi_pma_cgb_master_tx_ucontrol_reset_pcie          "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "pcscorehip_controls_mcgb"   ::mcgb_package_s10::mcgb::set_to_default }\
      { hssi_pma_cgb_master_vccdreg_output                  "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "vccdreg_nominal"            ::mcgb_package_s10::mcgb::set_to_default }\
      { hssi_pma_cgb_master_input_select                    "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "fpll_top"                  ::mcgb_package_s10::mcgb::validate_input_select }\
      { hssi_pma_cgb_master_input_select_gen3               "enable_mcgb && enable_mcgb_debug_ports_parameters"    STRING     true      true            false     false     "unused"                     ::mcgb_package_s10::mcgb::validate_input_select_gen3 }\
   }

   set mcgb_interfaces {\
      {NAME                  DIRECTION  UI_DIRECTION  WIDTH_EXPR         ROLE              TERMINATION_VALUE  IFACE_NAME         IFACE_TYPE         IFACE_DIRECTION  TERMINATION                                                                                                        ELABORATION_CALLBACK }\
      {mcgb_rst               input     input         1                  mcgb_rst          NOVAL              mcgb_rst           conduit            end              "!enable_mcgb || (enable_mcgb && !enable_analog_resets && !in_pcie_hip_mode)"                                      NOVAL                }\
      {mcgb_aux_clk0          input     input         1                  tx_serial_clk     NOVAL              mcgb_aux_clk0      conduit            end              "!enable_mcgb || (mcgb_aux_clkin_cnt<1)"                                                                           NOVAL                }\
      {mcgb_aux_clk1          input     input         1                  tx_serial_clk     NOVAL              mcgb_aux_clk1      conduit            end              "!enable_mcgb || (mcgb_aux_clkin_cnt<2)"                                                                           NOVAL                }\
      {mcgb_aux_clk2          input     input         1                  tx_serial_clk     NOVAL              mcgb_aux_clk2      conduit            end              "!enable_mcgb || (mcgb_aux_clkin_cnt<3)"                                                                           NOVAL                }\
      {tx_bonding_clocks      output    output        6                  clk               NOVAL              tx_bonding_clocks  hssi_bonded_clock  start            "!enable_mcgb || !enable_bonding_clks"                                                                             NOVAL                }\
      {mcgb_serial_clk        output    output        1                  clk               NOVAL              mcgb_serial_clk    hssi_serial_clock  start            "!enable_mcgb || !enable_hfreq_clk"                                                                                NOVAL                }\
      {pcie_sw                input     input         2                  pcie_sw           NOVAL              pcie_sw            conduit            end              "!enable_mcgb || !enable_mcgb_pcie_clksw"                                                                          NOVAL                }\
      {pcie_sw_done           output    output        2                  pcie_sw_done      NOVAL              pcie_sw_done       conduit            end              "!enable_mcgb || !enable_mcgb_pcie_clksw"                                                                          NOVAL                }\
      \
      {reconfig_clk1          input     input         1                  clk               NOVAL              reconfig_clk1      clock              sink             "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_reset1        input     input         1                  reset             NOVAL              reconfig_reset1    reset              sink             "!enable_mcgb_debug_ports_parameters"                                                                              ::mcgb_package_s10::mcgb::elaborate_reconfig_reset }\
      {reconfig_write1        input     input         1                  write             NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_read1         input     input         1                  read              NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_address1      input     input         11                 address           NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_writedata1    input     input         32                 writedata         NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_readdata1     output    output        32                 readdata          NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {reconfig_waitrequest1  output    output        1                  waitrequest       NOVAL              reconfig_avmm1     avalon             slave            "!enable_mcgb_debug_ports_parameters"                                                                              NOVAL                }\
      {mcgb_cal_busy          output    output        1                  mcgb_cal_busy     NOVAL              mcgb_cal_busy      conduit            end              "(!enable_mcgb_debug_ports_parameters) && (!enable_pld_mcgb_cal_busy_port)"                                        NOVAL                }\
      {mcgb_hip_cal_done      output    output        1                  hip_cal_done      NOVAL              mcgb_hip_cal_done  conduit            end              "!mapped_hip_cal_done_port"                                                                                        NOVAL                }\
   }

}

##################################################################################################################################################
# INTERNAL UTILITY FUNCTIONS
##################################################################################################################################################

proc ::mcgb_package_s10::mcgb::set_property_byParameterIndex { data propertyName propertyValue parameterIndex } {

   set headers [lindex $data 0]
   set propertyIndex [lsearch $headers $propertyName]
   if { $propertyIndex == -1 } {
      ip_message error "::mcgb_package_s10::mcgb::set_property_byParameterIndex:: property($propertyName) does not exist"
   }
   

   set length [llength $data]

   if { $length <= $parameterIndex || $parameterIndex < 1 } {
      ip_message error "::mcgb_package_s10::mcgb::set_property_byParameterIndex:: invalid parameter index($parameterIndex)"
   }

   set parameterProperties [lindex $data $parameterIndex]
   set parameterProperties [lreplace $parameterProperties $propertyIndex $propertyIndex $propertyValue]
   set data [lreplace $data $parameterIndex $parameterIndex $parameterProperties]
   return $data
}

proc ::mcgb_package_s10::mcgb::set_property_byParameterName  { data propertyName propertyValue parameterName } {
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
      ip_message error "::mcgb_package_s10::mcgb::set_property_byParameterName:: parameter($parameterName) does not exist"
   }

   return [set_property_byParameterIndex $data $propertyName $propertyValue $parameterIndex]
}

##################################################################################################################################################
# EXPORTED FUNCTIONS
##################################################################################################################################################
proc ::mcgb_package_s10::mcgb::set_output_clock_frequency_maps_from { mapsFrom } {
   variable pll_parameters_used_in_mcgb_validation_callbacks
   set pll_parameters_used_in_mcgb_validation_callbacks [set_property_byParameterName $pll_parameters_used_in_mcgb_validation_callbacks M_MAPS_FROM $mapsFrom mapped_output_clock_frequency]
}

proc ::mcgb_package_s10::mcgb::set_primary_pll_buffer_maps_from { mapsFrom } {
   variable pll_parameters_used_in_mcgb_validation_callbacks
   set pll_parameters_used_in_mcgb_validation_callbacks [set_property_byParameterName $pll_parameters_used_in_mcgb_validation_callbacks M_MAPS_FROM $mapsFrom mapped_primary_pll_buffer]
}

proc ::mcgb_package_s10::mcgb::set_hip_cal_done_enable_maps_from { mapsFrom } {
   variable pll_parameters_used_in_mcgb_validation_callbacks
   set pll_parameters_used_in_mcgb_validation_callbacks [set_property_byParameterName $pll_parameters_used_in_mcgb_validation_callbacks M_MAPS_FROM $mapsFrom mapped_hip_cal_done_port]
}

proc ::mcgb_package_s10::mcgb::set_protocol_mode_maps_from { mapsFrom } {
   variable mcgb_atom_parameters
   set mcgb_atom_parameters [set_property_byParameterName $mcgb_atom_parameters M_MAPS_FROM $mapsFrom hssi_pma_cgb_master_prot_mode]
}

proc ::mcgb_package_s10::mcgb::set_silicon_rev_maps_from { mapsFrom } {
   variable mcgb_atom_parameters
   set mcgb_atom_parameters [set_property_byParameterName $mcgb_atom_parameters M_MAPS_FROM $mapsFrom hssi_pma_cgb_master_silicon_rev]
}

proc ::mcgb_package_s10::mcgb::set_mcgb_display_item_properties { group_value args_value } {
   variable mcgb_display_items

   set mcgb_display_items [set_property_byParameterIndex $mcgb_display_items GROUP $group_value 1]
   set mcgb_display_items [set_property_byParameterIndex $mcgb_display_items ARGS $args_value 1]
}

proc ::mcgb_package_s10::mcgb::declare_mcgb_display_items {} {
   variable mcgb_display_items
   ip_declare_display_items $mcgb_display_items
}

proc ::mcgb_package_s10::mcgb::declare_mcgb_parameters {} {
   variable mcgb_parameters
   variable mapped_parameters
   variable pll_parameters_used_in_mcgb_validation_callbacks
   variable mcgb_atom_parameters
   variable mcgb_parameters_to_be_removed
   ip_declare_parameters $mcgb_parameters
   ip_declare_parameters $mapped_parameters
   ip_declare_parameters $pll_parameters_used_in_mcgb_validation_callbacks
   ip_declare_parameters $mcgb_atom_parameters
   ip_declare_parameters $mcgb_parameters_to_be_removed
}

proc ::mcgb_package_s10::mcgb::declare_mcgb_interfaces {} {
   variable mcgb_interfaces
   ip_declare_interfaces $mcgb_interfaces
}
##################################################################################################################################################
# functions: converting user parameters to their final form (appropriate for the hdl) 
##################################################################################################################################################

## \TODO some of these functions needs to be implemented as mapped parameters

proc ::mcgb_package_s10::mcgb::validate_check_output_ports_mcgb {enable_bonding_clks enable_hfreq_clk enable_mcgb} {
   if {$enable_mcgb} {
      if {!$enable_bonding_clks && !$enable_hfreq_clk } {
         set port_name1  [ip_get "parameter.enable_bonding_clks.display_name"]
         set port_name2  [ip_get "parameter.enable_hfreq_clk.display_name"]
         ip_message error "Enable at least one output port for Master CGB using checkbox \"$port_name1\" and/or \"$port_name2\". "
      }
   }
}

##
# The auxilary input for Master CGB are allowed when instantitated through the ATX and FPLL
# The FPLL is allowed because of the need to share PLLs in PCIe mode  
# 
# short summary: for Gen 3 designs we want ATX to instantiate M-CGB, fPLL should connect to aux input
proc ::mcgb_package_s10::mcgb::update_mcgb_aux_clkin_cnt { PROP_VALUE enable_mcgb_debug_ports_parameters } {
   if { $enable_mcgb_debug_ports_parameters==1 } {
      ip_set "parameter.mcgb_aux_clkin_cnt.ALLOWED_RANGES" {0 1 2 3}
   }
 }

##
# check enable_mcgb and enable_bonding_clks before propagating enable_fb_comp_bonding selection to atom parameters
proc ::mcgb_package_s10::mcgb::convert_enable_fb_comp_bonding { enable_mcgb enable_bonding_clks enable_fb_comp_bonding } {
   if {$enable_mcgb && $enable_bonding_clks && $enable_fb_comp_bonding} {
      ip_set "parameter.mcgb_enable_iqtxrxclk.value" "enable_iqtxrxclk"
   } else {
      ip_set "parameter.mcgb_enable_iqtxrxclk.value" "disable_iqtxrxclk"
   }
}

proc ::mcgb_package_s10::mcgb::elaborate_reconfig_reset { } {
  ip_set "interface.reconfig_reset1.associatedclock" reconfig_clk1
}

##
# NOTE: this is a dummy function, for parameters that will eventually be set through a validation_callback (but the functions are not ready yet).
# The parameters are listed in the IP anyways. This is to make sure that they will be part of reconfiguration files.
# However if enumerations for those values changes due to atom map changes, existing IP variant files need to be manually edited.
# This function will enable us to prevent that
proc ::mcgb_package_s10::mcgb::set_to_default { PROP_NAME } {
   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
   ip_set "parameter.${PROP_NAME}.value" $value
}

##
# There is a hard connection to lcpll_top input of the CGB from both fPLL and ATX PLL
# and for both PLLs input_select default is lcpll_top
# however for Gen 3, design we have the fpll connecting to aux0 of MasterCGB, which goes to fpll_top port of the Master CGB
# but we want Gen3 designs to start with Gen1-2 speeds hence the input port that fPLL is connected should be set as primary 
# \note master cgb instentiation at fpll IP is not allowed for gen 3 designs, hence only atx is of importance  
#
# ------------------------------
# Changes made with 
#  The hard connection from the FPLL core is now to the fpll_top input port of the mcgb
#  The hard connection from the ATX core is now to the lcpll_top input port of the mcgb
#  The input_select parameter default value has been changed to fpll_top
#  In the case of ATX PLL in gen1/2 (not gen 3), the input_select needs to be set to lcpll_top
#  In all other cases, the input_select needs to be set to fpll_top 
# ------------------------------

proc ::mcgb_package_s10::mcgb::validate_input_select { hssi_pma_cgb_master_prot_mode } {
   # if module name contains atx it is most likely atx not fpll
   if { [string first "atx" [ip_get "module.name"]] >=0 && $hssi_pma_cgb_master_prot_mode != "pcie_gen3_tx" } {
      ip_set "parameter.hssi_pma_cgb_master_input_select.value" "lcpll_top"
   } else {
      ip_set "parameter.hssi_pma_cgb_master_input_select.value" "fpll_top"
   }
}

##
# There is a hard connection to lcpll_top input of the CGB from both fPLL and ATX PLL
# and for both PLLs input_select default is lcpll_top
# however for Gen 3, design we have the fpll connecting to aux0 of MasterCGB, which goes to fpll_top port of the Master CGB
# but we want Gen3 designs to start with Gen1-2 speeds and then switch to Gen 3 speed
# hence the input port that fPLL is connected should be set as primary (taken car of in the function validate_input_select) and
#       the input port that LCPLL is connected should be set as secondary (done by updating hssi_pma_cgb_master_input_select_gen3)
# \note master cgb instentiation at fpll IP is not allowed for gen 3 designs, hence only atx is of importance  
#
# ------------------------------
# Changes made with 
#  The hard connection from the FPLL core is now to the fpll_top input port of the mcgb
#  The hard connection from the ATX core is now to the lcpll_top input port of the mcgb
#  The input_select parameter default value has been changed to fpll_top
#  In the case of any pcie gen3 design, the input_select_g3 needs to be set to lcpll_top 
#  In all other cases, it can be set to "unused"
# ------------------------------
#

proc ::mcgb_package_s10::mcgb::validate_input_select_gen3 { hssi_pma_cgb_master_prot_mode } {
   # if module name contains atx it is most likely atx not fpll
   if { $hssi_pma_cgb_master_prot_mode == "pcie_gen3_tx" } {
      ip_set "parameter.hssi_pma_cgb_master_input_select_gen3.value" "lcpll_top"
   } else {
      ip_set "parameter.hssi_pma_cgb_master_input_select_gen3.value" "unused"
   }
}

##
# if protocol mode is not pcie, it does not make any sense to enable pcie clock switch interface.
proc ::mcgb_package_s10::mcgb::validate_enable_mcgb_pcie_clksw { PROP_VALUE enable_mcgb is_protocol_PCIe } {
   if {$enable_mcgb && $PROP_VALUE && !$is_protocol_PCIe} {
      ip_message warning "PCIe clock switch interface is intended to be used for PCIe protocol(s) only."
   }
}

##
# if protocol mode is pcie, it does not make any sense to use feedback compensation bonding.
proc ::mcgb_package_s10::mcgb::validate_enable_fb_comp_bonding { PROP_VALUE enable_mcgb enable_bonding_clks is_protocol_PCIe } {
   if {$enable_mcgb && $enable_bonding_clks &&  $PROP_VALUE && $is_protocol_PCIe} {
      ip_message warning "Feedback compensation bonding is not intended for PCIe protocol(s)."
   }
}

#convert units in mega (10^6) to base (10^0)
proc ::mcgb_package_s10::mcgb::mega_to_base { PROP_NAME PROP_VALUE } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $PROP_VALUE "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  ip_set "parameter.${PROP_NAME}.value" $temp
}

##
# check enable_mcgb before propagating pma_width selection to atom parameter
proc ::mcgb_package_s10::mcgb::convert_mcgb_ser_mode {PROP_NAME enable_mcgb pma_width} {
   set temp $pma_width
   if {!$enable_mcgb} {
      # do not propogate user selection if cgb not enabled
      set temp [ip_get "parameter.pma_width.DEFAULT_VALUE"]
   }

   switch $temp {
      8        { ip_set "parameter.${PROP_NAME}.value" eight_bit      }
      10       { ip_set "parameter.${PROP_NAME}.value" ten_bit        }
      16       { ip_set "parameter.${PROP_NAME}.value" sixteen_bit    }
      20       { ip_set "parameter.${PROP_NAME}.value" twenty_bit     }
      32       { ip_set "parameter.${PROP_NAME}.value" thirty_two_bit }
      40       { ip_set "parameter.${PROP_NAME}.value" forty_bit      }
      64       { ip_set "parameter.${PROP_NAME}.value" sixty_four_bit }
      default  { ip_set "parameter.${PROP_NAME}.value" sixty_four_bit }
   }
}

##
# check enable_mcgb before propagating mcgb_div selection to atom parameter
proc ::mcgb_package_s10::mcgb::convert_mcgb_div { PROP_NAME enable_mcgb mcgb_div } {
   set temp $mcgb_div
   if {!$enable_mcgb} {
      # do not propogate user selection if cgb not enabled
      set temp [ip_get "parameter.mcgb_div.DEFAULT_VALUE"]
   }

   ip_set "parameter.${PROP_NAME}.value" $temp
}

##
# Dont allow, Master CGB if GT is selected as primary buffer
# It complicates PLL Computations such as which computation result are we supposed to make? GX or GT
proc ::mcgb_package_s10::mcgb::validate_enable_mcgb {PROP_NAME PROP_VALUE mapped_primary_pll_buffer} {
   if { $PROP_VALUE } {
      if {       [string compare -nocase $mapped_primary_pll_buffer "N/A"]==0 } {
         # this is most likely fPLL hence dont care
      } elseif { [string compare -nocase $mapped_primary_pll_buffer "GT clock output buffer"]==0 } {
         ip_message error "Master CGB ($PROP_NAME) cannot be enabled when GT is selected for Primary PLL clock output buffer."
      }
   }
}

##################################################################################################################################################
# functions: copying calculated pll settings to corresponding hdl parameters 
################################################################################################################################################## 

##
# Dont allow, Master CGB input clock rate more than 8 GHz
proc ::mcgb_package_s10::mcgb::update_mcgb_in_clk_freq { mapped_output_clock_frequency enable_mcgb} {
        # strip off MHz if needed
        if {[llength $mapped_output_clock_frequency] > 1} {
           set mcgb_in_freq [::alt_xcvr::utils::common::get_freq_in_mhz $mapped_output_clock_frequency]
        } else {
           set mcgb_in_freq $mapped_output_clock_frequency
        }
        ip_set "parameter.mcgb_in_clk_freq.value" $mcgb_in_freq

        # \todo hardcoded f_max_x1 8700!!!! FIXME
        set MAX_MCGB_IN_MHZ 8700
        if {$enable_mcgb} {
           if {$mcgb_in_freq>$MAX_MCGB_IN_MHZ} {
              ip_message error "Master CGB input clock frequency($mcgb_in_freq MHz) is above maximum allowed($MAX_MCGB_IN_MHZ MHz)."
           }
        }
}

proc ::mcgb_package_s10::mcgb::update_mcgb_out_datarate { mcgb_in_clk_freq mcgb_div_fnl} {
	set temp_mcgb_out_datarate [expr {(2.0*$mcgb_in_clk_freq)/$mcgb_div_fnl}]
	ip_set "parameter.mcgb_out_datarate.value" $temp_mcgb_out_datarate
}
