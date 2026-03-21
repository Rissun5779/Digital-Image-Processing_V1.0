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


set CLIENT_BASE  $BASE_TRFC

# Returns the number of blocks dropped by
# the client loopback module due to overflow.
# A block is a client interface data segment (64b for 25g and 128b for 50g)
proc dropped_blocks { } {
    global CLIENT_BASE
    set count [reg_read $CLIENT_BASE 0x7]
    set count [expr {$count}]
    return $count
}

# Clears the dropped blocks counter
proc clear_dropped_blocks { } {
    global CLIENT_BASE
    reg_write $CLIENT_BASE 0
}

# Turn on client loopback
proc client_loop_on {} { client_loop }

# Left for backward compatibility
proc client_loop {} {
    global CLIENT_BASE
    reg_write $CLIENT_BASE 0x10 0xf
}

# Turn off client loopback
proc client_loop_off {} {
    global CLIENT_BASE
     reg_write $CLIENT_BASE 0x10 0x7
}

# Turn on packet generator
proc start_gen {} {
    global CLIENT_BASE
    reg_write $CLIENT_BASE 0x10 0x5
}

# Turn off packet generator
proc stop_gen {} {
    global CLIENT_BASE
    reg_write $CLIENT_BASE 0x10 0x7
}
