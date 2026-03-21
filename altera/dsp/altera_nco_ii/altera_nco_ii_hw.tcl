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

source ../lib/tcl/avalon_streaming_util.tcl
source ../lib/tcl/dspip_common.tcl
load_strings altera_nco_ii.properties

# change this to make the NCO generate more consistent AV-ST port names
global use_old_style_ports
set use_old_style_ports true

set_module_property NAME altera_nco_ii
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property EDITABLE false
set_module_property HELPER_JAR nco_helper.jar

set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V} {STRATIX 10}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
    {CYCLONE IV GX} {CYCLONE IV E} {CYCLONE V} {CYCLONE 10 LP}
    {MAX 10 FPGA}
}

set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate

add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_sim_verilog
add_fileset sim_vhdl SIM_VHDL generate_sim_vhdl

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/hco1421694900164/hco1421694881684
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697884642

# set up module properties that are stored in the strings file
set_module_properties_from_strings AUTHOR GROUP DISPLAY_NAME DESCRIPTION DATASHEET_URL

set_variables_from_strings main_tab freq_tab optional_tab hyper_opt_tab

add_display_item "" $main_tab group tab
add_display_item "" $freq_tab group tab
add_display_item "" $optional_tab group tab
add_display_item "" $hyper_opt_tab group tab

# possibly redundant now that tab bug is fixed 
add_display_item "" dummy group

add_display_item "" widget_group group tab
add_display_item widget_group freq_domain parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera dsp lib helpers com.altera.dsp.jar]
set widget_name "freq_domain"
set_display_item_property widget_group WIDGET [list $jar_path $widget_name]

set_display_item_property widget_group WIDGET_PARAMETER_MAP {
    arch              arch
    fsamp             fsamp
    mpr               mpr
    apr               apr
    apri              apri
    want_dither       want_dither
    dpri              dpri
    cycles_per_output cycles_per_output
    phi_inc           phi_inc
    hyper_opt_select         hyper_opt_select
}

set_variables_from_strings params_group prec_group throughput_group dither_group freq_group \
                           freq_mod_group phase_mod_group hyper_opt_group

foreach group [list $params_group $throughput_group] {
    add_display_item $main_tab $group group
}

foreach group [list $prec_group $dither_group $freq_group] {
    add_display_item $freq_tab $group group
}

foreach group [list $freq_mod_group $phase_mod_group] {
    add_display_item $optional_tab $group group
}

foreach group [list $hyper_opt_group] {
    add_display_item $hyper_opt_tab $group group
}

# Architecture selection
add_parameter arch STRING large_rom
set_parameter_display_from_strings arch
set_allowed_ranges arch {small_rom large_rom cordic trig}
set_parameter_property arch GROUP $params_group

add_parameter want_sin_and_cos STRING dual_output
set_parameter_display_from_strings want_sin_and_cos
set_allowed_ranges want_sin_and_cos {single_output dual_output}
set_parameter_property want_sin_and_cos DISPLAY_HINT RADIO
set_parameter_property want_sin_and_cos GROUP $params_group

add_parameter numch POSITIVE 1
set_parameter_display_from_strings numch
set_parameter_property numch ALLOWED_RANGES 1:8
set_parameter_property numch GROUP $params_group

add_parameter numba POSITIVE 1
set_parameter_display_from_strings numba
set_parameter_property numba ALLOWED_RANGES 1:16
set_parameter_property numba GROUP $params_group

add_parameter use_dedicated_multipliers BOOLEAN TRUE
set_parameter_display_from_strings use_dedicated_multipliers
set_parameter_property use_dedicated_multipliers GROUP $params_group

add_parameter selected_device_family STRING
set_parameter_display_from_strings selected_device_family
set_parameter_property selected_device_family VISIBLE true
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property selected_device_family GROUP $params_group

# Precisions
add_parameter apr POSITIVE 32
set_parameter_display_from_strings apr
set_parameter_property apr ALLOWED_RANGES 4:64
set_parameter_property apr GROUP $prec_group
set_parameter_property apr UNITS bits

add_parameter apri POSITIVE 16
set_parameter_display_from_strings apri
set_parameter_property apri ALLOWED_RANGES 4:32
set_parameter_property apri GROUP $prec_group
set_parameter_property apri UNITS bits

add_parameter mpr POSITIVE 18
set_parameter_display_from_strings mpr
set_parameter_property mpr ALLOWED_RANGES 10:32
set_parameter_property mpr GROUP $prec_group
set_parameter_property mpr UNITS bits

