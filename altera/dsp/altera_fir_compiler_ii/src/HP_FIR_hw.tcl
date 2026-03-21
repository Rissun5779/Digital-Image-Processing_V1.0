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

source "../../lib/tcl/dspip_common.tcl"
load_strings altera_fir_compiler_ii.properties

# +------------------------------------------------------------------
# | module ALTERA FIR COMPILER II
# +------------------------------------------------------------------
set_module_property NAME altera_fir_compiler_ii
set_module_property VERSION 18.1
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property INTERNAL false
## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/hco1421694595728/hco1421694575632
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697809283

set_module_properties_from_strings AUTHOR GROUP DISPLAY_NAME DESCRIPTION 

set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V} {STRATIX 10}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
    {CYCLONE IV GX} {CYCLONE IV E} {CYCLONE V} {CYCLONE 10 LP}
    {MAX 10 FPGA} 
}

set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validation

set_module_property PARAMETER_UPGRADE_CALLBACK upgrade

add_fileset quartus_synth quartus_synth gen_synth_files
add_fileset sim_verilog sim_verilog gen_sim_verilog_files
add_fileset sim_vhdl sim_vhdl gen_sim_vhdl_files



proc add_core_file {path} {
    set type [get_type_from_extension $path]
    set leaf [file tail $path]
    add_fileset_file $leaf $type PATH $path
}

proc add_core_file_list {list_of_paths} {
    foreach path $list_of_paths {
        add_core_file $path
    }
}


proc add_common_files {} {
    global DSPBA_BACKEND_DIR
    global env
    set common_files [list]
    lappend common_files $DSPBA_BACKEND_DIR/Libraries/vhdl/base/dspba_library_package.vhd
    lappend common_files $DSPBA_BACKEND_DIR/Libraries/vhdl/base/dspba_library.vhd
    lappend common_files ast_components/auk_dspip_math_pkg_hpfir.vhd
    lappend common_files ast_components/auk_dspip_lib_pkg_hpfir.vhd
    lappend common_files ast_components/auk_dspip_avalon_streaming_controller_hpfir.vhd
    lappend common_files ast_components/auk_dspip_avalon_streaming_sink_hpfir.vhd
    lappend common_files ast_components/auk_dspip_avalon_streaming_source_hpfir.vhd
    lappend common_files ast_components/auk_dspip_roundsat_hpfir.vhd
    return $common_files
}

# DSPBA library files, now in the platform specific directory under 'backend'
set DSPBA_BACKEND_DIR "${env(QUARTUS_ROOTDIR)}/dspba/backend"
set DSPBA_BACKEND_BIN_DIR "$DSPBA_BACKEND_DIR/[get_platform]"

# +------------------------------------------------------------------
# | Parameters 
# +------------------------------------------------------------------

set_variables_from_strings filter_spec_tab coeff_settings_tab coeff_tab io_tab impl_tab reconfigurability_tab

foreach tab [list $filter_spec_tab $coeff_settings_tab $coeff_tab $io_tab $impl_tab $reconfigurability_tab] {
    add_display_item "" $tab group tab
}

set_variables_from_strings filter_group coeff_group input_group output_group \
    freq_group slave_group flow_group thresholds_group resources_group reconfigurability_group
 
foreach group [list $filter_group $freq_group $slave_group $flow_group] {
    add_display_item $filter_spec_tab $group group
}

foreach group [list $coeff_group] {
    add_display_item $coeff_settings_tab $group group
}

foreach group [list $input_group $output_group] {
    add_display_item $io_tab $group group
}

foreach group [list $thresholds_group $resources_group] {
    add_display_item $impl_tab $group group
}

foreach group [list $reconfigurability_group] {
    add_display_item $reconfigurability_tab $group group
}

# | Filter type
# +------------------------------------------------------------------
add_parameter filterType string single
set_parameter_display_from_strings filterType
set_allowed_ranges filterType {single decim interp frac}
set_parameter_property filterType GROUP $filter_group

# | Interpolation rate
# +------------------------------------------------------------------
add_parameter interpFactor integer 1
set_parameter_display_from_strings interpFactor
set_parameter_property interpFactor ALLOWED_RANGES {1:128}
set_parameter_property interpFactor GROUP $filter_group

# | Decimation rate
# +------------------------------------------------------------------
add_parameter decimFactor integer 1
set_parameter_display_from_strings decimFactor
set_parameter_property decimFactor ALLOWED_RANGES {1:128}
set_parameter_property decimFactor GROUP $filter_group

# | Type of symmetry
# +------------------------------------------------------------------
add_parameter symmetryMode string nsym
set_parameter_display_from_strings symmetryMode
set_allowed_ranges symmetryMode {nsym sym asym}
set_parameter_property symmetryMode GROUP $coeff_group

# | L-th Band Filter (allows optimisation based on some coefficients always being 0)
# +------------------------------------------------------------------
add_parameter L_bandsFilter string 1
set_parameter_display_from_strings L_bandsFilter
set_allowed_ranges L_bandsFilter {1 2 3 4 5}
set_parameter_property L_bandsFilter GROUP $coeff_group

# | Number of channels
# +------------------------------------------------------------------
add_parameter inputChannelNum integer 1
set_parameter_display_from_strings inputChannelNum
set_parameter_property inputChannelNum GROUP $filter_group

# | System clock rate (Megahertz)
# +------------------------------------------------------------------
add_parameter clockRate string 100
set_parameter_display_from_strings clockRate
set_parameter_property clockRate units Megahertz
set_parameter_property clockRate GROUP $freq_group
set_parameter_property clockRate DISPLAY_HINT COLUMNS:10

# | Extra slack for margin (Megahertz)
# +------------------------------------------------------------------
add_parameter clockSlack integer 0
set_parameter_display_from_strings clockSlack
set_parameter_property clockSlack GROUP $freq_group
set_parameter_property clockSlack units Megahertz


# | Sample rate per channel (MSPS)
# +------------------------------------------------------------------ 
add_parameter inputRate string 100
set_parameter_display_from_strings inputRate
set_parameter_property inputRate GROUP $freq_group
set_parameter_property inputRate DISPLAY_HINT COLUMNS:10


# | Enable Coefficient Reloading
# +------------------------------------------------------------------
add_parameter coeffReload boolean false
set_parameter_display_from_strings coeffReload
set_parameter_property coeffReload GROUP $slave_group

# | Base address for coefficient interface
# +------------------------------------------------------------------
add_parameter baseAddress integer 0
set_parameter_display_from_strings baseAddress
set_parameter_property baseAddress ENABLED false
set_parameter_property baseAddress GROUP $slave_group

# | Are coefficients readable? writeable? 
# +------------------------------------------------------------------
add_parameter readWriteMode string read_write
set_parameter_display_from_strings readWriteMode
set_allowed_ranges readWriteMode {read write read_write}
set_parameter_property readWriteMode ENABLED false
set_parameter_property readWriteMode GROUP $slave_group


#|Derived coef R/W
add_parameter coefficientReadback boolean false
set_parameter_property coefficientReadback DERIVED true
set_parameter_property coefficientReadback VISIBLE false

add_parameter coefficientWriteable boolean false
set_parameter_property coefficientWriteable DERIVED true
set_parameter_property coefficientWriteable VISIBLE false

add_parameter busDataWidth integer 16
set_parameter_property busDataWidth DERIVED true
set_parameter_property busDataWidth VISIBLE false


# | Back Pressure support
# +------------------------------------------------------------------
add_parameter backPressure boolean false
set_parameter_display_from_strings backPressure
set_parameter_property backPressure GROUP $flow_group

# | Device family
# +------------------------------------------------------------------
add_parameter deviceFamily string "Stratix V"
set_parameter_display_from_strings deviceFamily
set_parameter_property deviceFamily system_info {DEVICE_FAMILY}
set_parameter_property deviceFamily GROUP $thresholds_group

# | Speed grade for device
# +------------------------------------------------------------------
add_parameter speedGrade string medium
set_parameter_display_from_strings speedGrade
set_allowed_ranges speedGrade {fast medium slow}
set_parameter_property speedGrade GROUP $thresholds_group

# Refer DSP Advanced Blockset user guide for more details about the resource optimization

# | If bits in delay is greater than this number then use a RAM (TBD)
# +------------------------------------------------------------------   
add_parameter delayRAMBlockThreshold integer 20
set_parameter_display_from_strings delayRAMBlockThreshold
set_parameter_property delayRAMBlockThreshold GROUP $thresholds_group

# | Number of bits before MLAB gets converted to M9K
# +------------------------------------------------------------------ 
add_parameter dualMemDistRAMThreshold integer 1280
set_parameter_display_from_strings dualMemDistRAMThreshold
set_parameter_property dualMemDistRAMThreshold GROUP $thresholds_group

# | If bits  > this, use MRAM or M144K
# +------------------------------------------------------------------ 
add_parameter mRAMThreshold integer 1000000
set_parameter_display_from_strings mRAMThreshold
set_parameter_property mRAMThreshold GROUP $thresholds_group

# | Number of LUTs below which a mult with be made from LUTs
# +------------------------------------------------------------------ 
add_parameter hardMultiplierThreshold integer -1
set_parameter_display_from_strings hardMultiplierThreshold
set_parameter_property hardMultiplierThreshold GROUP $thresholds_group




# | Enabled Reconfigurability
# +------------------------------------------------------------------
add_parameter reconfigurable boolean false
#set_parameter_property reconfigurable ALLOWED_RANGES {1:128}
set_parameter_display_from_strings reconfigurable
set_parameter_property reconfigurable VISIBLE true
set_parameter_property reconfigurable GROUP $reconfigurability_group

# | Choose num Modes
# +------------------------------------------------------------------
add_parameter num_modes integer 2
set_parameter_display_from_strings num_modes
set_parameter_property num_modes VISIBLE true
set_parameter_property num_modes GROUP $reconfigurability_group

# | Width of the mode port - 0 for non-reconfigruable
# +------------------------------------------------------------------
add_parameter ModeWidth integer 2
set_parameter_property ModeWidth VISIBLE false
set_parameter_property ModeWidth derived true

