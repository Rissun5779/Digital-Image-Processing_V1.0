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


###############################################################################
#
#   $Header: //acds/rel/18.1std/ip/altera_hps/altera_hps_arria_10/util/quartus_pin_mux_db_part_query.tcl#1 $
#
#    Description: Quartus Tcl API that provides all the HPS pin muxing data
#                    in a single data structure. Data structure format is
#                    implied knowledge shared between this Quartus Tcl API
#                    and the hw.tcl API "pin_mux_db".
#
#    Author: Michael Tozaki
#    Date:   2012.02.02
#
###############################################################################

namespace eval :: {
    source [file join $quartus(tclpath) internal dev_pin_muxing_db.tcl]
}

proc get_bace_device {part} {
    set debug_part   [get_dstr_string -part   $part -debug  ]
    set device       [get_part_info   -device $debug_part   ]
    set debug_device [get_dstr_string -device $device -debug]
    return           [get_base_device_of $debug_device] 
}

proc get_speed_grade {device} {
    return           [get_part_info   -speed_grade $device  ]
}


#proc get_cpu_core_info {device} {
#    return [get_part_info -resource CPU_CORE $device] 
#}



##############################################################
