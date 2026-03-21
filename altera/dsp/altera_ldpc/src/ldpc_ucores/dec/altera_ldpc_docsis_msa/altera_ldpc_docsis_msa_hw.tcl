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


# (C) 2001-2014 Altera Corporation. All rights reserved.
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

source "../../../../src/lib/altera_ldpc_utilities.tcl"
source "../../../../../lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_transaction_format_adapter
# | 
set_module_property DESCRIPTION "Altera LDPC DOCSIS MSA"
set_module_property NAME altera_ldpc_docsis_msa
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/LDPC/Submodules"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "LDPC DOCSIS Decoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersDEC
#set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

add_filesets altera_ldpc_docsis_msa

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate {type entity} {
    
    add_encrypted_file $type "altera_ldpc_pkg.sv" "../../../lib" 
    add_encrypted_file $type altera_ldpc_docsis_mat.sv
    add_encrypted_file $type altera_ldpc_docsis_msa.sv
    add_encrypted_file $type altera_ldpc_docsis_msa.ocp

}


# +-----------------------------------
# | Callbacks
# | 


proc elaborate {} {

    set N                [ get_parameter_value N ]
    set bitspersymbol    [ get_parameter_value BITSPERSYMBOL ]
    set softbits         [ get_parameter_value SOFTBITS ]
	set isvarrate        [ get_parameter_value ISVARRATE ]
	
	
    set in_data_width    [expr $bitspersymbol*$softbits]
    set out_data_width   [expr $bitspersymbol]
    set in_fraglistwidth [expr $in_data_width+ 3*$isvarrate]
    
    
    
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
    dsp_add_streaming_interface cw_in sink

    set_interface_property cw_in ENABLED true
    set_interface_property cw_in associatedClock clk
    set_interface_property cw_in associatedReset rst
    dsp_set_interface_property cw_in dataBitsPerSymbol $in_fraglistwidth
    dsp_set_interface_property cw_in beatsPerCycle 1
    dsp_set_interface_property cw_in readyLatency 0
    dsp_set_interface_property cw_in symbolsPerBeat 1
    
    add_interface_port cw_in cw_in_sop startofpacket Input 1
    add_interface_port cw_in cw_in_eop endofpacket Input 1
    add_interface_port cw_in cw_in_valid valid Input 1
    add_interface_port cw_in cw_in_ready ready Output 1

    set fraglist_in     [list ]
    if {$isvarrate == 1} {
        lappend fraglist_in cw_in_number 3
    }
    lappend fraglist_in cw_in_data $in_data_width 
    if { [get_parameter_value design_env] eq {QSYS} } {
        send_message warning "in_data\[[expr $in_fraglistwidth-1]:0\] = \{cw_in_number\[2:0\] cw_in_data\[[expr $in_data_width-1]:0\]\}"
    }
    dsp_add_interface_port cw_in cw_in_datas data Input $in_fraglistwidth $fraglist_in
    
    
    
    # +-----------------------------------
    # | Elaborate source interface (cw_out)
    # +-----------------------------------

    dsp_add_streaming_interface cw_out start
 
    set_interface_property cw_out ENABLED true
    set_interface_property cw_out associatedClock clk
    set_interface_property cw_out associatedReset rst
    dsp_set_interface_property cw_out dataBitsPerSymbol $out_data_width
    dsp_set_interface_property cw_out beatsPerCycle 1
    dsp_set_interface_property cw_out readyLatency 0
    dsp_set_interface_property cw_out symbolsPerBeat 1
    
    add_interface_port cw_out cw_out_sop startofpacket Output 1
    add_interface_port cw_out cw_out_eop endofpacket Output 1
    add_interface_port cw_out cw_out_valid valid Output 1
    add_interface_port cw_out cw_out_ready ready Input 1
    add_interface_port cw_out cw_out_data data Output $out_data_width
    set_port_property  cw_out_data VHDL_TYPE STD_LOGIC_VECTOR

}





