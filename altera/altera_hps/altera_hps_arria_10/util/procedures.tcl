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


#--------------------------------------------------------------------------------------
# procedures.tcl
#
# Description: procedures shared amongst IP under HPS.
#
# Dependencies: hps/util/constants.tcl
#               altera_hps_hw.tcl (::fpga_intefaces)
#--------------------------------------------------------------------------------------


proc clear_array { name } {
	if { [uplevel array exists $name ] == 1 } { 
		uplevel array unset $name
	}
}

# Force Unset
proc funset {var_name} {
	upvar 1 $var_name var
	if {[info exists var]} {
		unset var
	}
}

# TODO: support newlines within quoted cells
proc csv_foreach_row {file cells_var_name loop_body} {
	set fp [open $file r]
	set filedata [read $fp]
	close $fp
	set data [split $filedata "\n"]
	
	foreach line $data {
		if {[regexp {^[ \t\n,]*$} $line]} continue ;# Skip empty lines
		
		set line [string trim $line]
		upvar 1 $cells_var_name cells
		set cells [list]
		
		set POST_COMMA                   0
		set STRING                       1
		set STRING_IN_QUOTES             2
		set STRING_IN_QUOTES_FIRST_QUOTE 3
		set WAITING_FOR_COMMA            4
		set mode $POST_COMMA

		set space_buffer ""
		set cell_buffer  ""
		set line_length [string length $line]
		for {set col 0} {$col < $line_length} {incr col} {
			set ch [string index $line $col]
			
			if {$mode == $POST_COMMA} {
				if {[string is space $ch]} {
					# do nothing
				} elseif {[string compare $ch ","] == 0} {
					lappend cells ""
				} elseif {[string compare $ch "\""] == 0} {
					set mode $STRING_IN_QUOTES
					set cell_buffer ""
				} else {
					set mode $STRING
					set cell_buffer $ch
					set space_buffer ""
				}
			} elseif {$mode == $STRING} {
				if {[string compare $ch ","] == 0} {
					lappend cells $cell_buffer
					set mode $POST_COMMA
				} elseif {[string is space $ch]} {
					set space_buffer "${space_buffer}${ch}"
				} else {
					set cell_buffer  "${cell_buffer}${space_buffer}${ch}"
					set space_buffer ""
				}
			} elseif {$mode == $STRING_IN_QUOTES} {
				if {[string compare $ch "\""] == 0} {
					set mode $STRING_IN_QUOTES_FIRST_QUOTE
				} else {
					set cell_buffer "${cell_buffer}${ch}"
				}
			} elseif {$mode == $STRING_IN_QUOTES_FIRST_QUOTE} {
				if {[string compare $ch "\""] == 0} {
					set cell_buffer "${cell_buffer}${ch}"
					set mode $STRING_IN_QUOTES
				} else {
					lappend cells $cell_buffer
					
					if {[string compare $ch ","] == 0} {
						set mode $POST_COMMA
					} else {
						set mode $WAITING_FOR_COMMA
					}
				}
			} elseif {$mode == $WAITING_FOR_COMMA} {
				if {[string compare $ch ","] == 0} {
					set mode $POST_COMMA
				}
			} else {
				send_message error "CSV Scanning of file ${file} failed"
				return
			}
		}
		if {$mode == $POST_COMMA} {
			lappend cells ""
		} elseif {$mode == $STRING} {
			lappend cells $cell_buffer
		} elseif {$mode == $STRING_IN_QUOTES} {
			lappend cells $cell_buffer
		} elseif {$mode == $STRING_IN_QUOTES_FIRST_QUOTE} {
			lappend cells $cell_buffer
		} elseif {$mode == $WAITING_FOR_COMMA} {
			# do nothing
		}
		
		uplevel 1 $loop_body
	}
}

proc sanitize_direction {dir} {
   set dir [string tolower $dir]
   if {[string compare $dir "bidir"] == 0} {
	  set dir "inout"
   }
   return $dir
}


# format used for the A10 HPS
proc load_pin_to_atom_map {peripheral_ports_ref} {
	upvar 1 $peripheral_ports_ref        peripheral_ports
	
	set csv_file [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 hps "pin_to_atom_mapping.csv"]
	set count 0
	csv_foreach_row $csv_file cols {  ;# peripheral atom and location table
		incr count
		if {$count == 1} continue

		set peripheral_name      [string trim [lindex $cols 0]]
		set pin_name             [string trim [lindex $cols 1]]
		set input_signal         [string trim [lindex $cols 2]]
		set input_idx            [string trim [lindex $cols 3]]
		set output_signal        [string trim [lindex $cols 4]]
		set output_idx           [string trim [lindex $cols 5]]
		set oe_signal            [string trim [lindex $cols 6]]
		set oe_idx               [string trim [lindex $cols 7]]
		set modes                [string trim [lindex $cols 8]]
		
		foreach name {input output oe} {
			upvar 0 ${name}_signal tempsignal
			upvar 0 ${name}_idx    tempidx
			if {$tempsignal != ""} {
				set index 0
				if {$tempidx != ""} {
					set index $tempidx
				}
				set tempsignal "${tempsignal}(${index}:${index})"
			}
		}
		
		if {[info exists peripheral_ports($peripheral_name)] == 0} {
			set peripheral_ports($peripheral_name) [list]
		}

		lappend peripheral_ports($peripheral_name) $pin_name
		lappend peripheral_ports($peripheral_name) $input_signal  
		lappend peripheral_ports($peripheral_name) $output_signal
		lappend peripheral_ports($peripheral_name) $oe_signal
		lappend peripheral_ports($peripheral_name) $modes
	}
	
}


