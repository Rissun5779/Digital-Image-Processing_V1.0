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


package require -exact qsys 16.1

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Files to be added to the SOPC component when reusing the modules defined in common_hdl       --
# -- (legacy stuff)                                                                               --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

set sv_files_list {}
set vhdl_files_list {}
set ver_files_list {}
set sdc_files_list {}
set misc_files_list {}
set hex_files_list {}

proc add_static_sv_file {filename {rel_path "."} {package_name ""} } {
    global sv_files_list
    lappend sv_files_list $filename $rel_path $package_name
}
proc add_static_vhdl_file {filename {rel_path "."}} {
    global vhdl_files_list
    lappend vhdl_files_list $filename $rel_path
}
proc add_static_ver_file {filename {rel_path "."}} {
    global ver_files_list
    lappend ver_files_list $filename $rel_path
}
proc add_static_sdc_file {filename {rel_path "."}} {
    global sdc_files_list
    lappend sdc_files_list $filename $rel_path
}
proc add_static_misc_file {filename {rel_path "."}} {
    global misc_files_list
    lappend misc_files_list $filename $rel_path
}
proc add_static_hex_file {filename {rel_path "."}} {
    global hex_files_list
    lappend hex_files_list $filename $rel_path
}

proc add_sim_encrypted_file {filename rel_path filetype {package_name ""}} {
    if {"1" == 1} {
        add_fileset_file mentor/$filename $filetype PATH "$rel_path/mentor/$filename" {MENTOR_SPECIFIC}
    }
    if {"1" == 1} {
        add_fileset_file aldec/$filename $filetype PATH "$rel_path/aldec/$filename" {ALDEC_SPECIFIC}
    }
    if {"1" == 1} {
        add_fileset_file cadence/$filename $filetype PATH "$rel_path/cadence/$filename" {CADENCE_SPECIFIC}
    }
    if {"1" == 1} {
        add_fileset_file synopsys/$filename $filetype PATH "$rel_path/synopsys/$filename" {SYNOPSYS_SPECIFIC}
    }
    if {[string compare $package_name ""] != 0} {
        if {"1" == 1} {
            set_fileset_file_attribute  mentor/$filename COMMON_SYSTEMVERILOG_PACKAGE mentor_$package_name
        }
        if {"1" == 1} {
            set_fileset_file_attribute  aldec/$filename COMMON_SYSTEMVERILOG_PACKAGE aldec_$package_name
        }
        if {"1" == 1} {
            set_fileset_file_attribute  cadence/$filename COMMON_SYSTEMVERILOG_PACKAGE cadence_$package_name
        }
        if {"1" == 1} {
            set_fileset_file_attribute  synopsys/$filename COMMON_SYSTEMVERILOG_PACKAGE synopsys_$package_name
        }
    }
}

