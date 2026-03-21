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


# This package provices a way to generate a thin wrapper around an HDL module
# that perfectly forwards all of its ports and parameters while adding some
# extra parameters. The initial ports and parameters are extracted using the
# hw.tcl API and so the wrapper should exactly match what Qsys is expecting
# from the top-level entity.

# The main reason to use such wrappers is to insert parameters whose values can
# only be known at generation time. This is useful for expensive to compute
# parameters so that elaboration is not unduly slowed and for filename
# parameters where the filename is only known at generation since it contains
# the entity name prefix (e.g. Hex files).

# The insert_code parameter is provided to allow additional code to be inserted
# into the body of the wrapper. If you use this parameter, it is up to you to
# ensure that the code provided is in the appropriate language.

package provide altera_hdl_wrapper 1.0

namespace eval altera_hdl_wrapper {
    namespace export generate_wrapper
}


# usage:
# set text [altera_hdl_wrapper::generate_wrapper [options] "outer" "inner" Verilog \
#             [list [list "arg1" 2 POSITIVE unquoted] \
#                   [list "arg2" "a value" STRING quoted] \
#                   [list "arg3" {foo("filename.hex")} STRING unquoted]]]

# When specifying parameters, you must declare a parameter's type as well as
# whether it's quoted. This is useful as the value could be a function 
# invocation which returns a string.

# by default only parameters that are marked as HDL_PARAMETER = true are written into the wrapper.
# [options]: if "-use_affects_gen_params" is passed, only parameters marked as AFFECTS_GENERATION = true
# are written into the wrapper.

# [options]: if "-no_params" is passed, no parameters are written into the wrapper.

