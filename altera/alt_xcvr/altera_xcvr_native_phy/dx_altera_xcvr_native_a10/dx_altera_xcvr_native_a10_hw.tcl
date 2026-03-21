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
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_native_phy/altera_xcvr_native_vi
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_native_phy/dx_altera_xcvr_native_a10
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_core/nf
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_pll/altera_xcvr_cdr_pll_vi

package require -exact qsys 16.0

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::ip_tcl::ip_module

package require altera_xcvr_native_vi::parameters
package require altera_xcvr_native_vi::interfaces
package require altera_xcvr_native_vi::fileset

package require alt_xcvr::de_tcl::de_api

package require dx_altera_xcvr_native_a10::design_example_rules::main_rule
package require dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                        VERSION            SUPPORTED_DEVICE_FAMILIES   INTERNAL   ELABORATION_CALLBACK   DISPLAY_NAME                                         GROUP                                 PARAMETER_UPGRADE_CALLBACK                      AUTHOR            }\
  {dx_altera_xcvr_native_a10   18.1   {"Arria VI" "Arria 10"}     true       my_elab_callback       "Arria 10 Design Example: Transceiver Native PHY"   "Interface Protocols/Transceiver PHY"  ::altera_xcvr_native_vi::parameters::upgrade    Altera Corporation}\
}

set display_items_2 {\
  {NAME                                        GROUP             ENABLED             VISIBLE                  TYPE    ARGS                   VALIDATION_CALLBACK }\
  {"DESIGN EXAMPLE"                            ""                NOVAL               true                     GROUP   tab                    NOVAL           }\
  {"Design Example Parameters"                 "DESIGN EXAMPLE"  NOVAL               true                     GROUP   NOVAL                  NOVAL           }\
}

set parameters2 {\
  {NAME                      DERIVED    HDL_PARAMETER   TYPE      DEFAULT_VALUE    ALLOWED_RANGES         ENABLED     VISIBLE   DISPLAY_HINT  DISPLAY_UNITS  DISPLAY_ITEM                  DISPLAY_NAME                          VALIDATION_CALLBACK      DESCRIPTION }\
  {tx_pll_type               false      false           STRING    ATX              {"ATX" "fPLL" "CMU"}   true        true      NOVAL         NOVAL          "Design Example Parameters"   "Tx PLL Type"                         NOVAL                    "TBD."      }\
  {tx_pll_refclk             false      false           FLOAT     125              NOVAL                  true        true      NOVAL         "MHz"          "Design Example Parameters"   "Tx PLL Referecen Clock Frequency"    NOVAL                    "TBD."      }\
  {design_example_filename   false      false           STRING    "top"            NOVAL                  true        true      NOVAL         NOVAL          "Design Example Parameters"   "Design Example Filename"             NOVAL                    "TBD."      }\
  {using_qsys_pro            false      false           INTEGER   1                NOVAL                  true        false     NOVAL         NOVAL          "Design Example Parameters"   "Using Qsys Pro"                      NOVAL                    "TBD."      }\
} 

set filesets2 {\
  { NAME            TYPE            CALLBACK                    }\
  { example_design  EXAMPLE_DESIGN  my_example_design_callback  }\
}

::alt_xcvr::ip_tcl::ip_module::ip_declare_module $module
::altera_xcvr_native_vi::fileset::declare_filesets
::alt_xcvr::ip_tcl::ip_module::ip_declare_filesets $filesets2

::altera_xcvr_native_vi::parameters::declare_parameters
::alt_xcvr::ip_tcl::ip_module::ip_declare_parameters $parameters2
::alt_xcvr::ip_tcl::ip_module::ip_declare_display_items $display_items_2

::altera_xcvr_native_vi::interfaces::declare_interfaces


proc my_elab_callback {} {
  ::altera_xcvr_native_vi::parameters::validate
  ::altera_xcvr_native_vi::interfaces::elaborate
}

##################################################################
##################################################################
##################################################################

proc my_example_design_callback {ip_name} {
   
  puts "Hi-I will generate the necessary design example as requested"
  
  #\TODO is this double nphy correct approach, to pass the name of main_instance??
  #\TODO should I get this from ip_name?? --> we are a dynamic IP so we know the name?!!
  set main_instance_name "nphy"
  set device_family [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.DEVICE_FAMILY.value"]
  set device [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.DEVICE.value"]  
  set root_file_name [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.design_example_filename.value"] 
  set useQsysPro [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.using_qsys_pro.value"];# caution changing this simply to 1 would not work 

  ############################################ THIS IS DUT QSYS-SYSTEM
  set root_dir "dut"
  set qsys_file_name "${root_file_name}.qsys"
  set log_file_name  "${root_file_name}.log"
  set qsys_path_dut [::alt_xcvr::de_tcl::de_api::de_buildQsysSystem \
      ${useQsysPro} \
      ${root_dir} \
      ${qsys_file_name} \
      ${log_file_name} \
      ${main_instance_name} \
      1 \
      "main_rule_name" \
      "::dx_altera_xcvr_native_a10::design_example_rules::main_rule" \
      "main_instance_name $main_instance_name" \
      ${device_family} \
      ${device} \
      ""]

  ############################################ THIS IS TESTBENCH: DUT+STIM_GEN QSYS-SYSTEM
  set root_dir "tb"
  set qsys_file_name_tb "${root_file_name}_tb.qsys"
  set log_file_name_tb  "${root_file_name}_tb.log"
  set qsys_path_tb [::alt_xcvr::de_tcl::de_api::de_buildQsysSystem \
      ${useQsysPro} \
      ${root_dir} \
      "${qsys_file_name_tb}" \
      "${log_file_name_tb}" \
      "${main_instance_name}_tb" \
      0 \
      "testbench_rule_name" \
      "::dx_altera_xcvr_native_a10::design_example_rules::main_tb_rule" \
      "main_instance_name ${main_instance_name}_tb dut_kind_ref ${root_file_name}" \
      ${device_family} \
      ${device} \
      "${qsys_path_dut},$"]
}