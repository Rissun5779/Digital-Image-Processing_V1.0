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


#
# Load prime numbers from file. Each line
# should contain only one prime number.
#
proc load_prime_numbers { } {
	
	set primes [file join $::env(QUARTUS_ROOTDIR) .. ip altera hps util primes-100000.txt ]
	set fp [ open $primes ]
	set prime_numbers [ read $fp ]
	close $fp
	return $prime_numbers
}


#
# Given a number and a list of prime numbers, 
# calculate a list of prime factors.
#
# Example: 120 returns { {2 3} {3 1} {5 1} }
#
# The list of prime numbers will decide the
# biggest prime factor that can be determined.
# If the number contains a prime factor bigger
# than what's in the list, an empty list will
# be returned indicating that the  solution is
# not complete.
#
proc get_prime_factors { number prime_numbers } {
	
	set prime_factors {}

	# Sanity check, only works with numbers >1
	# and when we have a list of prime numbers
	if { $number <= 1 || [ llength $prime_numbers ] == 0 } {
		return {} 
	}

	# A prime number is a factor when the number
	# divides without residue, do this repeatedly.
	for { set i 0 } { $i < [ llength $prime_numbers ] } { incr i } {
		set prime [ lindex $prime_numbers $i ]

		if { $number < $prime } {
			break
		} 

		# The number might be able to divide the prime
		# number multiple times without residue
		set count 0

		# int(ceil()) prevents int() from rounding down.
		while { [ expr int(ceil(fmod($number, $prime))) ] == 0 } {
			incr count
			set number [ expr $number / $prime ]
		}

		if { $count > 0 } {
			lappend prime_factors [ list $prime $count ]
		}
	}

	# If the number is still >1 this means
	# it contains prime numbers bigger than
	# what we can handle
	if { $number > 1 } {
		return {}
	}

	return $prime_factors

}


proc merge_one_prime_factor { list1 e } {

	set merged $list1

	if { [ llength $e ] == 0 } {
		return $merged
	}

	if { [ llength $merged ] == 0 } {
		lappend merged $e
		return $merged
	}
	
	set prime [ lindex $e 0 ]
	set count [ lindex $e 1 ]

	for { set i 0 } { $i < [ llength $merged ] } { incr i } {
	
#		set prime2 [ lindex $merged [ list $i 0 ] ]
#		set count2 [ lindex $merged [ list $i 1 ] ]
        	set prime2 [ lindex [ lindex $merged $i ] 0 ]
        	set count2 [ lindex [ lindex $merged $i ] 1 ]
	
		if { $prime < $prime2 } {
			set merged [ linsert $merged $i $e ]
			return $merged
		} 
	
		if { $prime == $prime2 } {
			if { $count > $count2 } {
				lset merged [ list $i 1 ] $count
			}
			return $merged		
		}
	}

	lappend merged $e
	return $merged
}


#
# Merge 2 list of prime factors
#
#
#
proc merge_prime_factors { list1 list2 } {

	# There's no need to merge the list if either
	# one is empty, so just return the other.
	if { [ llength $list1 ] == 0 } {
		return $list2
	}

	if { [ llength $list2 ] == 0 } {
		return $list1
	}

	set newlist $list1

	foreach e $list2 {
		set newlist [ merge_one_prime_factor $newlist $e ]
	}

	return $newlist
}


#
# Given a list of numbers, calculate their 
# least common multiple 
# 
proc get_lcm { numbers } {

	set lcm 1
	set merged {}
	set prime_numbers [ load_prime_numbers ]

	for { set i 0 } { $i < [ llength $numbers ] } { incr i } {
		set number [ lindex $numbers $i ]
		set p [ get_prime_factors $number $prime_numbers ]
		set merged [ merge_prime_factors $merged $p ]
	}


	foreach m $merged {
		set number [ lindex $m 0 ]
		set power [ lindex $m 1 ]
		set lcm [ expr $lcm * int(pow($number, $power)) ]
	}

	return $lcm
}