proc altera_hdl_wrapper::generate_wrapper {args} {
    if {[llength $args] == 0} {
        send_message error "generate_wrapper called with 0 arguments but requires at least 4"
        return
    }
    
    # by default only parameters that are marked as HDL_PARAMETER = true are written into the wrapper
    # with this flag set to true, the test instead looks at AFFECTS_GENERATION
    set use_affects_gen_params false
    # by default only parameters that are marked as HDL_PARAMETER = true 
    # or AFFECTS_GENERATION = true are written into the wrapper
    # with this flag set to true, the test doesnt include any params no matter the type
    set noparams false

    set i 0
    foreach arg $args {
        if {[string index $arg 0] == "-"} {
            if {[string equal -nocase $arg "-use_affects_gen_params"]} {
                set use_affects_gen_params true
            } elseif {[string equal -nocase $arg "-no_params"]} {
                set noparams true
            } else {
                send_message error "generate_wrapped called with unknown option parameter '$arg'"
            }
        } else { 
            break
        }
        incr i
    }
  
    set args [lrange $args $i end]
    if {[llength $args] < 4} {
        send_message error "generate_wrapper called with [llength $args] arguments but requires at least 4"
    }

 
    # if there are only 4 args then insert_code will take the empty string which is what we want
    lassign $args wrapper_name orig_name lang extra_params insert_code  forced_vector_name
    
    set params {}

    if {$use_affects_gen_params} {
        set wrapper_param_type AFFECTS_GENERATION
    } else {
        set wrapper_param_type HDL_PARAMETER
    }


    foreach p [get_parameters] {
        if {[get_parameter_property $p $wrapper_param_type]} {
            lappend params [list $p [get_parameter_property $p TYPE] [get_parameter_value $p]]
        }
    }

    set ports {}
    foreach iface [get_interfaces] {
        foreach port [get_interface_ports $iface] {
            set vhdl_type [get_port_property $port VHDL_TYPE]
            set width [get_port_property $port WIDTH_VALUE]
            if {$vhdl_type == "AUTO"} {
                if {$width == 1} {
                    set vhdl_type "STD_LOGIC"
                } else {
                    set vhdl_type "STD_LOGIC_VECTOR"
                }
            }
            lappend ports [list $port \
                                [get_port_property $port DIRECTION] \
                                [get_port_property $port FRAGMENT_LIST] \
                                $width \
                                $vhdl_type]
        }
    }

    set new_ports {}
    set forwarded_ports {}
    array set port_props {}
    foreach port $ports {
        set name [lindex $port 0]
        set direction [lindex $port 1]
        set frag_list [lindex $port 2]
        set width [lindex $port 3]
        set vhdl_type [lindex $port 4]

        if {$vhdl_type == "STD_LOGIC"} {
            set expected_frag_list "${name}(0)"
        } else {
            set expected_frag_list "${name}([expr {$width - 1}]:0)"
        }

        if {$frag_list == $expected_frag_list} {
            # not a fragment list so add it as normal
            if {$width==1} {set vect 0} else {set vect 1}
            foreach vector $forced_vector_name {
                if {$vector==$name} {
                    set vect 1
                }
            }
            lappend new_ports [list $name $direction $width $vhdl_type $vect]
        } else {
            set frag_ports [split $frag_list " "]
            foreach frag_port [split $frag_list " "] {
                if {$frag_port == ""} {
                    continue
                }

                set bracket_pos [string first "(" $frag_port]
                # attempt to match "foo", "foo(x)" or "foo(x:y)"
                # (?: ... ) stops it recording (x:y) on its own
                lassign [regexp -inline {(\w+)(?:\((\d+)(?::(\d+))?\))?} $frag_port] \
                    unused port_name start end


            set vect 0
            foreach vector $forced_vector_name {
                if {$vector==$port_name} {
                          set vect 1
                }
            }



                if {$start == ""} {
                    # empty start - treat original port as STD_LOGIC
                    if {[info exists port_props($port_name)]} {
                        lassign $port_props($port_name) vhdl_type
                        if {$vhdl_type != "STD_LOGIC"} {
                            send_message error "Port $port_name used as STD_LOGIC and STD_LOGIC_VECTOR"
                        }
                    } else {
                        set port_props($port_name) [list STD_LOGIC 1 $direction $vect]
                    }
                } else {
                    if {[info exists port_props($port_name)]} {
                        lassign $port_props($port_name) vhdl_type width 
                        if {$vhdl_type != "STD_LOGIC_VECTOR"} {
                            send_message error "Port $port_name used as STD_LOGIC and STD_LOGIC_VECTOR"
                        }
                        if {$start >= $width} {
                            set width [expr {$start + 1}]
                        }
                    } else {
                        set width [expr {$start + 1}]
                    }
                    set port_props($port_name) [list STD_LOGIC_VECTOR $width $direction $vect]
                }
            }
        }
    }

    foreach port_name [array names port_props] {
        lassign $port_props($port_name) vhdl_type width direction vect
        lappend new_ports [list $port_name $direction $width $vhdl_type $vect]
    }

    if {[string equal -nocase $lang "VERILOG"]} {
        return [altera_hdl_wrapper::write_verilog_wrapper $wrapper_name $orig_name \
            $params $extra_params $new_ports $insert_code $noparams]
    } elseif {[string equal -nocase $lang "VHDL"]} {
        return [altera_hdl_wrapper::write_vhdl_wrapper $wrapper_name $orig_name \
            $params $extra_params $new_ports $insert_code $noparams]
    } else {
        send_message error "Unknown language '$lang' for wrapper generation"
    }
}

proc altera_hdl_wrapper::append_table {textvar tablevar template {row_delim ""}} {
    upvar $textvar text
    upvar $tablevar table

    lassign $table col_count rows
    set num_cols [llength $col_count]

    set pos 0
    set new_template ""
    for {set i 0} {$i < $num_cols} {incr i} {
        set new_pos [string first "%" $template $pos]
        set next_char_pos [expr {$new_pos + 1}]
        set next_char [string index $template $next_char_pos]
        append new_template [string range $template $pos $new_pos]
        if {$next_char == "r"} {
            append new_template [lindex $col_count $i]
            incr next_char_pos
        } elseif {$next_char == "l"} {
            append new_template "-[lindex $col_count $i]"
            incr next_char_pos
        }
        set pos $next_char_pos
    }
    append new_template [string range $template $pos end]


    foreach row $rows {
        append text [format $new_template {*}$row]
        if {$row_delim != ""} {
            append text $row_delim
        }
    }
    if {$row_delim != ""} {
        delete_final_char_if text $row_delim
    }
}

proc altera_hdl_wrapper::create_table {tablevar num_cols} {
    upvar $tablevar table
    set cols {}
    for {set i 0} {$i < $num_cols} {incr i} {
        lappend cols 0
    }
    set table [list $cols [list]]
}

proc altera_hdl_wrapper::add_row {tablevar args} {
    upvar $tablevar table
    lassign $table col_count rows
    set num_cols [llength $col_count]
    if {$num_cols != [llength $args]} {
        send_message error "Expecting $num_cols columns but got [llength $args]"
    }

    for {set i 0} {$i < $num_cols} {incr i} {
        set c [lindex $col_count $i]
        set t [lindex $args $i]
        lset col_count $i [expr {max($c, [string length $t])}]
    }

    lappend rows $args
    set table [list $col_count $rows]
}

