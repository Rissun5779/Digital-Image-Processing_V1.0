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


package provide altera_xcvr_native_s10::design_example 18.1

##############################
# Include package
##############################
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

package require alt_xcvr::de_tcl::de_api
package require altera_xcvr_native_s10::design_example_rules::main_rule
package require altera_xcvr_native_s10::design_example_rules::main_tb_rule

##############################
# namespace declaration
##############################
namespace eval ::altera_xcvr_native_s10::design_example:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  variable design_example_parameters
  variable package_name

  # Initialize the variables
  set package_name "altera_xcvr_native_s10::design_example"

  set design_example_parameters {\
    { NAME                       	DERIVED	HDL_PARAMETER	TYPE   	DEFAULT_VALUE    	ALLOWED_RANGES      	ENABLED            	VISIBLE               	  DISPLAY_HINT	DISPLAY_UNITS	DISPLAY_ITEM               	DISPLAY_NAME                               	VALIDATION_CALLBACK                   	DESCRIPTION	}\
    { cannot_gen_exdesign_msg    	true   	false       	STRING 	{"Not validated"}	NOVAL               	true               	false                 	  NOVAL       	NOVAL        	"Design Example Parameters"	NOVAL                                      	::altera_xcvr_native_s10::design_example::validate_cannot_gen_exdesign_msg      	"Message to be displayed if design example cannot be generated. Empty string means can be generated."     	}\
    { can_gen_exdesign_basic_std 	true   	false       	INTEGER	0                	NOVAL               	true               	false                 	  NOVAL       	NOVAL        	"Design Example Parameters"	NOVAL                                      	::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_basic_std   	"If protocol mode is standard pcs, this parameter indicates whether a design example can be generated for the current configuration or not."     	}\
    { can_gen_exdesign_basic_enh 	true   	false       	INTEGER	0                	NOVAL               	true               	false                 	  NOVAL       	NOVAL        	"Design Example Parameters"	NOVAL                                      	::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_basic_enh   	"If protocol mode is enhanced pcs, this parameter indicates whether a design example can be generated for the current configuration or not."     	}\
    { can_gen_exdesign_pcs_direct       true    false           INTEGER 0                       NOVAL                   true                    false                     NOVAL         NOVAL           "Design Example Parameters"     NOVAL                                           ::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_pcs_direct          "If protocol mode is pcs direct, this parameter indicates whether a design example can be generated for the current configuration or not."              }\
    \
    { enable_workaround_rules   	false  	false       	INTEGER	0                	NOVAL               	enable_internal_options	enable_internal_options	  boolean     	NOVAL        	"Design Example Parameters"	"Enable Workaround Rules"                  	NOVAL                                 	"TBD."     	}\
    { tx_pll_type               	false  	false       	STRING 	ATX              	{"ATX" "fPLL" "CMU"}	true               	true                  	  NOVAL       	NOVAL        	"Design Example Parameters"	"Tx PLL Type"                              	NOVAL                                 	"TBD."     	}\
    { tx_pll_refclk             	false  	false       	FLOAT  	125              	NOVAL               	true               	true                  	  NOVAL       	MHz          	"Design Example Parameters"	"Tx PLL Referecen Clock Frequency"         	NOVAL                                 	"TBD."     	}\
    { use_tx_clkout2            	false  	false       	INTEGER	0                	NOVAL               	true               	true                  	  boolean     	NOVAL        	"Design Example Parameters"	"Use tx_clkout2 as source for tx_coreclkin"	NOVAL                                 	"TBD."     	}\
    { use_rx_clkout2            	false  	false       	INTEGER	0                	NOVAL               	true               	true                  	  boolean     	NOVAL        	"Design Example Parameters"	"Use rx_clkout2 as source for rx_coreclkin"	NOVAL                                 	"TBD."     	}\
    { design_example_filename   	false  	false       	STRING 	"top"            	NOVAL               	true               	true                  	  NOVAL       	NOVAL        	"Design Example Parameters"	"Design Example Filename"                  	NOVAL                                 	"TBD."     	}\
  }

}

###################################################################
##### FUNCTIONS EXPECTED TO BE USED DURING DECLERATION PHASE ######
###################################################################

##############################
# returns the required variable's content
##############################
proc altera_xcvr_native_s10::design_example::get_variable { var } {
  variable design_example_parameters
  variable package_name
  return [set $var]
}


###################################################################
##### FUNCTIONS EXPECTED TO BE USED DURING VALIDATION PHASE #######
###################################################################