# TODO: 12.1 add support for variable widths and optional signals
proc load_modes {modes_by_peripheral_ref pins_by_peripheral_mode_ref} {
	upvar 1 $modes_by_peripheral_ref      modes_by_peripheral
	upvar 1 $pins_by_peripheral_mode_ref  pins_by_peripheral_mode
	
	set csv_file [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps altera_hps_arria_10 hps "modes.csv"]
	csv_foreach_row $csv_file cols {
		set peripheral [string trim [lindex $cols 0]]
		set mode       [string trim [lindex $cols 1]]
		set signal     [string toupper [string trim [lindex $cols 2]]]
		set width      [string trim [lindex $cols 3]]
		set optional   [string trim [lindex $cols 4]]

		if {[string compare [string index $peripheral 0] "\#"] == 0} {
			continue
		}

		# Add mode
		set key "${peripheral}${mode}"
		if {[info exists mode_set($key)] == 0} {
			set mode_set($key) 1
			if {[info exists modes_by_peripheral($peripheral)] == 0} {
				set modes_by_peripheral($peripheral) [list]
			}
			lappend modes_by_peripheral($peripheral) $mode
		}
		
		# Add pin to mode
		set final_signals [list $signal]
		if {$width != ""} {
			set valid_widths [list]
			
			# support range of widths (hyphen) and list of widths (commas)
			set parts [split $width ","]
			foreach part $parts {
				set part [string trim $part]
				if {[string is integer $part]} {
					lappend valid_widths $part
				} else {
					# if not an integer, it is probably a range
					set range [split $part "-"]
					set legal_range [expr {[llength range] != 2}]
					if {$legal_range} {
						set lo [lindex $range 0]
						set hi [lindex $range 1]
					}
					if {$legal_range == 0 || $lo > $hi} {
						send_message error "Illegal signal width for signal ${signal} of mode ${mode} on peripheral type ${peripheral}"
					}
					for {set i $lo} {$i <= $hi} {incr i} {
						lappend valid_widths $i
					}
				}
			}
			# For 12.0, use greatest width
			set valid_widths [lsort -integer -decreasing $valid_widths]
			if {[llength $valid_widths] > 0} {
				set final_width [lindex $valid_widths 0]
				
				if {$final_width < 1} {
					send_message error "Illegal signal width for signal ${signal} of mode ${mode} on peripheral type ${peripheral}"
				}
				
				set final_signals [list]
				for {set i 0} {$i < $final_width} {incr i} {
					lappend final_signals "${signal}${i}"
				}
			}
		}
		
		set key "${peripheral}.${mode}"
		if {[info exists pins_by_peripheral_mode($key)] == 0} {
			set pins_by_peripheral_mode($key) [list]
		}
		foreach final_signal $final_signals {
			lappend pins_by_peripheral_mode($key) $final_signal
		}
	}
}


proc adjust_pin_muxing_with_exceptions {pin_muxing_peripherals_ref} {
	upvar 1 $pin_muxing_peripherals_ref pin_muxing_peripherals
	
	set exception_callbacks {
		adjust_pin_muxing_with_emac_i2c_exception
	}
	
	foreach callback $exception_callbacks {
		$callback pin_muxing_peripherals
	}
}

