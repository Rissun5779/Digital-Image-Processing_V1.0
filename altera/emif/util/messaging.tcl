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


package provide altera_emif::util::messaging 0.1

package require altera_emif::util::qini

namespace eval ::altera_emif::util::messaging:: {
   namespace export post_ipgen_i_msg
   namespace export post_ipgen_w_msg
   namespace export post_ipgen_e_msg
   namespace export has_pending_ipgen_e_msg
   namespace export issue_pending_ipgen_e_msg_and_terminate
   namespace export errors_were_thrown
   namespace export reset_error_messages
   
   namespace export emif_dbg
   namespace export emif_ie
   namespace export emif_assert
   
   namespace export emif_utest_enabled
   namespace export emif_utest_start
   namespace export emif_utest_pass
         
   variable debug_level 0
   
   variable debug_fh
   
   variable enable_send_message 0
   
   variable ipgen_err_msgs [list]
   
   variable curr_utest_name
   
   variable had_errors 0
}


proc ::altera_emif::util::messaging::emif_ie {message} {
   variable curr_utest_name
   
   set stack [_stacktrace]
   set message "INTERNAL ERROR: $message"
   puts $message
   puts $stack
   
   if {$curr_utest_name != ""} {
      puts "UNIT TESTS [format "%-70s" $curr_utest_name] FAILED"
      set curr_utest_name ""
   }
   
   error "\n$message\n$stack"
}

proc ::altera_emif::util::messaging::emif_assert {condition {message ""}} {
   variable curr_utest_name
   
   if {![uplevel 1 expr $condition]} {
      if {$message == ""} {
         set message $condition
      }
      
      set stack [_stacktrace]
      set message "ASSERTION ERROR: $message"
      puts $message
      puts $stack
      
      if {$curr_utest_name != ""} {
         puts "UNIT TESTS [format "%-70s" $curr_utest_name] FAILED"
         set curr_utest_name ""
      }
      
      error "\n$message\n$stack"
   }
}

proc ::altera_emif::util::messaging::emif_dbg {msg_debug_level debug_message} {
   variable debug_level
   variable debug_fh
   
   if {$debug_level >= $msg_debug_level} {
      set caller_level [info level]

      if {$caller_level == 1} {
         set caller "::"
      } else {
         set caller_query_level -1
         if {[
            catch {
               for {set i 1} {$i < $caller_level} {incr i} {
                  set caller_name [eval {lindex [info level $i] 0}]
               }
            }
         ] != 0} {
            set caller_query_level [expr {$i - 1}]
         }
         if {$caller_query_level == 0} {
            emif_ie "Internal Error: Found caller level as $caller_query_level!"
         }
         
         set caller [lindex [info level $caller_query_level] 0]
         set caller_namespace [uplevel 1 "namespace current"]
         if {[regexp "^\s*${caller_namespace}" $caller match] == 0} {
            set caller "${caller_namespace}::$caller"
         }
      }
      set debug_msg "DEBUG ${caller}(): $debug_message"
      puts $debug_msg
      if {[::altera_emif::util::qini::ini_is_on "enable_debug_log"]} {
         puts $debug_fh $debug_msg
         flush $debug_fh
      }
   }
   return
}

proc ::altera_emif::util::messaging::emif_utest_enabled {} {
   if {![info exists ::env(EMIF_UNIT_TESTS)] || !$::env(EMIF_UNIT_TESTS)} {
      return 0
   } else {
      return 1
   }  
}

proc ::altera_emif::util::messaging::emif_utest_start {test_name} {
   variable curr_utest_name
   if {! [emif_utest_enabled]} {
      emif_ie "emif_utest_start must not be invoked when unit tests aren't enabled!"
   }
   if {$curr_utest_name != ""} {
      emif_ie "emif_utest_start must not be invoked when a unit test ($curr_utest_name) is already running!"
   }
   set curr_utest_name $test_name
   puts "UNIT TESTS [format "%-70s" $curr_utest_name] STARTED"
}

proc ::altera_emif::util::messaging::emif_utest_pass {} {
   variable curr_utest_name
   if {! [emif_utest_enabled]} {
      emif_ie "emif_utest_pass must not be invoked when unit tests aren't enabled!"
   }
   if {$curr_utest_name == ""} {
      emif_ie "emif_utest_pass must not be invoked before a matching emif_utest_start!"
   }
   puts "UNIT TESTS [format "%-70s" $curr_utest_name] PASSED"
   set curr_utest_name ""
}