# | Choose Mode Editable
# +------------------------------------------------------------------
add_parameter reconfigurable_list string "0"
set_parameter_display_from_strings reconfigurable_list
set_parameter_property reconfigurable_list VISIBLE true
set_parameter_property reconfigurable_list ALLOWED_RANGES [ list "0:0:0,1,2,3" "1:1:0,0,0,0"]
set_parameter_property reconfigurable_list GROUP $reconfigurability_group

add_parameter MODE_STRING string "None Set"
set_parameter_display_from_strings MODE_STRING
set_parameter_property MODE_STRING VISIBLE false
set_parameter_property MODE_STRING AFFECTS_VALIDATION true
set_parameter_property MODE_STRING AFFECTS_ELABORATION true


add_parameter modeFormatted string "--"
set_parameter_property modeFormatted VISIBLE false
set_parameter_property modeFormatted DERIVED true



# | Reconfigurability channel modes
# +------------------------------------------------------------------
add_parameter channelModes string "0,1,2,3"
#set_parameter_property reconfigurable ALLOWED_RANGES {1:128}
set_parameter_display_from_strings channelModes
set_parameter_property channelModes VISIBLE false
set_parameter_property channelModes GROUP $reconfigurability_group


add_display_item $reconfigurability_group "Set Mode" ACTION setModeCallback
set_display_item_property "Set Mode" VISIBLE false



# | Input Data Type
# +------------------------------------------------------------------
add_parameter inputType string int
set_parameter_display_from_strings inputType
set_allowed_ranges inputType {int frac}
set_parameter_property inputType GROUP $input_group



# | Sample data width in bits
# +------------------------------------------------------------------
add_parameter inputBitWidth integer 8
set_parameter_display_from_strings inputBitWidth
set_parameter_property inputBitWidth ALLOWED_RANGES {1:32}
set_parameter_property inputBitWidth GROUP $input_group
set_parameter_property inputBitWidth units Bits

# | Sample data fraction width in bits
# +------------------------------------------------------------------
add_parameter inputFracBitWidth integer 0
set_parameter_display_from_strings inputFracBitWidth
set_parameter_property inputFracBitWidth ALLOWED_RANGES {0:32}
set_parameter_property inputFracBitWidth GROUP $input_group
set_parameter_property inputFracBitWidth units Bits

# | Real reset coefficients for the FIR (Original Value)
# +------------------------------------------------------------------
add_parameter coeffSetRealValue string "0.0176663, 0.013227, 0.0, -0.0149911, -0.0227152, -0.0172976, 0.0, 0.0204448, 0.0318046, 0.0249882, 0.0, -0.0321283, -0.0530093, -0.04498, 0.0, 0.0749693, 0.159034, 0.224907, 0.249809, 0.224907, 0.159034, 0.0749693, 0.0, -0.04498, -0.0530093, -0.0321283, 0.0, 0.0249882, 0.0318046, 0.0204448, 0.0, -0.0172976, -0.0227152, -0.0149911, 0.0, 0.013227, 0.0176663"
set_parameter_display_from_strings coeffSetRealValue
set_parameter_property coeffSetRealValue VISIBLE false

add_parameter coeffNum integer 8
set_parameter_property coeffNum DERIVED true
set_parameter_display_from_strings coeffNum
set_parameter_property coeffNum VISIBLE false

# | Imaginary component of Reset coefficients for the FIR (Original Value)
# | Only used if coeffComplex is true
# +------------------------------------------------------------------
add_parameter coeffSetRealValueImag string "0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0530093, -0.04498, 0.0, 0.0749693, 0.159034, 0.224907, 0.249809, 0.224907, 0.159034, 0.0749693, 0.0, -0.04498, -0.0530093, -0.0321283, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0"
set_parameter_display_from_strings coeffSetRealValueImag
set_parameter_property coeffSetRealValueImag VISIBLE false

# | Real reset coefficients (Scaled Value calculated by JAVA)
# +------------------------------------------------------------------
add_parameter coeffSetScaleValue string "0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125"
set_parameter_property coeffSetScaleValue DERIVED true
set_parameter_display_from_strings coeffSetScaleValue
set_parameter_property coeffSetScaleValue VISIBLE false

# | Imaginary component of reset coefficients (Scaled Value calculated by JAVA)
# | Only used if coeffComplex is true
# +------------------------------------------------------------------
add_parameter coeffSetScaleValueImag string "0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0"
set_parameter_property coeffSetScaleValueImag DERIVED true
set_parameter_display_from_strings coeffSetScaleValueImag
set_parameter_property coeffSetScaleValueImag VISIBLE false

# | Real reset coefficients (Fixed Point Value calculated by JAVA)
# +------------------------------------------------------------------
add_parameter coeffSetFixedValue string "127,127,127,127,127,127,127,127"
set_parameter_display_from_strings coeffSetFixedValue
set_parameter_property coeffSetFixedValue DERIVED true
set_parameter_property coeffSetFixedValue VISIBLE false

# | Imaginary component of reset coefficients (Fixed Point Value calculated by JAVA)
# | Only used if coeffComplex is true
# +------------------------------------------------------------------
add_parameter coeffSetFixedValueImag string "0,0,0,0,0,0,0,0"
set_parameter_display_from_strings coeffSetFixedValueImag
set_parameter_property coeffSetFixedValueImag DERIVED true
set_parameter_property coeffSetFixedValueImag VISIBLE false

# | Coefficient Scaling
# +------------------------------------------------------------------
add_parameter coeffScaling string auto
set_parameter_display_from_strings coeffScaling
set_allowed_ranges coeffScaling {auto none}
set_parameter_property coeffScaling GROUP $coeff_group

# | Coefficient Data Type
# +------------------------------------------------------------------
add_parameter coeffType string int
set_parameter_display_from_strings coeffType
set_allowed_ranges coeffType {int frac}
set_parameter_property coeffType GROUP $coeff_group

# | Coefficient width in bits
# +------------------------------------------------------------------
add_parameter coeffBitWidth integer 8
set_parameter_display_from_strings coeffBitWidth
set_parameter_property coeffBitWidth ALLOWED_RANGES {2:32}
set_parameter_property coeffBitWidth GROUP $coeff_group
set_parameter_property coeffBitWidth units Bits

# | Coefficient fraction width in bits
# +------------------------------------------------------------------
add_parameter coeffFracBitWidth integer 0
set_parameter_display_from_strings coeffFracBitWidth
set_parameter_property coeffFracBitWidth ALLOWED_RANGES {0:32}
set_parameter_property coeffFracBitWidth GROUP $coeff_group
set_parameter_property coeffFracBitWidth units Bits

#| Are coefficients complex numbers?
# +------------------------------------------------------------------
add_parameter coeffComplex boolean false
set_parameter_property coeffComplex VISIBLE false
set_parameter_display_from_strings coeffComplex
set_parameter_property coeffComplex GROUP $coeff_group
#| Are coefficients complex numbers?
# +------------------------------------------------------------------
add_parameter karatsuba boolean false
set_parameter_property karatsuba VISIBLE false
set_parameter_display_from_strings karatsuba
set_parameter_property karatsuba GROUP $coeff_group

# | Coefficient derived width in bits
# +------------------------------------------------------------------
add_parameter coeffBitWidth_derived integer 8
set_parameter_property coeffBitWidth_derived DERIVED true
set_parameter_property coeffBitWidth_derived VISIBLE false
set_parameter_property coeffBitWidth_derived ENABLED false

# | Output Data Type 
# +------------------------------------------------------------------
add_parameter outType string int
set_parameter_display_from_strings outType
set_allowed_ranges outType {int frac}
set_parameter_property outType GROUP $output_group

# | Output width in bits
# +------------------------------------------------------------------
add_parameter outBitWidth integer 19
set_parameter_display_from_strings outBitWidth
set_parameter_property outBitWidth ENABLED false
set_parameter_property outBitWidth DERIVED true
set_parameter_property outBitWidth GROUP $output_group
set_parameter_property outBitWidth units bits

# | Output fraction width in bits 
# +------------------------------------------------------------------
add_parameter outFracBitWidth integer 0
set_parameter_display_from_strings outFracBitWidth
set_parameter_property outFracBitWidth ENABLED false
set_parameter_property outFracBitWidth DERIVED true
set_parameter_property outFracBitWidth GROUP $output_group
set_parameter_property outFracBitWidth units bits
# | Output MSB rounding type
# +------------------------------------------------------------------
add_parameter outMSBRound string trunc
set_parameter_display_from_strings outMSBRound
set_allowed_ranges outMSBRound {trunc sat}
set_parameter_property outMSBRound GROUP $output_group

# | Output MSB bits to remove
# +------------------------------------------------------------------
add_parameter outMsbBitRem integer 0
set_parameter_display_from_strings outMsbBitRem
set_parameter_property outMsbBitRem ALLOWED_RANGES {0:32}
set_parameter_property outMsbBitRem GROUP $output_group

# | Output LSB rounding type
# +------------------------------------------------------------------
add_parameter outLSBRound string trunc
set_parameter_display_from_strings outLSBRound
set_allowed_ranges outLSBRound {trunc round}
set_parameter_property outLSBRound GROUP $output_group

# | Output MSB bits to remove
# +------------------------------------------------------------------
add_parameter outLsbBitRem integer 0
set_parameter_display_from_strings outLsbBitRem
set_parameter_property outLsbBitRem ALLOWED_RANGES {0:32}
set_parameter_property outLsbBitRem GROUP $output_group

# | Get the output width of result (bits) 
# +------------------------------------------------------------------
add_parameter outWidth integer 19
set_parameter_property outWidth ENABLED false
set_parameter_property outWidth DERIVED true
set_parameter_property outWidth GROUP $output_group
set_parameter_property outWidth units bits

foreach param [list outWidth outFullFracBitWidth latency outputfifodepth] {
    add_parameter ${param}_realOnly integer 19
    set_parameter_property ${param}_realOnly ENABLED false
    set_parameter_property ${param}_realOnly DERIVED true
    set_parameter_property ${param}_realOnly VISIBLE false
}



