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


# --------------------------------------------------------------------------------------------------
#--                                                                                               --
#-- _hw.tcl compose file for the Component Library Switch (Switch II)                             --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IP
declare_general_module_info

# -- General Info --
set_module_property NAME alt_vip_cl_swi
set_module_property DISPLAY_NAME "Switch II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Video Switch"
set_module_property HIDE_FROM_QUARTUS true

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set_module_property VALIDATION_CALLBACK validation_cb

set_module_property PARAMETER_UPGRADE_CALLBACK upgrade_cb

set_module_property ELABORATION_CALLBACK elaboration_cb


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files                                                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

add_static_sv_file src_hdl/alt_vip_cl_switch.sv
add_static_sv_file src_hdl/alt_vip_cl_switch_control.sv
add_static_sv_file src_hdl/alt_vip_cl_switch_input.sv
add_static_sv_file src_hdl/alt_vip_cl_switch_output.sv
add_static_sv_file src_hdl/alt_vip_cl_switch_synchronise.sv
add_static_sv_file src_hdl/alt_vip_cl_switch_wrap.sv

add_static_misc_file src_hdl/alt_vip_cl_switch.ocp
add_static_misc_file src_hdl/alt_vip_cl_switch_control.ocp
add_static_misc_file src_hdl/alt_vip_cl_switch_synchronise.ocp
add_static_misc_file src_hdl/alt_vip_cl_switch_input.ocp
add_static_misc_file src_hdl/alt_vip_cl_switch_output.ocp
add_static_misc_file src_hdl/alt_vip_cl_switch_wrap.ocp

setup_filesets alt_vip_cl_switch_wrap

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_bits_per_symbol_parameters

# adds NUMBER_OF_COLOR_PLANES, COLOR_PLANES_ARE_IN_PARALLEL
add_channels_nb_parameters

# adds PIXELS_IN_PARALLEL
add_pixels_in_parallel_parameters

add_parameter NO_OF_INPUTS INTEGER 2
set_parameter_property NO_OF_INPUTS DISPLAY_NAME "Number of inputs"
set_parameter_property NO_OF_INPUTS ALLOWED_RANGES 1:12
set_parameter_property NO_OF_INPUTS DESCRIPTION "The number of Avalon ST Video inputs to the switch"
set_parameter_property NO_OF_INPUTS AFFECTS_ELABORATION true
set_parameter_property NO_OF_INPUTS HDL_PARAMETER true

add_parameter NO_OF_OUTPUTS INTEGER 2
set_parameter_property NO_OF_OUTPUTS DISPLAY_NAME "Number of outputs"
set_parameter_property NO_OF_OUTPUTS ALLOWED_RANGES 1:12
set_parameter_property NO_OF_OUTPUTS DESCRIPTION "The number of Avalon ST Video outputs from the switch"
set_parameter_property NO_OF_OUTPUTS AFFECTS_ELABORATION true
set_parameter_property NO_OF_OUTPUTS HDL_PARAMETER true

add_parameter READY_LATENCY INTEGER 1
set_parameter_property READY_LATENCY VISIBLE false
set_parameter_property READY_LATENCY DISPLAY_NAME "Ready Latency"
set_parameter_property READY_LATENCY ALLOWED_RANGES {0,1}
set_parameter_property READY_LATENCY DESCRIPTION "The latency of the switch's Avalon ST Video Ready signal"
set_parameter_property READY_LATENCY AFFECTS_ELABORATION true
set_parameter_property READY_LATENCY HDL_PARAMETER true

# -- Static Ports --
# The clock
add_interface main_clock clock end
add_interface_port main_clock clock clk Input 1
add_interface_port main_clock reset reset Input 1

# Declare the Avalon slave interface
add_interface control avalon slave main_clock
set_interface_property control writeWaitTime 0
set_interface_property control addressAlignment DYNAMIC
set_interface_property control readWaitTime 1
set_interface_property control readLatency 0
# Declare all the signals that belong to the Slave interface
add_interface_port control control_read read input 1
add_interface_port control control_write write input 1
add_interface_port control control_address address input 5
add_interface_port control control_writedata writedata input 32
add_interface_port control control_readdata readdata output 32

