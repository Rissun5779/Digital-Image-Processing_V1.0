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


package require -exact qsys 14.0


#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "csv_ui_loader.tcl"
source "twentynm_mac_native_hw_extra.tcl"
source "twentynm_mac_msg.tcl"
source "../common/mac_native_common.tcl"

#+--------------------------------------------
#|
#|  IP Property
#|
#+--------------------------------------------
set_module_property     NAME                    "altera_a10_native_fixed_point_dsp"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 "18.1"
set_module_property     DISPLAY_NAME            "Native Fixed Point DSP Intel Arria 10 FPGA IP"
set_module_property     DESCRIPTION             "The NATIVE_DSP megafunction allows you to implement the primitive variable precision DSP block"
set_module_property     GROUP                   "DSP/Primitive DSP"
set_module_property     EDITABLE                false
set_module_property   	SUPPORTED_DEVICE_FAMILIES   {"Arria 10"}
set_module_property     ELABORATION_CALLBACK    elab
set_module_property   	HIDE_FROM_QSYS true
set_module_property   	DATASHEET_URL		"http://www.altera.com/literature/ug/ug_nfp_dsp.pdf"

#Added to support IP-UPGRADE 
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade_callback

#+--------------------------------------------
#|
#|  Filesets
#|
#+--------------------------------------------
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim


#+--------------------------------------------
#|
#|  Load the parameters and ui from CSV files
#|
#+--------------------------------------------
load_parameters "twentynm_mac.atom.csv"
load_ports    	"twentynm_mac.port.csv"
load_layout     "twentynm_mac.layout.csv"

#+--------------------------------------------
#|
#|  Manual disabling redundant parameter/port
#|
#+--------------------------------------------
#parameter
set_display_item_property mode_sub_location VISIBLE false

#+--------------------------------------------
#|
#|  Elaboration Callback
#|
#+--------------------------------------------
proc elab {} {
    
    #+---------- SETUP PARAMETERS ----------+#
    # The IP parameter is 1 to 1 with WYSIWYG parameter, no additional setup is required.
	
    #+---------- SETUP PORTS ----------+#
	# Port elaboration, declare dynamic interfaces and ports
	interface_ports_and_mapping
	
	#+---------- LEGALITY CHECK ----------+#
	# General information and check for illegal settings
	legality_check
	general_info

}

#+--------------------------------------------
#|
#|  IP-UPGRADE
#|
#+--------------------------------------------
proc parameter_upgrade_callback {ip_core_type version parameters} {
	set enable_accumulate "false"
	set accumulate_clock "none"
	set output_clock "none"
	set all_operation_mode [list m18x18_full m18x18_systolic m18x18_plus36 m18x18_sumof2 m27x27]
	#check for previous parameter name and value
	foreach {name value} $parameters {
		if {$name == "operation_mode"} {
			set operation_mode $value
			#The result_b_width will be always zero for ALL modes except m18x18_full
			if {$operation_mode ne "m18x18_full"} {
				set_parameter_value operation_mode $value
				set_parameter_value result_b_width "0"
				#Other than m18x18_full mode az/bz width will be set to 0 if operand_source_may/mby is equal to input
				set get_operand_source_may [get_parameter_value operand_source_may]
				set get_operand_source_mby [get_parameter_value operand_source_mby]
				#Check default value for operation mode==m18x18_full
				#check operand_source_may equal to input az_width need to change to default value "0"
				if {$get_operand_source_may ne "preadder"} {
					set_parameter_value az_width "0"
					send_message INFO "SHOW:PREADDER AZ_WIDTH 0"
				} 
				#check operand_source_mby equal to input bz_width need to change to default value "0"
				if {$get_operand_source_mby ne "preadder"} {
					set_parameter_value bz_width "0"
					send_message INFO "SHOW:PREADDER BZ_WIDTH 0"
				}
			#Mode equals to m18x18_full mode az/bz width will be set to 0 if operand_source_may/mby is equal to input	
			} elseif {$operation_mode eq "m18x18_full"} {
				set get_operand_source_may [get_parameter_value operand_source_may]
				set get_operand_source_mby [get_parameter_value operand_source_mby]
				#Check default value for operation mode==m18x18_full
				#check operand_source_may equal to input az_width need to change to default value "0"
				if {$get_operand_source_may ne "preadder"} {
					set_parameter_value az_width "0"
					send_message INFO "SHOW:PREADDER AZ_WIDTH 0"
				} 
				#check operand_source_mby equal to input bz_width need to change to default value "0"
				if {$get_operand_source_mby ne "preadder"} {
					set_parameter_value bz_width "0"
					send_message INFO "SHOW:PREADDER BZ_WIDTH 0"
				}
			}
		#Retain all other values from previous parameter
		} else {
			set_parameter_value $name $value
		}
	}
}


#+--------------------------------------------
#|
#|  Quartus Synthesis / Verilog Simulation
#|
#+--------------------------------------------
proc do_quartus_synth {output_name} {

	send_message info "generating top-level entity $output_name"
	
    set file_name ${output_name}.v
    set terp_path twentynm_mac.v.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VERILOG TEXT $contents
	
}


#+--------------------------------------------
#|
#|  VHDL Simulation
#|
#+--------------------------------------------
proc do_vhdl_sim {output_name} {
 	
	send_message info "generating top-level entity $output_name"
	
	set file_name ${output_name}.vhd
    set terp_path twentynm_mac.vhd.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VHDL TEXT $contents
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/kly1418710866787/kly1415863279223
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
