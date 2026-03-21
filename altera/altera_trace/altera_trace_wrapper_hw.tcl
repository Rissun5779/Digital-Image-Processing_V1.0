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


# 
# module altera_trace_wrapper
# 
set_module_property DESCRIPTION "This soft IP is used to export the trace interface from HPS out to FPGA pin"
set_module_property NAME altera_trace_wrapper
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Processors and Peripherals/Hard Processor Components"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Altera HPS Trace IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_QUARTUS true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property composition_callback compose

# 
# parameters
#
add_parameter 		   IN_DWIDTH INTEGER 32
set_parameter_property IN_DWIDTH DEFAULT_VALUE 32
set_parameter_property IN_DWIDTH DISPLAY_NAME IN_DWIDTH
set_parameter_property IN_DWIDTH TYPE INTEGER
set_parameter_property IN_DWIDTH UNITS None
set_parameter_property IN_DWIDTH HDL_PARAMETER true
set_parameter_property IN_DWIDTH VISIBLE false

add_parameter 		   OUT_DWIDTH INTEGER 32
set_parameter_property OUT_DWIDTH DEFAULT_VALUE 32
set_parameter_property OUT_DWIDTH DISPLAY_NAME OUT_DWIDTH
set_parameter_property OUT_DWIDTH TYPE INTEGER
set_parameter_property OUT_DWIDTH DERIVED true
set_parameter_property OUT_DWIDTH UNITS None
set_parameter_property OUT_DWIDTH HDL_PARAMETER true
set_parameter_property OUT_DWIDTH ALLOWED_RANGES {"16" "32"}
set_parameter_property OUT_DWIDTH VISIBLE false

add_parameter 		   NUM_PIPELINE_REG INTEGER 1
set_parameter_property NUM_PIPELINE_REG DEFAULT_VALUE 1
set_parameter_property NUM_PIPELINE_REG DISPLAY_NAME { NUM_PIPELINE_REG}
set_parameter_property NUM_PIPELINE_REG TYPE INTEGER
set_parameter_property NUM_PIPELINE_REG UNITS None
set_parameter_property NUM_PIPELINE_REG ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}
set_parameter_property NUM_PIPELINE_REG DESCRIPTION {Number of pipeline reg.}
set_parameter_property NUM_PIPELINE_REG HDL_PARAMETER true

add_parameter			DEVICE_FAMILY STRING "Cyclone V" ""
set_parameter_property 	DEVICE_FAMILY DEFAULT_VALUE "Cyclone V"
set_parameter_property  DEVICE_FAMILY SYSTEM_INFO     "DEVICE_FAMILY"
set_parameter_property 	DEVICE_FAMILY ALLOWED_RANGES {"Arria V" "Cyclone V" "Arria 10" "Stratix 10"}
set_parameter_property 	DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property 	DEVICE_FAMILY VISIBLE false

#
# Add instance 
#
proc compose {} {
	set device_family_param 	[ get_parameter_value DEVICE_FAMILY ]
	set IN_DWIDTH 	 			[ get_parameter_value IN_DWIDTH ]
	set NUM_PIPELINE_REG 		[ get_parameter_value NUM_PIPELINE_REG ]
	
	add_instance 			altera_trace_inst altera_trace
	set_instance_parameter 	altera_trace_inst IN_DWIDTH $IN_DWIDTH
    set_instance_parameter 	altera_trace_inst NUM_PIPELINE_REG $NUM_PIPELINE_REG
	
	add_interface 			clock_sink clock end
    set_interface_property 	clock_sink EXPORT_OF altera_trace_inst.clock_sink
	
	add_interface 			reset_sink reset end
    set_interface_property 	reset_sink EXPORT_OF altera_trace_inst.reset_sink
	
	add_interface 			h2f_tpiu conduit end
    set_interface_property 	h2f_tpiu EXPORT_OF altera_trace_inst.h2f_tpiu
	
	add_interface 		    f2h_clk_in conduit end
    set_interface_property 	f2h_clk_in EXPORT_OF altera_trace_inst.f2h_clk_in
	
	add_interface 		    trace_clk_out clock start
	set_interface_property  trace_clk_out EXPORT_OF altera_trace_inst.trace_clk_out
	
	add_interface 			trace_data_out conduit end
	
	if {$device_family_param == "Cyclone V" || $device_family_param == "Arria V"} {
		set_parameter_value 	OUT_DWIDTH 32
		set_instance_parameter 	altera_trace_inst OUT_DWIDTH 32
		set_interface_property 	trace_data_out EXPORT_OF altera_trace_inst.trace_data_out
		
	} else {
		set_parameter_value 	OUT_DWIDTH 16
		set_instance_parameter 	altera_trace_inst OUT_DWIDTH 16
		
		add_instance 			altgpio altera_gpio
		set_instance_parameter 	altgpio SIZE 16
        set_instance_parameter 	altgpio PIN_TYPE_GUI "Output"
        set_instance_parameter 	altgpio gui_io_reg_mode "DDIO"
        set_instance_parameter 	altgpio gui_areset_mode "Clear"
		
		set_interface_property 	trace_data_out  EXPORT_OF altgpio.pad_out
		add_connection 			altgpio.din 	altera_trace_inst.data_gpio
        add_connection 			altgpio.ck 		altera_trace_inst.clk_gpio
        add_connection 			altgpio.aclr 	altera_trace_inst.reset_gpio
	}
	
}
