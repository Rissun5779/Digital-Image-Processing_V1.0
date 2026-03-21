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
# altera_iopll_util.tcl
#
# To make another test file like this one...
# 1. Copy this file
# 2. change the name of this package (tester)
# 3. change the name of the package to be tested (testee)
# 4. write all the test functions
# 4. 

#REQUIRED PACKAGE (testing this package)
package require altera_iopll::util 14.0

package provide altera_iopll::test::util 14.0

#################################################################
# TEST FUNCTIONS
#################################################################

namespace eval ::altera_iopll::test::util {
   # Namespace Variables
   set tester_namespace ::altera_iopll::test::util::
   set testee_namespace ::altera_iopll::util::

   # Import functions into namespace

   # Export functions
   
}

# proc altera_iopll::test::util::test_value_in_allowed_range {} {
	# namespace import ::altera_iopll::util::map_value_to_allowed_range_if_necessary
	# namespace import ::altera_iopll::test::set_parameter_value
	# namespace import ::altera_iopll::test::set_parameter_property	
	# set result PASS
	
	# #TEST1- value is in the range
	# set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5}
	# set_parameter_value param1 3
	# set ret_val [::altera_iopll::util::value_in_allowed_range param1]
	# if {!$ret_val} {
		# puts "Failed test 1"
		# set result FAIL
	# }	
	
	# #TEST2 - value is not in the range
	# set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5}
	# set_parameter_value param1 2.5
	# set ret_val [::altera_iopll::util::value_in_allowed_range param1]
	# if {$ret_val} {
		# puts "Failed test 2"
		# set result FAIL
	# }		
	
	# #TEST3 - value is not the range (complicated range)
	# set_parameter_property param1 ALLOWED_RANGES {1 2 3:2.5 4 5}
	# set_parameter_value param1 2.5
	# set ret_val [::altera_iopll::util::value_in_allowed_range param1]
	# if {$ret_val} {
		# puts "Failed test 3"
		# set result FAIL
	# }		
	
	# #TEST4 -value is in the range (complicated range) 
	# set_parameter_property param1 ALLOWED_RANGES {1 2 2.5:3 4 5}
	# set_parameter_value param1 2.5
	# set ret_val [::altera_iopll::util::value_in_allowed_range param1]
	# if {!$ret_val} {
		# puts "Failed test 4"
		# set result FAIL
	# }		
	
	# return $result
# }

proc altera_iopll::test::util::test_search_mapped_range {} {
	return FAIL
}

proc altera_iopll::test::util::test_map_allowed_range {} {
	
	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::set_parameter_property
	namespace import ::altera_iopll::test::get_parameter_property
	
	namespace import ::altera_iopll::util::map_allowed_range
	
	set result PASS
	
	# TEST 1: totally new range, selected first value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 1
	::altera_iopll::util::map_allowed_range param1 {7 8 9 10} 7
	if {[get_parameter_property param1 ALLOWED_RANGES] != {1:7 8 9 10}} {
		puts "Failed test 1"
		set result FAIL
	}
	
	#TEST 2: totally new range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 1
	::altera_iopll::util::map_allowed_range param1 {7 8 9 10} 9
	if {[get_parameter_property param1 ALLOWED_RANGES] != {7 8 1:9 10}} {
		puts "Failed test 2"
		set result FAIL
	}
	
	#TEST 3: partly new range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 1
	::altera_iopll::util::map_allowed_range param1 {7 8 1 10} 8
	if {[get_parameter_property param1 ALLOWED_RANGES] != {7 1:8 1 10}} {
		puts "Failed test 3"
		set result FAIL
	}	
	
	#TEST 4: partly new range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 1
	::altera_iopll::util::map_allowed_range param1 {7 8 1 10} 1
	if {[get_parameter_property param1 ALLOWED_RANGES] != {7 8 1 10}} {
		puts "Failed test 4"
		set result FAIL
	}		
	
	# #TEST 5: partly new range, selected some other value
	# set_parameter_property param1 ALLOWED_RANGES {1 2 1:3 4 5 6}
	# set_parameter_value param1 1
	# ::altera_iopll::util::map_allowed_range param1 {1 2 3 4 5 6} 1
	# if {[get_parameter_property param1 ALLOWED_RANGES] != {7 8 1 10}} {
		# puts "Failed test 4"
		# set result FAIL
	# }		

	return $result
}