# Throughput
add_parameter cordic_arch STRING parallel
set_parameter_display_from_strings cordic_arch
set_allowed_ranges cordic_arch {parallel serial}
set_parameter_property cordic_arch GROUP $throughput_group

add_parameter trig_cycles_per_output INTEGER "1"
set_parameter_property trig_cycles_per_output DISPLAY_NAME [get_string CYCLES_PER_OUTPUT_DISPLAY]
set_parameter_property trig_cycles_per_output LONG_DESCRIPTION [get_string TRIG_CYCLES_PER_OUTPUT_LONG_DESCRIPTION]
set_parameter_property trig_cycles_per_output ALLOWED_RANGES {1 2}
set_parameter_property trig_cycles_per_output GROUP $throughput_group

add_parameter cycles_per_output INTEGER "1"
set_parameter_property cycles_per_output DERIVED true
set_parameter_display_from_strings cycles_per_output
set_parameter_property cycles_per_output GROUP $throughput_group

# Dithering
add_parameter want_dither BOOLEAN TRUE
set_parameter_display_from_strings want_dither
set_parameter_property want_dither GROUP $dither_group

add_parameter dpri NATURAL 4
set_parameter_display_from_strings dpri
set_parameter_property dpri DISPLAY_HINT SLIDER
set_parameter_property dpri ALLOWED_RANGES 2:10
set_parameter_property dpri GROUP $dither_group

# Generated output frequencies
add_parameter fsamp FLOAT 100.0
set_parameter_display_from_strings fsamp
set_parameter_property fsamp UNITS "Megahertz"
set_parameter_property fsamp GROUP $freq_group

add_parameter freq_out FLOAT 1.0
set_parameter_display_from_strings freq_out
set_parameter_property freq_out UNITS "Megahertz"
set_parameter_property freq_out GROUP $freq_group

add_parameter phi_inc LONG
set_parameter_display_from_strings phi_inc
set_parameter_property phi_inc DERIVED true
set_parameter_property phi_inc GROUP $freq_group

add_parameter real_freq_out FLOAT
set_parameter_display_from_strings real_freq_out
set_parameter_property real_freq_out DERIVED true
set_parameter_property real_freq_out UNITS "Megahertz"
set_parameter_property real_freq_out GROUP $freq_group

# Frequency modulation
add_parameter want_freq_mod BOOLEAN false
set_parameter_display_from_strings want_freq_mod
set_parameter_property want_freq_mod GROUP $freq_mod_group

add_parameter aprf POSITIVE 32
set_parameter_display_from_strings aprf
set_parameter_property aprf ALLOWED_RANGES 4:64
set_parameter_property aprf GROUP $freq_mod_group
set_parameter_property aprf UNITS bits

add_parameter fmod_pipe POSITIVE 1
set_parameter_display_from_strings fmod_pipe
set_parameter_property fmod_pipe ALLOWED_RANGES {1 2}
set_parameter_property fmod_pipe GROUP $freq_mod_group

# Phase modulation
add_parameter want_phase_mod BOOLEAN false
set_parameter_display_from_strings want_phase_mod
set_parameter_property want_phase_mod GROUP $phase_mod_group

add_parameter aprp POSITIVE 16
set_parameter_display_from_strings aprp
set_parameter_property aprp ALLOWED_RANGES 4:32
set_parameter_property aprp GROUP $phase_mod_group
set_parameter_property aprp UNITS bits

add_parameter pmod_pipe POSITIVE 1
set_parameter_display_from_strings pmod_pipe
set_parameter_property pmod_pipe ALLOWED_RANGES {1 2}
set_parameter_property pmod_pipe GROUP $phase_mod_group

# S10 optimization: hyper retiming etc.
add_parameter hyper_opt BOOLEAN FALSE
set_parameter_property hyper_opt VISIBLE false
set_parameter_property hyper_opt DERIVED true
set_parameter_property hyper_opt GROUP $hyper_opt_group

add_parameter hyper_opt_select BOOLEAN FALSE
set_parameter_display_from_strings hyper_opt_select
set_parameter_property hyper_opt_select GROUP $hyper_opt_group


proc enable_params {params status} {
    foreach p $params {
        set_parameter_property $p ENABLED $status
    }
}

proc arch_is_trig {arch} {
    return [expr {$arch == "trig"}]
}

