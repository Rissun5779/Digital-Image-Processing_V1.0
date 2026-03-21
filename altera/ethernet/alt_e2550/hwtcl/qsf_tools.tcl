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


package provide alt_e2550::qsf_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_e2550::qsf_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_hardware_qsf {} {
        set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
        set DEVICE_FAMILY   [ip_get "parameter.DEVICE_FAMILY.value"]
        set device          [::alt_e2550::fileset::get_board_safe_part]
        set board           [ip_get "parameter.DEV_BOARD.value"]
        set PTP_EN          [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set DIV40           [ip_get "parameter.SYNOPT_DIV40.value"]

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]

        # Used for file and module name
        set project_name "eth_ex_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_design_qsf_template.tcl.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]

        close $template_fd

        # Set varables needed by template
        set params(project_name)    $project_name
        set params(ip_inst)         "ex_${SPEED_CONFIG}g"
        set params(speed)           $SPEED_CONFIG
        set params(dst_path)        $temp_dir
        set params(device)          $device
        set params(board)           $board
        set params(family)          $DEVICE_FAMILY
        set params(is_pro)          [is_qsys_edition QSYS_PRO]
        set params(enable_ptp)      $PTP_EN
        set params(enable_div40)    $DIV40

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
        set device          [::alt_e2550::fileset::get_board_safe_part]
        set PTP_EN          [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set DIV40           [ip_get "parameter.SYNOPT_DIV40.value"]

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]

        # Used for file and module name
        set project_name "alt_eth_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_design_qsf_template.tcl.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(project_name)    $project_name
        set params(ip_inst)         "ex_${SPEED_CONFIG}g"
        set params(speed)           $SPEED_CONFIG
        set params(ports)           [get_virtual_pins]
        set params(dst_path)        $temp_dir
        set params(device)          $device
        set params(family)          $DEVICE_FAMILY
        set params(enable_ptp)      $PTP_EN
        set params(enable_div40)    $DIV40

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
        return $virtual_pins
    }

}