proc altera_iopll::test::util::test_get_actual_parameter_value {} {

	namespace import ::altera_iopll::test::set_parameter_value
	namespace import ::altera_iopll::test::set_parameter_property
	#namespace import ::altera_iopll::test::get_parameter_property
	
	namespace import ::altera_iopll::util::get_actual_parameter_value
	
	set result PASS
	
	# TEST 1: unmapped range, selected first value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 1
	set_parameter_property param1 TYPE STRING
	set ret_val [::altera_iopll::util::get_actual_parameter_value param1]
	if {$ret_val != 1} {
		puts "Failed test 1"
		set result FAIL
	}
	
	# TEST 2: nmapped range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3 4 5 6}
	set_parameter_value param1 3
	set_parameter_property param1 TYPE STRING
	set ret_val [::altera_iopll::util::get_actual_parameter_value param1]
	if {$ret_val != 3} {
		puts "Failed test 2"
		set result FAIL
	}
	
	# TEST 3: nmapped range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 3:4 5 6}
	set_parameter_value param1 3
	set_parameter_property param1 TYPE STRING
	set ret_val [::altera_iopll::util::get_actual_parameter_value param1]
	if {$ret_val != 4} {
		puts "Failed test 3"
		set result FAIL
	}
	
	# TEST 4: mapped range, selected some other value
	set_parameter_property param1 ALLOWED_RANGES {1 2 1:4 5 6}
	set_parameter_value param1 1
	set_parameter_property param1 TYPE STRING
	set ret_val [::altera_iopll::util::get_actual_parameter_value param1]
	if {$ret_val != 4} {
		puts "Failed test 4"
		set result FAIL
	}	
	
	#more thorough testing...?
	
	return $result
	
}

proc altera_iopll::test::util::test_are_parameters_equal {} {
	return FAIL
}

proc altera_iopll::test::util::test_is_parameter_equal {} {
	return FAIL
}

proc altera_iopll::test::util::test_is_parameter_equal_default {} {
	return FAIL
}

proc altera_iopll::test::util::test_set_parameters_equal {} {
	return FAIL
}

proc altera_iopll::test::util::test_round_to_n_decimals {} {
	
	set result PASS
	
	#TEST 1: round a basic list to 3 decimals
	set my_list {1.2332 5.11131 2.7678338}
	set return_list [::altera_iopll::util::round_to_n_decimals $my_list 3]
	if {$return_list != {1.233 5.111 2.768} } {
		puts "failed test 1"
		set result FAIL
	}
	
	#TSET 2: round a basic list to 1 decimal
	set my_list {1.2332 5.11131 2.7678338}
	set return_list [::altera_iopll::util::round_to_n_decimals $my_list 1]
	if {$return_list != {1.2 5.1 2.8} } {
		puts "failed test 2"
		puts $return_list
		set result FAIL
	}
	
	#TSET 3: round a basic list to 3 decimal with zeros
	set my_list {1.0001 5.11131 2.7678338}
	set return_list [::altera_iopll::util::round_to_n_decimals $my_list 3]
	if {$return_list != {1.0 5.111 2.768} && $return_list != {1.000 5.111 2.768}} {
		puts "failed test 3"
		set result FAIL
	}	
	
	#Test 4: round a single element (as a list)
	set my_list {1.012123}
	set return_list [::altera_iopll::util::round_to_n_decimals $my_list 3]
	if {$return_list != {1.012}} {
		puts "failed test 4"
		set result FAIL
	}	

	#Test 5: round a single element (as a list)
	set my_list 1.012123
	set return_list [::altera_iopll::util::round_to_n_decimals $my_list 3]
	if {$return_list != 1.012} {
		puts "failed test 5"
		set result FAIL
	}		
	
	return $result
}

proc altera_iopll::test::util::test_extract_header_and_data {} {
	return FAIL
}

proc altera_iopll::test::util::test_replace_symbol_with_integer {} {
	return FAIL
}

proc altera_iopll::test::util::test_convert_range_to_list {} {
	return FAIL
}

proc altera_iopll::test::util::test_get_index_array_from_column_list {} {
	return FAIL
}

proc altera_iopll::test::util::test_extract_columns_as_array {} {
	return FAIL
}

proc altera_iopll::test::util::test_extract_rows_given_duplicate_keys {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_parameters {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_display_items {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_interfaces {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_ports {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_module {} {
	return FAIL
}

proc altera_iopll::test::util::test_declare_hwtcl_filesets {} {
	return FAIL
}

############################
# MASTER TEST FUNCTION
# --DO NOT MODIFY ME--
# (EXCEPT FOR MY NAME)
############################
proc altera_iopll::test::util::master_test {} {
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