# | Get the output fraction width of result (bits) 
# +------------------------------------------------------------------
add_parameter outFullFracBitWidth integer 5
set_parameter_display_from_strings outFullFracBitWidth
set_parameter_property outFullFracBitWidth ENABLED false
set_parameter_property outFullFracBitWidth DERIVED true
set_parameter_property outFullFracBitWidth GROUP $output_group
set_parameter_property outFullFracBitWidth units bits

# | Get the number of input data ports (xIn_0 ... xIn_{n-1})
# +------------------------------------------------------------------
add_parameter inputInterfaceNum integer 1
set_parameter_display_from_strings inputInterfaceNum
set_parameter_property inputInterfaceNum DERIVED true
set_parameter_property inputInterfaceNum VISIBLE false

# | Get the number of output data ports (xOut_0 ... xOut_{n-1})
# +------------------------------------------------------------------
add_parameter outputInterfaceNum integer 1
set_parameter_display_from_strings outputInterfaceNum
set_parameter_property outputInterfaceNum DERIVED true
set_parameter_property outputInterfaceNum VISIBLE false

# | Get the number of channels per input data ports 
# +------------------------------------------------------------------
add_parameter chanPerInputInterface integer 1
set_parameter_display_from_strings chanPerInputInterface
set_parameter_property chanPerInputInterface DERIVED true
set_parameter_property chanPerInputInterface VISIBLE false

# | Get the number of channels per output data ports 
# +------------------------------------------------------------------
add_parameter chanPerOutputInterface integer 1
set_parameter_display_from_strings chanPerOutputInterface
set_parameter_property chanPerOutputInterface DERIVED true
set_parameter_property chanPerOutputInterface VISIBLE false

# | Get the latency reported
# +------------------------------------------------------------------
add_parameter latency integer 1
set_parameter_property latency DERIVED true
set_parameter_property latency VISIBLE false

add_parameter outputfifodepth integer 1
set_parameter_property outputfifodepth DERIVED true
set_parameter_property outputfifodepth VISIBLE false

#Parameter to store the results of the function call to the fir api 
add_parameter funcResult string ""
set_parameter_property funcResult DERIVED true
set_parameter_property funcResult VISIBLE false

add_parameter busAddressWidth integer 12
set_parameter_property busAddressWidth DERIVED true
set_parameter_property busAddressWidth VISIBLE false



# | Get the number of bankcount 
# +------------------------------------------------------------------
add_parameter bankCount integer 1
#set_parameter_property bankCount ALLOWED_RANGES {1:128}
set_parameter_display_from_strings bankCount
set_parameter_property bankCount VISIBLE false

# | And the bank port width 
# +------------------------------------------------------------------
add_parameter bankInWidth integer 1
#set_parameter_property bankInWidth ALLOWED_RANGES {1:128}
set_parameter_property bankInWidth VISIBLE false
set_parameter_property bankInWidth DERIVED true



# | Display coefficient bank 
# +------------------------------------------------------------------
add_parameter bankDisplay integer 0
set_parameter_property bankDisplay AFFECTS_ELABORATION false
set_parameter_property bankDisplay AFFECTS_VALIDATION false
set_parameter_property bankDisplay VISIBLE false

add_parameter lutCount integer
set_parameter_display_from_strings lutCount
set_parameter_property lutCount DERIVED true
set_parameter_property lutCount GROUP $resources_group

add_parameter dspCount integer
set_parameter_display_from_strings dspCount
set_parameter_property dspCount DERIVED true
set_parameter_property dspCount GROUP $resources_group

add_parameter memBitCount integer
set_parameter_display_from_strings memBitCount
set_parameter_property memBitCount DERIVED true
set_parameter_property memBitCount GROUP $resources_group

add_display_item $coeff_tab fir_widget_group group tab
add_display_item fir_widget_group coeff_table parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera dsp lib helpers com.altera.dsp.jar]
set widget_name coeff_table
set_display_item_property fir_widget_group WIDGET [list $jar_path $widget_name]
set_display_item_property fir_widget_group WIDGET_PARAMETER_MAP {
    bankCount               bankCount
    coeffSetRealValue       coeffSetRealValue
    coeffSetRealValueImag   coeffSetRealValueImag
    coeffSetFixedValue      coeffSetFixedValue
    coeffSetFixedValueImag  coeffSetFixedValueImag
    coeffSetScaleValue      coeffSetScaleValue
    coeffSetScaleValueImag  coeffSetScaleValueImag
    coeffScaling            coeffScaling
    coeffType               coeffType
    coeffBitWidth           coeffBitWidth
    coeffFracBitWidth       coeffFracBitWidth
    coeffBitWidth_derived   coeffBitWidth_derived
    coeffComplex            coeffComplex
    L_bandsFilter           L_bandsFilter
    symmetryMode            symmetryMode
    bankDisplay             bankDisplay
    inputRate               inputRate
    interpFactor            interpFactor
    decimFactor             decimFactor
}

# | This parameter check for error 
# +------------------------------------------------------------------
add_parameter errorList integer 0
set_parameter_property errorList DERIVED true
set_parameter_property errorList VISIBLE false




