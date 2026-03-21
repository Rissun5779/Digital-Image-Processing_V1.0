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


# TEST FILE 
# altera_iopll_hw_extra.tcl
#
# To make another test file like this one...
# 1. Copy this file
# 2. change the name of this package (tester)
# 3. change the name of the package to be tested (testee)
# 4. write all the test functions
# 4. 

#REQUIRED PACKAGE (testing this package)
#package require altera_iopll::util 14.0

package provide altera_iopll::test::hwtcl 14.0

#package require altera_iopll::test 14.0

#################################################################
# TEST FUNCTIONS
#################################################################

#HACK - since hw.tcl and hw.tcl extra aren't actually in namespaces
namespace eval ::altera_iopll::namespacefor::hwtcl:: {
	namespace import ::altera_iopll::test::*
	
	source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/top/altera_iopll_hw_extra.tcl
	#source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/top/altera_iopll_hw.tcl
	namespace export *
}

namespace eval ::altera_iopll::test::hwtcl {
   # Namespace Variables
   set tester_namespace ::altera_iopll::test::hwtcl::
   set testee_namespace ::altera_iopll::namespacefor::hwtcl::

   # Import functions into namespace
   
	#namespace import ::altera_iopll::namespacefor::hwtcl::*
   # Export functions
   
}

proc altera_iopll::test::hwtcl::test_increment_based_on_pll_precedence {} {
	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::get_parameter_value
	
	namespace import ::altera_iopll::namespacefor::hwtcl::increment_based_on_pll_precedence
	
	#using clocks 0, 1, 2
	set_parameter_value gui_number_of_clocks 3
	
	#test1
	set param "freq"
	set clock 0
	increment_based_on_pll_precedence param clock
	if {$param != "freq" && $clock != 1} {
		puts "failed test1"
		return FAIL
	}
	
	#test2
	set param "freq"
	set clock 1
	increment_based_on_pll_precedence param clock
	if {$param != "freq" && $clock != 2} {
		puts "failed test 2"
		return FAIL
	}
	
	#test 3
	set param "freq"
	set clock 2
	increment_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 0} {
		puts "failed test 3"
		return FAIL
	}

	#test 4
	set param "phase"
	set clock 0
	increment_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 1} {
		puts "failed test 4"
		return FAIL
	}
	
	#test 5
	set param "phase"
	set clock 1
	increment_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 2} {
		puts "failed test 5"
		return FAIL
	}

	#test 6
	set param "phase"
	set clock 2
	increment_based_on_pll_precedence param clock
	if {$param != "duty" && $clock != 0} {
		puts "failed test 6"
		return FAIL
	}

	#test 7
	set param "duty"
	set clock 0
	increment_based_on_pll_precedence param clock
	if {$param != "duty" && $clock != 1} {
		puts "failed test 7"
		return FAIL
	}

	#test 8
	set param "duty"
	set clock 1
	increment_based_on_pll_precedence param clock
	if {$param != "duty" && $clock != 2} {
		puts "failed test 8"
		return FAIL
	}

	#test 9
	set param "duty"
	set clock 2
	increment_based_on_pll_precedence param clock
	if {$param != "all"} {
		puts "failed test 9"
		return FAIL
	}

	# #test 10
	# set param "all"
	# set clock 0
	# [increment_based_on_pll_precedence param clock]
	# if {$param != "all"} {
		# puts "failed test 10"
		# return FAIL
	# }		
	
	# #test 11
	# set param "none"
	# set clock 1
	# [increment_based_on_pll_precedence param clock]
	# if {$param != "none"} {
		# puts "failed test 11"
		# return FAIL
	# }		
	
	return PASS
}

