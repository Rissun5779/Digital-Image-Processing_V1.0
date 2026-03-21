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


package provide altera_emif::arch_common::seq_param_tbl 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::enum_defs_interfaces
package require altera_emif::util::enum_defs_family_traits_and_features
package require altera_emif::util::device_family
package require altera_emif::util::doc_gen

namespace eval ::altera_emif::arch_common::seq_param_tbl:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


}


proc ::altera_emif::arch_common::seq_param_tbl::generate_files {filename contents} {
   set retval    [list]

   set base_addr [expr {[enum_data SEQ_ADDR_PARAM_TABLE_BASE ADDRESS] / 4}]
   set gpt_words [_get_packed_words [dict get $contents SEQ_GPT] SEQ_GPT]
   set pt_words  [_get_packed_words [dict get $contents SEQ_PT] SEQ_PT]
   set words     [concat $gpt_words $pt_words]

   lappend retval [_write_hex_file $filename $base_addr $words]

   set dbg_filename [string map {".hex" ".txt"} $filename]
   lappend retval [_write_dbg_file $dbg_filename $base_addr $contents]

   if {[::altera_emif::util::qini::ini_is_on "emif_update_emif_toolkit_format"]} {
      lappend retval [_write_toolkit_file "toolkit.txt"]
   }

   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::get_acds_version_num {ver_str} {

   set major   0
   set minor   0
   set sp      0
   set variant 0

   if {[regexp -lineanchor -nocase {^([0-9]+)\.([0-9]+)(.*)$} $ver_str matched major minor variant_str]} {

      if {[regexp -lineanchor -nocase {^sp([0-9]+)$} $variant_str matched sp]} {
      } elseif {[regexp -lineanchor -nocase {^fb$} $variant_str matched]} {
         set variant 1
      } elseif {[regexp -lineanchor -nocase {^cb$} $variant_str matched]} {
         set variant 2
      } elseif {[regexp -lineanchor -nocase {^eap$} $variant_str matched]} {
         set variant 3
      } elseif {$variant_str != ""} {
         set variant 7
      }
   } else {
      puts "WARNING: Unable to parse $ver_str"
   }

   emif_assert {[expr {$major   & 31 }] == $major}
   emif_assert {[expr {$minor   & 15 }] == $minor}
   emif_assert {[expr {$sp      & 7  }] == $sp}
   emif_assert {[expr {$variant & 7  }] == $variant}

   set retval  [expr { ($major << 10) | ($minor << 6) | ($sp << 3) | $variant }]

   return $retval
}


proc ::altera_emif::arch_common::seq_param_tbl::get_memory_type {protocol_enum} {

   if {$protocol_enum == "PROTOCOL_DDR3"} {
      set retval [enum_data SEQ_CONST_MEM_DDR3 VALUE]
   } elseif {$protocol_enum == "PROTOCOL_DDR4"} {
      set retval [enum_data SEQ_CONST_MEM_DDR4 VALUE]
   } elseif {$protocol_enum == "PROTOCOL_QDR2"} {
      set retval [enum_data SEQ_CONST_MEM_QDRII VALUE]
   } elseif {$protocol_enum == "PROTOCOL_QDR4"} {
      set retval [enum_data SEQ_CONST_MEM_QDRIV VALUE]
   } elseif {$protocol_enum == "PROTOCOL_RLD2"} {
      set retval [enum_data SEQ_CONST_MEM_RLDRAM2 VALUE]
   } elseif {$protocol_enum == "PROTOCOL_RLD3"} {
      set retval [enum_data SEQ_CONST_MEM_RLDRAM3 VALUE]
   } elseif {$protocol_enum == "PROTOCOL_LPDDR3"} {
      set retval [enum_data SEQ_CONST_MEM_LPDDR3 VALUE]
   } else {
      emif_ie "Unrecognized protocol_enum $protocol_enum"
   }

   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::get_dimm_type {mem_format_enum ping_pong_en} {

   if {$mem_format_enum == "MEM_FORMAT_DISCRETE"} {
      set retval [enum_data SEQ_CONST_DIMM_COMPONENT VALUE]
   } elseif {$mem_format_enum == "MEM_FORMAT_UDIMM"} {
      set retval [enum_data SEQ_CONST_DIMM_UDIMM VALUE]
   } elseif {$mem_format_enum == "MEM_FORMAT_RDIMM"} {
      set retval [enum_data SEQ_CONST_DIMM_RDIMM VALUE]
   } elseif {$mem_format_enum == "MEM_FORMAT_LRDIMM"} {
      set retval [enum_data SEQ_CONST_DIMM_LRDIMM VALUE]
   } elseif {$mem_format_enum == "MEM_FORMAT_SODIMM"} {
      set retval [enum_data SEQ_CONST_DIMM_SODIMM VALUE]
   } else {
      emif_ie "Unrecognized mem_format_enum $mem_format_enum"
   }

   if {$ping_pong_en} {
      set retval [expr {$retval | [enum_data SEQ_CONST_DIMM_PINGPONG]}]
   }
   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::get_num_of_ac_rom_pins {protocol_enum} {

   if {$protocol_enum == "PROTOCOL_DDR3"} {
      set retval [enum_data SEQ_CONST_AC_PIN_DDR3_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_DDR4"} {
      set retval [enum_data SEQ_CONST_AC_PIN_DDR4_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_QDR2"} {
      set retval [enum_data SEQ_CONST_AC_PIN_QDRII_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_QDR4"} {
      set retval [enum_data SEQ_CONST_AC_PIN_QDRIV_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_RLD2"} {
      set retval [enum_data SEQ_CONST_AC_PIN_RLDRAM2_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_RLD3"} {
      set retval [enum_data SEQ_CONST_AC_PIN_RLDRAM3_NUM VALUE]
   } elseif {$protocol_enum == "PROTOCOL_LPDDR3"} {
      set retval [enum_data SEQ_CONST_AC_PIN_LPDDR3_NUM VALUE]
   } else {
      emif_ie "Unrecognized protocol_enum $protocol_enum"
   }

   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::get_ac_rom_enum {protocol_enum port_enum bus_index} {

   if {$protocol_enum == "PROTOCOL_DDR3"} {
      set prefix "SEQ_CONST_AC_ROM_DDR3"
   } elseif {$protocol_enum == "PROTOCOL_DDR4"} {
      set prefix "SEQ_CONST_AC_ROM_DDR4"
   } elseif {$protocol_enum == "PROTOCOL_QDR2"} {
      set prefix "SEQ_CONST_AC_ROM_QDRII"
   } elseif {$protocol_enum == "PROTOCOL_QDR4"} {
      set prefix "SEQ_CONST_AC_ROM_QDRIV"
   } elseif {$protocol_enum == "PROTOCOL_RLD2"} {
      set prefix "SEQ_CONST_AC_ROM_RLDRAM2"
   } elseif {$protocol_enum == "PROTOCOL_RLD3"} {
      set prefix "SEQ_CONST_AC_ROM_RLDRAM3"
   } elseif {$protocol_enum == "PROTOCOL_LPDDR3"} {
      set prefix "SEQ_CONST_AC_ROM_LPDDR3"
   } else {
      emif_ie "Unrecognized protocol_enum $protocol_enum"
   }

   switch $port_enum {
      PORT_MEM_CK -
      PORT_MEM_CK_N {
         if {$protocol_enum == "PROTOCOL_DDR3" || $protocol_enum == "PROTOCOL_DDR4" || $protocol_enum == "PROTOCOL_LPDDR3"} {
            if {$port_enum == "PORT_MEM_CK"} {
               set retval "${prefix}_CK${bus_index}"
            } else {
               set retval "${prefix}_CK${bus_index}_N"
            }
         } else {
            emif_assert {$bus_index == 0}
            if {$port_enum == "PORT_MEM_CK"} {
               set retval "${prefix}_CK"
            } else {
               set retval "${prefix}_CK_N"
            }
         }
      }
      PORT_MEM_CS_N {
         set retval "${prefix}_CS_${bus_index}"
      }
      PORT_MEM_RM {
         set retval "${prefix}_RM_${bus_index}"
      }
      PORT_MEM_CKE {
         set retval "${prefix}_CKE_${bus_index}"
      }
      PORT_MEM_ODT {
         set retval "${prefix}_ODT_${bus_index}"
      }
      PORT_MEM_A {
         set retval "${prefix}_ADD_${bus_index}"
      }
      PORT_MEM_PAR {
         emif_assert {$bus_index == 0}
         set retval "${prefix}_PAR_IN"
      }
      PORT_MEM_ALERT_N {
         set retval "${prefix}_ALERT${bus_index}_N"
      }
      default {

         set port_name [string range $port_enum 9 end]

         set strlen [string length $port_name]
         if {$strlen > 2 && [string first "_N" $port_name] == [expr {$strlen - 2}]} {

            set port_name [string map [list "_N" ""] $port_name]

            emif_assert {$bus_index == 0}

            set retval "${prefix}_${port_name}"
         } else {
            set retval "${prefix}_${port_name}_${bus_index}"
         }
      }
   }
   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::cal_static_tbl_byte_size {pt_type} {

   set retval 0

   foreach param_enum [enums_of_type $pt_type] {
      set param_bit_size [enum_data $param_enum WIDTH]
      set param_depth    [enum_data $param_enum DEPTH]
      incr retval [expr {$param_bit_size / 8 * $param_depth}]
   }

   if {[expr {$retval % 4}] != 0} {
      incr retval [expr {4 - ($retval % 4)}]
   }
   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::cal_extra_data_byte_size {seq_glob_param_tbl seq_param_tbl} {

   set retval 0

   foreach seq_gpt_enum [enums_of_type SEQ_GPT] {
      set is_ptr [enum_data $seq_gpt_enum IS_PTR]
      if {$is_ptr} {
         incr retval [dict get $seq_glob_param_tbl $seq_gpt_enum BYTE_SIZE]
      }
   }

   foreach seq_pt_enum [enums_of_type SEQ_PT] {
      set is_ptr [enum_data $seq_pt_enum IS_PTR]
      if {$is_ptr} {
         incr retval [dict get $seq_param_tbl $seq_pt_enum BYTE_SIZE]
      }
   }

   return $retval
}



proc ::altera_emif::arch_common::seq_param_tbl::_get_packed_words {tbl pt_type} {

   set data [list]
   set extra_data [list]

   foreach param_enum [enums_of_type $pt_type] {
      set bit_size [enum_data $param_enum WIDTH]
      set depth    [enum_data $param_enum DEPTH]
      set is_ptr   [enum_data $param_enum IS_PTR]

      if {$is_ptr} {
         set val               [dict get $tbl $param_enum]
         set ptr               [dict get $val PTR]
         set items             [dict get $val CONTENT]
         set item_bit_size     [expr {[dict get $val ITEM_BYTE_SIZE] * 8}]

         lappend data [list $bit_size $ptr]

         foreach item $items {
            set val_tmp [dict get $item VALUE]
            lappend extra_data [list $item_bit_size $val_tmp]
         }

         emif_assert {[dict get $val BYTE_SIZE] == [expr {[dict get $val ITEM_BYTE_SIZE] * [llength $items]}]}

      } else {
         for {set d 0} {$d < $depth} {incr d} {
            set val [lindex [dict get $tbl $param_enum] $d]
            lappend data [list $bit_size $val]
         }
      }
   }

   lappend data {*}$extra_data

   set retval [list]

   set curr_word 0
   set curr_word_bit_size 0

   foreach item $data {
      set bit_size [lindex $item 0]
      set val      [lindex $item 1]

      emif_assert { $val == [expr {$val & ((1 << $bit_size) - 1)}] }

      set curr_word [expr {$curr_word | ($val << $curr_word_bit_size)}]
      incr curr_word_bit_size $bit_size

      if {$curr_word_bit_size == 32} {
        lappend retval $curr_word
        set curr_word 0
        set curr_word_bit_size 0
      } else {
        emif_assert {$curr_word_bit_size < 32}
      }
   }

   emif_assert {$curr_word_bit_size == 0}

   return $retval
}

proc ::altera_emif::arch_common::seq_param_tbl::_write_hex_file {filename base_addr words} {
   set file [create_temp_file $filename]
   set fh   [open $file "w"]

   set addr $base_addr
   foreach word $words {
      set sum 0

      incr sum 4
      set byte_count_str "04"

      incr sum [expr {($addr >> 8) & 0xFF}]
      incr sum [expr {($addr >> 0) & 0xFF}]
      set addr_str [bin2hex [num2bin $addr 16]]
      incr addr

      incr sum 0
      set rec_type_str "00"

      set data_str ""
      set tmp_word $word
      for {set i 0} {$i < 4} {incr i} {
         set byte     [expr {$tmp_word & ((1 << 8) - 1)}]
         set byte_str [bin2hex [num2bin $byte 8]]
         set tmp_word [expr {$tmp_word >> 8}]

         set data_str "${byte_str}${data_str}"

         incr sum $byte
      }

      set checksum     [expr {(256 - $sum) & ((1 << 8) - 1)}]
      set checksum_str [bin2hex [num2bin $checksum 8]]

      puts $fh ":${byte_count_str}${addr_str}${rec_type_str}${data_str}${checksum_str}"
   }

   puts $fh ":00000001FF"

   close $fh
   return $file
}

proc ::altera_emif::arch_common::seq_param_tbl::_write_dbg_file {filename base_addr contents} {

   set file [create_temp_file $filename]
   set fh   [open $file "w"]

   puts $fh "// This file is dynamically generated and is for information purposes only."
   puts $fh "// It is not used during compilation or simulation."
   puts $fh ""

   set addr $base_addr

   foreach pt_type [list SEQ_GPT SEQ_PT] {

      if {$pt_type == "SEQ_PT"} {
         set tbl [dict get $contents SEQ_PT]
      } else {
         set tbl [dict get $contents SEQ_GPT]
      }

      puts $fh $pt_type

      foreach param_enum [enums_of_type $pt_type] {
         set is_ptr    [enum_data $param_enum IS_PTR]
         set width     [enum_data $param_enum WIDTH]
         set depth     [enum_data $param_enum DEPTH]
         set addr_str  [bin2hex [num2bin $addr 16]]

         if {$is_ptr} {
            set val                [dict get $tbl $param_enum]
            set ptr                [dict get $val PTR]
            set items              [dict get $val CONTENT]
            set item_byte_size     [dict get $val ITEM_BYTE_SIZE]
            set item_bit_size      [expr {$item_byte_size * 8}]
            set ptr_str            [bin2hex [num2bin $ptr $width]]

            puts $fh [format "   0x%4s   %-30s: %-10u 0x%-8s" $addr_str $param_enum $ptr $ptr_str]
            incr addr [expr {$width / 8}]

            for {set i 0} {$i < [llength $items]} {incr i} {
               set item     [lindex $items $i]
               set val      [dict get $item VALUE]
               set dbg_val  [dict get $item DBG_VALUE]
               set dbg_name [dict get $item DBG_NAME]
               set val_str  [bin2hex [num2bin $val $item_bit_size]]
               set ptr_str  [bin2hex [num2bin $ptr 16]]

               puts $fh [format "   0x%4s      %-27s: %-10u 0x%-8s %s" $ptr_str $dbg_name $val $val_str $dbg_val]
               incr ptr $item_byte_size
            }
         } else {
            if {$depth == 1} {
               set val     [dict get $tbl $param_enum]
               set val_str [bin2hex [num2bin $val $width]]

               puts $fh [format "   0x%4s   %-30s: %-10u 0x%-8s" $addr_str $param_enum $val $val_str ]
               incr addr [expr {$width / 8}]
            } else {
               puts $fh [format "   0x%4s   %-30s" $addr_str $param_enum]

               for {set d 0} {$d < $depth} {incr d} {
                  set val      [lindex [dict get $tbl $param_enum] $d]
                  set val_str  [bin2hex [num2bin $val $width]]
                  set addr_str [bin2hex [num2bin $addr 16]]

                  puts $fh [format "   0x%4s      %-27s: %-10u 0x%-8s" $addr_str "static_array_elem \[$d\]" $val $val_str]
                  incr addr [expr {$width / 8}]
               }
            }
         }
      }
   }

   close $fh
   return $file
}

proc ::altera_emif::arch_common::seq_param_tbl::_write_toolkit_file {filename} {

   set file [create_temp_file $filename]
   set fh   [open $file "w"]

   set last_protocol ""
   set ac_pin_list [list]
   foreach enum [enums_of_type SEQ_CONST] {
      set value [enum_data $enum VALUE]
      puts $fh [format "#define %s %d" $enum $value]

      if {[regexp {SEQ_CONST_AC_ROM_([^_]+)_(\w+)} $enum stuff protocol pin_type]} {
         if {![string match $protocol $last_protocol]} {
            if {[llength $ac_pin_list]} {
               set csv_pin_list [join $ac_pin_list ", "]
               set lc_last_protocol [string tolower $last_protocol]
               set size [llength $ac_pin_list]
               puts $fh "const STL_STRING ${lc_last_protocol}_ac_pin_vec\[$size\] = {$csv_pin_list};"
            }
            set ac_pin_list [list]
         }
         set last_protocol $protocol
         lappend ac_pin_list "\"$pin_type\""
      }
   }

   if {[llength $ac_pin_list]} {
     set csv_pin_list [join $ac_pin_list ", "]
     set lc_last_protocol [string tolower $last_protocol]
     set size [llength $ac_pin_list]
     puts $fh "const STL_STRING ${lc_last_protocol}_ac_pin_vec\[$size\] = {$csv_pin_list};"
   }

   close $fh
   return $file
}

proc ::altera_emif::arch_common::seq_param_tbl::_init {} {

   if {[emif_utest_enabled]} {

      emif_utest_start "::altera_emif::arch_common::seq_param_tbl"

      emif_assert {[get_acds_version_num "13.1nf"]  == 13383}
      emif_assert {[get_acds_version_num "13.1sp1"] == 13384}
      emif_assert {[get_acds_version_num "13.1sp2"] == 13392}
      emif_assert {[get_acds_version_num "13.1"]    == 13376}
      emif_assert {[get_acds_version_num "13.0"]    == 13312}
      emif_assert {[get_acds_version_num "20.0fb"]  == 20481}
      emif_assert {[get_acds_version_num "20.0cb"]  == 20482}
      emif_assert {[get_acds_version_num "20.0eap"] == 20483}

      emif_assert {[get_memory_type PROTOCOL_DDR3]    == 0}
      emif_assert {[get_memory_type PROTOCOL_DDR4]    == 1}
      emif_assert {[get_memory_type PROTOCOL_LPDDR3]  == 2}
      emif_assert {[get_memory_type PROTOCOL_RLD3]    == 3}
      emif_assert {[get_memory_type PROTOCOL_RLD2]    == 4}
      emif_assert {[get_memory_type PROTOCOL_QDR4]    == 5}
      emif_assert {[get_memory_type PROTOCOL_QDR2]    == 6}

      emif_assert {[get_dimm_type MEM_FORMAT_DISCRETE 0] == 0}
      emif_assert {[get_dimm_type MEM_FORMAT_UDIMM 0]    == 1}
      emif_assert {[get_dimm_type MEM_FORMAT_RDIMM 0]    == 2}
      emif_assert {[get_dimm_type MEM_FORMAT_SODIMM 0]   == 3}
      emif_assert {[get_dimm_type MEM_FORMAT_LRDIMM 0]   == 4}

      emif_utest_pass
   }
}

::altera_emif::arch_common::seq_param_tbl::_init
