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

source "../lib/altera_ldpc_utilities.tcl"
source "../../../lib/tcl/avalon_streaming_util.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ser_dec
# |
set_module_property NAME altera_ldpc_enc
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "DSP/LDPC"
set_module_property DISPLAY_NAME "LDPC Encoder"
set_module_property DESCRIPTION "Altera LDPC Encoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersENC
add_module_parametersISVARRATE
set_module_property COMPOSITION_CALLBACK compose


# +-----------------------------------
# | Callbacks
# | 

proc compose {} {
    set n                   [ get_parameter_value N ]
    set bitspersymbol       [ get_parameter_value BITSPERSYMBOL ]
    set channel             [ get_parameter_value CHANNEL ]
    set nbcheckgroup        [ get_parameter_value NBCHECKGROUP]
    set nbvargroup          [ get_parameter_value NBVARGROUP]
    set type                [ get_parameter_value LDPC_TYPE]
    set isvarrate           [ get_parameter_value ISVARRATE ]

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
        set name "nasa"
        add_instance $name altera_ldpc_nasa_enc
    }
    if {$type=="DOCSIS"} {
        # add_instance enc altera_ldpc_docsis_enc
    }
    if {$type=="DVB"} {
        set name "dvb"
        add_instance $name altera_ldpc_dvb_enc
        set_instance_parameter $name CHANNEL       $channel
    }
    if {$type=="WiMedia"} {
        set name "wimedia"
        add_instance $name altera_ldpc_wimedia_enc
        set_instance_parameter $name ISVARRATE  $isvarrate
        
        set nbcheckgroup [expr $nbcheckgroup-4]


    }    
    
    
    set_instance_parameter $name NBCHECKGROUP  $nbcheckgroup
    set_instance_parameter $name NBVARGROUP    $nbvargroup
    set_instance_parameter $name N             $n
    set_instance_parameter $name BITSPERSYMBOL $bitspersymbol
    set_instance_parameter $name design_env    [get_parameter_value design_env]

 
    # Export in
    dsp_add_streaming_interface in sink 
    set_interface_property in export_of ${name}.in    

    # Export Out
    dsp_add_streaming_interface out source
    set_interface_property out export_of ${name}.out

    # Add connection
    add_connection clk_rst.clk/${name}.clk
    add_connection clk_rst.clk_reset/${name}.rst




}

