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


package provide altera_emif::util::doc_gen 0.1

package require altera_emif::util::messaging

namespace eval ::altera_emif::util::doc_gen:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::util::doc_gen::add_section {docs_varname filename title order contents} {

   upvar 1 $docs_varname docs

   if {! [dict exists $docs $filename]} {
      dict set docs $filename [dict create]
      dict set docs $filename __MAX_ORDER 0
   }
   
   if {$order < 0} {
      set order [expr {[dict get $docs $filename __MAX_ORDER] + 1}]
   }
   if {$order > [dict get $docs $filename __MAX_ORDER]} {
      dict set docs $filename __MAX_ORDER $order
   }
   
   if {! [dict exists $docs $filename $title]} {
      dict set docs $filename $title [dict create]
   }
   
   dict set docs $filename $title ORDER $order
   dict set docs $filename $title CONTENTS $contents
}

proc ::altera_emif::util::doc_gen::export_extended_documentation {docs_varname} {

   upvar 1 $docs_varname docs

   set retval [list]
   set div [string repeat "-" 80]

   set params_protocols_dict [_add_parameter_descriptions]

   foreach protocol_enum [lsort [dict keys $params_protocols_dict]] {
      set lines [list]

      set param_groups_dict [dict get $params_protocols_dict $protocol_enum]
      foreach param_group [dict keys $param_groups_dict] {
         set param_group_name [get_string "GROUP_${param_group}_NAME"]
         lappend lines "${param_group_name}\n$div\n"

         set params_dict [dict get $param_groups_dict $param_group]
         foreach param_name [lsort [dict keys $params_dict]] {
            set param_display_name [dict get $params_dict $param_name DISPLAY_NAME]
            set param_desc         [dict get $params_dict $param_name DESC]

            set change_tag ""
            if {[get_string "PARAM_${param_name}_STATUS"] ne "R"} {
               set change_tag "\[MODIFIED\] "
            }

            lappend lines "${change_tag}${param_display_name} (${param_name}):\n$param_desc\n"
         }
      }
      set title [enum_data $protocol_enum UI_NAME] 
      add_section docs "params_doc.txt" $title -1 $lines
   }

   lappend retval {*}[_generate_params_xml $params_protocols_dict "params_doc"]

   set sigs_protocols_dict [_add_signal_descriptions]
   
   foreach protocol_enum [dict keys $sigs_protocols_dict] {
      set lines [list]
      set ifs_dict [dict get $sigs_protocols_dict $protocol_enum]
      foreach if_enum [dict keys $ifs_dict] {
         set if_port_string ""

         set ports_dict [dict get $sigs_protocols_dict $protocol_enum $if_enum PORTS]
         foreach port_enum [dict keys $ports_dict] {
            set port_rtl_name [dict get $ports_dict $port_enum RTL_NAME]
            set port_dir      [dict get $ports_dict $port_enum DIR]
            set port_desc     [dict get $ports_dict $port_enum DESC]

            set change_tag ""
            if {[get_string "${port_enum}_STATUS"] ne "R"} {
               set change_tag "\[MODIFIED\] "
            }

            append if_port_string "${change_tag}${port_rtl_name} ($port_dir): $port_desc\n"
         }

         set if_name [dict get $ifs_dict $if_enum NAME]
         set if_type [dict get $ifs_dict $if_enum TYPE]
         set if_desc [dict get $ifs_dict $if_enum DESC]

         set change_tag ""
         if {[get_string "${if_enum}_STATUS"] ne "R"} {
            set change_tag "\[MODIFIED\] "
         }

         lappend lines "${change_tag}${if_name} ($if_type): $if_desc\n$div\n$if_port_string"
      }
      set title [enum_data $protocol_enum UI_NAME]

      add_section docs "sigs_doc.txt" $title -1 $lines
   }

   lappend retval {*}[_generate_sigs_xml $sigs_protocols_dict "sigs_doc"]

   return $retval
}

proc ::altera_emif::util::doc_gen::generate_files {top_level docs} {

   set retval [list]
   
   foreach base_filename [dict keys $docs] {
      
      set filename "${top_level}_${base_filename}"
      
      set doc [dict get $docs $base_filename]
      lappend retval [_generate_file $filename $doc]
   }
   return $retval
}


