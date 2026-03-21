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


#############################################################
# Read Timing Analysis
#############################################################

# Get the minimum of the value of the particular info
# tag from the colleciton.
proc memphy_get_min_in_collection {collection info_tag} {
   set result 1e10
   foreach_in_collection item $collection {  
      set i_delay [get_path_info -$info_tag $item]
      if {$i_delay < $result} { 
         set result $i_delay
      }
   }
   return $result
}

proc memphy_get_pess_dqs_for_read_capture {grp_idx} {
   upvar debug debug
   upvar pins pins
   upvar var var
      
   set scaling_factors(ODV) 0.08
   set scaling_factors(EOL) 0.05
   set scaling_factors(EOL_PERCENTAGE_KEPT_READ) 0.5
   
   set from_node [get_ports [join $pins(rclk,$grp_idx) $pins(rclk_n,$grp_idx)]]
   set to_node { *dff* }
   set dqs_min_delay [memphy_get_min_in_collection [get_path -rise_from $from_node -nworst 1 -min -rise_to $to_node] "arrival_time"]
   set scaling_factor [expr $scaling_factors(ODV) + $scaling_factors(EOL) * $scaling_factors(EOL_PERCENTAGE_KEPT_READ)]
   set dqs_phase_shift [expr $var(UI) * $var(GROUP_${grp_idx}_CAPTURE_PHASE_SHIFT) / 360.0]
   if {$dqs_min_delay == 1e10} {
      set adjusted_dqs_min_delay 0.0
   } else {
      set adjusted_dqs_min_delay [expr $dqs_min_delay - $dqs_phase_shift]
   }
   set Pess_DQS [expr $adjusted_dqs_min_delay * $scaling_factor]
   if {$debug} { puts "adjusted_dqs_min_delay $adjusted_dqs_min_delay" }
   if {$debug} { puts "dqs_min_delay $dqs_min_delay" }
   if {$debug} { puts "scaling_factor $scaling_factor" }
   if {$debug} { puts "Pess_DQS $Pess_DQS" }
   return $Pess_DQS
}

proc memphy_get_pess_dq_for_read_capture {dq} {
   upvar debug debug
   upvar pins pins
      
   set scaling_factors(ODV) 0.08
   set scaling_factors(EOL) 0.05
   set scaling_factors(EOL_PERCENTAGE_KEPT_READ) 0.5
   
   set from_node [get_ports $dq]
   set to_node { *dff* }
   set dq_min_delay [memphy_get_min_in_collection [get_path -rise_from $from_node -nworst 1 -min -rise_to $to_node] "arrival_time"]
   set scaling_factor [expr $scaling_factors(ODV) + $scaling_factors(EOL) * $scaling_factors(EOL_PERCENTAGE_KEPT_READ)]
   set Pess_DQ [expr $dq_min_delay * $scaling_factor]
   if {$debug} { puts "dq_min_delay $dq_min_delay" }
   if {$debug} { puts "scaling_factor $scaling_factor" }
   if {$debug} { puts "Pess_DQ $Pess_DQ" }
   return $Pess_DQ
}