################################################################################
# Looks for situations where EMAC can use I2C instead of MDIO
# -Adds modes to EMAC for using the I2C
#   -These modes do not include the MDIO/MDC pins
# -Adds modes to I2C when EMAC is using it
# 
proc adjust_pin_muxing_with_emac_i2c_exception {pin_muxing_peripherals_ref} {
################################################################################
	upvar 1 $pin_muxing_peripherals_ref pin_muxing_peripherals

	array set emac_signals_of_interest {"MDIO" 1 "MDC" 1}
	array set i2c_signals_of_interest  {"SDA"  1 "SCL" 1}

	# array set i2c_set  {}
	# array set emac_set {}
	foreach peripheral_name [list_peripheral_names] {
		if {[string match *I2C* $peripheral_name]} {
			set i2c_set($peripheral_name) 1
		} elseif {[string match *EMAC* $peripheral_name]} {
			set emac_set($peripheral_name) 1
		}
	}

	# Find all unique pin sets that use I2C
	select_signals pin_muxing_peripherals i2c_signals_of_interest\
		[array names i2c_set] i2c_pin_keys i2c_name_by_pin_key i2c_pinset_by_pin_key {}
	
	# find pins where I2C can replace MDIO in EMACs
	foreach emac_name [array names emac_set] {
		funset emac
		array set emac $pin_muxing_peripherals($emac_name)
		funset pin_sets
		array set pin_sets $emac(pin_sets)
		funset signals_by_mode
		array set signals_by_mode $emac(signals_by_mode)
		
		funset emac_pin_keys
		funset emac_name_by_pin_key
		funset emac_pinset_by_pin_key
		funset emac_modes_by_pin_key
		select_signals pin_muxing_peripherals emac_signals_of_interest\
			[list $emac_name] emac_pin_keys emac_name_by_pin_key emac_pinset_by_pin_key emac_modes_by_pin_key
		
		foreach pin_key [array names emac_pin_keys] {
			# find an i2c that uses compatible pins
			if {![info exists i2c_pin_keys($pin_key)]} {
				continue
			}
			
			set i2c_name $i2c_name_by_pin_key($pin_key)

			funset pin_set
			set pin_set_name $emac_pinset_by_pin_key($pin_key)
			array set pin_set $pin_sets($pin_set_name)

			# create derivative modes
			foreach mode $emac_modes_by_pin_key($pin_key) {
				#				if {[info exists affected_modes($mode)]} {}
				set new_mode "${mode} with ${i2c_name}"
				
				set new_mode_signals [list]
				foreach signal $signals_by_mode($mode) {
					if {![info exists emac_signals_of_interest($signal)]} {
						lappend new_mode_signals $signal
					}
				}
				
				lappend pin_set(valid_modes) $new_mode
				set signals_by_mode($new_mode) $new_mode_signals
			}

			# add new mode to i2c, for a specific pinset
			set i2c_pin_set_name $i2c_pinset_by_pin_key($pin_key)
			set new_mode "Used by ${emac_name}"
			funset i2c
			array set i2c $pin_muxing_peripherals($i2c_name)
			funset i2c_pin_sets
			array set i2c_pin_sets $i2c(pin_sets)
			funset i2c_pin_set
			array set i2c_pin_set $i2c_pin_sets($i2c_pin_set_name)
			lappend   i2c_pin_set(valid_modes) $new_mode
			set i2c_pin_sets($i2c_pin_set_name) [array get i2c_pin_set]
			set i2c(pin_sets) [array get i2c_pin_sets]
			funset    i2c_signals_by_mode
			array set i2c_signals_by_mode $i2c(signals_by_mode)
			set template $i2c_signals_by_mode(I2C)
			set i2c_signals_by_mode($new_mode) $template
			set i2c(signals_by_mode) [array get i2c_signals_by_mode]
			set pin_muxing_peripherals($i2c_name) [array get i2c]
			
			set pin_set(linked_peripheral)         $i2c_name
			set pin_set(linked_peripheral_pin_set) $i2c_pin_set_name
			set pin_set(linked_peripheral_mode)    $new_mode
			
			set pin_sets($pin_set_name) [array get pin_set]
		}
		
		# update modes in data structure
		set emac(signals_by_mode) [array get signals_by_mode]
		set emac(pin_sets)        [array get pin_sets]
		set pin_muxing_peripherals($emac_name) [array get emac]
	}
}

proc select_signals {pin_muxing_peripherals_ref
					 signals_of_interest_set_ref
					 peripheral_names
					 pin_keys_out_ref
					 peripheral_by_pin_key_out_ref
					 pin_set_by_pin_key_out_ref
					 modes_by_pin_key_out_ref
				 } {
	upvar 1 $pin_muxing_peripherals_ref    pin_muxing_peripherals
	upvar 1 $signals_of_interest_set_ref   signals_of_interest_set
	upvar 1 $pin_keys_out_ref              pin_keys_out
	upvar 1 $peripheral_by_pin_key_out_ref peripheral_by_pin_key_out
	upvar 1 $pin_set_by_pin_key_out_ref    pin_set_by_pin_key_out
	if {$modes_by_pin_key_out_ref != ""} {
		upvar 1 $modes_by_pin_key_out_ref  modes_by_pin_key_out
	}
	
	foreach peripheral_name $peripheral_names {
		array set peripheral $pin_muxing_peripherals($peripheral_name)
		
		funset modes_of_interest_set
		funset found_signals_of_interest_set
		foreach {mode signals} $peripheral(signals_by_mode) {
			foreach signal $signals {
				if {[info exist signals_of_interest_set($signal)]} {
					set found_signals_of_interest_set($signal) 1
				}
			}
			if {[array size found_signals_of_interest_set] ==
				[array size signals_of_interest_set]} {
				
				set modes_of_interest_set($mode) 1
			}
		}
		
		funset pin_sets
		array set pin_sets $peripheral(pin_sets)
		
		foreach pin_set_name [array names pin_sets] {
			funset pin_set
			array set pin_set $pin_sets($pin_set_name)
			
			# does it have the signals we care about?
			set interesting 0
			set matched_modes [list]
			foreach mode $pin_set(valid_modes) {
				if {[info exists modes_of_interest_set($mode)]} {
					lappend matched_modes $mode
				}
			}
			if {[llength $matched_modes] == 0} {
				continue
			}
			
			# make a key
			set unsorted_pins [list]
			foreach signal $pin_set(signals) pin $pin_set(pins) {
				if {[info exists signals_of_interest_set($signal)]} {
					lappend unsorted_pins $pin
				}
			}
			set sorted_pins [lsort -increasing -ascii $unsorted_pins]
			set pin_key [join $sorted_pins ","]
			
			set pin_keys_out($pin_key)              1
			set peripheral_by_pin_key_out($pin_key) $peripheral_name
			set pin_set_by_pin_key_out($pin_key)    $pin_set_name
			set modes_by_pin_key_out($pin_key)      $matched_modes
		}
	}
}

