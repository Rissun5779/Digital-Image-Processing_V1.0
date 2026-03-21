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


package provide alt_eth_ultra::qsf_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get
package require ethernet::tools

namespace eval ::alt_eth_ultra::qsf_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_hardware_qsf {} {
        set IS_100G         [ip_get "parameter.IS_100G.value"]
        set DEVICE_FAMILY   [ip_get "parameter.DEVICE_FAMILY.value"]
        set ENA_KR4         [ip_get "parameter.ENA_KR4.value"]
        set SYNOPT_PTP      [ip_get "parameter.SYNOPT_PTP.value"]
        set DEV_BOARD       [ip_get "parameter.DEV_BOARD.value"]
        set IS_CAUI4        [ip_get "parameter.SYNOPT_CAUI4.value"]
        set IS_C4_FEC       [ip_get "parameter.SYNOPT_C4_RSFEC.value"]

        if {$IS_100G == 1} {
            if {$IS_CAUI4} {
                set project_name "eth_ex_100g_caui4_a10"
            } else {
                set project_name "eth_ex_100g_a10"
            }
            set speed 100
            if {$IS_CAUI4 == 1} {
                set variant "ex_100g_caui4"
            } else {
                set variant "ex_100g"
            }
        } else {
            set variant "ex_40g"
            set speed 40
            if {$ENA_KR4} {
                set project_name "eth_ex_40g_kr4_a10"
            } else {
                set project_name "eth_ex_40g_a10"
            }
        } 

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]

        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_qsf_template.tcl.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(project_name)    $project_name
        set params(variant)         $variant
        set params(speed)           $speed
        set params(dst_path)        $temp_dir
        set params(ptp)             $SYNOPT_PTP
        set params(kr4)             $ENA_KR4
        set params(device)          [::alt_eth_ultra::fileset::get_board_safe_part]
        set params(family)          $DEVICE_FAMILY
        set params(dev_board)       $DEV_BOARD
        set params(caui4)           $IS_CAUI4
        set params(c4_fec)          $IS_C4_FEC
        set params(is_pro)          [::ethernet::tools::is_pro]

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write project generation tcl file
        set tcl_path [file join $temp_dir "${project_name}.tcl"]
        set tcl_fp   [open $tcl_path "w"]
        puts -nonewline $tcl_fp $contents
        close $tcl_fp

        # Run tcl file
        set res [exec quartus_sh -t ${tcl_path}]
        puts "Result = $res"

        # Copy generated qsf and qpf to compilation project dir
        add_fileset_file "../hardware_test_design/${project_name}.qpf" OTHER PATH [file join $temp_dir "${project_name}.qpf"]
        add_fileset_file "../hardware_test_design/${project_name}.qsf" OTHER PATH [file join $temp_dir "${project_name}.qsf"]
    }

    proc generate_compilation_qsf {} {
        set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
        set DEVICE_FAMILY   [ip_get "parameter.DEVICE_FAMILY.value"]
        set IS_CAUI4        [ip_get "parameter.SYNOPT_CAUI4.value"]
        set IS_C4_FEC       [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
        set ENA_KR4         [ip_get "parameter.ENA_KR4.value"]

        if {[expr {$SPEED_CONFIG eq "100 GbE"}]} {
            set speed 100
        } else {
            set speed 40
        }

        if {$speed == 100} {
            set project_name eth_100g_a10
            if {$IS_CAUI4} {
                set variant "ex_100g_caui4"
            } else {
                set variant "ex_100g"
            }
        } else {
            set project_name eth_40g_a10
            set variant "ex_40g"
        }

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]
        # set temp_dir "/data/jgiese/16.1/temp"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_qsf_template.tcl.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(project_name)    $project_name
        set params(variant)         $variant
        set params(ports)           [get_virtual_pins]
        set params(ptp)             [ip_get "parameter.SYNOPT_PTP.value"]
        set params(caui4)           $IS_CAUI4
        set params(dst_path)        $temp_dir
        set params(device)          [::alt_eth_ultra::fileset::get_board_safe_part]
        set params(family)          $DEVICE_FAMILY
        set params(c4_fec)          $IS_C4_FEC
        set params(kr4)             $ENA_KR4

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write project generation tcl file
        set tcl_path [file join $temp_dir "${project_name}.tcl"]
        set tcl_fp   [open $tcl_path "w"]
        puts -nonewline $tcl_fp $contents
        close $tcl_fp

        # Run tcl file
        # set cmd "quartus_sh -t ${tcl_path}"
        set res [exec quartus_sh -t ${tcl_path}]
        puts "Result = $res"

        # Copy generated qsf and qpf to compilation project dir
        add_fileset_file "../compilation_test_design/${project_name}.qpf" OTHER PATH [file join $temp_dir "${project_name}.qpf"]
        add_fileset_file "../compilation_test_design/${project_name}.qsf" OTHER PATH [file join $temp_dir "${project_name}.qsf"]
    }

    proc get_virtual_pins {} {
        set interfaces [get_interfaces]
        set virtual_pins [list]

        foreach interface $interfaces {
            set enabled [get_interface_property $interface ENABLED]
            if {$enabled} {
                set ports [get_interface_ports $interface]
                foreach port $ports {
                    set terminated [get_port_property $port TERMINATION]
                    if {!$terminated} {
                        set is_clk [regexp -nocase {clk} $port]
                        set is_xcvr [regexp {[rt]x_serial} $port]
                        if {[expr {$port eq "tx_serial_clk"}]} {
                            # Internal
                        } elseif {[expr {$port eq "tx_pll_locked"}]} {
                            # Internal
                        } elseif {$is_xcvr} {
                            # Can't assign to virtual pin
                        } elseif {$is_clk} {
                            # Can't assign to virtual pin
                        } else {
                            lappend virtual_pins $port
                        }
                    }
                }
            }
        }
        return $virtual_pins
    }

}
