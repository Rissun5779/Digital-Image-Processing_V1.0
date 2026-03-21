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


# $File: //acds/rel/18.1std/ip/iconnect/alt_hiconnect_st_reg/alt_hiconnect_st_reg_hw.tcl $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $
#------------------------------------------------------------------------------

package require -exact qsys 15.0

set_module_property NAME alt_hiconnect_st_reg
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
set_module_property DISPLAY_NAME "Avalon-ST Register"
set_module_property AUTHOR "Altera Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property HIDE_FROM_QUARTUS true
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf
# | 
# +-----------------------------------


proc _get_empty_width {} {
    set use_empty [ get_parameter_value USE_EMPTY ]
    set empty_width 0
    if { $use_empty } {
        set symbols_per_beat [ get_parameter_value SYMBOLS_PER_BEAT ]
        set empty_width [ expr int(ceil(log($symbols_per_beat) / log(2))) ]
    }
    return $empty_width
}

# | Callbacks
# | 

proc validate {} {
    set use_empty [ get_parameter_value USE_EMPTY ]
    set use_packets [ get_parameter_value USE_PACKETS ]
    if {![string compare $use_empty true] && ![string compare $use_packets false]} {
        send_message error "empty is not available without use_packets"
    }
   
    set symbols_per_beat [ get_parameter_value SYMBOLS_PER_BEAT ]
    if {![string compare $use_empty true] && $symbols_per_beat == 1} {
        send_message error "empty is not available when symbols_per_beat == 1"
    }
}

proc elaborate {} {
    set symbols_per_beat [ get_parameter_value SYMBOLS_PER_BEAT ]
    set bits_per_symbol [ get_parameter_value BITS_PER_SYMBOL ]

    set_interface_property sink0 readyLatency 0
    set_interface_property source0 readyLatency 0
  
    set_interface_property sink0 dataBitsPerSymbol $bits_per_symbol
    set_interface_property source0 dataBitsPerSymbol $bits_per_symbol
  
    set data_width [ expr $symbols_per_beat * $bits_per_symbol ]
  
    add_interface_port sink0 in_data data Input $data_width
    set_port_property in_data vhdl_type std_logic_vector
    add_interface_port source0 out_data data Output $data_width 
    set_port_property out_data vhdl_type std_logic_vector
  
    set channel_width [ get_parameter_value CHANNEL_WIDTH ]
    if {$channel_width > 0} {
        add_interface_port source0 out_channel channel Output $channel_width
        set_port_property out_channel vhdl_type std_logic_vector
        add_interface_port sink0 in_channel channel Input $channel_width
        set_port_property in_channel vhdl_type std_logic_vector
    } else {
        add_interface_port source0 out_channel channel Output 1
        set_port_property out_channel vhdl_type std_logic_vector
        add_interface_port sink0 in_channel channel Input 1
        set_port_property in_channel vhdl_type std_logic_vector
        
        set_port_property out_channel TERMINATION true
        set_port_property in_channel TERMINATION true
        set_port_property in_channel TERMINATION_VALUE 0
    }
  
    set max [ get_parameter_value MAX_CHANNEL ]
    set_interface_property sink0 maxChannel $max
    set_interface_property source0 maxChannel $max
  
    set_port_property in_startofpacket WIDTH_EXPR 1
    set_port_property in_endofpacket WIDTH_EXPR 1
    set_port_property out_startofpacket WIDTH_EXPR 1
    set_port_property out_endofpacket WIDTH_EXPR 1

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
  
    if {[ get_parameter_value USE_EMPTY ]} {
        set empty_width [ _get_empty_width ]
        set_port_property in_empty WIDTH_EXPR $empty_width
        set_port_property in_empty vhdl_type std_logic_vector
        set_port_property out_empty WIDTH_EXPR $empty_width
        set_port_property out_empty vhdl_type std_logic_vector
    } else {
        set_port_property in_empty WIDTH_EXPR 1
        set_port_property in_empty vhdl_type std_logic_vector
        set_port_property out_empty WIDTH_EXPR 1
        set_port_property out_empty vhdl_type std_logic_vector
        set_port_property in_empty TERMINATION true
        set_port_property in_empty TERMINATION_VALUE 0
        set_port_property out_empty TERMINATION true
    }

    if {![ get_parameter_value USE_READY ]} {
      set_port_property in_ready TERMINATION true
      set_port_property out_ready TERMINATION true
      set_port_property out_ready TERMINATION_VALUE 1
    }

    if {![ get_parameter_value USE_VALID ]} {
      set_port_property in_valid TERMINATION true
      set_port_property in_valid TERMINATION_VALUE 0
      set_port_property out_valid TERMINATION true
    }
  
    set error_width [ get_parameter_value ERROR_WIDTH ]
    if {$error_width > 0} {
        set_port_property in_error WIDTH_EXPR $error_width
        set_port_property in_error vhdl_type std_logic_vector
        set_port_property out_error WIDTH_EXPR $error_width
        set_port_property out_error vhdl_type std_logic_vector
    } else {
        set_port_property in_error WIDTH_EXPR 1
        set_port_property in_error vhdl_type std_logic_vector
        set_port_property out_error WIDTH_EXPR 1
        set_port_property out_error vhdl_type std_logic_vector
        set_port_property in_error TERMINATION true
        set_port_property in_error TERMINATION_VALUE 0
        set_port_property out_error TERMINATION true
    }
  
    set_interface_property cr0_reset synchronousEdges "both"
}

