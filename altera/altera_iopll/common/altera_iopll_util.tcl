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


package provide altera_iopll::util 14.0

# ================================================================================================
# | UTIL
# | Namespace of miscellaneous procedures used by altera_iopll, altera_iopll_common related to...
# | - Physical parameter table
# | - Delaring parameters and ports
# | - Comparing and swapping parameters
# | - Rounding and trucating
# | - NDFB Mode
# | - Parsing Parameters
# | - Messaging
# | - Constructing Inputs to Computation Code
# | - Mapped Ranges: used by altera_iopll_common only. 
# ================================================================================================

namespace eval ::altera_iopll::util:: {
   # Namespace Variables
   variable mapped_parameters
   array set mapped_parameters [list]
   
   # Import functions into namespace
   if { [catch {package present qsys} result] } {
		namespace import ::altera_iopll::test::*
   }
   # Export functions (for altera_iopll_common)
   namespace export are_parameters_equal
   namespace export set_parameters_equal
   namespace export is_parameter_equal
   namespace export is_parameter_equal_default
   namespace export search_mapped_range
   namespace export search_qsys_mapped_range
   namespace export map_allowed_range
   namespace export are_actual_ranges_equal
   namespace export search_range_with_tolerance
}

# +===============================================================================================
# | RELATED TO PHYSICAL PARAMETER TABLE

proc altera_iopll::util::extract_header_and_data {table &header_out &data_out} {
    # Description:
    #  Returns the header and the data of the given table.
	# Inputs:
	#  table is a TCL table with a header and data. 

	upvar ${&header_out} header
	upvar ${&data_out} data
	
	set header [lindex $table 0]
	set data [lrange $table 1 end]
}

proc altera_iopll::util::replace_symbol_with_integer {input_string symbol integer} {
    # Description:
    #  Given a symbol and an integer, replaces all instances of the symbol with the integer
	# Inputs:
	#  eg. Symbol=#, integer=3, string=mystring# --> mystring3

	regsub -all "$symbol" $input_string $integer output_string
	return $output_string
}

proc altera_iopll::util::convert_range_to_list {input_range} {
    # Description:
    #  Given a list of ranges and integers, returns a list containing
    #  the expanded ranges. 
    #  Eg: 4,6-8,23,1 -> {1 4 6 7 8 23}
	# Inputs:
	#  Input range is a list of ranges and integers. Eg  4,6-8,23,1

	# Split the list into comma separated elements
	set result [split $input_range ,]
	set master_list [list]
	
	# Loop through each element and extract the indicated values
	foreach {key} $result {
		# Check if the current element is actually a range element (1-14)
		set retval [regexp -all {([0-9]+)-([0-9]+)} $key matches matchlow matchhigh]
		
		if {$retval == 0} {
			# If it's not a range element (contains no -)
			lappend master_list $key
		} elseif {$retval == 1} {
			# If it is a range element
			for {set i $matchlow} {$i <= $matchhigh} {incr i} {
				lappend master_list $i
			}
		} else {
			# If there were more than 1 match in this element (more than 1 hyphen) = error
			error "Invalid range"
		}
	}
	
	# Return the sorted list of integers with unique elements
	return [lsort -integer -unique $master_list]
}

proc altera_iopll::util::get_index_array_from_column_list { \
                                         header expected_columns &input_index_array} {
    # Description:
    #  Maps each expected column in 'expected_columns' to the index of the array's
    #  name in the header. 
	#  Do be careful, since unknown columns are ignored
    #
	# Inputs:
	#  Header is a list of column names. 
    #  Expected_columns is a list of possible column names and requirement statuses
	
	upvar ${&input_index_array} index_array
	
	foreach column $expected_columns {
		set index [lsearch $header $column]
		if { $index != -1 } {
			# Found the column in the header
			set index_array($column) $index
		}
	}
}


