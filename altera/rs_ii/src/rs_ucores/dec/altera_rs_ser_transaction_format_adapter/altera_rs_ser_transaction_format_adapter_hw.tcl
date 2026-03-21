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

source "../../../lib/altera_rs_utilities.tcl"

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_transaction_format_adapter
# | 
set_module_property DESCRIPTION "Altera Reed Solomon Serial Transaction Format Adapter"
set_module_property NAME altera_rs_ser_transaction_format_adapter
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS Serial Transaction Format Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

add_filesets altera_rs_ser_transaction_format_adapter

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate {type entity lang} {
    add_rs_package $type "../../.."
    add_encrypted_file $type altera_rs_ser_transaction_format_adapter.sv
    add_encrypted_file $type altera_rs_ser_transaction_format_adapter.ocp
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
set inBitsPerSymbol         "inBitsPerSymbol"
set outBitsPerSymbol        "outBitsPerSymbol"
set UseinError              "UseinError"
set UseoutError             "UseoutError"
set ChannelWidth            "ChannelWidth"
set MaxChannel              "MaxChannel"

add_parameter $inBitsPerSymbol Integer 8 
set_parameter_property $inBitsPerSymbol DISPLAY_NAME "Input number of bits per symbol"
set_parameter_property $inBitsPerSymbol AFFECTS_ELABORATION true
set_parameter_property $inBitsPerSymbol DESCRIPTION "Input number of bits per symbol."
set_parameter_property $inBitsPerSymbol ENABLED true
set_parameter_property $inBitsPerSymbol HDL_PARAMETER true
set_parameter_property $inBitsPerSymbol GROUP "Port Widths"

add_parameter $outBitsPerSymbol Integer 8 
set_parameter_property $outBitsPerSymbol DISPLAY_NAME "Output number of bits per symbol"
set_parameter_property $outBitsPerSymbol AFFECTS_ELABORATION true
set_parameter_property $outBitsPerSymbol DESCRIPTION "Output number of bits per symbol."
set_parameter_property $outBitsPerSymbol ENABLED true
set_parameter_property $outBitsPerSymbol HDL_PARAMETER true
set_parameter_property $outBitsPerSymbol GROUP "Port Widths"

add_parameter $UseinError Integer 1 
set_parameter_property $UseinError DISPLAY_NAME "Use Input Error port"
set_parameter_property $UseinError AFFECTS_ELABORATION true
set_parameter_property $UseinError DESCRIPTION "Use Input Error port."
set_parameter_property $UseinError ENABLED true
set_parameter_property $UseinError HDL_PARAMETER true
set_parameter_property $UseinError GROUP "Port Enables"

add_parameter $UseoutError Integer 1 
set_parameter_property $UseoutError DISPLAY_NAME "Use Output Error port"
set_parameter_property $UseoutError AFFECTS_ELABORATION true
set_parameter_property $UseoutError DESCRIPTION "Use Output Error port."
set_parameter_property $UseoutError ENABLED true
set_parameter_property $UseoutError HDL_PARAMETER true
set_parameter_property $UseoutError GROUP "Port Enables"

add_parameter $ChannelWidth Integer 1 
set_parameter_property $ChannelWidth DISPLAY_NAME "Output number of bits per symbol"
set_parameter_property $ChannelWidth AFFECTS_ELABORATION true
set_parameter_property $ChannelWidth DESCRIPTION "Output number of bits per symbol."
set_parameter_property $ChannelWidth ENABLED true
set_parameter_property $ChannelWidth ALLOWED_RANGES {0:32}
set_parameter_property $ChannelWidth HDL_PARAMETER true
set_parameter_property $ChannelWidth GROUP "Port Widths"

add_parameter $MaxChannel Integer 1 
set_parameter_property $MaxChannel DISPLAY_NAME "Max Channel Number"
set_parameter_property $MaxChannel AFFECTS_ELABORATION true
set_parameter_property $MaxChannel HDL_PARAMETER true
set_parameter_property $MaxChannel DESCRIPTION "Maximun Channel Number"
set_parameter_property $MaxChannel GROUP "Channel Attributes"



# +-----------------------------------
# | Validate
# | 

proc validate {} {
}

# +-----------------------------------
# | Callbacks
# | 


proc elaborate {} {
    global inBitsPerSymbol  
    global outBitsPerSymbol  
    global UseinError  
    global UseoutError
    global ChannelWidth
    global MaxChannel
    
    
    
    set inBitsPerSymbol_value         [ get_parameter_value $inBitsPerSymbol ]
    set outBitsPerSymbol_value        [ get_parameter_value $outBitsPerSymbol ]
    set UseinError_value              [ get_parameter_value $UseinError]
    set UseoutError_value             [ get_parameter_value $UseoutError]
    set ChannelWidth_value            [ get_parameter_value $ChannelWidth ]
    set MaxChannel_value              [ get_parameter_value $MaxChannel ]
    
    set symbols_per_beat                1
    
    
    # +-----------------------------------
    # | connection point clock
    # | 
    add_interface clk clock end
    set_interface_property clk ENABLED true
    add_interface_port clk clk clk Input 1
    # | 
    # +-----------------------------------    
    # +-----------------------------------
    # | connection point reset
    # | 
    add_interface rst reset end
    set_interface_property rst ENABLED true
    set_interface_property rst associatedClock clk
    add_interface_port rst rst reset Input 1
    # | 
    # +-----------------------------------
    
    # +-----------------------------------
    # | Elaborate sink interface (cw_in)
    # +-----------------------------------
    
    add_interface cw_in avalon_streaming end

    set_interface_property cw_in ENABLED true
    set_interface_property cw_in associatedClock clk
    set_interface_property cw_in associatedReset rst
    set_interface_property cw_in beatsPerCycle 1
    set_interface_property cw_in dataBitsPerSymbol $inBitsPerSymbol_value
    set_interface_property cw_in maxChannel $MaxChannel_value
    set_interface_property cw_in readyLatency 0
    set_interface_property cw_in symbolsPerBeat $symbols_per_beat
    
    add_interface_port cw_in cw_in_sop startofpacket Input 1
    add_interface_port cw_in cw_in_eop endofpacket Input 1
    add_interface_port cw_in cw_in_valid valid Input 1
    add_interface_port cw_in cw_in_ready ready Output 1
    add_interface_port cw_in cw_in_error error Input 1
    add_interface_port cw_in cw_in_data data Input $inBitsPerSymbol_value
    
    if { $UseinError_value == 0} {
        set_port_property cw_in_error TERMINATION 1
        set_port_property cw_in_error TERMINATION_VALUE 0
    }

    
    # +-----------------------------------
    # | Elaborate source interface (cw_out)
    # +-----------------------------------

    add_interface cw_out avalon_streaming start
 
    set_interface_property cw_out ENABLED true
    set_interface_property cw_out associatedClock clk
    set_interface_property cw_out associatedReset rst
    set_interface_property cw_out beatsPerCycle 1
    set_interface_property cw_out dataBitsPerSymbol $outBitsPerSymbol_value
    set_interface_property cw_out maxChannel $MaxChannel_value
    set_interface_property cw_out readyLatency 0
    set_interface_property cw_out symbolsPerBeat $symbols_per_beat
    
    add_interface_port cw_out cw_out_sop startofpacket Output 1
    add_interface_port cw_out cw_out_eop endofpacket Output 1
    add_interface_port cw_out cw_out_valid valid Output 1
    add_interface_port cw_out cw_out_ready ready Input 1
    add_interface_port cw_out cw_out_error error Output 1
    add_interface_port cw_out cw_out_data data Output $outBitsPerSymbol_value
    set_port_property cw_out_data VHDL_TYPE STD_LOGIC_VECTOR

    
    if {$UseoutError_value == 0} {
        set_port_property cw_out_error TERMINATION 1
    }

   
    if {$ChannelWidth_value > 0} {
        add_interface_port cw_in cw_in_channel channel Input $ChannelWidth_value
        add_interface_port cw_out cw_out_channel channel Output $ChannelWidth_value
        set_port_property cw_in_channel VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property cw_out_channel VHDL_TYPE STD_LOGIC_VECTOR
    } else {
        add_interface_port cw_in cw_in_channel channel Input 1
        set_port_property cw_in_channel VHDL_TYPE STD_LOGIC_VECTOR
        add_interface_port cw_out cw_out_channel channel Output 1
        set_port_property cw_out_channel VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property  cw_in_channel TERMINATION 1
        set_port_property  cw_in_channel TERMINATION_VALUE 0
        set_port_property  cw_out_channel TERMINATION 1
    }   
    
}