proc process_coefficients { } {
    set coeffReload  [get_parameter_value coeffReload]
    set readWriteMode [get_parameter_value readWriteMode]
        ## Coefficient parameters
    set coeffType [get_parameter_value coeffType]
    set coeffFracBitWidth [get_parameter_value coeffFracBitWidth]
    set coeffScaling [get_parameter_value coeffScaling]
    set coeffSetRealValue [get_parameter_value coeffSetRealValue]
    # Split the coefficients: semi-colon splits the banks up, comma splits the coefficients within a bank
    set coeffsByBank [split [get_parameter_value coeffSetRealValue] ";"]
    set bankIdx 0
    foreach bankCoeff $coeffsByBank {
        set coeffSetByBank($bankIdx) [split $bankCoeff ","]
        incr bankIdx
    }

    set coeffSetFullList [split [get_parameter_value coeffSetRealValue] ",;"]
    # For 10900 coefficients, this was the fastest way to find the min/max elements
    # (compared to min/max functions and iterating over the array)
    # That took about about ~3ms which is dwarfed by the time to generate the FIR
    set sortedCoeffs [lsort -real -decreasing $coeffSetFullList]
    set maxCoeff_full [expr {int([lindex $sortedCoeffs 0])}]
    set minCoeff_full [expr {int ([lindex $sortedCoeffs end])}]

    set abs_maxCoeff_full [expr {abs($maxCoeff_full)}]
    set abs_minCoeff_full [expr {abs($minCoeff_full)}]

    if { $abs_maxCoeff_full >= $abs_minCoeff_full } {
        if { $maxCoeff_full > 0 } {
            set log2_coefWidth_derived [expr {log($abs_maxCoeff_full + 1) / log(2)}]
        } else {
            set log2_coefWidth_derived 0
        }
    } else {
        if { $minCoeff_full > 0 } {
            set log2_coefWidth_derived [expr {log($abs_minCoeff_full) / log(2)}]
        } else {
            set log2_coefWidth_derived 0
        }
    }
    set coefIntBits [expr {int(ceil($log2_coefWidth_derived)) + 1}]
    if { $coeffType == "int" } {
        set_parameter_value coeffBitWidth_derived [get_parameter_value coeffBitWidth]
    } else {
        set_parameter_value coeffBitWidth_derived [expr {$coefIntBits + $coeffFracBitWidth}]
    }
    set coeffBitWidth_derived [get_parameter_value coeffBitWidth_derived]
    if { $coeffBitWidth_derived <= 16 } {
        set_parameter_value busDataWidth 16
    } else {
        set_parameter_value busDataWidth 32
    }
    set coeffNum [get_parameter_value coeffNum]
    set symmetryMode [get_parameter_value symmetryMode]
    set bankCount [get_parameter_value bankCount]
    if { $symmetryMode == "asym" || $symmetryMode == "sym" } {
        set bitsforAddress [expr int(ceil(log([get_parameter_value baseAddress] + $coeffNum/2*$bankCount)/log(2)))]
    } else {
        set bitsforAddress [expr int(ceil(log([get_parameter_value baseAddress] + ($coeffNum)*$bankCount)/log(2)))]
    }
    set_parameter_value busAddressWidth $bitsforAddress

}
# +------------------------------------------------------------------
# | Elaboration 
# +------------------------------------------------------------------
# With Avalon-ST wrapper
proc elaborate {} {
    set_parameter_value bankInWidth [dsp_get_width [get_parameter_value bankcount]]
    set bankInWidth [get_parameter_value bankInWidth]
    set coeffComplex [get_parameter_value coeffComplex]
    set inputBitWidth [get_parameter_value inputBitWidth]
    set inputInterfaceNum [get_parameter_value inputInterfaceNum]
    set outputInterfaceNum [get_parameter_value outputInterfaceNum]
    set chanPerInputInterface [get_parameter_value chanPerInputInterface]
    set chanPerOutputInterface [get_parameter_value chanPerOutputInterface]
    set outWidth [get_parameter_value outWidth]
    set outMsbBitRem [get_parameter_value outMsbBitRem]
    set outLsbBitRem [get_parameter_value outLsbBitRem]
    set backPressure [get_parameter_value backPressure]
    set reconfigurable [get_parameter_value reconfigurable]
    if { $reconfigurable } {
        set_parameter_value ModeWidth [dsp_get_width [get_parameter_value num_modes]]
    } else {
        set_parameter_value ModeWidth 0
    }
    set ModeWidth [get_parameter_value ModeWidth]
    # connection point clock
    add_interface clk clock end
    set_interface_property clk ENABLED true
    add_interface_port clk clk clk Input 1

    # connection point reset
    add_interface rst reset end
    set_interface_property rst ENABLED true
    set_interface_property rst associatedClock clk
    add_interface_port rst reset_n reset_n Input 1

    # connection point avalon_streaming_sink
    add_interface avalon_streaming_sink avalon_streaming end
    set_interface_property avalon_streaming_sink ENABLED true    
    set_interface_property avalon_streaming_sink associatedClock clk
    set_interface_property avalon_streaming_sink associatedReset rst
    set totalDataWidthIn [expr ($bankInWidth + $inputBitWidth)*$inputInterfaceNum + $ModeWidth]
    if { $coeffComplex } {
        set totalDataWidthIn [expr $bankInWidth + 2*$inputBitWidth*$inputInterfaceNum + $ModeWidth]
    }
    if { $ModeWidth > 0 } {
        add_interface_port avalon_streaming_sink ast_sink_data data input $totalDataWidthIn
        set_interface_property avalon_streaming_sink dataBitsPerSymbol $totalDataWidthIn
    } else {
        add_interface_port avalon_streaming_sink ast_sink_data data input $totalDataWidthIn
        set_interface_property avalon_streaming_sink dataBitsPerSymbol [expr ($bankInWidth + $inputBitWidth)]
        set_interface_property avalon_streaming_sink symbolsPerBeat $inputInterfaceNum
    }
    add_interface_port avalon_streaming_sink ast_sink_valid valid input 1
    add_interface_port avalon_streaming_sink ast_sink_error error Input 2

    if {$chanPerInputInterface > 1} {
        add_interface_port avalon_streaming_sink ast_sink_sop startofpacket input 1
        add_interface_port avalon_streaming_sink ast_sink_eop endofpacket input 1
    }

    set singleChanWidthOut [expr {int($outWidth - $outMsbBitRem - $outLsbBitRem)}]

    set totalDataWidthOut [expr $singleChanWidthOut*$outputInterfaceNum ]
    set symbolWidth [expr ($singleChanWidthOut) ]
    if { $coeffComplex } {
        set totalDataWidthOut [expr (2*$singleChanWidthOut)*$outputInterfaceNum ]
        set symbolWidth [expr (2*$singleChanWidthOut) ]
    }

    # connection point avalon_streaming_source
    add_interface avalon_streaming_source avalon_streaming start
    set_interface_property avalon_streaming_source ENABLED true    
    set_interface_property avalon_streaming_source associatedClock clk
    set_interface_property avalon_streaming_source associatedReset rst
    add_interface_port avalon_streaming_source ast_source_data data output $totalDataWidthOut
    add_interface_port avalon_streaming_source ast_source_valid valid output 1
    add_interface_port avalon_streaming_source ast_source_error error output 2
    set_interface_property avalon_streaming_source dataBitsPerSymbol $symbolWidth
    set_interface_property avalon_streaming_source symbolsPerBeat $outputInterfaceNum

    # Backpressure signals
    if { $backPressure } {
        add_interface_port avalon_streaming_sink ast_sink_ready ready output 1
        add_interface_port avalon_streaming_source ast_source_ready ready input 1
    }

    if {$chanPerOutputInterface > 1} {
        add_interface_port avalon_streaming_source ast_source_sop startofpacket output 1
        add_interface_port avalon_streaming_source ast_source_eop endofpacket output 1
        add_interface_port avalon_streaming_source ast_source_channel channel output [expr {int(ceil(log($chanPerOutputInterface)/log(2)))}]
        set_port_property ast_source_channel vhdl_type std_logic_vector
    }


    set coeffReload  [get_parameter_value coeffReload]
    set readWriteMode [get_parameter_value readWriteMode]

    set_parameter_value coefficientReadback false
    set_parameter_value coefficientWriteable false
    if { $coeffReload } {
        if { $readWriteMode == "read" } {
            set_parameter_value coefficientReadback true
        } elseif { $readWriteMode == "write" } {
            set_parameter_value coefficientWriteable true
        } else {
            set_parameter_value coefficientReadback true
            set_parameter_value coefficientWriteable true
        }
    }
    set coefficientReadback [get_parameter_value coefficientReadback]
    set coefficientWriteable [get_parameter_value coefficientWriteable]

    process_coefficients

    set busDataWidth [get_parameter_value busDataWidth]
    if { $coeffReload } {

        # connection point coefficient clock
        add_interface coeff_clock clock end
        set_interface_property coeff_clock ENABLED true
        add_interface_port coeff_clock coeff_in_clk clk input 1

        # connection point coefficient reset
        add_interface coeff_reset reset end
        set_interface_property coeff_reset ENABLED true
        set_interface_property coeff_reset associatedClock coeff_clock
        add_interface_port coeff_reset coeff_in_areset reset_n Input 1

        # connection point avalon_mm_slave
        add_interface avalon_mm_slave avalon slave
        set_interface_property avalon_mm_slave associatedClock coeff_clock
        set_interface_property avalon_mm_slave associatedReset coeff_reset
        set busAddressWidth [get_parameter_value busAddressWidth]
        add_interface_port avalon_mm_slave coeff_in_address address input $busAddressWidth

        if { $coefficientReadback } {
            set_interface_property avalon_mm_slave maximumPendingReadTransactions 1
            add_interface_port avalon_mm_slave coeff_in_read read input 1
            add_interface_port avalon_mm_slave coeff_out_valid readdatavalid output 1
            set_port_property coeff_out_valid vhdl_type std_logic_vector
            add_interface_port avalon_mm_slave coeff_out_data readdata output $busDataWidth
        }
        if { $coefficientWriteable } {
            add_interface_port avalon_mm_slave coeff_in_we write input 1
            set_port_property coeff_in_we vhdl_type std_logic_vector
            add_interface_port avalon_mm_slave coeff_in_data writedata input $busDataWidth
        }
    }
}


proc round_to_zero {x} {
    if { $x >= 0 } {
        return [expr {int(floor($x))} ]
    } else {
        return [expr  {int(ceil($x))} ]
    }
}

#Being a bit naughty here, we used to comma separate, now we ; separate banks (allows non-even number of taps in banks - whereas before whilst you were 
# editing banks the validation would screw up) so now we figure out if we're under the old system and push into the new system
proc modifyFormat {coefficientsTemp} {
    set totalBanks [get_parameter_value bankCount]
    unset -nocomplain coefsbybankList
    if { [llength $coefficientsTemp] != $totalBanks && [llength $coefficientsTemp] == 1} {
        set tempCoeffs [split $coefficientsTemp ","]
        set taps [expr [llength $tempCoeffs]/$totalBanks ]
        for {set i 0} {$i < $totalBanks} {incr i} {
            for {set j 0} {$j < $taps} {incr j} {
                set index [expr $j + $i*$taps]
                if { $j == 0} {
                    set curBank [lindex $tempCoeffs $index]
                } else {
                    lappend curBank [lindex $tempCoeffs $index]
                }
            }
        lappend coefsbybankList [join $curBank ","]
        }
        set coefficientsTemp $coefsbybankList
    }    
    return $coefficientsTemp
}