# +-----------------------------------
# | files
# | 

add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL alt_hiconnect_st_reg

add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL alt_hiconnect_st_reg

add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure
set_fileset_property vhdl_fileset TOP_LEVEL alt_hiconnect_st_reg

proc synth_callback_procedure { entity_name } {
    add_fileset_file alt_hiconnect_st_reg.sv SYSTEM_VERILOG PATH "alt_hiconnect_st_reg.sv"
}

# | 
# +-----------------------------------
# +-----------------------------------
# | parameters
# | 
add_parameter SYMBOLS_PER_BEAT INTEGER 1
set_parameter_property SYMBOLS_PER_BEAT DISPLAY_NAME "Symbols per beat"
set_parameter_property SYMBOLS_PER_BEAT DESCRIPTION {Symbols per beat}
set_parameter_property SYMBOLS_PER_BEAT UNITS None
set_parameter_property SYMBOLS_PER_BEAT AFFECTS_GENERATION false
set_parameter_property SYMBOLS_PER_BEAT IS_HDL_PARAMETER true
set_parameter_property SYMBOLS_PER_BEAT ALLOWED_RANGES 1:256

add_parameter BITS_PER_SYMBOL INTEGER 8
set_parameter_property BITS_PER_SYMBOL DISPLAY_NAME "Bits per symbol"
set_parameter_property BITS_PER_SYMBOL DESCRIPTION {Bits per symbol}
set_parameter_property BITS_PER_SYMBOL UNITS None
set_parameter_property BITS_PER_SYMBOL AFFECTS_GENERATION false
set_parameter_property BITS_PER_SYMBOL IS_HDL_PARAMETER true
set_parameter_property BITS_PER_SYMBOL ALLOWED_RANGES 1:2048

add_parameter USE_PACKETS INTEGER 0 "If enabled, include optional startofpacket and endofpacket signals"
set_parameter_property USE_PACKETS DISPLAY_NAME "Use packets"
set_parameter_property USE_PACKETS DISPLAY_HINT boolean
set_parameter_property USE_PACKETS UNITS None
set_parameter_property USE_PACKETS AFFECTS_GENERATION false
set_parameter_property USE_PACKETS AFFECTS_ELABORATION true
set_parameter_property USE_PACKETS GROUP "Packet options"
set_parameter_property USE_PACKETS IS_HDL_PARAMETER true

add_parameter USE_EMPTY INTEGER 0 "If enabled, include optional empty signal"
set_parameter_property USE_EMPTY DISPLAY_NAME "Use empty"
set_parameter_property USE_EMPTY UNITS None
set_parameter_property USE_EMPTY DISPLAY_HINT boolean
set_parameter_property USE_EMPTY AFFECTS_GENERATION false
set_parameter_property USE_EMPTY AFFECTS_ELABORATION true
set_parameter_property USE_EMPTY GROUP "Packet options"
set_parameter_property USE_EMPTY IS_HDL_PARAMETER true

add_parameter USE_READY INTEGER 1 "If enabled, include optional ready signal"
set_parameter_property USE_READY DISPLAY_NAME "Use ready"
set_parameter_property USE_READY UNITS None
set_parameter_property USE_READY DISPLAY_HINT boolean
set_parameter_property USE_READY AFFECTS_GENERATION false
set_parameter_property USE_READY AFFECTS_ELABORATION true
set_parameter_property USE_READY GROUP "Packet options"
set_parameter_property USE_READY IS_HDL_PARAMETER false