add_interface interrupt interrupt end main_clock
add_interface_port interrupt control_interrupt irq output 1
set_interface_property interrupt associatedAddressablePoint control


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Upgrade callback                                                                             --
# -- ACDS version upgrade/downgrade                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc upgrade_cb {ip_core_type version parameters} {

    foreach { name value } $parameters {

        switch $name {

            BPS {
                # BPS maps to BITS_PER_SYMBOL
                set_parameter_value BITS_PER_SYMBOL $value
            }
            ALPHA_ENABLED {
                # Do nothing, ALPHA_ENABLED removed
            }
            AUTO_DEVICE_FAMILY {
                # Do nothing, AUTO_DEVICE_FAMILY removed
            }
            AUTO_MAIN_CLOCK_CLOCK_RATE {
                # Do nothing, AUTO_MAIN_CLOCK_CLOCK_RATE removed
            }
            NUM_CHANNELS {
                # Do nothing, NUM_CHANNELS removed
            }

            default                {
                set_parameter_value $name $value
            }
        }
    }

    #-- Data port names have changed: dinN -> din_N and doutN -> dout_N
    set num_inputs  [get_parameter_value NO_OF_INPUTS ]
    set num_outputs [get_parameter_value NO_OF_OUTPUTS]

    set complete_port_list {}

    #-- Map the input ports
    for { set i 0 } { $i < $num_inputs } { incr i } {

        set new_port_list [list din${i} din_${i}]

        set complete_port_list [concat $complete_port_list $new_port_list]
    }

    #-- Map the output ports
    for { set o 0 } { $o < $num_outputs } { incr o } {

        set new_port_list [list dout${o} dout_${o}]

        set complete_port_list [concat $complete_port_list $new_port_list]
    }

    set_interface_upgrade_map $complete_port_list
}

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Handling cross-dependencies between parameters (error/warning messages and dynamic GUI       --
# -- behaviour                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc validation_cb {} {
    # Parameters validation
    pip_validation_callback_helper
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Dynamic ports (elaboration callback)                                                         --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc elaboration_cb {} {

    # Avalon streaming source(s)
    set ready_latency                  [get_parameter_value READY_LATENCY]
    set bits_per_sym                   [get_parameter_value BITS_PER_SYMBOL]
    set number_of_color_planes         [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set color_planes_are_in_parallel   [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_pixels_in_parallel   [get_parameter_value PIXELS_IN_PARALLEL]
    set number_of_symbols              [expr {$color_planes_are_in_parallel ? $number_of_color_planes * $number_of_pixels_in_parallel : 1}]
    set data_width                     [expr {$color_planes_are_in_parallel ? [expr $bits_per_sym * $number_of_color_planes * $number_of_pixels_in_parallel] : $bits_per_sym}]

    set empty_port_width [clogb2_pure $number_of_symbols]

    # Optional input output interfaces
    for {set input 0} {$input < [get_parameter_value NO_OF_INPUTS]} {incr input} {
        add_av_st_video_input_port din_${input}   $bits_per_sym   $number_of_color_planes  $color_planes_are_in_parallel   $number_of_pixels_in_parallel

        # Set up port fragments
        set_port_property din_${input}_ready FRAGMENT_LIST "din_ready@${input}"
        set_port_property din_${input}_valid FRAGMENT_LIST "din_valid@${input}"
        set bottom [expr ${input} * ${data_width}]
        set top [expr ${bottom} + ${data_width} - 1]
        set_port_property din_${input}_data FRAGMENT_LIST "din_data@${top}:${bottom}"
        set_port_property din_${input}_startofpacket FRAGMENT_LIST "din_startofpacket@${input}"
        set_port_property din_${input}_endofpacket FRAGMENT_LIST "din_endofpacket@${input}"

        if { $number_of_pixels_in_parallel > 1 } {
            set bottom [expr ${input} * ${empty_port_width}]
            set top    [expr ${bottom} + ${empty_port_width} - 1]
            set_port_property din_${input}_empty FRAGMENT_LIST "din_empty@${top}:${bottom}"
        }

    }

    for {set output 0} {$output < [get_parameter_value NO_OF_OUTPUTS]} {incr output} {
        add_av_st_video_output_port dout_${output}   $bits_per_sym   $number_of_color_planes  $color_planes_are_in_parallel   $number_of_pixels_in_parallel

        # Set up port fragments
        set_port_property dout_${output}_ready FRAGMENT_LIST "dout_ready@${output}"
        set_port_property dout_${output}_valid FRAGMENT_LIST "dout_valid@${output}"
        set bottom [expr ${output} * ${data_width}]
        set top [expr ${bottom} + ${data_width} - 1]
        set_port_property dout_${output}_data FRAGMENT_LIST "dout_data@${top}:${bottom}"
        set_port_property dout_${output}_startofpacket FRAGMENT_LIST "dout_startofpacket@${output}"
        set_port_property dout_${output}_endofpacket FRAGMENT_LIST "dout_endofpacket@${output}"

        if { $number_of_pixels_in_parallel > 1 } {
            set bottom [expr ${output} * ${empty_port_width}]
            set top    [expr ${bottom} + ${empty_port_width} - 1]
            set_port_property dout_${output}_empty FRAGMENT_LIST "dout_empty@${top}:${bottom}"
        }
    }
}