##############################
# Display whether design example can be generated or not message in GUI
##############################
proc ::altera_xcvr_native_s10::design_example::validate_display_cannot_gen_exdesign_msg { cannot_gen_exdesign_msg } {
  # beautifying the message
  set message ""
  if {${cannot_gen_exdesign_msg}!=""} {
    set message "<html><font color=\"blue\">Note - </font>${cannot_gen_exdesign_msg}</html>"
  }
  ip_set "display_item.display_cannot_gen_exdesign_msg.text" ${message}
}

##############################
# update the message content showing whether design example can be generated or not 
# the value of the parameter also used in design example generation callback!!
##############################
proc ::altera_xcvr_native_s10::design_example::validate_cannot_gen_exdesign_msg { PROP_NAME channels bonded_mode protocol_mode can_gen_exdesign_basic_std can_gen_exdesign_basic_enh can_gen_exdesign_pcs_direct enable_split_interface channels enable_simple_interface enable_double_rate_transfer duplex_mode rx_fifo_mode enable_port_rx_fifo_rd_en} {
  set message ""
  set MULT_CH_SINGLE_INTF_NOT_OK_MESSAGE "For multi channel configurations, a design example cannot be generated unless \"[ip_get "parameter.enable_split_interface.display_name"]\" is selected."
  set SIMPLEX_NOT_SUPPORTED_MESSAGE      "Simplex Configurations are currently not supported by the Design Example Framework"
  set NO_SIMPLIFIED_INTF_NOT_OK_MESSAGE "A design example cannot be generated unless \"[ip_get "parameter.enable_simple_interface.display_name"]\" is selected."; #[IS:this might eventually depend on protocol]
  set NO_FIFO_RD_EN_NOT_OK_MESSAGE "When \"[ip_get "parameter.rx_fifo_mode.display_name"]\" is in ${rx_fifo_mode} mode, a design example cannot be generated unless \"[ip_get "parameter.enable_port_rx_fifo_rd_en.display_name"]\" is selected";
  set DEFAULT_NOT_OK_MESSAGE "Design example cannot be generated for the current configuration."

  # -------------------------------------------------
  # protocol level check
  # default behavior --> no example design can be generated
  if { ! [expr { ${protocol_mode}=="basic_std"? ${can_gen_exdesign_basic_std}:\
                 ${protocol_mode}=="basic_enh"? ${can_gen_exdesign_basic_enh}:\
                 ${protocol_mode}=="pcs_direct"? ${can_gen_exdesign_pcs_direct}:\
                                                        0 }] } {
    set message  ${DEFAULT_NOT_OK_MESSAGE}
    auto_message info $PROP_NAME ${message}
    ip_set "parameter.${PROP_NAME}.value" ${message}
    return; # <--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! EARLY RETURN
  }
  # -------------------------------------------------

  # -------------------------------------------------
  # top level checks
  set message ""
  if { ${channels}>1 && !${enable_split_interface}} {    
    auto_message info $PROP_NAME ${MULT_CH_SINGLE_INTF_NOT_OK_MESSAGE}
    set message "${message} ${MULT_CH_SINGLE_INTF_NOT_OK_MESSAGE}";#keep appending messages as they will appear in design example generation window
  }
  if {!${enable_simple_interface} && !( ( ${protocol_mode}=="pcs_direct" || ${protocol_mode}=="basic_enh" ) && ${enable_double_rate_transfer}==1)} {
    auto_message info $PROP_NAME ${NO_SIMPLIFIED_INTF_NOT_OK_MESSAGE}
    set message "${message} ${NO_SIMPLIFIED_INTF_NOT_OK_MESSAGE}";#keep appending messages as they will appear in design example generation window
  }

  if {(${duplex_mode}!="tx") && (${rx_fifo_mode}=="Phase compensation-Basic") && !(${enable_port_rx_fifo_rd_en})} {
    auto_message info $PROP_NAME ${NO_FIFO_RD_EN_NOT_OK_MESSAGE}
    set message "${message} ${NO_FIFO_RD_EN_NOT_OK_MESSAGE}"
  }

  if { ${duplex_mode} != "duplex" } {
    auto_message info $PROP_NAME ${SIMPLEX_NOT_SUPPORTED_MESSAGE}
    set message "${message} ${SIMPLEX_NOT_SUPPORTED_MESSAGE}"
  }

  if { (${channels} > 6) && (${bonded_mode} == "not_bonded") } {
    set ENABLE_MCGB_FOR_XN_NONBONDED_MESSAGE "For non-bonded designs with greater than 6 channels, the Design Example Framework enables the MCGB High Frequency Clock"  
    auto_message info $PROP_NAME ${ENABLE_MCGB_FOR_XN_NONBONDED_MESSAGE}
    #set message "${message} ${ENABLE_MCGB_FOR_XN_NONBONDED_MESSAGE}"
  }
    

  # -------------------------------------------------

  ip_set "parameter.${PROP_NAME}.value" ${message};# <---- note that if message is "" --> things are ok for design example generation
}

