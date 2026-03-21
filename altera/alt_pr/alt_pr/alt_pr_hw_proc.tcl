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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Altera Program License Subscription
# Agreement, Altera MegaCore Function License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Altera and sold by
# Altera or its authorized distributors.  Please refer to the applicable
# agreement for further details.

# +-----------------------------------
# |
# | $Header: //acds/rel/18.1std/ip/alt_pr/alt_pr/alt_pr_hw_proc.tcl#1 $
# |
# +-----------------------------------

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaboration_callback {} {

	# edcrc osc divisor setting only available for internal host
	set is_internal_host [get_parameter_value PR_INTERNAL_HOST]
	set_parameter_property EDCRC_OSC_DIVIDER ENABLED $is_internal_host

    # 1) ext_host_target_device_family setting only available for external host
	# 2) prpof id check UI option only applicable for external host
	#    always enable prpof id check feature for internal host
	set prpof_id_check_ui [get_parameter_value ENABLE_PRPOF_ID_CHECK_UI]
	if {$is_internal_host == "false"} {
		set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY ENABLED true
        set_parameter_property ENABLE_PRPOF_ID_CHECK_UI ENABLED true
		set_parameter_value ENABLE_PRPOF_ID_CHECK $prpof_id_check_ui
	} else {
		set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY ENABLED false
        set_parameter_property ENABLE_PRPOF_ID_CHECK_UI ENABLED false
		set_parameter_value ENABLE_PRPOF_ID_CHECK 1
	}

	# prpof id value only applicable if external host and prpof id check enabled
	if {($is_internal_host == "false") && ($prpof_id_check_ui == "true")} {
		set_parameter_property EXT_HOST_PRPOF_ID ENABLED true
	} else {
		set_parameter_property EXT_HOST_PRPOF_ID ENABLED false
	}

	# PR megafunction is available for all devices when used as external host
	# however, internal host only available for devices that support PR
    set device_family [get_parameter_value DEVICE_FAMILY]
    set ext_host_target_device_family [get_parameter_value EXT_HOST_TARGET_DEVICE_FAMILY]
	if {$is_internal_host == "true"} {
        if {!(($device_family == "Stratix V") || ($device_family == "Arria V GZ") || ($device_family == "Arria 10"))} {
            set skip_dev_check [get_quartus_ini "enable_alt_pr_instantiation"]
            if {!($skip_dev_check)} {
                send_message error "Partial Reconfiguration megafunction is not supported for the specified device family when used as Internal Host."
            }
        }
    }

    # V-series devices support PR_DATA x16 only
    # Arria 10 supports PR_DATA x1, x8, x16, and x32
    if {$is_internal_host == true} {
        set effective_device_family $device_family
    } else {
        set effective_device_family $ext_host_target_device_family
    }
    set st_mm_input_data_width [get_parameter_value DATA_WIDTH_INDEX]
    set enable_jtag [get_parameter_value ENABLE_JTAG]
    set enable_enhanced_decompression [get_parameter_value ENABLE_ENHANCED_DECOMPRESSION]

    # Compute `CB_DATA_WIDTH`.
    if {$effective_device_family == "Arria 10"} {
        set_parameter_value CB_DATA_WIDTH $st_mm_input_data_width
        if {$enable_jtag == false && $enable_enhanced_decompression == false} {
            if {$st_mm_input_data_width == 2 || $st_mm_input_data_width == 4} {
                set_parameter_value CB_DATA_WIDTH 8
            }
        } else {
        	# Either JTAG or enhanced decompression is enabled, a minimum CB
        	# data width of 16 needed. This is because:
        	#
        	# * JTAG input path supports a data width of 16 only.
        	# * Enhanced decompressor supports data widths of 16 and 32 only.
            if {$st_mm_input_data_width < 16} {
                set_parameter_value CB_DATA_WIDTH 16
            }

            # TODO Remove this workaround. Because the enhanced decompressor
            # actually doesn't support a width of 32 yet:
            if {$enable_enhanced_decompression == true} {
                set_parameter_value CB_DATA_WIDTH 16
            }
        }
		
		# Disable enhanced decompression in 16.1
		if {$enable_enhanced_decompression == true} {
			send_message error "Enhanced decompression is not currently supported with Arria 10."
		}
		
    } else {
        set_parameter_value CB_DATA_WIDTH 16
    }

    if {$effective_device_family == "Arria 10"} {
        # NF's 32-bit CB data accepts valid data that takes up 1, 8 or 16 of its
        # LSBs only, but this is not true for the enhanced decompressor.
        #
        # We should turn off data packing when it's possible though, to have a
        # smaller area. We can disable data packing whenever enhanced
        # decompression is not needed.
        set_parameter_value ENABLE_DATA_PACKING $enable_enhanced_decompression
    } else {
        set_parameter_value ENABLE_DATA_PACKING true
    }

    if {$effective_device_family == "Arria 10"} {
		set_parameter_property GENERATE_SDC VISIBLE true
    } else {
		set_parameter_property GENERATE_SDC VISIBLE false
    }
           

	
    set is_avmm_interface [get_parameter_value ENABLE_AVMM_SLAVE]

	if {$is_avmm_interface && !($st_mm_input_data_width == 16 || $st_mm_input_data_width == 32)} {
		send_message error "Only 16-bit and 32-bit data widths are supported for the Avalon-MM slave interface."
	}

	# +-----------------------------------
	# | UI Interface
	# +-----------------------------------

	#clk port
	set CLK_INTERFACE "clk"
	add_interface $CLK_INTERFACE clock end
	add_interface_port $CLK_INTERFACE $CLK_INTERFACE clk Input 1

	#nreset port
	set NRESET_INTERFACE "nreset"
	add_interface $NRESET_INTERFACE reset end
	set_interface_property $NRESET_INTERFACE associatedClock clk
	add_interface_port $NRESET_INTERFACE $NRESET_INTERFACE reset_n Input 1

	# conduit input
	add_interface pr_start conduit end
	add_interface_port pr_start pr_start pr_start Input 1
	add_interface double_pr conduit end
	add_interface_port double_pr double_pr double_pr Input 1

	# conduit output
	# freeze signal always available
	add_interface freeze conduit start
	add_interface_port freeze freeze freeze Output 1
	set_interface_property freeze ENABLED true
	add_interface status conduit start
	add_interface_port status status status Output 3

	# dedicated input
	add_interface pr_ready_pin conduit end
	add_interface_port pr_ready_pin pr_ready_pin pr_ready_pin Input 1
	add_interface pr_done_pin conduit end
	add_interface_port pr_done_pin pr_done_pin pr_done_pin Input 1
	add_interface pr_error_pin conduit end
	add_interface_port pr_error_pin pr_error_pin pr_error_pin Input 1
	add_interface crc_error_pin conduit end
	add_interface_port crc_error_pin crc_error_pin crc_error_pin Input 1

	# dedicated output
	add_interface pr_request_pin conduit start
	add_interface_port pr_request_pin pr_request_pin pr_request_pin Output 1
	add_interface pr_clk_pin conduit start
	add_interface_port pr_clk_pin pr_clk_pin pr_clk_pin Output 1
	add_interface pr_data_pin conduit start
	add_interface_port pr_data_pin pr_data_pin pr_data_pin Output CB_DATA_WIDTH

	# Avalon-ST sink interface
	add_interface avst_sink avalon_streaming sink
	set_interface_property avst_sink associatedClock {clk}
	set_interface_property avst_sink associatedReset {nreset}
	set_interface_property avst_sink symbolsPerBeat {1}
	set_interface_property avst_sink dataBitsPerSymbol $st_mm_input_data_width
	set_interface_property avst_sink readyLatency {0}
	set_interface_property avst_sink maxChannel {0}

	add_interface_port avst_sink data data Input DATA_WIDTH_INDEX
	add_interface_port avst_sink data_valid valid Input 1
	add_interface_port avst_sink data_ready ready Output 1

	# Avalon-MM slave interface
	add_interface avmm_slave avalon slave
	set_interface_property avmm_slave addressUnits {WORDS}
	set_interface_property avmm_slave associatedClock {clk}
	set_interface_property avmm_slave associatedReset {nreset}
	set_interface_property avmm_slave bitsPerSymbol {8}
	set_interface_property avmm_slave burstOnBurstBoundariesOnly {0}
	set_interface_property avmm_slave burstcountUnits {WORDS}
	set_interface_property avmm_slave constantBurstBehavior {0}
	set_interface_property avmm_slave holdTime {0}
	set_interface_property avmm_slave linewrapBursts {0}
	set_interface_property avmm_slave maximumPendingReadTransactions {0}
	set_interface_property avmm_slave readLatency {0}
	set_interface_property avmm_slave readWaitTime {0}
	set_interface_property avmm_slave registerIncomingSignals {0}
	set_interface_property avmm_slave registerOutgoingSignals {0}
	set_interface_property avmm_slave setupTime {0}
	set_interface_property avmm_slave timingUnits {Cycles}
	set_interface_property avmm_slave writeLatency {0}
	set_interface_property avmm_slave writeWaitStates {0}
	set_interface_property avmm_slave writeWaitTime {0}

	add_interface_port avmm_slave avmm_slave_address address Input 1
	add_interface_port avmm_slave avmm_slave_read read Input 1
	add_interface_port avmm_slave avmm_slave_writedata writedata Input DATA_WIDTH_INDEX
	add_interface_port avmm_slave avmm_slave_write write Input 1
	add_interface_port avmm_slave avmm_slave_readdata readdata Output DATA_WIDTH_INDEX
	add_interface_port avmm_slave avmm_slave_waitrequest waitrequest Output 1

	# switch between Avalon-MM interface or Avalon-ST/Conduit interface
	if {$is_avmm_interface == "true"} {
		set_interface_property avmm_slave ENABLED true
		set_interface_property avst_sink ENABLED false

		set_interface_property pr_start ENABLED false
		set_interface_property double_pr ENABLED false
		set_interface_property status ENABLED false
	} else {
		set_interface_property avmm_slave ENABLED false
		set_interface_property avst_sink ENABLED true

		set_interface_property pr_start ENABLED true
		set_interface_property status ENABLED true
        
		if {$effective_device_family == "Arria 10"} {
		    set_interface_property double_pr ENABLED false
		} else {
		    set_interface_property double_pr ENABLED true
		}
    }
    
    if {$effective_device_family == "Arria 10"} {
        if {$st_mm_input_data_width == 32} {
            send_message info "Enable enhanced decompression will change the CDRATIO requirement. Please check the CDRATIO requirement and select the value as refer to Notes for CDRATIO."
        }
        
        if {$st_mm_input_data_width == 32 && $enable_enhanced_decompression == false} {
            set_parameter_property CDRATIO ALLOWED_RANGES {1 4 8}
            
            set_display_item_property CDRATIO_INFORMATION TEXT \
                "<html><font color=\"blue\">&nbsp&nbsp Notes for CDRATIO:&nbsp Select 1 for plain PR data, 4 for encrypted PR data, or 8 for compressed PR data.</font></html>"
                
        } else {
            set_parameter_property CDRATIO ALLOWED_RANGES {1 2 4}
            
            set_display_item_property CDRATIO_INFORMATION TEXT \
                    "<html><font color=\"blue\">&nbsp&nbsp Notes for CDRATIO:&nbsp Select 1 for plain PR data, 2 for encrypted PR data, or 4 for compressed PR data.</font></html>"
            
        }
		
    } else {
        set_parameter_property CDRATIO ALLOWED_RANGES {1 2 4}
        
        set_display_item_property CDRATIO_INFORMATION TEXT \
            "<html><font color=\"blue\">&nbsp&nbsp Notes for Clock-to-Data Ratio:&nbsp Select 1 for plain PR data, 2 for encrypted PR data, or 4 for compressed PR data (with or without encryption).</font></html>"
    }
    
	if {$enable_enhanced_decompression && [get_parameter_value CDRATIO] == 2} {
		send_message error "A CDRATIO of 2 is not supported when enhanced decompression is enabled."
	}

	set_parameter_property INSTANTIATE_PR_BLOCK ENABLED $is_internal_host
	set_parameter_property INSTANTIATE_CRC_BLOCK ENABLED $is_internal_host

	set instantiate_pr_block [expr $is_internal_host && [get_parameter_value INSTANTIATE_PR_BLOCK]]
	set use_external_pr_block [expr !$instantiate_pr_block]
	set_interface_property pr_clk_pin ENABLED $use_external_pr_block
	set_interface_property pr_data_pin ENABLED $use_external_pr_block
	set_interface_property pr_done_pin ENABLED $use_external_pr_block
	set_interface_property pr_error_pin ENABLED $use_external_pr_block
	set_interface_property pr_ready_pin ENABLED $use_external_pr_block
	set_interface_property pr_request_pin ENABLED $use_external_pr_block

    set instantiate_crc_block [expr $is_internal_host && [get_parameter_value INSTANTIATE_CRC_BLOCK]]
	set use_external_crc_block [expr !$instantiate_crc_block]
	set_interface_property crc_error_pin ENABLED $use_external_crc_block

	# `ENABLE_INTERRUPT` is not an option if the Avalon-MM interface isn't used.
	set_parameter_property ENABLE_INTERRUPT ENABLED $is_avmm_interface

	# Add the `interrupt` interface.
	add_interface interrupt interrupt sender
	set_interface_property interrupt associatedClock clk
	set_interface_property interrupt associatedReset nreset
	set_interface_property interrupt associatedAddressablePoint avmm_slave

	add_interface_port interrupt irq irq output 1

	# Terminate the `interrupt` interface when it isn't used.
	set_interface_property interrupt ENABLED [expr $is_avmm_interface && [get_parameter_value ENABLE_INTERRUPT]]
}

