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


# Create input data file

#Parameters
set out_dir                        [lindex $argv 0]
set component_name                 [lindex $argv 1]

set DATA_WIDTH_c                   [lindex $argv 2]
set filter_type                    [lindex $argv 3]
set interpN                        [lindex $argv 4]
set decimN                         [lindex $argv 5]
set NUM_TIMESLOTS              [lindex $argv 6]
set NUM_OF_TAPS_c                  [lindex $argv 7]
set clockRate                      [lindex $argv 8]
set inRate                         [lindex $argv 9]
set bankcount                      [lindex $argv 10]
set modeList                      [lindex $argv 11]
set complex                      [lindex $argv 12]
set mode ""
set num_modes 1
# puts $modeList
if { $modeList ne "--" } {
set modeTemp [split $modeList "_"]
set num_modes [llength $modeTemp]
  foreach var $modeTemp {
      lappend modeMapping [split $var ","]
  }
  set mode 0
} else {
  for {set i 0} {$i < $NUM_TIMESLOTS} {incr i} {
    lappend modeMapping $i
  }
}


if {$complex} {
  set zero "0 0"
} else {
  set zero "0"
}

set INVERSE_TDM_FACTOR_c [expr int([expr ceil([expr double($inRate) / $clockRate])])]
# Adjust samples_factor to reduce/increase the number of samples
set samples_factor 2

set file_name "${out_dir}${component_name}_input.txt"

if { [ catch { set out_file [ open $file_name w ] } err ] } {
    send_message "error" "$err"
    return
}
set total_zero_samples [expr $NUM_OF_TAPS_c*$NUM_TIMESLOTS*$interpN*$decimN*5]
if { $filter_type == "decim" || $filter_type == "frac" } {
  set total_zero_samples [expr $NUM_OF_TAPS_c * 5 * $NUM_TIMESLOTS * $decimN]
} else {
  set total_zero_samples [expr $NUM_OF_TAPS_c * $NUM_TIMESLOTS * $INVERSE_TDM_FACTOR_c ]
}
  
if {$total_zero_samples < 10} {
  set total_zero_samples [expr $total_zero_samples * 3]
}

# Reduce simulation time by reducing the number of samples
if { $NUM_TIMESLOTS < 6 } {
    set total_non_zero_samples [expr $NUM_OF_TAPS_c * $NUM_TIMESLOTS *$decimN ]
} else {
    set total_non_zero_samples [expr $samples_factor * $NUM_TIMESLOTS *$decimN ]
}

if {$INVERSE_TDM_FACTOR_c > 1} {
    set total_non_zero_samples [expr $NUM_OF_TAPS_c * $NUM_TIMESLOTS *$decimN * $INVERSE_TDM_FACTOR_c * $interpN ]
}

if {$total_non_zero_samples < 15} {
  set total_non_zero_samples [expr $total_non_zero_samples * 3]
}

if { $NUM_TIMESLOTS < 6 } {
    set total_random_samples [expr $NUM_OF_TAPS_c * $NUM_TIMESLOTS * $INVERSE_TDM_FACTOR_c]
} else {
    set total_random_samples [expr $samples_factor * $NUM_TIMESLOTS * $INVERSE_TDM_FACTOR_c]
}

if { $filter_type == "decim" || $filter_type == "frac" } {
  set total_random_samples [expr $NUM_OF_TAPS_c * $NUM_TIMESLOTS * $decimN]
}

set total_samples [expr $total_non_zero_samples + $total_zero_samples + $total_random_samples]