proc ::altera_emif::util::doc_gen::_generate_file {filename doc} {
   
   set sections [list]
   foreach title [dict keys $doc] {
      if {$title != "__MAX_ORDER" } {
         set order [dict get $doc $title ORDER]
         set contents [dict get $doc $title CONTENTS]
         lappend sections [list $order $title $contents]
      }
   }
   set sections [lsort -integer -index 0 $sections]
   
   set file [create_temp_file $filename]
   set fh   [open $file "w"] 
   
   puts $fh "---------------------"
   puts $fh "; Table of Contents ;"
   puts $fh "---------------------"
   
   set section_i 1
   foreach section $sections {
      set title [lindex $section 1]
      puts $fh "[format "%3s" $section_i]. $title" 
      incr section_i
   }
   
   puts $fh ""
   puts $fh ""
   
   set section_i 1
   foreach section $sections {
      set title    "; [format "%3s" $section_i]. [lindex $section 1] ;"
      set contents [lindex $section 2]
      set sep      [string repeat "-" [string length $title]]
      puts $fh $sep
      puts $fh $title
      puts $fh $sep
      puts $fh ""
      puts $fh "   [join $contents "\n   "]"
      puts $fh ""
      puts $fh ""
      incr section_i
   }
   
   close $fh
   return $file
}

proc ::altera_emif::util::doc_gen::_add_parameter_descriptions {} {

   set protocols_list [enums_of_type PROTOCOL]
   set global_params_list [get_parameters]
   set params_protocols_dict [dict create]

   foreach protocol_enum $protocols_list {
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }

      set param_groups_dict [dict create]
      foreach param_name $global_params_list {
         if {![get_parameter_property $param_name DERIVED]} {
            set relevant 1
            foreach curr_protocol_enum $protocols_list {
               if {$curr_protocol_enum == "PROTOCOL_INVALID"} {
                  continue
               }

               if {$protocol_enum != $curr_protocol_enum} {
                  set module_name "_[string toupper [enum_data $curr_protocol_enum MODULE_NAME]]_"
                  if {[string first $module_name $param_name] != -1} {
                     set relevant 0
                     break
                  }
               }
            }
            if {$relevant} {
               set param_display_name [get_string PARAM_${param_name}_NAME]
               set param_desc [get_string PARAM_${param_name}_DESC]

               if {$param_display_name != "PARAM_${param_name}_NAME"} {
                  dict set param_dict DISPLAY_NAME $param_display_name
                  dict set param_dict DESC $param_desc

                  set param_group "GEN"
                  if {[string match "DIAG_*" $param_name]} {
                     set param_group DIAG
                  } elseif {[string match "EX_DESIGN_*" $param_name]} {
                     set param_group EX_DESIGN
                  } elseif {[string match "CTRL_*" $param_name]} {
                     set param_group CTRL
                  } elseif {[string match "MEM_*" $param_name]} {
                     set param_group MEM
                  } elseif {[string match "BOARD_*" $param_name]} {
                     set param_group BOARD
                  }

                  dict set param_groups_dict $param_group $param_name $param_dict
               }
            }
         }
      }

      dict set params_protocols_dict $protocol_enum $param_groups_dict
   }

   return $params_protocols_dict
}