proc setup_filesets {top_level {generate_cb ""}} {
    global sv_files_list
    global vhdl_files_list
    global ver_files_list
    global sdc_files_list
    global misc_files_list
    global hex_files_list
    global vipsuite_version

    # Quartus synth
    add_fileset synth_fileset QUARTUS_SYNTH $generate_cb
    if {[string compare $top_level ""] != 0} {
        set_fileset_property synth_fileset TOP_LEVEL $top_level
    }

    foreach {filename path package_name} $sv_files_list {
        add_fileset_file $filename SYSTEM_VERILOG PATH "$path/$filename"
    }
    foreach {filename path} $vhdl_files_list {
        add_fileset_file $filename VHDL PATH "$path/$filename"
    }
    foreach {filename path} $ver_files_list {
        add_fileset_file $filename VERILOG PATH "$path/$filename"
    }
    foreach {filename path} $hex_files_list {
        add_fileset_file $filename HEX PATH "$path/$filename"
    }
    foreach {filename path} $sdc_files_list {
        #if {[string equal $vipsuite_version VIPSUITE_STANDARD]} {
        #    set sdcname [string trim [file rootname $filename]]
        #    set sdcext "_std.sdc"
        #    set sdcfilename $sdcname$sdcext
        #    add_fileset_file $sdcfilename SDC PATH "$path/$sdcfilename"
        #} elseif {[string equal $vipsuite_version VIPSUITE_PRO]} {
        #    add_fileset_file $filename SDC_ENTITY PATH "$path/$filename"
        #} else {
        #    error "vipsuite_version is not properly defined"
        #}
        add_fileset_file $filename SDC PATH "$path/$filename"
    }
    foreach {filename path} $misc_files_list {
        add_fileset_file $filename OTHER PATH "$path/$filename"
    }

    # Sim verilog
    add_fileset sim_verilog_fileset SIM_VERILOG $generate_cb
    if {[string compare $top_level ""] != 0} {
        set_fileset_property sim_verilog_fileset TOP_LEVEL $top_level
    }
    foreach {filename path package_name} $sv_files_list {
        if {"0" == 0} {
            add_sim_encrypted_file $filename $path SYSTEM_VERILOG_ENCRYPT $package_name
        } else {
            if {"1" == 1} {
                add_fileset_file mentor/$filename SYSTEM_VERILOG_ENCRYPT PATH "$path/mentor/$filename" {MENTOR_SPECIFIC}
                if {[string compare $package_name ""] != 0} {
                    set_fileset_file_attribute mentor/$filename COMMON_SYSTEMVERILOG_PACKAGE $package_name
                }
            } else {
                add_fileset_file $filename SYSTEM_VERILOG PATH "$path/$filename" {MENTOR_SPECIFIC}
                if {[string compare $package_name ""] != 0} {
                    set_fileset_file_attribute $filename COMMON_SYSTEMVERILOG_PACKAGE $package_name
                }
            }
        }
    }
    foreach {filename path} $vhdl_files_list {
        if {"0" == 0} {
            add_sim_encrypted_file $filename $path VHDL_ENCRYPT
        } else {
            if {"1" == 1} {
                add_fileset_file mentor/$filename VHDL_ENCRYPT PATH "$path/mentor/$filename" {MENTOR_SPECIFIC}
            } else {
                add_fileset_file $filename VHDL PATH "$path/$filename" {MENTOR_SPECIFIC}
            }
        }
    }
    foreach {filename path} $ver_files_list {
        if {"0" == 0} {
            add_sim_encrypted_file $filename $path VERILOG_ENCRYPT
        } else {
            if {"1" == 1} {
                add_fileset_file mentor/$filename VERILOG_ENCRYPT PATH "$path/mentor/$filename" {MENTOR_SPECIFIC}
            } else {
                add_fileset_file $filename VERILOG PATH "$path/$filename" {MENTOR_SPECIFIC}
            }
        }
    }
    foreach {filename path} $hex_files_list {
        add_fileset_file $filename HEX PATH "$path/$filename"
    }

    # Sim vhdl
    add_fileset sim_vhdl_fileset SIM_VHDL $generate_cb
    if {[string compare $top_level ""] != 0} {
        set_fileset_property sim_vhdl_fileset TOP_LEVEL $top_level
    }
    foreach {filename path package_name} $sv_files_list {
        add_sim_encrypted_file $filename $path SYSTEM_VERILOG_ENCRYPT $package_name
    }
    foreach {filename path} $vhdl_files_list {
        add_sim_encrypted_file $filename $path VHDL_ENCRYPT
    }
    foreach {filename path} $ver_files_list {
        add_sim_encrypted_file $filename $path VERILOG_ENCRYPT
    }
    foreach {filename path} $hex_files_list {
        add_fileset_file $filename HEX PATH "$path/$filename"
    }
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- The common System Verilog packages                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc add_alt_vip_common_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_pkg.sv                        $root_rel_path/common_hdl     "alt_vip_common_pkg"
}

proc add_alt_vip_common_buf_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_buf_pkg.sv                    $root_rel_path/common_hdl     "alt_vip_common_buf_pkg"
}