proc altera_hdl_wrapper::write_verilog_wrapper {wrapper_name orig_name params extra_params ports insert_code noparams} {
    set text "`timescale 1 ps / 1 ps\n  module $wrapper_name ("

    # write out ports as a table so that the types, array indices and names line up
    altera_hdl_wrapper::create_table port_table 3
    foreach port $ports {
        lassign $port name direction width vhdl_type
        set type ""
        if {$vhdl_type != "STD_LOGIC"} {
            set type " \[[expr {$width-1}]:0\]"
        }
        altera_hdl_wrapper::add_row port_table [string tolower $direction] $type $name
    }
    altera_hdl_wrapper::append_table text port_table "\n    %ls%rs %s" ","

    append text ");\n";

	altera_hdl_wrapper::create_table param_table 2
    foreach param $params {
        lassign $param name type value
		if {[string equal -nocase $type "STRING"]} {set value "\"$value\""}
        altera_hdl_wrapper::add_row param_table $name $value
    }
    altera_hdl_wrapper::append_table text param_table "\n    parameter %ls = %s" ";"
    if {[llength $params]>0} {append text ";\n\n"}


    if {$insert_code != ""} {
        altera_hdl_wrapper::delete_final_char_if insert_code "\n"
        append text "$insert_code\n\n"
    }

    if {([string equal $noparams false] && [llength $params]>0) || [llength $extra_params]>0 } {
        append text "$orig_name #("

        # write out params as a table so that the names and values line up
        altera_hdl_wrapper::create_table param_table 2
        if {[string equal $noparams false]} {
            foreach param $params {
                set param [lindex $param 0]
                altera_hdl_wrapper::add_row param_table $param $param
            }
        }
        foreach param $extra_params {
            # type isn't needed for Verilog
            lassign $param name value type style
            if {[string equal -nocase $style "quoted"]} {
                set value "\"$value\""
            }
            altera_hdl_wrapper::add_row param_table $name $value
        }

        altera_hdl_wrapper::append_table text param_table "\n    .%ls (%s)" ","

        append text "\n) $orig_name ("
    } else {
         append text "$orig_name $orig_name ("
    }
    
    # write out port connections as a table so that the ports and signals line up
    altera_hdl_wrapper::create_table port_table 2
    foreach port $ports {
        set name [lindex $port 0]
        altera_hdl_wrapper::add_row port_table $name $name
    }
    altera_hdl_wrapper::append_table text port_table "\n    .%ls (%s)" ","

    append text "\n);\n"
    append text "\n"
    append text "endmodule\n"

    return $text
}

proc altera_hdl_wrapper::delete_final_char_if {var char} {
    upvar $var text
    # delete the final comma if it exists
    if {[string index $text end] == $char} {
        set text [string replace $text end end]
    }
}