proc add_files_to_simulation_fileset {allInterfaceInfos} {
   # function: add hdl files to be included into simulation fileset
   # input:    requires the top level value to the 'interfaces' key from the tcl data structure
   
   clear_array interfaces
   array set interfaces $allInterfaceInfos
   set interfaceNames $interfaces(@orderednames)
   
   # check the bfm to include
   set include_axi_bfm 0
   foreach interfaceName $interfaceNames {
	  clear_array interfaceInfos
	  array set interfaceInfos $interfaces($interfaceName)

	  set type $interfaceInfos(type)
	  if {[string equal $type "axi"]} {
	     set include_axi_bfm 1
	  }
   }
   
   set HDL_LIB_DIR      "$::env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification"
   set MENTOR_VIP_DIR   "$::env(QUARTUS_ROOTDIR)/../ip/altera/mentor_vip_ae"
   
   add_fileset_file verbosity_pkg.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/lib/verbosity_pkg.sv
   add_fileset_file avalon_utilities_pkg.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/lib/avalon_utilities_pkg.sv
   add_fileset_file avalon_mm_pkg.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/lib/avalon_mm_pkg.sv
   add_fileset_file altera_avalon_mm_slave_bfm.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/altera_avalon_mm_slave_bfm/altera_avalon_mm_slave_bfm.sv
   
   if {$include_axi_bfm} {
	  add_fileset_file questa_mvc_svapi.svh SYSTEM_VERILOG PATH $MENTOR_VIP_DIR/common/questa_mvc_svapi.svh
	  add_fileset_file mgc_common_axi.sv SYSTEM_VERILOG PATH $MENTOR_VIP_DIR/axi3/bfm/mgc_common_axi.sv
	  add_fileset_file mgc_axi_master.sv SYSTEM_VERILOG PATH $MENTOR_VIP_DIR/axi3/bfm/mgc_axi_master.sv
	  add_fileset_file mgc_axi_slave.sv SYSTEM_VERILOG PATH $MENTOR_VIP_DIR/axi3/bfm/mgc_axi_slave.sv   
   }
   
   add_fileset_file altera_avalon_interrupt_sink.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/altera_avalon_interrupt_sink/altera_avalon_interrupt_sink.sv
   add_fileset_file altera_avalon_clock_source.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/altera_avalon_clock_source/altera_avalon_clock_source.sv
   add_fileset_file altera_avalon_reset_source.sv SYSTEM_VERILOG PATH $HDL_LIB_DIR/altera_avalon_reset_source/altera_avalon_reset_source.sv
}

proc create_conduit_bfms {allInterfaceInfos outputName} {
   # function: to terp one conduit bfm per conduit or reset input interface
   # input:    requires the top level value to the 'interfaces' key from the tcl data structure
   #           and the component's dynamic module name
   
   clear_array interfaces
   array set interfaces $allInterfaceInfos
   set interfaceNames $interfaces(@orderednames) 
   
   foreach interfaceName $interfaceNames {
	  clear_array interfaceInfos
	  array set interfaceInfos $interfaces($interfaceName)

	  set type $interfaceInfos(type)
	  set direction $interfaceInfos(direction)
	        
	  # generate in a procedure
	  if {[is_to_be_connected_to_conduit_bfm $type $direction]} {
	     set clocked_conduit [is_clocked_conduit interfaceInfos]
	     
	     clear_array signals
	     array set signals $interfaceInfos(signals)
	     set signalNames $signals(@orderednames)
	     set signalRoleWidthDir ""
	     foreach signalName $signalNames {
	        clear_array signalInfos
	        array set signalInfos  $signals($signalName)
	        
	        set signalRole   $signalName
	        set signalDir    $signalInfos(direction)
	        set signalWidth  $signalInfos(width)
	        
	        if {[string equal $signalRoleWidthDir ""]} {
	           set signalRoleWidthDir "${signalRole}:${signalWidth}:${signalDir}"
	        } else {
	           set signalRoleWidthDir "${signalRoleWidthDir},${signalRole}:${signalWidth}:${signalDir}"
	        }
	     }
	     
	     # setting up variables to do terp         
	     set HDL_LIB_DIR "$::env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification"
	     set templateFile [read [open "${HDL_LIB_DIR}/altera_conduit_bfm/altera_conduit_bfm.v.terp" r]]
	     
	     set params(output_name) ${outputName}_${interfaceName}
	     set params(rolemap)     $signalRoleWidthDir
	     set params(clocked)     $clocked_conduit
	     
	     do_terp $templateFile params
	  }
   }
}