proc add_alt_vip_common_ctx_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_ctx_pkg.sv                    $root_rel_path/common_hdl     "alt_vip_common_ctx_pkg"
}

proc add_alt_vip_common_debug_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_debug_pkg.sv                  $root_rel_path/common_hdl     "alt_vip_common_debug_pkg"
}

proc add_alt_vip_common_coding_info_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_coding_info_pkg.sv            $root_rel_path/common_hdl     "alt_vip_common_coding_info_pkg"
}

proc add_alt_vip_common_sao_calc_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_sao_calc_pkg.sv               $root_rel_path/common_hdl     "alt_vip_common_sao_calc_pkg"
}

proc add_alt_vip_common_bitdec_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_bitdec_pkg.sv                 $root_rel_path/common_hdl     "alt_vip_common_bitdec_pkg"
    add_static_sv_file    common/alt_vip_common_bitdec_interfaces_pkg.sv      $root_rel_path/common_hdl     "alt_vip_common_bitdec_interfaces_pkg"
}

proc add_alt_vip_common_intervmd_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_intervmd_pkg.sv               $root_rel_path/common_hdl     "alt_vip_common_intervmd_pkg"
    add_static_sv_file    common/alt_vip_common_bitdec_interfaces_pkg.sv      $root_rel_path/common_hdl     "alt_vip_common_bitdec_interfaces_pkg"
}

proc add_alt_vip_common_enc_intervmd_pkg_files {root_rel_path} {
    add_static_sv_file    common/alt_vip_common_enc_intervmd_pkg.sv           $root_rel_path/common_hdl     "alt_vip_common_enc_intervmd_pkg"
    add_static_sv_file    common/alt_vip_common_bitdec_interfaces_pkg.sv      $root_rel_path/common_hdl     "alt_vip_common_bitdec_interfaces_pkg"
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- The common modules                                                                           --
# -- Convention: use add_$modulename_files                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc add_alt_vip_common_slave_interface_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_slave_interface/src_hdl/alt_vip_common_slave_interface.sv                 $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_slave_interface/src_hdl/alt_vip_common_slave_interface_mux.sv             $root_rel_path/common_hdl
}

proc add_alt_vip_common_event_packet_decode_files {root_rel_path} {
     add_static_sv_file   modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv         $root_rel_path/common_hdl
}

proc add_common_dc_mixed_widths_fifo_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_dc_mixed_widths_fifo/src_hdl/alt_vip_common_dc_mixed_widths_fifo.sv       $root_rel_path/common_hdl
    add_static_sdc_file   modules/alt_vip_common_dc_mixed_widths_fifo/src_hdl/alt_vip_common_dc_mixed_widths_fifo.sdc      $root_rel_path/common_hdl
}

proc add_alt_vip_common_mult_add_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_mult_add/src_hdl/alt_vip_common_mult_add.sv                               $root_rel_path/common_hdl
}

proc add_alt_vip_common_mult_add_nodsp_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_mult_add_nodsp/src_hdl/alt_vip_common_mult_add_nodsp.sv                   $root_rel_path/common_hdl
}

proc add_alt_vip_common_round_sat_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_round_sat/src_hdl/alt_vip_common_round_sat.sv                             $root_rel_path/common_hdl
}

proc add_alt_vip_common_hpel_filter_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_hpel_filter/src_hdl/alt_vip_common_hpel_filter.sv                         $root_rel_path/common_hdl
}

proc add_alt_vip_common_qpel_filter_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_qpel_filter/src_hdl/alt_vip_common_qpel_filter.sv                         $root_rel_path/common_hdl
}

proc add_alt_vip_common_sad_tree_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_sad_tree/src_hdl/alt_vip_common_sad_tree.sv                               $root_rel_path/common_hdl
}

proc add_alt_vip_common_mirror_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_mirror/src_hdl/alt_vip_common_mirror.sv                                   $root_rel_path/common_hdl
}