proc generate_synth {entityname} {
	set device_family [get_parameter_value DEVICE_FAMILY]

	send_message info "generating top-level entity $entityname"
    
	add_fileset_file alt_pr.v VERILOG PATH alt_pr.v
	add_fileset_file ../rtl/alt_pr_bitstream_host.v VERILOG PATH ../rtl/alt_pr_bitstream_host.v
	add_fileset_file ../rtl/alt_pr_bitstream_controller_v1.v VERILOG PATH ../rtl/alt_pr_bitstream_controller_v1.v
	add_fileset_file ../rtl/alt_pr_bitstream_controller_v2.v VERILOG PATH ../rtl/alt_pr_bitstream_controller_v2.v
	add_fileset_file ../rtl/alt_pr_cb_host.v VERILOG PATH ../rtl/alt_pr_cb_host.v
	add_fileset_file ../rtl/alt_pr_cb_interface.v VERILOG PATH ../rtl/alt_pr_cb_interface.v
	add_fileset_file ../rtl/alt_pr_cb_controller_v1.v VERILOG PATH ../rtl/alt_pr_cb_controller_v1.v
	add_fileset_file ../rtl/alt_pr_cb_controller_v2.v VERILOG PATH ../rtl/alt_pr_cb_controller_v2.v
	add_fileset_file ../rtl/alt_pr_mux.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_mux.sv
	add_fileset_file ../rtl/alt_pr_jtag_interface.v VERILOG PATH ../rtl/alt_pr_jtag_interface.v
	add_fileset_file ../rtl/alt_pr_width_adapter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_width_adapter.sv
	add_fileset_file ../rtl/alt_pr_bitstream_compatibility_checker_int_host.v VERILOG PATH ../rtl/alt_pr_bitstream_compatibility_checker_int_host.v
	add_fileset_file ../rtl/alt_pr_bitstream_compatibility_checker_ext_host.v VERILOG PATH ../rtl/alt_pr_bitstream_compatibility_checker_ext_host.v
    add_fileset_file ../rtl/alt_pr_down_converter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_down_converter.sv
    add_fileset_file ../rtl/alt_pr_fifo.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_fifo.sv
    add_fileset_file ../rtl/alt_pr_up_converter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_up_converter.sv
    add_fileset_file ../rtl/alt_pr_bitstream_decoder.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_bitstream_decoder.sv
    add_fileset_file ../rtl/alt_pr_enhanced_compression_magic_words_decoder_and_suppressor.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_enhanced_compression_magic_words_decoder_and_suppressor.sv
    add_fileset_file ../rtl/alt_pr_enhanced_decompressor.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_enhanced_decompressor.sv
    add_fileset_file ../rtl/alt_pr_magic_fifo.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_magic_fifo.sv
    add_fileset_file ../rtl/alt_pr_data.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_data.sv
    add_fileset_file ../rtl/alt_pr_clk_mux.v VERILOG PATH ../rtl/alt_pr_clk_mux.v
	
    if {($device_family == "Arria 10") && ([get_parameter_value GENERATE_SDC] == "true")} {
		add_fileset_file ../rtl/alt_pr.sdc SDC PATH ../rtl/alt_pr.sdc
	}	
}


