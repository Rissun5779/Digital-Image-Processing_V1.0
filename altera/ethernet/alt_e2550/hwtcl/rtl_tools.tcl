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


package provide alt_e2550::rtl_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_e2550::rtl_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_top_level_file { entity_name } {
        set SPEED_CONFIG        [ip_get "parameter.SPEED_CONFIG.value"]

        if {$SPEED_CONFIG == 25} {
            set template_path [file join .. 25g rtl top alt_e25_top.v.terp]
        } else {
            set template_path [file join .. 50g rtl top alt_e50_top.v.terp]
        }

        # Read template into variable "template"
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(qsys_assigned_name)     $entity_name

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        add_fileset_file "${entity_name}.v" VERILOG TEXT $contents
    }

    proc generate_hardware_rtl {} {
        set SPEED_CONFIG        [ip_get "parameter.SPEED_CONFIG.value"]
        set SYNOPT_LINK_FAULT   [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
        set FLOW_CONTROL        [ip_get "parameter.SYNOPT_FLOW_CONTROL.value"]
        set FCBITS              [ip_get "parameter.SYNOPT_NUMPRIORITY.value"]
        set ENABLE_PTP          [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set TIME_OF_DAY_FORMAT  [ip_get "parameter.SYNOPT_TIME_OF_DAY_FORMAT.value"]
        set TSTAMP_FP_WIDTH     [ip_get "parameter.SYNOPT_TSTAMP_FP_WIDTH.value"]

        # Used for file and module name
        set instance_name "eth_ex_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_design_template.v.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(module_name)        $instance_name
        set params(speed)              $SPEED_CONFIG
        set params(link_fault)         $SYNOPT_LINK_FAULT
        set params(flow_control)       $FLOW_CONTROL
        set params(fcbits)             $FCBITS
        set params(enable_ptp)         $ENABLE_PTP
        set params(time_of_day_format) $TIME_OF_DAY_FORMAT
        set params(tstamp_fp_width)    $TSTAMP_FP_WIDTH

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join hardware_test_design "${instance_name}.v"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_testbench_rtl {} {
        set SPEED_CONFIG            [ip_get "parameter.SPEED_CONFIG.value"]
        set SYNOPT_LINK_FAULT       [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
        set SYNOPT_PREAMBLE_PASS    [ip_get "parameter.SYNOPT_PREAMBLE_PASS.value"]
        set SYNOPT_TXCRC_PASS       [ip_get "parameter.SYNOPT_TXCRC_PASS.value"]
        set FLOW_CONTROL            [ip_get "parameter.SYNOPT_FLOW_CONTROL.value"]
        set FCBITS                  [ip_get "parameter.SYNOPT_NUMPRIORITY.value"]
        set OTN                     [ip_get "parameter.SYNOPT_OTN.value"]
        set IP_NAME                 [ip_get "module.NAME.value"]
        set ENABLE_PTP              [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set TIME_OF_DAY_FORMAT      [ip_get "parameter.SYNOPT_TIME_OF_DAY_FORMAT.value"]
        set TSTAMP_FP_WIDTH         [ip_get "parameter.SYNOPT_TSTAMP_FP_WIDTH.value"]

        # Used for file and module name
        if {$OTN} {
            set instance_name "alt_e25_otn_tb"
            set template_file "otn_testbench_template.sv.terp"
        } else {
            set instance_name "basic_avl_tb_top"
            set template_file "testbench_template.sv.terp"
        }
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates $template_file]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(module_name)        $instance_name
        set params(speed)              $SPEED_CONFIG
        set params(link_fault)         $SYNOPT_LINK_FAULT
        set params(preamble_pass)      $SYNOPT_PREAMBLE_PASS
        set params(txcrc_pass)         $SYNOPT_TXCRC_PASS
        set params(flow_control)       $FLOW_CONTROL
        set params(fcbits)             $FCBITS
        set params(ip_name)            $IP_NAME
        set params(enable_ptp)         $ENABLE_PTP
        set params(time_of_day_format) $TIME_OF_DAY_FORMAT
        set params(tstamp_fp_width)    $TSTAMP_FP_WIDTH

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join example_testbench "${instance_name}.sv"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_compilation_rtl {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]

        # Used for file and module name
        set instance_name "alt_eth_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_design_template.v.terp]

        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(module_name) $instance_name
        set params(speed)       $SPEED_CONFIG

        set exposed_ports [get_compilation_ports]
        set params(ports)     [list]
        set params(widths)    [list]
        set params(direction) [list]
        set params(port_count) 0
        foreach port $exposed_ports {
            lappend params(ports)       $port
            lappend params(widths)      [get_port_property $port WIDTH_VALUE]
            lappend params(directions)  [string tolower [get_port_property $port DIRECTION]]
            incr params(port_count)
        }

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join compilation_test_design "${instance_name}.v"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc get_compilation_ports {} {
        set interfaces [get_interfaces]
        set exposed_ports [list]

        foreach interface $interfaces {
            set enabled [get_interface_property $interface ENABLED]
            if {$enabled} {
                set ports [get_interface_ports $interface]
                foreach port $ports {
                    if {[expr {$port eq "tx_serial_clk"}]} {
                        # Internal
                    } elseif {[expr {$port eq "tx_pll_locked"}]} {
                        # Internal
                    } else {
                        lappend exposed_ports $port
                    }
                }
            }
        }

        return $exposed_ports
    }

}
