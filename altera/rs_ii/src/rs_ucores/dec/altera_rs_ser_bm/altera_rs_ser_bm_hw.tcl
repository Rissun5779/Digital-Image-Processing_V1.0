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
# | module altera_rs_ser_bm
# | 
set_module_property DESCRIPTION "Altera Reed Solomon Serial Berlekamp-Massey"
set_module_property NAME altera_rs_ser_bm
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/Reed Solomon II/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "RS Serial Berlekamp-Massey"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersBM
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
    set n                   [ get_parameter_value N ]
    set varn                [ get_parameter_value VARN ]
    set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]
    set irrpol              [ get_parameter_value IRRPOL ]
    set genstart            [ get_parameter_value GENSTART ]
    set rootspace           [ get_parameter_value ROOTSPACE ]
    set check               [ get_parameter_value CHECK ]
    set erasure             [ get_parameter_value ERASURE ]
    set optimizelatency     [ get_parameter_value OPTIMIZE_LATENCY ]
    # optional parameter change accordingly in the rtl
    set useROM              [ get_parameter_value USEROM ]
    set minn                [ get_parameter_value MIN_N ]
    
    if {$erasure == 1} {
        set error_symbols        $check
    } else {
        set error_symbols        [expr int($check/2) ]
    }
    

    add_rs_package $type "../../.."

    add_encrypted_file $type altera_rs_ser_bm.sv
    add_encrypted_file $type altera_rs_ser_bm.ocp 
    
    if {$varn==1 && $optimizelatency==1} {
        if {$useROM == 0} {
            get_lists_of_alphas Alpha_to Inv_of  $bits_per_symbol $irrpol
            add_rs_hex_wrapper $type $entity $lang altera_rs_ser_bm [list [list Alpha_to $Alpha_to] [list Inv_of $Inv_of]]
        } else {
            get_lists_of_alphas_and_roots Alpha_to Inv_of Locroot Evalroots $bits_per_symbol $irrpol $genstart $rootspace $error_symbols $n $minn
            add_rs_hex_wrapper $type $entity $lang altera_rs_ser_bm [list [list Alpha_to $Alpha_to] [list Inv_of $Inv_of] [list Locroot $Locroot]  [list Evalroots $Evalroots] ]
        }
    } else {
        get_lists_of_alphas Alpha_to Inv_of  $bits_per_symbol $irrpol
        add_rs_hex_wrapper $type $entity $lang altera_rs_ser_bm [list [list Inv_of $Inv_of]]
    }
}



# | 
# +-----------------------------------

# +-----------------------------------

proc elaborate {} {

    set bits_per_symbol        [ get_parameter_value BITSPERSYMBOL ]
    set check                  [ get_parameter_value CHECK ]
    set n                      [ get_parameter_value N ]
    set erasure                [ get_parameter_value ERASURE ]
    set varcheck               [ get_parameter_value VARCHECK ]
    set varn                   [ get_parameter_value VARN ]
    set optimizelatency        [ get_parameter_value OPTIMIZE_LATENCY ]
    
    if {$erasure == 1} {
        set error_symbols        $check
    } else {
        set error_symbols        [expr int($check/2) ]
    }
    set root_list_size           [expr $error_symbols*$bits_per_symbol]
    
    set synd_width        [ expr $bits_per_symbol*$check ]
    set err_cnt_width        [ expr int(ceil(log($error_symbols+1) / log(2))) ]
    set era_cnt_width        [ expr int(ceil(log($check+1) / log(2))) ]
    set poly_datawidth       [ expr $bits_per_symbol*$error_symbols ]
    set n_width              [ expr int(ceil(log($n+1) / log(2))) ]
    set check_width          [ expr int(ceil(log($check+1) / log(2))) ]
    

    set syn_in_datawidth    [expr  $synd_width + ($synd_width + $era_cnt_width)*$erasure + $check_width*$varcheck + $n_width*$varn]
    set bm_out_datawidth    [ expr 2 * $poly_datawidth + $err_cnt_width + ($n_width + $optimizelatency*2*$root_list_size)*$varn]

    
    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false

    # +-----------------------------------
    # | Elaborate sink interface (syn_in)
    # +-----------------------------------
    add_interface syn_in avalon_streaming end

    set_interface_property syn_in ENABLED true
    set_interface_property syn_in associatedClock clk
    set_interface_property syn_in associatedReset rst
    set_interface_property syn_in beatsPerCycle 1
    set_interface_property syn_in dataBitsPerSymbol $syn_in_datawidth
    set_interface_property syn_in maxChannel 0
    set_interface_property syn_in readyLatency 0
    set_interface_property syn_in symbolsPerBeat 1
    
    add_interface_port syn_in syn_in_sop startofpacket Input 1
    add_interface_port syn_in syn_in_eop endofpacket Input 1
    add_interface_port syn_in syn_in_valid valid Input 1
    add_interface_port syn_in syn_in_ready ready Output 1


    set fraglist_in     [list ]
    if {$varn} {
        lappend fraglist_in syn_in_numn $n_width
    } else {
        add_interface_port end_ports syn_in_numn export Input $n_width
    }
    if {$varcheck} {
        lappend fraglist_in syn_in_numcheck $check_width
    } else {
        add_interface_port end_ports syn_in_numcheck export Input $check_width
    }
    if {$erasure} {
        lappend fraglist_in syn_in_eracnt $era_cnt_width syn_in_erapos $synd_width
    } else {
        add_interface_port end_ports syn_in_eracnt export Input $era_cnt_width
        add_interface_port end_ports syn_in_erapos export Input $synd_width
    }
    lappend fraglist_in syn_in_synd $synd_width

    add_interface_port syn_in syn_in_data data Input $syn_in_datawidth
    set_port_property syn_in_data fragment_list [build_fragment_list $fraglist_in]

    # +-----------------------------------
    # | Elaborate source interface (bm_out)
    # +-----------------------------------
    add_interface bm_out avalon_streaming start

    set_interface_property bm_out ENABLED true
    set_interface_property bm_out associatedClock clk
    set_interface_property bm_out associatedReset rst
    set_interface_property bm_out beatsPerCycle 1
    set_interface_property bm_out dataBitsPerSymbol $bm_out_datawidth 
    set_interface_property bm_out maxChannel 0
    set_interface_property bm_out readyLatency 0
    set_interface_property bm_out symbolsPerBeat 1 
    
    
    add_interface_port bm_out bm_out_sop startofpacket Output 1
    add_interface_port bm_out bm_out_eop endofpacket Output 1
    add_interface_port bm_out bm_out_valid valid Output 1
    add_interface_port bm_out bm_out_ready ready Input 1
 

    set fraglist_out     [list ]
    if {$varn} {
        if {$optimizelatency} {
            lappend fraglist_out bm_out_locrootini $root_list_size bm_out_evalrootini $root_list_size
        } else {
            add_interface_port end_ports bm_out_locrootini  export Output $root_list_size
            add_interface_port end_ports bm_out_evalrootini export Output $root_list_size        
        }
        lappend fraglist_out  bm_out_numn $n_width
    } else {
        add_interface_port end_ports bm_out_locrootini   export Output $root_list_size
        add_interface_port end_ports  bm_out_evalrootini export Output $root_list_size
        add_interface_port end_ports bm_out_numn         export Output $n_width
    }
    lappend fraglist_out bm_out_error_count $err_cnt_width bm_out_error_evaluator $poly_datawidth bm_out_error_locator $poly_datawidth

    add_interface_port bm_out bm_out_data data Output $bm_out_datawidth
    set_port_property bm_out_data fragment_list [build_fragment_list $fraglist_out]

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

