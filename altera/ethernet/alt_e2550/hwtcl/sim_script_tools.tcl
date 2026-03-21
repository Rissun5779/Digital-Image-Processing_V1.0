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


package provide alt_e2550::sim_script_tools 18.1

package require altera_terp
package require alt_xcvr::ip_tcl::ip_module; #ip_get

namespace eval ::alt_e2550::sim_script_tools:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    proc generate_ncsim_script {} {
        set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
        set OTN             [ip_get "parameter.SYNOPT_OTN.value"]
        set RSFEC           [ip_get "parameter.SYNOPT_RSFEC.value"]

        if {$SPEED_CONFIG == 50} {
            set variant "ex_50g"
        } else {
            set variant "ex_25g"
        }
        set sim_dir [file join ".." $variant "sim"]

        # Used for file and module name
        set file_name "run_ncsim.sh"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates ncsim_script.sh.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(sim_dir)         $sim_dir
        set params(rsfec)           $RSFEC

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join example_testbench "${file_name}"]
        add_fileset_file $dst OTHER TEXT $contents
    }

    proc generate_vcs_script {} {
        set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
        set OTN             [ip_get "parameter.SYNOPT_OTN.value"]
        set RSFEC           [ip_get "parameter.SYNOPT_RSFEC.value"]

        if {$SPEED_CONFIG == 50} {
            set variant "ex_50g"
        } else {
            set variant "ex_25g"
        }

        if {$OTN} {
            set testbench_name "alt_e25_otn_tb"
        } else {
            set testbench_name "basic_avl_tb_top"
        }

        # Used for file and module name
        set file_name "run_vcs.sh"
        
        # Read template into variable "template"
        set template_path [file join .. example_project templates vcs_script.sh.terp]
        set template_fd   [open $template_path]
        set template      [read $template_fd]
        close $template_fd

        # Set varables needed by template
        set params(testbench_name)  $testbench_name
        set params(ip_dir)          $variant
        set params(rsfec)           $RSFEC

        # Convert template to output file
        set contents [altera_terp $template params]

        # Write file to project
        set dst [file join example_testbench "${file_name}"]
        add_fileset_file $dst OTHER TEXT $contents
    }

}