proc setup_params_if_no_error {mode} {
    set coeffsByBank [split [get_parameter_value coeffSetRealValue] ";"]
    # send_message INFO "Real Coefs: [get_parameter_value coeffSetRealValue]"
    set totalBanks [get_parameter_value bankCount]
    set coeffComplex [get_parameter_value coeffComplex]
    set coeffType [get_parameter_value coeffType]
    set coeffsByBank [modifyFormat $coeffsByBank]


    if {$coeffComplex} {
        set imagCoeffsbyBank [split [get_parameter_value coeffSetRealValueImag] ";"]
        set imagCoeffsbyBank [modifyFormat $imagCoeffsbyBank]
    }
    # send_message INFO "Imag Coefs: [get_parameter_value coeffSetRealValueImag]"
    for {set i 0} {$i < $totalBanks} {incr i} {
        set realCoeffsInBank [llength [split [lindex $coeffsByBank $i] ,]]
        lappend coefCountByBankList $realCoeffsInBank
        if {$coeffComplex} {
            set imagCoeffsInBank [llength [split [lindex $imagCoeffsbyBank $i] ,]]
            lappend coefCountByBankList $imagCoeffsInBank
            if { $imagCoeffsInBank != $realCoeffsInBank } {
                send_message ERROR "In Complex mode the every value must have both a real and complex value"
                return
            }
        }

    }
    set errorList 0

    set sortedCoefCountByBankList [lsort -real -decreasing $coefCountByBankList]
    set mostCoefs [lindex $sortedCoefCountByBankList 0]
    set leastCoefs [lindex $sortedCoefCountByBankList end]
    if { $mostCoefs != $leastCoefs } {
        send_message error "Banks should all have the same number of coefficients in them"
        return
    }

    # given number of banks should be equal to bank count
    if { [llength $coeffsByBank] != [get_parameter_value bankCount] } {
        send_message error "Bank count ([get_parameter_value bankCount]) does not match banks implied by coef structure ([llength coeffsByBank])"
        return
    }

    set num_of_coefs $mostCoefs

    # Separate coefficients into banks for scaling
    for {set bank 0} { $bank < $totalBanks} {incr bank} {
        set coeffSetList [split [lindex $coeffsByBank $bank] ,]
        set coeffSetScaleValuePerBank $coeffSetList
        set coeffSetFixedValuePerBank $coeffSetList
        set sortedCoeffs [lsort -real -decreasing $coeffSetList]
        set maxCoeff [lindex $sortedCoeffs 0]
        set minCoeff [lindex $sortedCoeffs end]
        set abs_maxCoeff [expr {abs($maxCoeff)}]
        set abs_minCoeff [expr {abs($minCoeff)}]

        set coeffBitWidth_derived [get_parameter_value coeffBitWidth_derived]
        set coeffFracBitWidth [get_parameter_value coeffFracBitWidth]
        if { [get_parameter_value coeffScaling] == "auto" } {
            if { $abs_maxCoeff < $abs_minCoeff } {
                set factor [expr {pow(2, $coeffBitWidth_derived - 1) / $abs_minCoeff}]
            } elseif {$abs_minCoeff == $abs_maxCoeff && $abs_maxCoeff == 0} {
                set factor 1 
            } else {
                set factor [expr {(pow(2,$coeffBitWidth_derived - 1) - 1) / $abs_maxCoeff}]
            } 
        } else {
            if { $coeffType != "int"} {
                set factor [expr {pow(2,$coeffFracBitWidth)}]
            } else {
                set factor 1
            }
        }
        for {set i 0} { $i < [llength $coeffSetList]} {incr i} {
            set scaledValue [round_to_zero [expr {[lindex $coeffSetList $i] * $factor}]]
            set coeffSetFixedValuePerBank [lreplace $coeffSetFixedValuePerBank $i $i $scaledValue]
            set coeffSetScaleValuePerBank [lreplace $coeffSetScaleValuePerBank $i $i [expr {$scaledValue / $factor}]]
        }
        set coeffSetFixedValue($bank) $coeffSetFixedValuePerBank
        set coeffSetScaleValue($bank) $coeffSetScaleValuePerBank
    }

    # Check if all fixed-point coefficients are zero.
    set coef_all_zero 1
    for {set i 0} {$i < $totalBanks} {incr i} {
        for {set j 0} {$j < [llength $coeffSetFixedValue($i)]} {incr j} {
            if {[lindex $coeffSetFixedValue($i) $j] != 0 } {
                set coef_all_zero 0
                break
            }
        }
    }


    if { $coef_all_zero == 1 } {
        send_message_from_strings error ERROR_ALL_ZEROS
        return
    }

    set coeffSetFixedValueList ""
    for {set i 0} {$i < $totalBanks} {incr i} {
        set coeffSetBank $coeffSetFixedValue($i) 
        set bankList [join $coeffSetBank ","]
        append coeffSetFixedValueList $bankList
        if { $i < [expr $totalBanks - 1]} {
            append coeffSetFixedValueList ";"
        }    
    }


    set coeffSetScaleValueList ""
    for {set i 0} {$i < $totalBanks} {incr i} {
        set coeffSetBank $coeffSetScaleValue($i) 
        set bankList [join $coeffSetBank ","]
        append coeffSetScaleValueList $bankList
        if { $i < [expr $totalBanks - 1]} {
            append coeffSetScaleValueList ";"
        }
    }

    if { $mode == "validate" } {

        # puts "coeffSetFixedValue $coeffSetFixedValueList"
        # puts "coeffSetScaleValue $coeffSetScaleValueList"
        # puts "coeffNum $num_of_coefs"
        # puts "numBanks [get_parameter_value bankCount]"

        set_parameter_value coeffSetFixedValue $coeffSetFixedValueList
        set_parameter_value coeffSetScaleValue $coeffSetScaleValueList
        set_parameter_value coeffNum $num_of_coefs
    }


    #Sorry, yes, copy-pasted. 
    if {$coeffComplex} {
        for {set bank 0} { $bank < $totalBanks} {incr bank} {
            set coeffSetList [split [lindex $imagCoeffsbyBank $bank] ,]
            set coeffSetScaleValuePerBank $coeffSetList
            set coeffSetFixedValuePerBank $coeffSetList
            set sortedCoeffs [lsort -real -decreasing $coeffSetList]
            set maxCoeff [lindex $sortedCoeffs 0]
            set minCoeff [lindex $sortedCoeffs end]
            set abs_maxCoeff [expr {abs($maxCoeff)}]
            set abs_minCoeff [expr {abs($minCoeff)}]

            set coeffBitWidth_derived [get_parameter_value coeffBitWidth_derived]
            set coeffFracBitWidth [get_parameter_value coeffFracBitWidth]
            if { [get_parameter_value coeffScaling] == "auto" } {
                if { $abs_maxCoeff > $abs_minCoeff } {
                    set factor [expr {(pow(2,$coeffBitWidth_derived - 1) - 1) / $abs_maxCoeff}]
                } elseif { $abs_maxCoeff < $abs_minCoeff } {
                    set factor [expr {pow(2, $coeffBitWidth_derived - 1) / $abs_minCoeff}]
                } else {
                    set factor [expr {pow(2, $coeffBitWidth_derived)}]
                }
            } else {
                if { $coeffFracBitWidth > 0 } {
                    set factor [expr {pow(2,$coeffFracBitWidth)}]
                } else {
                    set factor 1
                }
            }

            for {set i 0} { $i < [llength $coeffSetList]} {incr i} {
                set scaledValue [round_to_zero [expr {[lindex $coeffSetList $i] * $factor}]]
                set coeffSetFixedValuePerBank [lreplace $coeffSetFixedValuePerBank $i $i $scaledValue]
                set coeffSetScaleValuePerBank [lreplace $coeffSetScaleValuePerBank $i $i [expr {$scaledValue / $factor}]]
            }

            set coeffSetFixedValue($bank) $coeffSetFixedValuePerBank
            set coeffSetScaleValue($bank) $coeffSetScaleValuePerBank
        }

        # Check if all fixed-point coefficients are zero.
        set coef_all_zero 1
        for {set i 0} {$i < $totalBanks} {incr i} {
            for {set j 0} {$j < [llength $coeffSetFixedValue($i)]} {incr j} {
                if {[lindex $coeffSetFixedValue($i) $j] != 0 } {
                    set coef_all_zero 0
                    break
                }
            }
        }


        if { $coef_all_zero == 1 } {
            send_message_from_strings error ERROR_ALL_ZEROS
            return
        }

        set coeffSetFixedValueList ""
        for {set i 0} {$i < $totalBanks} {incr i} {
            set coeffSetBank $coeffSetFixedValue($i) 
            set bankList [join $coeffSetBank ","]
            append coeffSetFixedValueList $bankList
            if { $i < [expr $totalBanks - 1]} {
                append coeffSetFixedValueList ";"
            }    
        }


        set coeffSetScaleValueList ""
        for {set i 0} {$i < $totalBanks} {incr i} {
            set coeffSetBank $coeffSetScaleValue($i) 
            set bankList [join $coeffSetBank ","]
            append coeffSetScaleValueList $bankList
            if { $i < [expr $totalBanks - 1]} {
                append coeffSetScaleValueList ";"
            }
        }

        if { $mode == "validate" } {

            set_parameter_value coeffSetFixedValueImag $coeffSetFixedValueList
            set_parameter_value coeffSetScaleValueImag $coeffSetScaleValueList
        }
    }






    # End fixed point and scale coefficient calculation

    # name and destination not important in this validation callback as we don't generate files here

    #Call fir_ip_api_interface without generating rtl files
    call_fir_api_wrapper  ""
    
    set funcResult [get_parameter_value funcResult]
    if {$funcResult != ""} {
        set funcResultList [split $funcResult "|"]
        set funcResultListLength [llength $funcResultList]
        if {$funcResultListLength == 2} {
            send_message_from_strings error ERROR_FIR_IP_API_CREATING_CORE
        } elseif { $funcResultListLength == 13} {
            if { [string compare [lindex $funcResultList 1] "{}"] != 0 } {
                set errorMessage [lindex $funcResultList 1]
                regsub {^\{(.*)\}$} $errorMessage {\1} errorMessage
                send_message error "$errorMessage"
                set_parameter_value errorList 1
            } else {
                if { $mode == "validate" } {
                    set outType [get_parameter_value outType]
                    if { $outType eq "frac" } {
                        set_parameter_value outFracBitWidth [expr [get_parameter_value outFullFracBitWidth] - [get_parameter_value outLsbBitRem]]
                    } else {
                        set_parameter_value outFracBitWidth 0
                    }
                }
            }
        } else {
            set expectedArgs 12
            send_message_from_strings error ERROR_FIR_IP_API_WRONG_NUM
        }
    }
}


