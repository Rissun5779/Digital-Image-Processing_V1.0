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
#-- _hw.tcl compose file for Clocked Video Output II                                              --
#--                                                                                               --
#---------------------------------------------------------------------------------------------------
source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP top-level IPs
declare_general_module_info

# Module properties
set_module_property NAME alt_vip_cl_cvo
set_module_property DISPLAY_NAME "Clocked Video Output II (4K Ready) Intel FPGA IP"
set_module_property DESCRIPTION "The Clocked Video Output converts Avalon-ST Video to standard video formats such as BT656 or VGA."


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Validation callback to check legality of parameter set
set_module_property VALIDATION_CALLBACK cvo_validation_callback

# Composition callback to put the components together
set_module_property COMPOSITION_CALLBACK cvo_composition_callback


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
add_parameter BPS integer 8
set_parameter_property BPS DISPLAY_NAME "Bits per pixel per color plane"
set_parameter_property BPS ALLOWED_RANGES 4:20
set_parameter_property BPS HDL_PARAMETER true
set_parameter_property BPS DISPLAY_UNITS "bits"
set_parameter_property BPS DESCRIPTION "The number of bits used per pixel, per color plane."

add_parameter NUMBER_OF_COLOUR_PLANES INTEGER 3
set_parameter_property NUMBER_OF_COLOUR_PLANES DISPLAY_NAME "Number of color planes"
set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
set_parameter_property NUMBER_OF_COLOUR_PLANES HDL_PARAMETER true
set_parameter_property NUMBER_OF_COLOUR_PLANES AFFECTS_ELABORATION true
set_parameter_property NUMBER_OF_COLOUR_PLANES AFFECTS_GENERATION true
set_parameter_property NUMBER_OF_COLOUR_PLANES DESCRIPTION "The number of color planes per pixel."

add_parameter COLOUR_PLANES_ARE_IN_PARALLEL INTEGER 1
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane transmission format"
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL AFFECTS_ELABORATION true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL AFFECTS_GENERATION true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in sequence."

add_parameter INTERLACED integer 0
set_parameter_property INTERLACED DISPLAY_NAME "Interlaced video"
set_parameter_property INTERLACED ALLOWED_RANGES 0:1
set_parameter_property INTERLACED HDL_PARAMETER true
set_parameter_property INTERLACED DISPLAY_HINT boolean
set_parameter_property INTERLACED DESCRIPTION "The default output format is interlaced or progressive."

add_parameter H_ACTIVE_PIXELS integer 1920
set_parameter_property H_ACTIVE_PIXELS DISPLAY_NAME "Image width / Active pixels"
set_parameter_property H_ACTIVE_PIXELS ALLOWED_RANGES 32:8192
set_parameter_property H_ACTIVE_PIXELS HDL_PARAMETER true
set_parameter_property H_ACTIVE_PIXELS DISPLAY_UNITS "pixels"
set_parameter_property H_ACTIVE_PIXELS DESCRIPTION "The default output format active picture width."

add_parameter V_ACTIVE_LINES integer 1200
set_parameter_property V_ACTIVE_LINES DISPLAY_NAME "Image height / Active lines"
set_parameter_property V_ACTIVE_LINES ALLOWED_RANGES 32:8192
set_parameter_property V_ACTIVE_LINES HDL_PARAMETER true
set_parameter_property V_ACTIVE_LINES DISPLAY_UNITS "lines"
set_parameter_property V_ACTIVE_LINES DESCRIPTION "The default output format active picture height."

add_parameter ACCEPT_COLOURS_IN_SEQ integer 0
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_NAME "Allow output of channels in sequence"
set_parameter_property ACCEPT_COLOURS_IN_SEQ ALLOWED_RANGES 0:2
set_parameter_property ACCEPT_COLOURS_IN_SEQ HDL_PARAMETER true
set_parameter_property ACCEPT_COLOURS_IN_SEQ DISPLAY_HINT boolean
set_parameter_property ACCEPT_COLOURS_IN_SEQ DESCRIPTION "Enable the output of sequential and parallel color plane arrangements."

#GENERAL
add_parameter FIFO_DEPTH integer 1920
set_parameter_property FIFO_DEPTH DISPLAY_NAME "Pixel fifo size"
set_parameter_property FIFO_DEPTH ALLOWED_RANGES 32:65000
set_parameter_property FIFO_DEPTH HDL_PARAMETER true
set_parameter_property FIFO_DEPTH DISPLAY_UNITS "samples (Fifo capacity = FIFO_DEPTH x PIXELS_IN_PARALLEL)"
set_parameter_property FIFO_DEPTH DESCRIPTION "The depth of the FIFO that is used for clock crossing and rate smoothing."

add_parameter CLOCKS_ARE_SAME integer 0
set_parameter_property CLOCKS_ARE_SAME DISPLAY_NAME "Video in and out use the same clock"
set_parameter_property CLOCKS_ARE_SAME ALLOWED_RANGES 0:1
set_parameter_property CLOCKS_ARE_SAME HDL_PARAMETER true
set_parameter_property CLOCKS_ARE_SAME DISPLAY_HINT boolean
set_parameter_property CLOCKS_ARE_SAME DESCRIPTION "Turn on if the video clock and the system clock are the same."