proc altera_iopll::util::extract_columns_as_array { \
                         key_name column_names data_table {instance_expansion true} } {
	# Description:
	#  Creates an array mapping a given value from data_table to other columns from that
    #  row. 
	# Inputs:
	#  Takes a data_table that includes a header as the first row. 
    #  Key name is an element in the header, and column_names is a list of other header
    #  elements that must not include key_name. 
	#     data_table:
	#      {A 	B 		C 	 	D}
	#      {dog	woof	bark 	mammal}
	#      {cat  purr 	meow 	mammal}
	#     key_name: B
	#     column_names: {D C}
    #
	#  returns:
	#    array(woof) -> {mammal bark}
	#    array(purr) -> {mammal meow}

	
	# Separate the data and header from in the input table
	extract_header_and_data $data_table header data_less_header
	
	# Using the "key_name" column as a key 
	# Find that column in the array
	set i_name [lsearch $header $key_name]
	set i_instances [lsearch $header INSTANCES]
	
	# Get the indices for all of the "value" columns identified by "column_names"
	# and construct another list (column_indices) to hold them
	foreach column_name $column_names {
		set current_column_index [lsearch $header $column_name]
		if {$current_column_index == -1 } {
		error "IE: column $column_name is not a column in input data table"
		}	
		lappend column_indeces $current_column_index
	}
	
	# Now go through each row in the table and extract the data from the columns of interest
	array set output_array {}
	foreach row $data_less_header {
		set key [lindex $row $i_name]

		set instances [lindex $row $i_instances]
		if {!$instance_expansion} {
			set $instances ""
		}
		if {$instances == ""} {
			set value_list [list]
			# Now extract the data from the desired columns
			foreach column_name $column_names column_index $column_indeces {
				lappend value_list $column_name
				lappend value_list [lindex $row $column_index]
			}
			set output_array($key) $value_list		
		} else {	

			set instances [::altera_iopll::util::convert_range_to_list $instances]
			foreach i $instances {
				set value_list [list]
				# Now extract the data from the desired columns
				foreach column_name $column_names column_index $column_indeces {
					lappend value_list $column_name
					set column_value [lindex $row $column_index]
					set column_value [::altera_iopll::util::replace_symbol_with_integer \
                                      $column_value # $i]	
					lappend value_list $column_value
				}				
				set instance_key [::altera_iopll::util::replace_symbol_with_integer \
                                  $key # $i]	
				set output_array($instance_key) $value_list	
			}
		}

	}
	
	return [array get output_array]
}


proc altera_iopll::util::extract_rows_given_duplicate_keys { \
                                      key_column key_values data_table with_header} {
	# Description:
	#  Given a full list, returns a smaller table (optionally with the header) 
    #  and all rows with matching key as rows row from the table
	#  Finds the row by: 
	#    given a column name, searches that column for "key_value" (may be a list of values)
	# Inputs:
	#  Data_table is a TCL table of values. It must have a header.

	
	# Separate header and data
	extract_header_and_data $data_table header data_less_header
	
	# Find the "key_column" in the array
	set i_key_column [lsearch $header $key_column]
	
	# Now get the rows of interest
	set output_table [list]
	if {$with_header} {
		lappend $output_table $header
	} 

	foreach key_value $key_values {
		# Get a list of all rows with the current key
		set list_of_rows [lsearch -all -index $i_key_column \
                          -inline $data_less_header $key_value]
		foreach row $list_of_rows {
			lappend output_table $row

		}
	}

	return $output_table

}


# +===============================================================================================
# | RELATED TO DECLARING PARAMETERS AND PORTS

proc altera_iopll::util::declare_hwtcl_parameters {parameters add_to_display} {
	# Description:
	#  Adds visible controls to the gui
	# Inputs:
	#  A list containing the parameters and their properties, with a header providing the 
	#  name of the property in each column
	#  The first few columns must contain some required parameters. The rest
	#  are any valid parameter types. 
	#  If the INSTANCES property is set, then multiple parameters are created
	#  with the same name terminated by a number. ex "gui ...0" "gui...1" ... up to 
	#  the value of instances
	
	
	# Separate the header and the data
	::altera_iopll::util::extract_header_and_data $parameters header data_less_header
	
	set expected_columns_a {NAME VALIDATION_CALLBACK DISPLAY_GROUP PARENT \
                            DISPLAY_GROUP INSTANCES TYPE}
	set expected_columns_b [get_parameter_properties]
	
	::altera_iopll::util::get_index_array_from_column_list $header \
                                     $expected_columns_a index_array_a
	::altera_iopll::util::get_index_array_from_column_list $header \
                                     $expected_columns_b index_array_b
	
	# Declare each row/parameter 
	foreach parameter_list $data_less_header {
	
		set name 	[lindex $parameter_list $index_array_a(NAME)]
		set type	[lindex $parameter_list $index_array_a(TYPE)] 
	
		if { [info exists index_array_a(PARENT)] } {
			set group	[lindex $parameter_list $index_array_a(PARENT)]
		} elseif { [info exists index_array_a(DISPLAY_GROUP)] } {
			set group	[lindex $parameter_list $index_array_a(DISPLAY_GROUP)]
		} else {
			set group ""
		}
		if { [info exists index_array_a(INSTANCES)] } {
			set instances [lindex $parameter_list $index_array_a(INSTANCES)]
		} else {
			set instances ""
		}

		if { [info exists index_array_a(VALIDATION_CALLBACK)] } {
			set update_callback  [lindex $parameter_list $index_array_a(VALIDATION_CALLBACK)]
		} else {
            set update_callback NOVAL
        }

		set instances [::altera_iopll::util::convert_range_to_list $instances]
		
		# Get the list of the other parameters
		# Now add the parameter to the gui (name changes depending on duplicity)
		if {$instances == ""} {
			add_parameter $name $type
            set_parameter_update_callback $name $update_callback $name
            set array_names [array names index_array_b]
			foreach param_name $array_names {
					set param_value [lindex $parameter_list $index_array_b($param_name)]
					set_parameter_property $name $param_name $param_value
			}
			if {$add_to_display} {
				add_display_item $group $name parameter		
			}
		} else { 
			foreach i $instances {
				set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                  $name # $i]

				add_parameter $instance_name $type
           
                set_parameter_update_callback $instance_name $update_callback $instance_name
				foreach param_name [array names index_array_b] {
						set param_value [lindex $parameter_list $index_array_b($param_name)]
						set param_value [::altera_iopll::util::replace_symbol_with_integer \
                                        $param_value # $i]
						set_parameter_property $instance_name $param_name $param_value
				}	
				if {$add_to_display} {
					set instance_group [::altera_iopll::util::replace_symbol_with_integer \
                                        $group # $i]
					add_display_item $instance_group $instance_name parameter	
				}
			}					
		}

	}

}	

proc altera_iopll::util::declare_hwtcl_display_items	{items} {
	# Description:
	#  Adds display items
	# Inputs:
	#  a list containing the display items and their parameters, with a header providing the 
	#  name of the parameter in each column
	#  If the INSTANCES property is set, then multiple parameters are created
	#  with the same name terminated by a number. ex "gui ...0" "gui...1" ... up to 
	#  the value of instances
	#

	# Get the header row and the data rows
	::altera_iopll::util::extract_header_and_data $items header items_less_header
	
	# Get the list of columns expected by this function
	set expected_columns_a {NAME PARENT TYPE ADDITIONALINFO INSTANCES}	
		
	# ... make another list for the expected columns for the call to 
	set expected_columns_b [get_display_item_properties]
		
	# Now go get the indeces for all of these
	::altera_iopll::util::get_index_array_from_column_list \
		$header \
		$expected_columns_a \
		index_array_a
	
	::altera_iopll::util::get_index_array_from_column_list \
		$header \
		$expected_columns_b \
		index_array_b
	
	# Get the order of the columns
	
	# Add each display item (row in the data section)
	foreach parameter_list $items_less_header {
		set display_group		[lindex $parameter_list $index_array_a(PARENT)]
		set name				[lindex $parameter_list $index_array_a(NAME)]
		set display_type 		[lindex $parameter_list $index_array_a(TYPE)]
		
		# Optional parameter
		if { [info exists index_array_a(ADDITIONALINFO)] } {
			set additional_info		[lindex $parameter_list $index_array_a(ADDITIONALINFO)]
		} else {
			set additional_info 	""
		}
		if { [info exists index_array_a(INSTANCES)] } {
			set instances 			[lindex $parameter_list $index_array_a(INSTANCES)]
		} else {
			set instances "" 
		}
		set instances [::altera_iopll::util::convert_range_to_list $instances]
		
		# If there is an instances column, then add multiple versions of this display item 
		if {$instances == ""} {
			add_display_item $display_group $name $display_type $additional_info
			
			foreach param_name [array names index_array_b] {
				set param_value [lindex $parameter_list $index_array_b($param_name)]
				set_display_item_property $name $param_name $param_value
			}
			
		} else {
			foreach i $instances {
				set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                   $name # $i]
				set instance_display_group [::altera_iopll::util::replace_symbol_with_integer \
                                           $display_group # $i]
				add_display_item $instance_display_group "$instance_name" \
                                  $display_type $additional_info
				foreach param_name [array names index_array_b] {
					set param_value [lindex $parameter_list $index_array_b($param_name)]
					set param_value [::altera_iopll::util::replace_symbol_with_integer \
                                    $param_value # $i]
					set_display_item_property $instance_name $param_name $param_value
				}
			}	
		}
	}	
}	

proc altera_iopll::util::declare_hwtcl_interfaces {interfaces_table} {
	# Description:
	#  Adds interfaces to the qsys module
	#
	# Inputs:
	#  Note: any columns not in the expected columns list will be ignored
	#  Only the following columns may be "instance-ized":
	#    NAME
	
	# Separate the interface data rows and the header row
	::altera_iopll::util::extract_header_and_data $interfaces_table header \
                                                  interfaces_less_header

	# Expected columns
	set expected_columns {NAME TYPE DIRECTION INSTANCES}
	
	::altera_iopll::util::get_index_array_from_column_list $header \
                                                  $expected_columns index_array
	
	# Declare each interface
	foreach interface_row $interfaces_less_header {
		set name 		[lindex $interface_row $index_array(NAME)]
		set type 		[lindex $interface_row $index_array(TYPE)]
		set direction 	[lindex $interface_row $index_array(DIRECTION)]
		switch $direction {
			"end" {
				set blockdiagram_direction "input"
			}
			"start" {
				set blockdiagram_direction "output"
			}
			default {
				set blockdiagram_direction ""
			}
		}
		
		# Optional columns
		if { [info exists index_array(INSTANCES)] } {
			set instances [lindex $interface_row $index_array(INSTANCES)]
			set instances [::altera_iopll::util::convert_range_to_list $instances]
		} else {
			set instances ""
		}
		
		# Add the interface(s)
		if {$instances == ""} {
			add_interface $name $type $direction
			set_interface_assignment $name ui.blockdiagram.direction $blockdiagram_direction
		} else {
			foreach i $instances {
				set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                   $name # $i]
				add_interface $instance_name $type $direction
				set_interface_assignment $instance_name ui.blockdiagram.direction \
                                   $blockdiagram_direction
			}
		}
		
		# Now add the interface's properties (contained in other columns)
		
		# Get the list of properties
		# Note that each interface type has it's own valid list of property types
		if {$instances == ""} {
			set expected_property_columns [get_interface_properties $name]
		} else {
			# Use the last value of instance name
			set expected_property_columns [get_interface_properties $instance_name]
		}
		
		::altera_iopll::util::get_index_array_from_column_list $header \
                $expected_property_columns property_index_array
		
		if {$instances == "" } {
			foreach property_name [array names property_index_array] {
				set property_value [lindex $interface_row $property_index_array($property_name)]
				set_interface_property $name $property_name $property_value
			}
		} else {
			foreach property_name [array names property_index_array] {
				set property_value [lindex $interface_row $property_index_array($property_name)]
				foreach i $instances {
					set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                       $name # $i]
					set_interface_property $instance_name $property_name $property_value
				}			
			}
		}
	
	}
	
}

proc altera_iopll::util::declare_hwtcl_ports {ports_table} {
	# Description:
	#  Adds ports to the qsys module
	# Inputs:
	#  Note: any columns not in the expected columns list will be ignored
	#  Only the following columns may be "instance-ized":
	#    NAME INSTANCE
	
	# Separate the interface data rows and the header row
	::altera_iopll::util::extract_header_and_data $ports_table header ports_less_header

	# Expected columns
	set expected_columns {NAME INTERFACE ROLE DIRECTION INSTANCES}
	set expected_property_columns [get_port_properties]
	
	::altera_iopll::util::get_index_array_from_column_list $header \
                                      $expected_columns index_array
	::altera_iopll::util::get_index_array_from_column_list $header \
                                      $expected_property_columns property_index_array
	
	# Declare each interface
	foreach ports_row $ports_less_header {
		
		# Required columns (retrieve value given column index)
		set name 		[lindex $ports_row $index_array(NAME)]
		set role		[lindex $ports_row $index_array(ROLE)]
		set interface 	[lindex $ports_row $index_array(INTERFACE)]
		set direction 	[lindex $ports_row $index_array(DIRECTION)]
		
		# Optional columns
		if { [info exists index_array(INSTANCES)] } {
			set instances [lindex $ports_row $index_array(INSTANCES)]
			set instances [::altera_iopll::util::convert_range_to_list $instances]
		} else {
			set instances ""
		}
		
		# Add the port(s)
		if {$instances == ""} {
			add_interface_port $interface $name $role $direction
		} else {
			foreach i $instances {
				set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                  $name # $i]
				set instance_interface [::altera_iopll::util::replace_symbol_with_integer \
                                        $interface # $i]
				add_interface_port $instance_interface $instance_name $role $direction
			}
		}
		
		# Now add the port's properties (contained in other columns)
		if {$instances == "" } {
			foreach property_name [array names property_index_array] {
				set property_value [lindex $ports_row $property_index_array($property_name)]
                if {$property_name eq "WIDTH_EXPR" && \
                    ![regexp {^([0-9]+)$} $property_value]} {
                   set property_value      [eval $property_value]
                }
				set_port_property $name $property_name $property_value
			}
		} else {
			foreach property_name [array names property_index_array] {
				set property_value [lindex $ports_row $property_index_array($property_name)]
				foreach i $instances {
					set instance_name [::altera_iopll::util::replace_symbol_with_integer \
                                      $name # $i]
					set_port_property $instance_name $property_name $property_value
				}			
			}
		}	
	}	
}

proc altera_iopll::util::declare_hwtcl_module {module_parameters_table} {
    # Description:
    #  Declares the pll module and sets its properties
	# Inputs:
	#  the namespace variable module_parameters_table consisting of
    #  a header row providing a name to each column
    #     Assumes all parameters are legal 
    #	  Assumes a header row exists

	# Separate the parameter rows and the header row
	::altera_iopll::util::extract_header_and_data $module_parameters_table \
                                                  header module_less_header

	set expected_columns $header
	
	::altera_iopll::util::get_index_array_from_column_list $header $expected_columns \
                                                           column_index_array
	# Set the parameters
	# Loop through each data row and set the module property
	foreach module $module_less_header {
		foreach parameter_name [array names column_index_array] {
			set parameter_value [lindex $module $column_index_array($parameter_name)]
			set_module_property	 $parameter_name $parameter_value
		}	
	}
}

proc altera_iopll::util::declare_hwtcl_filesets {file_sets} {
    # Description: Declares the file_sets for the pll module
    # Inputs: the namespace variable file_sets consisting of a list
    #	of filesets and their properties, with a header row providing the 
    #	names of the properties in each column
    #   Assumes all parameters are legal 
    #   Assumes a header row exists

	# Separate the parameter rows from the header row
	::altera_iopll::util::extract_header_and_data $file_sets header filesets_less_header
	
	# Validate the inputs 
	set expected_columns {NAME TYPE CALLBACK_FUNCTION}
	set expected_columns_prop [get_fileset_properties]
		
	::altera_iopll::util::get_index_array_from_column_list $header \
          $expected_columns column_index_array	
	::altera_iopll::util::get_index_array_from_column_list $header \
          $expected_columns_prop column_index_array_prop	
	
	# Loop through each data row and create the fileset
	foreach file_set $filesets_less_header {
		set name		[lindex $file_set $column_index_array(NAME)]
		set type		[lindex $file_set $column_index_array(TYPE)]
		set callback	[lindex $file_set $column_index_array(CALLBACK_FUNCTION)]
		add_fileset	$name	$type	$callback
		foreach param_name [array names column_index_array_prop] {
			set param_value [lindex $file_set $column_index_array_prop($param_name)]
			set_fileset_property $name $param_name $param_value
		}
	}
}

proc altera_iopll::util::get_altera_pll_ports {} {
	return [altera_pll_interfaces::get_altera_pll_ports_as_array]
}

proc altera_iopll::util::get_hdl_parameters {} {
	set family [get_parameter_value gui_device_family]
	return  [altera_pll_physical_parameters::get_parameter_list $family]
}

proc altera_iopll::util::get_debug_parameters {} {
	set family [get_parameter_value gui_device_family]
	return  [altera_pll_physical_parameters::get_debug_parameters_list $family]
}
proc altera_iopll::util::get_gui_debug_parameters {} {
	set family [get_parameter_value gui_device_family]
	return  [altera_pll_gui_params::get_gui_debug_parameters_list $family]
}

proc altera_iopll::util::get_enabled_interfaces {} {
	set interfaces [get_interfaces]
	
	foreach interface $interfaces {
		if {[get_interface_property	$interface ENABLED]} {
			lappend enabled_interfaces $interface 
		}
	}
	return $enabled_interfaces
}

# +==============================================================================================
# | RELATED TO COMPARING and SWAPPING PARAMETERS

proc altera_iopll::util::search_range_with_tolerance {range value decimals} {
    # Description: Returns the index of the value in the range, or the value
    #  in the range that is within the tolerance. 
	# Inputs: Range is list of doubles, value is double and decimals sets the
    #  tolerance level. 
	set rounded_range [round_to_n_decimals $range $decimals]
	set rounded_value [round_to_n_decimals $value $decimals]
	
	return [lsearch $rounded_range $rounded_value]
}

proc altera_iopll::util::set_to_corresponding_fp_value {param_name hp_param_name src_param_name src_hp_param_name} {
    # Description: Returns the index of the value in the range, or the value
    #  in the range that is within the tolerance. 
	# Inputs: Range is list of doubles, value is double and decimals sets the
    #  tolerance level.
    if { $src_param_name == "" } {
	set src_param_name param_name
    }
    if { $src_hp_param_name == "" } {
	set src_hp_param_name hp_param_name
    }

	set rounded_value [get_parameter_value $src_param_name]
	set rounded_list [get_parameter_property $src_param_name ALLOWED_RANGES]
    set fp_list [get_parameter_property $src_hp_param_name ALLOWED_RANGES]
    set index [lsearch $rounded_list $rounded_value]
    if {$index > -1} {
        set fp_value [lindex $fp_list $index]
	set_parameter_value $param_name $rounded_value
	set_parameter_value $hp_param_name $fp_value
    }
}

proc altera_iopll::util::is_parameter_equal {param val} {
    # Description: Returns true if param value is equal to val, false if not. 
	# Inputs: Param had better be a hwtcl parameter!
	set param_val [get_parameter_value $param]
	if {$param_val == $val} {
		return true
	} else {
		return false
	}
}

proc altera_iopll::util::is_parameter_equal_default {param} {
    # Description: Returns true if parameter value is equal to parameter default. 
	# Inputs: param had better be a hwtcl parameter!
	set default [get_parameter_property $param DEFAULT_VALUE]
	return [is_parameter_equal $param $default]
}

proc altera_iopll::util::set_parameters_equal {param1 param2} {
    # Description: Sets value of param1 to value of param2
	# Inputs: These better be hwtcl parameters!
	set val2 [get_parameter_value $param2]
	set_parameter_value $param1 $val2
}

proc altera_iopll::util::copy_physical_clock {a b} {
    # Description: Copies all the hwtcl parameters related to clockb to clocka
	# Inputs: a and b must be indexes of existing, enabled clocks
	altera_iopll::util::copy_parameters c_cnt_hi_div$a 				c_cnt_hi_div$b
	altera_iopll::util::copy_parameters c_cnt_lo_div$a 				c_cnt_lo_div$b
	altera_iopll::util::copy_parameters c_cnt_prst$a				c_cnt_prst$b
	altera_iopll::util::copy_parameters c_cnt_ph_mux_prst$a	 		c_cnt_ph_mux_prst$b
	altera_iopll::util::copy_parameters c_cnt_in_src$a				c_cnt_in_src$b
	altera_iopll::util::copy_parameters c_cnt_bypass_en$a 			c_cnt_bypass_en$b
	altera_iopll::util::copy_parameters c_cnt_odd_div_duty_en$a 	c_cnt_odd_div_duty_en$b
	altera_iopll::util::copy_parameters output_clock_frequency$a 	output_clock_frequency$b
	altera_iopll::util::copy_parameters phase_shift$a 				phase_shift$b
	altera_iopll::util::copy_parameters duty_cycle$a 				duty_cycle$b
}

proc altera_iopll::util::swap_physical_clock {a b} {
    # Description: Copies all the hwtcl parameters related to clockb to clocka and vice versa
	# Inputs: a and b must be indexes of existing clocks
	altera_iopll::util::swap_parameters c_cnt_hi_div$a 				c_cnt_hi_div$b
	altera_iopll::util::swap_parameters c_cnt_lo_div$a 				c_cnt_lo_div$b
	altera_iopll::util::swap_parameters c_cnt_prst$a				c_cnt_prst$b
	altera_iopll::util::swap_parameters c_cnt_ph_mux_prst$a	 		c_cnt_ph_mux_prst$b
	altera_iopll::util::swap_parameters c_cnt_in_src$a				c_cnt_in_src$b
	altera_iopll::util::swap_parameters c_cnt_bypass_en$a 			c_cnt_bypass_en$b
	altera_iopll::util::swap_parameters c_cnt_odd_div_duty_en$a 	c_cnt_odd_div_duty_en$b
	altera_iopll::util::swap_parameters output_clock_frequency$a 	output_clock_frequency$b
	altera_iopll::util::swap_parameters phase_shift$a 				phase_shift$b
	altera_iopll::util::swap_parameters duty_cycle$a 				duty_cycle$b
}

proc altera_iopll::util::copy_parameters {a b} {
    # Description: Sets all properties of param1 to properties of param2
	# Inputs: These better be hwtcl parameters!

	# Copy the value over
	set_parameter_value $b [get_parameter_value $a]
	
	# Copy all the properties over
	set property_list {ENABLED ALLOWED_RANGES}
	
	foreach property $property_list {
		set_parameter_property $b $property [get_parameter_property $a $property]
	}	
}

proc altera_iopll::util::swap_parameters {a b} {
    # Description: Sets all properties of param1 to properties of param2 and vice versa.
	# Inputs: These better be hwtcl parameters!

	# Get parameter a's value
	set temp [get_parameter_value $a]
	set_parameter_value $a [get_parameter_value $b]
	set_parameter_value $b $temp
	
	# Now repeat with ALL the properties
	set property_list {ENABLED ALLOWED_RANGES}
	foreach property $property_list {
		set temp [get_parameter_property $a $property]
		set_parameter_property $a $property [get_parameter_property $b $property]
		set_parameter_property $b $property $temp
	}
}


# +===============================================================================================
# | RELATED TO ROUNDING and TRUNCATING

proc altera_iopll::util::round_to_n_decimals {input_list n {keep_decimal true}} {
    # Description: Rounds elements of input_list to n decimal places, and returns new list.
	# Inputs: input_list is a list of numbers, n is an integer
	set rounded_list [list]
	foreach item $input_list {
		set rounded_num [format "%.${n}f" $item]
		if {$keep_decimal} {
			set double_version [expr {double($rounded_num)}]
			if {[string length $double_version] <= [string length $rounded_num]} {
				lappend rounded_list $double_version
			} else  {
				lappend rounded_list $rounded_num
			}
		} else {
			lappend rounded_list $rounded_num
		}	
	}
	return $rounded_list
}

proc altera_iopll::util::round_to_atom_precision {input_list} {
    # Description: Rounds elements of input_list to 6 decimal places.
	set n_decimals 6
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc altera_iopll::util::round_to_n_decimals_cut {input_list n} {
    # Description: Cuts elements of input_list down to n decimal places
	set n_decimals $n
	return [::altera_iopll::util::round_to_n_decimals $input_list $n false]
}

proc altera_iopll::util::round_freq {input_list} {
    # Description: Rounds elements of input_list to 6 decimal places. 
	set n_decimals 6
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc altera_iopll::util::round_phase {input_list} {
    # Description: Rounds elements of input_list to 1 decimal place.
	set n_decimals 1
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc altera_iopll::util::round_duty {input_list} {
    # Description: Rounds elements of input_list to 2 decimal places.
	set n_decimals 2
	return [::altera_iopll::util::round_to_n_decimals $input_list $n_decimals]
}

proc altera_iopll::util::truncate_frequency {param_val} {
    # Description: Rounds frequency, and prevents unreasonable values that could
    #   cause problems in qcl/pll code. 
    # Inputs: param_val is a number to be rounded
    set rounded_param_val [round_freq $param_val]

    # The frequency can't be less than 1 Hz
    if {$rounded_param_val <= 0} {
        return 0.000001
    } 

    # Frequency isn't going to be > 1THz
    if {$rounded_param_val > 1000000} {
        return [string range $rounded_param_val 0 6]
    }
    return $rounded_param_val

}

proc altera_iopll::util::truncate_phase {param_val} {
    # Description: Rounds phase, and prevents unreasonable values that could
    #   cause problems in qcl/pll code. 
    # Inputs: param_val is a number to be rounded
    set rounded_param_val [round_freq $param_val]

    # No reason for the phase to be this small.
    if {$rounded_param_val <= -10000000} {
        return [string range $rounded_param_val 0 8]
    } 

    # No reason for the phase to be this large. 
    if {$rounded_param_val > 10000000} {
        return [string range $rounded_param_val 0 7]
    }
    return $rounded_param_val
}

proc altera_iopll::util::truncate_duty {param_val} {
    # Description: Rounds duty, and prevents unreasonable values that could
    #   cause problems in qcl/pll code. 
    # Inputs: param_val is a number to be rounded
    set rounded_param_val [round_duty $param_val]

    # Duty can't be  < 0!
    if {$rounded_param_val < 0} {
        return 0.000001
    } 
    # Duty can't be > 100!
    if {$rounded_param_val > 100} {
        return 100
    }
    return $rounded_param_val
}

proc altera_iopll::util::truncate_degrees {param_val} {
    # Description: Rounds phase in degrees, and prevents unreasonable values that could
    #   cause problems in qcl/pll code.  
    # Inputs: param_val is a number to be rounded
    set rounded_param_val [round_phase $param_val]

    # The frequency shouldn't be  <-360
    if {$rounded_param_val < -360} {
        return -360
    } 
    # Frequency shouldn't be > 360
    if {$rounded_param_val > 360} {
        return 360
    }
    return $rounded_param_val
}

proc altera_iopll::util::truncate_counter {param_val} {
    # Description: Rounds counter value, and prevents unreasonable values that could
    #   cause problems in qcl/pll code.
    # Inputs: param_val is a number to be rounded
	set rounded_param_val [::altera_iopll::util::round_to_n_decimals $param_val 0]

    # The counter value must be positive
    if {$rounded_param_val < 1} {
        return 1
    } 
    # Frequency shouldn't be very large. 
    if {$rounded_param_val > 1000000} {
        return [string range $rounded_param_val 0 6]
    }
    return $rounded_param_val
}


# +==============================================================================================
# | RELATED TO NDFB MODE

proc altera_iopll::util::get_next_outclk_to_update {curr_outclk} {
    # Description: The outclk settings need to be validated in a particular order. 
    #   Return the next outclk after curr_outclk .
    #   Usually just curr_outclk + 1 unless NDFB mode is enabled. 
    # Inputs: Curr_outclk must be the index of a valid outclk.  
    set NDFB_mode             [get_parameter_value gui_use_NDFB_modes]
    set clock_to_comp         [get_parameter_value gui_clock_to_compensate] 

    if {$NDFB_mode} {
        if {($curr_outclk == $clock_to_comp) && ($curr_outclk == 0)} {
            set next_counter 1
        } elseif {($curr_outclk == $clock_to_comp)} {
            set next_counter 0
        } elseif {$clock_to_comp == [expr $curr_outclk + 1]} {
            incr curr_outclk 2
            set next_counter $curr_outclk
        } else {
            incr curr_outclk 1
            set next_counter $curr_outclk
        }
    } else {
        incr curr_outclk 1
        set next_counter $curr_outclk
    }

    return $next_counter
}

proc altera_iopll::util::get_first_outclk_to_update {} {
    # Description: The outclk settings need to be validated in a particular order. 
    #   Return the first one in this order. 
    #   Usually just outclk0 unless NDFB mode is enabled.
    # Inputs: none   
    set NDFB_mode             [get_parameter_value gui_use_NDFB_modes]
    set clock_to_comp         [get_parameter_value gui_clock_to_compensate] 

    if {$NDFB_mode} {
        set next_counter $clock_to_comp
    } else {
        set next_counter 0
    }
    return $next_counter
}

proc altera_iopll::util::get_multiply_factor {} {
	# Description: Returns the total multiply factor (just m counter if not in NDFB mode)
    # Inputs: none
	set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
	set gui_multiply_factor [get_parameter_value gui_multiply_factor]
    set clock_to_compensate [get_parameter_value gui_clock_to_compensate]
    if {$gui_use_NDFB_modes} { 
        set counter_in_loop [get_parameter_value gui_divide_factor_c$clock_to_compensate]
	    set m [expr {$gui_multiply_factor * $counter_in_loop}]
    } else {
        set m $gui_multiply_factor
    }
    return $m
}

# +==============================================================================================
# | RELATED TO PARSING PARAMETERS

proc altera_iopll::util::get_total_cntr_value {hi_cnt lo_cnt bypass} {
    # Description: Given physical parameters related to an outclk, return the total value. 
    # Inputs: Hi_cnt (integer), lo_cnt (integer) and bypass (bool) values of the counter. 
    set total_cnt 1
    if {!$bypass} {
        set total_cnt [expr {$hi_cnt + $lo_cnt}]
    } 
    return $total_cnt
}

proc altera_iopll::util::using_simple_pll {} {
	# Description: Determine whether or not the code outputs a PLL that can use the
    #   simple sim model. Currently this is only possible for Stratix 10. 
    # Inputs: none
    set family [get_parameter_value gui_device_family]
	if { $family == "Stratix 10"} {	
		set en_dps 				[get_parameter_value gui_en_dps_ports]
		set en_reconf 			[get_parameter_value gui_en_reconf]
		set en_refclk_switch 	[get_parameter_value gui_refclk_switch]	
		set en_adv 				[get_parameter_value gui_en_adv_params]
		set en_pll_cascade_out 	[get_parameter_value gui_enable_cascade_out]
		set en_pll_cascade_in 	[get_parameter_value gui_enable_cascade_in]
		set en_phout 			[get_parameter_value gui_en_phout_ports]
		set en_counter_casc		[get_parameter_value gui_enable_output_counter_cascading]
		set en_lvds 			[get_parameter_value gui_en_lvds_ports]
		set en_extclks          [get_parameter_value gui_en_extclkout_ports]
        set operation_mode      [get_parameter_value gui_operation_mode]


        set en_unsupported_modes false
        if {$operation_mode == "external feedback" || $operation_mode == "zero delay buffer"} {
            set en_unsupported_modes true
        }

		set en_fixed_vco 		[get_parameter_value gui_fix_vco_frequency]
		if {$en_fixed_vco && !$en_adv} {
			set using_fixed_vco true
		} else {
			set using_fixed_vco false
		}
		
	    if {$en_dps || $en_reconf || $en_refclk_switch || $en_adv || \
			$en_pll_cascade_out || $en_pll_cascade_in || $en_phout || \
			$en_counter_casc || ($en_lvds != "Disabled") || $en_extclks || \
            $using_fixed_vco || $en_unsupported_modes} {
			return false
		} else {
			return true
		}
	} else {
		return false
	}	
	return false                 
}

proc altera_iopll::util::is_pll_mode_fractional {} {
	# Description: Returns true if this is a Fractional PLL... Currently this should
    #  *always* return true. 
    # Inputs: none
    set gui_pll_mode [get_parameter_value gui_pll_mode]
	if {$gui_pll_mode == "Integer-N PLL" } {
		return false
	} elseif {$gui_pll_mode == "Fractional-N PLL"} {
        # As mentioned above, this really shouldn't happen. 
		error "This Qsys IP only instantiates IOPLLs. Please instantiate a fractional \
               PLL using the fractional PLL Qsys IP"
		return true
	} else {
		error "gui_pll_mode parameter set to unknown value. \
               Do you need to update this case statement?"
	}	
}

proc altera_iopll::util::phase_shift_unit_is_degrees {phase_shift_unit_value} {
	# Description: Returns true if phase_shift_unit_value == degrees. False otherwise.
    # Inputs: Value of gui_ps_units#. Should be either ps or degrees.
	if {$phase_shift_unit_value == "ps"} {
		return false
	} elseif {$phase_shift_unit_value == "degrees"} {
		return true
	} else {
		error "IE: unknown ps_unit. Do you need to update this function?"
	}
}

proc altera_iopll::util::get_operation_mode_for_computation {} {
	# Description: Returns the compensation mode, which includes NDFB_normal
    #    and NDFB Source Synchronous options. 
    # Inputs: none
	set original_gui_operation_mode [get_parameter_value gui_operation_mode]
	set device_family [get_parameter_value gui_device_family]
	set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    
	switch $original_gui_operation_mode {
		"source synchronous" {
			if {$device_family == "Stratix 10" && $gui_use_NDFB_modes == true} {
				set compensation_mode "NDFB source synchronous"
			} else {
				set compensation_mode "source synchronous"
			}
		}
		"normal" {
			if {$device_family == "Stratix 10" && $gui_use_NDFB_modes == true} {
				set compensation_mode "NDFB normal"
			} else {
				set compensation_mode "normal"
			}
		}
		default {
			set compensation_mode $original_gui_operation_mode
		}
	}
    return $compensation_mode

}

# +==============================================================================================
# | MESSAGING

proc altera_iopll::util::pll_send_message {type message} {
	# Description: Sends message to GUI message box or command line depending on settings below. 
    # Inputs: Type is 'info', 'debug', 'error' or 'warning'. Message is a string. 
    set print_output_to_console false
    set print_output_to_send_message true
	set debug_level high
	
	if {$debug_level == "low" && $type == "DEBUG_DETAILED"} {
		#don't print the message
	} else {

		if {$debug_level == "high" && $type == "DEBUG_DETAILED"} {
			#change the message type to debug
			set type DEBUG
		}
		
		if {$print_output_to_console} {
			puts "$type: $message"
		} 
		
		if {$print_output_to_send_message} {
			send_message $type $message
		}
	}
}

proc altera_iopll::util::pll_send_update_message  {type message} {
    # HACK: During upgrade callbacks, if Qsys runs into a problem, we are not able to send
    # messaged to the qsys message box. To get around this, keep track of the messages that
    # we *want* to send, and actually send them during validation.
    #puts "$message"
    set current_message [get_parameter_value hp_parameter_update_message]
    set new_message [list altera_iopll::util::pll_send_message $type $message]
    lappend current_message $new_message
    set_parameter_value hp_parameter_update_message $current_message
}

# ================================================================================================
#   CONSTRUCTING INPUTS TO COMPUTATION CODE

proc altera_iopll::util::make_desired_c_counter_array {param n_counter {use_actual false}} {
    # Description: 
    #   This function creates an array of the desired settings for this outclk.
    #   Frequency and duty cycle are set to the default values when calculating frequency,
    #   but frequency must be included when calculating phase and duty. 
    # Inputs: Param indicates whether the current parameter being validated is phase
    #   duty or frequency. N_counter is the counter index.

    set i $n_counter
	array set c_cnt_array [list]
	set using_adv_mode [get_parameter_value gui_en_adv_params]
	set usr_restrict_vco_freq [get_parameter_value gui_fix_vco_frequency]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
    set clock_to_compensate [get_parameter_value gui_clock_to_compensate]
	set gui_pll_auto_reset    [get_parameter_value gui_pll_auto_reset]
	
    # The parameters added to the array depend on whether frequency, phase or duty is
    # being validated. 
    switch $param {
		freq {
			if {!$using_adv_mode} {
                if {$use_actual} {
				    set current_freq [get_parameter_value gui_actual_output_clock_frequency$i] 
                } else {
				    set current_freq [get_parameter_value gui_output_clock_frequency$i] 
                }
			} else {
				set current_freq [get_parameter_value gui_divide_factor_c$i]
			}		
			set current_ps_unit_is_degrees false
			set current_phase 0.0
			set current_duty 50.0
		}
		phase {
			if {!$using_adv_mode} {
				set current_freq [get_parameter_value hp_actual_output_clock_frequency_fp$i] 	
			} else {
				set current_freq [get_parameter_value gui_divide_factor_c$i]
			}
			set current_phase_unit [get_parameter_value gui_ps_units$i]
			if {![altera_iopll::util::phase_shift_unit_is_degrees $current_phase_unit]} {
                if {$use_actual} {
				    set current_phase [get_parameter_value gui_actual_phase_shift$i] 
                } else {
				    set current_phase [get_parameter_value gui_phase_shift$i]
                }	
				set current_ps_unit_is_degrees false
			} else {
				set current_phase [get_parameter_value gui_phase_shift_deg$i]
				set current_ps_unit_is_degrees true
			}	
			set current_duty 50.0		
		}
		duty {
			if {!$using_adv_mode} {
				set current_freq [get_parameter_value hp_actual_output_clock_frequency_fp$i] 	
			} else {
				set current_freq [get_parameter_value gui_divide_factor_c$i]
			}
			set current_phase [get_parameter_value hp_actual_phase_shift_fp$i]
			set current_ps_unit_is_degrees false		
            if {$use_actual} {
			    set current_duty [get_parameter_value gui_actual_duty_cycle$i] 
            } else {
		    	set current_duty [get_parameter_value gui_duty_cycle$i]
            }
		}
		default {
			error "BAD PARAMETER NAME"
		}
	} 
	if {$using_adv_mode} {
		set current_cascade [get_parameter_value gui_cascade_counter$i]
	}
	
    if {!$using_adv_mode && $usr_restrict_vco_freq && !$gui_use_NDFB_modes} {
        # outclk0 is actually the VCO and the rest of the outclks are incremented. 
        # Effectively, n_counter(counter_index) is 
        #  VCO(0)-0(1)-1(2)-2(3)-3(4)-4(5)-5(6)-6(7)-7(8)-8(9)
        #  instead of 0(0)-1(1)-2(2)-3(3)-4(4)-5(5)-6(6)-7(7)-8(8),
		set counter_index [expr {$n_counter + 1}]
	} elseif {($gui_use_NDFB_modes) && !$using_adv_mode} {
        # outclk0 is actually the 'clock to compensate'
        # If clock to compensate is outclk4: then n_counter(index) is
        #  4(0)-0(1)-1(2)-2(3)-3(4)-5(5)-6(6)-7(7)-8(8)  instead of
        #  0(0)-1(1)-2(2)-3(3)-4(4)-5(5)-6(6)-7(7)-8(8),
        if {( $n_counter < $clock_to_compensate)} {
            set counter_index [expr {$n_counter + 1}]
        } elseif { $n_counter == $clock_to_compensate} {
            set counter_index 0
        } else {
            set counter_index $n_counter
        }
        set i $counter_index
    } else {
		set counter_index $n_counter
	}
    
	if {!$using_adv_mode} {
		set c_cnt_array($counter_index) [list -type c -index $i -freq $current_freq \
            -phase $current_phase -is_degrees $current_ps_unit_is_degrees -duty $current_duty]
    } else {
		set c_cnt_array($counter_index) [list -type c -index $i -cdiv $current_freq \
            -is_cascade $current_cascade -phase $current_phase -is_degrees \
            $current_ps_unit_is_degrees -duty $current_duty]
	}
	return [array get c_cnt_array]
}


proc altera_iopll::util::make_validated_c_counter_array {param n_counter} {
    # Description: 
    #   When changing a parameter, is it important to not contradict settings of higher priority.
    #   To do this, higher priority settings are passed to the computation code as
    #   hard constraints.
    #   The first outclk settings (outclk0, ...) have higher priority than later ones
    #          (... , outclk8)
    #   Frequency is higher priority than phase shift, which is higher priority than duty cycle. 
    #   This function generates these constraints, which are passed to the computation code. 
    # Inputs: Param indicates whether the current parameter being validated is phase
    #   duty or frequency. N_counter is the counter index.
 
	array set c_cnt_array [list]

	set num_clocks [get_parameter_value gui_number_of_clocks]
	set using_adv_mode [get_parameter_value		gui_en_adv_params]
	set clock_to_compensate [get_parameter_value	gui_clock_to_compensate]
    set gui_use_NDFB_modes [get_parameter_value gui_use_NDFB_modes]
	set auto_reset     [get_parameter_value     gui_pll_auto_reset]
	
	# Get VCO frequency first 
    # If VCO frequency is specified, we add it to these constraints as if it is outclk0, and
    # increment all other outclks. It must be outclk0 and not outclk9 because otherwise the 
    # VCO is lower priority in a way that is unintuitive. 
    # This is a bit of a hack, since ideally the VCO would be a separate input to the 
    # computation code. 
	set array_index 0
	set usr_fixed_vco_freq [get_parameter_value gui_fix_vco_frequency]
	if {!$using_adv_mode && $usr_fixed_vco_freq && !$gui_use_NDFB_modes} {
		set fixed_vco [get_parameter_value hp_actual_vco_frequency_fp]
		set c_cnt_array($array_index) 	[list -type wire -index 0 -freq $fixed_vco \
            -phase 0.0 -is_degrees false -duty 50.0]
		incr array_index
	}
	
    # Similarly, if there is an outclk in the loop, it needs to be validated first. 
    # So if outclk4 is the outclk in the loop the priority is 4-0-1-2-3-5-6-7-8
	if {($gui_use_NDFB_modes) && ($clock_to_compensate != 0) && !$using_adv_mode} {
         
        # If we are on the clock_to_compensate, is is first so there are no validated clocks yet. 
        if {($clock_to_compensate == $n_counter)} {
            return [array get c_cnt_array]
        } else {
            switch $param {
                freq {
                    set current_freq [get_parameter_value \
                              hp_actual_output_clock_frequency_fp$clock_to_compensate]
                    set current_phase 0.0
                    set current_duty 50.0
                }
                phase {
                    set current_freq [get_parameter_value \
                              hp_actual_output_clock_frequency_fp$clock_to_compensate]
                    set current_phase [get_parameter_value \
                              hp_actual_phase_shift_fp$clock_to_compensate]
                    set current_duty 50.0
                } 
                duty {
                    set current_freq [get_parameter_value \
                              hp_actual_output_clock_frequency_fp$clock_to_compensate]
                    set current_phase [get_parameter_value \
                              hp_actual_phase_shift_fp$clock_to_compensate]
                    set current_duty [get_parameter_value \
                              hp_actual_duty_cycle_fp$clock_to_compensate]				
                }
                default { error "BAD PARAMETER TYPE" }
            }
            set c_cnt_array($array_index) [list -type c -index 0 -freq $current_freq \
                         -phase $current_phase -is_degrees false -duty $current_duty]
            incr array_index
        }
	}
	
    # Add all higher priority settings (this depends on the parameter type and clock number,
    #  as described above.)
	for {set i 0} {$i < $num_clocks} {incr i} {
    	if {($gui_use_NDFB_modes) && ($clock_to_compensate != 0) && ($i == $clock_to_compensate) \
             && !$using_adv_mode} {          
            # We already added this one, so skip it. 
            continue;
        }
		switch $param {
			freq {
                if {!($i < $n_counter)} {
                    continue
                }
				if {!$using_adv_mode} { 	
					set current_freq [get_parameter_value hp_actual_output_clock_frequency_fp$i]
				} else {
					set current_freq [get_parameter_value gui_divide_factor_c$i]
				}
				set current_ps_unit_is_degrees false
				set current_phase 0.0
				set current_duty 50.0
			}
			phase {
				if {!$using_adv_mode} {
					set current_freq [get_parameter_value hp_actual_output_clock_frequency_fp$i]	
				} else {
					set current_freq [get_parameter_value gui_divide_factor_c$i]
				}
                 if {!($i < $n_counter)} {
                    set current_phase 0.0
                } else {
                    set current_phase [get_parameter_value hp_actual_phase_shift_fp$i]
                }
				set current_ps_unit_is_degrees false

				set current_duty 50.0
			} 
			duty {
				if {!$using_adv_mode} {
					set current_freq [get_parameter_value hp_actual_output_clock_frequency_fp$i]	
				} else {
					set current_freq [get_parameter_value gui_divide_factor_c$i]
				}
				set current_phase [get_parameter_value hp_actual_phase_shift_fp$i]
				set current_ps_unit_is_degrees false
                if {!($i < $n_counter)} {
                    set current_duty 50.0
                } else {
                    set current_duty [get_parameter_value hp_actual_duty_cycle_fp$i]
                }				
			}
			default {
				error "BAD PARAMETER TYPE"
			}
		}
		
		if {$using_adv_mode} {
			set current_cascade [get_parameter_value gui_cascade_counter$i]
		}
		
        if {($gui_use_NDFB_modes) && ($clock_to_compensate != 0) && !$using_adv_mode} {          
            set c_cnt_array($array_index) [list -type c -index $array_index \
                -freq $current_freq -phase $current_phase -is_degrees \
                $current_ps_unit_is_degrees -duty $current_duty]
        } elseif {$using_adv_mode} {
            set c_cnt_array($array_index) [list -type c -index $i -cdiv $current_freq \
                -phase $current_phase -is_cascade $current_cascade -is_degrees \
                $current_ps_unit_is_degrees -duty $current_duty]
		} else {
            set c_cnt_array($array_index) [list -type c -index $i -freq $current_freq \
                -phase $current_phase -is_degrees $current_ps_unit_is_degrees \
                -duty $current_duty]		
		}
		incr array_index
	}
	
	return [array get c_cnt_array]
}


# +==============================================================================================
# | MAPPED RANGES: USED by ALTERA_IOPLL_COMMON ONLY
# | Eventually should be removed from altera_iopll_common and then deleted. 

##### SEARCHING RANGES WITH TOLERANCE ###########################################
proc altera_iopll::util::search_range_with_tolerance {range value decimals} {
	set rounded_range [round_to_n_decimals $range $decimals]
	set rounded_value [round_to_n_decimals $value $decimals]
	
	return [lsearch $rounded_range $rounded_value]
}

##### MAPPING FUNCTIONS #########################################################

proc altera_iopll::util::search_mapped_range {parameter_name desired_value} {
    # used by ALTERA_IOPLL_COMMON only
	#returns the index of the element the == the value given 
	set allowed_ranges [get_parameter_property $parameter_name ALLOWED_RANGES]
	for {set i 0} {$i < [llength $allowed_ranges]} {incr i} {
		set possible_value [lindex $allowed_ranges $i]
		#if this sucker is mapped then split him up
		set split_val [split $possible_value ":"]
		#puts "split_val: $split_val"
		if {[llength $split_val] > 1} {
			set possible_value [lindex $split_val 1]
		}
		#puts "possible_value: $possible_value"
		#puts "desired_value: $desired_value"
		if { $desired_value == $possible_value} {
			return $i
		}
	}
	return -1
}

proc altera_iopll::util::search_qsys_mapped_range {parameter_name desired_value} {
    # used by ALTERA_IOPLL_COMMON only
	#returns the index of the element the == the value given 
	set allowed_ranges [get_parameter_property $parameter_name ALLOWED_RANGES]
	for {set i 0} {$i < [llength $allowed_ranges]} {incr i} {
		set possible_value [lindex $allowed_ranges $i]
		#if this sucker is mapped then split him up
		set split_val [split $possible_value ":"]
		#puts "split_val: $split_val"
		if {[llength $split_val] > 1} {
			set possible_value [lindex $split_val 0]
		}
		#puts "possible_value: $possible_value"
		#puts "desired_value: $desired_value"
		if { $desired_value == $possible_value} {
			return $i
		}
	}
	return -1
}

proc altera_iopll::util::map_allowed_range {gui_param_name new_range new_value} {
    # used by ALTERA_IOPLL_COMMON only
	#::alt_xcvr::utils::common::map_allowed_range $gui_param_name $new_range
	#puts "___ in map allowed range"
	
	#the current value of the parameter
	set current_value [get_parameter_value $gui_param_name]
	#puts "  current gui value: $current_value"
	set current_range [get_parameter_property $gui_param_name ALLOWED_RANGES]
	#puts "  current gui range: $current_range"
	
	#get the index of the newly desired value of the parameter
	set index_new_value [lsearch $new_range $new_value]
	if {$index_new_value == -1} {
		error "IE: desired value is not in allowed range"
	}
	
	#puts "list before update: $new_range"
	set new_legal_values [list]
	
	#search the legal values (the list that you want to make the new allowed range)
	#for the current value of the gui parameter
	#if its not there, you are going to have to make a mapping to not throw an error
	#dont need this check:  [lsearch $new_range $current_value] != -1
	if {[lsearch $new_range $current_value] != -1 && $current_value == $new_value} {
		#pll_send_message DEBUG "    found it or equal"
		set new_legal_values $new_range
	} elseif { [lsearch $new_range $current_value] != -1} {
		#this means that the element IS in the new list, but we still need to remap... so
		#we're going to cheat. 
		#replace the new element with the mapped one
		#replace the old element with a mapped one
		set new_legal_values $new_range
		set curr_val_to_set "$current_value "
		set new_legal_values [lreplace $new_legal_values $index_new_value \
                                 $index_new_value ${curr_val_to_set}:${new_value}]
		set old_element_index [lsearch $new_range $current_value]
		set new_legal_values [lreplace $new_legal_values $old_element_index \
                                 $old_element_index ${current_value}.]
	} else {
		#puts "didn't find it"
		#if you didn't find it, then remap the first value in the legal values list to be the 
		#current parameter value
		set new_legal_values $new_range
		set new_legal_values [lreplace $new_legal_values $index_new_value \
                                 $index_new_value ${current_value}:${new_value}]
	}

	#set new_range [lreplace new_range 0 0 "\"${current_value}\":$legal_values0"]
	#puts "list after update: $new_legal_values"
	set_parameter_property $gui_param_name ALLOWED_RANGES $new_legal_values
    
	#set new_range [get_parameter_property $gui_param_name ALLOWED_RANGES]
	#puts "new gui range after update: $new_range"
	
}

proc altera_iopll::util::get_actual_parameter_value {gui_param_name} {	
    # used by ALTERA_IOPLL_COMMON only
	pll_send_message DEBUG_DETAILED "IN GET_ACTUAL_PARAMETER_VALUE"
	#puts "Mapping: $gui_param_name"
	
	#determine if the range has been mapped (ie values are fakes)
	#-search for :
	set qsys_value [get_parameter_value $gui_param_name]
	set qsys_range [get_parameter_property $gui_param_name ALLOWED_RANGES]
    
	set colon_index [lsearch -regexp $qsys_range {:}]
	
	#if it's not mapped
	if {$colon_index == -1 || ($colon_index != -1 && \
            [get_parameter_property $gui_param_name TYPE] != "STRING")} {
		return $qsys_value 
	}
	
	foreach element $qsys_range {
		set split_element [split $element ":"]
		if {[llength $split_element] > 1} {
			lappend actual_list [lindex $split_element 1]
			lappend real_list [lindex $split_element 0]
		} else {
			lappend actual_list $element
			lappend real_list $element
		}
	}
    
	set index [lsearch $real_list $qsys_value]
	if {$index == -1} {
		error "error in getting mapped value"
	}
	set actual_value [lindex $actual_list $index]
	return $actual_value
}

proc altera_iopll::util::are_parameters_equal {param1 param2} {
    # used by ALTERA_IOPLL_COMMON only
	#these better be hwtcl parameters
	set val1 [get_actual_parameter_value $param1]
	set val2 [get_actual_parameter_value $param2]
	if {$val1 == $val2} {
		return true
	} else {
		return false
	}
	
}

proc altera_iopll::util::are_actual_ranges_equal {range1 range2} {
    # used by ALTERA_IOPLL_COMMON only
	#these better be hw tcl parameters and a valid property
	set new_range1 [list]
	foreach element $range1 {
		set splitval [split $element :]
		if {[llength $splitval] > 1} {
			lappend new_range1 [lindex $splitval 1]
		} else {
			lappend new_range1 $element
		}
	}
	set new_range2 [list]
	foreach element $range2 {
		set splitval [split $element :]
		if {[llength $splitval] > 1} {
			lappend new_range2 [lindex $splitval 1]
		} else {
			lappend new_range2 $element
		}
	}	
	set new_range1 [round_to_n_decimals $new_range1 8]
	set new_range2 [round_to_n_decimals $new_range2 8]
	if {$new_range1 == $new_range2} {
		return true
	} else {
		return false
	}
}