# +------------------------------------------------------------------
# | Validation
# +------------------------------------------------------------------
proc validation {} {
    set num_modes [get_parameter_value num_modes]
    set modeList [get_parameter_value MODE_STRING ]
    set expected_modes [llength $modeList]
    set reconfigurable [get_parameter_value reconfigurable]

    if { $reconfigurable } {
        ## Display List
        set_parameter_property num_modes VISIBLE true
        set_parameter_property channelModes VISIBLE true
        set_parameter_property reconfigurable_list VISIBLE true
        set_display_item_property "Set Mode" VISIBLE true

        set MS [get_parameter_value MODE_STRING ]
        set num_modes [get_parameter_value num_modes ]
        set ListofModes [split $MS "_"]
        # puts "LoM: $ListofModes"
        for {set i 0} {$i < $num_modes} {incr i} {
            if { $i < [llength $ListofModes] } {
                lappend ModeListRange "$i:$i:[lindex $ListofModes $i]"
            } else {
                lappend ModeListRange "$i:$i:None Set"
            }
        }
        # puts "ModeListRange $ModeListRange"
        # puts "ModeListRange $ModeListRange"
        set_parameter_property reconfigurable_list ALLOWED_RANGES $ModeListRange

        set modeList [get_parameter_value MODE_STRING ]
        set ExpectedTimeSlots [get_parameter_value inputChannelNum]
        set modeString ""
        set err "0" 
        # puts "modeList [llength $modeList] num_modes; $num_modes"
        if { [expr [llength $modeList]-1] >= $num_modes } {
                send_message ERROR "Please set channel order for all modes, $num_modes selected, only [llength $modeList]-1] set"
        }
        set modeList [split $modeList "_"]
        for {set i 0} {$i < $num_modes} {incr i} {
            set curMode [lindex $modeList $i]
            set timeSlot [split $curMode ","]
            # puts "curMode $curMode"
            # puts "timeSlot $timeSlot"

            if { $curMode eq "None Set" } {
                send_message ERROR "Please set channel order for mode $i"
                set err "1"
                break
            }
            if { [llength $timeSlot] ne $ExpectedTimeSlots } {
                send_message ERROR "Illegal Mode, Mode $i contains the wrong number of channels, expecting $ExpectedTimeSlots time slots to be filled got [llength $timeSlot]"
                set err "1"
                break
            }
            for {set j 0} {$j < [llength $timeSlot]} {incr j} {
                set curChan [lindex $timeSlot $j]
                if { ![string is integer $curChan] } {
                    send_message ERROR "Illegal channel number for timeslot $j on mode $i: $curChan, must be between the max number of channels and 0"
                    set err "1"
                    break
                }
                if { $curChan >= $ExpectedTimeSlots || $curChan < 0 } {
                    send_message ERROR "Illegal channel number for timeslot $j on mode $i: $curChan"
                    set err "1"
                    break
                }
            }
            if { $err eq "1" } {
                break
            } 
        }
        if { [get_parameter_value reconfigurable] } {
            set modeRaw [get_parameter_value MODE_STRING]
            set modeRawSplit [split $modeRaw "_"] 
            for {set i 0} {$i < [get_parameter_value num_modes]} {incr i} {
                lappend modeFormatted [lindex $modeRawSplit $i]
            }
            set modeFormatted [join $modeFormatted "_"]
            set_parameter_value modeFormatted $modeFormatted
        } else {
            set_parameter_value modeFormatted "--"
        }
    } else {
        set_parameter_value modeFormatted "--"
        set_parameter_property num_modes VISIBLE false
        set_parameter_property reconfigurable_list VISIBLE false
        set_parameter_property channelModes VISIBLE false
        set_display_item_property "Set Mode" VISIBLE false
        for {set i 0} {$i < 1025} {incr i} {
            lappend range $i
        }
        set_parameter_property reconfigurable_list ALLOWED_RANGES $range
        # set_parameter_property reconfigurable_list derived true
        # set_parameter_value reconfigurable_list 0
    }


    set errorList 0

    set clockRate [get_parameter_value clockRate]
    set filterType [get_parameter_value filterType]
    set interpFactor [get_parameter_value interpFactor]
    set decimFactor [get_parameter_value decimFactor]


    if { $clockRate > 600 || $clockRate <= 0 }  {
        send_message_from_strings error ERROR_INVALID_CLOCK_FREQ
        set errorList 1
    }

    if { $filterType == "single" } {
        if { $interpFactor != 1 || $decimFactor != 1 }  {
            send_message_from_strings error ERROR_SINGLE_RATE_BAD_INTERP_DECIM
            set errorList 1
        }
    } elseif { $filterType == "decim" } {
        if { $decimFactor == 1 || $interpFactor != 1 } {
            send_message_from_strings error ERROR_DECIM_BAD_INTERP
            set errorList 1
        }
    } elseif { $filterType == "interp" } {
        if { $decimFactor != 1 || $interpFactor == 1 } {
            send_message_from_strings error ERROR_INTERP_BAD_DECIM
            set errorList 1
        }
    } else {
        if { $decimFactor == 1 || $interpFactor == 1 } {
            send_message_from_strings error ERROR_FRAC_BAD_INTERP_DECIM
            set errorList 1
        }
    }   
    set devicefamily [get_parameter_value deviceFamily]
    set supportedfamilies [get_module_property SUPPORTED_DEVICE_FAMILIES]

    if { [lsearch $supportedfamilies $devicefamily] == -1 } {
        send_message_from_strings error "$devicefamily Device family not supported"
        set errorList 1
    }
    ## Update Coeff reload mode
    if { [get_parameter_value coeffReload] } {
        set_parameter_property baseAddress ENABLED true
        set_parameter_property readWriteMode ENABLED true
    } else {
        set_parameter_property baseAddress ENABLED false
        set_parameter_property readWriteMode ENABLED false
    }   
    set inputType [get_parameter_value inputType]
    set inputBitWidth [get_parameter_value inputBitWidth]
    set inputFracBitWidth [get_parameter_value inputFracBitWidth]
    if { $inputType == "int" } {
        set_parameter_property inputFracBitWidth ENABLED false
        if { $inputBitWidth == 0 } {
            send_message_from_strings error ERROR_INPUT_INT_BAD_WIDTH_AND_FRAC
            set errorList 1
        }
    } else {
        set_parameter_property inputFracBitWidth ENABLED true
        set max_frac_width [expr {$inputBitWidth - 1}]
        if { $inputFracBitWidth > $max_frac_width } {
            send_message_from_strings error ERROR_INPUT_FRAC_BAD_FRAC_WIDTH
            set errorList 1
        }
    }

    set_parameter_property coeffType ENABLED true
    set coeffType [get_parameter_value coeffType]
    set coeffFracBitWidth [get_parameter_value coeffFracBitWidth]
    set coeffBitWidth_derived [get_parameter_value coeffBitWidth_derived]
    set coeffReload [get_parameter_value coeffReload]
    if { $coeffType == "int" } {
        set_parameter_property coeffFracBitWidth ENABLED false
        set_parameter_property coeffBitWidth ENABLED true
        if { $coeffBitWidth_derived == 0 } {
            send_message_from_strings error ERROR_COEFF_INT_BAD_WIDTH_AND_FRAC
            set errorList 1
        }   
    } else {
        set_parameter_property coeffFracBitWidth ENABLED true
        if { $coeffReload == false } {
            set_parameter_property coeffBitWidth ENABLED false
        } else {
            set_parameter_property coeffBitWidth ENABLED true
            set totalWidth [expr {$coeffBitWidth_derived }]
            if { [get_parameter_value coeffBitWidth] < $totalWidth } {
                send_message_from_strings error ERROR_COEFF_FRAC_BAD_TOTAL_WIDTH
                set errorList 1
            }

        }
        if { $coeffBitWidth_derived == 0 || $coeffFracBitWidth == 0 } {
            send_message_from_strings error ERROR_COEFF_FRAC_BAD_FRAC_WIDTH
            set errorList 1
        }
    }

    ## Update output Bit Width
    set inputChannelNum [get_parameter_value inputChannelNum]
    set inputRate [get_parameter_value inputRate]
    set clockRate [get_parameter_value clockRate]
    set outType [get_parameter_value outType]
    set outFracBitWidth [get_parameter_value outFracBitWidth]
    set outLsbBitRem [get_parameter_value outLsbBitRem]


    if { $outType eq "frac" } {
        if { $coeffType != "frac" || $inputType != "frac"} {
            send_message_from_strings error ERROR_OUT_FRAC_OTHERS_MUST_BE_FRAC
            set errorList 1
        }    
    }



    if { $inputChannelNum < 1 || $inputChannelNum > 1024 } {
        send_message_from_strings error ERROR_CHANS_OUT_OF_RANGE
        set errorList 1
    }

    if { $inputRate <= 0 || $inputRate > 10000 } {
        send_message_from_strings error ERROR_IN_RATE_OUT_OF_RANGE
        set errorList 1
    }

    if { $clockRate > 0 } {
        if { $inputRate / $clockRate > 100 } {
            send_message_from_strings error ERROR_CLOCK_RATE_OUT_OF_RANGE
            set errorList 1
        }
    }

    if { [expr {$coeffBitWidth_derived}] > 32 } {
        send_message info "$coeffBitWidth_derived + $coeffFracBitWidth"
        send_message_from_strings error ERROR_COEFF_WIDTH_TOO_HIGH
        set errorList 1
    }


    if {$errorList == 0} {
        setup_params_if_no_error validate
    } else {
        send_message error "Failed to validate, not running FIR"
    }

    set outBitWidth [get_parameter_value outBitWidth]
    set outWidth [get_parameter_value outWidth]


    if { $outBitWidth > $outWidth } {
        send_message_from_strings error ERROR_OUT_WIDTH_MORE_THAN_FULL
    }

    if { $outFracBitWidth > $outWidth } {
        send_message_from_strings error ERROR_OUT_FRAC_WIDTH_MORE_THAN_FULL_FRAC
    }

    ## post-processing validation
    # have to re-read these values as they may have changed above
    set outWidth [get_parameter_value outWidth]
    # Output Type = Signed Fractional Binary format    
    if { $outType eq "frac" } {
        # if { $outLsbBitRem > $outWidth } {
        #     send_message_from_strings error ERROR_TOO_MANY_FRAC_LSB_BITS
        #     set errorList 1
        # }
        # set int_bits_derived [expr [get_parameter_value coeffBitWidth_derived] - [get_parameter_value coeffFracBitWidth]]
        # if { [get_parameter_value outMsbBitRem] >= $int_bits_derived } {
        #     send_message_from_strings error ERROR_TOO_MANY_FRAC_MSB_BITS
        #     set errorList 1
        # }
        # Output Type = Signed Binary format
    }  else {
        set_parameter_value outFullFracBitWidth 0
        set_parameter_value outFracBitWidth 0
    }

    set total_removed_bit [expr [get_parameter_value outMsbBitRem] + [get_parameter_value outLsbBitRem] + 2]
    if { $total_removed_bit > $outWidth } {
        send_message_from_strings error ERROR_OUTPUT_WIDTH_TOO_SMALL
        set errorList 1
    }
}

proc setModeCallback {} {
    set MS [get_parameter_value MODE_STRING ]
    set newItem [get_parameter_value channelModes]
    set ItemLocation [get_parameter_value reconfigurable_list]

    set ListofModes [split $MS "_"]
    set numModes  [llength $ListofModes] 
    # puts "LoM $ListofModes"
    # puts "Existing list [llength $ListofModes] and inserting $ItemLocation"
    # If we're trying to set a location that is disjoint with the current list then we need to extend the list
    if { $numModes <= $ItemLocation } {
     # puts "Adding"
        for {set i [expr $numModes-1]} {$i < $ItemLocation} {incr i} {
            # puts "Adding $i"
            lappend ListofModes  "None Set"
        }
    }
    # puts "LoM $ListofModes"
    # puts "New $newItem"
    set newListofModes [lreplace $ListofModes $ItemLocation $ItemLocation $newItem]
    # puts "LoM $newListofModes"
    set NewMS [join $newListofModes "_"]
    # puts "NewMS $NewMS"

    set_parameter_value MODE_STRING $NewMS
    #generate a reasonable suggestion 
    for {set i 0} {$i < [get_parameter_value inputChannelNum]} {incr i} {
        lappend newSuggestion $i
    }
    set_parameter_value channelModes [join $newSuggestion ","]
    validation
}

proc create_temp_dir {} {
    set temp_dir  [create_temp_file ""] 
    file mkdir $temp_dir
    return $temp_dir
}



