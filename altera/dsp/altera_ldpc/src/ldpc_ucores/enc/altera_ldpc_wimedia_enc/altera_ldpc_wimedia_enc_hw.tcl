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
source "altera_ldpc_wimedia_enc_utilities.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_ldpc_enc
# | 
set_module_property DESCRIPTION "Altera LDPC WiMedia Encoder"
set_module_property NAME altera_ldpc_wimedia_enc
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/LDPC"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "LDPC DVB Encoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersENC
add_module_parametersISVARRATE_HDL
set_module_property ELABORATION_CALLBACK elaborate

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_filesets altera_ldpc_wimedia_enc

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate {type entity} {

    set list_of_generated_file [generate_enc_ROM_rtl $entity]

    add_encrypted_file $type "altera_ldpc_pkg.sv" "../../../lib" 
    add_encrypted_file $type altera_ldpc_wimedia_enc.sv
    add_encrypted_file $type altera_ldpc_wimedia_enc.ocp
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Callbacks
# | 
proc elaborate {} {
    set isvarrate       [ get_parameter_value ISVARRATE ]
    set bitspersymbol      [ get_parameter_value BITSPERSYMBOL ]

    set in_data_width    $bitspersymbol
    set out_data_width   $bitspersymbol
    set in_fraglistwidth [expr $bitspersymbol+ 4*$isvarrate]

    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false

# | 
# +-----------------------------------
# | connection point in (avalon_streaming_sink)
# | 

dsp_add_streaming_interface in sink
set_interface_property in ENABLED true
set_interface_property in associatedClock clk
set_interface_property in associatedReset rst
dsp_set_interface_property in beatsPerCycle 1
dsp_set_interface_property in dataBitsPerSymbol $in_fraglistwidth
dsp_set_interface_property in readyLatency 0
dsp_set_interface_property in symbolsPerBeat 1

add_interface_port in in_startofpacket startofpacket Input 1
add_interface_port in in_endofpacket endofpacket Input 1
add_interface_port in in_valid valid Input 1
add_interface_port in in_ready ready Output 1



    set fraglist_in     [list ]
    if {$isvarrate == 1} {
        lappend fraglist_in in_rate 4
        if { [get_parameter_value design_env] eq {QSYS} } {
            send_message warning "in_data\[[expr $in_fraglistwidth-1]:0\] = \{in_rate\[3:0\] in_data\[[expr $in_data_width-1]:0\]\}"
        } 
    } else {
        add_interface_port end_ports in_rate export Input 4
    }
    lappend fraglist_in in_data $in_data_width 

    dsp_add_interface_port in in_datas data Input $in_fraglistwidth $fraglist_in

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
dsp_set_interface_property out dataBitsPerSymbol $out_data_width
dsp_set_interface_property out readyLatency 0
dsp_set_interface_property out symbolsPerBeat 1

add_interface_port out out_startofpacket startofpacket Output 1
add_interface_port out out_endofpacket endofpacket Output 1
add_interface_port out out_valid valid Output 1
add_interface_port out out_ready ready Input 1

set fraglist_out     [list ]
lappend fraglist_out out_data $out_data_width 

dsp_add_interface_port out out_data data Output $out_data_width $fraglist_out


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