add_parameter USE_CONTROL integer 0
set_parameter_property USE_CONTROL DISPLAY_NAME "Use control port"
set_parameter_property USE_CONTROL ALLOWED_RANGES 0:1
set_parameter_property USE_CONTROL HDL_PARAMETER true
set_parameter_property USE_CONTROL DISPLAY_HINT boolean
set_parameter_property USE_CONTROL DESCRIPTION "Enable the Avalon-MM slave port that can be used for control."

add_parameter NO_OF_MODES integer 1
set_parameter_property NO_OF_MODES DISPLAY_NAME "Runtime configurable video modes"
set_parameter_property NO_OF_MODES ALLOWED_RANGES 1:13
set_parameter_property NO_OF_MODES HDL_PARAMETER true
set_parameter_property NO_OF_MODES DISPLAY_UNITS "modes"
set_parameter_property NO_OF_MODES DESCRIPTION "Set the number of output video formats that can be stored in parallel."
 
add_parameter THRESHOLD integer 1919
set_parameter_property THRESHOLD DISPLAY_NAME "Fifo level at which to start output"
set_parameter_property THRESHOLD ALLOWED_RANGES 0:65000
set_parameter_property THRESHOLD HDL_PARAMETER true
set_parameter_property THRESHOLD DISPLAY_UNITS "pixels"
set_parameter_property THRESHOLD DESCRIPTION "Video output will start when the FIFO fill level reaches this threshold."

add_parameter STD_WIDTH integer 1
set_parameter_property STD_WIDTH DISPLAY_NAME "Width of vid_std bus"
set_parameter_property STD_WIDTH ALLOWED_RANGES 1:16
set_parameter_property STD_WIDTH HDL_PARAMETER true
set_parameter_property STD_WIDTH DISPLAY_UNITS "bits"
set_parameter_property STD_WIDTH DESCRIPTION "Sets the width in bits of the vid_std bus."

add_parameter GENERATE_SYNC integer 0
set_parameter_property GENERATE_SYNC DISPLAY_NAME "Generate synchronization outputs"
set_parameter_property GENERATE_SYNC ALLOWED_RANGES 0:1
set_parameter_property GENERATE_SYNC HDL_PARAMETER true
set_parameter_property GENERATE_SYNC DISPLAY_HINT boolean
set_parameter_property GENERATE_SYNC VISIBLE true
set_parameter_property GENERATE_SYNC DESCRIPTION "Include the vid_sof and vid_sof_locked and vid_vcoclk_div output signals, which can be used externally to sync video streams."

add_parameter ACCEPT_SYNC integer 0
set_parameter_property ACCEPT_SYNC DISPLAY_NAME "Accept synchronization inputs"
set_parameter_property ACCEPT_SYNC ALLOWED_RANGES 0:1
set_parameter_property ACCEPT_SYNC HDL_PARAMETER true
set_parameter_property ACCEPT_SYNC DISPLAY_HINT boolean
set_parameter_property ACCEPT_SYNC VISIBLE true
set_parameter_property ACCEPT_SYNC DESCRIPTION "Include the sof and sof_locked input signals, which the output video can be synchronized to."

add_parameter COUNT_STEP_IS_PIP_VALUE integer 0
set_parameter_property COUNT_STEP_IS_PIP_VALUE DISPLAY_NAME "Set vco_clk_divider increment to pixels in parallel"
set_parameter_property COUNT_STEP_IS_PIP_VALUE ALLOWED_RANGES 0:1
set_parameter_property COUNT_STEP_IS_PIP_VALUE HDL_PARAMETER true
set_parameter_property COUNT_STEP_IS_PIP_VALUE DISPLAY_HINT boolean
set_parameter_property COUNT_STEP_IS_PIP_VALUE DESCRIPTION "Determines whether the clock divider count increments 1 at a time or by pixels in parallel value"

add_parameter LOW_LATENCY integer 0
set_parameter_property LOW_LATENCY DISPLAY_NAME "Low latency mode" 
set_parameter_property LOW_LATENCY ALLOWED_RANGES {0,1}
set_parameter_property LOW_LATENCY HDL_PARAMETER true
set_parameter_property LOW_LATENCY DESCRIPTION "Enables switching of outut resolution mid-frame (minimises back-pressure)"
set_parameter_property LOW_LATENCY VISIBLE true

#SYNCS
add_parameter USE_EMBEDDED_SYNCS integer 0
set_parameter_property USE_EMBEDDED_SYNCS VISIBLE true
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_NAME "Syncs signals"
set_parameter_property USE_EMBEDDED_SYNCS ALLOWED_RANGES  {"1:Embedded in video" "0:On separate wires"}
set_parameter_property USE_EMBEDDED_SYNCS HDL_PARAMETER true
set_parameter_property USE_EMBEDDED_SYNCS DISPLAY_HINT radio
set_parameter_property USE_EMBEDDED_SYNCS DESCRIPTION "Insert sync signals into the video data, otherwise use separate sync signals."

