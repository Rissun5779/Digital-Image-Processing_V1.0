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


# (C) 2001-2013 Altera Corporation. All rights reserved.
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


package provide alt_eth_ultra::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace eval ::alt_eth_ultra::interfaces:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
    namespace import ::alt_xcvr::ip_tcl::messages::*

    namespace export \
        declare_interfaces \
        elaborate

    variable interfaces
    variable avalon_elab
    variable custom_elab
}


proc ::alt_eth_ultra::interfaces::declare_interfaces {} {
    variable interfaces
    ip_parse_csv "interfaces.csv" "alt_eth_ultra_100g_if"
    set interfaces [ip_get_csv_variable "alt_eth_ultra_100g_if" "interface_100g"]
    ip_declare_interfaces $interfaces
}

proc ::alt_eth_ultra::interfaces::elaborate {} {
    variable avalon_elab
    variable custom_elab
    set avalon_elab 0
    set custom_elab 0
    ip_elaborate_interfaces
}

proc ::alt_eth_ultra::interfaces::e_avalon_if {PROP_NAME IS_100G SYNOPT_AVALON} {
    variable avalon_elab
    if {$avalon_elab == 0} {
        add_interface "avalon_st_tx" conduit end
        ip_set "interface.avalon_st_tx.assignment" [list "ui.blockdiagram.direction" input]
        add_interface "avalon_st_rx" conduit end
        ip_set "interface.avalon_st_rx.assignment" [list "ui.blockdiagram.direction" output]
        set avalon_elab 1
    }

    if {$IS_100G} {    
        switch $PROP_NAME {
            "l8_tx_startofpacket" {
                add_interface_port "avalon_st_tx" "l8_tx_startofpacket" "l8_tx_startofpacket" input 1
            }
            "l8_tx_endofpacket" {
                add_interface_port "avalon_st_tx" "l8_tx_endofpacket" "l8_tx_endofpacket" input 1
            }
            "l8_tx_error" {
                add_interface_port "avalon_st_tx" "l8_tx_error" "l8_tx_error" input 1
            }
            "l8_tx_valid" {
                add_interface_port "avalon_st_tx" "l8_tx_valid" "l8_tx_valid" input 1
            }
            "l8_tx_ready" {
                add_interface_port "avalon_st_tx" "l8_tx_ready" "l8_tx_ready" output 1
            }
            "l8_tx_empty" {
                add_interface_port "avalon_st_tx" "l8_tx_empty" "l8_tx_empty" input 6
            }
            "l8_tx_data" {
                add_interface_port "avalon_st_tx" "l8_tx_data" "l8_tx_data" input 512
            }
            "l8_rx_error" {
                add_interface_port "avalon_st_rx" "l8_rx_error" "l8_rx_error" output 6
            }
            "l8_rx_status" {
                    add_interface_port "avalon_st_rx" "l8_rx_status" "l8_rx_status" output 3
            }
            "l8_rx_valid" {
                add_interface_port "avalon_st_rx" "l8_rx_valid" "l8_rx_valid" output 1
            }
            "l8_rx_startofpacket" {
                add_interface_port "avalon_st_rx" "l8_rx_startofpacket" "l8_rx_startofpacket" output 1
            }
            "l8_rx_endofpacket" {
                add_interface_port "avalon_st_rx" "l8_rx_endofpacket" "l8_rx_endofpacket" output 1
            }
            "l8_rx_data" {
                add_interface_port "avalon_st_rx" "l8_rx_data" "l8_rx_data" output 512
            }
            "l8_rx_empty" {
                add_interface_port "avalon_st_rx" "l8_rx_empty" "l8_rx_empty" output 6
            }
            "l8_rx_fcs_error" {
                add_interface_port "avalon_st_rx" "l8_rx_fcs_error" "l8_rx_fcs_error" output 1
            }
            "l8_rx_fcs_valid" {
                add_interface_port "avalon_st_rx" "l8_rx_fcs_valid" "l8_rx_fcs_valid" output 1
            }
        }
    } else {
        switch $PROP_NAME {
            "l8_tx_startofpacket" {
                add_interface_port "avalon_st_tx" "l4_tx_startofpacket" "l4_tx_startofpacket" input 1
                set PROP_NAME "l4_tx_startofpacket"
            }
            "l8_tx_endofpacket" {
                add_interface_port "avalon_st_tx" "l4_tx_endofpacket" "l4_tx_endofpacket" input 1
                set PROP_NAME "l4_tx_endofpacket"
            }
            "l8_tx_error" {
                add_interface_port "avalon_st_tx" "l4_tx_error" "l4_tx_error" input 1
                set PROP_NAME "l4_tx_error"
            }
            "l8_tx_valid" {
                add_interface_port "avalon_st_tx" "l4_tx_valid" "l4_tx_valid" input 1
                set PROP_NAME "l4_tx_valid"
            }
            "l8_tx_ready" {
                add_interface_port "avalon_st_tx" "l4_tx_ready" "l4_tx_ready" output 1
                set PROP_NAME "l4_tx_ready"
            }
            "l8_tx_empty" {
                add_interface_port "avalon_st_tx" "l4_tx_empty" "l4_tx_empty" input 5
                set PROP_NAME "l4_tx_empty"
            }
            "l8_tx_data" {
                add_interface_port "avalon_st_tx" "l4_tx_data" "l4_tx_data" input 256
                set PROP_NAME "l4_tx_data"
            }
            "l8_rx_error" {
                add_interface_port "avalon_st_rx" "l4_rx_error" "l4_rx_error" output 6
                set PROP_NAME "l4_rx_error"
            }
            "l8_rx_status" {
                add_interface_port "avalon_st_rx" "l4_rx_status" "l4_rx_status" output 3
                set PROP_NAME "l4_rx_status"
            }
            "l8_rx_valid" {
                add_interface_port "avalon_st_rx" "l4_rx_valid" "l4_rx_valid" output 1
                set PROP_NAME "l4_rx_valid"
            }
            "l8_rx_startofpacket" {
                add_interface_port "avalon_st_rx" "l4_rx_startofpacket" "l4_rx_startofpacket" output 1
                set PROP_NAME "l4_rx_startofpacket"
            }
            "l8_rx_endofpacket" {
                add_interface_port "avalon_st_rx" "l4_rx_endofpacket" "l4_rx_endofpacket" output 1
                set PROP_NAME "l4_rx_endofpacket"
            }
            "l8_rx_data" {
                add_interface_port "avalon_st_rx" "l4_rx_data" "l4_rx_data" output 256
                set PROP_NAME "l4_rx_data"
            }
            "l8_rx_empty" {
                add_interface_port "avalon_st_rx" "l4_rx_empty" "l4_rx_empty" output 5
                set PROP_NAME "l4_rx_empty"
            }
            "l8_rx_fcs_error" {
                add_interface_port "avalon_st_rx" "l4_rx_fcs_error" "l4_rx_fcs_error" output 1
                set PROP_NAME "l4_rx_fcs_error"
            }
            "l8_rx_fcs_valid" {
                add_interface_port "avalon_st_rx" "l4_rx_fcs_valid" "l4_rx_fcs_valid" output 1
                set PROP_NAME "l4_rx_fcs_valid"
            }
        }
    }

    if {$SYNOPT_AVALON == 0} {
        set_port_property $PROP_NAME TERMINATION true
        set_port_property $PROP_NAME TERMINATION_VALUE 0
    }
}

