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
# | $Header: //acds/rel/18.1std/ip/altera_parallel_flash_loader/altera_parallel_flash_loader_csv_reader.tcl#2 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1
package require csv
package require struct::matrix

set		csv_file "altera_parallel_flash_loader_parameter_values.csv"


# +-----------------------------------
# | Add and set parameters from csv
# +-----------------------------------
proc create_parameters	{csv_file} {

	set fid [open "$csv_file" r]			;# Open the CSV file with parameter definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set parameter [list]					;# List that holds the latest #parameter data

	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
    
		# Grab the first cell in the row and see if it defines a new #parameter
		set first_cell [string trim [mat get cell 0 $r]]
		if { [string match -nocase "PARAMETER" $first_cell] == 1 } {
			set parameter [mat get row $r]
			continue
		}

		# Add the parameter if a #parameter has been defined and the row has some info (not a blank line)
		set row [mat get row $r]
		if { [string match -nocase "" $parameter] == 0 && [string match -nocase "" [join $row {}]] == 0 } {
			add_parameter_from_csv_line $parameter $row
		}
	}

	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix
}


proc add_parameter_from_csv_line {parameter row} {
	# Add Parameter by grabing the name and type 
	set name_index 		[lsearch -nocase $parameter "PARAMETER"]
	set type_index 		[lsearch -nocase $parameter "TYPE"]
	set default_index	[lsearch -nocase $parameter "DEFAULT_VALUE"]
	if { $name_index != -1 && $type_index != -1 && $default_index != -1 } {
		set name_value		[lindex	$row	$name_index]
		set type_value		[lindex	$row	$type_index]
		set default_value	[lindex	$row	$default_index]
		add_parameter	$name_value	$type_value	$default_value
	} else {
		return
	}

    # Add any of the parameter properties that are defined
	for {set i 0} {$i < [llength $parameter]} {incr i} {
		# Grab the item on the parameter line and the row line
		set pval [string trim [lindex $parameter $i]]
		set rval [string trim [lindex $row $i]]

		# Set the parameter property if the property is not the name or type or default (handled above) or tab (handled below) or empty
		if {
			[string match -nocase "PARAMETER" $pval] == 0 &&
			[string match -nocase "TYPE" $pval] == 0 &&
			[string match -nocase "DEFAULT" $pval] == 0 &&
			[string match -nocase "TAB" $pval] == 0 &&
			[string match -nocase "UPDATE_CALLBACK" $pval] == 0 &&
			[string match -nocase "IS_HDL_PARAM" $pval] == 0 &&
			[string match -nocase "" $pval] == 0
		} then {
			if {$rval != ""} {
				set_parameter_property $name_value $pval $rval
			}
		}
	}

	set tab_index [lsearch -nocase $parameter "TAB"]
	if { $name_index != -1 && $tab_index != -1 } {
		set tab_value [lindex $row $tab_index]
		if { $tab_value != ""} {
			add_display_item $tab_value $name_value parameter
		}
	} else {
		return
	}
	
	set update_callback_index [lsearch -nocase $parameter "UPDATE_CALLBACK"]
	if { $update_callback_index != -1 && $tab_index != -1 } {
		set update_callback_value [lindex $row	$update_callback_index]
		if { $update_callback_value != "" } {
			set_parameter_update_callback	$name_value	$update_callback_value
		}
	}
}