add_parameter AP_LINE integer 0
set_parameter_property AP_LINE DISPLAY_NAME "Active picture line"
set_parameter_property AP_LINE ALLOWED_RANGES 0:50000
set_parameter_property AP_LINE HDL_PARAMETER true
set_parameter_property AP_LINE DESCRIPTION "The line number that should be used for the first line of active picture in the frame."

add_parameter V_BLANK integer 0
set_parameter_property V_BLANK DISPLAY_NAME "Vertical blanking"
set_parameter_property V_BLANK ALLOWED_RANGES 0:50000
set_parameter_property V_BLANK HDL_PARAMETER true
set_parameter_property V_BLANK DISPLAY_UNITS "lines"
set_parameter_property V_BLANK DESCRIPTION "The size of the vertical blanking for the frame or after the active picture of field 1 ends."

add_parameter H_BLANK integer 0
set_parameter_property H_BLANK DISPLAY_NAME "Horizontal blanking"
set_parameter_property H_BLANK ALLOWED_RANGES 0:50000
set_parameter_property H_BLANK HDL_PARAMETER true
set_parameter_property H_BLANK DISPLAY_UNITS "pixels"
set_parameter_property H_BLANK DESCRIPTION "The size of the horizontal blanking for the frame."

add_parameter H_SYNC_LENGTH integer 44
set_parameter_property H_SYNC_LENGTH DISPLAY_NAME "Horizontal sync"
set_parameter_property H_SYNC_LENGTH ALLOWED_RANGES 0:50000
set_parameter_property H_SYNC_LENGTH HDL_PARAMETER true
set_parameter_property H_SYNC_LENGTH DISPLAY_UNITS "pixels"
set_parameter_property H_SYNC_LENGTH DESCRIPTION "The size of the horizontal sync for the frame."

add_parameter H_FRONT_PORCH integer 88
set_parameter_property H_FRONT_PORCH DISPLAY_NAME "Horizontal front porch"
set_parameter_property H_FRONT_PORCH ALLOWED_RANGES 0:50000
set_parameter_property H_FRONT_PORCH HDL_PARAMETER true
set_parameter_property H_FRONT_PORCH DISPLAY_UNITS "pixels"
set_parameter_property H_FRONT_PORCH DESCRIPTION "The size of the horizontal front porch for the frame."

add_parameter H_BACK_PORCH integer 148
set_parameter_property H_BACK_PORCH DISPLAY_NAME "Horizontal back porch"
set_parameter_property H_BACK_PORCH ALLOWED_RANGES 0:50000
set_parameter_property H_BACK_PORCH HDL_PARAMETER true
set_parameter_property H_BACK_PORCH DISPLAY_UNITS "pixels"
set_parameter_property H_BACK_PORCH DESCRIPTION "The size of the horizontal back porch for the frame."

add_parameter V_SYNC_LENGTH integer 5
set_parameter_property V_SYNC_LENGTH DISPLAY_NAME "Vertical sync"
set_parameter_property V_SYNC_LENGTH ALLOWED_RANGES 0:50000
set_parameter_property V_SYNC_LENGTH HDL_PARAMETER true
set_parameter_property V_SYNC_LENGTH DISPLAY_UNITS "lines"
set_parameter_property V_SYNC_LENGTH DESCRIPTION "The size of the vertical sync for the frame or field 1."

add_parameter V_FRONT_PORCH integer 4
set_parameter_property V_FRONT_PORCH DISPLAY_NAME "Vertical front porch"
set_parameter_property V_FRONT_PORCH ALLOWED_RANGES 0:50000
set_parameter_property V_FRONT_PORCH HDL_PARAMETER true
set_parameter_property V_FRONT_PORCH DISPLAY_UNITS "lines"
set_parameter_property V_FRONT_PORCH DESCRIPTION "The size of the vertical front porch for the frame or field 1."

add_parameter V_BACK_PORCH integer 36
set_parameter_property V_BACK_PORCH DISPLAY_NAME "Vertical back porch"
set_parameter_property V_BACK_PORCH ALLOWED_RANGES 0:50000
set_parameter_property V_BACK_PORCH HDL_PARAMETER true
set_parameter_property V_BACK_PORCH DISPLAY_UNITS "lines"
set_parameter_property V_BACK_PORCH DESCRIPTION "The size of the vertical back porch for the frame or field 1."

add_parameter F_RISING_EDGE integer 0
set_parameter_property F_RISING_EDGE DISPLAY_NAME "F rising edge line"
set_parameter_property F_RISING_EDGE ALLOWED_RANGES 0:50000
set_parameter_property F_RISING_EDGE HDL_PARAMETER true
set_parameter_property F_RISING_EDGE DESCRIPTION "The line number that field 1 should start on."

add_parameter F_FALLING_EDGE integer 0
set_parameter_property F_FALLING_EDGE DISPLAY_NAME "F falling edge line"
set_parameter_property F_FALLING_EDGE ALLOWED_RANGES 0:50000
set_parameter_property F_FALLING_EDGE HDL_PARAMETER true
set_parameter_property F_FALLING_EDGE DESCRIPTION "The line number that field 0 should start on."

