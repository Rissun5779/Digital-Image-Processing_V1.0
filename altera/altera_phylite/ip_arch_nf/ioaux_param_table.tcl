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


package provide altera_phylite::ip_arch_nf::ioaux_param_table 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_phylite::util::enum_defs
package require altera_emif::ip_arch_nf::seq_param_tbl
package require altera_emif::arch_common::seq_param_tbl

namespace eval ::altera_phylite::ip_arch_nf::ioaux_param_table:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


   variable max_grps 18
   variable params_file_suffix "_param_table.hex"
}


proc ::altera_phylite::ip_arch_nf::ioaux_param_table::add_parameters {} {

}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::derive_parameters {} {

}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename_parameter_name { } {

   return "PARAM_TABLE_HEX_FILENAME"

}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename { top_level } {
   variable params_file_suffix

   set hexfilename "${top_level}${params_file_suffix}"

   return $hexfilename

}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::generate_ioaux_files { top_level } {

   set file_list [list]

   lappend file_list {*}[_generate_ioaux_table $top_level]

   lappend file_list {*}[_generate_ioaux_headers]

   return $file_list
}




proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_ioaux_table { top_level } {

   set gpt_size [expr 24+([enum_data SEQ_CONST_MAX_NUM_MEM_INTERFACES VALUE]*4)]

   set hex_lane_tbl [lassign [_generate_lane_assignments] lane_tbl_size]
   set hex_pin_tbl  [lassign [_generate_pin_assignments]  pin_tbl_size]
   set hex_pt       [lassign [_generate_pt $gpt_size] pt_size]
   set hex_gpt      [_generate_gpt $gpt_size $pt_size [expr ${lane_tbl_size}+${pin_tbl_size}]]

   set hex_content_list [list]

   lappend hex_content_list {*}$hex_gpt
   lappend hex_content_list {*}$hex_pt
   lappend hex_content_list {*}$hex_lane_tbl
   lappend hex_content_list {*}$hex_pin_tbl

   set hexfilename [get_param_table_filename $top_level]
   set base_addr [expr {[enum_data SEQ_ADDR_PARAM_TABLE_BASE ADDRESS] / 4}]
   set hexfile [altera_emif::arch_common::seq_param_tbl::_write_hex_file $hexfilename $base_addr $hex_content_list]

   return $hexfile
}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_gpt {gpt_size pt_size data_size} {

   set hex_gpt [list]

   set glb_par_ver [enum_data SEQ_CONST_CURR_GLOBAL_PAR_VER VALUE]
   set glb_par_ver_hex [bin2hex [num2bin ${glb_par_ver} 32]]
   lappend hex_gpt "0x${glb_par_ver_hex}"

   set nios_c_ver [enum_data SEQ_CONST_CURR_NIOS_C_VER VALUE]
   set nios_c_ver_hex [bin2hex [num2bin ${nios_c_ver} 32]]
   lappend hex_gpt "0x${nios_c_ver_hex}"

   lappend hex_gpt "0x00000001"

   set num_iopacks [get_family_trait FAMILY_TRAIT_MAX_TILES_PER_IF]
   set num_iopacks_hex [bin2hex [num2bin ${num_iopacks} 32]]
   lappend hex_gpt "0x${num_iopacks_hex}"

   set nios_freq [enum_data SEQ_CONST_NOMINAL_NIOS_CLK_FREQ_KHZ VALUE]
   set nios_freq_hex [bin2hex [num2bin ${nios_freq} 32]]
   lappend hex_gpt "0x${nios_freq_hex}"

   set total_size [expr ${gpt_size}+${pt_size}+${data_size}]
   set hex_size [bin2hex [num2bin ${total_size} 32]]
   lappend hex_gpt "0x${hex_size}"

   set id [get_parameter_value PHYLITE_INTERFACE_ID]
   set id_hex [bin2hex [num2bin $id 4]]
   set pt_addr ${gpt_size}
   set pt_addr_hex [bin2hex [num2bin ${pt_addr} 16]]
   lappend hex_gpt "0x8${id_hex}00${pt_addr_hex}"
   for {set i 1} {$i < [enum_data SEQ_CONST_MAX_NUM_MEM_INTERFACES VALUE]} {incr i} {
      lappend hex_gpt "0x00000000"
   }

   return $hex_gpt
}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_pt {gpt_size} {

   set hex_pt [list]

   set ip_ver [altera_emif::arch_common::seq_param_tbl::get_acds_version_num "18.1"]
   set ip_ver_hex [bin2hex [num2bin ${ip_ver} 16]]
   set if_ver [enum_data IOAUX_CONST_INTERFACE_PAR_VER]
   set if_ver_hex [bin2hex [num2bin ${if_ver} 16]]
   lappend hex_pt "0x${if_ver_hex}${ip_ver_hex}"

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]
   set num_grps_hex [bin2hex [num2bin ${num_grps} 8]]
   lappend hex_pt "0x000000${num_grps_hex}"

   set total_num_lanes 0
   set line ""
   for { set i 0 } { $i < ${num_grps} } {incr i } {
      set num_pins    [::altera_phylite::ip_top::group::get_data_width_in_grp $i]
      set num_strobes [altera_phylite::ip_top::group::get_num_strobes_in_grp ${i}]
      set grp_num_pins [expr ${num_pins}+${num_strobes}]
      set num_lanes [expr (${grp_num_pins}-1)/12]

      set counts [expr (${num_lanes}<<6)+${grp_num_pins}]
      set counts_hex [bin2hex [num2bin ${counts} 8]]
      set line "${counts_hex}${line}"

      set total_num_lanes [expr ${total_num_lanes}+${num_lanes}+1]
   }

   set bytes_to_round [expr (4-(${num_grps}%4))%4]
   for { set i 0 } { $i < ${bytes_to_round} } {incr i } {
      set line "00${line}"
   }
   set strlen [string length $line]
   set lsb [expr ${strlen}-1]
   set msb [expr ${strlen}-8]
   while { ${msb} >= 0 } {
      set word [string range $line $msb $lsb]
      lappend hex_pt "0x${word}"
      set lsb [expr ${lsb}-8]
      set msb [expr ${msb}-8]
   }

   set bytes_to_round [expr (4-(${total_num_lanes}%4))%4]
   set total_num_lanes [expr ${total_num_lanes}+${bytes_to_round}]
   set lane_addr [expr ${gpt_size}+([llength $hex_pt]*4)+(${num_grps}*4)]
   set pin_addr  [expr ${gpt_size}+([llength $hex_pt]*4)+(${num_grps}*4)+${total_num_lanes}]

   for { set i 0 } { $i < ${num_grps} } {incr i } {
      set num_pins    [::altera_phylite::ip_top::group::get_data_width_in_grp $i]
      set num_strobes [altera_phylite::ip_top::group::get_num_strobes_in_grp ${i}]
      set grp_num_pins [expr ${num_pins}+${num_strobes}]
      set num_lanes [expr (${grp_num_pins}-1)/12]

      set lane_addr_hex [bin2hex [num2bin ${lane_addr} 16]]
      set pin_addr_hex  [bin2hex [num2bin ${pin_addr}  16]]
      lappend hex_pt "0x${lane_addr_hex}${pin_addr_hex}"

      set lane_addr [expr ${lane_addr}+${num_lanes}+1]
      set pin_addr  [expr ${pin_addr}+(${grp_num_pins}*2)]
   }

   set rvals [list]
   lappend rvals [expr [llength $hex_pt]*4]
   lappend rvals {*}$hex_pt

   return $rvals


   return $hex_pt
}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_lane_assignments {} {

   set hex_lane_tbl [list]

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]
   
   set line ""
   for { set i 0 } { $i < ${num_grps} } { incr i } {
      
      set num_strobes [::altera_phylite::ip_top::group::get_num_strobes_in_grp $i]
      set num_pins    [::altera_phylite::ip_top::group::get_data_width_in_grp $i]
      set total_num_pins [expr ${num_strobes}+${num_pins}]
      set num_lanes   [expr int(ceil(${total_num_pins}/12.0))]

      for { set j 0 } { $j < ${num_lanes} } { incr j } {
         set tile_id_hex [bin2hex [num2bin [expr ($i<<2)+$j] 8]]
         set line "${tile_id_hex}${line}"
      }
   }

   set strlen [string length $line]
   set lsb [expr ${strlen}-1]
   set msb [expr ${strlen}-8]
   while { ${msb} >= 0 } {
      set word [string range $line $msb $lsb]
      lappend hex_lane_tbl "0x${word}"
      set lsb [expr ${lsb}-8]
      set msb [expr ${msb}-8]
   }

   if { ${msb} < 0 && ${msb} != -8 } {
      set lastline "0x"
      while { ${msb} < 0 } {
         set lastline "${lastline}00"
         set msb [expr ${msb}+2]
      }
      set lastbytes [string range $line 0 $lsb]
      set lastline "${lastline}${lastbytes}"
      lappend hex_lane_tbl $lastline
   }

   set rvals [list]
   lappend rvals [expr [llength $hex_lane_tbl]*4]
   lappend rvals {*}$hex_lane_tbl

   return $rvals
}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_pin_assignments {} {

   set hex_pin_table [list]

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]
   
   set line ""
   set tbl_idx 0
   for { set i 0 } { $i < ${num_grps} } { incr i } {

      set num_strobes [::altera_phylite::ip_top::group::get_num_strobes_in_grp $i]
      set num_pins    [::altera_phylite::ip_top::group::get_data_width_in_grp $i]
      set total_num_pins [expr ${num_strobes}+${num_pins}]

      for { set j 0 } { $j < ${total_num_pins} } { incr j } {
         set lane_id [expr int(${j}/12)]
         set pin_id [expr ${j}%12]
         set pin_type 15
         if { $j < $num_strobes } {
            set pin_type 14
         }
         set tile_id_hex [bin2hex [num2bin [expr ((${i}<<10)|(${lane_id}<<8)|(${pin_type}<<4))+${pin_id}] 16]]
         set line "${tile_id_hex}${line}"
      }
   }

   set strlen [string length $line]
   set lsb [expr ${strlen}-1]
   set msb [expr ${strlen}-8]
   while { ${msb} >= 0 } {
      set word [string range $line $msb $lsb]
      lappend hex_pin_table "0x${word}"
      set lsb [expr ${lsb}-8]
      set msb [expr ${msb}-8]
   }

   if { ${msb} < 0 && ${msb} != -8 } {
      set lastline "0x"
      while { ${msb} < 0 } {
         set lastline "${lastline}0000"
         set msb [expr ${msb}+4]
      }
      set lastbytes [string range $line 0 $lsb]
      set lastline "${lastline}${lastbytes}"
      lappend hex_pin_table $lastline
   }

   set rvals [list]
   lappend rvals [expr [llength $hex_pin_table]*4]
   lappend rvals {*}$hex_pin_table

   return $rvals
}

proc ::altera_phylite::ip_arch_nf::ioaux_param_table::_generate_ioaux_headers {} {

}
