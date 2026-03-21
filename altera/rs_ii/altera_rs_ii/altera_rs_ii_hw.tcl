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

source "../src/lib/altera_rs_utilities.tcl"
source "../../dsp/lib/tcl/avalon_streaming_util.tcl"
source "../src/lib/altera_rs_example_design.tcl"
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_rs_ii
# |
set_module_property NAME altera_rs_ii
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DISPLAY_NAME "Reed Solomon II"
set_module_property DESCRIPTION "Altera Reed Solomon II"
set_module_property DATASHEET_URL "https://documentation.altera.com/#/link/dmi1413888853556/dmi1413897599075"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersTOP 
set_module_property VALIDATION_CALLBACK validateTOP
set_module_property COMPOSITION_CALLBACK compose
set_module_property SUPPORTED_DEVICE_FAMILIES \
{\
{Arria 10} {Arria V} {Arria V GZ} {Arria II GX} {Arria II GZ} \
{Cyclone 10 LP} {Cyclone V} {Cyclone IV E} {Cyclone IV GX}\
{Max 10 FPGA}\
{Stratix V} {Stratix IV}\
}

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}
add_fileset example_design EXAMPLE_DESIGN example_fileset "RS_II Example Design"


# +-----------------------------------
# | Callbacks
# | 
proc compose {} {
    set rs                  [ get_parameter_value RS ]
    set bits_per_symbol     [ get_parameter_value BITSPERSYMBOL ]   
    set check               [ get_parameter_value CHECK ]
    set irrpol              [ get_parameter_value IRRPOL ]
    set i0                  [ get_parameter_value GENSTART ]
    set rootspace           [ get_parameter_value ROOTSPACE ]
    set channel             [ get_parameter_value CHANNEL ]
    set n                   [ get_parameter_value N ]
    set genpoltype          [ get_parameter_value GENPOLTYPE] 
    set erasure             [ get_parameter_value ERASURE ]
    set isvarcheck          [ get_parameter_value VARCHECK ]
    set mincheck            [ get_parameter_value MINCHECK ]
    set isvarn              [ get_parameter_value VARN ]
    set min_n               [ get_parameter_value MIN_N ]
    set bitcounttype        [ get_parameter_value BITCOUNTTYPE ]
    set errorsymbol         [ get_parameter_value ERRORSYMB ]
    set errorsymbcount      [ get_parameter_value ERRORSYMBCOUNT ]
    set errorbitcount       [ get_parameter_value ERRORBITCOUNT ]
    set optimizelatency     [ get_parameter_value OPTIMIZE_LATENCY ]
    set userom              [ get_parameter_value USEROM ]
    set use_dual_basis      [ get_parameter_value USEDUALBASIS ]
    set dual_basis_of       [ get_parameter_value DUALBASISOF ]

    
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
    if ([string equal $genpoltype "CCSDS-like"]) {
        set genstart        [expr $i0*$rootspace%[expr 2**$bits_per_symbol-1]]
    } else {
        set genstart        [expr $i0]
        set use_dual_basis 0
    }


    set usenumn       [expr $isvarn && ($erasure ||  [ get_parameter_value USENUMN ])]   



    if ([string equal $rs "Encoder"]) {
        add_instance rs_encoder altera_rs_ser_enc

        set_instance_parameter rs_encoder design_env [get_parameter_value design_env]

        set_instance_parameter rs_encoder BITSPERSYMBOL $bits_per_symbol
        set_instance_parameter rs_encoder CHECK $check
        set_instance_parameter rs_encoder IRRPOL $irrpol
        set_instance_parameter rs_encoder GENSTART $genstart
        set_instance_parameter rs_encoder ROOTSPACE $rootspace
        set_instance_parameter rs_encoder CHANNEL $channel
        set_instance_parameter rs_encoder VARCHECK $isvarcheck
        set_instance_parameter rs_encoder MINCHECK $mincheck
        set_instance_parameter rs_encoder USEDUALBASIS $use_dual_basis
        set_instance_parameter rs_encoder DUALBASISOF $dual_basis_of
    } else {
        add_instance rs_decoder altera_rs_ser_dec

        set_instance_parameter rs_decoder design_env [get_parameter_value design_env]

        set_instance_parameter rs_decoder BITSPERSYMBOL $bits_per_symbol
        set_instance_parameter rs_decoder CHECK $check
        set_instance_parameter rs_decoder IRRPOL $irrpol
        set_instance_parameter rs_decoder GENSTART $genstart
        set_instance_parameter rs_decoder ROOTSPACE $rootspace
        set_instance_parameter rs_decoder CHANNEL $channel
        set_instance_parameter rs_decoder N $n
        # Decoder erasure
        set_instance_parameter rs_decoder ERASURE $erasure
        # Decoder status
        set_instance_parameter rs_decoder ERRORSYMB $errorsymbol
        set_instance_parameter rs_decoder ERRORSYMBCOUNT $errorsymbcount
        set_instance_parameter rs_decoder ERRORBITCOUNT $errorbitcount
        set_instance_parameter rs_decoder BITCOUNTTYPE $bitcounttype
        # Decoder varenc
        set_instance_parameter rs_decoder VARCHECK $isvarcheck
        set_instance_parameter rs_decoder VARN $isvarn
        set_instance_parameter rs_decoder USENUMN $usenumn
        set_instance_parameter rs_decoder OPTIMIZE_LATENCY $optimizelatency
        set_instance_parameter rs_decoder MIN_N $min_n
        set_instance_parameter rs_decoder USEROM $userom
        # Dual Basis
        set_instance_parameter rs_decoder USEDUALBASIS $use_dual_basis
        set_instance_parameter rs_decoder DUALBASISOF $dual_basis_of
    }

    if ([string equal $rs "Encoder"]) {
        # Export In
        #add_interface in avalon_streaming end
        dsp_add_streaming_interface in sink
        set_interface_property in export_of rs_encoder.in
        
        # Export Out
        add_interface out avalon_streaming start
        #dsp_add_streaming_interface out source
        set_interface_property out export_of rs_encoder.out

        # Add connection
        add_connection clk_rst.clk/rs_encoder.clk
        add_connection clk_rst.clk_reset/rs_encoder.rst
    } else {
        # Export In
        #add_interface in avalon_streaming end
        dsp_add_streaming_interface in sink
        set_interface_property in export_of rs_decoder.in
        
        # Export Out
        #add_interface out avalon_streaming start
        dsp_add_streaming_interface out source
        set_interface_property out export_of rs_decoder.out


        # Add connection
        add_connection clk_rst.clk/rs_decoder.clk
        add_connection clk_rst.clk_reset/rs_decoder.rst
    }

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1413888853556/dmi1413897599075
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697922670