add_parameter FIELD0_V_RISING_EDGE integer 0
set_parameter_property FIELD0_V_RISING_EDGE DISPLAY_NAME "Vertical blanking rising edge line"
set_parameter_property FIELD0_V_RISING_EDGE ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_V_RISING_EDGE HDL_PARAMETER true
set_parameter_property FIELD0_V_RISING_EDGE DESCRIPTION "The line number that that active picture for field 0 ends and the vertical blanking begins."

add_parameter FIELD0_V_BLANK integer 0
set_parameter_property FIELD0_V_BLANK DISPLAY_NAME "Vertical blanking"
set_parameter_property FIELD0_V_BLANK ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_V_BLANK HDL_PARAMETER true
set_parameter_property FIELD0_V_BLANK DISPLAY_UNITS "lines"
set_parameter_property FIELD0_V_BLANK DESCRIPTION "The size of the vertical blanking after the active picture of field 0 ends."

add_parameter FIELD0_V_SYNC_LENGTH integer 0
set_parameter_property FIELD0_V_SYNC_LENGTH DISPLAY_NAME "Vertical sync"
set_parameter_property FIELD0_V_SYNC_LENGTH ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_V_SYNC_LENGTH HDL_PARAMETER true
set_parameter_property FIELD0_V_SYNC_LENGTH DISPLAY_UNITS "lines"
set_parameter_property FIELD0_V_SYNC_LENGTH DESCRIPTION "The size of the vertical sync for field 0."

add_parameter FIELD0_V_FRONT_PORCH integer 0
set_parameter_property FIELD0_V_FRONT_PORCH DISPLAY_NAME "Vertical front porch"
set_parameter_property FIELD0_V_FRONT_PORCH ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_V_FRONT_PORCH HDL_PARAMETER true
set_parameter_property FIELD0_V_FRONT_PORCH DISPLAY_UNITS "lines"
set_parameter_property FIELD0_V_FRONT_PORCH DESCRIPTION "The size of the vertical front porch for field 0."

add_parameter FIELD0_V_BACK_PORCH integer 0
set_parameter_property FIELD0_V_BACK_PORCH DISPLAY_NAME "Vertical back porch"
set_parameter_property FIELD0_V_BACK_PORCH ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_V_BACK_PORCH HDL_PARAMETER true
set_parameter_property FIELD0_V_BACK_PORCH DISPLAY_UNITS "lines"
set_parameter_property FIELD0_V_BACK_PORCH DESCRIPTION "The size of the vertical back porch for field 0."

add_parameter ANC_LINE integer 0
set_parameter_property ANC_LINE DISPLAY_NAME "Ancillary packet insertion line"
set_parameter_property ANC_LINE ALLOWED_RANGES 0:50000
set_parameter_property ANC_LINE HDL_PARAMETER true
set_parameter_property ANC_LINE DESCRIPTION "The line number to start inserting ancillary packets into for the frame or field 1."

add_parameter FIELD0_ANC_LINE integer 0
set_parameter_property FIELD0_ANC_LINE DISPLAY_NAME "Ancillary packet insertion line"
set_parameter_property FIELD0_ANC_LINE ALLOWED_RANGES 0:50000
set_parameter_property FIELD0_ANC_LINE HDL_PARAMETER true
set_parameter_property FIELD0_ANC_LINE DESCRIPTION "The line number to start inserting ancillary packets into for field 0."

# Additional parameters to match clocked_video conduit type for VIP component test methodology
#add_parameter PIXELS_IN_PARALLEL integer 1
#set_parameter_property PIXELS_IN_PARALLEL DISPLAY_NAME "Number of pixels in Parallel"
#set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
#set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER true
#set_parameter_property PIXELS_IN_PARALLEL AFFECTS_ELABORATION true
#set_parameter_property PIXELS_IN_PARALLEL AFFECTS_GENERATION true
#set_parameter_property PIXELS_IN_PARALLEL DESCRIPTION "Will be added to CVO HDL in future, cureently a placeholder for flow"
add_pixels_in_parallel_parameters

add_parameter NO_OF_CHANNELS integer 1
set_parameter_property NO_OF_CHANNELS VISIBLE false
set_parameter_property NO_OF_CHANNELS DISPLAY_NAME "Number of Channels"
set_parameter_property NO_OF_CHANNELS ALLOWED_RANGES 1:4
set_parameter_property NO_OF_CHANNELS HDL_PARAMETER FALSE
set_parameter_property NO_OF_CHANNELS DESCRIPTION "Will be added to CVO HDL in future, cureently a placeholder for flow"

add_av_st_event_parameters
set_parameter_property SRC_WIDTH VISIBLE false
set_parameter_property DST_WIDTH VISIBLE false
set_parameter_property CONTEXT_WIDTH VISIBLE false
set_parameter_property TASK_WIDTH VISIBLE false

#Order due to spr 333763
add_display_item "Image Data Format" H_ACTIVE_PIXELS parameter
add_display_item "Image Data Format" V_ACTIVE_LINES parameter
add_display_item "Image Data Format" BPS parameter
add_display_item "Image Data Format" NUMBER_OF_COLOUR_PLANES parameter
add_display_item "Image Data Format" COLOUR_PLANES_ARE_IN_PARALLEL parameter
add_display_item "Image Data Format" ACCEPT_COLOURS_IN_SEQ parameter
add_display_item "Image Data Format" PIXELS_IN_PARALLEL parameter
add_display_item "Image Data Format" NO_OF_CHANNELS parameter
add_display_item "Image Data Format" INTERLACED parameter