proc memphy_perform_read_capture_analysis {grp_idx opcname inst pin_array_name var_array_name summary_name} {

   #######################################
   # Need access to global variables
   upvar 1 $summary_name global_summary
   upvar 1 $var_array_name var
   upvar 1 $pin_array_name pins

   set IP(read_deskew_mode)      [string tolower $var(GROUP_${grp_idx}_READ_DESKEW_MODE)]
   set num_failing_path 10
   set var(RD_SU_DESKEW_CUSTOM)  $var(GROUP_${grp_idx}_READ_SU_DESKEW_CUSTOM)
   set var(RD_HD_DESKEW_CUSTOM)  $var(GROUP_${grp_idx}_READ_HD_DESKEW_CUSTOM)

   set analysis_name "Read Capture"

   # Debug switch. Change to 1 to get more run-time debug information
   set debug 0   
   set result 1

   set dqs_pins_in ""
   foreach dqsclock [join $pins(rclk,$grp_idx) $pins(rclk_n,$grp_idx)] {
      lappend dqs_pins_in ${dqsclock}_IN
   }
   set all_dq_pins $pins(rdata,$grp_idx)

   if {[llength $all_dq_pins] == 0} {
      return
   }
   
   set panel_name_setup  "$inst||Group $grp_idx||Before Calibration \u0028Negative slacks are OK\u0029||$inst Read Capture \u0028Before Calibration\u0029 (setup)"
   set panel_name_hold   "$inst||Group $grp_idx||Before Calibration \u0028Negative slacks are OK\u0029||$inst Read Capture \u0028Before Calibration\u0029 (hold)"

   #####################################################################
   # Default Read Analysis
   set res_0 [report_timing -detail full_path -from [get_ports $all_dq_pins] \
      -to_clock [get_clocks $dqs_pins_in] -npaths $num_failing_path -panel_name $panel_name_setup -setup -disable_panel_color -quiet]
   set res_1 [report_timing -detail full_path -from [get_ports $all_dq_pins] \
      -to_clock [get_clocks $dqs_pins_in] -npaths $num_failing_path -panel_name $panel_name_hold -hold -disable_panel_color -quiet]

   ###############################
   # Write summary report
   ###############################

   set positive_fcolour [list "black" "blue" "blue"]
   set negative_fcolour [list "black" "red" "red"]

   set summary [list]
   
   set var(RD_SU_BC) [lindex $res_0 1]
   set var(RD_HD_BC) [lindex $res_1 1]
   lappend summary [list "   Before Calibration" [memphy_format_3dp $var(RD_SU_BC)] [memphy_format_3dp $var(RD_HD_BC)]]
   if {$debug} { puts "DEBUG read: [lindex $summary end]" }
   set var(RD_SU_FINAL) $var(RD_SU_BC) 
   set var(RD_HD_FINAL) $var(RD_HD_BC) 

   if {$IP(read_deskew_mode) == "custom"} {
      set var(RD_SU_DESKEW) $var(RD_SU_DESKEW_CUSTOM)
      set var(RD_HD_DESKEW) $var(RD_HD_DESKEW_CUSTOM)
   } elseif {$IP(read_deskew_mode) == "dq_group"} {
      set Pess_DQS [memphy_get_pess_dqs_for_read_capture $grp_idx]
      set var(RD_SU_DESKEW) [expr 0.5*($var(RD_HD_BC) - $var(RD_SU_BC) + $Pess_DQS)]
      set var(RD_HD_DESKEW) [expr 0.5*($var(RD_SU_BC) - $var(RD_HD_BC) + $Pess_DQS)]
   } elseif {$IP(read_deskew_mode) == "per_bit_deskew"} {
      set Pess_DQS [memphy_get_pess_dqs_for_read_capture $grp_idx]
      set min_dvw 1e10
      foreach i_dq_pin $all_dq_pins {
         set i_Pess_DQ [memphy_get_pess_dq_for_read_capture $i_dq_pin]
         set i_setup [lindex [report_timing -quiet -from [get_ports $i_dq_pin] -to_clock [get_clocks $dqs_pins_in] -npaths 400 -setup -nworst 1] 1]
         set i_hold  [lindex [report_timing -quiet -from [get_ports $i_dq_pin] -to_clock [get_clocks $dqs_pins_in] -npaths 400 -hold  -nworst 1] 1]
         set i_dvw [expr $i_setup + $i_hold + $i_Pess_DQ]
         if {$i_dvw < $min_dvw} {
            set min_dvw $i_dvw
         }
      }
      if {$min_dvw == 1e10} {
         set var(RD_SU_DESKEW) 0.0
         set var(RD_HD_DESKEW) 0.0
      } else {
         set balanced_slack [expr ($min_dvw+$Pess_DQS)*0.5]
         set var(RD_SU_DESKEW) [expr $balanced_slack - $var(RD_SU_BC)]
         set var(RD_HD_DESKEW) [expr $balanced_slack - $var(RD_HD_BC)]
      }
   } else {
      set var(RD_SU_DESKEW) 0.0
      set var(RD_HD_DESKEW) 0.0
   }

   set var(RD_SU_DESKEW) [expr -$var(RD_SU_DESKEW)]
   set var(RD_HD_DESKEW) [expr -$var(RD_HD_DESKEW)]

   lappend summary [list "   Deskew Read" [memphy_format_3dp $var(RD_SU_DESKEW) ] [memphy_format_3dp $var(RD_HD_DESKEW)]]
   if {$debug} { puts "DEBUG read: [lindex $summary end]" }
   set var(RD_SU_FINAL) [expr $var(RD_SU_FINAL) - $var(RD_SU_DESKEW)] 
   set var(RD_HD_FINAL) [expr $var(RD_HD_FINAL) - $var(RD_HD_DESKEW)]


   if {$IP(read_deskew_mode) == "dq_group" || $IP(read_deskew_mode) == "per_bit_deskew"} {
      set var(RD_CAL_UNC) [expr $var(RD_CALIBRATION_LOSS_OTHER)+($var(IS_DLL_ON) == 1 ? 0 : $var(RD_TEMP_CAL_LOSS_WO_DLL))+($var(OCT_RECAL) == 1 ? $var(RD_TEMP_CAL_LOSS_OCT_RECAL) : $var(RD_TEMP_CAL_LOSS_WO_OCT_RECAL))]

      set var(RD_SU_CAL_UNC) [expr $var(RD_CAL_UNC) / 2.0]
      set var(RD_HD_CAL_UNC) [expr $var(RD_CAL_UNC) / 2.0]
      lappend summary [list "   [emiftcl_get_parameter_user_string -parameter RD_CAL_UNC]" [memphy_format_3dp $var(RD_SU_CAL_UNC)] [memphy_format_3dp $var(RD_HD_CAL_UNC)]]
      if {$debug} { puts "DEBUG read: [lindex $summary end]" }
      set var(RD_SU_FINAL) [expr $var(RD_SU_FINAL) - $var(RD_SU_CAL_UNC)] 
      set var(RD_HD_FINAL) [expr $var(RD_HD_FINAL) - $var(RD_HD_CAL_UNC)]
   }
   
   set summary [linsert $summary 0 [list "After Calibration" [memphy_format_3dp $var(RD_SU_FINAL)] [memphy_format_3dp $var(RD_HD_FINAL)]]]
   if {$debug} { puts "DEBUG read: [lindex $summary 0]" }

   #######################################
   #######################################
   # Create the read analysis panel   
   
   set setup_slack $var(RD_SU_FINAL)
   set hold_slack  $var(RD_HD_FINAL)

   set panel_name "$inst||Group $grp_idx||$inst $analysis_name"
   set root_folder_name [memphy_get_current_timequest_report_folder]
   
   if { ! [string match "${root_folder_name}*" $panel_name] } {
      set panel_name "${root_folder_name}||$panel_name"
   }
   # Create the root if it doesn't yet exist
   if {[get_report_panel_id $root_folder_name] == -1} {
      set panel_id [create_report_panel -folder $root_folder_name]
   }

   # Delete any pre-existing summary panel
   set panel_id [get_report_panel_id $panel_name]
   if {$panel_id != -1} {
      delete_report_panel -id $panel_id
   }
   
   if {($setup_slack < 0) || ($hold_slack <0)} {
      set panel_id [create_report_panel -table $panel_name -color red]
   } else {
      set panel_id [create_report_panel -table $panel_name]
   }
   add_row_to_table -id $panel_id [list "Operation" "Setup Slack" "Hold Slack"]      
   
   foreach summary_line $summary {
      add_row_to_table -id $panel_id $summary_line -fcolors $positive_fcolour
   }
   
   lappend global_summary [list $opcname 0 "$analysis_name ($opcname)" [memphy_format_3dp $setup_slack] [memphy_format_3dp $hold_slack]]
}


