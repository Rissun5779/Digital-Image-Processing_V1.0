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

source "../../lib/altera_ldpc_utilities.tcl"
source "../../../../lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_dec
# |
set_module_property NAME altera_ldpc_dec
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/LDPC"
set_module_property DISPLAY_NAME "LDPC Decoder"
set_module_property DESCRIPTION "Altera LDPC Decoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersDEC
#set_module_property VALIDATION_CALLBACK validateDEC
set_module_property COMPOSITION_CALLBACK compose


# +-----------------------------------
# | Callbacks
# | 

proc compose {} {
    set n                   [ get_parameter_value N ]
    set bitspersymbol       [ get_parameter_value BITSPERSYMBOL ]
    set softbits            [ get_parameter_value SOFTBITS ]
    set channel             [ get_parameter_value CHANNEL ]
    set att                 [ get_parameter_value ATTENUATION]
    set nbcheckgroup        [ get_parameter_value NBCHECKGROUP]
    set nbvargroup          [ get_parameter_value NBVARGROUP]
    set nbite               [ get_parameter_value NB_ITE]
    set type                [ get_parameter_value LDPC_TYPE]
    set transmitparity      [ get_parameter_value TRANSMIT_PARITY]
    set softbits_msa        [ get_parameter_value S]
    set isfull              [ get_parameter_value ISFULLSTREAMING ]
    set islayered           [ get_parameter_value ISLAYERED ]
    set isvarrate           [ get_parameter_value ISVARRATE ]
    set par                 [ get_parameter_value PAR ]
    set extralatency        [ get_parameter_value EXTRALATENCY ]
    

    # Clock Rest Source
    add_instance clk_rst clock_source
    set_instance_parameter clk_rst resetSynchronousEdges DEASSERT
    set_instance_parameter clk_rst clockFrequencyKnown "false"
    
    # suppress this warning:
    # Warning: rs.clk_rst: The input clock frequency must be known or set by the parent if this is a subsystem.
    set_instance_property clk_rst SUPPRESS_ALL_WARNINGS true
    
    
    # Clock
    add_interface clk clock end
    set_interface_property clk export_of clk_rst.clk_in
    # Reset
    add_interface rst reset end
    set_interface_property rst export_of clk_rst.clk_in_reset

    
    # MSA
    if {$type=="NASA"} {
        add_instance dec_msa altera_ldpc_nasa_msa
        set_instance_parameter dec_msa ISFULLSTREAMING  $isfull
    }
    if {$type=="DOCSIS"} {
        add_instance dec_msa altera_ldpc_docsis_msa
        set_instance_parameter dec_msa ISVARRATE  1
        set_instance_parameter dec_msa EXTRALATENCY  $extralatency
    }
    if {$type=="DVB"} {
        add_instance dec_msa altera_ldpc_dvb_msa
    }
    if {$type=="WiMedia"} {
        add_instance dec_msa altera_ldpc_wimedia_msa
        set_instance_parameter dec_msa ISFULLSTREAMING  1
        set_instance_parameter dec_msa ISVARRATE  $isvarrate
        
        
        if {$n==1200} {
            set nbcheckgroup [expr $nbcheckgroup-4]
            set nbvargroup   [expr $nbvargroup-4]
        }

        
    }    
    
    
    set_instance_parameter dec_msa NBCHECKGROUP  $nbcheckgroup
    set_instance_parameter dec_msa NBVARGROUP    $nbvargroup
    set_instance_parameter dec_msa N             $n
    set_instance_parameter dec_msa BITSPERSYMBOL $bitspersymbol
    set_instance_parameter dec_msa PAR           $par
    set_instance_parameter dec_msa ATTENUATION   $att
    set_instance_parameter dec_msa TRANSMIT_PARITY  $transmitparity
    set_instance_parameter dec_msa CHANNEL       $channel
    set_instance_parameter dec_msa SOFTBITS      $softbits
    set_instance_parameter dec_msa S             $softbits_msa
    set_instance_parameter dec_msa NB_ITE        $nbite
    set_instance_parameter dec_msa ISLAYERED     $islayered
    set_instance_parameter dec_msa design_env    [get_parameter_value design_env]

 
    # Export in
    dsp_add_streaming_interface in sink 
    set_interface_property in export_of dec_msa.cw_in    

    # Export Out
    dsp_add_streaming_interface out source
    set_interface_property out export_of dec_msa.cw_out
    


    # Add connection
    #add_connection clk_rst.clk/dec_in_buffer.clk
    add_connection clk_rst.clk/dec_msa.clk
    #add_connection clk_rst.clk/dec_out_buffer.clk


    #add_connection clk_rst.clk_reset/dec_in_buffer.rst
    add_connection clk_rst.clk_reset/dec_msa.rst
    #add_connection clk_rst.clk_reset/dec_out_buffer.rst


    #add_connection dec_in_buffer.out/dec_msa.in
    #add_connection dec_msa.out/dec_out_buffer.in


}