proc generate_sim {entityname} {
	set device_family [get_parameter_value DEVICE_FAMILY]
	
	send_message info "generating top-level entity $entityname"
    if {$device_family == "Arria 10"} {
		add_fileset_file alt_pr.v VERILOG PATH alt_pr.v
		add_fileset_file ../rtl/alt_pr_bitstream_host.v VERILOG PATH ../rtl/alt_pr_bitstream_host.v
		add_fileset_file ../rtl/alt_pr_bitstream_controller_v1.v VERILOG PATH ../rtl/alt_pr_bitstream_controller_v1.v
		add_fileset_file ../rtl/alt_pr_bitstream_controller_v2.v VERILOG PATH ../rtl/alt_pr_bitstream_controller_v2.v
		add_fileset_file ../rtl/alt_pr_cb_host.v VERILOG PATH ../rtl/alt_pr_cb_host.v
		add_fileset_file ../rtl/alt_pr_cb_interface.v VERILOG PATH ../rtl/alt_pr_cb_interface.v
		add_fileset_file ../rtl/alt_pr_cb_controller_v1.v VERILOG PATH ../rtl/alt_pr_cb_controller_v1.v
		add_fileset_file ../rtl/alt_pr_cb_controller_v2.v VERILOG PATH ../rtl/alt_pr_cb_controller_v2.v
		add_fileset_file ../rtl/alt_pr_mux.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_mux.sv
		add_fileset_file ../rtl/alt_pr_jtag_interface.v VERILOG PATH ../rtl/alt_pr_jtag_interface.v
		add_fileset_file ../rtl/alt_pr_width_adapter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_width_adapter.sv
		add_fileset_file ../rtl/alt_pr_bitstream_compatibility_checker_int_host.v VERILOG PATH ../rtl/alt_pr_bitstream_compatibility_checker_int_host.v
		add_fileset_file ../rtl/alt_pr_bitstream_compatibility_checker_ext_host.v VERILOG PATH ../rtl/alt_pr_bitstream_compatibility_checker_ext_host.v
		add_fileset_file ../rtl/alt_pr_down_converter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_down_converter.sv
		add_fileset_file ../rtl/alt_pr_fifo.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_fifo.sv
		add_fileset_file ../rtl/alt_pr_up_converter.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_up_converter.sv
		add_fileset_file ../rtl/alt_pr_bitstream_decoder.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_bitstream_decoder.sv
		add_fileset_file ../rtl/alt_pr_enhanced_compression_magic_words_decoder_and_suppressor.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_enhanced_compression_magic_words_decoder_and_suppressor.sv
		add_fileset_file ../rtl/alt_pr_enhanced_decompressor.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_enhanced_decompressor.sv
		add_fileset_file ../rtl/alt_pr_magic_fifo.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_magic_fifo.sv
		add_fileset_file ../rtl/alt_pr_data.sv SYSTEM_VERILOG PATH ../rtl/alt_pr_data.sv
		add_fileset_file ../rtl/alt_pr_clk_mux.v VERILOG PATH ../rtl/alt_pr_clk_mux.v
	} else {
		add_fileset_file alt_pr.v VERILOG PATH alt_pr_sim.v
	}
}