proc add_alt_vip_common_edge_detect_chain_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_edge_detect_chain/src_hdl/alt_vip_common_edge_detect_chain.sv             $root_rel_path/common_hdl
}

proc add_alt_vip_common_h_kernel_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel.sv                               $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel_par.sv                           $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel_seq.sv                           $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_mirror/src_hdl/alt_vip_common_mirror.sv                                   $root_rel_path/common_hdl
}

proc add_alt_vip_common_event_packet_encode_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv         $root_rel_path/common_hdl
}

proc add_alt_vip_common_video_packet_decode {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_video_packet_decode/src_hdl/alt_vip_common_latency_1_to_latency_0.sv      $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_video_packet_decode/src_hdl/alt_vip_common_video_packet_decode.sv         $root_rel_path/common_hdl
}

proc add_alt_vip_common_video_packet_encode {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_latency_0_to_latency_1.sv      $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_video_packet_empty.sv          $root_rel_path/common_hdl
    add_static_sv_file    modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_video_packet_encode.sv         $root_rel_path/common_hdl
}

proc add_alt_vip_common_video_packet_empty {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_video_packet_empty.sv          $root_rel_path/common_hdl
}

proc add_alt_vip_common_latency_1_to_latency_0 {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_video_packet_decode/src_hdl/alt_vip_common_latency_1_to_latency_0.sv      $root_rel_path/common_hdl/
}

proc add_alt_vip_common_latency_0_to_latency_1 {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_latency_0_to_latency_1.sv      $root_rel_path/common_hdl
}

proc add_alt_vip_common_fifo2_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_fifo2/src_hdl/alt_vip_common_fifo2.sv                                     $root_rel_path/common_hdl
    add_static_sdc_file   modules/alt_vip_common_fifo2/src_hdl/alt_vip_common_fifo2.sdc                                    $root_rel_path/common_hdl
}

proc add_alt_vip_common_generic_step_count_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_generic_step_count/src_hdl/alt_vip_common_generic_step_count.v            $root_rel_path/common_hdl
}

proc add_alt_vip_common_fifo_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_fifo/src_hdl/alt_vip_common_fifo.v                                        $root_rel_path/common_hdl
    add_static_sdc_file   modules/alt_vip_common_fifo/src_hdl/alt_vip_common_fifo.sdc                                      $root_rel_path/common_hdl
}

proc add_alt_vip_common_to_binary_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_to_binary/src_hdl/alt_vip_common_to_binary.v                              $root_rel_path/common_hdl
}

proc add_alt_vip_common_trigger_sync_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_trigger_sync/src_hdl/alt_vip_common_trigger_sync.v                        $root_rel_path/common_hdl
}

proc add_alt_vip_common_sync_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_sync/src_hdl/alt_vip_common_sync.v                                        $root_rel_path/common_hdl
}

proc add_alt_vip_common_sync_generation_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_sync_generation/src_hdl/alt_vip_common_sync_generation.v                  $root_rel_path/common_hdl
}

proc add_alt_vip_common_frame_counter_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_frame_counter/src_hdl/alt_vip_common_frame_counter.v                      $root_rel_path/common_hdl
}

proc add_alt_vip_common_sample_counter_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_sample_counter/src_hdl/alt_vip_common_sample_counter.v                    $root_rel_path/common_hdl
}

proc add_alt_vip_common_clock_crossing_bridge_grey_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_clock_crossing_bridge_grey/src_hdl/alt_vip_common_clock_crossing_bridge_grey.sv $root_rel_path/common_hdl
}

proc add_alt_vip_common_delay_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_delay/src_hdl/alt_vip_common_delay.sv                                     $root_rel_path/common_hdl
}

proc add_alt_vip_common_qpel_buffer_control_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_qpel_buffer_control/src_hdl/alt_vip_common_qpel_buffer_control.sv         $root_rel_path/common_hdl
}

proc add_alt_vip_common_message_pipeline_stage_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_message_pipeline_stage/src_hdl/alt_vip_common_message_pipeline_stage.sv   $root_rel_path/common_hdl
}

