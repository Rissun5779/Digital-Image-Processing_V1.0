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


source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl
source ../../common_tcl/alt_vip_interfaces_common.tcl

# Common module properties for VIP components 
declare_general_component_info

# General info
set_module_property NAME alt_vip_cvo_core
set_module_property DISPLAY_NAME "Clocked Video Output Core"
set_module_property DESCRIPTION "The Clocked Video Output converts Avalon-ST Video to standard video formats such as BT656 or VGA."

#set_module_property simulation_model_in_vhdl true
add_alt_vip_common_pkg_files ../..
add_alt_vip_common_event_packet_encode_files ../..
add_alt_vip_common_event_packet_decode_files ../..
add_alt_vip_common_fifo_files ../..
add_alt_vip_common_generic_step_count_files ../..
add_alt_vip_common_to_binary_files ../..
add_alt_vip_common_sync_files ../..
add_alt_vip_common_trigger_sync_files ../..
add_alt_vip_common_sync_generation_files ../..
add_alt_vip_common_frame_counter_files ../..
add_alt_vip_common_sample_counter_files ../..
add_static_sv_file src_hdl/alt_vip_cvo_stream_marker.sv		    
add_static_sv_file src_hdl/alt_vip_cvo_core.sv		    
add_static_sv_file src_hdl/alt_vip_cvo_sync_compare.v		    
add_static_sv_file src_hdl/alt_vip_cvo_sync_conditioner.sv		    
add_static_sv_file src_hdl/alt_vip_cvo_sync_generation.sv		    
add_static_sv_file src_hdl/alt_vip_cvo_calculate_mode.v		    
add_static_sv_file src_hdl/alt_vip_cvo_mode_banks.sv		    
add_static_sv_file src_hdl/alt_vip_cvo_statemachine.sv		    

add_static_sdc_file alt_vip_cvo_core.sdc .

add_static_misc_file src_hdl/alt_vip_cvo_core.ocp

setup_filesets alt_vip_cvo_core


#Properties

# -- Parameters --
add_parameter FAMILY string "Cyclone IV"
set_parameter_property FAMILY DISPLAY_NAME "Device family selected"
set_parameter_property FAMILY DESCRIPTION "Current device family selected"
set_parameter_property FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property FAMILY VISIBLE false

# IMAGE DATA FORMAT
add_parameter NUMBER_OF_COLOUR_PLANES integer 3
set_parameter_property NUMBER_OF_COLOUR_PLANES DISPLAY_NAME "Number of color planes"
set_parameter_property NUMBER_OF_COLOUR_PLANES ALLOWED_RANGES 1:4
set_parameter_property NUMBER_OF_COLOUR_PLANES HDL_PARAMETER true
set_parameter_property NUMBER_OF_COLOUR_PLANES DESCRIPTION "The number of color planes per pixel."

add_parameter COLOUR_PLANES_ARE_IN_PARALLEL integer 1
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_NAME "Color plane transmission format"
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL ALLOWED_RANGES {0:Sequence 1:Parallel}
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL HDL_PARAMETER true
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DISPLAY_HINT radio
set_parameter_property COLOUR_PLANES_ARE_IN_PARALLEL DESCRIPTION "The color planes are arranged in parallel, otherwise in sequence."

add_parameter BPS integer 8
set_parameter_property BPS DISPLAY_NAME "Bits per pixel per color plane"
set_parameter_property BPS ALLOWED_RANGES 4:20
set_parameter_property BPS HDL_PARAMETER true
set_parameter_property BPS DISPLAY_UNITS "bits"
set_parameter_property BPS DESCRIPTION "The number of bits used per pixel, per color plane."

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
set_parameter_property FIFO_DEPTH DISPLAY_UNITS "pixels"
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
set_parameter_property GENERATE_SYNC DESCRIPTION "Include the vid_sof and vid_sof_locked and vid_vcoclk_div output signals, which can be used externally to sync video streams."

