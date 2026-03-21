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


# This file holds a number of common functions for DSPIP
#Creates the XML Syntax for SPD Files
proc convert_to_spd_xml { file_name type library {simulator ""} } {
   if { $type == "SYSTEM_VERILOG_ENCRYPT" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" simulator=\"${simulator}\"/>"
   } elseif { $type == "VERILOG_ENCRYPT" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" simulator=\"${simulator}\"/>"
   } elseif { $type == "VHDL_ENCRYPT" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" simulator=\"${simulator}\"/>"
   } elseif { $type == "VERILOG" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" />"
   } elseif { $type == "VHDL" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" />"
   } elseif { $type == "SYSTEM_VERILOG" } {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\" />"
   } elseif { $type == "Memory" } {
       return "<file path=\"$file_name\" type=\"MEM_INIT\" initParamName=\"[file rootname $file_name ]\" memoryPath=\"test_program\" />"
   } else {
      return  "<file path=\"$file_name\" type=\"$type\" library=\"$library\"/>"
   }
}

# Add a file with automatic support for encrypted files
proc dsp_add_fileset_file {file_name fileset {simulator_list ""}} {

    set name [file tail $file_name]
    set path [file dirname $file_name]
    if {$simulator_list == ""} {
        set simulator_list [get_simulator_list]
    }

    set is_ocp [string equal [file extension $name] ".ocp"]

    if {$fileset == "SIM_VHDL" || $fileset == "SIM_VERILOG"} {
        set added 0
        foreach simulator $simulator_list {
            set sim [lindex $simulator 0]
            if {[file exists $sim/$file_name]} {
                set specific "[string toupper $sim]_SPECIFIC"
                add_fileset_file $sim/$name "[get_type_from_extension $name]_ENCRYPT" PATH $sim/$file_name $specific
                set added 1
            } elseif {[file exists $path/$sim/$name]} {
                set specific "[string toupper $sim]_SPECIFIC"
                add_fileset_file $sim/$name "[get_type_from_extension $name]_ENCRYPT" PATH $path/$sim/$name $specific
                set added 1
            }
        }
        if {! $added} {
            add_fileset_file $name [get_type_from_extension $name] PATH $file_name
        }
    } else {
        add_fileset_file $name [get_type_from_extension $name] PATH $file_name
    }
}




# Send a message of severity type with variables set in the local context filled in 
proc send_message_from_strings {type id} {
    set message [get_string $id]
    send_message $type [uplevel [list subst -nocommands $message]]
}

# given a list of properties, retrieve them from the strings file and set the module property
# with the same name
proc set_module_properties_from_strings {args} {
    foreach prop $args {
        set_module_property $prop [get_string $prop]
    }
}

# For a drop-down menu parameter and a given set of key, set the ALLOWED_RANGES parameter
# using the keys to look up the user-visible strings. Strings must have name "<PARAM>_<KEY>"
proc set_allowed_ranges {param keys} {
    set allowed {}
    foreach key $keys {
        set value [get_string_or_empty $param $key]
        if {$value == ""} {
            lappend allowed "$key"
        } else {
            lappend allowed "$key:$value"
        }
    }
    set_parameter_property $param ALLOWED_RANGES $allowed
}

# given a list of variable names retrieve values from the string file using variable name as a key
# then set those variables in the calling context (optionally can set global variables)
proc set_variables_from_strings {args} {
    set is_global false
    if {[lindex $args 0] == "-global"} {
        set is_global true
        set args [lreplace $args 0 0]
    }
        
    foreach var $args {
        set value [get_string [string toupper $var]]
        if {$is_global} {
            uplevel [list variable $var]
        }
        uplevel [list set $var $value]
    }
}

# retrieve a property string associated with a specific parameter and return it if it exists 
# otherwise return an empty string. Strings must have a name in this form: <PARAM>_<PROPERTY>
# (by default get_string just returns the property name if there's no associated value)
proc get_string_or_empty {param s} {
    set property [string toupper "${param}_$s"]
    set property_value [get_string $property]
    if {$property_value == $property} {
        set property_value ""
    }
    return $property_value
}

# set up parameter display strings, descriptions (and long descriptions) by looking for values
# in the properties file. 
# The assumption is that parameter foo will have strings:
# FOO_DISPLAY, FOO_DESCRIPTION, FOO_LONG_DESCRIPTION
proc set_parameter_display_from_strings {param} {
    set_parameter_property $param DISPLAY_NAME [get_string "[string toupper $param]_DISPLAY"]
    set desc [get_string_or_empty $param "DESCRIPTION"]
    set long_desc [get_string_or_empty $param "LONG_DESCRIPTION"]
    if {$long_desc == ""} {
        set long_desc $desc
    } elseif {[string index $long_desc 0] == "+"} {
        set long_desc "$desc [string range $long_desc 1 end]"
    }
    set_parameter_property $param DESCRIPTION $desc
    set_parameter_property $param LONG_DESCRIPTION $long_desc
}