add_parameter USE_VALID INTEGER 1 "If enabled, include optional valid signal"
set_parameter_property USE_VALID DISPLAY_NAME "Use valid"
set_parameter_property USE_VALID UNITS None
set_parameter_property USE_VALID DISPLAY_HINT boolean
set_parameter_property USE_VALID AFFECTS_GENERATION false
set_parameter_property USE_VALID AFFECTS_ELABORATION true
set_parameter_property USE_VALID GROUP "Packet options"
set_parameter_property USE_VALID IS_HDL_PARAMETER false

add_parameter CHANNEL_WIDTH INTEGER 0 "If non-zero, include optional channel signal"
set_parameter_property CHANNEL_WIDTH DISPLAY_NAME "Channel width"
set_parameter_property CHANNEL_WIDTH UNITS None
set_parameter_property CHANNEL_WIDTH AFFECTS_GENERATION false
set_parameter_property CHANNEL_WIDTH AFFECTS_ELABORATION true
set_parameter_property CHANNEL_WIDTH IS_HDL_PARAMETER true
set_parameter_property CHANNEL_WIDTH ALLOWED_RANGES 0:31

add_parameter MAX_CHANNEL INTEGER 0 "Sets the maximum channel value on the source and sink interfaces"
set_parameter_property MAX_CHANNEL DISPLAY_NAME "Maximum channel value"
set_parameter_property MAX_CHANNEL AFFECTS_ELABORATION true
set_parameter_property MAX_CHANNEL AFFECTS_GENERATION false
set_parameter_property MAX_CHANNEL IS_HDL_PARAMETER false
set_parameter_property MAX_CHANNEL ALLOWED_RANGES 0:2147483647

add_parameter ERROR_WIDTH INTEGER 0 "If non-zero, include optional error signal"
set_parameter_property ERROR_WIDTH DISPLAY_NAME "Error width"
set_parameter_property ERROR_WIDTH UNITS None
set_parameter_property ERROR_WIDTH AFFECTS_GENERATION false
set_parameter_property ERROR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ERROR_WIDTH IS_HDL_PARAMETER true
set_parameter_property ERROR_WIDTH ALLOWED_RANGES 0:255

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point cr0
# | 
add_interface cr0 clock end
set_interface_property cr0 ptfSchematicName ""

set_interface_property cr0 ENABLED true
set_interface_property cr0 EXPORT_OF true

add_interface_port cr0 clk clk Input 1
add_interface_port cr0 reset reset Input 1
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point sink0
# | 
add_interface sink0 avalon_streaming end
set_interface_property sink0 dataBitsPerSymbol 1
set_interface_property sink0 errorDescriptor ""
set_interface_property sink0 readyLatency 0
set_interface_property sink0 symbolsPerBeat 1

set_interface_property sink0 ASSOCIATED_CLOCK cr0
set_interface_property sink0 ENABLED true
set_interface_property sink0 EXPORT_OF true

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point source0
# | 
add_interface source0 avalon_streaming start
set_interface_property source0 dataBitsPerSymbol 1
set_interface_property source0 errorDescriptor ""
set_interface_property source0 readyLatency 0
set_interface_property source0 symbolsPerBeat 1

set_interface_property source0 ASSOCIATED_CLOCK cr0
set_interface_property source0 ENABLED true
set_interface_property source0 EXPORT_OF true

# | 
# +-----------------------------------


# Add always-present ports valid, data.
add_interface_port sink0 in_valid valid Input 1
add_interface_port sink0 in_data data Input 1
add_interface_port source0 out_valid valid Output 1
add_interface_port source0 out_data data Output 1

# Add ready ports.
add_interface_port sink0 in_ready ready Output 1
add_interface_port source0 out_ready ready Input 1

# Add sop, eop ports.
add_interface_port sink0 in_startofpacket startofpacket Input 1
add_interface_port sink0 in_endofpacket endofpacket Input 1
add_interface_port source0 out_startofpacket startofpacket Output 1
add_interface_port source0 out_endofpacket endofpacket Output 1

# Add empty ports.
add_interface_port sink0 in_empty empty Input 1
add_interface_port source0 out_empty empty Output 1

# Add error ports.
add_interface_port sink0 in_error error Input 1
add_interface_port source0 out_error error Output 1