add_display_item "Syncs Configuration" USE_EMBEDDED_SYNCS parameter
add_display_item "Syncs Configuration" AP_LINE parameter
add_display_item "Syncs Configuration" "Frame / Field 1 Parameters" group
add_display_item "Syncs Configuration" "Interlaced and Field 0 Parameters" group

add_display_item "General Parameters" FIFO_DEPTH parameter
add_display_item "General Parameters" THRESHOLD parameter
add_display_item "General Parameters" CLOCKS_ARE_SAME parameter
add_display_item "General Parameters" USE_CONTROL parameter
add_display_item "General Parameters" GENERATE_SYNC parameter
add_display_item "General Parameters" ACCEPT_SYNC parameter
add_display_item "General Parameters" COUNT_STEP_IS_PIP_VALUE parameter
add_display_item "General Parameters" NO_OF_MODES parameter
add_display_item "General Parameters" STD_WIDTH parameter
add_display_item "General Parameters" LOW_LATENCY parameter

add_display_item "Frame / Field 1 Parameters" ANC_LINE parameter
add_display_item "Frame / Field 1 Parameters" "Embedded Syncs Only - Frame / Field 1" group
add_display_item "Frame / Field 1 Parameters" "Separate Syncs Only - Frame / Field 1" group

add_display_item "Embedded Syncs Only - Frame / Field 1" H_BLANK parameter
add_display_item "Embedded Syncs Only - Frame / Field 1" V_BLANK parameter

add_display_item "Separate Syncs Only - Frame / Field 1" H_SYNC_LENGTH parameter
add_display_item "Separate Syncs Only - Frame / Field 1" H_FRONT_PORCH parameter
add_display_item "Separate Syncs Only - Frame / Field 1" H_BACK_PORCH parameter
add_display_item "Separate Syncs Only - Frame / Field 1" V_SYNC_LENGTH parameter
add_display_item "Separate Syncs Only - Frame / Field 1" V_FRONT_PORCH parameter
add_display_item "Separate Syncs Only - Frame / Field 1" V_BACK_PORCH parameter

add_display_item "Interlaced and Field 0 Parameters" F_RISING_EDGE parameter
add_display_item "Interlaced and Field 0 Parameters" F_FALLING_EDGE parameter
add_display_item "Interlaced and Field 0 Parameters" FIELD0_V_RISING_EDGE parameter
add_display_item "Interlaced and Field 0 Parameters" FIELD0_ANC_LINE parameter
add_display_item "Interlaced and Field 0 Parameters" "Embedded Syncs Only - Field 0" group
add_display_item "Interlaced and Field 0 Parameters" "Separate Syncs Only - Field 0" group

add_display_item "Embedded Syncs Only - Field 0" FIELD0_V_BLANK parameter

add_display_item "Separate Syncs Only - Field 0" FIELD0_V_SYNC_LENGTH parameter
add_display_item "Separate Syncs Only - Field 0" FIELD0_V_FRONT_PORCH parameter
add_display_item "Separate Syncs Only - Field 0" FIELD0_V_BACK_PORCH parameter
 


proc cvo_validation_callback {} {
    set use_embedded_syncs [get_parameter_value USE_EMBEDDED_SYNCS]
    if { $use_embedded_syncs == 1} {
        set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 2
        set_parameter_property BPS ALLOWED_RANGES 8,10
        #set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4} 
        set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1}
    } else {
        set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
        set_parameter_property BPS ALLOWED_RANGES 4:20
        set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
        #set_parameter_property GENERATE_VID_F ENABLED true
        #set_parameter_property GENERATE_ANC ENABLED false
        #set_parameter_property ANC_DEPTH ENABLED false
    }
    
    set interlaced [get_parameter_value INTERLACED]
    if { $interlaced == 0} {
        set_parameter_property FIELD0_V_RISING_EDGE ENABLED false
        set_parameter_property FIELD0_V_BLANK ENABLED false
        set_parameter_property FIELD0_V_SYNC_LENGTH ENABLED false
        set_parameter_property FIELD0_V_FRONT_PORCH ENABLED false
        set_parameter_property FIELD0_V_BACK_PORCH ENABLED false
        set_parameter_property FIELD0_ANC_LINE ENABLED false
    } else {    
        set_parameter_property FIELD0_V_RISING_EDGE ENABLED true
        set_parameter_property FIELD0_V_BLANK ENABLED true
        set_parameter_property FIELD0_V_SYNC_LENGTH ENABLED true
        set_parameter_property FIELD0_V_FRONT_PORCH ENABLED true
        set_parameter_property FIELD0_V_BACK_PORCH ENABLED true
        set_parameter_property FIELD0_ANC_LINE ENABLED true
    }
    
    set colour_planes_are_in_parallel [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    if { $colour_planes_are_in_parallel == 1 } {
        set_parameter_property ACCEPT_COLOURS_IN_SEQ ENABLED true
    } else {
        set_parameter_property ACCEPT_COLOURS_IN_SEQ ENABLED false
    }
    
    set fifo_threshold [get_parameter_value THRESHOLD]
    set fifo_size [get_parameter_value FIFO_DEPTH]
    
    if { $fifo_threshold > $fifo_size } {
        send_message Error "The fifo threshold must be set to less than the FIFO_DEPTH"
    }
    
    set use_control [get_parameter_value USE_CONTROL]
    if {$use_control == 1} {
        set_parameter_property GENERATE_SYNC ENABLED true
    } else {
        set_parameter_property GENERATE_SYNC ENABLED false    
    }

    set generate_sync [get_parameter_value GENERATE_SYNC]    
    if {$generate_sync == 1} {
        set_parameter_property ACCEPT_SYNC ENABLED true
        set_parameter_property COUNT_STEP_IS_PIP_VALUE ENABLED true
    } else {
        set_parameter_property ACCEPT_SYNC ENABLED false    
        set_parameter_property COUNT_STEP_IS_PIP_VALUE ENABLED false
    }
    
}