##############################
# update the parameter showing whether design example can be generated or not if the protocol mode is enhanced pcs
##############################
proc ::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_basic_enh { PROP_NAME } {
  # PROBABLY THERE ARE MANY CONFIGURAIONS WHICH ARE NOT COVERED YET, BUT FOR ILLUSTRATION PURPOSES FOR NOW SET TO 1, eventually add logic here
  set value 1
  ip_set "parameter.${PROP_NAME}.value" ${value};
}

##############################
# update the parameter showing whether design example can be generated or not if the protocol mode is standard pcs
##############################
proc ::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_basic_std { PROP_NAME protocol_mode std_pcs_pma_width enable_double_rate_transfer duplex_mode std_tx_byte_ser_mode l_pcs_pma_width l_tx_fifo_transfer_mode} {
  set SPECIAL_CONFIG_NOT_OK_MESSAGE "A design example cannot be generated for \"[ip_get "parameter.protocol_mode.display_name"]\"==\"${protocol_mode}\" && \"[ip_get "parameter.std_pcs_pma_width.display_name"]\"==\"${std_pcs_pma_width}\" && \"[ip_get "parameter.std_tx_byte_ser_mode.display_name"]\"==\"${std_tx_byte_ser_mode}\" && \"[ip_get "parameter.enable_double_rate_transfer.display_name"]\"==\"${enable_double_rate_transfer}\""
  set value 1
  if {(${duplex_mode}!="rx" && ${std_tx_byte_ser_mode}=="Disabled" && ${l_pcs_pma_width}==20) && (${l_tx_fifo_transfer_mode}=="x2" || ${l_tx_fifo_transfer_mode}=="x1x2")} {
    #auto_message info $PROP_NAME ${SPECIAL_CONFIG_NOT_OK_MESSAGE}
    set value 0
  }
  ip_set "parameter.${PROP_NAME}.value" ${value};
}

##############################
# update the parameter showing whether design example can be generated or not if the protocol mode is pcs direct
##############################
proc ::altera_xcvr_native_s10::design_example::validate_can_gen_exdesign_pcs_direct { PROP_NAME protocol_mode std_pcs_pma_width enable_double_rate_transfer duplex_mode l_pcs_pma_width l_tx_fifo_transfer_mode} {
  set SPECIAL_CONFIG_NOT_OK_MESSAGE "A design example cannot be generated for \"[ip_get "parameter.protocol_mode.display_name"]\"==\"${protocol_mode}\" && \"[ip_get "parameter.std_pcs_pma_width.display_name"]\"==\"${std_pcs_pma_width}\" && \"[ip_get "parameter.enable_double_rate_transfer.display_name"]\"==\"${enable_double_rate_transfer}\""
  set value 1
  if {(${duplex_mode}!="rx" && ${l_pcs_pma_width}==20) && (${l_tx_fifo_transfer_mode}=="x2" || ${l_tx_fifo_transfer_mode}=="x1x2")} {
    #auto_message info $PROP_NAME ${SPECIAL_CONFIG_NOT_OK_MESSAGE}
    set value 0
  }
  ip_set "parameter.${PROP_NAME}.value" ${value};
}

###################################################################
##### FUNCTIONS EXPECTED TO BE USED DURING GENERATION PHASE #######
###################################################################

################################
# Fileset callback to the design example generation engine
##############################
proc ::altera_xcvr_native_s10::design_example::callback_design_example {ip_name} {
    if { [ip_get "parameter.cannot_gen_exdesign_msg.value"] !="" } {
      ip_message error [ip_get "parameter.cannot_gen_exdesign_msg.value"]
      return
    }

    puts "Hi-I will generate the necessary design example as requested"
    #\TODO is this double nphy correct approach, to pass the name of main_instance??
    #\TODO should I get this from ip_name?? --> we are a dynamic IP so we know the name?!!
    set main_instance_name "nphy"
    set device_family [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.DEVICE_FAMILY.value"]
    set device [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.DEVICE.value"]  
    set root_file_name [::alt_xcvr::ip_tcl::ip_module::ip_get "parameter.design_example_filename.value"] 
    set useQsysPro 1;
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
      "::altera_xcvr_native_s10::design_example_rules::main_rule" \
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
      "::altera_xcvr_native_s10::design_example_rules::main_tb_rule" \
      "main_instance_name ${main_instance_name}_tb dut_kind_ref ${root_file_name} stimuli_generator_ref ${root_file_name}_sg" \
      ${device_family} \
      ${device} \
      "${qsys_path_dut},$"]
}