proc ::altera_emif::util::messaging::post_ipgen_i_msg {msg_id {msg_args [list]}} {
   variable debug_fh
   variable enable_send_message
   
   if {[info exists ::env(MESSAGE_CHECK_REGTEST)] == 1} {
      puts $msg_id;
   }   

   set msg [get_string $msg_id]
   set arg_i 1
   foreach msg_arg $msg_args {
      set msg [string map [list "%$arg_i" $msg_arg] $msg]
      incr arg_i
   }   

   set formatted_msg $msg
   regsub {^[ ]*} $formatted_msg "" formatted_msg
   regsub {[ ]*$} $formatted_msg "" formatted_msg
   
   if {!$enable_send_message} {
      puts "INFO: $formatted_msg"
   } else {
      send_message info $formatted_msg
   }
   
   if {[::altera_emif::util::qini::ini_is_on "enable_debug_log"]} {
      puts $debug_fh "Info: $formatted_msg"
      flush $debug_fh
   }
   return 1
}

proc ::altera_emif::util::messaging::post_ipgen_w_msg {msg_id {msg_args [list]}} {
   variable debug_fh
   variable enable_send_message

   if {[info exists ::env(MESSAGE_CHECK_REGTEST)] == 1} {
      puts $msg_id;
   }   

   set msg [get_string $msg_id]
   set arg_i 1
   foreach msg_arg $msg_args {
      set msg [string map [list "%$arg_i" $msg_arg] $msg]
      incr arg_i
   }

   set formatted_msg $msg
   regsub {^[ ]*} $formatted_msg "" formatted_msg
   regsub {[ ]*$} $formatted_msg "" formatted_msg
   
   if {!$enable_send_message} {
      puts "WARNING: $formatted_msg"
   } else {
      send_message warning $formatted_msg
   }
   
   if {[::altera_emif::util::qini::ini_is_on "enable_debug_log"]} {
      puts $debug_fh "Warning: $formatted_msg"
      flush $debug_fh
   }
   return 1
}

proc ::altera_emif::util::messaging::post_ipgen_e_msg {msg_id {msg_args [list]}} {
   variable debug_fh
   variable ipgen_err_msgs
   variable enable_send_message

   if {[info exists ::env(MESSAGE_CHECK_REGTEST)] == 1} {
      puts $msg_id;
   }

   set msg [get_string $msg_id]
   set arg_i 1
   foreach msg_arg $msg_args {
      set msg [string map [list "%$arg_i" $msg_arg] $msg]
      incr arg_i
   }

   set formatted_msg $msg
   regsub {^[ ]*} $formatted_msg "" formatted_msg
   regsub {[ ]*$} $formatted_msg "" formatted_msg
   
   lappend ipgen_err_msgs $formatted_msg
   
   if {!$enable_send_message} {
      puts "ERROR: $formatted_msg"
   }
   
   if {[::altera_emif::util::qini::ini_is_on "enable_debug_log"]} {
      puts $debug_fh "Error: $formatted_msg"
      flush $debug_fh
   }
   return 1
}

proc ::altera_emif::util::messaging::has_pending_ipgen_e_msg {} {
   variable ipgen_err_msgs
   return [expr {[llength $ipgen_err_msgs] > 0}]
}

proc ::altera_emif::util::messaging::errors_were_thrown {} {
   variable had_errors
   return $had_errors
}

proc ::altera_emif::util::messaging::reset_error_messages {} {
   variable had_errors
   set had_errors 0
}

proc ::altera_emif::util::messaging::issue_pending_ipgen_e_msg_and_terminate {{force_msg 0}} {
   variable debug_level
   variable enable_send_message
   variable ipgen_err_msgs
   variable had_errors
   
   if {[llength $ipgen_err_msgs] > 0} {
      set had_errors 1
      set local_ipgen_err_msgs $ipgen_err_msgs
      set ipgen_err_msgs [list]
   
      if {$enable_send_message} {
         if {$debug_level == 0 &&
            $force_msg == 0 &&
            [lsearch [split [get_parameters]] DISABLE_CHILD_MESSAGING] != -1 &&
            [string compare -nocase [get_parameter_value DISABLE_CHILD_MESSAGING] "true"] == 0} {
         } else {
            foreach msg $local_ipgen_err_msgs {
               send_message error $msg
            }
         }
      }
   }
   
   return 1
}

