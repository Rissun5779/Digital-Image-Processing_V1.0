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



package require -exact qsys 15.0
package require -exact altera_terp 1.0

set_module_property NAME alt_hiconnect_unsquish
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property DISPLAY_NAME "Avalon-ST Unsquish"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_QUARTUS true
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf

add_parameter IN_DATA_WIDTH INTEGER 8
set_parameter_property IN_DATA_WIDTH DISPLAY_NAME "Sink data width"
set_parameter_property IN_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property IN_DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property IN_DATA_WIDTH IS_HDL_PARAMETER false

add_parameter OUT_DATA_WIDTH INTEGER 8
set_parameter_property OUT_DATA_WIDTH DISPLAY_NAME "Source data width"
set_parameter_property OUT_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property OUT_DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property OUT_DATA_WIDTH IS_HDL_PARAMETER false

add_parameter USE_PACKETS INTEGER 1 "If enabled, include optional startofpacket and endofpacket signals"
set_parameter_property USE_PACKETS DISPLAY_NAME "Use packets"
set_parameter_property USE_PACKETS DISPLAY_HINT boolean
set_parameter_property USE_PACKETS AFFECTS_ELABORATION true
set_parameter_property USE_PACKETS AFFECTS_GENERATION false
set_parameter_property USE_PACKETS GROUP "Packet options"
set_parameter_property USE_PACKETS IS_HDL_PARAMETER false

add_parameter USE_VALID INTEGER 1 "If enabled, include optional valid signal"
set_parameter_property USE_VALID DISPLAY_NAME "Use valid"
set_parameter_property USE_VALID DISPLAY_HINT boolean
set_parameter_property USE_VALID AFFECTS_ELABORATION true
set_parameter_property USE_VALID AFFECTS_GENERATION false
set_parameter_property USE_VALID GROUP "Packet options"
set_parameter_property USE_VALID IS_HDL_PARAMETER false

add_parameter USE_READY INTEGER 1 "If enabled, include optional ready signal"
set_parameter_property USE_READY DISPLAY_NAME "Use ready"
set_parameter_property USE_READY DISPLAY_HINT boolean
set_parameter_property USE_READY AFFECTS_ELABORATION true
set_parameter_property USE_READY AFFECTS_GENERATION false
set_parameter_property USE_READY GROUP "Packet options"
set_parameter_property USE_READY IS_HDL_PARAMETER false

add_parameter CHANNEL_WIDTH INTEGER 0 "If non-zero, include optional channel signal"
set_parameter_property CHANNEL_WIDTH DISPLAY_NAME "Channel width"
set_parameter_property CHANNEL_WIDTH AFFECTS_ELABORATION true
set_parameter_property CHANNEL_WIDTH AFFECTS_GENERATION true
set_parameter_property CHANNEL_WIDTH IS_HDL_PARAMETER false

add_parameter ERROR_WIDTH INTEGER 0 "If non-zero, include optional error signal"
set_parameter_property ERROR_WIDTH DISPLAY_NAME "Error width"
set_parameter_property ERROR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ERROR_WIDTH AFFECTS_GENERATION true
set_parameter_property ERROR_WIDTH IS_HDL_PARAMETER false

add_parameter OUTPUT_DATA_MAPPING String "" ""
set_parameter_property OUTPUT_DATA_MAPPING DISPLAY_NAME "Output data mapping"
set_parameter_property OUTPUT_DATA_MAPPING AFFECTS_ELABORATION true
set_parameter_property OUTPUT_DATA_MAPPING AFFECTS_GENERATION true
set_parameter_property OUTPUT_DATA_MAPPING IS_HDL_PARAMETER false

add_interface clk clock end
add_interface_port clk clk clk Input 1
add_interface_port clk reset reset Input 1

add_interface in avalon_streaming end
set_interface_property in dataBitsPerSymbol 1
set_interface_property in errorDescriptor ""
set_interface_property in readyLatency 0
set_interface_property in symbolsPerBeat 1
set_interface_property in ASSOCIATED_CLOCK clk

