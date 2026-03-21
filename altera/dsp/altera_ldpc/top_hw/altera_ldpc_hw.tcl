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
package require altera_terp

source "../src/lib/altera_ldpc_utilities.tcl"
source "../../lib/tcl/avalon_streaming_util.tcl"
source "../src/lib/altera_ldpc_example_design.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_ldpc
# |
set_module_property NAME altera_ldpc
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DISPLAY_NAME "LDPC"
set_module_property DESCRIPTION "Altera LDPC"
set_module_property DATASHEET_URL "https://documentation.altera.com/#/link/dmi1412945793256/dmi1412947726256"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersTOP 
set_module_property VALIDATION_CALLBACK validateTOP
set_module_property COMPOSITION_CALLBACK compose
set_module_property SUPPORTED_DEVICE_FAMILIES {\
{Arria 10} {Arria V} {Arria V GZ}  \
{Cyclone V} {Cyclone IV} {Cyclone IV GX}\
{Max 10 FPGA}\
{Stratix 10} {Stratix V} {Stratix IV}\
}

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_fileset example_design EXAMPLE_DESIGN example_fileset "LDPC Example Design"

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1412945793256/dmi1412947726256
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697849863


# +-----------------------------------
# | Callbacks
# | 
proc compose {} {

    set module              [ get_parameter_value MODULE ]
    set ldpc_type           [ get_parameter_value LDPC_TYPE ]   
    set rate                [ get_parameter_value RATE ]
    set channel             [ get_parameter_value CHANNEL ]
    set n_number            [ get_parameter_value N ]
    set bitspersymbol       [ get_parameter_value BITSPERSYMBOL ]
    set llrpersymbol        [ get_parameter_value LLRPERSYMBOL ]
    set softbits            [ get_parameter_value SOFTBITS ]
    set nbite               [ get_parameter_value NB_ITE]

    
    
    
    set par                 [ get_parameter_value PAR]
    set att                 [ get_parameter_value ATTENUATION]
    set transmitparity      [ get_parameter_value TRANSMIT_PARITY]
    set softbits_msa        [ get_parameter_value S]
    set nasafull            [ get_parameter_value ISFULLSTREAMING ]
    set islayered           [ get_parameter_value ISLAYERED ]
    set isvarrate           [ get_parameter_value ISVARRATE ]
    set extralatency        [ get_parameter_value EXTRALATENCY ]
    
    if {[string equal $module "Encoder"]} {
        set isencoder 1
    } else {
        set isencoder 0
    }
    
    
    
    
    if {[string equal $ldpc_type "DOCSIS"]} {
        get_DOCSIS_parameters nbcheckgroup nbvargroup n $rate
        set nbvargroup  45
        #send_message warning "DOCSIS: n is $n, rate is $rate, q is $nbcheckgroup, p is $nbvargroup"
        set par   [expr $par/$llrpersymbol]
        set isencoder 0
    }
    
    if {[string equal $ldpc_type "DVB"]} {
        set matrix_number    [get_DVB_matrixnumber $n_number $rate]
        get_DVB_parameters nbcheckgroup nbvargroup n $matrix_number
        #send_message warning "DVB: code number is [expr $matrix_number+1]: n is $n, rate is $rate, q is $nbcheckgroup, p is $nbvargroup"
        set isencoder 1
    }

    if {[string equal $ldpc_type "NASA"]} {
        get_NASA_parameters nbcheckgroup nbvargroup n $n_number $isencoder
        #send_message warning "NASA: n is $n, rate is $rate, q is $nbcheckgroup, p is $nbvargroup"
    }
    
    if {[string equal $ldpc_type "WiMedia"]} {
        get_Wimedia_parameters nbcheckgroup nbvargroup n $n_number $rate $isencoder
        #send_message warning "WiMedia: n is $n, rate is $rate, q is $nbcheckgroup, p is $nbvargroup"
    }
    
    
    

    

    # Clock Source
    add_instance clk_rst clock_source
    add_interface clk clock end
    set_interface_property clk export_of clk_rst.clk_in
    set_instance_parameter clk_rst resetSynchronousEdges DEASSERT
    set_instance_parameter clk_rst clockFrequencyKnown "false"

    # suppress this warning:
    # Warning: rs.clk_rst: The input clock frequency must be known or set by the parent if this is a subsystem.
    set_instance_property clk_rst SUPPRESS_ALL_WARNINGS true
    
    
    # Reset
    add_interface reset reset end
    set_interface_property reset export_of clk_rst.clk_in_reset
    
    #
    if {$isencoder} {
        set instance_name encoder
        add_instance $instance_name altera_ldpc_enc
        set_instance_parameter $instance_name N $n
        set_instance_parameter $instance_name CHANNEL 1
        set_instance_parameter $instance_name NBCHECKGROUP $nbcheckgroup
        set_instance_parameter $instance_name NBVARGROUP $nbvargroup
        set_instance_parameter $instance_name BITSPERSYMBOL $bitspersymbol
        set_instance_parameter $instance_name LDPC_TYPE $ldpc_type
        set_instance_parameter $instance_name ISVARRATE $isvarrate
        set_instance_parameter $instance_name design_env [get_parameter_value design_env]
    } else {
        set instance_name decoder
        add_instance $instance_name altera_ldpc_dec
        set_instance_parameter $instance_name N $n
        set_instance_parameter $instance_name CHANNEL $channel
        set_instance_parameter $instance_name NBCHECKGROUP $nbcheckgroup
        set_instance_parameter $instance_name NBVARGROUP $nbvargroup
        set_instance_parameter $instance_name BITSPERSYMBOL $llrpersymbol
        set_instance_parameter $instance_name SOFTBITS $softbits
        set_instance_parameter $instance_name PAR $par
        set_instance_parameter $instance_name ATTENUATION $att
        set_instance_parameter $instance_name NB_ITE $nbite
        set_instance_parameter $instance_name LDPC_TYPE $ldpc_type
        set_instance_parameter $instance_name TRANSMIT_PARITY $transmitparity
        set_instance_parameter $instance_name S             $softbits_msa
        set_instance_parameter $instance_name ISFULLSTREAMING  $nasafull
        set_instance_parameter $instance_name ISLAYERED             $islayered
        set_instance_parameter $instance_name ISVARRATE             $isvarrate
        set_instance_parameter $instance_name EXTRALATENCY          $extralatency
        set_instance_parameter $instance_name design_env [get_parameter_value design_env]
    }


    # Export In
    dsp_add_streaming_interface in sink
    dsp_set_interface_property in export_of ${instance_name}.in
    
    # Export Out
    dsp_add_streaming_interface out source
    set_interface_property out export_of ${instance_name}.out

    # Add connection
    add_connection clk_rst.clk/${instance_name}.clk
    add_connection clk_rst.clk_reset/${instance_name}.rst


}