add_parameter ACCEPT_SYNC integer 0
set_parameter_property ACCEPT_SYNC DISPLAY_NAME "Accept synchronization inputs"
set_parameter_property ACCEPT_SYNC ALLOWED_RANGES 0:1
set_parameter_property ACCEPT_SYNC HDL_PARAMETER true
set_parameter_property ACCEPT_SYNC DISPLAY_HINT boolean
set_parameter_property ACCEPT_SYNC DESCRIPTION "Include the sof and sof_locked input signals, which the output video can be synchronized to."

add_parameter COUNT_STEP_IS_PIP_VALUE integer 0
set_parameter_property COUNT_STEP_IS_PIP_VALUE DISPLAY_NAME "Set vco_clk_divider increment to pixels in parallel"
set_parameter_property COUNT_STEP_IS_PIP_VALUE ALLOWED_RANGES 0:1
set_parameter_property COUNT_STEP_IS_PIP_VALUE HDL_PARAMETER true
set_parameter_property COUNT_STEP_IS_PIP_VALUE DISPLAY_HINT boolean
set_parameter_property COUNT_STEP_IS_PIP_VALUE DESCRIPTION "Determines whether the clock divider count increments 1 at a time or by pixels in parallel value"

#SYNCS
add_parameter USE_EMBEDDED_SYNCS integer 0
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
add_parameter PIXELS_IN_PARALLEL integer 1
set_parameter_property PIXELS_IN_PARALLEL DISPLAY_NAME "Number of pixels in Parallel"
set_parameter_property PIXELS_IN_PARALLEL ALLOWED_RANGES {1,2,4,8}
set_parameter_property PIXELS_IN_PARALLEL HDL_PARAMETER true
set_parameter_property PIXELS_IN_PARALLEL DESCRIPTION "Will be added to CVO HDL in future, cureently a placeholder for flow"

add_parameter NO_OF_CHANNELS integer 1
set_parameter_property NO_OF_CHANNELS DISPLAY_NAME "Number of Channels"
set_parameter_property NO_OF_CHANNELS ALLOWED_RANGES 1:4
set_parameter_property NO_OF_CHANNELS HDL_PARAMETER FALSE
set_parameter_property NO_OF_CHANNELS DESCRIPTION "Will be added to CVO HDL in future, cureently a placeholder for flow"
add_display_item "Image Data Format" PIXELS_IN_PARALLEL parameter
add_display_item "Image Data Format" NO_OF_CHANNELS parameter

add_parameter UHD_MODE integer 0
set_parameter_property UHD_MODE DISPLAY_NAME "Generate Display Port Output"
set_parameter_property UHD_MODE ALLOWED_RANGES {0,1}
set_parameter_property UHD_MODE HDL_PARAMETER true
set_parameter_property UHD_MODE DESCRIPTION "Configure Pixels in Parallel and related syncs to be driven in Display Port compatible mode"

add_parameter LOW_LATENCY integer 0
set_parameter_property LOW_LATENCY DISPLAY_NAME "Low latency mode" 
set_parameter_property LOW_LATENCY ALLOWED_RANGES {0,1}
set_parameter_property LOW_LATENCY HDL_PARAMETER true
set_parameter_property LOW_LATENCY DESCRIPTION "Enables switching of outut resolution mid-frame (minimises back-pressure)"
set_parameter_property LOW_LATENCY VISIBLE false

add_av_st_event_parameters

#Order due to spr 333763
add_display_item "Image Data Format" H_ACTIVE_PIXELS parameter
add_display_item "Image Data Format" V_ACTIVE_LINES parameter
add_display_item "Image Data Format" BPS parameter
add_display_item "Image Data Format" NUMBER_OF_COLOUR_PLANES parameter
add_display_item "Image Data Format" COLOUR_PLANES_ARE_IN_PARALLEL parameter
add_display_item "Image Data Format" ACCEPT_COLOURS_IN_SEQ parameter
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
 
#add_main_clock_port
add_interface       main_clock   clock       end
add_interface       main_reset   reset       end       main_clock

add_interface_port  main_clock   is_clk      clk          Input    1
add_interface_port  main_reset   rst         reset        Input    1


#the elaboration callback
set_module_property ELABORATION_CALLBACK cvo_elaboration_callback