add_interface out avalon_streaming start
set_interface_property out dataBitsPerSymbol 1
set_interface_property out errorDescriptor ""
set_interface_property out readyLatency 0
set_interface_property out symbolsPerBeat 1
set_interface_property out ASSOCIATED_CLOCK clk


add_interface_port in in_valid valid Input 1
add_interface_port in in_data data Input 1
add_interface_port in in_startofpacket startofpacket Input 1
add_interface_port in in_endofpacket endofpacket Input 1
add_interface_port in in_ready ready Output 1

add_interface_port out out_valid valid Output 1
add_interface_port out out_data data Output 1
add_interface_port out out_startofpacket startofpacket Output 1
add_interface_port out out_endofpacket endofpacket Output 1
add_interface_port out out_ready ready Input 1


proc elaborate {} {
    set in_data_width [ get_parameter_value IN_DATA_WIDTH ]
    set out_data_width [ get_parameter_value OUT_DATA_WIDTH ]

    set_interface_property in maxChannel 0
    set_interface_property out maxChannel 0
    set_interface_property in readyLatency 0
    set_interface_property out readyLatency 0
    set_interface_property in dataBitsPerSymbol $in_data_width
    set_interface_property out dataBitsPerSymbol $out_data_width
  
    set_port_property in_data WIDTH_EXPR $in_data_width
    set_port_property in_data vhdl_type std_logic_vector

    set_port_property out_data WIDTH_EXPR $out_data_width
    set_port_property out_data vhdl_type std_logic_vector
  
    set channel_width [ get_parameter_value CHANNEL_WIDTH ]
    if { $channel_width > 0 } {
        add_interface_port in in_channel channel Input $channel_width
        set_port_property in_channel vhdl_type std_logic_vector

        add_interface_port out out_channel channel Output $channel_width
        set_port_property out_channel vhdl_type std_logic_vector
    } 
 
    set error_width [ get_parameter_value ERROR_WIDTH ]
    if { $error_width > 0 } {
        add_interface_port in in_error error Input $error_width
        set_port_property in_error vhdl_type std_logic_vector

        add_interface_port out out_error error Output $error_width
        set_port_property out_error vhdl_type std_logic_vector
    }

  
    if { [ get_parameter_value USE_PACKETS ] } {
        # do nothing
    } else {
        set_port_property in_startofpacket TERMINATION true
        set_port_property in_startofpacket TERMINATION_VALUE 0
        set_port_property out_startofpacket TERMINATION true
        set_port_property in_endofpacket TERMINATION true
        set_port_property in_endofpacket TERMINATION_VALUE 0
        set_port_property out_endofpacket TERMINATION true
    }
  
    if { ![ get_parameter_value USE_READY ] } {
        set_port_property in_ready TERMINATION true
        set_port_property out_ready TERMINATION true
        set_port_property out_ready TERMINATION_VALUE 1
    }

    if { ![ get_parameter_value USE_VALID ] } {
        set_port_property in_valid TERMINATION true
        set_port_property in_valid TERMINATION_VALUE 0
        set_port_property out_valid TERMINATION true
    }
  

    set_interface_property clk_reset synchronousEdges "both"
}


add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure

proc synth_callback_procedure { entity_name } {
    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "alt_hiconnect_unsquish.sv.terp" ]

    set template_fh [ open $template_file r ]
    set template    [ read $template_fh ]
    close $template_fh

    set params(in_data_width)  [ get_parameter_value IN_DATA_WIDTH ]
    set params(out_data_width) [ get_parameter_value OUT_DATA_WIDTH ]
    set params(channel_width)  [ get_parameter_value CHANNEL_WIDTH ]
    set params(error_width)    [ get_parameter_value ERROR_WIDTH ]

    set mapping_string [ get_parameter_value OUTPUT_DATA_MAPPING ]
    set mapping_list [ split $mapping_string , ]
    set params(mapping_list) $mapping_list
    
    set params(output_name) $entity_name

    set result          [ altera_terp $template params ]
    set output_file     [ create_temp_file ${entity_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${entity_name}.sv SYSTEM_VERILOG PATH ${output_file}
}