proc arch_is_large_rom {arch} {
    return [expr {$arch == "large_rom"}]
}

proc arch_is_small_rom {arch} {
    return [expr {$arch == "small_rom"}]
}

proc arch_is_cordic {arch} {
    return [expr {$arch == "cordic"}]
}

proc cordic_is_serial {cordic_type} {
    return [expr {$cordic_type == "serial"}]
}

proc output_is_single {want_sin_and_cos} {
    return [expr {$want_sin_and_cos == "single_output"}]
}

proc validate {} {
    # get non-dependent parameters
    set arch [get_parameter_value arch]
    set apr [get_parameter_value apr]
    set mpr [get_parameter_value mpr]
    set apri [get_parameter_value apri]

    set numch [get_parameter_value numch]
    set numba [get_parameter_value numba]

    set want_freq_mod [get_parameter_value want_freq_mod]
    set want_phase_mod [get_parameter_value want_phase_mod]
    set want_dither [get_parameter_value want_dither]

    set fsamp [get_parameter_value fsamp]
    set freq_out [get_parameter_value freq_out]

    set cordic_type [get_parameter_value cordic_arch]
    set mult_tput [get_parameter_value trig_cycles_per_output]


    # enable/disable parameters based on relevent checkboxes
    enable_params {aprf fmod_pipe} $want_freq_mod
    enable_params {aprp pmod_pipe} $want_phase_mod
    enable_params {dpri} $want_dither

    set mult_based [arch_is_trig $arch]
    enable_params {use_dedicated_multipliers} $mult_based
    if {$mult_based} {
        set_parameter_property cycles_per_output VISIBLE false
        set_parameter_property trig_cycles_per_output VISIBLE true
    } else {
        set_parameter_property cycles_per_output VISIBLE true
        set_parameter_property trig_cycles_per_output VISIBLE false
    }

    set_parameter_property cordic_arch VISIBLE [arch_is_cordic $arch]


    # perform parameter validation
    if {$apr < $apri} {
        send_message_from_strings error ERROR_APR_LESS_THAN_APRI 
    }

    if {$apri > 24 && ([arch_is_large_rom $arch] || [arch_is_small_rom $arch])} {
        send_message_from_strings error ERROR_APRI_TOO_LARGE_FOR_ARCH
    }

    if {$want_freq_mod} {
        set aprf [get_parameter_value aprf]
        if {$aprf > $apr} {
            send_message_from_strings error ERROR_APRF_GREATER_THAN_APR
        }
    }

    if {$want_phase_mod} {
        set aprp [get_parameter_value aprp]
        if {$aprp > $apr} {
            send_message_from_strings error ERROR_APRP_GREATER_THAN_APR
        } elseif {$aprp < $apri} {
            send_message_from_strings error ERROR_APRP_LESS_THAN_APRI
        }
    }

    if {$numch > 1} {
        if {$numba > 1} {
            send_message_from_strings error ERROR_NUMCH_AND_NUMBA_BOTH_USED
        }

        if {[arch_is_cordic $arch] && [cordic_is_serial $cordic_type]} {
            send_message_from_strings error ERROR_SERIAL_CORDIC_AND_MULTI_CHAN
        } elseif {[arch_is_trig $arch] && $mult_tput != 1} {
            send_message_from_strings error ERROR_TIMESHARED_TRIG_AND_MULTI_CHAN
        }
    }

    if {$fsamp <= 0} {
        send_message_from_strings error ERROR_CLOCK_RATE_ZERO_OR_LESS
    } elseif {$freq_out <= 0} {
        send_message_from_strings error ERROR_OUT_RATE_ZERO_OR_LESS
    } else {
        set tput 1
        if {[arch_is_cordic $arch] && [cordic_is_serial $cordic_type]} {
            # Serial CORDIC takes 1 cycle per output bit
            set tput $mpr
        } elseif {[arch_is_trig $arch]} {
            set tput $mult_tput
        }
        set_parameter_value cycles_per_output $tput
        set max_freq [expr {$fsamp / (2.0 * $tput)}]
        set phi_inc [expr {round($tput * $freq_out * pow(2.0, $apr) / $fsamp)}]
        set min_freq [expr {$fsamp / (pow(2.0, $apr) * $tput)}]
        set actual_freq [expr {$phi_inc * $min_freq}]

        set_parameter_value phi_inc $phi_inc
        set_parameter_value real_freq_out [format "%.4g" $actual_freq]

        if {$freq_out > $max_freq} {
            set max_freq [format "%.4g" $max_freq]
            send_message_from_strings error ERROR_FREQ_OUT_TOO_HIGH
        } elseif {$phi_inc < 1} {
            send_message_from_strings error ERROR_INCREMENT_TOO_SMALL
        }
    }
}