proc get_bfm {interfaceType interfaceDirection} {
   # function: to determine which bfm class to be use for the interface in the HPS simulation model
   # input:    need to provide qsys's interface type and direction. 
   #           these information can be found in each of the interfaces key
   #           in the tcl data structure
   # returns:  the bfm component class
   
   set interfaceType       [string tolower $interfaceType]
   set interfaceDirection  [string tolower $interfaceDirection]

   set bfmList       [list axi_master mgc_axi_master]
   lappend bfmList   axi_slave mgc_axi_slave
   lappend bfmList   avalon_slave altera_avalon_mm_slave_bfm
   lappend bfmList   interrupt_receiver altera_avalon_interrupt_sink
   lappend bfmList   clock_output altera_avalon_clock_source
   lappend bfmList   reset_output altera_avalon_reset_source
   
   array set bfmTable $bfmList
   set key ${interfaceType}_${interfaceDirection}
   if {[info exists bfmTable($key)]} {
	  return $bfmTable($key)
   } else {
	  return -code continue
   }
}

proc get_bfm_ports {bfm} {
   # function: to get list of port names and port roles of a bfm class
   # input:    bfm component class
   # returns:  nested list of the bfm class's port role and port name
   
   set bfmTypePortsList       [list mgc_axi_master {clk ACLK reset_n ARESETn bready BREADY arready ARREADY arid ARID awprot AWPROT \
	     wdata WDATA arburst ARBURST arcache ARCACHE awaddr AWADDR awvalid AWVALID arlock ARLOCK rready RREADY arsize ARSIZE bresp BRESP \
	     awuser AWUSER bid BID arlen ARLEN wvalid WVALID awlen AWLEN arprot ARPROT rid RID rdata RDATA awid AWID wlast WLAST araddr ARADDR \
	     bvalid BVALID awready AWREADY arvalid ARVALID aruser ARUSER wstrb WSTRB awburst AWBURST awcache AWCACHE wready WREADY rvalid RVALID \
	     awlock AWLOCK rlast RLAST wid WID awsize AWSIZE rresp RRESP}]
   lappend bfmTypePortsList   mgc_axi_slave {clk ACLK reset_n ARESETn bready BREADY arready ARREADY arid ARID awprot AWPROT wdata \
	  WDATA arburst ARBURST arcache ARCACHE awaddr AWADDR awvalid AWVALID arlock ARLOCK rready RREADY arsize ARSIZE bresp BRESP awuser AWUSER \
	  bid BID arlen ARLEN wvalid WVALID awlen AWLEN arprot ARPROT rid RID rdata RDATA awid AWID wlast WLAST araddr ARADDR bvalid BVALID \
	  awready AWREADY arvalid ARVALID aruser ARUSER wstrb WSTRB awburst AWBURST awcache AWCACHE wready WREADY rvalid RVALID awlock AWLOCK \
	  rlast RLAST wid WID awsize AWSIZE rresp RRESP}
   lappend bfmTypePortsList   altera_avalon_mm_slave_bfm {clk clk reset reset waitrequest avs_waitrequest readdatavalid avs_readdatavalid \
	  readdata avs_readdata write avs_write read avs_read address avs_address byteenable avs_byteenable burstcount avs_burstcount \
	  beginbursttransfer avs_beginbursttransfer begintransfer avs_begintransfer writedata avs_writedata arbiterlock avs_arbiterlock \
	  lock avs_lock debugaccess avs_debugaccess transactionid avs_transactionid readresponse avs_readresponse readid avs_readid \
	  writeresponserequest avs_writeresponserequest writeresponsevalid avs_writeresponsevalid writeresponse avs_writeresponse \
	  writeid avs_writeid clken avs_clken}
   lappend bfmTypePortsList   altera_avalon_interrupt_sink {clk clk reset reset irq irq}
   lappend bfmTypePortsList   altera_avalon_clock_source {clk clk}
   lappend bfmTypePortsList   altera_avalon_reset_source {clk clk reset_n reset}
   
   array set bfmPortsTable $bfmTypePortsList
   return $bfmPortsTable($bfm)
}