proc ::alt_eth_ultra::interfaces::e_custom_if {PROP_NAME IS_100G SYNOPT_AVALON} {
    variable custom_elab
    if {$custom_elab == 0} {
        add_interface "custom_st_tx" conduit end
        ip_set "interface.custom_st_tx.assignment" [list "ui.blockdiagram.direction" input]
        add_interface "custom_st_rx" conduit end
        ip_set "interface.custom_st_rx.assignment" [list "ui.blockdiagram.direction" output]
        set custom_elab 1
    }
    
    set words 2
    if {$IS_100G} {
        set words 4
    }

    switch $PROP_NAME {
        "din_sop" {
            add_interface_port "custom_st_tx" "din_sop" "din_sop" input $words
        }
        "din_eop" {
            add_interface_port "custom_st_tx" "din_eop" "din_eop" input $words
        }
        "tx_error" {
            add_interface_port "custom_st_tx" "tx_error" "tx_error" input $words
        }

        "din_idle" {
            add_interface_port "custom_st_tx" "din_idle" "din_idle" input $words
        }
        "din_eop_empty" {
            add_interface_port "custom_st_tx" "din_eop_empty" "din_eop_empty" input $words*3    
        }
        "din" {
            add_interface_port "custom_st_tx" "din" "din" input $words*64
        }
        "din_req" {
            add_interface_port "custom_st_tx" "din_req" "din_req" output 1    
        }
        "dout_valid" {
            add_interface_port "custom_st_rx" "dout_valid" "dout_valid" output 1    
        }
        "dout_d" {
            add_interface_port "custom_st_rx" "dout_d" "dout_d" output $words*64    
        }
        "dout_c" {
            add_interface_port "custom_st_rx" "dout_c" "dout_c" output $words*8
        }
        "dout_sop" {
            add_interface_port "custom_st_rx" "dout_sop" "dout_sop" output $words
        }
        "dout_eop" {
            add_interface_port "custom_st_rx" "dout_eop" "dout_eop" output $words    
        }
        "dout_eop_empty" {
            add_interface_port "custom_st_rx" "dout_eop_empty" "dout_eop_empty" output $words*3    
        }
        "dout_idle" {
            add_interface_port "custom_st_rx" "dout_idle" "dout_idle" output $words
        }
        "rx_fcs_valid" {
            add_interface_port "custom_st_rx" "rx_fcs_valid" "rx_fcs_valid" output 1
        }
        "rx_fcs_error" {
            add_interface_port "custom_st_rx" "rx_fcs_error" "rx_fcs_error" output 1
        }
        "rx_error" {
            add_interface_port "custom_st_rx" "rx_error" "rx_error" output 6
        }
        "rx_status" {
                add_interface_port "custom_st_rx" "rx_status" "rx_status" output 3
        }
    }

    if {$SYNOPT_AVALON == 1} {
        set_port_property $PROP_NAME TERMINATION true
        set_port_property $PROP_NAME TERMINATION_VALUE 0
    }
}
