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


package provide alt_e2550::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace eval ::alt_e2550::interfaces:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
    namespace import ::alt_xcvr::ip_tcl::messages::*

    proc elaborate {} {
        set SPEED_CONFIG  [ip_get "parameter.SPEED_CONFIG.value"]
        set OTN           [ip_get "parameter.SYNOPT_OTN.value"]

        if {$SPEED_CONFIG == 50} {
            set serial_lanes        2
            set tx_serial_clk_bits  2
        } else {
            set serial_lanes        1
            set tx_serial_clk_bits  1
        }

        if {$OTN} {
            if {$SPEED_CONFIG == 50} {
                set data_bits    132
            } else {
                set data_bits    66
            }

            Add_interface       "clocks_and_clock_status"
            Add_interface_port  "clocks_and_clock_status"   "tx_serial_clk"         input   1
            Add_interface_port  "clocks_and_clock_status"   "pll_locked"            input   1
            Add_interface_port  "clocks_and_clock_status"   "rx_cdr_refclk"         input   1
            Add_interface_port  "clocks_and_clock_status"   "tx_pma_clk"            output  1
            Add_interface_port  "clocks_and_clock_status"   "tx_pma_clk_stable"     output  1
            Add_interface_port  "clocks_and_clock_status"   "rx_pma_clk"            output  1
            Add_interface_port  "clocks_and_clock_status"   "rx_pma_clk_stable"     output  1

            Add_interface       "resets"
            Add_interface_port  "resets"                    "csr_rst_n"             input   1
            Add_interface_port  "resets"                    "tx_rst_n"              input   1
            Add_interface_port  "resets"                    "rx_rst_n"              input   1
            Add_interface_port  "resets"                    "tx_sync_reset"         output  1
            Add_interface_port  "resets"                    "tx_out_of_rst"         output  1
            Add_interface_port  "resets"                    "rx_out_of_rst"         output  1

            Add_interface       "tx_interface"
            Add_interface_port  "tx_interface"              "tx_clk"                input   1
            Add_interface_port  "tx_interface"              "tx_pcs_66b_d"          input   $data_bits
            Add_interface_port  "tx_interface"              "tx_pcs_66b_am"         input   1
            Add_interface_port  "tx_interface"              "tx_pcs_66b_valid"      input   1
            Add_interface_port  "tx_interface"              "tx_pcs_66b_ready"      output  1

            Add_interface       "rx_interface"
            Add_interface_port  "rx_interface"              "rx_clk"                input   1
            Add_interface_port  "rx_interface"              "rx_pcs_66b_d"          output  $data_bits
            Add_interface_port  "rx_interface"              "rx_pcs_66b_valid"      output  1

            Add_interface       "serial_lanes"
            Add_interface_port  "serial_lanes"              "rx_serial_data"        input   1
            Add_interface_port  "serial_lanes"              "tx_serial_data"        output  1

            Add_interface       "avalon_mm"
            Add_interface_port  "avalon_mm"                 "avmm_clk"              input   1
            Add_interface_port  "avalon_mm"                 "avmm_clk_stable"       input   1
            Add_interface_port  "avalon_mm"                 "avmm_reset"            input   1
            Add_interface_port  "avalon_mm"                 "avmm_write"            input   1
            Add_interface_port  "avalon_mm"                 "avmm_read"             input   1
            Add_interface_port  "avalon_mm"                 "avmm_address"          input   16
            Add_interface_port  "avalon_mm"                 "avmm_write_data"       input   32
            Add_interface_port  "avalon_mm"                 "avmm_read_data"        output  32
            Add_interface_port  "avalon_mm"                 "avmm_read_data_valid"  output  1
            Add_interface_port  "avalon_mm"                 "avmm_waitrequest"      output  1

            Add_interface       "reconfig"
            Add_interface_port  "reconfig"                  "reconfig_clk"          input   1
            Add_interface_port  "reconfig"                  "reconfig_reset"        input   1
            Add_interface_port  "reconfig"                  "reconfig_write"        input   1
            Add_interface_port  "reconfig"                  "reconfig_read"         input   1
            if {$SPEED_CONFIG == 50} {
               Add_interface_port  "reconfig"                  "reconfig_address"      input   11
            } else {
               Add_interface_port  "reconfig"                  "reconfig_address"      input   10
            }
            Add_interface_port  "reconfig"                  "reconfig_write_data"   input   32
            Add_interface_port  "reconfig"                  "reconfig_read_data"    output  32
            Add_interface_port  "reconfig"                  "reconfig_waitrequest"  output  1

            Add_interface       "status"
            Add_interface_port  "status"                    "rx_block_lock"         output  1
            Add_interface_port  "status"                    "rx_am_lock"            output  1
            Add_interface_port  "status"                    "rx_pcs_ready"          output  1
        } else {
            # Non-OTN (normal)
            if {$SPEED_CONFIG == 50} {
                set words        2
                set empty_bits   4
                set data_bits    128
            } else {
                set words        1
                set empty_bits   3
                set data_bits    64
            }

            Add_interface       "status"
            Add_interface_port  "status"        "clk_status"                    input   1
            Add_interface_port  "status"        "reset_status"                  input   1
            Add_interface_port  "status"        "status_write"                  input   1
            Add_interface_port  "status"        "status_read"                   input   1
            Add_interface_port  "status"        "status_addr"                   input   16
            Add_interface_port  "status"        "status_writedata"              input   32
            Add_interface_port  "status"        "status_readdata"               output  32
            Add_interface_port  "status"        "status_readdata_valid"         output  1
            Add_interface_port  "status"        "status_waitrequest"            output  1

            Add_interface       "avalon_st_tx"
            set_ui_direction    "avalon_st_tx"  input
            Add_interface_port  "avalon_st_tx"  "clk_txmac"                     output  1
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_startofpacket"    input   1
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_endofpacket"      input   1
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_valid"            input   1
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_ready"            output  1
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_empty"            input   $empty_bits
            Add_interface_port  "avalon_st_tx"  "l${words}_tx_data"             input   $data_bits

            Add_interface       "avalon_st_rx"
            set_ui_direction    "avalon_st_rx"  output
            Add_interface_port  "avalon_st_rx"  "clk_rxmac"                     output  1
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_error"            output  6
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_valid"            output  1
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_startofpacket"    output  1
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_endofpacket"      output  1
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_empty"            output  $empty_bits
            Add_interface_port  "avalon_st_rx"  "l${words}_rx_data"             output  $data_bits

            Add_interface       "serial_lanes"
            set_ui_direction    "serial_lanes"  output
            Add_interface_port  "serial_lanes"  "tx_serial"                     output  $serial_lanes
            Add_interface_port  "serial_lanes"  "rx_serial"                     input   $serial_lanes

            Add_interface       "reconfig"
            set_ui_direction    "reconfig"      output
            Add_interface_port  "reconfig"      "reconfig_clk"                  input   1
            Add_interface_port  "reconfig"      "reconfig_reset"                input   1
            Add_interface_port  "reconfig"      "reconfig_write"                input   1
            Add_interface_port  "reconfig"      "reconfig_read"                 input   1
            if {$SPEED_CONFIG == 50} {
               Add_interface_port  "reconfig"      "reconfig_address"              input   11
            } else {
               Add_interface_port  "reconfig"      "reconfig_address"              input   10
            }
            Add_interface_port  "reconfig"      "reconfig_writedata"            input   32
            Add_interface_port  "reconfig"      "reconfig_readdata"             output  32
            Add_interface_port  "reconfig"      "reconfig_waitrequest"          output  1

            Add_interface       "other"
            Add_interface_port  "other"         "tx_lanes_stable"               output  1
            Add_interface_port  "other"         "rx_pcs_ready"                  output  1
            Add_interface_port  "other"         "clk_ref"                       input   1
            Add_interface_port  "other"         "csr_rst_n"                     input   1
            Add_interface_port  "other"         "tx_rst_n"                      input   1
            Add_interface_port  "other"         "rx_rst_n"                      input   1
            Add_interface_port  "other"         "rx_block_lock"                 output  1
            Add_interface_port  "other"         "rx_am_lock"                    output  1
            Add_interface_port  "other"         "tx_serial_clk"                 input   $tx_serial_clk_bits
            Add_interface_port  "other"         "tx_pll_locked"                 input   1

            Add_interface       "stats"
            Add_interface_port  "stats"         "l${words}_txstatus_valid"      output  1
            Add_interface_port  "stats"         "l${words}_txstatus_data"       output  40
            Add_interface_port  "stats"         "l${words}_txstatus_error"      output  7
            Add_interface_port  "stats"         "l${words}_rxstatus_valid"      output  1
            Add_interface_port  "stats"         "l${words}_rxstatus_data"       output  40

            Add_interface       "link_fault"
            Add_interface_port  "link_fault"    "remote_fault_status"           output  1
            Add_interface_port  "link_fault"    "local_fault_status"            output  1
            Add_interface_port  "link_fault"    "unidirectional_en"             output  1
            Add_interface_port  "link_fault"    "link_fault_gen_en"             output  1
            set LINK_FAULT    [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
            if {$LINK_FAULT == 0} { disable_interface "link_fault" }

            set FCBITS        [ip_get "parameter.SYNOPT_NUMPRIORITY.value"]
            Add_interface       "flow_control"
            Add_interface_port  "flow_control"  "pause_insert_tx0"              input   $FCBITS
            Add_interface_port  "flow_control"  "pause_insert_tx1"              input   $FCBITS
            Add_interface_port  "flow_control"  "pause_receive_rx"              output  $FCBITS
            set FLOW_CONTROL [ip_get "parameter.SYNOPT_FLOW_CONTROL.value"]
            if {$FLOW_CONTROL == 0} { disable_interface "flow_control" }

            if {$SPEED_CONFIG == 25} {
                set FP_WIDTH        [ip_get "parameter.SYNOPT_TSTAMP_FP_WIDTH.value"]
                set TOD_FORMAT      [ip_get "parameter.SYNOPT_TIME_OF_DAY_FORMAT.value"]
                Add_interface       "ptp"
                Add_interface_port  "ptp"  "tx_time_of_day_96b_data"                        input   96
                Add_interface_port  "ptp"  "rx_time_of_day_96b_data"                        input   96
                if {$TOD_FORMAT == 1} {
                    set_port_property tx_time_of_day_96b_data DRIVEN_BY 0
                    set_port_property tx_time_of_day_96b_data TERMINATION true
                    set_port_property tx_time_of_day_96b_data TERMINATION_VALUE 0
                    
                    set_port_property rx_time_of_day_96b_data DRIVEN_BY 0
                    set_port_property rx_time_of_day_96b_data TERMINATION true
                    set_port_property rx_time_of_day_96b_data TERMINATION_VALUE 0                
                }
                Add_interface_port  "ptp"  "tx_time_of_day_64b_data"                        input   64            
                Add_interface_port  "ptp"  "rx_time_of_day_64b_data"                        input   64
                if {$TOD_FORMAT == 0} {
                    set_port_property tx_time_of_day_64b_data DRIVEN_BY 0
                    set_port_property tx_time_of_day_64b_data TERMINATION true
                    set_port_property tx_time_of_day_64b_data TERMINATION_VALUE 0
                    
                    set_port_property rx_time_of_day_64b_data DRIVEN_BY 0
                    set_port_property rx_time_of_day_64b_data TERMINATION true
                    set_port_property rx_time_of_day_64b_data TERMINATION_VALUE 0                
                }
                Add_interface_port  "ptp"  "tx_egress_timestamp_request_valid"              input   1
                Add_interface_port  "ptp"  "tx_egress_timestamp_request_fingerprint"        input   $FP_WIDTH
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_timestamp_insert"           input   1
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_timestamp_format"           input   1
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_residence_time_update"      input   1
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_ingress_timestamp_96b"      input   96
                if {$TOD_FORMAT == 1} {
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b DRIVEN_BY 0
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION true
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_96b TERMINATION_VALUE 0
                }
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_ingress_timestamp_64b"      input   64
                if {$TOD_FORMAT == 0} {
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b DRIVEN_BY 0
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION true
                    set_port_property tx_etstamp_ins_ctrl_ingress_timestamp_64b TERMINATION_VALUE 0
                }
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_residence_time_calc_format" input   1
                if {$TOD_FORMAT == 1} {
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format DRIVEN_BY 1
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION true
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION_VALUE 1   
                }
                if {$TOD_FORMAT == 0} {
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format DRIVEN_BY 0
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION true
                    set_port_property tx_etstamp_ins_ctrl_residence_time_calc_format TERMINATION_VALUE 0   
                }
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_checksum_zero"              input   1
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_checksum_correct"           input   1
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_offset_timestamp"           input   16
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_offset_correction_field"    input   16
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_offset_checksum_field"      input   16
                Add_interface_port  "ptp"  "tx_etstamp_ins_ctrl_offset_checksum_correction" input   16
                Add_interface_port  "ptp"  "tx_egress_asymmetry_update"                     input   1
                Add_interface_port  "ptp"  "tx_egress_timestamp_96b_valid"                  output  1
                Add_interface_port  "ptp"  "tx_egress_timestamp_96b_data"                   output  96
                Add_interface_port  "ptp"  "tx_egress_timestamp_96b_fingerprint"            output  $FP_WIDTH
                Add_interface_port  "ptp"  "rx_ingress_timestamp_96b_valid"                 output  1
                Add_interface_port  "ptp"  "rx_ingress_timestamp_96b_data"                  output  96
                if {$TOD_FORMAT == 1} {
                    set_port_property tx_egress_timestamp_96b_valid TERMINATION true
                    set_port_property tx_egress_timestamp_96b_data TERMINATION true
                    set_port_property tx_egress_timestamp_96b_fingerprint TERMINATION true
                    set_port_property rx_ingress_timestamp_96b_valid TERMINATION true
                    set_port_property rx_ingress_timestamp_96b_data TERMINATION true
                }
                Add_interface_port  "ptp"  "tx_egress_timestamp_64b_valid"                  output  1
                Add_interface_port  "ptp"  "tx_egress_timestamp_64b_data"                   output  64
                Add_interface_port  "ptp"  "tx_egress_timestamp_64b_fingerprint"            output  $FP_WIDTH
                Add_interface_port  "ptp"  "rx_ingress_timestamp_64b_valid"                 output  1
                Add_interface_port  "ptp"  "rx_ingress_timestamp_64b_data"                  output  64
                if {$TOD_FORMAT == 0} {
                    set_port_property tx_egress_timestamp_64b_valid TERMINATION true
                    set_port_property tx_egress_timestamp_64b_data TERMINATION true
                    set_port_property tx_egress_timestamp_64b_fingerprint TERMINATION true
                    set_port_property rx_ingress_timestamp_64b_valid TERMINATION true
                    set_port_property rx_ingress_timestamp_64b_data TERMINATION true
                }
                
                set PTP_EN [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
                if {$PTP_EN == 0} { disable_interface "ptp" }
            }

            if {$SPEED_CONFIG == 50} {
                set PREAMBLE_PASS [ip_get "parameter.SYNOPT_PREAMBLE_PASS.value"]
                if {$PREAMBLE_PASS == 1} {
                    Add_interface_port  "avalon_st_tx"   "l2_tx_preamble" input  64
                    Add_interface_port  "avalon_st_rx"   "l2_rx_preamble" output 64
                } else {
                    Add_interface       "preamble_ports"
                    Add_interface_port  "preamble_ports" "l2_tx_preamble" input  64
                    Add_interface_port  "preamble_ports" "l2_rx_preamble" output 64
                    disable_interface   "preamble_ports"
                }
            }

            if {$SPEED_CONFIG == 25} {
                Add_interface_port  "other"         "l1_tx_error"                 input   1
            }
        }
    }

    # add_interface_port wrapper which is more compact
    proc Add_interface_port { interface port_name direction width } {
        add_interface_port $interface $port_name $port_name $direction $width
    }

    # add_interface wrapper
    proc Add_interface { interface } {
        add_interface $interface conduit end
    }

    # Set which side of the Block Symbol that an interface shows up on
    proc set_ui_direction { interface direction } {
        ip_set "interface.${interface}.assignment" [list "ui.blockdiagram.direction" $direction]
    }

    # Hide interface at top level wrapper and terminate connections
    proc disable_interface { interface } {
        ip_set "interface.${interface}.ENABLED" false
    }
}
