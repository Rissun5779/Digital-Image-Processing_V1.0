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
package require altera_hdl_wrapper 1.0

source "../../../lib/altera_rs_utilities.tcl"
source "../../../../../dsp/lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_syn
# | 
set_module_property DESCRIPTION "Altera Reed Solomon Serial Syndrome Generator"
set_module_property NAME altera_rs_ser_syn
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS Serial Syndrome Generator"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersSYN
set_module_property VALIDATION_CALLBACK validateDEC
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

    set forced_vect [list cw_in_channel]
    
    if {$use_dual_basis} {
        get_lists_of_alphas_and_dualbasis Alpha_to Inv_of T invT $bits_per_symbol $irrpol $dual_basis_of 1
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_syn [list [list Alpha_to $Alpha_to] [list ToStd $invT]] "" $forced_vect
    } else {
        get_lists_of_alphas Alpha_to Inv_of  $bits_per_symbol $irrpol
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_syn [list [list Alpha_to $Alpha_to]] "" $forced_vect
    }
    

    add_rs_package $type "../../.."

    add_encrypted_file $type altera_rs_ser_syn.sv
    add_encrypted_file $type altera_rs_ser_syn.ocp

}
# | 
# +-----------------------------------

proc _get_empty_width { symbolsPerBeat } {
    set empty_width [ expr int(ceil(log($symbolsPerBeat) / log(2))) ]
    return $empty_width
}

# +-----------------------------------
# | Callbacks
# | 


proc elaborate {} {
    
    set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]
    set check               [ get_parameter_value CHECK ]
    set n                   [ get_parameter_value N ]
    set min_n               [ get_parameter_value MIN_N ]
    set channel             [ get_parameter_value CHANNEL ]
    set erasure             [ get_parameter_value ERASURE ]
    set varn                [ get_parameter_value VARN ]
    set varcheck            [ get_parameter_value VARCHECK ]
    set usenumn   	        [ get_parameter_value USENUMN ]
    
    
    set syn_datawidth       [ expr $bits_per_symbol*$check ] 
    set eracnt_datawidth    [ expr int(ceil(log($check+1)/log(2))) ]
    set max_channel         [ expr $channel - 1 ]
    set n_width             [ expr int(ceil(log($n+1) / log(2))) ]
    set check_width         [ expr int(ceil(log($check+1) / log(2))) ]

  

    if {$channel == 1} {
        set channel_width 1
    } else {
        set channel_width [ expr int(ceil(log($channel) / log(2))) ]
    }
    
    
    set syn_in_datawidth   [ expr $bits_per_symbol + $check_width*$varcheck + $n_width*$usenumn] 
    set syn_out_datawidth  [ expr $syn_datawidth +  ($syn_datawidth + $eracnt_datawidth)*$erasure + $check_width*$varcheck + $n_width*$varn]



    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false

    # +-----------------------------------
    # | Elaborate sink interface (cw_in)
    # +-----------------------------------
	add_interface cw_in avalon_streaming end

    set_interface_property cw_in ENABLED true
    set_interface_property cw_in associatedClock clk
    set_interface_property cw_in associatedReset rst
	set_interface_property cw_in symbolsPerBeat 1   
    set_interface_property cw_in dataBitsPerSymbol $syn_in_datawidth
    set_interface_property cw_in maxChannel $max_channel
	set_interface_property cw_in beatsPerCycle 1
    set_interface_property cw_in readyLatency 0
    
    add_interface_port cw_in cw_in_sop startofpacket Input 1
    add_interface_port cw_in cw_in_eop endofpacket Input 1
    add_interface_port cw_in cw_in_valid valid Input 1
    add_interface_port cw_in cw_in_ready ready Output 1
    addPort cw_in cw_in_channel channel Input $channel_width "$channel == 1" 0

  	if {$erasure} {
		add_interface_port cw_in cw_in_erasure error Input 1
	} else {
		add_interface_port end_ports cw_in_erasure export Input 1
	}  

	set fraglist_in     [list ]
    if {$usenumn} {
        lappend fraglist_in cw_in_numn $n_width
    } else {
        add_interface_port end_ports cw_in_numn export Input $n_width
    }  
    if {$varcheck} {
        lappend fraglist_in cw_in_numcheck $check_width
    } else {
        add_interface_port end_ports cw_in_numcheck export Input $check_width
    } 
	lappend fraglist_in cw_in_data $bits_per_symbol

 	add_interface_port cw_in cw_in_datas data Input $syn_in_datawidth
	set_port_property cw_in_datas fragment_list [build_fragment_list $fraglist_in]   

    # +-----------------------------------
    # | Elaborate source interface (syn_out)
    # +-----------------------------------
  	add_interface syn_out avalon_streaming start

    set_interface_property syn_out ENABLED true
    set_interface_property syn_out associatedClock clk
    set_interface_property syn_out associatedReset rst
    set_interface_property syn_out symbolsPerBeat 1
    set_interface_property syn_out dataBitsPerSymbol $syn_out_datawidth
    set_interface_property syn_out maxChannel 0
	set_interface_property syn_out beatsPerCycle 1
    set_interface_property syn_out readyLatency 0
    
    add_interface_port syn_out syn_out_sop startofpacket Output 1
    add_interface_port syn_out syn_out_eop endofpacket Output 1
    add_interface_port syn_out syn_out_valid valid Output 1
    add_interface_port syn_out syn_out_ready ready Input 1

    
	set fraglist_out     [list ]
	if {$varn} {
		lappend fraglist_out syn_out_numn $n_width
	} else {
		add_interface_port end_ports syn_out_numn export Output $n_width
	}
	if {$varcheck} {
		lappend fraglist_out syn_out_numcheck $check_width
	} else {
		add_interface_port end_ports syn_out_numcheck export Output $check_width
	}
	if {$erasure} {
		lappend fraglist_out syn_out_eracnt $eracnt_datawidth syn_out_erapos $syn_datawidth
	} else {
		add_interface_port end_ports syn_out_eracnt export Output $eracnt_datawidth
		add_interface_port end_ports syn_out_erapos export Output $syn_datawidth
	}
	lappend fraglist_out syn_out_synd $syn_datawidth
	add_interface_port syn_out syn_out_data data Output $syn_out_datawidth
	set_port_property syn_out_data fragment_list [build_fragment_list $fraglist_out]


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
        if {$pWidth>1} {
    	    set_port_property $pName VHDL_TYPE STD_LOGIC_VECTOR
        }
        if { [ expr $termComparison ] == 1 } {
            set_port_property $pName termination true
            set_port_property $pName termination_value $termValue
        }
    }
}