#Random set of bank_seq, 0 = 0,1,2,3... , 1= random banks....
set bank_seq_set [expr {int(rand()*2)}]
set cur_mode [expr {int(rand()*$num_modes-1)}]
# for {set cur_mode 0} {$cur_mode < $num_modes} {incr cur_mode} {
  if { $modeList ne "--" } {
   set mode $cur_mode
  } 
  # set mode 1
  if {$bankcount > 1} {
    set bank_seq_cnt 0
    set bank_seq ""
    for {set cnt 0} {$cnt < [expr $total_samples * 2]} {incr cnt} {
      lappend bank_seq [expr $cnt%$bankcount]
    }
  }
  ##all zeros for at least num_of_Taps times.
  for {set idx 0} {$idx < $total_zero_samples} {incr idx} {
    if {$bankcount > 1} {
      if {$bank_seq_set == 0 } {
        puts $out_file "$zero [lindex $bank_seq $bank_seq_cnt] $mode"
        incr bank_seq_cnt
      } else {
        puts $out_file "$zero [expr {int(rand()*$bankcount)}] $mode"
      }
    } else {
    	puts $out_file "$zero $mode"
    }
  }

  ##the first samples of each channel
  set visited {}
  if {$filter_type == "decim" || $filter_type == "frac"} {
    for {set idx 1} {$idx < [expr $decimN+1]} {incr idx} {
      for {set sample 1} {$sample < [expr 2*$NUM_TIMESLOTS+1]} {incr sample} {
        set curChan [lindex [lindex $modeMapping 0] [expr $sample -1]] 
        set val [expr $sample + 1]
        if {$complex} {
          set val "[expr $sample + 1] [expr $sample + 1]"
        }
        set numVisited [llength [lsearch -all $visited $curChan]]
        if { $numVisited >= $decimN } { 
          set val $zero
        }
        lappend visited $curChan
        if {$bankcount > 1} {
          if {$bank_seq_set == 0 } {
            puts $out_file "$val [lindex $bank_seq $bank_seq_cnt] $mode"
            incr bank_seq_cnt
          } else {
          	 puts $out_file "$val [expr {int(rand()*$bankcount)}] $mode"
          }
        } else {
          puts $out_file "$val $mode" 
        }
      }
    }
  } else {
    for {set sample 1} {$sample < [expr 2*($NUM_TIMESLOTS)+1]} {incr sample} {
        set curChan [lindex [lindex $modeMapping 0] [expr $sample -1]] 
        set val [expr $sample + 1]
        if {$complex} {
          set val "[expr $sample + 1] [expr $sample + 1]"
        }
      if {$bankcount > 1} {
        if {$bank_seq_set == 0 } {
          puts $out_file "$val [lindex $bank_seq $bank_seq_cnt] $mode"
          incr bank_seq_cnt
        } else {
          puts $out_file "$val [expr {int(rand()*$bankcount)}] $mode"
        }
      } else {
      	puts $out_file "$val $mode"
      }
    }
  }

##the rest are all zeros
  if {( $filter_type == "decim" || $filter_type == "frac" )} {
    set start_part_two [expr $NUM_TIMESLOTS * $decimN + 1]
  } else {
    set start_part_two [expr $NUM_TIMESLOTS + 1]
  }

  for {set sample $start_part_two} {$sample < [expr $total_non_zero_samples+1]} {incr sample} {
    if {$bankcount > 1} {
      if {$bank_seq_set == 0 } {
        puts $out_file "$zero [lindex $bank_seq $bank_seq_cnt] $mode"
        incr bank_seq_cnt
      } else {
        puts $out_file "$zero [expr {int(rand()*$bankcount)}] $mode"
      }
    } else {
    	puts $out_file "$zero $mode"
    }
  }

  ##random number
  set min_limit [expr 0 - [expr pow (2,[expr $DATA_WIDTH_c-1])]]

  set max_limit [expr [expr pow (2,[expr $DATA_WIDTH_c-1])] - 1]


  for {set idx 0} {$idx < $total_random_samples} {incr idx} {
    if {$complex} {
      set val "[expr {int(rand()*($max_limit-$min_limit+1)+$min_limit)}] [expr {int(rand()*($max_limit-$min_limit+1)+$min_limit)}]"
    } else {
      set val "[expr {int(rand()*($max_limit-$min_limit+1)+$min_limit)}]"
    }
    # generate random integer number in the range [min,max]
    if {$bankcount > 1} {
      if {$bank_seq_set == 0 } {
        puts $out_file "$val [lindex $bank_seq $bank_seq_cnt] $mode"
        incr bank_seq_cnt
      } else {
      	puts $out_file "$val [expr {int(rand()*$bankcount)}] $mode"
      }
    } else {
      puts $out_file "$val $mode"
    }
  }
    ##all zeros for at least num_of_Taps times.

  for {set idx 0} {$idx < $total_zero_samples} {incr idx} {
    if {$bankcount > 1} {
      if {$bank_seq_set == 0 } {
        puts -nonewline $out_file "$zero [lindex $bank_seq $bank_seq_cnt] $mode"
        incr bank_seq_cnt
      } else {
        puts -nonewline $out_file "$zero [expr {int(rand()*$bankcount)}] $mode"
      }
    } else {
      puts -nonewline $out_file "$zero $mode"
    }
    if {$idx != $total_zero_samples } { puts -nonewline $out_file "\n"}
  }
# }
close $out_file
