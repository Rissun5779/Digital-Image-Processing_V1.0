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


#TOP LEVEL TEST FILE

# pll tcl libraries
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/tclpackages.tcl

package require altera_iopll::test 14.0
package require altera_iopll::util 14.0

#source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/test/altera_iopll_util_tests.tcl

set num_test_suites 0
set num_test_suites_passed 0

puts "-------------------------------------"
puts "RUNNING ALTERA_IOPLL TCL TEST SUITE "
puts "-------------------------------------"
puts " " 

#UGLY TEST: hw_extra.tcl
package require altera_iopll::test::hwtcl 14.0
set return_val [::altera_iopll::test::hwtcl::master_test]
if {$return_val == "PASS"} {
	incr num_test_suites_passed
}
incr num_test_suites

#TEST 1: test util
package require altera_iopll::test::util 14.0
set return_val [::altera_iopll::test::util::master_test]
if {$return_val == "PASS"} {
	incr num_test_suites_passed
}
incr num_test_suites

puts " "
puts "-------------------------------------"
puts "FINISHED ALTERA_IOPLL TCL TEST SUITE "
puts " "
puts "Result: $num_test_suites_passed/$num_test_suites"
puts "-------------------------------------"
puts " "



