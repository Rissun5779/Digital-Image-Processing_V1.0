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


package require -exact qsys 13.1
package require altera_hdl_wrapper 1.0

source "../../lib/altera_rs_utilities.tcl"
source "../../../../dsp/lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_enc
# | 
set_module_property DESCRIPTION "Altera Reed Solomon II Serial Encoder"
set_module_property NAME altera_rs_ser_enc
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS II Serial Encoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersENC
set_module_property VALIDATION_CALLBACK validateENC
set_module_property ELABORATION_CALLBACK elaborate

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_filesets

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate {type entity lang} {
	set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]
    set irrpol              [ get_parameter_value IRRPOL ]
    set use_dual_basis      [ get_parameter_value USEDUALBASIS ]
    set dual_basis_of       [ get_parameter_value DUALBASISOF ]

    if {$use_dual_basis} {
        get_lists_of_alphas_and_dualbasis Alpha_to Inv_of T invT $bits_per_symbol $irrpol $dual_basis_of 1
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_enc [list [list Alpha_to $Alpha_to] [list ToDual $T] [list ToStd $invT]]
    } else {
        get_lists_of_alphas Alpha_to Inv_of  $bits_per_symbol $irrpol
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_enc [list [list Alpha_to $Alpha_to]]
    }

    add_rs_package $type "../.."

    add_encrypted_file $type altera_rs_ser_enc.sv
    add_encrypted_file $type altera_rs_ser_enc.ocp
}
# | 
# +-----------------------------------


# +-----------------------------------
# | Callbacks
# | 
proc elaborate {} {

    set bits_per_symbol [ get_parameter_value BITSPERSYMBOL ]
    set channel         [ get_parameter_value CHANNEL ]
    set max_channel_nb  [ expr $channel - 1 ]
    set varcheck        [ get_parameter_value VARCHECK ]
    set check           [ get_parameter_value CHECK ]
    set check_width     [ expr int(ceil(log($check+1) / log(2))) ]

    if { $channel==1 } {
        set channel_width 1
    } else {
        set channel_width [ expr int(ceil(log($channel) / log(2))) ]
    }
    
    set in_datas_width [ expr $bits_per_symbol +  $check_width*$varcheck ]
    
	# | 
	# +-----------------------------------
	# | connection point in (avalon_streaming_sink)
	# | 

	dsp_add_streaming_interface in sink
	set_interface_property in ENABLED true
	set_interface_property in associatedClock clk
	set_interface_property in associatedReset rst
	dsp_set_interface_property in beatsPerCycle 1
	dsp_set_interface_property in dataBitsPerSymbol $in_datas_width
	dsp_set_interface_property in maxChannel $max_channel_nb
	dsp_set_interface_property in readyLatency 0
	dsp_set_interface_property in symbolsPerBeat 1

	add_interface_port in in_startofpacket startofpacket Input 1
	add_interface_port in in_endofpacket endofpacket Input 1
	add_interface_port in in_valid valid Input 1
	add_interface_port in in_ready ready Output 1
	addPort in in_channel channel Input $channel_width "$channel == 1" 0

	set fraglist_in     [list ]
	if {$varcheck} {     
		lappend  fraglist_in numcheck $check_width                                                                                                
	} else {   
    	add_interface end_ports conduit end
    	set_interface_property end_ports ENABLED false
	    add_interface_port end_ports numcheck export Input $check_width
	}
	
	lappend fraglist_in data $bits_per_symbol 

	dsp_add_interface_port in in_datas data Input $in_datas_width $fraglist_in


	# | 
	# +-----------------------------------

	# +-----------------------------------
	# | connection point out (avalon_streaming_source)
	# | 

	add_interface out avalon_streaming start
	set_interface_property out ENABLED true
	set_interface_property out associatedClock clk
	set_interface_property out associatedReset rst
	set_interface_property out beatsPerCycle 1
	set_interface_property out dataBitsPerSymbol $bits_per_symbol
	set_interface_property out maxChannel $max_channel_nb
	set_interface_property out readyLatency 0
	set_interface_property out symbolsPerBeat 1

	add_interface_port out out_startofpacket startofpacket Output 1
	add_interface_port out out_endofpacket endofpacket Output 1
	add_interface_port out out_valid valid Output 1
	add_interface_port out out_ready ready Input 1
	add_interface_port out out_data data Output $bits_per_symbol
	addPort out out_channel channel Output $channel_width "$channel == 1" 0

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


proc addPort { iface pName pRole pDir pWidth termComparison termValue } {

    if { $pWidth != 0 } {
        add_interface_port $iface $pName $pRole $pDir $pWidth
        if { $pWidth>1} {
		    set_port_property $pName VHDL_TYPE STD_LOGIC_VECTOR
        }
        if { [ expr $termComparison ] == 1 } {
            set_port_property $pName termination true
            set_port_property $pName termination_value $termValue
        }
    }
}

