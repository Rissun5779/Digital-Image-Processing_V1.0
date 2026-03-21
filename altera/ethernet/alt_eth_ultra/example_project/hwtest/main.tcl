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


source [file join [file dirname [info script]] "altera/sval_top/main.tcl"]

# Function to run a simple series of tests
proc run_test {} {
    puts "--- Turning off packet generation ----"
    puts "--------------------------------------\n"
    stop_gen

    puts "--------- Enabling loopback ----------"
    puts "--------------------------------------\n"
    loop_on

    puts "--- Wait for RX clock to settle... ---"
    puts "--------------------------------------\n"
    sleep 2

    puts "-------- Printing PHY status ---------"
    puts "--------------------------------------\n"
    chkphy_status

    puts "---- Clearing MAC stats counters -----"
    puts "--------------------------------------\n"
    clear_all_stats

    puts "--------- Sending packets... ---------"
    puts "--------------------------------------\n"
    start_gen
    sleep 1
    stop_gen

    puts "----- Reading MAC stats counters -----"
    puts "--------------------------------------\n"
    chkmac_stats

    puts "---------------- Done ----------------\n"
}
