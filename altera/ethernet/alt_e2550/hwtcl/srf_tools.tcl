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


package provide alt_e2550::srf_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_e2550::srf_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_compilation_srf {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]

        # Used for file and module name
        set instance_name "alt_eth_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_srf_template.txt.terp]
        #set template_fd   [open $template_path]
        #set template      [read $template_fd]
        #close $template_fd

        ## Set varables needed by template
        #set params(speed)       $SPEED_CONFIG

        ## Convert template to output file
        #set contents [altera_terp $template params]

        ## Write file to project
        set dst [file join compilation_test_design "${instance_name}.srf"]
        add_fileset_file $dst OTHER PATH $template_path
        #add_fileset_file $dst OTHER TEXT $contents
    }
}
