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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2_hw_proc.tcl#3 $
# | 
# +-----------------------------------source altera_parallel_flash_loader_2_common.tclsource altera_parallel_flash_loader_2_msgs.tcl
# +-----------------------------------
# | Set UI Interface during elaboration callback
# +-----------------------------------
proc elaboration {}		{

    # --- Definitions --- #    set	page_access_time			3    set	pfl_fpga_data_width			1    set pfl_flash_data_width		16    set	pfl_page_select_width		3    set	operating_modes_cfg			0    set	operating_modes_pgm			1    set	is_cfg_mode					"false"    set flash_nreset_port_gen		"false"    set	reconfigure					"false"    set	rsu_watchdog_enable			"false"    set cfi_burst					"false"    set	access_time					100    set	enhanced_flash_programming	 0       # +-----------------------------------   # | Get Parameter from UI   # +-----------------------------------    set get_device_setting				[get_parameter_value 			INTENDED_DEVICE_FAMILY]    set OPERATING_MODE 					[get_parameter_value 			OPERATING_MODE]    set flash_type_ui 					[get_parameter_value 			FLASH_TYPE_UI]
    set	flash_device					[get_parameter_value 			FLASH_DEVICE_DENSITY]    set	qspi_device_density			    [get_parameter_value 			QSPI_DEVICE_DENSITY]
    set	num_flash				    	[get_parameter_value 			NUM_FLASH]    set	num_qspi				    	[get_parameter_value 			NUM_QSPI]
    set	qspi_mfc					    [get_parameter_value			QSPI_MFC] 
    set	enhanced_flash_prog_str			[get_parameter_value			ENHANCED_FLASH_PROGRAMMING_UI]    set	fifo_size						[get_parameter_value			FIFO_SIZE_UI]    set	get_disable_crc_check			[get_parameter_value			DISABLE_CRC_CHECK]    set	clock_frequency					[get_parameter_value			CLOCK_FREQUENCY]    set option_bit_addr					[get_parameter_value			OPTION_BIT_ADDRESS]    set	fpga_conf_scheme				[get_parameter_value			FPGA_CONF_SCHEME]    set	safe_mode						[get_parameter_value			SAFE_MODE]    set	safe_revert_addr				[get_parameter_value			SAFE_MODE_REVERT_ADDR_UI]    set reconfigure						[get_parameter_value			RECONFIGURE_CHECKBOX]    set	read_modes						[get_parameter_value			READ_MODES]    set data_width 						[get_parameter_value 			FLASH_DATA_WIDTH_UI]   # set	pfl_flash_data_width			[regsub -all {[^0-9]} $data_width ""]    set	access_time						[get_parameter_value			FLASH_ACCESS_TIME]    set	latency_count					[get_parameter_value 			LATENCY_COUNT]    set ready_latency					[get_parameter_value 			READY_LATENCY]    # use to get number of state of ready syncrhonizer. Default is 2 states.    set ready_sync_stages 				[get_parameter_value 			READY_SYNC_STAGES]       # Gets variable from string    set is_cfi_flash		    	    [regexp "CFI Parallel Flash" $flash_type_ui]
    set is_qspi_flash				    [regexp "Quad SPI Flash" $flash_type_ui]
    set operating_modes_pgm				[regexp "Flash Programming" $OPERATING_MODE]    set operating_modes_cfg				[regexp "FPGA Configuration" $OPERATING_MODE]	    set	safe_mode_halt					[regexp "Halt" $safe_mode]    set	safe_mode_retry					[regexp "Retry same page" $safe_mode]    set	safe_mode_revert				[regexp "Retry from fixed address" $safe_mode]    set	read_normal_mode				[regexp "Normal Mode" $read_modes]    set	flash_family_intel				[regexp "Intel Burst Mode" $read_modes]	    set	spansion_page_mode				[regexp "16 Bytes Page Mode" $read_modes]    set	mt28ew_page_mode				[regexp "32 Bytes Page Mode" $read_modes]    set	flash_family_numonyx			[regexp "Micron Burst Mode" $read_modes]    set	qspi_mfc					[get_parameter_value			QSPI_MFC] 
    set	is_qspi_micron		        [regexp "Micron" $qspi_mfc]
    set	is_qspi_epcq		        [regexp "Altera EPCQ" $qspi_mfc]
    set	is_qspi_macronix	        [regexp "Macronix" $qspi_mfc]
    set	is_qspi_spansion	        [regexp "Spansion" $qspi_mfc]
    # calculate the address width based on the density of the flash    if {$is_cfi_flash} {
        set	pfl_flash_data_width			[regsub -all {[^0-9]} $data_width ""]
    set pfl_address_width				[calculate_pfl_addr_width		$flash_device	$pfl_flash_data_width]    } elseif {$is_qspi_flash} {
        if {$num_qspi == 1} {
            set	pfl_flash_data_width			8
        } else {
            set	pfl_flash_data_width			[expr $num_qspi * 4]
        }        set pfl_address_width				[calculate_qspi_addr_width		$qspi_device_density	$num_qspi]
    }
        send_message debug " pfl_address_width : $pfl_address_width"
    # --- Check device family support --- #    set cycloneiii_family_list		{"Cyclone IV GX" "Cyclone IV E" "Cyclone 10 LP"}    if {[check_device_family_equivalence $get_device_setting $cycloneiii_family_list]} {        if { ([string match -nocase [get_quartus_ini_string	PGM_PFL_ALLOW_CONF	"OFF"] "OFF"] == 1) } {			set_parameter_property	 OPERATING_MODE 	ENABLED 	0            set	operating_modes_pgm		1            set	operating_modes_cfg		0        }    }     # --- Sets tab visibility ---#    # Sets Flash Programming Tab visibility    # QSPI flash does not have flash programing tap    if { $operating_modes_pgm == 0 ||            $is_qspi_flash == 1 } {    
        set_display_item_property "Flash Programming"	VISIBLE	0    } else {        set_display_item_property "Flash Programming"	VISIBLE	1    }        # Sets FPGA Configuration Tab visibility    if { $operating_modes_cfg == 0 } {        set_display_item_property "FPGA Configuration"	VISIBLE	0    } else {        set_display_item_property "FPGA Configuration"	VISIBLE	1    }    # +-----------------------------------
    # --- flash  --- #
    # +-----------------------------------
    if { $is_cfi_flash } {
        set pfl_num_flash		$num_flash
        set	pfl_qflash_byte_size 0
    } elseif { $is_qspi_flash } {
        if { $is_qspi_epcq } {
            set_parameter_property QSPI_DEVICE_DENSITY ALLOWED_RANGES {"QSPI 16 Mbit" "QSPI 32 Mbit" \
                                                                        "QSPI 64 Mbit" "QSPI 128 Mbit" "QSPI 256 Mbit" \
                                                                        "QSPI 512 Mbit" "QSPI 1 Gbit"}
        } else {
            set_parameter_property QSPI_DEVICE_DENSITY ALLOWED_RANGES {"QSPI 8 Mbit" "QSPI 16 Mbit" "QSPI 32 Mbit" \
                                                            "QSPI 64 Mbit" "QSPI 128 Mbit" "QSPI 256 Mbit" \
                                                            "QSPI 512 Mbit" "QSPI 1 Gbit" "QSPI 2 Gbit"}
        }
        set	pfl_num_flash			$num_qspi
        set	pfl_qflash_byte_size		[get_byte_flash_density $qspi_device_density]
        if { $pfl_qflash_byte_size	> [expr	16<<20] } {
            set	qflash_extra_addr_byte		1
        } else {
            set	qflash_extra_addr_byte		0
        }
     }  
    # +-----------------------------------    # --- Flash interface Tab --- #
    # --- UI setting          ---#
    # +-----------------------------------
    send_message debug " is_cfi_flash : $is_cfi_flash"
    send_message debug " is_qspi_flash : $is_qspi_flash"
    # CFI Flash Interface settings
    set_parameter_property				NUM_FLASH		            VISIBLE			$is_cfi_flash
    set_parameter_property				FLASH_DEVICE_DENSITY	    VISIBLE			$is_cfi_flash
    set_parameter_property				FLASH_DATA_WIDTH_UI         VISIBLE			$is_cfi_flash
    set_parameter_property				FLASH_NRESET_CHECK			VISIBLE			$is_cfi_flash
    # QSPI Flash Interface settings
    set_parameter_property				NUM_QSPI			        VISIBLE			$is_qspi_flash
    set_parameter_property				QSPI_MFC			        VISIBLE			$is_qspi_flash
    set_parameter_property				QFLASH_FAST_SPEED			VISIBLE			$is_qspi_flash
    set_parameter_property				QSPI_DEVICE_DENSITY			VISIBLE			$is_qspi_flash
    #only enable fast read for macronix follow PFL I
    if {$is_qspi_flash & $is_qspi_macronix} {
        set_parameter_property			QFLASH_FAST_SPEED				ENABLED		1
    } else {
        set_parameter_property			QFLASH_FAST_SPEED				ENABLED		0
    }
    # +-----------------------------------
    # --- Flash Programming Tab --- #    # +-----------------------------------    if { $operating_modes_pgm == 1 } {        set	enhanced_flash_programming	    [regexp "Speed" $enhanced_flash_prog_str]    
         if { $get_disable_crc_check } {			set	disable_crc_check_value	0
        } else {
            set	disable_crc_check_value	1
        }
  
        set_parameter_property			enhanced_flash_programming_ui	ENABLED		1        set_parameter_property          disable_crc_check               ENABLED     1        if { $enhanced_flash_programming == 1 } {            set_parameter_property			fifo_size_ui				ENABLED		1        } else {            # Speed            set_parameter_property			fifo_size_ui				ENABLED		0        }            } elseif  { $operating_modes_pgm == 0 } {        set	enhanced_flash_programming	    0
        set_parameter_property			enhanced_flash_programming_ui		ENABLED		0        set_parameter_property			fifo_size_ui						ENABLED		0
        set_parameter_property          disable_crc_check                   ENABLED     0    }	        # +-----------------------------------        # --- FPGA Configuration Tab --- #        # +-----------------------------------        if { $operating_modes_cfg == 1 } {            set	watchdog_counter		[get_parameter_value			RSU_WATCHDOG_COUNTER_UI]            set reconfigure				[get_parameter_value			RECONFIGURE_CHECKBOX]
            set	delay_count				1
            set	burst_timing			[get_quartus_ini_string			PGM_PFL_BURST_MODE_CLK_TO_OUTPUT_VALID_NS	22]
            set	static_wait_timing		[get_quartus_ini_string			PGM_PFL_FLASH_STATIC_WAIT_US				100]
            set clk_freq				[expr	int(ceil($clock_frequency))]
            set	clk_div					[expr	int(ceil($clock_frequency * $access_time / 1000.0)) - 1]
            set	burst_clk_count			[expr	int(ceil($clock_frequency * $burst_timing / 1000.00))]
            set	static_wait_count		[expr	int(ceil($clock_frequency * $static_wait_timing))]
            set	pfl_fpga_data_width		[regsub -all {[^0-9]} $fpga_conf_scheme ""]                          
            set is_cfg_mode "true"
            set_parameter_value RSU_WATCHDOG_ENABLE [get_parameter_value			RSU_WATCHDOG_CHECKBOX]
            set rsu_watchdog_enable		[get_parameter_value			RSU_WATCHDOG_ENABLE]
           
            if { $flash_family_intel == 1 || $flash_family_numonyx == 1 } {
                set	read_burst_mode		    "true"
            } else {
                set	read_burst_mode		    "false"
            }
            if { $burst_clk_count > 2 } {
                set	burst_clk_count		1

            } else {
                set	burst_clk_count		0
            }
                
            # to ensure that that clk div is at least one
            set	clk_div					[return_at_least_one	$clk_div] 
            # get page access time
            set	page_div				[expr	int(ceil($clock_frequency * $page_access_time / 100.0)) - 1]
            # to ensure that the page_div is at least one
            set	page_div				[return_at_least_one	$page_div]
            set	user_mode_wait			[expr	int(ceil($clock_frequency  * 1500))]
            # get number of count
            set	flash_nreset_counter	[expr	int(ceil($clock_frequency  * 50))]
            # to ensure that that num_count is at least one
            set	flash_nreset_counter	[return_at_least_one	$flash_nreset_counter] 
            # get number of watchdog count
            set	rsu_watchdog_counter	[expr	int(ceil($watchdog_counter * $clock_frequency * 1000.0))]
            # to ensure that the count is at least one clock
            set	rsu_watchdog_counter	[return_at_least_one	$rsu_watchdog_counter] 	
            set conf_wait_timer			[expr	{[log2	$user_mode_wait] + 2}]
            if { $conf_wait_timer <= 18} {
                set conf_wait_timer		18
            }
   
            if {$read_burst_mode == "false" && $pfl_num_flash == 1} {
                set_parameter_property		FLASH_NRESET_CHECK		    ENABLED	1
                set_parameter_value flash_nreset [get_parameter_value FLASH_NRESET_CHECK]
            } else {
                set_parameter_property		FLASH_NRESET_CHECK		    ENABLED	 0
                set_parameter_value flash_nreset 0
            }
             set flash_nreset [get_parameter_value FLASH_NRESET]
             if {$is_cfi_flash} {
            if { $flash_nreset || $read_burst_mode || $pfl_num_flash > 1 } {
                set flash_nreset_port_gen	"true"
                 }
             }
     
            if { $read_burst_mode && $is_cfi_flash } {
                set		cfi_burst			"true"
            }
            set_parameter_property		clock_frequency		        ENABLED		1            set_parameter_property		flash_access_time		    ENABLED		$is_cfi_flash
            set_parameter_property		option_bit_address		    ENABLED		1
            set_parameter_property		fpga_conf_scheme		    ENABLED		1
            set_parameter_property		safe_mode		            ENABLED		1
            set_parameter_property		RECONFIGURE_CHECKBOX	    ENABLED		1            set_parameter_property		RSU_WATCHDOG_CHECKBOX	    ENABLED		1
            set_parameter_property		READ_MODES		            ENABLED		$is_cfi_flash                      set_parameter_property		SAFE_MODE_REVERT_ADDR_UI	ENABLED		$safe_mode_revert	
            set_parameter_property		LATENCY_COUNT			    ENABLED		$flash_family_intel            set_parameter_property		RSU_WATCHDOG_COUNTER_UI		ENABLED		$rsu_watchdog_enable		
                 } elseif  { $operating_modes_cfg == 0 } {
 
         set_parameter_value RSU_WATCHDOG_ENABLE 0
           set  reconfigure		    0
           set  watchdog_counter    0
           set  read_burst_mode 	"false"
           set  flash_nreset  0
           set flash_nreset_port_gen	"false"
           set is_cfg_mode "false"
           set_parameter_property		clock_frequency		        ENABLED		0
           set_parameter_property		flash_access_time		    ENABLED		0
           set_parameter_property		option_bit_address		    ENABLED		0
           set_parameter_property		fpga_conf_scheme		    ENABLED		0
           set_parameter_property		safe_mode		            ENABLED		0
           set_parameter_property		RECONFIGURE_CHECKBOX	    ENABLED		0
           set_parameter_property		RSU_WATCHDOG_CHECKBOX	    ENABLED		0
           set_parameter_property		READ_MODES		            ENABLED		0
           set_parameter_property		SAFE_MODE_REVERT_ADDR_UI	ENABLED		0
           set_parameter_property		LATENCY_COUNT			    ENABLED		0           set_parameter_property		RSU_WATCHDOG_COUNTER_UI		ENABLED		0
           set_parameter_property		FLASH_NRESET_CHECK		    ENABLED	    0        }        #error message
   check_for_fpga_conf_error	$pfl_flash_data_width	$pfl_address_width	$pfl_num_flash	$pfl_qflash_byte_size	$operating_modes_cfg           set		debug		[get_quartus_ini_string		PFL_ADDS_DEBUG_BUS		0]         # +-----------------------------------    # --- add hdl --- #    # +-----------------------------------          if {$operating_modes_cfg == 1} {     set inSymbolsPerBeat   [expr $pfl_flash_data_width/8]     set outSymbolsPerBeat  [expr $pfl_fpga_data_width/8]    # Use common Data format adapter     #add_hdl_instance 		altera_pfl2_data_format_adapter data_format_adapter    # Use PFL Data format adapter     add_hdl_instance 		altera_pfl2_data_format_adapter altera_pfl2_data_format_adapter    set_instance_parameter_value 	altera_pfl2_data_format_adapter inSymbolsPerBeat	$inSymbolsPerBeat    set_instance_parameter_value 	altera_pfl2_data_format_adapter outSymbolsPerBeat	$outSymbolsPerBeat    set_instance_parameter_value 	altera_pfl2_data_format_adapter endianess	"Little Endian"            add_hdl_instance 		altera_pfl2_timing_adapter timing_adapter        set_instance_parameter_value    altera_pfl2_timing_adapter inSymbolsPerBeat $outSymbolsPerBeat    set_instance_parameter_value 	altera_pfl2_timing_adapter inReadyLatency	0    set_instance_parameter_value 	altera_pfl2_timing_adapter outReadyLatency	[expr $ready_latency - $ready_sync_stages]		}            # +-----------------------------------    # --- UI port Interface --- #    # +-----------------------------------        if {$is_cfg_mode eq "true"} {        add_interface pfl_clk clock end        add_interface_port pfl_clk pfl_clk clk Input 1        add_interface pfl_nreset reset end        set_interface_property pfl_nreset associatedClock pfl_clk        add_interface_port pfl_nreset pfl_nreset reset_n Input 1                add_interface avalon_source avalon_streaming source        add_interface_port avalon_source avst_valid valid output 1        add_interface_port avalon_source avst_ready ready input 1        add_interface_port avalon_source avst_data data output $pfl_fpga_data_width        set_interface_property avalon_source associatedClock pfl_clk		        set_interface_property avalon_source associatedreset pfl_nreset	        set_interface_property avalon_source readyLatency $ready_latency                     add_interface avst_clk conduit end	        add_interface_port avst_clk avst_clk avst_clk output 1	} else {		my_add_interface_port	"in"	"pfl_nreset"					"pfl_nreset"					1							"true"
	}    # --- input ports --- #    my_add_interface_port	"in"	"pfl_flash_access_granted"		"pfl_flash_access_granted"		1							"true"    my_add_interface_port	"in"	"fpga_pgm"						"fpga_pgm"						$pfl_page_select_width		$is_cfg_mode    my_add_interface_port	"in"	"fpga_conf_done"				"fpga_conf_done"				1							$is_cfg_mode    my_add_interface_port	"in"	"fpga_nstatus"					"fpga_nstatus"					1							$is_cfg_mode    my_add_interface_port	"in"	"pfl_nreconfigure"				"pfl_nreconfigure"				1							$reconfigure    my_add_interface_port	"in"	"pfl_reset_watchdog"			"pfl_reset_watchdog"			1							$rsu_watchdog_enable    my_add_interface_port	"out"	"pfl_flash_access_request"		"pfl_flash_access_request"		1							"true"
    # --- output/bidir ports --- #    if {$is_cfi_flash} {    my_add_interface_port	"out"	"flash_addr"					"flash_addr"					$pfl_address_width			"true"    my_add_interface_port	"bidir"	"flash_data"					"flash_data"					$pfl_flash_data_width		"true"    my_add_interface_port	"out"	"flash_nce"						"flash_nce"						$pfl_num_flash				"true"    my_add_interface_port	"out"	"flash_nwe"						"flash_nwe"						1							"true"    my_add_interface_port	"out"	"flash_noe"						"flash_noe"						1							"true"    my_add_interface_port	"out"	"flash_clk"						"flash_clk"						1							$read_burst_mode    my_add_interface_port	"out"	"flash_nadv"					"flash_nadv"					1							$read_burst_mode    } elseif {$is_qspi_flash} {
        my_add_interface_port	"out"	"flash_sck"						"flash_sck"						$pfl_num_flash				"true"
        my_add_interface_port	"out"	"flash_ncs"						"flash_ncs"						$pfl_num_flash				"true"
        my_add_interface_port	"bidir"	"flash_io0"						"flash_io0"						$pfl_num_flash				"true"
        my_add_interface_port	"bidir"	"flash_io1"						"flash_io1"						$pfl_num_flash				"true"
        my_add_interface_port	"bidir"	"flash_io2"						"flash_io2"						$pfl_num_flash				"true"
        my_add_interface_port	"bidir"	"flash_io3"						"flash_io3"						$pfl_num_flash				"true"
    }
    my_add_interface_port	"out"	"flash_nreset"					"flash_nreset"					1							$flash_nreset_port_gen    my_add_interface_port	"out"	"fpga_nconfig"					"fpga_nconfig"					1							$is_cfg_mode    my_add_interface_port	"out"	"pfl_watchdog_error"			"pfl_watchdog_error"			1							$rsu_watchdog_enable    if { $debug > 0 } {        my_add_interface_port	"out"	"debug"							"debug"							$debug						"true"    }                   # +-----------------------------------    # --- update HDL parameters with regards to parameter changes --- #    # +-----------------------------------    set_hdl_parameters				ADDR_WIDTH					$pfl_address_width    set_hdl_parameters				N_FLASH						$pfl_num_flash       if { $is_cfi_flash } {
        set_hdl_parameters				FLASH_DATA_WIDTH			$pfl_flash_data_width
    if { $pfl_num_flash == 1 } {        if { $flash_nreset && !$read_burst_mode } {            set_hdl_parameters		FLASH_NRESET_CHECKBOX		1        } else {            set_hdl_parameters		FLASH_NRESET_CHECKBOX		0        }
    }        if { $operating_modes_pgm == 1  } {        set_hdl_parameters				FIFO_SIZE					$fifo_size        set_hdl_parameters				DISABLE_CRC_CHECKBOX		$disable_crc_check_value        }
    } elseif { $is_qspi_flash } {
        set_hdl_parameters				FLASH_MFC						$qspi_mfc   
        set_hdl_parameters				EXTRA_ADDR_BYTE						$qflash_extra_addr_byte   
    }     if { $operating_modes_cfg == 1 } {            if { $is_cfi_flash } {
    set_hdl_parameters		CLK_DIVISOR					$clk_div    set_hdl_parameters		PAGE_CLK_DIVISOR			$page_div    set_hdl_parameters		NORMAL_MODE					$read_normal_mode    set_hdl_parameters		BURST_MODE					$read_burst_mode    set_hdl_parameters		PAGE_MODE					$spansion_page_mode	set_hdl_parameters		MT28EW_PAGE_MODE			$mt28ew_page_mode    set_hdl_parameters		BURST_MODE_SPANSION			0    set_hdl_parameters		BURST_MODE_INTEL			$flash_family_intel    set_hdl_parameters		BURST_MODE_LATENCY_COUNT	$latency_count    set_hdl_parameters		BURST_MODE_NUMONYX			$flash_family_numonyx        if { $pfl_num_flash == 1 } {
        set_hdl_parameters		FLASH_NRESET_COUNTER		$flash_nreset_counter
        } 
    }
    set_hdl_parameters		FLASH_BURST_EXTRA_CYCLE		$burst_clk_count    set_hdl_parameters		CONF_WAIT_TIMER_WIDTH		$conf_wait_timer    set_hdl_parameters		CONF_DATA_WIDTH				$pfl_fpga_data_width    set_hdl_parameters		OPTION_START_ADDR	        [expr int($option_bit_addr)]    set_hdl_parameters		SAFE_MODE_HALT				$safe_mode_halt    set_hdl_parameters		SAFE_MODE_RETRY				$safe_mode_retry    set_hdl_parameters		SAFE_MODE_REVERT			$safe_mode_revert    set_hdl_parameters		SAFE_MODE_REVERT_ADDR		[expr int($safe_revert_addr)]    set_hdl_parameters		SAFE_MODE_REVERT_ADDR		[expr int($safe_revert_addr)]    set_hdl_parameters		READY_SYNC_STAGES		    $ready_sync_stages    if { $rsu_watchdog_enable } {        set_hdl_parameters			PFL_RSU_WATCHDOG_ENABLED	$rsu_watchdog_enable        set_hdl_parameters			RSU_WATCHDOG_COUNTER		$rsu_watchdog_counter        }	            } }

# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {
    set OPERATING_MODE 				[get_parameter_value 			OPERATING_MODE]
    set operating_modes_pgm			[regexp "Flash Programming" $OPERATING_MODE]
    set operating_modes_cfg			[regexp "FPGA Configuration" $OPERATING_MODE]	
    set flash_type_ui 		        [get_parameter_value 			FLASH_TYPE_UI]
    set is_cfi_flash	            [regexp "CFI Parallel Flash" $flash_type_ui]
    set is_qspi_flash		        [regexp "Quad SPI Flash" $flash_type_ui]
    set tristate_checkbox  			[get_parameter_value			TRISTATE_CHECKBOX]
    set reconfigure_port			[get_parameter_value			RECONFIGURE_CHECKBOX]
    set rsu_watchdog_enable			[get_parameter_value			RSU_WATCHDOG_ENABLE]
    set	read_modes					[get_parameter_value			READ_MODES] 
    set	read_normal_mode			[regexp "Normal Mode" $read_modes]
    set	flash_family_intel			[regexp "Intel Burst Mode" $read_modes]	
    set	spansion_page_mode			[regexp "16 Bytes Page Mode" $read_modes]    set	mt28ew_page_mode			[regexp "32 Bytes Page Mode" $read_modes]
    set	flash_family_numonyx		[regexp "Micron Burst Mode" $read_modes]
    set read_burst_mode    			[expr $flash_family_intel == 1 || $flash_family_numonyx == 1 ]	set read_page_mode    			[expr $spansion_page_mode == 1 || $mt28ew_page_mode == 1 ]
    set	flash_nreset				[get_parameter_value			FLASH_NRESET]
    set	num_flash				    [get_parameter_value 			NUM_FLASH]       
    set	get_disable_crc_check		[get_parameter_value			DISABLE_CRC_CHECK]          
    set	num_qspi				    [get_parameter_value 			NUM_QSPI]  
    set	qspi_mfc					[get_parameter_value			QSPI_MFC] 
    set	is_qspi_micron		        [regexp "Micron" $qspi_mfc]
    set	is_qspi_epcq		        [regexp "Altera EPCQ" $qspi_mfc]
    set	is_qspi_macronix	        [regexp "Macronix" $qspi_mfc]
    set	is_qspi_spansion	        [regexp "Spansion" $qspi_mfc]
    set	enhanced_flash_prog_str		[get_parameter_value			ENHANCED_FLASH_PROGRAMMING_UI]      
    set enhanced_flash_programming	[regexp "Speed" $enhanced_flash_prog_str]      
    set data_width 					[get_parameter_value 			FLASH_DATA_WIDTH_UI]       
    set	pfl_flash_data_width		[regsub -all {[^0-9]} $data_width ""]       
    set	fpga_conf_scheme			[get_parameter_value			FPGA_CONF_SCHEME]      
    set	pfl_fpga_data_width			[regsub -all {[^0-9]} $fpga_conf_scheme ""]

        
    send_message info "generating top-level entity $entityname"
    # --- update ports in top level file via terp with regards to parameter changes --- #        set this_dir      [ get_module_property MODULE_DIRECTORY ]  
        if {$is_cfi_flash} {
            if { $num_flash == 1 } {
             set template_file [ file join $this_dir "altera_pfl2_single_cfi.vhd.terp" ]
        } else {
               set template_file [ file join $this_dir "altera_pfl2_multiple_cfi.vhd.terp" ]
            }
        } elseif {$is_qspi_flash} {
            set template_file [ file join $this_dir "altera_pfl2_qspi.v.terp" ]
        }        set template    [ read [ open $template_file r ] ]                            # set parameter for terp file         set params(is_cfg_mode)                 $operating_modes_cfg
        set params(is_pgm_mode)                 $operating_modes_pgm
        set params(is_pgm_enhanced)             $enhanced_flash_programming        set params(reconfigure_port)            $reconfigure_port        set params(rsu_watchdog_enable_port)    $rsu_watchdog_enable        set params(cfi_burst)                   $read_burst_mode
        set params(flash_nreset_checkbox)      $flash_nreset        set params(flash_nreset_port_gen)       [expr $flash_family_intel || $flash_family_numonyx || $flash_nreset || $num_flash > 1]        set params(tristate_checkbox)    $tristate_checkbox        set result          [ altera_terp $template params ]             if {$is_cfi_flash} {
            set output_file     [ create_temp_file altera_parallel_flash_loader_2.vhd ]
       } elseif {$is_qspi_flash} {
            set output_file     [ create_temp_file altera_parallel_flash_loader_2.v ]       }
        set output_handle   [ open $output_file w ]                puts $output_handle $result        close $output_handle		        # adding RTL files        if {$is_cfi_flash} {
            add_fileset_file altera_parallel_flash_loader_2.vhd VHDL    PATH ${output_file}
        } elseif {$is_qspi_flash} {
            add_fileset_file altera_parallel_flash_loader_2.v   VERILOG PATH ${output_file}
        }
				# RTL file for flash programming
		if { $operating_modes_pgm == 1  } {
			if { $is_cfi_flash } {
                if { $get_disable_crc_check } {
                    add_fileset_file "altera_pfl2_pgm_verify.v"     VERILOG PATH "../rtl/altera_pfl2_pgm_verify.v"
                    add_fileset_file "altera_pfl2_crc_calculate.v"  VERILOG PATH "../rtl/altera_pfl2_crc_calculate.v"
                }
                if { $enhanced_flash_programming == 1 } {
                    add_fileset_file "altera_pfl2_pgm_enhanced.vhd"         VHDL PATH "../rtl/altera_pfl2_pgm_enhanced.vhd"
                    add_fileset_file "altera_pfl2_pgm_sm.vhd"               VHDL PATH "../rtl/altera_pfl2_pgm_sm.vhd"
                    add_fileset_file "altera_pfl2_pgm_fifo_sm.vhd"          VHDL PATH "../rtl/altera_pfl2_pgm_fifo_sm.vhd"
                    add_fileset_file "altera_pfl2_pgm_flash_sm.vhd"         VHDL PATH "../rtl/altera_pfl2_pgm_flash_sm.vhd"
                    add_fileset_file "altera_pfl2_pgm_status_register.vhd"  VHDL PATH "../rtl/altera_pfl2_pgm_status_register.vhd"
                    } else {
                    add_fileset_file "altera_pfl2_pgm.vhd"      VHDL PATH "../rtl/altera_pfl2_pgm.vhd"
                }
            } elseif { $is_qspi_flash } {
                    add_fileset_file "altera_pfl2_qspi_pgm.v" VERILOG PATH "../rtl/altera_pfl2_qspi_pgm.v"
            }
		}
		
		# RTL file for FPGA Configuration
		if { $operating_modes_cfg == 1 } {            add_fileset_file "altera_pfl2_cfg.v"                    VERILOG PATH "../rtl/altera_pfl2_cfg.v"            add_fileset_file "altera_pfl2_cfg_controller.v"         VERILOG PATH "../rtl/altera_pfl2_cfg_controller.v"            add_fileset_file "altera_pfl2_glitch.v"                 VERILOG PATH "../rtl/altera_pfl2_glitch.v"            add_fileset_file "altera_pfl2_reset.v"                  VERILOG PATH "../rtl/altera_pfl2_reset.v"            add_fileset_file "altera_pfl2_cfg_ready_synchronizer.v" VERILOG PATH "../rtl/altera_pfl2_cfg_ready_synchronizer.v"            
            if { $rsu_watchdog_enable } {
                add_fileset_file "altera_pfl2_cfg_rsu_wd.v" VERILOG PATH "../rtl/altera_pfl2_cfg_rsu_wd.v"	
            }
            
            if { $is_cfi_flash } {
                if { $flash_nreset && $read_burst_mode == 0} {
                    add_fileset_file "altera_pfl2_cfg_flash_reset.v" VERILOG PATH "../rtl/altera_pfl2_cfg_flash_reset.v"
                }                if { $read_normal_mode == 1 } {                    add_fileset_file "altera_pfl2_cfg_cfi_normal_read.v" VERILOG PATH "../rtl/altera_pfl2_cfg_cfi_normal_read.v"	                                    } elseif { $flash_family_intel == 1 ||                        $flash_family_numonyx == 1 } {                    add_fileset_file "altera_pfl2_cfg_cfi_intel_burst.v" VERILOG PATH "../rtl/altera_pfl2_cfg_cfi_intel_burst.v"	                    add_fileset_file "altera_pfl2_counter.v" VERILOG PATH "../rtl/altera_pfl2_counter.v"                    add_fileset_file "altera_pfl2_data.v" VERILOG PATH "../rtl/altera_pfl2_data.v"                                    } elseif { $read_page_mode == 1 } {                    add_fileset_file "altera_pfl2_cfg_cfi_spansion_page.v" VERILOG PATH "../rtl/altera_pfl2_cfg_cfi_spansion_page.v"                            }
                            } elseif { $is_qspi_flash } {
                add_fileset_file "altera_pfl2_qspi_cfg.v" VERILOG PATH "../rtl/altera_pfl2_qspi_cfg.v"  
                if { $num_qspi == 1} {
                    add_fileset_file "altera_pfl2_up_converter.v"   VERILOG PATH "../rtl/altera_pfl2_up_converter.v"
                    add_fileset_file "altera_pfl2_fifo.v"           VERILOG PATH "../rtl/altera_pfl2_fifo.v"                     
                }
                    if { $is_qspi_micron || $is_qspi_epcq } {
                        add_fileset_file "altera_pfl2_qspi_cfg_micron_altera.v" VERILOG PATH "../rtl/altera_pfl2_qspi_cfg_micron_altera.v"   
                    } elseif {$is_qspi_macronix} {
                        add_fileset_file "altera_pfl2_qspi_cfg_macronix.v"      VERILOG PATH "../rtl/altera_pfl2_qspi_cfg_macronix.v"   
                    } else {
                        add_fileset_file "altera_pfl2_qspi_cfg_others.v"        VERILOG PATH "../rtl/altera_pfl2_qspi_cfg_others.v"   
                    }            }            		}		
}