proc add_alt_vip_common_rotate_mux_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_rotate_mux/src_hdl/alt_vip_common_rotate_mux.sv                           $root_rel_path/common_hdl
}

proc add_alt_vip_common_shift_mux_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_shift_mux/src_hdl/alt_vip_common_shift_mux.sv                             $root_rel_path/common_hdl
}

proc add_alt_vip_common_onehot_to_binary_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_onehot_to_binary/src_hdl/alt_vip_common_onehot_to_binary.sv               $root_rel_path/common_hdl
}

proc add_alt_vip_common_cabac_binarise_egk_files {root_rel_path} {
   add_static_sv_file    modules/alt_vip_common_cabac_binarise_egk/src_hdl/alt_vip_common_cabac_binarise_egk.sv            $root_rel_path/common_hdl
}

proc add_alt_vip_common_sop_align_files {root_rel_path} {
    add_static_sv_file   modules/alt_vip_common_sop_align/src_hdl/alt_vip_common_sop_align.sv                              $root_rel_path/common_hdl
}

proc add_alt_vip_common_data_by_line_rearrange_files {root_rel_path} {
    add_static_ver_file   modules/alt_vip_common_data_by_line_rearrange/src_hdl/alt_vip_common_data_by_line_rearrange.sv   $root_rel_path/common_hdl
}

proc add_alt_vip_common_seq_par_convert_files {root_rel_path} {
    add_static_sv_file    modules/alt_vip_common_seq_par_convert/src_hdl/alt_vip_common_seq_par_convert.sv                 $root_rel_path/common_hdl
}

proc add_alt_vip_common_scaler_edge_detect_files {root_rel_path} {
   add_static_sv_file    modules/alt_vip_common_scaler_edge_detect/src_hdl/alt_vip_common_scaler_edge_detect.sv            $root_rel_path/common_hdl
}

proc add_alt_vip_common_pip_bunch_files {root_rel_path} {
   add_static_sv_file    modules/alt_vip_common_pip_bunch/src_hdl/alt_vip_common_pip_bunch.sv                              $root_rel_path/common_hdl
}

proc add_alt_vip_common_pip_merge_files {root_rel_path} {
   add_static_sv_file    modules/alt_vip_common_pip_merge/src_hdl/alt_vip_common_pip_merge.sv                              $root_rel_path/common_hdl
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Shared files (to be deprecated)                                                              --
# -- Convention: use add_$modulename_files                                                        --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc add_alt_vip_common_control_packet_decoder_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_control_packet_decoder.v      $root_rel_path/common_hdl
}

proc add_alt_vip_common_unpack_data_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_unpack_data.v                 $root_rel_path/common_hdl
}

proc add_alt_vip_common_stream_input_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_stream_input.v                $root_rel_path/common_hdl
}

proc add_alt_vip_common_stream_output_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_stream_output.v               $root_rel_path/common_hdl
}

proc add_alt_vip_common_avalon_mm_master_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_avalon_mm_master.v            $root_rel_path/common_hdl
}

proc add_alt_vip_common_avalon_mm_slave_files {root_rel_path} {
    add_static_ver_file   alt_vip_common_avalon_mm_slave.v             $root_rel_path/common_hdl
}

proc add_avalon_mm_bursting_master_component_files {root_rel_path} {
    set       path        modules/alt_vip_common_avalon_mm_bursting_master_fifo
    add_static_vhdl_file  $path/alt_vip_common_package.vhd                            $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_avalon_mm_bursting_master_fifo.vhd     $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_pulling_width_adapter.vhd              $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_general_fifo.vhd                       $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_fifo_usedw_calculator.vhd              $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_gray_clock_crosser.vhd                 $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_std_logic_vector_delay.vhd             $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_one_bit_delay.vhd                      $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_logic_fifo.vhd                         $root_rel_path/common_hdl
    add_static_vhdl_file  $path/alt_vip_common_ram_fifo.vhd                           $root_rel_path/common_hdl
}