# +-----------------------------------------------------------------------------
# | Synthesis Files Generation
# +-----------------------------------------------------------------------------
proc gen_synth_files {entity} {
    gen_files $entity "false"
}

proc gen_files {entity sim} {
    global env
    set common_files [add_common_files]
    lappend common_files "${env(QUARTUS_ROOTDIR)}/../ip/altera/sopc_builder_ip/altera_avalon_sc_fifo/altera_avalon_sc_fifo.v"    
    add_core_file_list $common_files



    #Call fir_ip_api_interface to generate rtl files
    set temp_dir [create_temp_dir]

    set entity_name "${entity}_rtl"
    set entity "${entity}"
    #When we go complex obviously we'll have to sort between the real and imag vals

    call_fir_api_wrapper $entity

    set inputInterfaceNum [get_parameter_value inputInterfaceNum]
    set outputInterfaceNum [get_parameter_value outputInterfaceNum]
    set chanPerInputInterface [get_parameter_value chanPerInputInterface]
    set chanPerOutputInterface [get_parameter_value chanPerOutputInterface]
    set outWidth [get_parameter_value outWidth]
    set bankCount [get_parameter_value bankCount]
    set latency [get_parameter_value latency]
    set coeffBitWidth_derived [get_parameter_value coeffBitWidth_derived]
    set clockRate [get_parameter_value clockRate]


    send_message info "PhysChanIn $inputInterfaceNum, PhysChanOut $outputInterfaceNum, ChansPerPhyIn $chanPerInputInterface, ChansPerPhyOut $chanPerOutputInterface, OutputFullBitWidth $outWidth, Bankcount $bankCount, Latency $latency, CoefBitWidth $coeffBitWidth_derived"

    foreach param [lsort [get_parameters]] {
        set terp_array($param) [get_parameter_value $param]
    }
    set terp_array(busDataWidth_msb) [expr $terp_array(busDataWidth) - 1]
    set terp_array(entity) $entity

    if { $terp_array(chanPerOutputInterface) > 1} {
        set terp_array(use_packets) 1
    } else {
        set terp_array(use_packets) 0
    }

    set terp_array(log2_outputfifodepth) [expr {log($terp_array(outputfifodepth))/log(2)}]
    set terp_array(log2_outputfifodepth) [expr {int(ceil($terp_array(log2_outputfifodepth)))}]
    if {$terp_array(log2_outputfifodepth) > 1} {
    } else {
        set terp_array(log2_outputfifodepth) 1
    }


    set terp_array(antilog2_outputfifodepth) [expr {int(2 ** $terp_array(log2_outputfifodepth))}]
    set terp_array(extension) ".vhd"



    set terp_array(ComplexConstant) 1
    if { [get_parameter_value coeffComplex] } {
        set terp_array(ComplexConstant) 2
    }

    set template_path "ast_components/hpfir_ast_temp.vhd.template" ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it
    # foreach idx [array names terp_array] {send_message INFO "$idx : $terp_array($idx)"}
    set contents [altera_terp $template terp_array] ;# pass parameter array in by reference


    # Create Avalon-ST wrapper
    add_fileset_file ${entity}_ast.vhd VHDL Text $contents


    set template_path "top.vhd.terp" ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it
    set contents [altera_terp $template terp_array] ;# pass parameter array in by reference
    add_fileset_file ${entity}.vhd VHDL Text $contents





    if { $sim == "true" } {
        src gen_nativelink.tcl $temp_dir $entity "VHDL"
        add_core_file "${temp_dir}/${entity}_nativelink.tcl"

        # Generate msim script
        set ver [get_module_property VERSION]
        src gen_msim.tcl $temp_dir $entity $ver [get_parameter_value deviceFamily] $env(QUARTUS_ROOTDIR)
        add_core_file "${temp_dir}/${entity}_msim.tcl"

        # Generate testbench


        set template_path "testbench.vhd.terp" ;# path to the TERP template
        set template_fd   [open $template_path] ;# file handle for template
        set template      [read $template_fd]   ;# template contents
        close $template_fd ;# we are done with the file so we should close it
        set contents [altera_terp $template terp_array] ;# pass parameter array in by reference
        add_fileset_file ${entity}_tb.vhd VHDL Text $contents


        # src gen_testbench.tcl $temp_dir $entity $ver $config(PhysChanIn) $config(PhysChanOut) $config(ChansPerPhyIn) $config(ChansPerPhyOut) $config(InWidth) $config(outWidth) $inputParams(nChans) $config(Log2_ChansPerPhyOut) $inputParams(nTaps) $config(readWriteMode) $inputParams(clockRate) $inputParams(inRate) $inputParams(interpN) $inputParams(baseAddr) $config(coeffBitWidth_derived) $config(busDataWidth) $config(bankcount) $config(bankInWidth) $inputParams(symmetry_type) $config(useClkEnable) $config(ModeWidth)
        # add_core_file "${temp_dir}/${entity}_tb.vhd"
        foreach param [lsort [get_parameters]] {
            set $param [get_parameter_value $param]
        }
        set coefsReal [get_parameter_value coeffSetFixedValue]
        set coefsImag [get_parameter_value coeffSetFixedValueImag]
        set coeffSetReal [string map {";" ","} $coefsReal]
        set coeffSetImag [string map {";" ","} $coefsImag]
        # puts "Gen Matlab: $coeffSetReal"
        src gen_matlab.tcl $temp_dir $entity $ver $coeffReload $coeffNum $inputBitWidth $filterType $interpFactor $decimFactor $outBitWidth $coefsReal $outMsbBitRem $outMSBRound $outLsbBitRem $outLSBRound $inputChannelNum $inputInterfaceNum $coeffBitWidth_derived $coefficientWriteable $symmetryMode $bankCount $reconfigurable $modeFormatted $coeffComplex $coefsImag
        add_core_file "${temp_dir}/${entity}_mlab.m"
        add_core_file "${temp_dir}/${entity}_model.m"
        add_core_file "${temp_dir}/${entity}_coef_int.txt"

        if {[get_parameter_value coefficientWriteable]} {
            add_core_file "${temp_dir}/${entity}_coef_reload.txt"
            add_core_file "${temp_dir}/${entity}_coef_reload_rtl.txt"
        }

        # Generate input data file
        src gen_input.tcl $temp_dir $entity $inputBitWidth $filterType $interpFactor $decimFactor $inputChannelNum $coeffNum $clockRate $inputRate $bankCount $modeFormatted $coeffComplex
        add_core_file "${temp_dir}/${entity}_input.txt"

        # Generate parameter file
        set effInputFracWidth [get_parameter_value inputFracBitWidth]
        if { $inputType == "int" } {
            set effInputFracWidth 0
        }
        src gen_param.tcl $temp_dir $entity $inputInterfaceNum $outputInterfaceNum $chanPerInputInterface $chanPerOutputInterface $inputBitWidth $effInputFracWidth $outBitWidth $outWidth $outFracBitWidth $outFullFracBitWidth $coeffNum $coeffNum $clockRate $inputRate $interpFactor $decimFactor $busDataWidth [dsp_get_width $bankCount] [get_parameter_value ModeWidth]
        add_core_file "${temp_dir}/${entity}_param.txt"
    }

}

proc gen_sim_vhdl_files {entity} {
    gen_sim_files $entity VHDL
}

proc gen_sim_verilog_files {entity} {
    gen_sim_files $entity VERILOG
}

