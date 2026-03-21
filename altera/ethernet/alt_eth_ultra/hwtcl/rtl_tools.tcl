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


package provide alt_eth_ultra::rtl_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_eth_ultra::rtl_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_top_level_file { entity_name } {
        set SPEED_CONFIG        [ip_get "parameter.SPEED_CONFIG.value"]

        if {[expr {$SPEED_CONFIG eq "100 GbE"}]} {
            set template_path [file join .. 100g rtl eth alt_aeu_100_top.v.terp]
        } else {
            set template_path [file join .. 40g rtl eth alt_aeu_40_top.v.terp]
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
        set REF_CLK             [ip_get "parameter.PHY_REFCLK.value"]
        set KR4                 [ip_get "parameter.ENA_KR4.value"]
        set FAMILY              [ip_get "parameter.DEVICE_FAMILY.value"]
        set IS_CAUI4            [ip_get "parameter.SYNOPT_CAUI4.value"]

        if {[expr {$SPEED_CONFIG eq "100 GbE"}]} {
            set speed 100
        } else {
            set speed 40
        }

        if {[expr {$FAMILY eq "Arria 10"}]} {
            set family_short a10
        } else {
            set family_short sv
        }

        # Used for file and module name
        set module_name "eth_ex_${speed}g"
        if {$KR4} {      set module_name "${module_name}_kr4" }
        if {$IS_CAUI4} { set module_name "${module_name}_caui4" }
        set module_name "${module_name}_${family_short}"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_example_template.v.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        if {$REF_CLK == 1} {
            set ref_clk 644
        } else {
            set ref_clk 322
        }

        set params(module_name)     $module_name
        set params(speed)           $speed
        set params(family)          $FAMILY
        set params(family_short)    $family_short
        set params(link_fault)      [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
        set params(ref_clk)         $ref_clk
        set params(ptp)             [ip_get "parameter.SYNOPT_PTP.value"]
        set params(ptp64)           [ip_get "parameter.SYNOPT_64B_PTP.value"]
        set params(ptp96)           [ip_get "parameter.SYNOPT_96B_PTP.value"]
        set params(pause)           [ip_get "parameter.SYNOPT_PAUSE_TYPE.value"]
        set params(link_fault)      [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
        set params(ext_tx_pll)      [ip_get "parameter.EXT_TX_PLL.value"]
        set params(avalon)          [ip_get "parameter.SYNOPT_AVALON.value"]
        set params(kr4)             $KR4
        set params(caui4)           $IS_CAUI4

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join hardware_test_design "${module_name}.v"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_testbench_rtl {} {
        set SPEED_CONFIG            [ip_get "parameter.SPEED_CONFIG.value"]
        set SYNOPT_LINK_FAULT       [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
        set SYNOPT_PREAMBLE_PASS    [ip_get "parameter.SYNOPT_PREAMBLE_PASS.value"]

        # Used for file and module name
        set instance_name "basic_avl_tb_top"
        
        # Read template into variable "template"
        set template_path [file join templates testbench_template.sv.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(module_name)     $instance_name
        set params(speed)           $SPEED_CONFIG
        set params(link_fault)      $SYNOPT_LINK_FAULT
        set params(preamble_pass)   $SYNOPT_PREAMBLE_PASS

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join example_testbench "${instance_name}.sv"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_compilation_rtl {} {
        set IS_100G     [ip_get "parameter.IS_100G.value"]
        set IS_CAUI4    [ip_get "parameter.SYNOPT_CAUI4.value"]

        # Variant specific settings
        if {$IS_100G} {
            set module_name eth_100g_a10
            if {$IS_CAUI4} {
                set ip_inst_name ex_100g_caui4
            } else {
                set ip_inst_name ex_100g
            }
            set speed 100
        } else {
            set module_name eth_40g_a10
            set ip_inst_name ex_40g
            set speed 40
        }

        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_rtl_template.v.terp]

        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(module_name)     $module_name
        set params(speed)           $speed
        set params(caui4)           $IS_CAUI4
        set params(ip_inst_name)    $ip_inst_name

        set exposed_ports [get_compilation_ports]
        set params(ports)      [list]
        set params(widths)     [list]
        set params(directions) [list]
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
        set dst [file join compilation_test_design "${module_name}.v"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc get_compilation_ports {} {
        set interfaces [get_interfaces]
        set exposed_ports [list]

        foreach interface $interfaces {
            set ports [get_interface_ports $interface]
            foreach port $ports {
                set terminated [get_port_property $port TERMINATION]
                if {!$terminated} {
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