proc all_memory_options {} {
    return [list "logic_element:[get_string MEM_LE_NAME]"  "auto:[get_string MEM_AUTO_NAME]" "M512:[get_string MEM_M512_NAME]" "M4K:[get_string MEM_M4K_NAME]" "M9K:[get_string MEM_M9K_NAME]"  "M10K:[get_string MEM_M10K_NAME]" "M20K:[get_string MEM_M20K_NAME]" "MRAM:[get_string MEM_MRAM_NAME]" "MLAB:[get_string MEM_MLAB_NAME]"]
}

proc memory_options {} {
   set device_family [get_parameter_value selected_device_family]
   if { [ check_device_family_equivalence $device_family {  "StratixIV"   "ArriaIIGZ" } ] == 1 } {
        return [list "logic_element"  "auto" "M512" "M4K" "MRAM"]
    } elseif { [ check_device_family_equivalence $device_family { "Max10FPGA"  "CycloneIVGX"  "CycloneIVE" } ] == 1 } {
        return [list "logic_element"  "auto" "M9K"]
    } elseif { [ check_device_family_equivalence $device_family { "ArriaIIGX" } ] == 1 } {
        return [list "logic_element"  "auto" "M9K" "MLAB" ]
    } elseif { [ check_device_family_equivalence $device_family {  "StratixV" "ArriaVGZ" } ] == 1 } {
        return [list "logic_element"  "auto" "M20K" "MLAB" ]
    } elseif { [ check_device_family_equivalence $device_family {  "CycloneV" "ArriaV" } ] == 1 } {
        return [list "logic_element"  "auto" "M10K" "MLAB" ]
    } elseif { [ check_device_family_equivalence $device_family {  "Arria10" } ] == 1 } {
        return [list "logic_element"  "auto" "M20K" "MLAB" ]
    } else {
        return [list "logic_element"  "auto" ]
    }
}

#Added tolerant so that you CAN just dump any file into this - but if you've got a common use case 
#(for example .png or something) then just please add a case!
proc get_type_from_extension {path {tolerant "false"}} {
    switch -glob $path {
        *.vhd { return VHDL }
        *.vho { return VHDL }
        *.txt { return OTHER }
        *.tcl { return OTHER }
        *.sdc { return SDC }
        *.hex { return HEX }
        *.v   { return VERILOG }
        *.sv   { return SYSTEM_VERILOG}
        *.vo   { return VERILOG }
        *.ocp { return OTHER}
        *.m   { return OTHER }
        default { 
            if {$tolerant} {
                return OTHER
            } else {
                send_message error "Unknown file type for '$path'" 
            }
        }
    }
}


proc get_platform {} {
    if { [regexp -nocase win $::tcl_platform(os) match] } {
        set PLATFORM "windows"
    } else {
        set PLATFORM "linux"
    }
    # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
    # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
    if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
        if {[string match "*64" $::tcl_platform(machine)]} {
            set POINTERSIZE 8
        } else {
            set POINTERSIZE 4
        }
    }
    if { $POINTERSIZE == 8 } {
        set PLATFORM "${PLATFORM}64"
    } else {
        set PLATFORM "${PLATFORM}32"
    }        
}
# Compare two qsys versions
# returns: -1 : a older than b , 0 : a same as b, 1 : a newer than b
proc compare_versions { a b }  {
    set  a_split [split $a .]
    set  b_split [split $b .]
    #first, zero pad the versions to get the same lengths
    if { [llength $a_split] > [llength $b_split] } {
        for {set i 0} {$i < [expr [llength $a_split] - [llength $b_split]]} {incr i} {
            lappend $b_split "0"   
        }
    } elseif { [llength $b_split] > [llength $a_split] } {
        for {set i 0} {$i < [expr [llength $b_split] - [llength $a_split]]} {incr i} {
            lappend $a_split "0"   
        }
    }
    set length [llength $a_split]
    if { $length  < 1 } { return 0 } 
    #compare release years
    set a_year [lindex $a_split 0]
    set b_year [lindex $b_split 0]
    if { $a_year > $b_year } { 
        return 1
    } elseif { $a_year < $b_year } {
        return -1
    }
    if { $length  < 2 } { return 0 } 
    #compare release
    set a_rel [lindex $a_split 1]
    set b_rel [lindex $b_split 1]   
    set a_rel_val [string index $a_rel 0]
    set b_rel_val [string index $b_rel 0]
    if { $a_rel_val > $b_rel_val } {
        return 1
    } elseif { $a_rel_val < $b_rel_val } {
        return -1
    }
    #check for non-numeric (ie, 14.0a is newer than 14.0)
    if { [string length $a_rel] > [string length $b_rel] } {
        return 1
    } elseif { [string length $a_rel] < [string length $b_rel] } {
        return -1
    }
    if { $length  < 3 } { return 0 } 
    #Check update version
    set a_update [lindex $a_split 2]
    set b_update [lindex $b_split 2]   
    if { $a_update > $b_update } {
        return 1
    } elseif { $a_update < $b_update } {
        return -1
    }
    return 0

}
