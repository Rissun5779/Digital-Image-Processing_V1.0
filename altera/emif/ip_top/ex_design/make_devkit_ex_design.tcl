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



package require ::quartus::project

source $::env(QUARTUS_ROOTDIR)/../ip/altera/emif/ip_top/ex_design/devkit_data.tcl

proc set_pins {devkit_data wire_names} {
   array set data $devkit_data

   foreach wire_name $wire_names {
      set data_list $data($wire_name)
      set wire_width [lindex $data_list 0]
      set pin_list [lindex $data_list 3]

      for {set num 0} {$num < $wire_width} {incr num} {
         set pin [lindex $pin_list $num]
         set_location_assignment $pin -to "${wire_name}\[${num}\]"
      }
   }
}

proc set_top_wires {fh devkit_data wire_names} {
   array set data $devkit_data
   set last_item [lindex $wire_names [expr [llength $wire_names] -1]]

   foreach wire_name $wire_names {
      set data_list $data($wire_name)
      set wire_type [lindex $data_list 1]
      set wire_width [lindex $data_list 0]
      set wire_max [expr $wire_width -1]

		set wire_size "\[${wire_max}\:0\]"

      set line "${wire_type} wire ${wire_size} ${wire_name}"
      if {$last_item != $wire_name} {
         append line ","
      }

      puts $fh "   $line"
   }
}

proc set_invert_wires {fh devkit_data wire_names} {
   array set data $devkit_data
   puts $fh "// The Development Kit User LEDs are active LOW"

   foreach wire_name $wire_names {
      set data_list $data($wire_name)
      set wire_width [lindex $data_list 0]
      set wire_max [expr $wire_width -1]
      set invert_wire [lindex $data_list 2]

      if {$invert_wire} {
         set wire_with_width "inv_${wire_name}"
         if {$wire_width > 1} {
            set wire_with_width "\[${wire_max}\:0\] ${wire_with_width}"
         }

         puts $fh "wire $wire_with_width;"
         puts $fh "assign $wire_name = ~inv_${wire_name};"
      }
   }

   puts $fh "\n"
}

proc set_inst_connection {fh devkit_data wire_names} {
   array set data $devkit_data
   set last_item [lindex $wire_names [expr [llength $wire_names] -1]]
   set longest_name_length 0

   foreach wire_name $wire_names {
		set name_length [string length $wire_name]
		if {$name_length > $longest_name_length} {
			set longest_name_length $name_length
		}
	}

   foreach wire_name $wire_names {
      set data_list $data($wire_name)
      set wire_width [lindex $data_list 0]
      set max_wire [expr $wire_width - 1]

      set invert_wire [lindex $data_list 2]

      set line ".${wire_name}"

		for {set num [string length $wire_name]} {$num < $longest_name_length} {incr num} {
			append line " "
		}

      append line " \("
      if {$invert_wire} {
         append line "inv_"
      }
      append line "${wire_name}\)"
      if {$last_item != $wire_name} {
         append line ","
      }
      puts $fh "   $line"
   }
}

set project [lindex $quartus(args) 0]
set top_level_name [lindex $quartus(args) 1]
set selected_devkit [string tolower [lindex $quartus(args) 2]]
set out_name [lindex $quartus(args) 3]
set io_voltage [lindex $quartus(args) 4]

array set devkit_data [eval ${selected_devkit}_data $out_name]
set wire_names [lsort [array names devkit_data]]

set synth_top_file "${top_level_name}.sv"


project_open $project

set_global_assignment -name TOP_LEVEL_ENTITY ${top_level_name}
set_global_assignment -name SYSTEMVERILOG_FILE ${synth_top_file}

set_global_assignment -name MESSAGE_DISABLE 13410
set_global_assignment -name MESSAGE_DISABLE 13024

set_global_assignment -name MESSAGE_DISABLE 12620

set_global_assignment -name MESSAGE_DISABLE 13039
set_global_assignment -name MESSAGE_DISABLE 13040

set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "\"${io_voltage} V\""
set_global_assignment -name VERILOG_MACRO "\"ALTERA_EMIF_ENABLE_ISSP=1\""

set_pins [array get devkit_data] $wire_names

project_close


set fh [open $synth_top_file "w"]

puts $fh "// Generated dynamically by Qsys altera_emif \"Generate Example Design\"\n"

puts $fh "module ${top_level_name} ("

set_top_wires $fh [array get devkit_data] $wire_names

puts $fh ");\n"

set_invert_wires $fh [array get devkit_data] $wire_names

puts $fh "${project} ${project}_inst ("

set_inst_connection $fh [array get devkit_data] $wire_names

puts $fh ");\n"
puts $fh "endmodule"

close $fh
