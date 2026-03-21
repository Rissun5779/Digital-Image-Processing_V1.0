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


# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package require -exact qsys 14.0

source "../../../lib/altera_ldpc_utilities.tcl"
source "../../../../../lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_ldpc_enc
# | 
set_module_property DESCRIPTION "Altera LDPC DVB Encoder"
set_module_property NAME altera_ldpc_dvb_enc
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/LDPC"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "LDPC DVB Encoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersENC
set_module_property ELABORATION_CALLBACK elaborate

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_filesets altera_ldpc_dvb_enc

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate {type entity} {
    add_encrypted_file $type altera_ldpc_dvb_enc_mat.sv
	add_encrypted_file $type altera_ldpc_dvb_enc.sv
    add_encrypted_file $type altera_ldpc_dvb_enc.ocp
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Callbacks
# | 
proc elaborate {} {

    set data_width      [ get_parameter_value BITSPERSYMBOL ]
    set channel         [ get_parameter_value CHANNEL ]
    set max_channel_nb  [ expr $channel - 1 ]

    if { $channel==1 } {
        set channel_width 1
    } else {
        set channel_width [ expr int(ceil(log($channel) / log(2))) ]
    }
    
# | 
# +-----------------------------------
# | connection point in (avalon_streaming_sink)
# | 
dsp_add_streaming_interface in sink
set_interface_property in ENABLED true
set_interface_property in associatedClock clk
set_interface_property in associatedReset rst
dsp_set_interface_property in beatsPerCycle 1
dsp_set_interface_property in dataBitsPerSymbol $data_width
dsp_set_interface_property in maxChannel $max_channel_nb
dsp_set_interface_property in readyLatency 0
dsp_set_interface_property in symbolsPerBeat 1

add_interface_port in in_startofpacket startofpacket Input 1
add_interface_port in in_endofpacket endofpacket Input 1
add_interface_port in in_valid valid Input 1
add_interface_port in in_ready ready Output 1
add_interface_port in in_data data Input $data_width

addPort in in_channel channel Input $channel_width "$channel == 1" 0
set_port_property in_channel VHDL_TYPE STD_LOGIC_VECTOR



# | 
# +-----------------------------------

# +-----------------------------------
# | connection point out (avalon_streaming_source)
# | 
dsp_add_streaming_interface out source
set_interface_property out ENABLED true
set_interface_property out associatedClock clk
set_interface_property out associatedReset rst
dsp_set_interface_property out beatsPerCycle 1
dsp_set_interface_property out dataBitsPerSymbol $data_width
dsp_set_interface_property out maxChannel $max_channel_nb
dsp_set_interface_property out readyLatency 0
dsp_set_interface_property out symbolsPerBeat 1

add_interface_port out out_startofpacket startofpacket Output 1
add_interface_port out out_endofpacket endofpacket Output 1
add_interface_port out out_valid valid Output 1
add_interface_port out out_ready ready Input 1
add_interface_port out out_data data Output $data_width

addPort out out_channel channel Output $channel_width "$channel == 1" 0
set_port_property out_channel VHDL_TYPE STD_LOGIC_VECTOR

set fraglist_out     [list ]
lappend fraglist_out out_data $data_width 

dsp_add_interface_port out out_data data Output $data_width $fraglist_out


# | 
# +-----------------------------------
}


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
# Add Port Function
# |
# |
proc addPort { iface pName pRole pDir pWidth termComparison termValue } {

    if { $pWidth != 0 } {
        add_interface_port $iface $pName $pRole $pDir $pWidth

        if { [ expr $termComparison ] == 1 } {
            set_port_property $pName termination true
            set_port_property $pName termination_value $termValue
        }
    }
}
# | 
