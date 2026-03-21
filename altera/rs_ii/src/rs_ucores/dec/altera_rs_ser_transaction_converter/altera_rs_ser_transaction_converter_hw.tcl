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
source "../../../../../dsp/lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_transaction_format_adapter
# | 
set_module_property DESCRIPTION "Altera Reed Solomon Serial Transaction Converter"
set_module_property NAME altera_rs_ser_transaction_converter
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS Serial Transaction Converter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersCONVERTOR
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

add_filesets altera_rs_ser_transaction_converter

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
    add_encrypted_file $type altera_rs_ser_transaction_converter.sv
    add_encrypted_file $type altera_rs_ser_transaction_converter.ocp
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 


# +-----------------------------------
# | Validate
# | 

proc validate {} {
}

# +-----------------------------------
# | Callbacks
# | 


proc elaborate {} {

    
  	set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]
    set check               [ get_parameter_value CHECK ]
    set n                   [ get_parameter_value N ]
    set channel             [ get_parameter_value CHANNEL ]
    set erasure             [ get_parameter_value ERASURE ]
    set varcheck            [ get_parameter_value VARCHECK ]
	set usenumn   	        [ get_parameter_value USENUMN ]
   #set [get_parameter_value design_env] 
    
    set max_channel         [ expr $channel - 1 ]
    set n_width             [ expr int(ceil(log($n+1) / log(2))) ]
    set check_width         [ expr int(ceil(log($check+1) / log(2))) ]
    
    

    if {$channel == 1} {
        set channel_width 1
    } else {
        set channel_width [ expr int(ceil(log($channel) / log(2))) ]
    }
    
    
    set datawidth    [ expr $bits_per_symbol + $check_width*$varcheck + $n_width*$usenumn] 
 

    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false

    # +-----------------------------------
    # | Elaborate sink interface (in)
    # +-----------------------------------
	dsp_add_streaming_interface in sink

    set_interface_property in ENABLED true
    set_interface_property in associatedClock clk
    set_interface_property in associatedReset rst
	dsp_set_interface_property in symbolsPerBeat 1   
    dsp_set_interface_property in dataBitsPerSymbol $datawidth
    dsp_set_interface_property in maxChannel $max_channel
	dsp_set_interface_property in beatsPerCycle 1
    dsp_set_interface_property in readyLatency 0
    
    add_interface_port in in_sop startofpacket Input 1
    add_interface_port in in_eop endofpacket Input 1
    add_interface_port in in_valid valid Input 1
    add_interface_port in in_ready ready Output 1
    addPort in in_channel channel Input $channel_width "$channel == 1" 0

  	if {$erasure} {
		add_interface_port in in_erasure error Input 1
	} else {
		add_interface_port end_ports in_erasure export Input 1
	}  

	set fraglist_in     [list ]
    if {$usenumn} {
        lappend fraglist_in numn $n_width
    } else {
        add_interface_port end_ports numn export Input $n_width
	    #add_interface_port in numn data Input $n_width 
		#set_port_property numn VHDL_TYPE STD_LOGIC_VECTOR
        #set_port_property numn TERMINATION 1
    }  
    if {$varcheck} {
        lappend fraglist_in numcheck $check_width
    } else {
        add_interface_port end_ports numcheck export Input $check_width
		#add_interface_port in numcheck data Input $check_width 
		#set_port_property numcheck VHDL_TYPE STD_LOGIC_VECTOR
        #set_port_property numcheck TERMINATION 1
    } 
	lappend fraglist_in data $bits_per_symbol 

	dsp_add_interface_port in in_datas data Input $datawidth $fraglist_in



    # +-----------------------------------
    # | Elaborate source interface (out)
    # +-----------------------------------
  	add_interface out avalon_streaming start

    set_interface_property out ENABLED true
    set_interface_property out associatedClock clk
    set_interface_property out associatedReset rst
    set_interface_property out symbolsPerBeat 1
    set_interface_property out dataBitsPerSymbol $datawidth
    set_interface_property out maxChannel 0
	set_interface_property out beatsPerCycle 1
    set_interface_property out readyLatency 0
    
    add_interface_port out out_sop startofpacket Output 1
    add_interface_port out out_eop endofpacket Output 1
    add_interface_port out out_valid valid Output 1
    add_interface_port out out_ready ready Input 1
	addPort out out_channel channel Output $channel_width "$channel == 1" 0

  	if {$erasure} {
		add_interface_port out out_erasure error Output 1
	} else {
		add_interface_port end_ports out_erasure export Output 1
	} 

	add_interface_port out out_data data Output $datawidth



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
    	set_port_property $pName VHDL_TYPE STD_LOGIC_VECTOR
        if { [ expr $termComparison ] == 1 } {
            set_port_property $pName termination true
            set_port_property $pName termination_value $termValue
        }
    }
}






