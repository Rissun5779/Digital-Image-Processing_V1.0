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


package provide altera_emif::util::math 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini


namespace eval ::altera_emif::util::math:: {
   
   
   namespace import ::altera_emif::util::messaging::*
   
   namespace export round_num
   namespace export gcd
   namespace export log2
   namespace export num2bin
   namespace export bin2hex
   namespace export bin2num
   namespace export hex2num
   namespace export set_bits
   namespace export linear_interpolate
   namespace export bilinear_interpolate
   namespace export min
}


proc ::altera_emif::util::math::round_num {num dec} {
   set factor [expr {pow(10, $dec) * 1.0}]
   set num [expr {round($num * $factor) / $factor}]
   return $num
}

proc ::altera_emif::util::math::gcd {m n} {
   while {[expr {$m % $n}] != 0} {
      set r [expr {$m % $n}]
      set m $n
      set n $r
   }
   return $n
}

proc ::altera_emif::util::math::log2 {n} {
   return [expr {log($n) / log(2)}]
}

proc ::altera_emif::util::math::num2bin {num length} {
   binary scan [binary format I $num] B* str
   set str_length [string length $str]
   set retval [string range $str [expr {$str_length - $length}] end]
   return $retval
}

proc ::altera_emif::util::math::bin2hex {binstr} {
   set bin2hex_map {
      0000 0
      0001 1
      0010 2
      0011 3
      0100 4
      0101 5
      0110 6
      0111 7
      1000 8
      1001 9
      1010 A
      1011 B
      1100 C
      1101 D
      1110 E
      1111 F
   }
   
   set num_of_padding_zeros [expr {4 - ([string length $binstr] % 4)}]
   if {$num_of_padding_zeros == 4} {
      set num_of_padding_zeros 0
   }
   
   set padding_zeros [string repeat "0" $num_of_padding_zeros]
   set binstr "${padding_zeros}${binstr}"
   
   return [string map -nocase $bin2hex_map $binstr]
}

proc ::altera_emif::util::math::bin2num {binstr} {
   set retval 0
   set mult 1

   for {set i [expr {[string length $binstr] - 1}]} {$i >= 0} {incr i -1} {
      set char [string index $binstr $i]
      
      if {$char != "_"} {
         if {$char == "1"} {
            incr retval $mult
         } else {
            emif_assert {$char == "0"}
         }
         set mult [expr {$mult * 2}]
      }
   }
   return $retval
}

proc ::altera_emif::util::math::hex2num {hexstr} {
   return [expr 0x$hexstr]
}

proc ::altera_emif::util::math::set_bits { bit_vector index num_bits new_bits } {
   set mask       [expr ((1 << $num_bits) - 1) << $index]
   set new_bits   [expr ($new_bits << $index) & $mask]
   set bit_vector [expr $bit_vector & ~$mask]
   set bit_vector [expr $bit_vector | $new_bits]
   return $bit_vector
}

proc ::altera_emif::util::math::linear_interpolate {x1 x2 q1 q2 a} {
   if {$x1 == $x2} {
      emif_assert {$x1 == $a}
      emif_assert {$q1 == $q2}
      return [expr {double($q1)}]
   } else {
      return [expr {double($q1) + (($a - $x1) * 1.0 * ($q2 - $q1) / ($x2 - $x1))}]
   }
}

proc ::altera_emif::util::math::bilinear_interpolate {x1 x2 y1 y2 q11 q12 q21 q22 a b} {
	set r1 [linear_interpolate $x1 $x2 $q11 $q21 $a]
	set r2 [linear_interpolate $x1 $x2 $q12 $q22 $a]
	return [linear_interpolate $y1 $y2 $r1 $r2 $b]
}

proc ::altera_emif::util::math::min {nums} {
   set retval [lindex $nums 0]

   foreach num $nums {
      if {$num < $retval} {
         set retval $num
      }
   }
   return $retval
}


proc ::altera_emif::util::math::_init {} {

   if {[emif_utest_enabled]} {
      emif_utest_start "::altera_emif::util::math"
   
      emif_assert {[round_num 3.141592 0] == 3.0}
      emif_assert {[round_num 3.141592 1] == 3.1}
      emif_assert {[round_num 3.141592 2] == 3.14}
      emif_assert {[round_num 0        0] == 0}
      
      emif_assert {[gcd 1 1] == 1}
      emif_assert {[gcd 1 2] == 1}
      emif_assert {[gcd 2 4] == 2}
      emif_assert {[gcd 9 6] == 3}
      
      emif_assert {[log2 1] == 0}
      emif_assert {[log2 2] == 1}
      emif_assert {[log2 4] == 2}
      emif_assert {[log2 1024] == 10}
      emif_assert {[round_num [log2 1025] 3] == 10.001}
      
      emif_assert {[string compare [num2bin 0 5]  "00000"] == 0}
      emif_assert {[string compare [num2bin 1 5]  "00001"] == 0}
      emif_assert {[string compare [num2bin 31 5] "11111"] == 0}
      
      emif_assert {[string compare [bin2hex "0"]                                "0"       ] == 0}
      emif_assert {[string compare [bin2hex "1"]                                "1"       ] == 0}
      emif_assert {[string compare [bin2hex "10"]                               "2"       ] == 0}
      emif_assert {[string compare [bin2hex "101"]                              "5"       ] == 0}
      emif_assert {[string compare [bin2hex "1010"]                             "A"       ] == 0}
      emif_assert {[string compare [bin2hex "10101"]                            "15"      ] == 0}
      emif_assert {[string compare [bin2hex "1010110110101010101101"]           "2B6AAD"  ] == 0}
      emif_assert {[string compare [bin2hex "10101101101010101011011010110111"] "ADAAB6B7"] == 0}
      
      emif_assert {[bin2num "0"]                                == 0}
      emif_assert {[bin2num "1"]                                == 1}
      emif_assert {[bin2num "10"]                               == 2}
      emif_assert {[bin2num "101"]                              == 5}
      emif_assert {[bin2num "1010"]                             == 10}
      emif_assert {[bin2num "10101"]                            == 21}
      emif_assert {[bin2num "1010110110101010101101"]           == 2845357}
      emif_assert {[bin2num "10101101101010101011011010110111"] == 2913646263}   
      
      emif_assert {[set_bits [bin2num "100001"] 0 2 [bin2num "10"]] == [bin2num "100010"]}
      emif_assert {[set_bits [bin2num "100001"] 4 2 [bin2num "01"]] == [bin2num "010001"]}
      
      emif_assert {[linear_interpolate 1.1 2.1 5.1   6.1   1.6] == 5.6}
      emif_assert {[linear_interpolate 0   10  100   101   5  ] == 100.5}  
      emif_assert {[linear_interpolate 0   0   100.5 100.5 0  ] == 100.5}
      
      emif_assert {[round_num [bilinear_interpolate 1.8 1.6 0.8 0.7   5   3 13  11 1.7 0.75] 3] == 8}
      emif_assert {[round_num [bilinear_interpolate 1.8 1.6 0.8 0.7 -12 -32 -4 -24 1.7 0.75] 3] == -18}
      
      emif_assert {[min [list 1 2 3 4 5]] == 1}
      emif_assert {[min [list 100 -7 3 -2 25]] == -7}
            
      emif_utest_pass
   }
}

::altera_emif::util::math::_init