proc altera_hdl_wrapper::write_vhdl_wrapper {wrapper_name orig_name params extra_params ports {insert_code ""} noparams } {

    set vect_list [list ]
    if {[llength $ports] > 0} {
        foreach port $ports {
            lassign $port name direction width vhdl_type vect
            if {$vect == 1 && $width==1} {
                lappend vect_list [list $name $direction $width]
            }
        }
    }

    set text "library IEEE;\n"
    append text "use IEEE.std_logic_1164.all;\n"
    append text "use IEEE.numeric_std.all;\n"
    append text "\n"
    append text "entity $wrapper_name is\n"
    if {[llength $params] > 0} {
        append text "    generic ("
        altera_hdl_wrapper::create_table param_table 3
        foreach param $params {
            lassign $param name type value
            if {[string equal -nocase $type "STRING"]} {set value "\"$value\""}
            altera_hdl_wrapper::add_row param_table $name $type $value
        }
        altera_hdl_wrapper::append_table text param_table "\n        %ls : %s := %s" ";"
        append text "\n    );\n"
    }
    if {[llength $ports] > 0} {
        append text "    port ("
        altera_hdl_wrapper::create_table port_table 3
        foreach port $ports {
            lassign $port name direction width vhdl_type
            if {$direction == "Input"} {
                set direction "in"
            } else {
                set direction "out"
            }
            if {$vhdl_type != "STD_LOGIC"} {
                set vhdl_type "${vhdl_type}([expr {$width-1}] downto 0)"
            }
            altera_hdl_wrapper::add_row port_table $name [string tolower $direction] $vhdl_type
        }
        altera_hdl_wrapper::append_table text port_table "\n        %ls : %ls %s" ";"
        append text "\n    );\n"
    }
    append text "end entity $wrapper_name;\n"
    append text "\n"
    append text "architecture rtl of $wrapper_name is\n"
    append text "\n"
    append text "    component  $orig_name \n"
    if {([string equal $noparams false] && [llength $params] > 0) || [llength $extra_params] > 0} {
        append text "        generic ("
        altera_hdl_wrapper::create_table param_table 3
        if {[string equal $noparams false]} {
            foreach param $params {
                lassign $param name type value
                if {[string equal -nocase $type "STRING"]} {set value "\"$value\""}
                altera_hdl_wrapper::add_row param_table $name $type $value
            }
        }
        foreach param $extra_params {
            lassign $param name value type style
			if {[string equal -nocase $style "quoted"]} {set value "\"$value\""}
            altera_hdl_wrapper::add_row param_table $name $type $value
        }
        altera_hdl_wrapper::append_table text param_table "\n            %ls : %s := %s" ";"
        append text "\n        );\n"
    }
    if {[llength $ports] > 0} {
        append text "        port ("
        #altera_hdl_wrapper::append_table text port_table "\n            %ls : %ls %s" ";"

        altera_hdl_wrapper::create_table comp_port_table 3
        foreach port $ports {
            lassign $port name direction width vhdl_type vect
            if {$direction == "Input"} {
                set direction "in"
            } else {
                set direction "out"
            }
            if {$vect == 1 || $width>1} {
                set vhdl_type "STD_LOGIC_VECTOR([expr {$width-1}] downto 0)"
            } else {
                set vhdl_type "STD_LOGIC"
            }
            altera_hdl_wrapper::add_row comp_port_table $name [string tolower $direction] $vhdl_type
        }
        altera_hdl_wrapper::append_table text comp_port_table "\n            %ls : %ls %s" ";"

        append text "\n        );\n"
    }
    append text "    end component $orig_name;\n"
    append text "\n"

    if {[llength $vect_list] > 0} {
        foreach vector $vect_list {
            append text "    signal [lindex $vector 0]_vect : STD_LOGIC_VECTOR([expr [lindex $vector 2]-1] downto 0);\n"
        }
        append text "\n"
    }


    append text "begin\n"
    append text "\n"
    if {[string length $insert_code] > 0} {
        altera_hdl_wrapper::delete_final_char_if insert_code "\n"
        append text "$insert_code\n"
        append text "\n"
    }

    if {[llength $vect_list] > 0} {
        foreach vector $vect_list {
            if {[lindex $vector 1]== "Input"} {
                append text "    [lindex $vector 0]_vect\(0\) <= [lindex $vector 0];\n"
            } else {
                append text "    [lindex $vector 0] <= [lindex $vector 0]_vect\(0\);\n"
            }
        }
        append text "\n"
    }


    append text "    ${orig_name}_inst : component $orig_name"
    if {([string equal $noparams false] && [llength $params] > 0) || [llength $extra_params] > 0} {
        append text "\n        generic map ("
        altera_hdl_wrapper::create_table param_table 2
        if {[string equal $noparams false]} {
            foreach param $params {
                lassign $param name type
                altera_hdl_wrapper::add_row param_table $name $name
            }
        }
        foreach param $extra_params {
            lassign $param name value type style
            if {[string equal -nocase $style "quoted"]} {
                set value "\"$value\""
            }
            altera_hdl_wrapper::add_row param_table $name $value
        }
        altera_hdl_wrapper::append_table text param_table "\n            %ls => %s" ","
        append text "\n        )"
    }
    if {[llength $ports] > 0} {
        append text "\n        port map ("
        altera_hdl_wrapper::create_table port_table 2
        foreach port $ports {
            lassign $port name direction width vhdl_type vect
            set name0 $name
            if {$vect == 1 && $width==1} {
               set name0 "${name}_vect"
            }
            altera_hdl_wrapper::add_row port_table $name $name0
        }
        altera_hdl_wrapper::append_table text port_table "\n            %ls => %s" ","
        append text "\n        )"
    }
    append text ";\n"
    append text "\n"
    append text "end architecture rtl; -- of $wrapper_name\n"

    return $text
}