proc log2ceil {x} {
    return [expr {int(ceil(log($x) / log(2)))}]
}

proc elaborate {} {
    global use_old_style_ports

    if {$use_old_style_ports} {
        array set ports {
            inValid "clken"
			inIncrement "phi_inc_i"
			inBandSel "freq_sel_sig"
			inFreqMod "freq_mod_i"
			inPhaseMod "phase_mod_i"

			inFreqHopAddr "address"
			inFreqHopWrite "write_sig"
			inFreqHopData "phi_inc_i"

			outSin "fsin_o"
			outCos "fcos_o"
			outValid "out_valid"
        }
    } else {
        array set ports {
            inValid "in_valid"
			inIncrement "in_increment"
			inBandSel "in_band_sel"
			inFreqMod "in_freq_mod"
			inPhaseMod "in_phase_mod"

			inFreqHopAddr "freq_hop_address"
			inFreqHopWrite "freq_hop_write"
			inFreqHopData "freq_hop_data"

			outSin "out_sin"
			outCos "out_cos"
			outValid "out_valid"
        }
    }



    set hyper_opt_select                     [ get_parameter_value hyper_opt_select ]
    set family                               [ get_parameter_value selected_device_family ]

    if {$family == "Stratix 10" || $family == "Arria 10"} {
       set_display_item_property [get_string hyper_opt_tab] VISIBLE true
       set_parameter_value hyper_opt ${hyper_opt_select}
    } else {
       set_display_item_property [get_string hyper_opt_tab] VISIBLE false
       set_parameter_value hyper_opt false
    }



    add_interface clk clock end
    add_interface_port clk clk clk Input 1

    add_interface rst reset end
    set_interface_property rst associatedClock clk
    add_interface_port rst reset_n reset_n Input 1

    set apr [get_parameter_value apr]
    set mpr [get_parameter_value mpr]
    set want_sin_and_cos [get_parameter_value want_sin_and_cos]

    dsp_add_streaming_interface in sink
    dsp_set_interface_property in associatedClock clk
    dsp_add_interface_port in $ports(inValid) valid Input 1

    set numba [get_parameter_value numba]
    if {$numba > 1} {
        set log2numba [log2ceil $numba]
        add_interface freq_hop avalon slave
        add_interface_port freq_hop $ports(inFreqHopWrite) write     input 1
        add_interface_port freq_hop $ports(inFreqHopAddr)  address   input $log2numba
        add_interface_port freq_hop $ports(inFreqHopData)  writedata input $apr
        set_interface_property freq_hop associatedClock clk
        set_interface_property freq_hop bitsPerSymbol $apr

        # in multi-band (frequency hopping) mode, main data input is the band select signal
        set in_width $log2numba
        set in_frag [list $ports(inBandSel) $log2numba]
    } else {
        # main data input is the input increment
        set in_width $apr
        set in_frag [list $ports(inIncrement) $apr]
    }

    if {[get_parameter_value want_freq_mod]} {
        # add in_freq_mod port
        set aprf [get_parameter_value aprf]
        set in_width [expr {$in_width + $aprf}]
        lappend in_frag $ports(inFreqMod) $aprf
    }
    if {[get_parameter_value want_phase_mod]} {
        # add in_phase_mod port
        set aprp [get_parameter_value aprp]
        set in_width [expr {$in_width + $aprp}]
        lappend in_frag $ports(inPhaseMod) $aprp
    }
    dsp_set_interface_property in dataBitsPerSymbol $in_width
    dsp_add_interface_port in in_data data Input $in_width $in_frag

    set out_frag [list $ports(outSin) $mpr]
    set out_width $mpr

    if {! [output_is_single $want_sin_and_cos]} {
        set out_width [expr {$mpr * 2}]
        lappend out_frag $ports(outCos) $mpr
    }
    dsp_add_streaming_interface out source
    dsp_set_interface_property out associatedClock clk
    dsp_set_interface_property out dataBitsPerSymbol $mpr
    dsp_add_interface_port out out_data data Output $out_width $out_frag
    dsp_add_interface_port out out_valid valid Output 1
}