proc get_bfm_port_direction {bfm portName} {
   # function: get bfm's individual port direction
   # input:    bfm component class, bfm port name
   # returns:  bfm port direction
   
   set mgc_axi_master [list ACLK input ARESETn input \
	     AWVALID output AWADDR output AWLEN output AWSIZE output AWBURST output AWLOCK output \
	     AWCACHE output AWPROT output AWID output AWREADY input AWUSER output \
	     ARVALID output ARADDR output ARLEN output ARSIZE output ARBURST output ARLOCK output \
	     ARCACHE output  ARPROT output ARID output ARREADY input ARUSER output \
	     RVALID input RLAST input RDATA input RRESP input RID input RREADY output \
	     WVALID output WLAST output WDATA output WSTRB output WID output WREADY input \
	     BVALID input BRESP input BID input BREADY output]
	     
   set mgc_axi_slave [list ACLK input ARESETn input \
	     AWVALID input AWADDR input AWLEN input AWSIZE input AWBURST input AWLOCK input \
	     AWCACHE input AWPROT input AWID input AWREADY output AWUSER input \
	     ARVALID input ARADDR input ARLEN input ARSIZE input ARBURST input ARLOCK input \
	     ARCACHE input  ARPROT input ARID input ARREADY output ARUSER input \
	     RVALID output RLAST output RDATA output RRESP output RID output RREADY input \
	     WVALID input WLAST input WDATA input WSTRB input WID input WREADY output \
	     BVALID output BRESP output BID output BREADY input]
	     
   set altera_avalon_mm_slave_bfm [list clk input reset input avs_waitrequest output avs_readdatavalid output \
	     avs_readdata output avs_write input avs_read input avs_address input avs_byteenable input \
	     avs_burstcount input avs_beginbursttransfer input avs_begintransfer input avs_writedata input \
	     avs_arbiterlock input avs_lock input avs_debugaccess input avs_transactionid input \
	     avs_readresponse output avs_readid output avs_writeresponserequest input \
	     avs_writeresponsevalid output avs_writeresponse output avs_writeid output avs_clken input]

   set altera_avalon_interrupt_sink [list clk input reset input irq input]
   set altera_avalon_clock_source [list clk output]
   set altera_avalon_reset_source [list clk input reset output]

   switch $bfm {
	  mgc_axi_master                {set bfmPort $mgc_axi_master}
	  mgc_axi_slave                 {set bfmPort $mgc_axi_slave}
	  altera_avalon_mm_slave_bfm    {set bfmPort $altera_avalon_mm_slave_bfm}
	  altera_avalon_interrupt_sink  {set bfmPort $altera_avalon_interrupt_sink}
	  altera_avalon_clock_source    {set bfmPort $altera_avalon_clock_source}
	  altera_avalon_reset_source    {set bfmPort $altera_avalon_reset_source}      
   }
   
   array set bfmPortDirection $bfmPort
   return $bfmPortDirection($portName)   
}

proc get_bfm_parameters {bfm} {
   # function: to get list of parameters of a bfm class
   # input:    bfm component class
   # returns:  nested list of the bfm class's parameter, parameter tag and parameter default value
   
   set bfmTypeParamsList       [list mgc_axi_master {{AXI_ID_WIDTH "id_width" 4} {AXI_ADDRESS_WIDTH "addr_width" 32} {AXI_WDATA_WIDTH data_width 32} {AXI_RDATA_WIDTH data_width 32}}]
   lappend bfmTypeParamsList   mgc_axi_slave {{AXI_ID_WIDTH "id_width" 4} {AXI_ADDRESS_WIDTH "addr_width" 32} {AXI_WDATA_WIDTH data_width 32} {AXI_RDATA_WIDTH data_width 32}}
   lappend bfmTypeParamsList   altera_avalon_mm_slave_bfm {{AV_ADDRESS_W "addr_width" 30} {AV_SYMBOL_W "" 8} {AV_NUMSYMBOLS data_width 4} \
	  {AV_BURSTCOUNT_W "" 8} {AV_READRESPONSE_W "" 8} {AV_WRITERESPONSE_W "" 8} {USE_READ "" 1} {USE_WRITE "" 1} {USE_ADDRESS "" 1} \
	  {USE_BYTE_ENABLE "" 1} {USE_BURSTCOUNT "" 1} {USE_READ_DATA "" 1} {USE_READ_DATA_VALID "" 1} {USE_WRITE_DATA "" 1} \
	  {USE_BEGIN_TRANSFER "" 0} {USE_BEGIN_BURST_TRANSFER "" 0} {USE_WAIT_REQUEST "" 1} {USE_ARBITERLOCK "" 0} {USE_LOCK "" 0} \
	  {USE_DEBUGACCESS "" 0} {USE_TRANSACTIONID "" 0} {USE_WRITERESPONSE "" 0} {USE_READRESPONSE "" 0} {USE_CLKEN "" 0} \
	  {AV_MAX_PENDING_READS "" 50} {AV_FIX_READ_LATENCY "" 0} {AV_BURST_LINEWRAP  "" 0} {AV_BURST_BNDR_ONLY "" 0} \
	  {AV_READ_WAIT_TIME "" 0} {AV_WRITE_WAIT_TIME "" 0} {REGISTER_WAITREQUEST "" 0} {AV_REGISTERINCOMINGSIGNALS "" 0}}
   lappend bfmTypeParamsList   altera_avalon_interrupt_sink {{ASSERT_HIGH_IRQ "" 1} {AV_IRQ_W "" 32} {ASYNCHRONOUS_INTERRUPT "" 1}}
   lappend bfmTypeParamsList   altera_avalon_clock_source {{CLOCK_RATE "clock_rate" 100}}
   lappend bfmTypeParamsList   altera_avalon_reset_source {{ASSERT_HIGH_RESET "reset_polarity" 0} {INITIAL_RESET_CYCLES "" 0}}
	
   array set bfmParamsTable $bfmTypeParamsList
   return $bfmParamsTable($bfm)
}

