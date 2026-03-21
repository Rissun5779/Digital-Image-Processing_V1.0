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
# | module altera_rs_par_steering
# | 
set_module_property DESCRIPTION "Altera Reed Solomon Search"
set_module_property NAME altera_rs_ser_search
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS Serial Error Search"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersSEARCH
set_module_property VALIDATION_CALLBACK validateBM
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
    
    set forced_vect [list sch_out_channel]
    
    if {$use_dual_basis} {
        get_lists_of_alphas_and_dualbasis Alpha_to Inv_of T invT $bits_per_symbol $irrpol $dual_basis_of 0
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_search [list [list Alpha_to $Alpha_to] [list Inv_of $Inv_of] [list ToDual $T]] "" $forced_vect
    } else {
        get_lists_of_alphas Alpha_to Inv_of  $bits_per_symbol $irrpol
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_search [list [list Alpha_to $Alpha_to] [list Inv_of $Inv_of]] "" $forced_vect
    }
    

    add_rs_package $type "../../.."

    add_encrypted_file $type altera_rs_ser_search.sv
    # add_encrypted_file $type altera_rs_ser_search.ocp

    
 
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Callbacks
# | 

proc elaborate {} {

    set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]
    set check               [ get_parameter_value CHECK ]
    set n                   [ get_parameter_value N ]
    set channel             [ get_parameter_value CHANNEL ]
    set erasure             [ get_parameter_value ERASURE ]
    set varn                [ get_parameter_value VARN ]
    set optimizelatency     [ get_parameter_value OPTIMIZE_LATENCY ]
    
    if {$erasure == 1} {
        set error_symbols        $check
    } else {
        set error_symbols        [expr int($check/2) ]
    }    
    set root_list_size           [expr $error_symbols*$bits_per_symbol]
    
    set err_cnt_width        [ expr int(ceil(log($error_symbols+1) / log(2))) ]    
    set poly_datawidth       [ expr $bits_per_symbol*$error_symbols  ]
    set n_width              [ expr int(ceil(log($n+1) / log(2))) ]    
    
    
    set max_channel          [ expr $channel - 1 ]
    if {$channel == 1} {
        set channel_width 1
    } else {
        set channel_width    [ expr int(ceil(log($channel) / log(2))) ]
    }

    set bm_in_datawidth      [ expr 2 * $poly_datawidth + $err_cnt_width + ($n_width + $optimizelatency*2*$root_list_size)*$varn]
    set sch_out_datawidth        [ expr $bits_per_symbol + 1 + $err_cnt_width ] 

    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false
      
    # +-----------------------------------
    # | Elaborate sink interface (bm_in)
    # +-----------------------------------
    add_interface bm_in avalon_streaming end

    set_interface_property bm_in ENABLED true
    set_interface_property bm_in associatedClock clk
    set_interface_property bm_in associatedReset rst
    set_interface_property bm_in beatsPerCycle   1
    set_interface_property bm_in dataBitsPerSymbol $bm_in_datawidth
    set_interface_property bm_in maxChannel      0
    set_interface_property bm_in readyLatency    0
    set_interface_property bm_in symbolsPerBeat  1
    
    
    add_interface_port bm_in bm_in_sop startofpacket Input 1
    add_interface_port bm_in bm_in_eop endofpacket Input 1
    add_interface_port bm_in bm_in_valid valid Input 1
    add_interface_port bm_in bm_in_ready ready Output 1

    set fraglist_in     [list ]
    if {$varn} {
        if {$optimizelatency} {
            lappend fraglist_in bm_in_locrootini $root_list_size bm_in_evalrootini $root_list_size
        } else {
            add_interface_port end_ports bm_in_locrootini export Input $root_list_size
            add_interface_port end_ports bm_in_evalrootini export Input $root_list_size        
        }
        lappend fraglist_in  bm_in_numn $n_width
    } else {
        add_interface_port end_ports bm_in_locrootini export Input $root_list_size
        add_interface_port end_ports bm_in_evalrootini export Input $root_list_size
        add_interface_port end_ports bm_in_numn export Input $n_width
    }
    lappend fraglist_in bm_in_error_count $err_cnt_width bm_in_error_evaluator $poly_datawidth bm_in_error_locator $poly_datawidth
    
    add_interface_port bm_in bm_in_data data Input $bm_in_datawidth
    set_port_property bm_in_data fragment_list [build_fragment_list $fraglist_in]  

    # +-----------------------------------
    # | Elaborate source interface (sch_out)
    # +-----------------------------------
    add_interface sch_out avalon_streaming start

    set_interface_property sch_out ENABLED true
    set_interface_property sch_out associatedClock clk
    set_interface_property sch_out associatedReset rst
    set_interface_property sch_out beatsPerCycle   1
    set_interface_property sch_out dataBitsPerSymbol $sch_out_datawidth
    set_interface_property sch_out maxChannel      $max_channel
    set_interface_property sch_out readyLatency    0
    set_interface_property sch_out symbolsPerBeat  1
    
    
    add_interface_port sch_out sch_out_sop startofpacket Output 1
    add_interface_port sch_out sch_out_eop endofpacket Output 1
    add_interface_port sch_out sch_out_valid valid Output 1
    add_interface_port sch_out sch_out_error error Output 1
    add_interface_port sch_out sch_out_ready ready Input 1
    addPort sch_out sch_out_channel channel Output $channel_width "$channel == 1" 0
                              
    set fraglist_out     [list  sch_out_error_count $err_cnt_width sch_out_error_magnitude $bits_per_symbol sch_out_error_location 1]

     add_interface_port sch_out sch_out_data data Output $sch_out_datawidth
    set_port_property sch_out_data fragment_list [build_fragment_list $fraglist_out] 
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