proc ::altera_emif::util::messaging::create_table {table_name init_num_cols input_col_width table_data_arr} {
   upvar 1 $table_data_arr table_data
   
   set num_rows  [llength [array names table_data]]

   set col_widths [list]
   set table_width 0
   set table_result [list]
   set seperator_line ""
   set temp_line ""

   set init_col_width $input_col_width
   set num_cols $init_num_cols

   if {$num_cols == -1} {
      set data_row $table_data(0)
      
      set num_cols [llength $data_row]
      set width [list]
      for {set i 0} {$i < $num_cols} {incr i} {
         lappend width 20
      }
      set init_col_width $width;
   }
   
   if {[llength $init_col_width] != $num_cols} {
      puts "Fatal Error: initial column widths is not a list of length $num_cols!"
      exit 1
   }

   for {set y 0} {$y < $num_rows} {incr y} {
      set data_row $table_data($y)
      if {[string compare [lindex $data_row 0] "--SEPERATOR--"] == 0} {
         if {[llength $data_row] != $num_cols} {
            puts "Fatal Error: Data row $y does not have $num_cols columns!"
            exit 1
         }
      }
   }

   for {set x 0} {$x < $num_cols} {incr x} {
      set max_length  0
      for {set y 0} {$y < $num_rows} {incr y} {
         set data_row $table_data($y)
         if {[string compare [lindex $data_row 0] "--SEPERATOR--"] != 0} {
            if {[string length [lindex $data_row $x]] > $max_length} {
               set max_length  [string length [lindex $data_row $x]]
            }
         }
      }
      lappend col_widths $max_length
   }

   for {set x 0} {$x < $num_cols} {incr x} {
      if {[lindex $init_col_width $x] > [lindex $col_widths $x]} {
         set col_widths [lreplace $col_widths $x $x [lindex $init_col_width $x]]
      }
   }

   for {set x 0} {$x < $num_cols} {incr x} {
      set table_width [expr {$table_width + [lindex $col_widths $x] +2 +1}]
   }
   incr table_width

   set while_limit [expr {$table_width-4}]
   while {$while_limit < [string length $table_name]} {
      for {set x 0} {$x < $num_cols} {incr x} {
         lreplace $col_widths $x $x [expr {[lindex $col_widths $x] + 1}]
         incr table_width
         set while_limit [expr {$table_width-4}]
         set condition_expr [expr {$table_width-4}]
         if {$condition_expr >= [string length $table_name]} {
            break
         }
      }
   }

   
   set line "+[string repeat - [expr {$table_width-2}]]+"
   lappend table_result $line
   set line [format "| %-*s |" [expr {$table_width-4}] $table_name]
   lappend table_result $line
   set line "+[string repeat - [expr {$table_width-2}]]+"
   lappend table_result $line

   set seperator_line ""
   for {set x 0} {$x < $num_cols} {incr x} {
      set seperator_line "${seperator_line}+[string repeat - [expr {[lindex $col_widths $x]+2}]]"
   }
   set seperator_line "${seperator_line}+"
   lappend table_result $seperator_line

   for {set y 0} {$y < $num_rows} {incr y} {
      set data_row $table_data($y)
      if {[string compare [lindex $data_row 0] "--SEPERATOR--"] == 0} {
         lappend table_result $seperator_line
      } else {
         set temp_line ""
         for {set x 0} {$x < $num_cols} {incr x} {
            set temp_line [format "%s| %-*s " $temp_line [lindex $col_widths $x] [lindex $data_row $x]]
         }
         lappend table_result "${temp_line}|"
      }
   }

   set seperator_line "${seperator_line}"
   lappend table_result $seperator_line

   return $table_result
}


proc ::altera_emif::util::messaging::_stacktrace {} {
   set stack "Stack trace:\n"
   for {set i 1} {$i < [info level]} {incr i} {
      set lvl [info level -$i]
      append stack "   $lvl\n"
   }
   return $stack
}

proc ::altera_emif::util::messaging::_init {} {
   variable debug_level
   variable debug_fh
   variable enable_send_message
   variable curr_utest_name
   
   set curr_utest_name ""

   if {[llength [info commands send_message]] == 1} {
      set enable_send_message 1
   } else {
      set enable_send_message 0
   }

   if {[::altera_emif::util::qini::ini_is_on "enable_debug_log"]} {
      set debug_fh [::open "altera_emif_debug_log.txt" w+]
   }

   set debug_level [::altera_emif::util::qini::get_ini_value "debug_msg_level" 0]
   
   if {$debug_level == 0} {
      set debug_level [::altera_emif::util::qini::ini_is_on "debug_msg"]
   }
   
   emif_dbg 1 "Setting debug level to $debug_level"

   return 1
}


::altera_emif::util::messaging::_init


