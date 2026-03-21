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


# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# 
# altera_config_slave_endpoint_bridge "altera_config_slave_endpoint_bridge" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_config_slave_endpoint_bridge
# 
set_module_property NAME altera_config_slave_endpoint_bridge
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_config_slave_endpoint_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_assignment debug.isTransparent true

# 
# parameters
# 
add_parameter ADDR_WIDTH INTEGER 10
set_parameter_property ADDR_WIDTH ALLOWED_RANGES {1:30}
set_parameter_property ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 64
set_parameter_property DATA_WIDTH ALLOWED_RANGES 64
set_parameter_property DATA_WIDTH VISIBLE false
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter HAS_MASTER_RDV INTEGER 1
set_parameter_property HAS_MASTER_RDV ALLOWED_RANGES {0 1}
set_parameter_property HAS_MASTER_RDV AFFECTS_ELABORATION true
set_parameter_property HAS_MASTER_RDV AFFECTS_GENERATION false
set_parameter_property HAS_MASTER_RDV HDL_PARAMETER true

add_parameter MAX_PENDING_READ INTEGER 1
set_parameter_property MAX_PENDING_READ ALLOWED_RANGES {1:64}
set_parameter_property MAX_PENDING_READ AFFECTS_ELABORATION true
set_parameter_property MAX_PENDING_READ AFFECTS_GENERATION false
set_parameter_property MAX_PENDING_READ HDL_PARAMETER true

add_parameter MAX_BURST INTEGER 1
set_parameter_property MAX_BURST ALLOWED_RANGES {1 2 4 8 16}
set_parameter_property MAX_BURST AFFECTS_ELABORATION true
set_parameter_property MAX_BURST AFFECTS_GENERATION false
set_parameter_property MAX_BURST HDL_PARAMETER true

add_parameter HAS_SLAVE INTEGER 0
set_parameter_property HAS_SLAVE ALLOWED_RANGES {0 1}
set_parameter_property HAS_SLAVE AFFECTS_ELABORATION true
set_parameter_property HAS_SLAVE AFFECTS_GENERATION false
set_parameter_property HAS_SLAVE HDL_PARAMETER true

add_parameter HAS_SLAVE_RDV INTEGER 1
set_parameter_property HAS_SLAVE_RDV ALLOWED_RANGES {0 1}
set_parameter_property HAS_SLAVE_RDV AFFECTS_ELABORATION true
set_parameter_property HAS_SLAVE_RDV AFFECTS_GENERATION false
set_parameter_property HAS_SLAVE_RDV HDL_PARAMETER true


# 
# display items
# 

#
# connection point clk
#
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset ENABLED true
add_interface_port reset reset reset Input 1


#
# connection point master
#
add_interface ext_master avalon end
set_interface_property ext_master addressUnits WORDS
set_interface_property ext_master associatedClock clk
set_interface_property ext_master associatedReset reset
set_interface_property ext_master ENABLED true
add_interface_port ext_master ext_master_write write Input 1
add_interface_port ext_master ext_master_read read Input 1
add_interface_port ext_master ext_master_address address Input ADDR_WIDTH
add_interface_port ext_master ext_master_byteenable byteenable Input {DATA_WIDTH/8}
add_interface_port ext_master ext_master_writedata writedata Input DATA_WIDTH
add_interface_port ext_master ext_master_waitrequest waitrequest Output 1
add_interface_port ext_master ext_master_readdata readdata Output DATA_WIDTH

add_interface int_master avalon start
set_interface_property int_master addressUnits WORDS
set_interface_property int_master associatedClock clk
set_interface_property int_master associatedReset reset
set_interface_property int_master ENABLED true
add_interface_port int_master int_master_write write Output 1
add_interface_port int_master int_master_read read Output 1
add_interface_port int_master int_master_address address Output ADDR_WIDTH
add_interface_port int_master int_master_byteenable byteenable Output {DATA_WIDTH/8}
add_interface_port int_master int_master_writedata writedata Output DATA_WIDTH
add_interface_port int_master int_master_waitrequest waitrequest Input 1
add_interface_port int_master int_master_readdata readdata Input DATA_WIDTH

set_interface_property ext_master bridgesToMaster int_master
set_interface_assignment int_master debug.controlledBy ext_master
set_port_property int_master_write driven_by ext_master_write
set_port_property int_master_read driven_by ext_master_read
set_port_property int_master_address driven_by ext_master_address
set_port_property int_master_byteenable driven_by ext_master_byteenable
set_port_property int_master_writedata driven_by ext_master_writedata
set_port_property ext_master_waitrequest driven_by int_master_waitrequest
set_port_property ext_master_readdata driven_by int_master_readdata