proc generate_synth {entity} {
    generate_all QUARTUS_SYNTH $entity
}

proc generate_sim_verilog {entity} {
    generate_all SIM_VERILOG $entity
}

proc generate_sim_vhdl {entity} {
    generate_all SIM_VHDL $entity
}

proc get_file_type {file_name} {
    switch -glob $file_name {
        *.v { set file_type VERILOG }
        *.vhd { set file_type VHDL }
        *.hex { set file_type HEX }
        default { send_message error "Unknown file extension for $file_name" }
    }
    return $file_type
}

proc create_array_for_generator {a entity create_tb} {
    upvar $a params

    set params(NAME) $entity
    set params(TB_NAME) ""
    if {$create_tb} {
        set params(TB_NAME) "${entity}_tb"
    }
    set params(FAMILY) [get_parameter_value selected_device_family]

    foreach param {arch numch numba apr apri mpr \
                   want_dither dpri fsamp freq_out phi_inc real_freq_out \
                   want_freq_mod aprf fmod_pipe want_phase_mod aprp pmod_pipe \
                   use_dedicated_multipliers trig_cycles_per_output \
                   phi_inc fsamp freq_out hyper_opt} {
        set params([string toupper $param]) [get_parameter_value $param]
    }

    set params(WANT_SIN_AND_COS) [expr {[get_parameter_value want_sin_and_cos] == "dual_output"}]
    set params(CORDIC_IS_PARALLEL) [expr {[get_parameter_value cordic_arch] == "parallel"}]

    global use_old_style_ports
    set params(USE_OLD_STYLE_PORTS) $use_old_style_ports
}

proc generate_all {fileset entity} {
    set for_synth [expr {$fileset == "QUARTUS_SYNTH"}]
    create_array_for_generator params $entity [expr {! $for_synth}]

    array set output [call_helper generate [array get params]]
    if {! [info exists output(status)]} {
        send_message error "generate call_helper returned unexpected output"
    }


    if {$output(status) != "success"} {
        send_message error $output(message)
    } else {
        set library_files [split $output(library_files)]
        set contents [split $output(contents)]

        #send_message INFO "--------------------------------"
        #send_message INFO $contents
        #send_message INFO "--------------------------------"
        #send_message INFO $library_files
        #send_message INFO "--------------------------------"

        # add library files
        foreach lf $library_files {
            dsp_add_fileset_file "./lib/$lf" $fileset [get_simulator_list]
        }
        
        # add generated files
        foreach id $contents {
            set file_name $output(${id}_name)
            set file_contents $output(${id}_contents)
            set file_type [get_file_type $file_name]

            if {$id == "testbench"} {
                # set filetype to other so simulator doesn't compile it normally
                add_fileset_file $file_name OTHER TEXT $file_contents
            } else {
                add_fileset_file $file_name $file_type TEXT $file_contents
            }
        }

        if {$for_synth} {
            set ocp_files {
                asj_altq.ocp asj_altqmcash.ocp asj_altqmcpipe.ocp
            }
            foreach of $ocp_files {
                add_fileset_file $of OTHER PATH lib/$of
            }
        } else {
            # generate the c model files for simulation fileset
            foreach c_file [get_c_model_files] {
                add_fileset_file $c_file OTHER PATH $c_file
            }
        }
    }
}




proc copy_file {for_synth dir file_name orig_location} {
    set file_type [get_file_type $file_name]
    if {$for_synth} {
        add_fileset_file $file_name $file_type PATH $orig_location
    } else {
        file copy $orig_location "$dir$file_name"
    }
}

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}


proc find_c_model_dir { cur_dir } {
   #send_message WARNING "searching $cur_dir"
   set found_dir "nothing"
   foreach sub_dir [glob -nocomplain -type d -directory $cur_dir *] {
      #send_message WARNING "found $sub_dir"
      if {[string match *c_model*  $sub_dir ] == 1} {
         set found_dir $sub_dir
         #send_message WARNING "!! found c_model"
         return $found_dir
      } else {
         set found_dir [find_c_model_dir $sub_dir]
      }
      if {[string match *c_model*  $found_dir ] == 1} {
         return $found_dir
      }
   }
   return $found_dir
}

proc get_c_model_files {} {
   set c_model_files {
        c_model/model_wrapper.cpp
	c_model/nco_model.cpp
	c_model/nco_model.h
   }
   return $c_model_files
}