#############################################################
# Write Timing Analysis
#############################################################
proc memphy_get_pess_dqs_for_write_capture {grp_idx} {
   upvar debug debug
   upvar pins pins
   upvar var var
      
   set scaling_factors(ODV) 0.08
   set scaling_factors(EOL) 0.05
   set scaling_factors(EOL_PERCENTAGE_KEPT_WRITE) 0.2
   
   set from_node { *phy_reg* }
   set to_node [get_ports [join $pins(wclk,$grp_idx) $pins(wclk_n,$grp_idx)]]
   set dqs_min_delay [memphy_get_min_in_collection [get_path -rise_from $from_node -nworst 1 -min -rise_to $to_node] "arrival_time"]
   set scaling_factor [expr $scaling_factors(ODV) + $scaling_factors(EOL) * $scaling_factors(EOL_PERCENTAGE_KEPT_WRITE)]
   set dqs_phase_shift [expr $var(UI) * $var(GROUP_${grp_idx}_OUTPUT_STROBE_PHASE) / 360.0]
   if {$dqs_min_delay == 1e10} {
      set adjusted_dqs_min_delay 0.0
   } else {
      set adjusted_dqs_min_delay [expr $dqs_min_delay - $dqs_phase_shift]
   }
   set Pess_DQS [expr $adjusted_dqs_min_delay * $scaling_factor]
   if {$debug} { puts "adjusted_dqs_min_delay $adjusted_dqs_min_delay" }
   if {$debug} { puts "dqs_min_delay $dqs_min_delay" }
   if {$debug} { puts "scaling_factor $scaling_factor" }
   if {$debug} { puts "Pess_DQS $Pess_DQS" }
   return $Pess_DQS
}

