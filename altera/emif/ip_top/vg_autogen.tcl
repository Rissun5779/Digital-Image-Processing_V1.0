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


package provide altera_emif::ip_top::vg_autogen 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::ctrl_expert
package require altera_emif::ip_top::phy
package require altera_emif::ip_top::mem
package require altera_emif::ip_top::board
package require altera_emif::ip_top::ctrl
package require altera_emif::ip_top::diag
package require altera_emif::ip_top::ex_design_gui
package require altera_emif::ip_top::protocol_expert
package require altera_iopll_common::iopll

namespace eval ::altera_emif::ip_top::vg_autogen:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_iopll_common::iopll::*
   namespace import ::altera_emif::util::math::*

}

proc ::altera_emif::ip_top::vg_autogen::generate_xml {} {
   dict set requirement compile           {}
   dict set requirement timing_closure    {}
   dict set requirement files             {}
   dict set requirement ex_tb             {}
   dict set requirement generate          {}
   dict set requirement qcore_rtl_vlg     {}
   dict set requirement qcore_rtl_vhdl    {}
   dict set requirement vcs_rtl_vlg       {}
   dict set requirement vcsmx_rtl_vlg     {}
   dict set requirement vcsmx_rtl_vhdl    {}
   dict set requirement ncsim_rtl_vlg     {}
   dict set requirement ncsim_rtl_vhdl    {}
   dict set requirement msimae_rtl_vlg    {}
   dict set requirement msimae_rtl_vhdl   {}
   dict set requirement riviera_rtl_vlg   {}
   dict set requirement riviera_rtl_vhdl  {}

   set curr_device_family [::altera_emif::util::device_family::get_device_family_enum]

   set fp [open "${::env(AUTOGEN_VG_XML)}/tags.csv"]
   set tag_file [read $fp]

   set header_line_in_csv 1
   set headings_list {}

   set tags_dict []

   puts [get_parameter_value DIAG_SIM_CAL_MODE_ENUM]
   puts [get_parameter_value DIAG_DDR3_SIM_CAL_MODE_ENUM]
   puts [get_parameter_value DIAG_LPDDR3_SIM_CAL_MODE_ENUM]
   puts [get_parameter_value DIAG_DDR4_SIM_CAL_MODE_ENUM]

   foreach line [split $tag_file "\n"] {
      set headings_list {}
      if {$header_line_in_csv > 0} {
         set header_line_in_csv 0
         foreach heading [split $line ","] {
            lappend headings_list [string trim $heading]
         }
      } elseif {$line ne ""} {
         foreach heading [split $line ","] {
            lappend headings_list [string trim $heading]
         }
         dict set tags_dict [lindex $headings_list 0] [lindex $headings_list 1]
      }
   }

   set fp [open "${::env(AUTOGEN_VG_XML)}/altera_emif_cov_req.xml.template"]
   set template [read $fp]

   close $fp

   set protocol NULL


   set index 0

   set cross_products_hash [dict create]

   set list_of_cross_product_groups [list]
   set list_of_individual_cross_products [list]

   foreach {match group contents} [regexp -all -inline {([\w.]+)\.\{([\w,*\s]+)\}} $template] {
      if {[dict exists $requirement $group] && [lsearch $list_of_cross_product_groups [string trim $contents]] < 0} {
         lappend list_of_cross_product_groups $contents
      }
      incr index
      foreach cross_product [split $contents ","] {
         if {[dict exists $requirement $group] && [lsearch $list_of_individual_cross_products [string trim $cross_product]] < 0} {
            lappend list_of_individual_cross_products [string trim $cross_product]
         }
      }
   }

   foreach cross_product $list_of_individual_cross_products {
      set cross_prod_result_list [list]
      foreach param_in_cross_product [split $cross_product "*"] {
         if {[dict exists $tags_dict [string trim $param_in_cross_product]]} {
            if {$cross_prod_result_list == [list]} {
               foreach entry_in_param [enum_dropdown_entries [string trim $param_in_cross_product]] {
                  regexp {^(\w+)\:\w+} $entry_in_param match extracted_tag
                  set corresponding_regtest_tag [dict get $tags_dict [string trim $param_in_cross_product]]
                  lappend cross_prod_result_list "param_${corresponding_regtest_tag}_val_${extracted_tag}"
               }
            } else {
               set temp_list [list]
               set i [expr {[llength $cross_prod_result_list] - 1}]
               foreach entry_in_list $cross_prod_result_list {
                  foreach entry_in_param [enum_dropdown_entries [string trim $param_in_cross_product]] {
                     regexp {^(\w+)\:\w+} $entry_in_param match extracted_tag
                     set corresponding_regtest_tag [dict get $tags_dict [string trim $param_in_cross_product]]
                     if {[regexp {param_PROTOCOL_ENUM_val_PROTOCOL_([a-zA-Z0-9]+)} $entry_in_list match protocol]} {
                        regsub -all {\$protocol} $corresponding_regtest_tag $protocol corresponding_regtest_tag
                     }
                     if {[string trim $param_in_cross_product] eq "RATE" && [regexp {param_PROTOCOL_ENUM_val_(PROTOCOL_[a-zA-Z0-9]+)} $entry_in_list match tag_element]} {
                        if {[lsearch [::altera_emif::ip_top::util::get_dropdown_entries FEATURE_RATE $tag_element] $entry_in_param] >= 0} {
                           lappend temp_list "${entry_in_list}_param_${corresponding_regtest_tag}_val_${extracted_tag}"
                        }
                     } elseif {$param_in_cross_product eq "MEM_FORMAT"} {
                        if {$protocol eq "DDR3" || $protocol eq "DDR4"} {
                           lappend temp_list "${entry_in_list}_param_${corresponding_regtest_tag}_val_${extracted_tag}"
                        } elseif {$extracted_tag eq "MEM_FORMAT_DISCRETE"} {
                           lappend temp_list "${entry_in_list}_param_${corresponding_regtest_tag}_val_${extracted_tag}"
                        }
                     }  else {
                        lappend temp_list "${entry_in_list}_param_${corresponding_regtest_tag}_val_${extracted_tag}"
                     }
                  }
               }
               lappend cross_prod_result_list {*}$temp_list
               set cross_prod_result_list [lreplace $cross_prod_result_list 0 $i]
            }
            dict set cross_products_hash $cross_product $cross_prod_result_list
         } elseif {[dict exists $cross_products_hash $cross_product]} {
            dict remove cross_products_hash $cross_product
            break
         }
      }
   }

   set template2 $template

   foreach {match cross_product} [regexp -all -inline {[ ,\{]([\w*]+)[, \}]} $template2] {
      if {[dict exists $cross_products_hash $cross_product]} {
         set cross_product_regex [string map {\* \[\*\]} $cross_product]
         regsub -all [join [list {[.]\{[\s]*} ${cross_product_regex} {,[\s]*}] ""] $template2 [join [list ".\{" [join [dict get $cross_products_hash $cross_product] ", "] ", "] ""] template2
         regsub -all [join [list {[\s]*,[\s]*} ${cross_product_regex} {[\s]*,[\s]*}] ""] $template2 [join [list ", " [join [dict get $cross_products_hash $cross_product] ", "] ", "] ""] template2
         regsub -all [join [list {,[\s]*} ${cross_product_regex} {[\s]*\}[\s]*}] ""] $template2 [join [list ", " [join [dict get $cross_products_hash $cross_product] ", "] "\}"] ""] template2
      }
   }

   set fo [open "/data/rchandan/xml/altera_emif_cov_req.xml" "w"]
   puts $fo $template2

   close $fo

}


proc ::altera_emif::ip_top::vg_autogen::_init {} {
}

::altera_emif::ip_top::vg_autogen::_init




