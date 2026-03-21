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


#loop on/off test
proc loop_test {} {
   
    set linkup 0
    for {set i 0} {$i < 10000} {incr i} {
        puts "$i"
        while {$linkup == 0} {
            loop_on
            set linkup [reg_read 0x326]
            #puts "$i link status: $linkup"
        }
        puts "link status after loop on $linkup"
        loop_off
        set linkup [reg_read 0x326]
        puts "link status after loop off $linkup"
    }
}

proc skew_test {} {
   
    set linkup 0
    loop_on

    puts "Linear skew Test"
    puts "Assuming synthesis directive to be set in PCS"
    puts "Increasing skew and doing 100 resets per step"
    for {set i 4} {$i < 32} {incr i} {
        reg_write 0x331 $i
        while {$linkup == 0} {
            set linkup [reg_read 0x326]
        }
        
        for {set j 0} {$j < 100} {incr j} {
          #  loop_off
        reg_write 0x310 2
        reg_write 0x310 0
            set linkup [reg_read 0x326]
            loop_on
            while {$linkup == 0} {
                set linkup [reg_read 0x326]
            }
        }
        
        puts "$i Verified link up: $linkup"
    }

   loop_on
   puts "Decreasing skew and doing 100 resets per step"
   for {set i 31} {$i > 4} {set i [expr {$i - 1}]} {
        reg_write 0x331 $i
        while {$linkup == 0} {
            set linkup [reg_read 0x326]
        }

        
        for {set j 0} {$j < 100} {incr j} {
            loop_off
            set linkup [reg_read 0x326]
            loop_on
            while {$linkup == 0} {
                set linkup [reg_read 0x326]
            }
        }
        
        puts "$i Verified link up: $linkup"
    }

}


proc rskew {} {

  puts "Stress Testing PCS by Randomly Varying skews"
  puts "Assuming synthesis directive to be set in RX-PCS"
  loop_on
  set linkup 0
  for {set i 0} {$i < 250} {incr i} {
        set delay [expr {round(rand()*63)}]     
        set delay [expr {$delay & 0x3F} ]
        reg_write 0x331 $delay
        set word_delay [expr {$delay >> 1}]
        set bit_delay [expr {$delay & 0x1}]
        puts "$i: Setting skew value: word-delay:$word_delay, 33-bit-shift:$bit_delay" 
        set j 0
        while {$linkup == 1} {
            set linkup [reg_read 0x326]
            incr j
            if {$j == 1000 } { 
                break
            }
        }
        #puts "Expected loss of lock"

        set j 0
        while {$linkup == 0} {
            set linkup [reg_read 0x326]
            incr j
            if {$j == 1000 } {
                if {$word_delay > 16 || $word_delay < 2} {
                    puts "PASSED: Could not lock on infeasible skew"
                    break
                } else {
                    puts "$i: WARNING: Could not lock when inserting skew value: $word_delay, $bit_delay "
                    puts "Under no external skews, this skew amount should not have failed"
                    return
                }
            }
        }

        if {$linkup == 1} {
            puts "PASSED: Link came back up"
        }
  }
}

proc trst_test {} {
    
    loop_on
#    reg_write 0x331 18
    for {set i 0} {$i < 100} {incr i} {
        set linkup 0
        reg_write 0x310 2
        reg_write 0x310 0
        while {$linkup == 0} {
            set linkup [reg_read 0x326]  
            puts "$i: link down"
        }
        puts "$i"
    }
}


proc reset_test {} {

   loop_on
   for {set i 0} {$i < 1000} {incr i} {
        set linkup 0
        set recd_pkts 0
        set errs 0
    
        reg_write 0x310 1
        reg_write 0x310 0
        while {$linkup == 0} {
            set linkup [reg_read 0x326]  
        }
        start_pkt_gen
        while {$recd_pkts == 0} {
            set recd_pkts [get_rx_count]
        }
        stop_pkt_gen
        set errs [get_error_count]
        puts "$i: errors: $errs"
        #reset_counters
    }
}