proc memphy_get_pess_dq_for_write_capture {dq} {
   upvar debug debug
   upvar pins pins
      
   set scaling_factors(ODV) 0.08
   set scaling_factors(EOL) 0.05
   set scaling_factors(EOL_PERCENTAGE_KEPT_WRITE) 0.2
   
   set from_node { *phy_reg* }
   set to_node [get_ports $dq]
   set dq_min_delay [memphy_get_min_in_collection [get_path -rise_from $from_node -nworst 1 -min -rise_to $to_node] "arrival_time"]
   set scaling_factor [expr $scaling_factors(ODV) + $scaling_factors(EOL) * $scaling_factors(EOL_PERCENTAGE_KEPT_WRITE)]
   set Pess_DQ [expr $dq_min_delay * $scaling_factor]
   if {$debug} { puts "dq_min_delay $dq_min_delay" }
   if {$debug} { puts "scaling_factor $scaling_factor" }
   if {$debug} { puts "Pess_DQ $Pess_DQ" }
   return $Pess_DQ
}

proc memphy_perform_write_launch_analysis {grp_idx opcname inst pin_array_name var_array_name summary_name} {
   set num_failing_path 10

   set analysis_name "Write"

   #######################################
   # Need access to global variables
   upvar 1 $summary_name global_summary
   upvar 1 $var_array_name var
   upvar 1 $pin_array_name pins

   set IP(write_deskew_mode) [string tolower $var(GROUP_${grp_idx}_WRITE_DESKEW_MODE)]
   set var(WR_SU_DESKEW_CUSTOM) $var(GROUP_${grp_idx}_WRITE_SU_DESKEW_CUSTOM)
   set var(WR_HD_DESKEW_CUSTOM) $var(GROUP_${grp_idx}_WRITE_HD_DESKEW_CUSTOM)

   # Debug switch. Change to 1 to get more run-time debug information
   set debug 0   
   set result 1

   set all_dq_pins $pins(wdata,$grp_idx)

   if {[llength $all_dq_pins] == 0} {
      return
   }

   set panel_name_setup  "$inst||Group $grp_idx||Before Calibration \u0028Negative slacks are OK\u0029||$inst Write \u0028Before Calibration\u0029 (setup)"
   set panel_name_hold   "$inst||Group $grp_idx||Before Calibration \u0028Negative slacks are OK\u0029||$inst Write \u0028Before Calibration\u0029 (hold)"

   #####################################################################
   # Default Write Analysis
   set res_0 [report_timing -detail full_path -to [get_ports $all_dq_pins] \
      -npaths $num_failing_path -panel_name $panel_name_setup -setup -disable_panel_color -quiet]
   set res_1 [report_timing -detail full_path -to [get_ports $all_dq_pins] \
      -npaths $num_failing_path -panel_name $panel_name_hold -hold -disable_panel_color -quiet]

   ###############################
   # Write summary report
   ###############################

   set positive_fcolour [list "black" "blue" "blue"]
   set negative_fcolour [list "black" "red" "red"]

   set summary [list]
      
   set var(WR_SU_BC) [lindex $res_0 1]
   set var(WR_HD_BC) [lindex $res_1 1]
   lappend summary [list "   Before Calibration" [memphy_format_3dp $var(WR_SU_BC)] [memphy_format_3dp $var(WR_HD_BC)]]
   if {$debug} { puts "DEBUG write: [lindex $summary end]" }
   set var(WR_SU_FINAL) $var(WR_SU_BC)
   set var(WR_HD_FINAL) $var(WR_HD_BC)

   if {$IP(write_deskew_mode) == "custom"} {
      set var(WR_SU_DESKEW) $var(WR_SU_DESKEW_CUSTOM)
      set var(WR_HD_DESKEW) $var(WR_HD_DESKEW_CUSTOM)
   } elseif {$IP(write_deskew_mode) == "dq_group"} {
      set Pess_DQS [memphy_get_pess_dqs_for_write_capture $grp_idx]
      set var(WR_SU_DESKEW) [expr 0.5*($var(WR_HD_BC) - $var(WR_SU_BC) + $Pess_DQS)]
      set var(WR_HD_DESKEW) [expr 0.5*($var(WR_SU_BC) - $var(WR_HD_BC) + $Pess_DQS)]
   } elseif {$IP(write_deskew_mode) == "per_bit_deskew"} {
      set Pess_DQS [memphy_get_pess_dqs_for_write_capture $grp_idx]
      set min_dvw 1e10
      foreach i_dq_pin $all_dq_pins {
         set i_Pess_DQ [memphy_get_pess_dq_for_write_capture $i_dq_pin]
         set i_setup [lindex [report_timing -quiet -to [get_ports $i_dq_pin] -npaths 400 -setup -nworst 1] 1]
         set i_hold  [lindex [report_timing -quiet -to [get_ports $i_dq_pin] -npaths 400 -hold  -nworst 1] 1]
         set i_dvw [expr $i_setup + $i_hold + $i_Pess_DQ]
         if {$i_dvw < $min_dvw} {
            set min_dvw $i_dvw
         }
      }
      if {$min_dvw == 1e10} {
         set var(WR_SU_DESKEW) 0.0
         set var(WR_HD_DESKEW) 0.0
      } else {
         set balanced_slack [expr ($min_dvw+$Pess_DQS)*0.5]
         set var(WR_SU_DESKEW) [expr $balanced_slack - $var(WR_SU_BC)]
         set var(WR_HD_DESKEW) [expr $balanced_slack - $var(WR_HD_BC)]
      }
   } else {
      set var(WR_SU_DESKEW) 0.0
      set var(WR_HD_DESKEW) 0.0
   }
   
   set var(WR_SU_DESKEW) [expr -$var(WR_SU_DESKEW)]
   set var(WR_HD_DESKEW) [expr -$var(WR_HD_DESKEW)]

   lappend summary [list "   Deskew Write" [memphy_format_3dp $var(WR_SU_DESKEW)] [memphy_format_3dp $var(WR_HD_DESKEW)]]
   if {$debug} { puts "DEBUG write: [lindex $summary end]" }
   set var(WR_SU_FINAL) [expr $var(WR_SU_FINAL) - $var(WR_SU_DESKEW)] 
   set var(WR_HD_FINAL) [expr $var(WR_HD_FINAL) - $var(WR_HD_DESKEW)]

   if {$IP(write_deskew_mode) == "dq_group" || $IP(write_deskew_mode) == "per_bit_deskew"} {

      set var(WR_CAL_UNC) [expr $var(WR_CALIBRATION_LOSS_OTHER)+($var(OCT_RECAL) == 1 ? $var(WR_TEMP_CAL_LOSS_OCT_RECAL) : $var(WR_TEMP_CAL_LOSS_WO_OCT_RECAL))]

      set var(WR_SU_CAL_UNC) [expr $var(WR_CAL_UNC) / 2.0]
      set var(WR_HD_CAL_UNC) [expr $var(WR_CAL_UNC) / 2.0]
      lappend summary [list "   [emiftcl_get_parameter_user_string -parameter WR_CAL_UNC]" [memphy_format_3dp $var(WR_SU_CAL_UNC)] [memphy_format_3dp $var(WR_HD_CAL_UNC)]]
      if {$debug} { puts "DEBUG write: [lindex $summary end]" }
      set var(WR_SU_FINAL) [expr $var(WR_SU_FINAL) - $var(WR_SU_CAL_UNC)] 
      set var(WR_HD_FINAL) [expr $var(WR_HD_FINAL) - $var(WR_HD_CAL_UNC)]
   }

   set summary [linsert $summary 0 [list "After Calibration" [memphy_format_3dp $var(WR_SU_FINAL)] [memphy_format_3dp $var(WR_HD_FINAL)]]]
   if {$debug} { puts "DEBUG write: [lindex $summary 0]" }
   
   #######################################
   #######################################
   # Create the write analysis panel   
   set setup_slack $var(WR_SU_FINAL)
   set hold_slack  $var(WR_HD_FINAL)

   set panel_name "$inst||Group $grp_idx||$inst $analysis_name"
   set root_folder_name [memphy_get_current_timequest_report_folder]
   
   if { ! [string match "${root_folder_name}*" $panel_name] } {
      set panel_name "${root_folder_name}||$panel_name"
   }
   # Create the root if it doesn't yet exist
   if {[get_report_panel_id $root_folder_name] == -1} {
      set panel_id [create_report_panel -folder $root_folder_name]
   }

   # Delete any pre-existing summary panel
   set panel_id [get_report_panel_id $panel_name]
   if {$panel_id != -1} {
      delete_report_panel -id $panel_id
   }
   
   if {($setup_slack < 0) || ($hold_slack <0)} {
      set panel_id [create_report_panel -table $panel_name -color red]
   } else {
      set panel_id [create_report_panel -table $panel_name]
   }
   add_row_to_table -id $panel_id [list "Operation" "Setup Slack" "Hold Slack"]       
   
   foreach summary_line $summary {
      add_row_to_table -id $panel_id $summary_line -fcolors $positive_fcolour
   }
   
   lappend global_summary [list $opcname 0 "$analysis_name ($opcname)" [memphy_format_3dp $setup_slack] [memphy_format_3dp $hold_slack]]
}