# +-----------------------------------
# | Set parameter allowed_ranges from csv
# +-----------------------------------
proc set_allowed_ranges	{parameter	table_name	column_name	special} {
	global csv_file
	set fid [open "$csv_file" r]			;# Open the CSV file with table definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set line	 			[list]
	set header				0
	set error				0
	set col					0
	set special_col			0
	set value				""
	set	x					0
	
	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
		# Grab the first cell in the row and see if it defines a new #table
		set col_name	[string trim [mat get cell 0 $r]]
		set col_value	""
		
		if { [string match -nocase "#TABLE" $col_name] == 1 } {
			set	header		1
			set	line		[mat get row $r]
			set	col			[lsearch -nocase $line $column_name]
			set	special_col	[lsearch -nocase $line $special]
			if {$col == -1 } {
				set error 1
			} else {
				set error 0
			}
			
		} else {
			if {$header == 1 && $error == 0} {
				if { [string match -nocase $table_name $col_name] == 1 } {
					set col_value	[string trim [mat get cell $col $r]]
					if { $special_col != -1} {
						set special_value 	[string trim [mat get cell $special_col $r]]
								
						switch -nocase $special {
							
							"cfi_ini" {
								# For CFI FLASH DEVICE LIST
								set	cfi_ini_value	[get_quartus_ini_string		PGM_PFL_CFI_DEVICE	0]
								if {$special_value == -1 || (($special_value & $cfi_ini_value) != 0)} {
									append value " " $col_value
								}
							}
							
							"ini_value" {
								# For QSPI FLASH MFC
								set	mfc_ini_value	[get_quartus_ini_string		PGM_PFL_QSPI_MFC	0]
								if {$special_value == -1 || (($special_value & $mfc_ini_value) != 0)} {
									append value " " $col_value
								}
							}
							
							"support_flash" {
								# For NAND FLASH MFC
								set special_value [string map {"\(" ""} $special_value]
								set special_value [string map {"\)" ""} $special_value]
								if { $special_value > 0 } {
									append value " " $col_value
								}
							}
							
							"nand_supported" {
								# For NAND FLASH DEVICE LIST
								if { $special_value == "TRUE" } {
									append value " " $col_value
								}
							}
							
							"str" {
								# For SAFE MODE TABLE LIST
								if { $special_value != 0 } {
									append value " " $col_value
								}
							}
						}
					} else {
						switch -nocase $special {
							"nflash_data_width" {
								# For NAND FLASH DATA WIDTH LIST
								if {$x >= 1 && $x < 3} {
									append value " " $col_value
								}
								incr x
							}
							
							"decompressor_mode" {
								# For DECOMPRESSOR MODE
								lassign [update_decompression_control] count 
								if {$x < $count} {
									append value " " $col_value
								}
								incr x
							}
							
							"epcq_ini" {
								# For EPCQ/QSPI - check for hidden devices
								#set	is_epcq512		[get_quartus_ini_string	PGM_ALLOW_EPCQ512	"OFF"]
								#set	is_epcq1024		[get_quartus_ini_string	PGM_ALLOW_EPCQ1024	"OFF"]
                                set	is_epcq512		"ON"
								set	is_epcq1024		"ON"
								set temp			[string map {"\"" ""} $col_value]

								if { ([string match -nocase $temp "EPCQ 512 Mbit"] == 1) ||
										([string match -nocase $temp "QSPI 512 Mbit"] == 1) } {
									if { $is_epcq512 eq "ON"} {
										append value " " $col_value
									}
								} elseif { ([string match -nocase $temp "EPCQ 1024 Mbit"] == 1) ||
											([string match -nocase $temp "QSPI 1024 Mbit"] == 1) } {
									if { $is_epcq1024 eq "ON"} {
										append value " " $col_value
									}
								} else {
									append value " " $col_value
								}
							}

							"none" {
								append value " " $col_value
							}
						}
					}
				} 
			}
		}
	}
		
	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix

	set_parameter_property $parameter ALLOWED_RANGES $value
}


# +-----------------------------------
# | Set parameter allowed_ranges for ASC/QSPI/NAND flash devices from csv
# +-----------------------------------
proc set_flash_allowed_ranges	{parameter	table_name	column_name	special	supported_flash	backup_cur_flash} {
	global csv_file
	set fid [open "$csv_file" r]			;# Open the CSV file with table definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set line	 			[list]
	set header				0
	set error				0
	set col					0
	set special_col			0
	set	visible_col			0
	set value				""
	set	first_device		""
	set	x					0
	
	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
		# Grab the first cell in the row and see if it defines a new #table
		set col_name	[string trim [mat get cell 0 $r]]
		set col_value	""
		
		if { [string match -nocase "#TABLE" $col_name] == 1 } {
			set	header		1
			set	line		[mat get row $r]
			set	col			[lsearch -nocase $line $column_name]
			set	special_col	[lsearch -nocase $line $special]
			set	visible_col	[lsearch -nocase $line "visible"]
			if {$col == -1 } {
				set error 1
			} else {
				set error 0
			}
			
		} else {
			if {$header == 1 && $error == 0} {
				if { [string match -nocase $table_name $col_name] == 1 } {
					set col_value	[string trim [mat get cell $col $r]]
					if { $special_col != -1} {
						set special_value 	[string trim [mat get cell $special_col $r]]
						if	{$visible_col != -1} {
							set visible_value	[string trim [mat get cell $visible_col $r]]
						}
							
						switch -nocase $special {
							
							"byte_meg_size" {
								# For ASC/QSPI FLASH DEVICE LIST
								set	is_epcq512		"ON"
								set	is_epcq1024		"ON"
								if { [expr $supported_flash & $special_value] != 0 } {
									if { $special_value == 64 } {
										if { [string match -nocase $is_epcq512 "ON"] } {
											append value " " $col_value
											incr x
										}
									} elseif { $special_value == 128 } {
										if { [string match -nocase $is_epcq1024 "ON"] } {
											append value " " $col_value
											incr x
										}
									} else {
										append value " " $col_value
										incr x
									}
									if { $x == 1 } {
										# stores first device in list
										set first_device $col_value
									}
								}
							}
							
							"flash_byte_size" {
								# For NAND FLASH DEVICE LIST
								if { [expr $supported_flash & ($special_value >> 20)] != 0 } {
									if	{ $visible_col != -1 } {
										if { $visible_value == 1 } {
											append value " " $col_value
											incr x
										}
									} else {
										append value " " $col_value
										incr x
									}
									if { $x == 1 } {
										# stores first device in list
										set first_device $col_value
									}
								}
							}
						}
					} 
				} 
			}
		}
	}
		
	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix

	set_parameter_property $parameter ALLOWED_RANGES $value
	
	if { [lsearch -nocase $value $backup_cur_flash] == -1 } {
		# if currently selected flash density is no longer in the list, reselect the first in list
		set_parameter_value	$parameter		[string map {"\"" ""} $first_device]
	}
}


