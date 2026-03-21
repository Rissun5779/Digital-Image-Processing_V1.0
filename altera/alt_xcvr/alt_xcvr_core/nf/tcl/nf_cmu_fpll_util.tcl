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



proc ::nf_cmu_fpll::parameters::intersect { param_values constraints } {
   if {[llength $param_values] == 0} {return {}}
   if {[llength $constraints] == 0} {return {}}

   if {[llength $constraints] > [llength $param_values]} {
      set temp $param_values
      set param_values $constraints
      set constraints $temp
   }

   set temp {}
   foreach value $param_values {set ($value) {}}
   foreach value $constraints {
      if {[info exists ($value)]} {
         lappend temp $value
      }
   }
   return $temp
}

proc ::nf_cmu_fpll::parameters::exclude { param_values constraints } {
   if {[llength $param_values] == 0} {return {}}
   if {[llength $constraints] == 0} {return {}}

   set temp {}
   foreach value $constraints {set ($value) {}}
   foreach value $param_values {
      if {![info exists ($value)]} {
         lappend temp $value
      }
   }
   return $temp
}

proc ::nf_cmu_fpll::parameters::split_range { value } {
   set range_list [split $value ":"]

   set min_cur [lindex $range_list 0]
   if { [llength $range_list] > 1 } {
      set max_cur [lindex $range_list 1]
   } else {
      set max_cur $min_cur
   }

   return [list $min_cur $max_cur]
}

proc ::nf_cmu_fpll::parameters::union { values } {
   if { [llength $values] > 1 } {
      set union_list {}

      set values_size [llength $values]
      for {set i 0} {$i < $values_size} {incr i} {
         if { ![info exists visited_list($i)] } {
            set visited_list($i) {}

            set range_list [split_range [lindex $values $i]]
            set min_cur [lindex $range_list 0]
            set max_cur [lindex $range_list 1]

            for {set j 1} {$j < $values_size} {incr j} {
               if { ![info exists visited_list($j)] } {
                  set range_list [split_range [lindex $values $j]]
                  set min_next [lindex $range_list 0]
                  set max_next [lindex $range_list 1]   

                  if [expr { ($min_next <= $max_cur + 1) && ($min_cur <= $max_next + 1)}] {
                     set visited_list($j) {}

                     if { $min_cur > $min_next } {
                       set min_cur $min_next
                     }
                     if { $max_cur < $max_next } {
                       set max_cur $max_next
                     }
                  }
               }
            }

            set update_value 1
            for {set j 0} {$j < [llength $union_list]} {incr j} {
               set range_list [split_range [lindex $union_list $j]]
               set min_next [lindex $range_list 0]
               set max_next [lindex $range_list 1]

               if [expr { ($min_next <= $max_cur + 1) && ($min_cur <= $max_next + 1)}] {
                  set update_value 0

                  if { $min_cur > $min_next } {
                     set min_cur $min_next
                     set update_value 1
                  }
                  if { $max_cur < $max_next } {
                     set max_cur $max_next
                     set update_value 1
                  }

                  if { $update_value } {
                     set update_value 0
                     lset union_list $j "${min_cur}:${max_cur}"
                  }
               }
            }

            if { $update_value } {  
               if { $max_cur == $min_cur } {
                  lappend union_list $min_cur
               } else {
                  lappend union_list "${min_cur}:${max_cur}"
               }
            }
         }
      }
   } else {
      set union_list $values
   }

   return $union_list
}

proc ::nf_cmu_fpll::parameters::compare_lt { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { $min < $constraint_value }] {
         if [expr { $max >= $constraint_value }] {
            set max [expr {$constraint_value -1}]
         }

         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_le { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { $min <= $constraint_value }] {
         if [expr { $max > $constraint_value }] {
            set max $constraint_value
         }

         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_gt { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { $max > $constraint_value }] {
         if [expr { $min <= $constraint_value }] {
            set min [expr {$constraint_value + 1}]
         }

         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_ge { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { $max >= $constraint_value }] {
         if [expr { $min < $constraint_value }] {
            set min $constraint_value
         }

         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_eq { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { ($constraint_value >= $min) && ($constraint_value <= $max)}] {
         lappend new_list [list $constraint_value]
         break
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_ne { legal_range_values constraint_value } {
   set new_list {}

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      if [expr { ($constraint_value < $min) || ($constraint_value > $max) }] {
         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      } elseif [expr { ($constraint_value == $min) && ($min != $max) }] {
         set min [expr {$constraint_value + 1}]
         if { $min == $max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$max]
         }
      } elseif [expr { ($constraint_value > $min) && ($min != $max) }] {
         set temp_max [expr {$constraint_value - 1}]
         if { $min == $temp_max } {
            lappend new_list [list $min]
         } else {
            lappend new_list [list $min:$temp_max]
         }

         set temp_min [expr {$constraint_value + 1}]
         if { $temp_min == $max } {
            lappend new_list [list $temp_min]
         } else {
            lappend new_list [list $temp_min:$max]
         }
      }
   }
   return $new_list
}

proc ::nf_cmu_fpll::parameters::compare_inside { legal_range_values constraint_values } {
   set new_list {}
   set constraint_values [union $constraint_values]

   foreach value $legal_range_values {
      set range_list [split_range $value]
      set min [lindex $range_list 0]
      set max [lindex $range_list 1]

      foreach c_value $constraint_values {
         set min_cur $min
         set max_cur $max

         set range_list [split_range $c_value]
         set c_min [lindex $range_list 0]
         set c_max [lindex $range_list 1]

         if [expr { ($max_cur >= $c_min) && ($min_cur <= $c_max)}] {
            if [expr {$min_cur < $c_min}] {
               set min_cur $c_min
            }
            if [expr {$max_cur > $c_max}] {
               set max_cur $c_max
            }
            if { $min_cur == $max_cur } {
               lappend new_list [list $min_cur]
            } else {
               lappend new_list [list ${min_cur}:${max_cur}]
            }
         }
      }
   }

   set new_list [union $new_list]
   return $new_list
}

proc ::nf_cmu_fpll::parameters::get_base_device_user_string { BASE_DEVICE } {

   set loc_base_device [string tolower $BASE_DEVICE]
   set user_dev_revision "NOVAL"

   set dev_map(nightfury4es) 20nm4es
   set dev_map(nightfury4) 20nm4
   set dev_map(nightfury1) 20nm1
   set dev_map(nightfury5) 20nm5
   set dev_map(nightfury5es) 20nm5es
   set dev_map(nightfury2) 20nm2
   set dev_map(nightfury3) 20nm3
   set dev_map(nightfury5es2) 20nm5es2

   if [info exists dev_map($loc_base_device)] {
      set user_dev_revision $dev_map($loc_base_device)
   }

   return $user_dev_revision
}


