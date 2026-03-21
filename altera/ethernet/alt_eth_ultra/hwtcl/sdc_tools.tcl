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


package provide alt_eth_ultra::sdc_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_eth_ultra::sdc_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_compilation_sdc {} {
        set IS_100G     [ip_get "parameter.IS_100G.value"]
        set IS_CAUI4    [ip_get "parameter.SYNOPT_CAUI4.value"]
        set IS_C4_FEC   [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
        set KR4         [ip_get "parameter.ENA_KR4.value"]

        if {$IS_100G} {
            set speed 100
            set module_name eth_100g_a10
        } else {
            set speed 40
            set module_name eth_40g_a10
        }

        # Read template into variable "template"
        set template_path [file join .. example_project templates compilation_sdc_template.sdc.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(speed)   $speed
        set params(caui4)   $IS_CAUI4
        set params(c4_fec)  $IS_C4_FEC
        set params(kr4)     $KR4

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join compilation_test_design "${module_name}.sdc"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_hardware_sdc {} {
        set IS_100G     [ip_get "parameter.IS_100G.value"]
        set IS_CAUI4    [ip_get "parameter.SYNOPT_CAUI4.value"]
        set IS_C4_FEC   [ip_get "parameter.SYNOPT_C4_RSFEC.value"]
        set ENA_KR4     [ip_get "parameter.ENA_KR4.value"]

        if {$IS_100G} {
            set speed 100g
        } else {
              if {$ENA_KR4} {
                 set speed 40g_kr4
              } else {
                 set speed 40g
              }		      
        }

        # Used for file and module name
        set module_name "eth_ex_${speed}"
        if {$IS_CAUI4} { set module_name "${module_name}_caui4" }
        set module_name "${module_name}_a10"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates hardware_sdc_template.sdc.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        #set params(speed)       $speed
        set params(caui4)   $IS_CAUI4
        set params(c4_fec)  $IS_C4_FEC

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join hardware_test_design "${module_name}.sdc"]
        add_fileset_file $dst OTHER TEXT $contents
    }
}
