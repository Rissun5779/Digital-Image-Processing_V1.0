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
# | $Header: //acds/rel/18.1std/ip/altera_parallel_flash_loader/altera_parallel_flash_loader_ui_settings.tcl#1 $
# | 
# +-----------------------------------

source altera_parallel_flash_loader_csv_reader.tcl
source altera_parallel_flash_loader_common.tcl
source altera_parallel_flash_loader_msgs.tcl


proc general_parameters_procedure {flag}	{
    global	PFL_CFI_FLASH
    global	PFL_ASC_FLASH
    global	PFL_QSPI_FLASH
    global	PFL_NAND_FLASH

    # --- Definitions --- #
    set	page_access_time			3
    set Family_Cycloniii			"false"
    
    set	pfl_fpga_data_width			1
    set pfl_flash_data_width		16
    set	pfl_page_select_width		3
    set	pfl_num_flash				1
    set pfl_qflash_byte_size		0
    set pfl_qflash_mfc_type			""
    set pfl_nflash_mfc_type			""

    set	nand_ecc					"false"
    set	nrb_addr					0
    set	nand_size					0
    
    set	operating_modes_cfg			0
    set	operating_modes_pgm			1
    
    set	is_cfi_nand_flash			"false"
    set is_asc_qspi_flash			"false"
    set	is_cfi_flash				"false"
    set is_asc_flash				"false"
    set is_qspi_flash				"false"
    set	is_nand_flash				"false"
    set	is_cfg_mdoe					"false"

    set flash_nreset_port_gen		"false"
    set	reconfigure					"false"
    set	rsu_watchdog_enable			"false"
    set cfi_burst					"false"
    set	qflash_extra_addr_byte		0
    set	access_time					100
        
    set TARGETTED_FLASH				[get_parameter_value 			flash_type_combo]
    
    # --- Checks Targeted Flash device ---#
    if { ([string match -nocase $TARGETTED_FLASH $PFL_CFI_FLASH] == 1) ||
            ([string match -nocase $TARGETTED_FLASH $PFL_NAND_FLASH] == 1) } {
        set	is_cfi_nand_flash	"true"
        if { ([string match -nocase $TARGETTED_FLASH $PFL_CFI_FLASH] == 1) } {
            set	is_cfi_flash	"true"
        } elseif { ([string match -nocase $TARGETTED_FLASH $PFL_NAND_FLASH] == 1) } {
            set	is_nand_flash	"true"
        }
    } elseif { ([string match -nocase $TARGETTED_FLASH $PFL_ASC_FLASH] == 1) ||
            ([string match -nocase $TARGETTED_FLASH $PFL_QSPI_FLASH] == 1) } {
        set	is_asc_qspi_flash	"true"
        if { ([string match -nocase $TARGETTED_FLASH $PFL_ASC_FLASH] == 1) } {
            set	is_asc_flash	"true"
        } elseif { ([string match -nocase $TARGETTED_FLASH $PFL_QSPI_FLASH] == 1) } {
            set	is_qspi_flash	"true"
        }
    }

    if { $is_cfi_flash } {
        set data_width_combo		flash_data_width_combo
        set	device_combo			flash_device_combo
        set	n_flash_combo			num_flash_combo
        set	access_time				flash_access_time
    } elseif { $is_nand_flash } {
        set data_width_combo		nflash_data_width_combo
        set	device_combo			nflash_device_combo
        set	n_flash_combo			num_nflash_combo
        set	access_time				nflash_access_time
    } elseif { $is_asc_flash } {
        set	device_combo			qflash_size_combo
        set	n_flash_combo			num_qflash_combo
    } elseif { $is_qspi_flash } {
        set	device_combo			qspi_size_combo
        set	n_flash_combo			num_qflash_combo
    }
    
    # Gets parameter value from UI
    set get_device_setting				[get_parameter_value 			INTENDED_DEVICE_FAMILY]
    set operating_mode 					[get_parameter_value 			operating_mode_combo]
    set	flash_device					[get_parameter_value 			$device_combo]
    set	pfl_num_flash					[get_parameter_value 			$n_flash_combo]
    set	flash_nreset					[get_parameter_value			flash_nreset_check]	
    set	qflash_mfc						[get_parameter_value			qflash_mfc_combo]
    set qflash_fast_speed				[get_parameter_value			QFLASH_FAST_SPEED]
    set	pfl_nflash_mfc					[get_parameter_value			nflash_mfc_combo]
    set	nrb_addr						[get_parameter_value			nflash_rb_edit]
    set	nand_ecc						[get_parameter_value			FLASH_ECC_CHECKBOX]
    set	enhanced_flash_prog_str			[get_parameter_value			enhanced_flash_programming_combo]
    set	fifo_size						[get_parameter_value			fifo_size_combo]
    set	get_disable_crc_check			[get_parameter_value			disable_crc_check]
    set	clock_frequency					[get_parameter_value			clock_frequency]
    set option_bit_addr					[get_parameter_value			option_bit_address]
    set	fpga_conf_scheme				[get_parameter_value			fpga_conf_scheme_combo]
    set	safe_mode						[get_parameter_value			safe_mode_combo]
    set	safe_revert_addr				[get_parameter_value			safe_mode_revert_edit]
    set reconfigure						[get_parameter_value			reconfigure_checkbox]
    set rsu_watchdog_enable				[get_parameter_value			rsu_watchdog_checkbox]
    set	watchdog_counter				[get_parameter_value			rsu_watchdog_counter_edit]
    set	dclk_divisor					[get_parameter_value			dclk_divisor_combo]
    set	read_mode						[get_parameter_value			read_modes_combo]
    
    if { $is_cfi_flash || $is_nand_flash } {
        set data_width 					[get_parameter_value 			$data_width_combo]
        set	pfl_flash_data_width		[get_value_based_on_row_value	"FLASH_DATA_WIDTH_TABLE"						$data_width			"HDL_PARAMETER"]
        set	access_time					[get_parameter_value			$access_time]
    }
    
    # Gets variable from tables
    set operating_modes_pgm				[get_value_based_on_row_value	"OPERATING_MODES_TABLE"							$operating_mode		"pgm"]
    set operating_modes_cfg				[get_value_based_on_row_value	"OPERATING_MODES_TABLE"							$operating_mode		"cfg"]
    set	flash_type_param				[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_FLASH_TYPE"				$TARGETTED_FLASH	"HDL_PARAMETER"]
    set	pfl_nflash_mfc_type				[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_NFLASH_MFC_TABLE"		$pfl_nflash_mfc		"mfc_type"]
    set	qflash_byte_meg_size			[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_QFLASH_DEVICE_TABLE"		$flash_device		"byte_meg_size"]
    set	safe_mode_halt					[get_value_based_on_row_value	"SAFE_MODE_TABLE"								$safe_mode			"halt"]
    set	safe_mode_retry					[get_value_based_on_row_value	"SAFE_MODE_TABLE"								$safe_mode			"retry"]
    set	safe_mode_revert				[get_value_based_on_row_value	"SAFE_MODE_TABLE"								$safe_mode			"revert"]
    set	read_normal_mode				[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"normal_mode"]
    set	flash_family_intel				[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"burst_mode"]
    set	spansion_page_mode				[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"page_mode"]
    set	mt28ew_page_mode				[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"mt28ew_page_mode"]
    set	flash_family_numonyx			[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"burst_mode_numonyx"]
    set	latency_count					[get_value_based_on_row_value	"READ_MODES_TABLE"								$read_mode			"latency_count"]

    set	pfl_address_width				[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		0					"address_width"]	
    set	fpp16	[string map {"\"" ""}	[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_CONF_SCHEME_TABLE"		2					"ALLOWED_VALUES"]]
    set	fpp32	[string map {"\"" ""} 	[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_CONF_SCHEME_TABLE"		3					"ALLOWED_VALUES"]]
    
    # --- Check device family support --- #
    set cycloneiii_family_list		{"Cyclone IV GX" "Cyclone IV E" "Cyclone 10 LP"}
    if {[check_device_family_equivalence $get_device_setting $cycloneiii_family_list]} {
        if { ([string match -nocase [get_quartus_ini_string	PGM_PFL_ALLOW_CONF	"OFF"] "OFF"] == 1) } {
            set Family_Cycloniii	"true"
            
            if { $is_cfi_flash } {
                set	operating_modes_pgm		1
                set	operating_modes_cfg		0
            }
        }
    }    
        
    # +-----------------------------------
    # --- Flash Interface Tab --- #
    # +-----------------------------------
    if { $is_cfi_nand_flash } {
        set pfl_address_width			[calculate_pfl_addr_width		$flash_device	$pfl_flash_data_width]
        
        if { $is_nand_flash } {
            set	nand_size			[expr	[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		$flash_device		"flash_byte_size"]]
            
            check_for_nand_error			$nand_size
                
            set nand_reserved_size			[calculate_nand_reserved_size	$nand_size]
            set nand_guarded_size			[calculate_nand_guarded_size	$nand_size]
            
            set max_range					[format %08X $nand_reserved_size]
            set max_size					[format %08X $nand_guarded_size]
        }
        
    } elseif { $is_asc_qspi_flash } {
        
        if { $is_asc_flash } {
            # Fixed manufacturer to Altera
            set pfl_qflash_mfc_type		[string map {"\"" ""}	[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_QFLASH_MFC_TABLE"		0					"mfc_type"]	]
        } elseif { $is_qspi_flash } {
            set pfl_qflash_mfc_type		[string map {"\"" ""}	[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_QFLASH_MFC_TABLE"		$qflash_mfc			"mfc_type"]	]
        }
        set	pfl_qflash_byte_size			[expr	$qflash_byte_meg_size * 1024 * 1024]	

        if { $pfl_qflash_byte_size	> [expr	16<<20] } {
            set	qflash_extra_addr_byte		1
        } else {
            set	qflash_extra_addr_byte		0
        }
    } 

    # +-----------------------------------
    # --- Flash Programming Tab --- #
    # +-----------------------------------
    if { $operating_modes_pgm == 1 } {
    
        if { [string match -nocase $enhanced_flash_prog_str "Area"] == 1 } {
            set	enhanced_flash_programming	0
        } else {
            # Speed
            set	enhanced_flash_programming	1
        }
        
        if { $get_disable_crc_check } {
            set	disable_crc_check_value	0
        } else {
            set	disable_crc_check_value	1
        }
        
    } elseif  { $operating_modes_pgm == 0 } {
        set	enhanced_flash_programming	0
    }	

    # +-----------------------------------
    # --- FPGA Configuration Tab --- #
    # +-----------------------------------
    if { $operating_modes_cfg == 1 } {
        set	qspi_data_delay				0
        set	delay_count					1
        set	flash_family_spansion		0
        
        set	burst_timing				[get_quartus_ini_string			PGM_PFL_BURST_MODE_CLK_TO_OUTPUT_VALID_NS	22]
        set	static_wait_timing			[get_quartus_ini_string			PGM_PFL_FLASH_STATIC_WAIT_US				100]

        set clk_freq					[expr	int(ceil($clock_frequency))]
        
        # get the pulse width
        set	clk_div						[expr	int(ceil($clock_frequency * $access_time / 1000.0)) - 1]
        set	burst_clk_count				[expr	int(ceil($clock_frequency * $burst_timing / 1000.00))]
        set	static_wait_count			[expr	int(ceil($clock_frequency * $static_wait_timing))]

        for {set i 0} {$i < 4} {incr i} {
            set	pfl_conf_scheme		[string map {"\"" ""}	[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_CONF_SCHEME_TABLE"	$i	"ALLOWED_VALUES"]]
            if { [string match -nocase $fpga_conf_scheme $pfl_conf_scheme] == 1 } {
                break
            }
        }
        
        if { $i == 0 } {
            set width	1
        } elseif { $i == 4 } {
            set width	8
        } else {
            set width	[expr	1<<(2+$i)]
        }
        set pfl_fpga_data_width	$width
                        
        if { $flash_family_intel == 1 || $flash_family_numonyx == 1 } {
            set	read_burst_mode		1
        } else {
            set	read_burst_mode		0
        }
        
        if { $read_burst_mode == 1 && $is_cfi_flash } {
            set		cfi_burst			"true"
        }

        if { $burst_clk_count > 2 } {
            set	burst_clk_count		1
        } else {
            set	burst_clk_count		0
        }

        if { $is_asc_qspi_flash } {
            # if this is QSPI, recalculate whether we need extra burst clock
            set	burst_clk_count			0
            if { $pfl_qflash_mfc_type eq "ALTERA" ||
                    $pfl_qflash_mfc_type eq "MICRON" ||
                    $pfl_qflash_mfc_type eq "NUMONYX" } {
                if { $clk_freq > 100 } {
                    # Maximum we only support 100MHz
                    set	burst_clk_count		1
                }
            } elseif { $pfl_qflash_mfc_type eq "MACRONIX" } {
                if { ($qflash_fast_speed == 1) &&
                        ($clk_freq > 125) } {
                    # Maximum we only support 125MHz
                    set	burst_clk_count		1
                } elseif { ($qflash_fast_speed == 0) &&
                        ($clk_freq > 80) } {
                    # Maximum we only support 80MHz
                    set	burst_clk_count		1
                }
            }
            
            if { $burst_clk_count == 0 } {
                set flash_data_width	[expr	$pfl_num_flash * 4 * $dclk_divisor]
                if { $flash_data_width > $pfl_fpga_data_width } {
                    set	burst_clk_count		1
                }
            }	
        }
        
        if { $burst_clk_count == 0 } {
            if { $clk_freq > 65 } {
                set	qspi_data_delay		[get_quartus_ini_string		PGM_PFL_QSPI_DATA_DELAY		24]
                set	delay_count			[get_quartus_ini_string		PGM_PFL_QSPI_DELAY_COUNT	6]
            }
        }
        
        if { $is_nand_flash } {
            # recalculating for NAND FLASH
            # 50ns
            set	clk_div						[expr	int(ceil($clock_frequency * 50 / 1000.0))]
        }		
        
        # to ensure that that clk div is at least one
        set	clk_div					[return_at_least_one	$clk_div] 
        
        # get page access time
        set	page_div				[expr	int(ceil($clock_frequency * $page_access_time / 100.0)) - 1]
        set	us_unit_counter		0
        
        if { $is_nand_flash } {
            # recalculating for NAND FLASH
            set page_div			[expr	int(ceil($clock_frequency * $access_time))]
            set	page_div			[expr	$page_div / $clk_div]
            set	us_unit_counter		[expr	$clk_freq / $clk_div]
        }
        
        # to ensure that the page_div is at least one
        set	page_div				[return_at_least_one	$page_div] 
        set	us_unit_counter			[return_at_least_one	$us_unit_counter] 
        
        set	user_mode_wait			[expr	int(ceil($clock_frequency  * 1500))]
        # get number of count
        set	flash_nreset_counter	[expr	int(ceil($clock_frequency  * 50))]
        # to ensure that that num_count is at least one
        set	flash_nreset_counter	[return_at_least_one	$flash_nreset_counter] 
        # get number of watchdog count
        set	rsu_watchdog_counter	[expr	int(ceil($watchdog_counter * $clock_frequency * 1000.0))]
        # to ensure that the count is at least one clock
        set	rsu_watchdog_counter	[return_at_least_one	$rsu_watchdog_counter] 	
        
        set	dclk_value					[calculate_dclk]
        
        set	is_fpp16_fpp32				0

        if { ($fpga_conf_scheme eq $fpp16) || ($fpga_conf_scheme eq $fpp32) } {
            set	is_fpp16_fpp32					1
        }

        set conf_wait_timer				[expr	{[log2	$user_mode_wait] + 2}]
        
        if { $conf_wait_timer <= 18} {
            set conf_wait_timer		18
        }
        
        check_for_fpga_conf_error	$pfl_flash_data_width	$pfl_address_width	$pfl_num_flash	$pfl_qflash_byte_size	$operating_modes_cfg
        
        set	is_cfg_mode		"true"
        if { $reconfigure } {
            set reconfigure_port			"true"
        } else {
            set reconfigure_port			"false"
        }
        if { $rsu_watchdog_enable } {
            set rsu_watchdog_enable_port	"true"
        } else {
            set rsu_watchdog_enable_port	"false"
        }
        
    } else {
        set read_burst_mode			0
        set is_cfg_mode						"false"
        set reconfigure_port				"false"
        set rsu_watchdog_enable_port		"false"
    }

    if { $is_cfi_flash } {
        if { ($read_burst_mode == 1 && $operating_modes_cfg == 1) ||
                $pfl_num_flash != 1} {
            set	flash_nreset			"false"
        } 
        
        if { $flash_nreset || $read_burst_mode } {
            set flash_nreset_port_gen	"true"
        }
        
    } elseif { $is_asc_flash } {
        set supported_flash_size		[get_value_based_on_row_num		"PARALLEL_FLASH_LOADER_QFLASH_MFC_TABLE"		0					"support_flash"]
        
    } elseif { $is_qspi_flash } {
        set supported_flash_size		[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_QFLASH_MFC_TABLE"		$qflash_mfc			"support_flash"]
        
    } elseif { $is_nand_flash } {
        set supported_flash_size			[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_NFLASH_MFC_TABLE"		$pfl_nflash_mfc		"support_flash"]	
    }       

    set		debug		[get_quartus_ini_string		PFL_ADDS_DEBUG_BUS		0]
      

    # +-----------------------------------
    # --- update ports in top level file via terp with regards to parameter changes --- #
    # +-----------------------------------
    if {$flag eq "rtl_file_gen"} {
    
        set this_dir      [ get_module_property MODULE_DIRECTORY ]
        set template_file [ file join $this_dir "altera_parallel_flash_loader.v.terp" ]
        set template    [ read [ open $template_file r ] ]
        
        set params(is_cfg_mode)                 $is_cfg_mode
        set params(reconfigure_port)            $reconfigure_port
        set params(rsu_watchdog_enable_port)    $rsu_watchdog_enable_port
        set params(is_cfi_flash)                $is_cfi_flash
        set params(is_nand_flash)               $is_nand_flash
        set params(is_cfi_nand_flash)           $is_cfi_nand_flash
        set params(cfi_burst)                   $cfi_burst
        set params(flash_nreset_port_gen)       $flash_nreset_port_gen
        set params(is_asc_qspi_flash)           $is_asc_qspi_flash
        set result          [ altera_terp $template params ]
        
        set output_file     [ create_temp_file altera_parallel_flash_loader.v ]
        set output_handle   [ open $output_file w ]
        
        puts $output_handle $result
        close $output_handle
        
        add_fileset_file altera_parallel_flash_loader.v VERILOG PATH ${output_file}
        
    } else {

        # --- Sets tab visibility ---#
        # Sets Flash Programming Tab visibility
        if { $operating_modes_pgm == 0 ||
                $is_asc_flash ||
                $is_qspi_flash ||
                $is_nand_flash } {
            set_display_item_property "Flash Programming"	VISIBLE	0
        } else {
            set_display_item_property "Flash Programming"	VISIBLE	1
        }
        
        # Sets FPGA Configuration Tab visibility
        if { $operating_modes_cfg == 0 } {
            set_display_item_property "FPGA Configuration"	VISIBLE	0
        } else {
            set_display_item_property "FPGA Configuration"	VISIBLE	1
        }
        
        # --- Operating mode--- #
        set_parameter_property				operating_mode_combo	ENABLED					1
        if { $is_cfi_flash } {
            if { $Family_Cycloniii } {
                set_parameter_property		operating_mode_combo	ENABLED					0
                if {$flag eq "ui_settings"} {
                    set_parameter_value		operating_mode_combo	"Flash Programming"
                }
            }
        }

        # +-----------------------------------
        # --- Flash Interface Tab --- #
        # +-----------------------------------
        if { $is_cfi_nand_flash } {
            if { $is_cfi_flash } {
                set_parameter_property			flash_access_time				VISIBLE			1
                set_parameter_property			flash_access_time				ENABLED			1
                set_parameter_property			nflash_access_time				VISIBLE			0
                set_parameter_property			read_modes_combo				ENABLED			1
                
            } elseif { $is_nand_flash } {
                set_parameter_property			flash_access_time				VISIBLE			0
                set_parameter_property			nflash_access_time				VISIBLE			1
                set_parameter_property			read_modes_combo				ENABLED			0
                set_parameter_property			num_nflash_combo				ENABLED			0
               
                set_display_item_property		"nrb_label1" 	TEXT	"Note: You must reserve $max_range byte memory for the selected NAND flash reserved block"
                set_display_item_property		"nrb_label2" 	TEXT	"Maximum selected NAND flash reserved block byte address is $max_size"
            }
            
        } elseif { $is_asc_qspi_flash } {
            set_parameter_property				flash_access_time				VISIBLE			1
            set_parameter_property				flash_access_time				ENABLED			0
            set_parameter_property				nflash_access_time				VISIBLE			0
            set_parameter_property				read_modes_combo				ENABLED			0

            if { $is_qspi_flash } {
                if { [string match -nocase $pfl_qflash_mfc_type "MACRONIX"] == 1 } {
                    set_parameter_property			QFLASH_FAST_SPEED			ENABLED			1
                } else {
                    set_parameter_property			QFLASH_FAST_SPEED			ENABLED			0				
                }
            }
        } 

        # +-----------------------------------
        # --- Flash Programming Tab --- #
        # +-----------------------------------
        if { $operating_modes_pgm == 1 } {
            set_parameter_property			enhanced_flash_programming_combo		ENABLED				1
            if { [string match -nocase $enhanced_flash_prog_str "Area"] == 1 } {
                set_parameter_property			fifo_size_combo						ENABLED				0
            } else {
                # Speed
                set_parameter_property			fifo_size_combo						ENABLED				1
            }
            
        } elseif  { $operating_modes_pgm == 0 } {
            set_parameter_property			enhanced_flash_programming_combo		ENABLED				0
            set_parameter_property			fifo_size_combo							ENABLED				0
        }	


        # +-----------------------------------
        # --- FPGA Configuration Tab --- #
        # +-----------------------------------
        if { $operating_modes_cfg == 1 } {
            
            set_display_item_property		"dclk_note" 	TEXT		"- Configuration DCLK frequency is $dclk_value MHz. All FPGAs being configured must support this frequency"
            
            set_display_item_property		"fpp_note"			VISIBLE				$is_fpp16_fpp32

            lassign		[update_decompression_control]				decompression_count	decompressor_string
            set_allowed_ranges	decompressor_combo					"PARALLEL_FLASH_LOADER_DECOMPRESSION_TABLE"		"ALLOWED_VALUES"		"decompressor_mode"
            
            if { $rsu_watchdog_enable } {
                set_parameter_property		rsu_watchdog_counter_edit		ENABLED		1
            } else {
                set_parameter_property		rsu_watchdog_counter_edit		ENABLED		0
            }		

            check_for_fpga_conf_error	$pfl_flash_data_width	$pfl_address_width	$pfl_num_flash	$pfl_qflash_byte_size	$operating_modes_cfg
        }


        # +-----------------------------------
        # --- update UI settings with regards to parameter changes --- #
        # +-----------------------------------	
        if {$flag eq "ui_settings"} {
            if { $is_cfi_flash } {
                if { ($read_burst_mode == 1 && $operating_modes_cfg == 1) ||
                        $pfl_num_flash != 1} {
                    set_parameter_value			flash_nreset_check		0
                    set_parameter_property		flash_nreset_check		ENABLED					0
                } else {
                    set_parameter_property		flash_nreset_check		ENABLED					1
                }
                
            } elseif { $is_asc_flash } {
                set_flash_allowed_ranges		qflash_size_combo				"PARALLEL_FLASH_LOADER_QFLASH_DEVICE_TABLE"		device_altera		"byte_meg_size"		$supported_flash_size	$flash_device
                set_parameter_value				QFLASH_FAST_SPEED				0	
                
            } elseif { $is_qspi_flash } {
                set_flash_allowed_ranges		qspi_size_combo					"PARALLEL_FLASH_LOADER_QFLASH_DEVICE_TABLE"		device				"byte_meg_size"		$supported_flash_size	$flash_device
                if { [string match -nocase $pfl_qflash_mfc_type "MACRONIX"] == 1 } {
                    set_parameter_property			QFLASH_FAST_SPEED			ENABLED			1
                } else {
                    set_parameter_property			QFLASH_FAST_SPEED			ENABLED			0
                    set_parameter_value				QFLASH_FAST_SPEED			0
                }
                
            } elseif { $is_nand_flash } {
                set_flash_allowed_ranges			nflash_device_combo				"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		nand_device			"flash_byte_size"		$supported_flash_size	$flash_device
            
                if { $nand_ecc } {
                    if { [string match -nocase $pfl_nflash_mfc_type "MICRON"] == 1 } {
                        set_display_item_property		"ecc_info_text" 	TEXT	"Internal ECC is enabled"
                    } else {
                        set_display_item_property		"ecc_info_text" 	TEXT	"PFL IP ECC is enabled"
                    }
                } else {
                    set_display_item_property		"ecc_info_text" 	TEXT	"ECC is recommended for NAND flash (Caveat emptor)"
                }		
            }
            
            if { $safe_mode_revert == 0 || $operating_modes_cfg == 0 } {
                set_parameter_property			safe_mode_revert_edit			ENABLED			0
            } else {
                set_parameter_property			safe_mode_revert_edit			ENABLED			1
            }		
        }
        
        # +-----------------------------------
        # --- Sets UI visibility --- #
        # +-----------------------------------
        
        # CFI Flash Interface settings
        set_parameter_property				num_flash_combo				VISIBLE			$is_cfi_flash
        set_parameter_property				flash_device_combo			VISIBLE			$is_cfi_flash
        set_parameter_property				flash_data_width_combo		VISIBLE			$is_cfi_flash
        set_parameter_property				flash_nreset_check			VISIBLE			$is_cfi_flash

        # ASC/QSPI Flash Interface settings
        set_parameter_property				num_qflash_combo			VISIBLE			$is_asc_qspi_flash
        set_parameter_property				qflash_mfc_combo			VISIBLE			$is_qspi_flash
        set_parameter_property				QFLASH_FAST_SPEED			VISIBLE			$is_qspi_flash
        set_parameter_property				qflash_size_combo			VISIBLE			$is_asc_flash
        set_parameter_property				qspi_size_combo				VISIBLE			$is_qspi_flash
        
        # NAND Flash Interface settings
        set_parameter_property				num_nflash_combo			VISIBLE			$is_nand_flash
        set_parameter_property				nflash_mfc_combo			VISIBLE			$is_nand_flash
        set_parameter_property				nflash_device_combo			VISIBLE			$is_nand_flash
        set_parameter_property				nflash_data_width_combo		VISIBLE			$is_nand_flash
        set_parameter_property				nflash_rb_edit				VISIBLE			$is_nand_flash
        set_parameter_property				FLASH_ECC_CHECKBOX			VISIBLE			$is_nand_flash
        
        set_display_item_property			"spacer0"					VISIBLE			$is_nand_flash
        set_display_item_property			"nrb_label1"				VISIBLE			$is_nand_flash
        set_display_item_property			"nrb_label2"				VISIBLE			$is_nand_flash
        set_display_item_property			"ecc_info_text"				VISIBLE			$is_nand_flash

        # FPGA Configuration settings
        set_display_item_property			"spacer1"					VISIBLE			"true"
        set_display_item_property			"note_text"					VISIBLE			"true"
        set_display_item_property			"dclk_note"					VISIBLE			"true"

        # +-----------------------------------
        # --- update ports in block diagram with regards to parameter changes --- #
        # +-----------------------------------
        if {$flag eq "port_settings"} {
 
            # --- input ports --- #
            my_add_interface_port	"in"	"pfl_nreset"					"pfl_nreset"					1							"true"
            my_add_interface_port	"in"	"pfl_flash_access_granted"		"pfl_flash_access_granted"		1							"true"
            my_add_interface_port	"in"	"pfl_clk"						"pfl_clk"						1							$is_cfg_mode
            my_add_interface_port	"in"	"fpga_pgm"						"fpga_pgm"						$pfl_page_select_width		$is_cfg_mode
            my_add_interface_port	"in"	"fpga_conf_done"				"fpga_conf_done"				1							$is_cfg_mode
            my_add_interface_port	"in"	"fpga_nstatus"					"fpga_nstatus"					1							$is_cfg_mode
            my_add_interface_port	"in"	"pfl_nreconfigure"				"pfl_nreconfigure"				1							$reconfigure_port
            my_add_interface_port	"in"	"pfl_reset_watchdog"			"pfl_reset_watchdog"			1							$rsu_watchdog_enable_port

            # --- output/bidir ports --- #
            my_add_interface_port	"out"	"pfl_flash_access_request"		"pfl_flash_access_request"		1							"true"
            my_add_interface_port	"out"	"flash_addr"					"flash_addr"					$pfl_address_width			$is_cfi_flash
            my_add_interface_port	"bidir"	"flash_data"					"flash_data"					$pfl_flash_data_width		$is_cfi_flash
            my_add_interface_port	"bidir"	"flash_io"						"flash_io"						$pfl_flash_data_width		$is_nand_flash
            my_add_interface_port	"out"	"flash_nce"						"flash_nce"						$pfl_num_flash				$is_cfi_nand_flash
            my_add_interface_port	"out"	"flash_nwe"						"flash_nwe"						1							$is_cfi_nand_flash
            my_add_interface_port	"out"	"flash_noe"						"flash_noe"						1							$is_cfi_nand_flash
            my_add_interface_port	"out"	"flash_clk"						"flash_clk"						1							$cfi_burst
            my_add_interface_port	"out"	"flash_nadv"					"flash_nadv"					1							$cfi_burst
            my_add_interface_port	"out"	"flash_nreset"					"flash_nreset"					1							$flash_nreset_port_gen
            my_add_interface_port	"out"	"flash_cle"						"flash_cle"						1							$is_nand_flash
            my_add_interface_port	"out"	"flash_ale"						"flash_ale"						1							$is_nand_flash
            my_add_interface_port	"out"	"flash_sck"						"flash_sck"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"out"	"flash_ncs"						"flash_ncs"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"bidir"	"flash_io0"						"flash_io0"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"bidir"	"flash_io1"						"flash_io1"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"bidir"	"flash_io2"						"flash_io2"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"bidir"	"flash_io3"						"flash_io3"						$pfl_num_flash				$is_asc_qspi_flash
            my_add_interface_port	"out"	"fpga_data"						"fpga_data"						$pfl_fpga_data_width		$is_cfg_mode
            my_add_interface_port	"out"	"fpga_dclk"						"fpga_dclk"						1							$is_cfg_mode
            my_add_interface_port	"out"	"fpga_nconfig"					"fpga_nconfig"					1							$is_cfg_mode
            my_add_interface_port	"out"	"pfl_watchdog_error"			"pfl_watchdog_error"			1							$rsu_watchdog_enable_port

            if { $debug > 0 } {
                my_add_interface_port	"out"	"debug"							"debug"							$debug						"true"
            }
        }

        # +-----------------------------------
        # --- update HDL parameters with regards to parameter changes --- #
        # +-----------------------------------
        set_hdl_parameters					FEATURES_PGM				$operating_modes_pgm
        set_hdl_parameters					FEATURES_CFG				$operating_modes_cfg	
        set_hdl_parameters					FLASH_TYPE					$flash_type_param
        
        # by default set all HDL parameters to false
        set_hdl_parameters_to_false
                                    
        if { $is_cfi_nand_flash } {
            set_hdl_parameters				ADDR_WIDTH					$pfl_address_width
            set_hdl_parameters				FLASH_DATA_WIDTH			$pfl_flash_data_width
            set_hdl_parameters				N_FLASH						$pfl_num_flash
            if { $is_cfi_flash } {
                if { $flash_nreset && !$read_burst_mode } {
                    set_hdl_parameters		FLASH_NRESET_CHECKBOX		1
                } else {
                    set_hdl_parameters		FLASH_NRESET_CHECKBOX		0
                }
            } elseif { $is_nand_flash } {
                set_hdl_parameters			NFLASH_MFC					$pfl_nflash_mfc_type
                set_parameter_property		FLASH_ECC_CHECKBOX			HDL_PARAMETER				"true"
            }
        } elseif { $is_asc_qspi_flash } {
            set_hdl_parameters				N_FLASH						$pfl_num_flash
            set_hdl_parameters				QFLASH_MFC					$pfl_qflash_mfc_type
            set_hdl_parameters				EXTRA_ADDR_BYTE				$qflash_extra_addr_byte
            if { $is_qspi_flash } {
                set_parameter_property			QFLASH_FAST_SPEED			HDL_PARAMETER				"true"
            }
        }
        if { $operating_modes_pgm == 1 && $is_cfi_flash } {
            set_hdl_parameters				ENHANCED_FLASH_PROGRAMMING	$enhanced_flash_programming
            set_hdl_parameters				FIFO_SIZE					$fifo_size
            set_hdl_parameters				DISABLE_CRC_CHECKBOX		$disable_crc_check_value
        }
        if { $operating_modes_cfg == 1 } {
            if { $is_cfi_nand_flash } {
                set_hdl_parameters			CLK_DIVISOR					$clk_div
                set_hdl_parameters			PAGE_CLK_DIVISOR			$page_div
                if { $is_cfi_flash } {
                    set_hdl_parameters		FLASH_NRESET_COUNTER		$flash_nreset_counter
                    set_hdl_parameters		NORMAL_MODE					$read_normal_mode
                    set_hdl_parameters		BURST_MODE					$read_burst_mode
                    set_hdl_parameters		PAGE_MODE					$spansion_page_mode
                    set_hdl_parameters		MT28EW_PAGE_MODE			$mt28ew_page_mode
                    set_hdl_parameters		BURST_MODE_SPANSION			$flash_family_spansion
                    set_hdl_parameters		BURST_MODE_INTEL			$flash_family_intel
                    set_hdl_parameters		BURST_MODE_LATENCY_COUNT	$latency_count
                    set_hdl_parameters		BURST_MODE_NUMONYX			$flash_family_numonyx
                    set_hdl_parameters		FLASH_BURST_EXTRA_CYCLE		$burst_clk_count
                } else {
                    set_hdl_parameters		NRB_ADDR					$nrb_addr
                    set_hdl_parameters		US_UNIT_COUNTER				$us_unit_counter
                }
            } elseif { $is_asc_qspi_flash } {
                set address_width			[log2	[expr	$pfl_num_flash * $pfl_qflash_byte_size]]
                set_hdl_parameters			ADDR_WIDTH					$address_width
                set_hdl_parameters			FLASH_BURST_EXTRA_CYCLE		$burst_clk_count
                set_hdl_parameters			FLASH_STATIC_WAIT_WIDTH		[expr	[log2	$static_wait_count] + 1]
            }
            set_hdl_parameters				CONF_DATA_WIDTH				$pfl_fpga_data_width
            set_hdl_parameters				OPTION_BITS_START_ADDRESS	[expr int($option_bit_addr)]
            set_hdl_parameters				CONF_WAIT_TIMER_WIDTH		$conf_wait_timer
            set_hdl_parameters				DCLK_DIVISOR				$dclk_divisor
            set_hdl_parameters				DECOMPRESSOR_MODE			$decompressor_string
            
            set_hdl_parameters				SAFE_MODE_HALT				$safe_mode_halt
            set_hdl_parameters				SAFE_MODE_RETRY				$safe_mode_retry
            set_hdl_parameters				SAFE_MODE_REVERT			$safe_mode_revert
            
            set_hdl_parameters				SAFE_MODE_REVERT_ADDR		[expr int($safe_revert_addr)]
            set_hdl_parameters				QSPI_DATA_DELAY				$qspi_data_delay
            set_hdl_parameters				QSPI_DATA_DELAY_COUNT		$delay_count
            
            if { $rsu_watchdog_enable } {
                set_hdl_parameters			PFL_RSU_WATCHDOG_ENABLED	$rsu_watchdog_enable
                set_hdl_parameters			RSU_WATCHDOG_COUNTER		$rsu_watchdog_counter
            }	
        }
    }
}



# +-----------------------------------
# | Procedure for ports creation
# +-----------------------------------
proc my_add_interface_port {port_type megafunction_port_name module_port_name port_width port_gen} {
	
	if {$port_gen eq "true"} {
		if {$port_type eq "in"} {
			add_interface $megafunction_port_name conduit end
			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Input $port_width
		} elseif {$port_type eq "out"} {
			add_interface $megafunction_port_name conduit start
			set_interface_assignment $megafunction_port_name "ui.blockdiagram.direction" OUTPUT
			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Output $port_width
		} elseif {$port_type eq "bidir"} {
			add_interface $megafunction_port_name conduit start
			set_interface_assignment $megafunction_port_name "ui.blockdiagram.direction" OUTPUT
			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Bidir $port_width
		} else {
			send_message error "Illegal port type"
		}
	}
}



# +-----------------------------------
# | Set parameter allowed ranges
# +-----------------------------------
proc set_parameter_allowed_ranges {} {
	set allowed_values_col			"ALLOWED_VALUES"
	
	set_allowed_ranges	operating_mode_combo				"OPERATING_MODES_TABLE"							str						"str"
	set_allowed_ranges	flash_type_combo					"PARALLEL_FLASH_LOADER_FLASH_TYPE"				$allowed_values_col		"none"
	set_allowed_ranges	num_flash_combo						"NUM_FLASH_TABLE"								$allowed_values_col		"none"
	set_allowed_ranges	flash_device_combo					"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		device					"cfi_ini"
	set_allowed_ranges	flash_data_width_combo				"FLASH_DATA_WIDTH_TABLE"						$allowed_values_col		"none"
	set_allowed_ranges	num_qflash_combo					"NUM_QFLASH_TABLE"								$allowed_values_col		"none"
	set_allowed_ranges	qflash_size_combo					"PARALLEL_FLASH_LOADER_QFLASH_DEVICE_TABLE"		device_altera			"none"
	set_allowed_ranges	qflash_mfc_combo					"PARALLEL_FLASH_LOADER_QFLASH_MFC_TABLE"		mfc						"ini_value"
	set_allowed_ranges	qspi_size_combo						"PARALLEL_FLASH_LOADER_QFLASH_DEVICE_TABLE"		device					"none"
	set_allowed_ranges	nflash_mfc_combo					"PARALLEL_FLASH_LOADER_NFLASH_MFC_TABLE"		mfc						"support_flash"
	set_allowed_ranges	nflash_device_combo					"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		nand_device				"nand_supported"
	set_allowed_ranges	nflash_data_width_combo				"FLASH_DATA_WIDTH_TABLE"						$allowed_values_col		"nflash_data_width"
	set_allowed_ranges	enhanced_flash_programming_combo	"ENHANCED_FLASH_PROGRAMMING_TABLE"				$allowed_values_col		"none"
	set_allowed_ranges	fifo_size_combo						"FIFO_SIZE_TABLE"								$allowed_values_col		"none"
	set_allowed_ranges	fpga_conf_scheme_combo				"PARALLEL_FLASH_LOADER_CONF_SCHEME_TABLE"		$allowed_values_col		"none"
	set_allowed_ranges	safe_mode_combo						"SAFE_MODE_TABLE"								str						"str"
	set_allowed_ranges	dclk_divisor_combo					"DCLK_DIVISOR_TABLE"							$allowed_values_col		"none"
	set_allowed_ranges	read_modes_combo					"READ_MODES_TABLE"								str						"str"
	set_allowed_ranges	decompressor_combo					"PARALLEL_FLASH_LOADER_DECOMPRESSION_TABLE"		$allowed_values_col		"none"
}



# +-----------------------------------
# | Callback procedure for parameters
# +-----------------------------------
# proc update_device_family {arg} {
	# puts "device family update"
	# general_parameters_procedure	device_setting
# }

proc update_ui_settings {arg} {
	general_parameters_procedure	ui_settings
}
