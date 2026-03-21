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

source "../src/lib/altera_hsrs_utilities.tcl"
source "../src/lib/avalon_streaming_util.tcl"
source "../src/lib/altera_hsrs_example_design.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_ldpc
# |
set_module_property NAME altera_highspeed_rs
set_module_property AUTHOR "Intel Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DISPLAY_NAME "High-Speed Reed-Solomon"
set_module_property DESCRIPTION "Altera High-Speed Reed-Solomon"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersTOP 
set_module_property VALIDATION_CALLBACK validateTOP
set_module_property COMPOSITION_CALLBACK compose
set_module_property SUPPORTED_DEVICE_FAMILIES {\
{Arria 10} {Arria V} {Arria V GZ}  \
{Cyclone V} {Cyclone IV} {Cyclone IV GX}\
{Max 10 FPGA}\
{Stratix V} {Stratix IV} {Stratix 10}\
}

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_fileset example_design EXAMPLE_DESIGN example_fileset "Highspeed RS Example Design"

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1424790284305/dmi1424790559225
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

# +-----------------------------------
# | Callbacks
# | 
proc compose {} {
    set rs_design           [ get_parameter_value RSDESIGN ]
    set rs                  [ get_parameter_value RS ]
    set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]   
    set channel             [ get_parameter_value CHANNEL ]   
    set k                   [ get_parameter_value K ]
    set irrpol              [ get_parameter_value IRRPOL ]
    set n                   [ get_parameter_value N ]
    set par                 [ get_parameter_value PAR ]
    set use_backpressure    [ get_parameter_value USE_BKP ]
    set use_decfail         [ get_parameter_value USE_DECFAIL ]
    set use_nberror         [ get_parameter_value USE_NBERROR ]
    set use_errorvalue      [ get_parameter_value USE_ERRORVALUE ]
    set use_sopeop          [ get_parameter_value USE_SOPEOP ]
    set use_bypass          [ get_parameter_value USE_BYPASS ]
    set use_sync            [ get_parameter_value USE_SYNC ]
    
    # Force bm_speed = 4 when bm_speed=6 is not allowed
    if {$n/$par<(6/2)} {
        set bm_speed  4
    } else {
        set bm_speed  [ get_parameter_value BMSPEED]
    }
    if {$par>192} {
        set use_decfail 0
    }

    set useram              [ get_parameter_value USERAM]
    set useeccforram        [ get_parameter_value USEECCFORRAM]
    set usetruedualportram  [ get_parameter_value USETRUEDUALRAM]
    set check               [ expr $n-$k]

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

    
    if ([string equal $rs "Encoder"]) {
    
        if {$rs_design} {
            add_instance encoder altera_frac100_rs_enc
            set_instance_parameter encoder TWO_CHANNELS  [ get_parameter_value TWO_CHANNELS ]
            set_instance_parameter encoder FOUR_CHANNELS [ get_parameter_value FOUR_CHANNELS ]
        } else {
            add_instance encoder altera_highspeed_rs_enc
            set_instance_parameter encoder BITSPERSYMBOL $bits_per_symbol
            set_instance_parameter encoder N $n
            set_instance_parameter encoder CHECK $check
            set_instance_parameter encoder IRRPOL $irrpol
            set_instance_parameter encoder PAR $par
        }
        
        set_instance_parameter encoder USE_BKP $use_backpressure  
        set_instance_parameter encoder design_env [get_parameter_value design_env]
        
    } else {
        
        if {$rs_design} {
            add_instance decoder altera_frac100_rs_dec
            set_instance_parameter decoder TWO_CHANNELS [ get_parameter_value TWO_CHANNELS ]
            set_instance_parameter decoder FOUR_CHANNELS  [ get_parameter_value FOUR_CHANNELS ]
        } else {
            add_instance decoder altera_highspeed_rs_dec
            set_instance_parameter decoder BITSPERSYMBOL $bits_per_symbol
            set_instance_parameter decoder CHECK $check
            set_instance_parameter decoder CHANNEL $channel
            set_instance_parameter decoder IRRPOL $irrpol
            set_instance_parameter decoder N $n
            set_instance_parameter decoder USE_BYPASS $use_bypass
            set_instance_parameter decoder USE_SYNC $use_sync
        }
        
        set_instance_parameter decoder PAR $par        
        set_instance_parameter decoder design_env [get_parameter_value design_env]
        set_instance_parameter decoder BMSPEED $bm_speed
        set_instance_parameter decoder USERAM $useram
        set_instance_parameter decoder USEECCFORRAM $useeccforram
        set_instance_parameter decoder USETRUEDUALRAM $usetruedualportram
        set_instance_parameter decoder USE_BKP $use_backpressure
        set_instance_parameter decoder USE_DECFAIL $use_decfail
        set_instance_parameter decoder USE_NBERROR $use_nberror
        set_instance_parameter decoder USE_ERRORVALUE $use_errorvalue
        set_instance_parameter decoder USE_SOPEOP $use_sopeop
    }

    if ([string equal $rs "Encoder"]) {
        # Export In
        #add_interface in avalon_streaming end
        dsp_add_streaming_interface in sink
        set_interface_property in export_of encoder.in
        
        # Export Out
        #add_interface out avalon_streaming start
        dsp_add_streaming_interface out source
        set_interface_property out export_of encoder.out

        # Add connection
        add_connection clk_rst.clk/encoder.clk
        add_connection clk_rst.clk_reset/encoder.rst
    } else {
        # Export In
        #add_interface in avalon_streaming end
        dsp_add_streaming_interface in sink
        set_interface_property in export_of decoder.in
        
        # Export Out
        dsp_add_streaming_interface out source
        set_interface_property out export_of decoder.out


        # Add connection
        add_connection clk_rst.clk/decoder.clk
        add_connection clk_rst.clk_reset/decoder.rst
    }


}

        










