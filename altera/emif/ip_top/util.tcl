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


package provide altera_emif::ip_top::util 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::math
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::util:: {
   namespace export derating_table_lookup
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_top::util::get_dropdown_entries {feature_enum protocol_enum} {
   set retval [list]
   foreach enum [get_feature_support_level $feature_enum $protocol_enum] {
      lappend retval [::altera_emif::util::enums::enum_dropdown_entry $enum]
   }
   return $retval
}   

proc ::altera_emif::ip_top::util::ns_to_tck {ns_value clk_period_ns} {

   set ns_to_tck_float [expr {$ns_value / $clk_period_ns}]
   
   set ns_to_tck_float [expr {round($ns_to_tck_float * 100.0) / 100.0}]

   return [expr {int(ceil($ns_to_tck_float))}]
}


proc ::altera_emif::ip_top::util::tck_to_ns {tck_value clk_freq_mhz n_dec} {
    
   set clk_period_ns [expr {1.0 / $clk_freq_mhz * 1000.0}]
   set ns_value [expr {$tck_value * $clk_period_ns}]
    
   for {set i 0} {$i < $n_dec} {incr i 1} {
       set ns_value [expr {$ns_value * 10.0}]
   }
   set ns_value [expr {ceil($ns_value)}]
   for {set i 0} {$i < $n_dec} {incr i 1} {
       set ns_value [expr {$ns_value / 10.0}]
   }
   return $ns_value
}


proc ::altera_emif::ip_top::util::derating_table_lookup {x_name y_name q_name a b param_name} {

   set ok 1
   
   set x $x_name
   set y $y_name
   set q $q_name

   set x_last [expr {[llength $x] - 1}]
   set y_last [expr {[llength $y] - 1}]
   
   if {$ok} {
      if {[llength $x] == 0 || [llength $y] == 0 || [llength $q] == 0} { 
         post_ipgen_e_msg MSG_NO_DERATING_TABLE [list [get_parameter_property $param_name DISPLAY_NAME]]
         set ok 0
      }
   }

   if {$ok} {
      if {$a > [lindex $x 0] || $a < [lindex $x $x_last]} {
         post_ipgen_e_msg MSG_UNSUPPORTED_SLEW_RATES [list [get_parameter_property $param_name DISPLAY_NAME]]
         set ok 0
      }
   }
   
   if {$ok} {
      if {$b > [lindex $y 0] || $b < [lindex $y $y_last]} {
         post_ipgen_e_msg MSG_UNSUPPORTED_SLEW_RATES [list [get_parameter_property $param_name DISPLAY_NAME]]
         set ok 0
      }
   }
   
   if {$ok} {
      for {set x_index1 1} {$x_index1 <= $x_last} {incr x_index1} {
         if {$a > [lindex $x $x_index1]} { 
            set x_index2 [expr {$x_index1 - 1}]
            break 
         } elseif {$a == [lindex $x $x_index1]} { 
            set x_index2 $x_index1
            break
         }
      }
      for {set y_index1 1} {$y_index1 <= $y_last} {incr y_index1} {
         if {$b > [lindex $y $y_index1]} { 
            set y_index2 [expr {$y_index1 - 1}]
            break
         } elseif {$b == [lindex $y $y_index1]} { 
            set y_index2 $y_index1
            break
         }
      }
      
      set x1 [lindex $x $x_index1]
      set x2 [lindex $x $x_index2]
      set y1 [lindex $y $y_index1]
      set y2 [lindex $y $y_index2]
      
      set q11 [lindex [lindex $q $x_index1] $y_index1]
      set q12 [lindex [lindex $q $x_index1] $y_index2]
      set q21 [lindex [lindex $q $x_index2] $y_index1]
      set q22 [lindex [lindex $q $x_index2] $y_index2]
      
      if {[expr {abs($q11)}] == 999 || [expr {abs($q12)}] == 999 || [expr {abs($q21)}] == 999 || [expr {abs($q22)}] == 999} {
         post_ipgen_e_msg MSG_UNSUPPORTED_SLEW_RATES [list [get_parameter_property $param_name DISPLAY_NAME]]
         set ok 0
      }
   }
   
   if {$ok} {
      return [bilinear_interpolate $x1 $x2 $y1 $y2 $q11 $q12 $q21 $q22 $a $b]
   } else {
      return 0
   }
}

proc ::altera_emif::ip_top::util::_init {} {
}

::altera_emif::ip_top::util::_init