proc cvo_composition_callback {} {
    global isVersion acdsVersion

    set bps                     [get_parameter_value BPS]
    set are_in_par              [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes  [get_parameter_value NUMBER_OF_COLOUR_PLANES]
    set pixels_in_parallel      [get_parameter_value PIXELS_IN_PARALLEL]
    set fifo_depth              [get_parameter_value FIFO_DEPTH]
    set clocks_are_same         [get_parameter_value CLOCKS_ARE_SAME]

    set src_width               [get_parameter_value SRC_WIDTH]
    set dst_width               [get_parameter_value DST_WIDTH]
    set context_width           [get_parameter_value CONTEXT_WIDTH]
    set task_width              [get_parameter_value TASK_WIDTH]
    set generate_sync           [get_parameter_value GENERATE_SYNC]
    set accept_sync             [get_parameter_value ACCEPT_SYNC]
    set count_step_is_pip_value [get_parameter_value COUNT_STEP_IS_PIP_VALUE]
    
    if { $are_in_par > 0 } {
      set symbols_per_pixel $number_of_color_planes
    } else {
      set symbols_per_pixel 1
    }
    set pixel_width            [expr $bps * $symbols_per_pixel]

    add_interface   main_clock          clock               end
    add_interface   main_reset          reset               end

    add_interface   clocked_video       conduit             sink
    set_interface_property   clocked_video      export_of   cvo_core.clocked_video 

    if { $generate_sync && $accept_sync } {
        add_interface          genlock             conduit             sink
        set_interface_property genlock             export_of           cvo_core.genlock
    }
    
    # The chain of components to compose :
    ###################################################################################################################
    # The clock and reset bridges
    ###################################################################################################################
    add_instance                   is_clk_bridge               altera_clock_bridge            $acdsVersion
    add_instance                   is_reset_bridge             altera_reset_bridge            $acdsVersion

#    if {$clocks_are_same} {
#        add_instance               vid_clk_bridge              altera_clock_bridge            $acdsVersion
#        add_instance               vid_reset_bridge            altera_reset_bridge            $acdsVersion
#    }
    
    add_interface                  main_clock                  clock                           end
    set_interface_property         main_clock                  export_of                       is_clk_bridge.in_clk
    add_interface                  main_reset                  reset                           end
    set_interface_property         main_reset                  export_of                       is_reset_bridge.in_reset
    ###################################################################################################################
    # The video input bridge
    ###################################################################################################################
    add_instance                   video_in                      alt_vip_video_input_bridge   $isVersion
    set_instance_parameter_value   video_in                      BITS_PER_SYMBOL              $bps   
    set_instance_parameter_value   video_in                      COLOR_PLANES_ARE_IN_PARALLEL $are_in_par
    set_instance_parameter_value   video_in                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes
    set_instance_parameter_value   video_in                      PIXELS_IN_PARALLEL           $pixels_in_parallel
    set_instance_parameter_value   video_in                      DEFAULT_LINE_LENGTH          $fifo_depth

    add_interface   din            avalon_streaming              sink 
    set_interface_property din     export_of                     video_in.av_st_vid_din

    ###################################################################################################################
    # The CVO scheduler
    ###################################################################################################################
    add_instance                   scheduler                     alt_vip_cvo_scheduler        $isVersion
    set_instance_parameter_value   scheduler                     SRC_WIDTH                    $src_width
    set_instance_parameter_value   scheduler                     DST_WIDTH                    $dst_width
    set_instance_parameter_value   scheduler                     CONTEXT_WIDTH                $context_width
    set_instance_parameter_value   scheduler                     TASK_WIDTH                   $task_width
    set_instance_parameter_value   scheduler                     USE_CONTROL                  [get_parameter_value USE_CONTROL]
    
    ###################################################################################################################
    # The SOP realigner
    ###################################################################################################################
    add_instance                   sop_align                     alt_vip_pip_sop_realign      $isVersion
    set_instance_parameter_value   sop_align                     PIXEL_WIDTH                  $pixel_width                
    set_instance_parameter_value   sop_align                     PIXELS_IN_PARALLEL           $pixels_in_parallel
    set_instance_parameter_value   sop_align                     SRC_WIDTH                    $src_width
    set_instance_parameter_value   sop_align                     DST_WIDTH                    $dst_width
    set_instance_parameter_value   sop_align                     CONTEXT_WIDTH                $context_width
    set_instance_parameter_value   sop_align                     TASK_WIDTH                   $task_width
    
                  
    ###################################################################################################################
    # The CVO core
    ###################################################################################################################
    add_instance cvo_core alt_vip_cvo_core $isVersion

    set_instance_parameter_value    cvo_core     NUMBER_OF_COLOUR_PLANES       [get_parameter_value NUMBER_OF_COLOUR_PLANES]
    set_instance_parameter_value    cvo_core     COLOUR_PLANES_ARE_IN_PARALLEL [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
    set_instance_parameter_value    cvo_core     BPS                           [get_parameter_value BPS]
    set_instance_parameter_value    cvo_core     INTERLACED                    [get_parameter_value INTERLACED]               
    set_instance_parameter_value    cvo_core     H_ACTIVE_PIXELS               [get_parameter_value H_ACTIVE_PIXELS]       
    set_instance_parameter_value    cvo_core     V_ACTIVE_LINES                [get_parameter_value V_ACTIVE_LINES]        
    set_instance_parameter_value    cvo_core     ACCEPT_COLOURS_IN_SEQ         [get_parameter_value ACCEPT_COLOURS_IN_SEQ] 
    set_instance_parameter_value    cvo_core     FIFO_DEPTH                    [get_parameter_value FIFO_DEPTH]
    set_instance_parameter_value    cvo_core     CLOCKS_ARE_SAME               [get_parameter_value CLOCKS_ARE_SAME]       
    set_instance_parameter_value    cvo_core     USE_CONTROL                   [get_parameter_value USE_CONTROL]               
    set_instance_parameter_value    cvo_core     NO_OF_MODES                   [get_parameter_value NO_OF_MODES]               
    set_instance_parameter_value    cvo_core     THRESHOLD                     [get_parameter_value THRESHOLD]               
    set_instance_parameter_value    cvo_core     STD_WIDTH                     [get_parameter_value STD_WIDTH]               
    set_instance_parameter_value    cvo_core     GENERATE_SYNC                 [get_parameter_value GENERATE_SYNC ]        
    set_instance_parameter_value    cvo_core     ACCEPT_SYNC                   [get_parameter_value ACCEPT_SYNC ]        
    set_instance_parameter_value    cvo_core     COUNT_STEP_IS_PIP_VALUE       [get_parameter_value COUNT_STEP_IS_PIP_VALUE ]
    set_instance_parameter_value    cvo_core     USE_EMBEDDED_SYNCS            [get_parameter_value USE_EMBEDDED_SYNCS]
    set_instance_parameter_value    cvo_core     AP_LINE                       [get_parameter_value AP_LINE]               
    set_instance_parameter_value    cvo_core     V_BLANK                       [get_parameter_value V_BLANK]               
    set_instance_parameter_value    cvo_core     H_BLANK                       [get_parameter_value H_BLANK]               
    set_instance_parameter_value    cvo_core     H_SYNC_LENGTH                 [get_parameter_value H_SYNC_LENGTH]               
    set_instance_parameter_value    cvo_core     H_FRONT_PORCH                 [get_parameter_value H_FRONT_PORCH]               
    set_instance_parameter_value    cvo_core     H_BACK_PORCH                  [get_parameter_value H_BACK_PORCH]               
    set_instance_parameter_value    cvo_core     V_SYNC_LENGTH                 [get_parameter_value V_SYNC_LENGTH]               
    set_instance_parameter_value    cvo_core     V_FRONT_PORCH                 [get_parameter_value V_FRONT_PORCH]               
    set_instance_parameter_value    cvo_core     V_BACK_PORCH                  [get_parameter_value V_BACK_PORCH]               
    set_instance_parameter_value    cvo_core     F_RISING_EDGE                 [get_parameter_value F_RISING_EDGE]        
    set_instance_parameter_value    cvo_core     F_FALLING_EDGE                [get_parameter_value F_FALLING_EDGE]       
    set_instance_parameter_value    cvo_core     FIELD0_V_RISING_EDGE          [get_parameter_value FIELD0_V_RISING_EDGE]  
    set_instance_parameter_value    cvo_core     FIELD0_V_BLANK                [get_parameter_value FIELD0_V_BLANK]        
    set_instance_parameter_value    cvo_core     FIELD0_V_SYNC_LENGTH          [get_parameter_value FIELD0_V_SYNC_LENGTH]  
    set_instance_parameter_value    cvo_core     FIELD0_V_FRONT_PORCH          [get_parameter_value FIELD0_V_FRONT_PORCH]  
    set_instance_parameter_value    cvo_core     FIELD0_V_BACK_PORCH           [get_parameter_value FIELD0_V_BACK_PORCH]  
    set_instance_parameter_value    cvo_core     ANC_LINE                      [get_parameter_value ANC_LINE]               
    set_instance_parameter_value    cvo_core     FIELD0_ANC_LINE               [get_parameter_value FIELD0_ANC_LINE]       
    set_instance_parameter_value    cvo_core     PIXELS_IN_PARALLEL            [get_parameter_value PIXELS_IN_PARALLEL]   
    set_instance_parameter_value    cvo_core     NO_OF_CHANNELS                [get_parameter_value NO_OF_CHANNELS]  
    set_instance_parameter_value    cvo_core     LOW_LATENCY                   [get_parameter_value LOW_LATENCY]
    
    # UHD_MODE must be set for using external signals 
    # It should be possible to re-arrange the core RTL so that the parameter becomes unnecessary.
    set use_embedded_syncs [get_parameter_value USE_EMBEDDED_SYNCS]
    if { $use_embedded_syncs==1 } {
        set uhd_mode 0
    } else {
        set uhd_mode 1
    }
    set_instance_parameter_value    cvo_core         UHD_MODE                      $uhd_mode

    # Now do some elaboration (can't have composition and elaboration callbacks)

    # Connect up the instances
    add_connection                 is_clk_bridge.out_clk         is_reset_bridge.clk
    
    add_connection                 video_in.av_st_dout           sop_align.av_st_din
    add_connection                 sop_align.av_st_dout           cvo_core.av_st_din
    add_connection                 is_reset_bridge.out_reset     video_in.main_reset
    add_connection                 is_clk_bridge.out_clk         video_in.main_clock

    add_connection                 is_reset_bridge.out_reset     sop_align.main_reset
    add_connection                 is_clk_bridge.out_clk         sop_align.main_clock
    
    add_connection                 is_reset_bridge.out_reset     cvo_core.main_reset
    add_connection                 is_clk_bridge.out_clk         cvo_core.main_clock
    
    # --------------------------------------------------------------------------------------------------
    # -- Scheduler connections                                                                        --
    # --------------------------------------------------------------------------------------------------
    add_connection                 is_reset_bridge.out_reset     scheduler.main_reset
    add_connection                 is_clk_bridge.out_clk         scheduler.main_clock
   
    add_connection                 scheduler.cmd_vib             video_in.av_st_cmd
    add_connection                 scheduler.cmd_mark            cvo_core.cmd_mark
    
    add_connection                 video_in.av_st_resp           scheduler.resp_vib
    
    add_connection                 scheduler.cmd_mode_banks         cvo_core.cmd_mode_banks
    add_connection                 cvo_core.resp_mode_banks         scheduler.resp_mode_banks
    
    ###################################################################################################################
    # Control Slave
    ###################################################################################################################
    set use_control [get_parameter_value USE_CONTROL]

    # Optional Control slave when enabled
    if { $use_control==1 } {
        add_instance                   control                         alt_vip_control_slave          $isVersion
        set_instance_parameter_value   control                      NUM_READ_REGISTERS             1
        set_instance_parameter_value   control                         NUM_TRIGGER_REGISTERS          27
        set_instance_parameter_value   control                         NUM_RW_REGISTERS               0
        set_instance_parameter_value   control                         NUM_INTERRUPTS                 2
        set_instance_parameter_value   control                         MM_CONTROL_REG_BYTES           1
        set_instance_parameter_value   control                         MM_READ_REG_BYTES              4              
        set_instance_parameter_value   control                         DATA_INPUT                     0
        set_instance_parameter_value   control                         DATA_OUTPUT                    0
        set_instance_parameter_value   control                         FAST_REGISTER_UPDATES          0
        set_instance_parameter_value   control                         USE_MEMORY                     0
        set_instance_parameter_value   control                         PIPELINE_READ                  0
        set_instance_parameter_value   control                         PIPELINE_RESPONSE              0
        set_instance_parameter_value   control                         PIPELINE_DATA                  0
        set_instance_parameter_value   control                         SRC_WIDTH                      8
        set_instance_parameter_value   control                         DST_WIDTH                      8
        set_instance_parameter_value   control                         CONTEXT_WIDTH                  8
        set_instance_parameter_value   control                         TASK_WIDTH                     8
        set_instance_parameter_value   control                         RESP_SOURCE                    1
        set_instance_parameter_value   control                         RESP_DEST                      1 
        set_instance_parameter_value   control                         RESP_CONTEXT                   1
        set_instance_parameter_value   control                         DOUT_SOURCE                    1
        set_instance_parameter_value   control                         NUM_BLOCKING_TRIGGER_REGISTERS 0    
        set_instance_parameter_value   control                         MM_TRIGGER_REG_BYTES           4
        set_instance_parameter_value   control                         MM_RW_REG_BYTES                4
        set_instance_parameter_value   control                         MM_ADDR_WIDTH                  8

        add_interface control avalon slave 
        set_interface_property control export_of control.av_mm_control
    
        add_connection                 is_reset_bridge.out_reset     control.main_reset
        add_connection                 is_clk_bridge.out_clk         control.main_clock
    
        add_connection                 scheduler.cmd_control_slave   control.av_st_cmd
        add_connection                 control.av_st_resp            scheduler.resp_control_slave

        add_interface status_update_irq interrupt end 
        set_interface_property status_update_irq export_of control.av_mm_control_interrupt
    }
}