# +-----------------------------------
# | Get parameter values from csv based row value
# +-----------------------------------
proc get_value_based_on_row_value {table_name	column1_value	column2_name} {
	global csv_file
	set fid [open "$csv_file" r]			;# Open the CSV file with table definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set line	 			[list]
	set header				0
	set column2_value		""
	
	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
	
		# Grab the first cell in the row and see if it defines a new #table
		set col_name	[string trim [mat get cell 0 $r]]
		set	line		[string trim [mat get row $r]]
		if { [string match -nocase "#TABLE" $col_name] == 1 } {
			set	header			1
			set column2_index	[lsearch -nocase $line $column2_name]
		} else {
			if { $header == 1} {
				if { [string match -nocase $table_name $col_name] == 1 } {
					#search for values
					if { $column1_value != "" } {
						set line [string map {"\"" ""} $line]
						if { [lsearch -nocase $line $column1_value] != -1} {
							if { $column2_index != -1 } {
								set column2_value		[lindex	$line	$column2_index]
								if { [string match -nocase "support_flash" $column2_name] } {
									set column2_value	[expr $column2_value]
								}
							}
						}
					}
				} 
			}
		}
	}


	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix
	
	return $column2_value
}


# +-----------------------------------
# | Get parameter values from csv based row number
# +-----------------------------------
proc get_value_based_on_row_num {table_name	row_num	column2_name} {
	global csv_file
	set fid 		[open "$csv_file" r]	;# Open the CSV file with table definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set line	 			[list]
	set header				0
	set	count				0
	set column2_value		""
	
	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
	
		# Grab the first cell in the row and see if it defines a new #table
		set col_name	[string trim [mat get cell 0 $r]]
		set	line		[string trim [mat get row $r]]
		if { [string match -nocase "#TABLE" $col_name] == 1 } {
			set	header			1
			set column2_index	[lsearch -nocase $line $column2_name]
		} else {
			if { $header == 1} {
				if { [string match -nocase $table_name $col_name] == 1 } {
					if { $row_num == $count } {
						if { $column2_index != -1 } {
							set column2_value		[lindex	$line	$column2_index]
							if { [string match -nocase "support_flash" $column2_name] } {
								set column2_value	[expr $column2_value]
							}
						}
					}
					incr count
				} 
			}
		}
	}


	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix
	
	return $column2_value
}


# +-----------------------------------
# | Set default HDL Parameters to false
# +-----------------------------------
# Only set HDL parameters that only exist in certain conditions to false at the beginning
# Do not include fixed HDL parameters here
proc set_hdl_parameters_to_false	{} {
	set csv_file "altera_parallel_flash_loader_parameters.csv"
	set fid [open "$csv_file" r]			;# Open the CSV file with table definitions

	struct::matrix mat						;# Create a 2d matrix to hold the data
	csv::read2matrix $fid mat "," auto		;# Fill the matrix with the csv file data

	set line	 			[list]
	set header				0
	set error				0
	set col					0
	
	# Traverse each row in the csv file
	for {set r 0} {$r < [mat rows]} {incr r} {
		# Grab the first cell in the row and see if it defines a new #table
		set col_name	[string trim [mat get cell 0 $r]]
		set col_value	""
		if { [string match -nocase "PARAMETER" $col_name] == 1 } {
			set	header		1
			set	line		[mat get row $r]
			set	col			[lsearch -nocase $line "IS_HDL_PARAM"]
			if {$col == -1 } {
				set error 1
			} else {
				set error 0
			}
			
		} else {
			if {$header == 1 && $error == 0} {
				set parameter_value	[string trim [mat get cell 0 $r]]
				set col_value	[string trim [mat get cell $col $r]]
				if { ([string match -nocase $col_value "TRUE"] == 1) } {
					set_parameter_property		$parameter_value		HDL_PARAMETER		FALSE
				}
			}
		}
	}
		
	close $fid      ;# Close the csv file
	mat destroy     ;# Destroy the matrix
}