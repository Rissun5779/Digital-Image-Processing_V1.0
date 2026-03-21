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


package provide alt_e2550::sdc_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_e2550::sdc_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_hardware_sdc {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
        set IP_NAME      [ip_get "module.NAME.value"]
        set PTP_EN       [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set DIV40        [ip_get "parameter.SYNOPT_DIV40.value"]

        # Used for file and module name
        set instance_name "eth_ex_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_design_template.sdc.terp]

        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(speed)       $SPEED_CONFIG
        set params(ip_name)     $IP_NAME
        set params(enable_ptp)  $PTP_EN
        set params(enable_div40)  $DIV40

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join hardware_test_design "${instance_name}.sdc"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_compilation_sdc {} {
        set SPEED_CONFIG [ip_get "parameter.SPEED_CONFIG.value"]
        set IP_NAME      [ip_get "module.NAME.value"]
        set PTP_EN       [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
        set DIV40        [ip_get "parameter.SYNOPT_DIV40.value"]

        # Used for file and module name
        set instance_name "alt_eth_${SPEED_CONFIG}g"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_design_template.sdc.terp]

        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(speed)       $SPEED_CONFIG
        set params(ip_name)     $IP_NAME
        set params(enable_ptp)  $PTP_EN
        set params(enable_div40)  $DIV40

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join compilation_test_design "${instance_name}.sdc"]
        add_fileset_file $dst OTHER TEXT $contents
    }
}
