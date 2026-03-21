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


package provide altera_emif::util::qini 0.1


namespace eval ::altera_emif::util::qini:: {
   namespace export get_ini_value
   namespace export ini_is_on
}


proc ::altera_emif::util::qini::get_ini_value {key {default {}}} {
   set val [get_quartus_ini $key STRING]
   if {$val == ""} {
      set val $default
   }
   return $val
}

proc ::altera_emif::util::qini::ini_is_on {key} {
   set key_value [get_ini_value $key 0]
   if {[regexp -nocase {^[\t\r\n ]*yes[\t\r\n ]*$|^[\t\r\n ]*on[\t\r\n ]*$|^[\t\r\n ]*1[\t\r\n ]*$} $key_value match] == 1} {
      return 1
   } else {
      return 0
   }
}