proc expose_border {instance_name interfaces_str} {
	array set interfaces $interfaces_str
	foreach name $interfaces([ORDERED_NAMES]) {
		funset interface
		array set interface $interfaces($name)
		if { [info exists interface([HDL_ONLY])] == 0 } {
			if { [info exists interface([NO_EXPORT])] == 0 || $interface([NO_EXPORT]) == 0} {
				set type $interface(type)
				set direction $interface(direction)
				
				# only elaborate interfaces w/ at least one non-terminated port		
				set interface_exists 0
				set port_map [list]
				funset signals
				array set signals $interface(signals)
				foreach signal_name $signals([ORDERED_NAMES]) {
					funset signal
					array set signal $signals($signal_name)
					if {[is_port_terminated signal] == 0} {
						lappend port_map $signal_name $signal_name
						set interface_exists 1
					}
				}
				
				if {$interface_exists} {
					add_interface          $name $type $direction
					set_interface_property $name export_of "${instance_name}.${name}"
					
					# Expose port names as if we are not composed
					set_interface_property $name port_name_map $port_map
				}
			}
		}
	}
}

######################################
# Each interface elaborated by an instance is exported
# and given the assignment to auto-export to the top of
# the top-level system.
# Note: this will not work until http://fogbugz/default.asp?36266
#       is fixed.
#
proc expose_border_to_the_top {instance_name} {
######################################
	set interfaces [get_instance_interfaces $instance_name]
	foreach interface $interfaces {
		set type      [get_instance_interface_property $instance_name $interface type]
		set direction [get_instance_interface_property $instance_name $interface direction]

		set interface_exists 0
		set port_map [list]
		set ports     [get_instance_interface_ports    $instance_name $interface]
		foreach port $ports {
			lappend port_map $port $port
			set interface_exists 1
		}
		if {$interface_exists} {
			add_interface          $interface $type $direction
			set_interface_property $interface  export_of "${instance_name}.${interface}"
			
			# Expose port names as if we are not composed
			set_interface_property $name port_name_map $port_map
			
			# and make it float to the top
			set_interface_assignment $interface "qsys.ui.export_name" $interface
		}
	}
}

proc is_port_terminated {var_name} {
	upvar 1 $var_name signal
	array set properties $signal(properties)

	if {[info exists properties([TERMINATION])]} {
		if {[string compare $properties([TERMINATION]) [TRUE]] == 0} {
			return 1
		}
	}
	return 0
}

proc is_to_be_connected_to_conduit_bfm { interfaceType interfaceDirection } {
   set interfaceType      [string tolower $interfaceType]
   set interfaceDirection [string tolower $interfaceDirection]
   
   return [expr [string equal $interfaceType "conduit"]\
	  || [string equal ${interfaceType}_${interfaceDirection} "reset_input"]]
}

proc do_terp {templateFile paramsArrayName} {
   upvar 1 $paramsArrayName params

   set result [ altera_terp ${templateFile} params ]
   add_fileset_file $params(output_name).sv SYSTEM_VERILOG TEXT ${result}
}

proc is_clocked_conduit {interfaceArrayName} {
   upvar 1 $interfaceArrayName interfaceInfos
   
   array set propertiesArray $interfaceInfos(properties)
   if {[info exist propertiesArray(associatedClock)]} {
	  return 1
   } else {
	  return 0   
   }
}

proc get_port_role {signalInfo} {
   return [lindex [lindex [lindex $signalInfo 2] 0] 0]
}

proc get_port_name {signalInfo} {
   return [lindex [lindex [lindex $signalInfo 2] 0] 1]
}

proc get_clock_rate {allInterfacesArrayName interfaceName} {
   # provide the name of array that contains all interfaces information and the interface name
   # returns clock frequency in MHz
   upvar 1 $allInterfacesArrayName allInterfacesArray
   
   clear_array interfaceInfo
   array set interfaceInfo $allInterfacesArray($interfaceName)
   
   clear_array interfaceProperty
   array set interfaceProperty $interfaceInfo(properties)

   set clockRate ""
   if {[info exist interfaceProperty(clockRate)]} {
	  set clockRate $interfaceProperty(clockRate)
	  set clockRate [expr $clockRate/1000000]
   }   
   return $clockRate
}