proc cvo_elaboration_callback {} {

	set src_width                   [get_parameter_value SRC_WIDTH]
	set dst_width                   [get_parameter_value DST_WIDTH]
	set context_width               [get_parameter_value CONTEXT_WIDTH]
	set task_width                  [get_parameter_value TASK_WIDTH]
        # Scheduler cmd/resp ports
        add_av_st_cmd_sink_port   cmd_mark   1   $dst_width   $src_width   $task_width   $context_width   main_clock   2

	# Control Port
	set use_control [get_parameter_value USE_CONTROL]
        add_av_st_cmd_sink_port   cmd_mode_banks   1   $dst_width   $src_width   $task_width   $context_width   main_clock   2
        add_av_st_resp_source_port    resp_mode_banks  1   $dst_width   $src_width   $task_width   $context_width   main_clock   2

	# Avalon streaming input port
	#set color_planes_are_in_parallel [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
	set are_in_par             [get_parameter_value COLOUR_PLANES_ARE_IN_PARALLEL]
	set number_of_color_planes [get_parameter_value NUMBER_OF_COLOUR_PLANES]
	set bps                    [get_parameter_value BPS]
	set pixels_in_parallel     [get_parameter_value PIXELS_IN_PARALLEL]
	
	if { $are_in_par > 0 } {
	  set symbols_per_pixel $number_of_color_planes
	} else {
	  set symbols_per_pixel 1
	}

	if {$pixels_in_parallel > 1} {
            # add the empty signal to the interface
            set use_empty 2
	} else {
            # don't add the empty signal to the interface
            set use_empty 1
	}

	set data_width               [expr $bps * $symbols_per_pixel]
	set clocked_video_data_width [expr $data_width * $pixels_in_parallel]
        add_av_st_data_sink_port    av_st_din       $data_width       $pixels_in_parallel  $dst_width           $src_width   $task_width     $context_width  0  main_clock  0

	
	# Video signals - SOPC Builder needs to treat these as asynchronous signals
	add_interface clocked_video conduit source
	set clocks_are_same [get_parameter_value CLOCKS_ARE_SAME]
	if { $clocks_are_same == 0 } {
		add_interface_port clocked_video vid_clk vid_clk input 1
	} 
	
	add_interface_port clocked_video vid_data vid_data output $clocked_video_data_width
	add_interface_port clocked_video underflow underflow output 1
	
	set sync_width [expr 1 * $pixels_in_parallel]
	if { $use_control==1 } {
		add_interface_port clocked_video vid_mode_change vid_mode_change output 1
		
		set std_width [expr $pixels_in_parallel * [get_parameter_value STD_WIDTH]]
		add_interface_port clocked_video vid_std vid_std output $std_width
		
		set generate_sync [get_parameter_value GENERATE_SYNC]
		if { $generate_sync!=0 } {
			add_interface_port clocked_video vid_vcoclk_div vid_vcoclk_div output 1
			add_interface_port clocked_video vid_sof_locked vid_sof_locked output 1
			add_interface_port clocked_video vid_sof vid_sof output 1

		}

		set accept_sync [get_parameter_value ACCEPT_SYNC]
		if { $accept_sync!=0 } {
       	                add_interface genlock conduit sink
                        add_interface_port genlock sof_locked sof_locked input 1
                        add_interface_port genlock sof sof input 1        
		}
	}
		
	set use_embedded_syncs [get_parameter_value USE_EMBEDDED_SYNCS]
	set vid_ln_width [expr 11 * $pixels_in_parallel]
	if { $use_embedded_syncs == 1 } {	
		add_interface_port clocked_video vid_trs vid_trs output $sync_width
		add_interface_port clocked_video vid_ln vid_ln output $vid_ln_width
	} else {
		add_interface_port clocked_video vid_datavalid vid_datavalid output $sync_width
		add_interface_port clocked_video vid_v_sync vid_v_sync output $sync_width
		add_interface_port clocked_video vid_h_sync vid_h_sync output $sync_width
		add_interface_port clocked_video vid_f vid_f output $sync_width
		add_interface_port clocked_video vid_h vid_h output $sync_width
		add_interface_port clocked_video vid_v vid_v output $sync_width
	}
        
}