proc ::altera_emif::util::doc_gen::_add_signal_descriptions {} {

   set protocols [enums_of_type PROTOCOL]
   set sigs_protocols_dict [dict create]

   foreach protocol_enum $protocols {
      if {$protocol_enum == "PROTOCOL_INVALID"} {
            continue
         }

      set ifs_dict [dict create]
      foreach if_enum [enums_of_type IF] {
         set include_all_ports 0
         set if_protocols [enum_data $if_enum PROTOCOLS]
         if {$if_protocols eq "ALL" || [lsearch $if_protocols $protocol_enum] != -1} {
            set include_all_ports 1
         }

         set port_enum_type [enum_data $if_enum PORT_ENUM_TYPE]
         if {[enum_type_exists $port_enum_type] == 1} {
            set ports_dict [dict create]
            set prev_port_enum ""
            foreach port_enum [enums_of_type $port_enum_type] {
               set port_protocols [enum_data $port_enum PROTOCOLS]
               if {$include_all_ports == 1 || $port_protocols eq "ALL" || [lsearch $port_protocols $protocol_enum] != -1} {
                  if {$port_enum != $prev_port_enum} {
                     set port_dir_key \
                           "PORT_DIR_[string toupper [enum_data $port_enum QSYS_DIR]]_DESC"

                     dict set ports_dict $port_enum [dict create]
                     dict set ports_dict $port_enum RTL_NAME [enum_data $port_enum RTL_NAME]
                     dict set ports_dict $port_enum DESC [get_string "${port_enum}_DESC"]
                     dict set ports_dict $port_enum DIR [get_string ${port_dir_key}]
                  }
                  set prev_port_enum $port_enum
               }
            }

            if {[dict size $ports_dict] != 0} {
               set if_qsys_type [string toupper [enum_data $if_enum QSYS_TYPE]]
               set if_qsys_dir  [string toupper [enum_data $if_enum QSYS_DIR]]

               dict set ifs_dict $if_enum [dict create]
               dict set ifs_dict $if_enum NAME  [enum_data $if_enum QSYS_NAME]
               dict set ifs_dict $if_enum DESC  [get_string "${if_enum}_DESC"]
               dict set ifs_dict $if_enum PORTS $ports_dict
               dict set ifs_dict $if_enum TYPE  [get_string "IF_TYPE_${if_qsys_type}_${if_qsys_dir}_DESC"]
            }
         }
      }
      if {[dict size $ifs_dict] != 0} {
         dict set sigs_protocols_dict $protocol_enum $ifs_dict
      }
   }

   return $sigs_protocols_dict
}

proc ::altera_emif::util::doc_gen::_xml {lines_varname indent line} {
   if {$indent < 0} {error "Negative indent passed to _xml"}

   upvar 1 $lines_varname lines

   set indent_string [string repeat "   " $indent]
   lappend lines "${indent_string}${line}"
}

proc ::altera_emif::util::doc_gen::_generate_params_xml {params_protocols_dict dir} {
   set quartus_version_num $::env(ACDS_VERSION)
   set quartus_build $::env(ACDS_BUILD_NUMBER)
   set current_time [clock format [clock seconds]]
   if {$quartus_version_num ne "" && $quartus_build ne ""} {
      set quartus_version_msg " and is sourced from ACDS Version $quartus_version_num Build $quartus_build"
   } else {
      set quartus_version_msg ""
   }

   set files [dict create]

   foreach protocol_enum [lsort [dict keys $params_protocols_dict]] {
      set protocol_ui_name [enum_data $protocol_enum UI_NAME]
      set protocol_tag [enum_data $protocol_enum MODULE_NAME]
      set param_groups_dict [dict get $params_protocols_dict $protocol_enum]

      foreach param_group [dict keys $param_groups_dict] {
         set param_group_name [get_string "GROUP_${param_group}_NAME"]
         set param_group_tag [string tolower $param_group]
         set ref_id "params_${protocol_tag}_${param_group_tag}"

         set lines [list]
         set i 0

         _xml lines $i "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
         _xml lines $i "<!DOCTYPE reference PUBLIC \"-//ALTERA//DTD ALTERA DITA Composite//EN\" \"../../system/dtd/client/AlteraDitabase.dtd\">"
         _xml lines $i "<reference id=\"ip_emif_autogen_$ref_id\" xml:lang=\"en-us\">"
         incr i 1
         _xml lines $i "<title>Arria 10 EMIF $protocol_ui_name $param_group_name</title>"
         _xml lines $i "<abstract>"
         incr i 1
         _xml lines $i "<shortdesc>"
         incr i 1
         _xml lines $i "<draft-comment>The content presented below was automatically generated by EMIF IP$quartus_version_msg. The time of generation was $current_time.</draft-comment>"
         incr i -1
         _xml lines $i "</shortdesc>"
         incr i -1
         _xml lines $i "</abstract>"
         _xml lines $i "<refbody>"
         incr i 1
         _xml lines $i "<section id=\"section_${ref_id}\">"
         incr i 1
         _xml lines $i "<table id=\"table_${ref_id}\">"
         incr i 1
         _xml lines $i "<title>$param_group_name</title>"
         _xml lines $i "<tgroup cols=\"3\">"
         incr i 1
         _xml lines $i "<colspec colnum=\"1\" colname=\"col1\" colwidth=\"3.0*\"/>"
         _xml lines $i "<colspec colnum=\"2\" colname=\"col2\" colwidth=\"2.0*\"/>"
         _xml lines $i "<colspec colnum=\"3\" colname=\"col3\" colwidth=\"5.0*\"/>"
         _xml lines $i "<thead>"
         incr i 1
         _xml lines $i "<row>"
         incr i 1
         _xml lines $i "<entry colname=\"col1\">Display Name</entry>"
         _xml lines $i "<entry colname=\"col2\">Identifier</entry>"
         _xml lines $i "<entry colname=\"col3\">Description</entry>"
         incr i -1
         _xml lines $i "</row>"
         incr i -1
         _xml lines $i "</thead>"
         _xml lines $i "<tbody>"
         incr i 1

         set params_dict [dict get $param_groups_dict $param_group]
         foreach param_name [lsort [dict keys $params_dict]] {
            set param_display_name [dict get $params_dict $param_name DISPLAY_NAME]
            set param_desc         [dict get $params_dict $param_name DESC]

            set change_tag ""
            if {[get_string "PARAM_${param_name}_STATUS"] ne "R"} {
               set change_tag " rev=\"mod\""
            }

            _xml lines $i "<row${change_tag}>"
            incr i 1
            _xml lines $i "<entry colname=\"col1\"><uicontrol>$param_display_name</uicontrol></entry>"
            _xml lines $i "<entry colname=\"col2\">$param_name</entry>"
            _xml lines $i "<entry colname=\"col3\">$param_desc</entry>"
            incr i -1
            _xml lines $i "</row>"
         }

         incr i -1
         _xml lines $i "</tbody>"
         incr i -1
         _xml lines $i "</tgroup>"
         incr i -1
         _xml lines $i "</table>"
         incr i -1
         _xml lines $i "</section>"
         incr i -1
         _xml lines $i "</refbody>"
         incr i -1
         _xml lines $i "</reference>"

         set fn "ip_emif_autogen_$ref_id.xml"
         dict set files $fn [join $lines "\n"]
      }
   }

   set retval [list]

   foreach fn [dict keys $files] {
      set file [create_temp_file "$fn"]
      set fh   [open $file "w"]
      puts $fh [dict get $files $fn]
      close $fh
      lappend retval $file
   }
   return $retval
}