# +-----------------------------------------------------------------------------
# | Simulation Files Generation
# +-----------------------------------------------------------------------------
proc gen_sim_files {entity hdl_type} {
    gen_files $entity "true"
    
}
proc call_fir_api_wrapper  {prefix} { 
    if {[get_parameter_value coeffComplex]} {
        set coefs [get_parameter_value coeffSetFixedValue]
        set coeffSet [string map {";" ","} $coefs]
        call_fir_ip_api_interface $prefix "rr" $coeffSet
        call_fir_ip_api_interface $prefix "ri" $coeffSet
        call_fir_ip_api_interface $prefix "ir" $coeffSet
        call_fir_ip_api_interface $prefix "ii" $coeffSet
    } else {
        set coefs [get_parameter_value coeffSetFixedValue]
        set coeffSet [string map {";" ","} $coefs]
        call_fir_ip_api_interface $prefix "core" $coeffSet
    }


}
# +-----------------------------------------------------------------------------
# | call_fir_ip_api_interface
# +-----------------------------------------------------------------------------
proc call_fir_ip_api_interface {prefix suffix coeffSet} {
    set entity "${prefix}_rtl_${suffix}"
    global env
    global DSPBA_BACKEND_BIN_DIR
    set list_of_files [list]
    # Run executable to call back-end fir_ip_api to generate real VHDL code and files with the specified parameters value above
    # On linux the location is a shell wrapper which sets up its own environment, so we don't need to worry about it
    set fir_ip_api_interface "${DSPBA_BACKEND_BIN_DIR}/fir_ip_api_interface"

    if {$prefix == ""} {
        set generateCode false
        set entity "dummy"
        set temp_dir "null"
    } else {
        set temp_dir [create_temp_dir]
        set generateCode true
    }
    foreach param [lsort [get_parameters]] {
        set $param [get_parameter_value $param]
    }
    set symmetry 2
    if { $symmetryMode == "nsym" } {
        set symmetry 1
    }
    if {$inputType eq "int"} {
        set inputFracBitWidth 0
    }
    set DeviceFamilyArg [regsub -all {\s+} [string toupper ${deviceFamily}] ""]
    # puts  "fir_ip_api_interface $fir_ip_api_interface  entity ${entity} .  .  DeviceFamilyArg $DeviceFamilyArg  speedGrade $speedGrade  clockRate $clockRate  clockSlack $clockSlack  inputChannelNum $inputChannelNum  inputRate $inputRate  coeffNum $coeffNum  interpFactor $interpFactor  decimFactor $decimFactor  symmetry $symmetry  symmetryMode $symmetryMode  L_bandsFilter $L_bandsFilter  inputBitWidth $inputBitWidth  inputFracBitWidth $inputFracBitWidth  coeffBitWidth_derived $coeffBitWidth_derived  coeffFracBitWidth $coeffFracBitWidth  baseAddress $baseAddress  coefficientReadback $coefficientReadback  coefficientWriteable $coefficientWriteable --  --  busDataWidth $busDataWidth  busAddressWidth $busAddressWidth  delayRAMBlockThreshold $delayRAMBlockThreshold  dualMemDistRAMThreshold $dualMemDistRAMThreshold  mRAMThreshold $mRAMThreshold  hardMultiplierThreshold $hardMultiplierThreshold  generateCode $generateCode  backPressure $backPressure  bankCount $bankCount  modeFormatted $modeFormatted  <<<  coeffSet $coeffSet  "

    send_message debug "$fir_ip_api_interface ${entity} . $DeviceFamilyArg $speedGrade $clockSlack $clockRate $inputChannelNum $inputRate $coeffNum $interpFactor $decimFactor $symmetry $symmetryMode $L_bandsFilter $inputBitWidth $inputFracBitWidth $coeffBitWidth_derived $coeffFracBitWidth $baseAddress $coefficientReadback $coefficientWriteable -- $busDataWidth $busAddressWidth $delayRAMBlockThreshold $dualMemDistRAMThreshold $mRAMThreshold $hardMultiplierThreshold $generateCode $backPressure $bankCount $modeFormatted <<< $coeffSet "
    if { [ catch { set funcResult [exec $fir_ip_api_interface ${entity} $temp_dir $DeviceFamilyArg $speedGrade $clockRate $clockSlack $inputChannelNum $inputRate $coeffNum $interpFactor $decimFactor $symmetry $symmetryMode $L_bandsFilter $inputBitWidth $inputFracBitWidth $coeffBitWidth_derived $coeffFracBitWidth $baseAddress $coefficientReadback $coefficientWriteable -- $busDataWidth $busAddressWidth $delayRAMBlockThreshold $dualMemDistRAMThreshold $mRAMThreshold $hardMultiplierThreshold $generateCode $backPressure $bankCount $modeFormatted << $coeffSet ] } err ] } {
        # puts "------------------------"
        # puts "$fir_ip_api_interface $inputParams(entity_name) $temp_dir $inputParams(family) $inputParams(speedGrade) $inputParams(clockRate) $inputParams(clockSlack) $inputParams(nChans) $inputParams(inRate) $inputParams(nTaps) $inputParams(interpN) $inputParams(decimN) $inputParams(symmetry) $inputParams(symmetry_type) $inputParams(nband) $config(InWidth) $inputParams(inFracWidth) $config(coefWidth) $config(coeffFracBitWidth) $inputParams(baseAddr) $config(coefficientReadback) $config(coefficientWriteable) -- $config(busDataWidth) $inputParams(busAddressWidth) $inputParams(delayRAMBlockThreshold) $inputParams(dualMemDistRAMThreshold) $inputParams(mRAMThreshold) $inputParams(hardMultiplierThreshold) $generateCode $config(useClkEnable) $config(bankcount) $inputParams(modeMapping) << $inputParams(coeffSet)"
        # puts "------------------------"
        send_message WARNING "Generation Error: $err"
        send_message warning "failed to generate the fir ip api"
        # send_message WARNING "out params $outputParams(funcResult)"

        return
    }

    send_message debug "OUTPARAMS $funcResult"      
    set funcResultList [split $funcResult "|"]
    set funcResultListLength [llength $funcResultList]
    if { $generateCode == false } {
        set_parameter_value funcResult $funcResult
        # Get number input/output data wire, number of latency
        set_parameter_value inputInterfaceNum [lindex $funcResultList 2]
        set_parameter_value outputInterfaceNum [lindex $funcResultList 3]
        set_parameter_value chanPerInputInterface [lindex $funcResultList 4]
        set_parameter_value chanPerOutputInterface [lindex $funcResultList 5]
        set_parameter_value outWidth_realOnly [lindex $funcResultList 6]
        set_parameter_value outFullFracBitWidth_realOnly [lindex $funcResultList 7]
        set_parameter_value latency_realOnly  [lindex $funcResultList 8]
        set_parameter_value outputfifodepth_realOnly [lindex $funcResultList 9]
        if {[get_parameter_value coeffComplex] } {
            if { $suffix eq "rr" } {
                set_parameter_value outWidth [expr [lindex $funcResultList 6] + 1]
                set_parameter_value outFullFracBitWidth [lindex $funcResultList 7]
                set_parameter_value latency  [expr [lindex $funcResultList 8] + 3]
                set_parameter_value outputfifodepth [lindex $funcResultList 9]
                set_parameter_value outBitWidth [expr [get_parameter_value outWidth] - [get_parameter_value outMsbBitRem] - [get_parameter_value outLsbBitRem]]  
            }
        } else {
            set_parameter_value outWidth [lindex $funcResultList 6]
            set_parameter_value outFullFracBitWidth [lindex $funcResultList 7]
            set_parameter_value latency  [lindex $funcResultList 8]
            set minFIFODepth [lindex $funcResultList 9]
            set_parameter_value outputfifodepth [expr int(2**(ceil(log($minFIFODepth+1)/log(2))))]
            set_parameter_value outBitWidth [expr [get_parameter_value outWidth] - [get_parameter_value outMsbBitRem] - [get_parameter_value outLsbBitRem]]  
        }

        set generate_pass [lindex $funcResultList 10]

        if { [lindex $funcResultList 10] == true } {
            set_parameter_value errorList 0
        } elseif { [lindex $funcResultList 10] == false } {
            send_message_from_strings error ERROR_FIR_IP_API_CREATING_VHDL
            set_parameter_value errorList 1
        } elseif { [lindex $funcResultList 10] == "noCode" } {
            set_parameter_value errorList 0
        } else {
            send_message_from_strings error ERROR_FIR_IP_API_UNKNOWN
            set_parameter_value errorList 1
        }

        set resourceUsage [lindex $funcResultList 11]


        send_message info "PhysChanIn [get_parameter_value inputInterfaceNum], PhysChanOut [get_parameter_value outputInterfaceNum], ChansPerPhyIn [get_parameter_value chanPerInputInterface], ChansPerPhyOut [get_parameter_value chanPerOutputInterface], OutputFullBitWidth [get_parameter_value outWidth], Bankcount [get_parameter_value bankCount], CoefBitWidth [get_parameter_value coeffBitWidth_derived]"

        set resourceCounts [regexp -all -inline {LUTS: (\d+) DSPs: (\d+) RAM Bits: (\d+)} $resourceUsage]

        if {[llength $resourceCounts] < 4} {
            set resourceCounts {"" -1 -1 -1}
        }
        set_parameter_value lutCount [lindex $resourceCounts 1]
        set_parameter_value dspCount [lindex $resourceCounts 2]
        set_parameter_value memBitCount [lindex $resourceCounts 3]
                

        if { $generate_pass == false } {
            send_message_from_strings error ERROR_FILTER_CREATION_FAILURE
            return
        }

    }   else {
        # Get DSPBA file list and add them to the file set
        for {set m 13} {$m < $funcResultListLength-1} {incr m} {
            set dspba_files [lindex $funcResultList $m]
            #Ignore if it is a file path starts with $ instead of a file name for now
            if {![regexp {^\$} $dspba_files match]} {
                lappend list_of_files "${temp_dir}/$dspba_files"
            }
        }
        set list_of_files [lsort -unique $list_of_files]
        #Add DSPBA FIR rtl file
        lappend list_of_files "${temp_dir}/[lindex $funcResultList 12]"
        add_core_file_list $list_of_files
    }
}

proc remap_parameter {name old_params_map_name map_pairs} {
    array set map $map_pairs
    upvar $old_params_map_name old_params
    set old_value $old_params($name) 
    set_parameter_value $name $map($old_value)
}

proc upgrade {ip_core_type version old_param_value_pairs} {
    # TODO: This needs to be extended to allow upgrading from any version earlier than 14.1
    # send_message info "version is $version"
    if { $version == "14.0" } {
        array set old_params $old_param_value_pairs
        # resoureEstimation is removed in 14.1, yes it's resoure without the c!
        unset -nocomplain -- old_params(resoureEstimation) 

        set maps {
                  L_bandsFilter {"All taps" 1 "Half band" 2 "3 rd" 3 "4 th" 4 "5 th" 5}
                  filterType    {"Single Rate" single "Decimation" decim "Interpolation" interp "Fractional Rate" frac}
                  readWriteMode {"Read" read "Write" write "Read/Write" read_write}
                  symmetryMode  {"Non Symmetry" nsym "Symmetrical" sym "Anti-Symmetrical" asym}
                  inputType     {"Signed Binary" int "Signed Fractional Binary" frac}
                  coeffType     {"Signed Binary" int "Signed Fractional Binary" frac}
                  outType       {"Signed Binary" int "Signed Fractional Binary" frac}
                  speedGrade    {Fast fast Medium medium Slow slow}
                  outLSBRound   {Truncation trunc Rounding round}
                  outMSBRound   {Truncation trunc Saturating sat}
                  coeffScaling  {Auto auto None none}
                 }

        foreach {param map} $maps {
            remap_parameter $param old_params $map
            array unset old_params $param
        }

        # add all the remaining unmapped parameters
        foreach name [array names old_params] {
            set_parameter_value $name $old_params($name)
        }
    } else {
        foreach {name value} $old_param_value_pairs {
            set_parameter_value $name $value
        }
    }
}
#Get the width of a port based on the number of elements we want to be able to address with it
proc dsp_get_width { elements } {
    if { $elements < 2 } {
        return 0
    } else {
        return [expr {int(ceil(log($elements)/log(2)))}]
    }
} 

# +-----------------------------------------------------------------------------
# | Source tcl files with parameters
# +-----------------------------------------------------------------------------
proc src { filename args } {
    global argv
    set argv $args
    set TCLdir [get_module_property MODULE_DIRECTORY]
    source "$TCLdir/$filename"
}