#
# connection point slave
#
add_interface ext_slave avalon start
set_interface_property ext_slave addressUnits WORDS
set_interface_property ext_slave associatedClock clk
set_interface_property ext_slave associatedReset reset
set_interface_property ext_slave ENABLED true
add_interface_port ext_slave ext_slave_byteenable byteenable Output {DATA_WIDTH/8}

add_interface int_slave avalon end
set_interface_property int_slave addressUnits WORDS
set_interface_property int_slave associatedClock clk
set_interface_property int_slave associatedReset reset
set_interface_property int_slave ENABLED true
add_interface_port int_slave int_slave_byteenable byteenable Input {DATA_WIDTH/8}

set_interface_property int_slave bridgesToMaster ext_slave
set_interface_assignment ext_slave debug.controlledBy int_slave
set_port_property ext_slave_byteenable driven_by int_slave_byteenable


#
# Elaboration callback
#
proc elaborate {} {
    set HAS_MASTER_RDV [get_parameter_value HAS_MASTER_RDV]
    set MAX_PENDING_READ [get_parameter_value MAX_PENDING_READ]
    set MAX_BURST [get_parameter_value MAX_BURST]
    set HAS_SLAVE [get_parameter_value HAS_SLAVE]
    set HAS_SLAVE_RDV [get_parameter_value HAS_SLAVE_RDV]

    if {$HAS_MASTER_RDV == 0} {
        set_interface_property int_master maximumPendingReadTransactions 0
        set_interface_property ext_master maximumPendingReadTransactions 0
    }

    if {$HAS_MASTER_RDV != 0} {
        set_interface_property int_master maximumPendingReadTransactions $MAX_PENDING_READ
        set_interface_property ext_master maximumPendingReadTransactions $MAX_PENDING_READ
        add_interface_port int_master int_master_readdatavalid readdatavalid Input 1
        add_interface_port ext_master ext_master_readdatavalid readdatavalid Output 1
        set_port_property ext_master_readdatavalid driven_by int_master_readdatavalid
    }

    if {$MAX_BURST > 1} {
        add_interface_port int_master int_master_burstcount burstcount Output 5
        add_interface_port ext_master ext_master_burstcount burstcount Input 5
        set_port_property int_master_burstcount driven_by ext_master_burstcount
    }

    if {$HAS_SLAVE_RDV == 0} {
        set_interface_property int_slave maximumPendingReadTransactions 0
        set_interface_property ext_slave maximumPendingReadTransactions 0
    }

    if {$HAS_SLAVE_RDV != 0} {
        set_interface_property int_slave maximumPendingReadTransactions 1
        set_interface_property ext_slave maximumPendingReadTransactions 1
    }

    if {$HAS_SLAVE != 0} {
        add_interface_port int_slave int_slave_write write Input 1
        add_interface_port ext_slave ext_slave_write write Output 1
        set_port_property ext_slave_write driven_by int_slave_write
        add_interface_port int_slave int_slave_read read Input 1
        add_interface_port ext_slave ext_slave_read read Output 1
        set_port_property ext_slave_read driven_by int_slave_read
        add_interface_port int_slave int_slave_address address Input $ADDR_WIDTH
        add_interface_port ext_slave ext_slave_address address Output $ADDR_WIDTH
        set_port_property ext_slave_address driven_by int_slave_address
        add_interface_port int_slave int_slave_writedata writedata Input $DATA_WIDTH
        add_interface_port ext_slave ext_slave_writedata writedata Output $DATA_WIDTH
        set_port_property ext_slave_writedata driven_by int_slave_writedata
        add_interface_port int_slave int_slave_waitrequest waitrequest Output 1
        add_interface_port ext_slave ext_slave_waitrequest waitrequest Input 1
        set_port_property int_slave_waitrequest driven_by ext_slave_waitrequest
        add_interface_port int_slave int_slave_readdata readdata Output $DATA_WIDTH
        add_interface_port ext_slave ext_slave_readdata readdata Input $DATA_WIDTH
        set_port_property int_slave_readdata driven_by ext_slave_readdata
    }

    if {$HAS_SLAVE != 0 && $HAS_SLAVE_RDV != 0} {
        add_interface_port int_slave int_slave_readdatavalid readdatavalid Output 1
        add_interface_port ext_slave ext_slave_readdatavalid readdatavalid Input 1
        set_port_property int_slave_readdatavalid driven_by ext_slave_readdatavalid
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}