proc altera_iopll::test::hwtcl::test_decrement_based_on_pll_precedence {} {
	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::get_parameter_value
	
	namespace import ::altera_iopll::namespacefor::hwtcl::decrement_based_on_pll_precedence
	
	#using clocks 0, 1, 2
	set_parameter_value gui_number_of_clocks 3
	
	#test1
	set param "duty"
	set clock 2
	decrement_based_on_pll_precedence param clock
	if {$param != "duty" && $clock != 1} {
		puts "failed test1"
		return FAIL
	}
	
	#test2
	set param "duty"
	set clock 1
	decrement_based_on_pll_precedence param clock
	if {$param != "duty" && $clock != 0} {
		puts "failed test 2"
		return FAIL
	}
	
	#test 3
	set param "duty"
	set clock 0
	decrement_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 2} {
		puts "failed test 3"
		return FAIL
	}

	#test 4
	set param "phase"
	set clock 2
	decrement_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 1} {
		puts "failed test 4"
		return FAIL
	}
	
	#test 5
	set param "phase"
	set clock 1
	decrement_based_on_pll_precedence param clock
	if {$param != "phase" && $clock != 0} {
		puts "failed test 5"
		return FAIL
	}

	#test 6
	set param "phase"
	set clock 0
	decrement_based_on_pll_precedence param clock
	if {$param != "freq" && $clock != 2} {
		puts "failed test 6"
		return FAIL
	}

	#test 7
	set param "freq"
	set clock 2
	decrement_based_on_pll_precedence param clock
	if {$param != "freq" && $clock != 1} {
		puts "failed test 7"
		return FAIL
	}

	#test 8
	set param "freq"
	set clock 1
	decrement_based_on_pll_precedence param clock
	if {$param != "freq" && $clock != 0} {
		puts "failed test 8"
		return FAIL
	}

	#test 9
	set param "freq"
	set clock 0
	decrement_based_on_pll_precedence param clock
	if {$param != "none"} {
		puts "failed test 9"
		return FAIL
	}

	# #test 10
	# set param "all"
	# set clock 2
	# [decrement_based_on_pll_precedence param clock]
	# if {$param != "all"} {
		# puts "failed test 10"
		# return FAIL
	# }		
	
	# #test 11
	# set param "none"
	# set clock 1
	# [decrement_based_on_pll_precedence param clock]
	# if {$param != "none"} {
		# puts "failed test 11"
		# return FAIL
	# }		
	
	return PASS
}

proc altera_iopll::test::hwtcl::test_determine_whether_refclk_has_changed {} {
	namespace import ::altera_iopll::namespacefor::hwtcl::determine_whether_refclk_has_changed
	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::set_parameter_property
	
	set_parameter_property gui_reference_clock_frequency ALLOWED_RANGES {5:700}
	set_parameter_property hp_previous_refclk ALLOWED_RANGES ""
	set_parameter_property gui_reference_clock_frequency TYPE "FLOAT"
	set_parameter_property hp_previous_refclk TYPE "FLOAT"
	
	#test 1 they are the same
	set_parameter_value gui_reference_clock_frequency 100.0
	set_parameter_value hp_previous_refclk 100.0
	if {[determine_whether_refclk_has_changed] != {false}} {
		puts "failed test 1"
		return FAIL
	}
	
	#test 2 they are the same
	set_parameter_value gui_reference_clock_frequency 100.0
	set_parameter_value hp_previous_refclk 200.0
	if {[determine_whether_refclk_has_changed] != {true}} {
		puts "failed test 2"
		return FAIL
	}	
	
	return PASS
}

proc altera_iopll::test::hwtcl::test_update_gui_system_parameters_from_system_info_or_registered_values {} {
	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::get_parameter_value
	
	return FAIL

}

proc altera_iopll::test::hwtcl::test_change_speedgrade_validation {} {
	#This function is supposed to only have any impact on the 
	return FAIL
}

proc altera_iopll::test::hwtcl::test_update_these_previous_actual_outclk_values {} {
	return FAIL
}

# proc altera_iopll::test::hwtcl::test_set_gui_visibility {} {
	# #HACK -- this is just always going to be a pass
	# return PASS
# }

############################
# MASTER TEST FUNCTION
# --DO NOT MODIFY ME--
# (EXCEPT FOR MY NAME)
############################
proc altera_iopll::test::hwtcl::master_test {} {
	variable tester_namespace
	variable testee_namespace
	
	set result PASS
	set tests_passed 0
	set tests_run 0
	
	puts "------------------------------"
	puts "TEST: $testee_namespace"
	puts " " 
	
	#1. Check to ensure testing is complete
	set commands_in_tester_namespace [info commands $tester_namespace*]
	set commands_in_testee_namespace [info commands $testee_namespace*]
	if { [llength $commands_in_tester_namespace] <= [llength $commands_in_testee_namespace] } {
		puts "ERROR: not all functions in $testee_namespace are being tested! Update $tester_namespace with tester functions"
		set result FAIL
	}
	
	#2. Run all testing functions
	foreach function $commands_in_tester_namespace {
		if {$function != "${tester_namespace}master_test"} {
			#run each command
			set test_result [$function]
			if {$test_result == "FAIL"} {
				puts "Fail: $function"
				set result FAIL
			} elseif {$test_result == "PASS"} {
				incr tests_passed
			} else {
				error "IE: Bad return value in test $function"
			}
			incr tests_run
		}
	}
	
	#3. Print results
	puts "Result: $tests_passed/$tests_run passed"
	puts $result
	return $result
}

#############################
# TEST FUNCTION
# --DO NOT MODIFY ME--
#############################
#::altera_iopll::test::util::master_test