# http://wiki.tcl.tk/12276
# Note: jacl doesn't seem to support -command on this one when there is more than one element
proc lsort-indices args {
	set unsortedList [lindex $args end]
	set switches [lrange $args 0 end-1]
	set pairs {}
	set i -1
	foreach el $unsortedList {
		lappend pairs [list [incr i] $el]
	}
	set result {}
	foreach el [eval lsort $switches [list -index 1 $pairs]] {
		lappend result [lindex $el 0]
	}
	set result
}

# TODO: remove when using ctcl
proc lreverse {l} {
	set result [list]
	foreach element $l {
		set result [linsert $result 0 $element]
	}
	return $result
}

# TODO: remove when using ctcl
proc lassign {l args} {
	set length [llength $args]
	for {set i 0} {$i < $length} {incr i} {
		set ref [lindex $args $i]
		upvar 1 $ref var
		set var [lindex $l $i]
	}
}

# TODO: remove when using ctcl
proc lassign_trimmed {l args} {
	uplevel 1 "lassign \[list $l\] $args"
	foreach arg $args {
		upvar 1 $arg my_arg
		set my_arg [string trim $my_arg]
	}
}

######################################
# Alias a namespac var with an available local name.
# Useful for aliasing arrays where the namespace-qualified path contains variables.
# e.g. { namespace_alias ::a::$var_name var
#        set str $var(key)
#      }
# instead of 
#      { variable ::a::$var_name
#        set str $$var_name(key)   ;# This doesn't work!
#      }
proc namespace_alias {qual_name alias} {
######################################
	uplevel upvar 0 $qual_name $alias
}

######################################
# Converts from Hz to period in ns.
# Does not check for a frequency of 0.
#
proc frequency_to_period {freq} {
######################################
	return [expr {1.0 / $freq * 1000000000}]
}

################################################################
# Adds a clock to the sdc file if the frequency is valid. 
#
proc add_clock_constraint_if_valid {freq pin_pattern} {
################################################################
	if {$freq != 0} {
		fpga_interfaces::add_raw_sdc_constraint [format [SDC_CREATE_CLOCK] [frequency_to_period $freq] $pin_pattern]
	}
}

################################################################
# Returns 1 if peripheral is indexed
#
proc is_peripheral_one_of_many {peripheral_name} {
################################################################
	set length [string length $peripheral_name]
	set last_char [string index $peripheral_name [expr {$length - 1}]]
	return [string is integer $last_char]
}

################################################################
# Returns the peripheral index
#
proc get_peripheral_index {peripheral_name} {
################################################################
	set index_string ""
	set length [string length $peripheral_name]
	set last_char_index [expr {$length - 1}]
	for {set i $last_char_index} {$i >= 0} {incr i -1} {
		set char [string index $peripheral_name $i]
		if {[string is integer $char]} {
			set index_string "${char}${index_string}"
		} else {
			break
		}
	}
	# case 188708 fix the I2C emac. 
	# for location reference, look the \\p4\quartus\devices\nightfury\family\blc\block_data\hps\hps_block.blc
	if { [string first "I2CEMAC" $peripheral_name] != -1 } { 
		set index_string [ expr $index_string + 2 ]
	}
	return $index_string
}

#####################################################################
#
# Returns true if peripheral is available to FPGA.
# Parameters: * peripheral: name of a VALID peripheral
#
proc peripheral_connects_to_fpga {peripheral} {
#####################################################################
	if {[string compare -nocase $peripheral "trace"] == 0} {
		return 0
	}
	return 1
}

################################################################
# Returns the generic atom name for a given HPS peripheral.
#
proc hps_io_peripheral_to_generic_atom_name {peripheral} {
################################################################
	array set hps_io_peri_to_atom {
		EMAC0  hps_peripheral_emac
		EMAC1  hps_peripheral_emac
		EMAC2  hps_peripheral_emac
		NAND   hps_peripheral_nand
		QSPI   hps_peripheral_qspi
		SDMMC  hps_peripheral_sdmmc
		USB0   hps_peripheral_usb
		USB1   hps_peripheral_usb
		SPIM0  hps_peripheral_spi_master
		SPIM1  hps_peripheral_spi_master
		SPIS0  hps_peripheral_spi_slave
		SPIS1  hps_peripheral_spi_slave
		UART0  hps_peripheral_uart
		UART1  hps_peripheral_uart
		I2C0   hps_peripheral_i2c
		I2C1   hps_peripheral_i2c
		I2CEMAC0 hps_peripheral_i2c
		I2CEMAC1 hps_peripheral_i2c
		I2CEMAC2 hps_peripheral_i2c
		GPIO   hps_peripheral_gpio
		TRACE  hps_peripheral_tpiu_trace
		CM     hps_peripheral_pll_clk
	}
	set generic_atom_name $hps_io_peri_to_atom($peripheral)
	return $generic_atom_name
}


