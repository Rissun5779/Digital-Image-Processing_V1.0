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


package provide alt_eth_ultra::srf_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_eth_ultra::srf_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_compilation_srf {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
        set IS_CAUI4     [ip_get "parameter.SYNOPT_CAUI4.value"]

        if {[expr {$SPEED_CONFIG eq "100 GbE"}]} {
            set speed 100
        } else {
            set speed 40
        }

        # Used for file and module name
        set instance_name "eth_${speed}g_a10"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_srf_template.txt.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(speed)       $speed
        set params(caui4)       $IS_CAUI4

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join compilation_test_design "${instance_name}.srf"]
        add_fileset_file $dst OTHER TEXT $contents
        #add_fileset_file $dst OTHER PATH $template_path
    }

    proc generate_hardware_srf {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
        set IS_CAUI4     [ip_get "parameter.SYNOPT_CAUI4.value"]

        if {[expr {$SPEED_CONFIG eq "100 GbE"}]} {
            set speed 100
        } else {
            set speed 40
        }

        # Used for file and module name
        set instance_name "eth_ex_${speed}g"
        if {$IS_CAUI4} { set instance_name "${instance_name}_caui4" }
        set instance_name "${instance_name}_a10"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_srf_template.txt.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(speed)       $SPEED_CONFIG

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join hardware_test_design "${instance_name}.srf"]
        add_fileset_file $dst OTHER TEXT $contents
    }
}
