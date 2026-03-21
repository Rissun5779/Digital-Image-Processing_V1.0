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


# source common/jtag_basic.tcl

proc start_pkt_gen {} {
    reg_write 0x1002 1
}

proc stop_pkt_gen {} {
    reg_write 0x1002 0
}

proc get_tx_count {} {
    set tx_count [reg_read 0x1004]
    return $tx_count
}

proc get_rx_count {} {
    set rx_count [reg_read 0x1005]
    return $rx_count
}

proc get_error_count {} {
    set error_count [reg_read 0x1006]
    return $error_count
}

proc reset_counters {} {
    reg_write 0x1007 1
    reg_write 0x1007 0
}
