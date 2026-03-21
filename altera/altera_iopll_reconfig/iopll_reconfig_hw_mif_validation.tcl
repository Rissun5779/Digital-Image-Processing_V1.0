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



# +============================================================================================================
# | MIF VALIDATION

package provide altera_iopll_reconfig::mif_validation 14.0
namespace eval altera_iopll_reconfig::mif_validation {
   namespace export validate_reconfig_mif_file
}

proc altera_iopll_reconfig::mif_validation::validate_reconfig_mif_file	{ curr_filename ROM_width }	{

     set curr_file      [open $curr_filename r]
     set curr_file_data [read $curr_file]
     set curr_file_data_lines [split $curr_file_data "\n"]
     set curr_file_line 0
     set num_configs    0
     set line_index 0
     set conf_line_count 0 
     set conf_value_list [list]
     set conf_name_list [list]
     set conf_sizes [list]
     set conf_m_src [list]
     set config_indices [list]
     set allow_file true
     set new_config true

   # +-----------------------------------
   # | Parse the user's input MIF file for:
   # |  - Number of configurations
   # |  - Total size
   # +----------------------------------- 
     
     foreach line $curr_file_data_lines {
         if {[regexp {([0-9]+):(([1]{16});[ \t]*(--.*)*)$} $line full_match line_index value_and_comment value comment]} {
             ## Line is of the form #:1111111111111111   (--COMMENT)? \n
             ## This is the end of a configuration.

             ## Update the size of this config
             lappend conf_name_list "Configuration $num_configs size"
             lappend conf_value_list $conf_line_count
             lappend conf_sizes $conf_line_count
             if {$conf_line_count == 0} {
                 send_message WARNING "MIF validation: Configuration $num_configs contains zero instructions."
             }
             set conf_line_count 0

             ## Update the name of this config
             lappend conf_name_list "Configuration $num_configs name"
             if {[regexp {(--END_OF_CONFIG:([A-Za-z0-9_]*))} $comment full_match full value]} {
                 lappend conf_value_list $value
             } else {
                 lappend conf_value_list unnamed
             }
             incr num_configs
             set new_config true
         } elseif {[regexp {([0-9]+):(([0-1]{16});[ \t]*(--.*)*)$} $line full_match line_index value_and_comment value comment]} {
             ## Add a header for a new config if this is the first line. 
             if {$new_config} {
                 lappend conf_name_list ""
                 lappend conf_value_list ""
                 lappend conf_name_list "<html><b>Configuration $num_configs parameters</b><br>"
                 lappend conf_value_list ""

                 lappend config_indices [list MIF_ADDRESS_$num_configs $line_index]
             }
             set new_config false
             set split_comments [split $comment ","]
             foreach pair $split_comments {
                 if {[regexp {([A-Za-z0-9_]*):([A-Za-z0-9_]*)} $pair full_match param value]} {
                     lappend conf_name_list $param
                     lappend conf_value_list $value
                     if {[regexp {M_SRC_MUX} $param]} {
                         lappend conf_m_src $value
                     } 
                 }   
             } 
             incr conf_line_count
         } elseif {[regexp {DEPTH} $line] || [regexp {WIDTH} $line]||[regexp {ADDRESS_RADIX} $line]||[regexp {DATA_RADIX} $line] \
                 ||[regexp {CONTENT} $line]||[regexp {BEGIN} $line]||[regexp {END;} $line]||[regexp {^[ \t]*$} $line]} {
             ## This line is not illegal, but it doesn't need to be validated.
         } else {
             send_message ERROR "Invalid MIF file: Unrecognized line in MIF file: $line"
             set allow_file false
         }
     }

     if {!$new_config} {
         send_message ERROR "Invalid MIF file: The last configuration has no 'End of Configuration' sequence (1111111111111111)."
         set allow_file false
     }

     if {$num_configs > 32} {
         send_message ERROR "Invalid MIF file: Contains more than 32 IOPLL configurations."
         set allow_file false
     }

     if {$num_configs > 0} {
         set num_lines [expr {$line_index +1 }]
         set mif_width $ROM_width
     } else {
         set num_lines 0
         set mif_width 0
     }

     set uniq_sizes [lsort -unique $conf_sizes]
     if {[llength $uniq_sizes] != 1} {
         send_message WARNING "MIF validation: Different configurations have different numbers of instructions. All configurations should have the same number of instructions."
     }
     set uniq_m_src [lsort -unique $conf_m_src]
     if {[llength $uniq_m_src] != 1 && [llength $uniq_m_src] != 0} {
         send_message ERROR "Invalid MIF file: Different configurations have different compensation modes (different M_SRC_MUX values). Compensation mode is not reconfigurable."
         set allow_file false
     }

     lappend names_list "<html><b>General Information</b><br>"
     lappend value_list ""
     lappend names_list "Number of IOPLL Configurations"
     lappend value_list $num_configs
     lappend names_list "Depth of MIF File"
     lappend value_list $num_lines
     lappend names_list "Width of MIF File"
     lappend value_list $ROM_width

     set table_names [concat $names_list $conf_name_list]
     set table_values [concat $value_list $conf_value_list]
     set return_array [list $allow_file $table_names $table_values $config_indices $num_lines]

     close $curr_file
     return $return_array
}