proc ::altera_emif::util::doc_gen::_generate_sigs_xml {sigs_protocols_dict dir} {
   set quartus_version_num $::env(ACDS_VERSION)
   set quartus_build $::env(ACDS_BUILD_NUMBER)
   set current_time [clock format [clock seconds]]
   if {$quartus_version_num ne "" && $quartus_build ne ""} {
      set quartus_version_msg " and is sourced from ACDS Version $quartus_version_num Build $quartus_build"
   } else {
      set quartus_version_msg ""
   }

   set files [dict create]
   set ditamap_entries [dict create]

   foreach protocol_enum [lsort [dict keys $sigs_protocols_dict]] {
      set protocol_ui_name [enum_data $protocol_enum UI_NAME]
      set protocol_tag [enum_data $protocol_enum MODULE_NAME]

      set protocol_ref_id "sigs_${protocol_tag}_ifs"

      set lines [list]
      set i 0

      _xml lines $i "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      _xml lines $i "<!DOCTYPE reference PUBLIC \"-//ALTERA//DTD ALTERA DITA Composite//EN\" \"../../system/dtd/client/AlteraDitabase.dtd\">"
      _xml lines $i "<reference id=\"ip_emif_autogen_$protocol_ref_id\" xml:lang=\"en-us\">"
      incr i 1
      _xml lines $i "<title>Arria 10 EMIF IP Interfaces for $protocol_ui_name</title>"
      _xml lines $i "<abstract>"
      incr i 1
      _xml lines $i "<shortdesc>"
      incr i 1
      _xml lines $i "<draft-comment>The content presented below was automatically generated by EMIF IP$quartus_version_msg. The time of generation was $current_time.</draft-comment>"
      _xml lines $i "The interfaces in the Arria 10 External Memory Interface IP each have signals that can be connected in Qsys. The following table lists the interfaces and corresponding interface types for $protocol_ui_name."
      incr i -1
      _xml lines $i "</shortdesc>"
      incr i -1
      _xml lines $i "</abstract>"
      _xml lines $i "<refbody>"
      incr i 1
      _xml lines $i "<section id=\"section_$protocol_ref_id\">"
      incr i 1
      _xml lines $i "<p/>"
      _xml lines $i "<table id=\"table_$protocol_ref_id\">"
      incr i 1
      _xml lines $i "<title>Interfaces for $protocol_ui_name</title>"
      _xml lines $i "<tgroup cols=\"3\">"
      incr i 1
      _xml lines $i "<colspec colnum=\"1\" colname=\"col1\" colwidth=\"3.0*\"/>"
      _xml lines $i "<colspec colnum=\"2\" colname=\"col2\" colwidth=\"2.0*\"/>"
      _xml lines $i "<colspec colnum=\"3\" colname=\"col3\" colwidth=\"5.0*\"/>"
      _xml lines $i "<thead>"
      incr i 1
      _xml lines $i "<row>"
      incr i 1
      _xml lines $i "<entry colname=\"col1\">Interface Name</entry>"
      _xml lines $i "<entry colname=\"col2\">Interface Type</entry>"
      _xml lines $i "<entry colname=\"col3\">Description</entry>"
      incr i -1
      _xml lines $i "</row>"
      incr i -1
      _xml lines $i "</thead>"
      _xml lines $i "<tbody>"
      incr i 1

      foreach if_enum [dict keys [dict get $sigs_protocols_dict $protocol_enum]] {
         set if_name [dict get $sigs_protocols_dict $protocol_enum $if_enum NAME]
         set if_type [dict get $sigs_protocols_dict $protocol_enum $if_enum TYPE]
         set if_desc [dict get $sigs_protocols_dict $protocol_enum $if_enum DESC]

         set change_tag ""
         if {[get_string "${if_enum}_STATUS"] ne "R"} {
            set change_tag " rev=\"mod\""
         }

         _xml lines $i "<row${change_tag}>"
         incr i 1
         _xml lines $i "<entry colname=\"col1\"><xref href=\"ip_emif_autogen_sigs_${protocol_tag}_${if_name}_ports.xml\">$if_name</xref></entry>"
         _xml lines $i "<entry colname=\"col2\">$if_type</entry>"
         _xml lines $i "<entry colname=\"col3\">$if_desc</entry>"
         incr i -1
         _xml lines $i "</row>"
      }

      incr i -1
      _xml lines $i "</tbody>"
      incr i -1
      _xml lines $i "</tgroup>"
      incr i -1
      _xml lines $i "</table>"
      incr i -1
      _xml lines $i "</section>"
      incr i -1
      _xml lines $i "</refbody>"
      incr i -1
      _xml lines $i "</reference>"

      set fn "ip_emif_autogen_$protocol_ref_id.xml"
      dict set files $fn [join $lines "\n"]
      dict set ditamap_entries $fn [list]

      foreach if_enum [dict keys [dict get $sigs_protocols_dict $protocol_enum]] {
         set if_name [dict get $sigs_protocols_dict $protocol_enum $if_enum NAME]
         set if_type [dict get $sigs_protocols_dict $protocol_enum $if_enum TYPE]
         set if_desc [dict get $sigs_protocols_dict $protocol_enum $if_enum DESC]

         set if_ref_id "sigs_${protocol_tag}_${if_name}_ports"

         set change_tag ""
         if {[get_string "${if_enum}_STATUS"] ne "R"} {
            set change_tag " rev=\"mod\""
         }

         set lines [list]
         set i 0

         _xml lines $i "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
         _xml lines $i "<!DOCTYPE reference PUBLIC \"-//ALTERA//DTD ALTERA DITA Composite//EN\" \"../../system/dtd/client/AlteraDitabase.dtd\">"
         _xml lines $i "<reference id=\"ip_emif_autogen_$if_ref_id\" xml:lang=\"en-us\">"
         incr i 1
         _xml lines $i "<title>$if_name for $protocol_ui_name</title>"
         _xml lines $i "<abstract>"
         incr i 1
         _xml lines $i "<shortdesc${change_tag}>"
         incr i 1
         _xml lines $i "<draft-comment>The content presented below was automatically generated by EMIF IP$quartus_version_msg. The time of generation was $current_time.</draft-comment>"
         _xml lines $i "$if_desc"
         incr i -1
         _xml lines $i "</shortdesc>"
         incr i -1
         _xml lines $i "</abstract>"
         _xml lines $i "<refbody>"
         incr i 1
         _xml lines $i "<section id=\"section_$if_ref_id\">"
         incr i 1
         _xml lines $i "<p/>"
         _xml lines $i "<table id=\"table_$if_ref_id\">"
         incr i 1
         _xml lines $i "<title>Interface: $if_name</title>"
         _xml lines $i "<desc>Interface type: $if_type</desc>"
         _xml lines $i "<tgroup cols=\"3\">"
         incr i 1
         _xml lines $i "<colspec colnum=\"1\" colname=\"col1\" colwidth=\"3.0*\"/>"
         _xml lines $i "<colspec colnum=\"2\" colname=\"col2\" colwidth=\"2.0*\"/>"
         _xml lines $i "<colspec colnum=\"3\" colname=\"col3\" colwidth=\"5.0*\"/>"
         _xml lines $i "<thead>"
         incr i 1
         _xml lines $i "<row>"
         incr i 1
         _xml lines $i "<entry colname=\"col1\">Port Name</entry>"
         _xml lines $i "<entry colname=\"col2\">Direction</entry>"
         _xml lines $i "<entry colname=\"col3\">Description</entry>"
         incr i -1
         _xml lines $i "</row>"
         incr i -1
         _xml lines $i "</thead>"
         _xml lines $i "<tbody>"
         incr i 1

         set ports_dict [dict get $sigs_protocols_dict $protocol_enum $if_enum PORTS]
         foreach port_enum [dict keys $ports_dict] {
            set port_rtl_name [dict get $ports_dict $port_enum RTL_NAME]
            set port_dir      [dict get $ports_dict $port_enum DIR]
            set port_desc     [dict get $ports_dict $port_enum DESC]

            set change_tag ""
            if {[get_string "${port_enum}_STATUS"] ne "R"} {
               set change_tag " rev=\"mod\""
            }

            _xml lines $i "<row${change_tag}>"
            incr i 1
               _xml lines $i "<entry colname=\"col1\">$port_rtl_name</entry>"
               _xml lines $i "<entry colname=\"col2\">$port_dir</entry>"
               _xml lines $i "<entry colname=\"col3\">$port_desc</entry>"
            incr i -1
            _xml lines $i "</row>"
         }

         incr i -1
         _xml lines $i "</tbody>"
         incr i -1
         _xml lines $i "</tgroup>"
         incr i -1
         _xml lines $i "</table>"
         incr i -1
         _xml lines $i "</section>"
         incr i -1
         _xml lines $i "</refbody>"
         incr i -1
         _xml lines $i "</reference>"

         set fn "ip_emif_autogen_$if_ref_id.xml"
         dict set files $fn [join $lines "\n"]
         dict lappend ditamap_entries "ip_emif_autogen_$protocol_ref_id.xml" $fn
      }
   }

   set ref_id "sigs_doc"

   set lines [list]

   _xml lines $i "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
   _xml lines $i "<!DOCTYPE map PUBLIC \"-//ALTERA//DTD DITA Map//EN\" \"../../system/dtd/client/altr_map.dtd\">"
   _xml lines $i "<map id=\"ip_emif_autogen_$ref_id\" xml:lang=\"en-us\">"
   incr i 1
   _xml lines $i "<title>Arria 10 EMIF IP Signals</title>"

   foreach protocol_ifs_fn [dict keys $ditamap_entries] {
      _xml lines $i "<topicref href=\"$protocol_ifs_fn\">"
      incr i 1

      foreach if_ports_fn [dict get $ditamap_entries $protocol_ifs_fn] {
         _xml lines $i "<topicref href=\"$if_ports_fn\"/>"
      }
      incr i -1
      _xml lines $i "</topicref>"
   }

   incr i -1
   _xml lines $i "</map>"

   set fn "ip_emif_autogen_$ref_id.ditamap"
   dict set files $fn [join $lines "\n"]

   set retval [list]

   foreach fn [dict keys $files] {
      set file [create_temp_file "$fn"]
      set fh   [open $file "w"]
      puts $fh [dict get $files $fn]
      close $fh
      lappend retval $file
   }
   return $retval
}

proc ::altera_emif::util::doc_gen::_init {} {
}

::altera_emif::util::doc_gen::_init
