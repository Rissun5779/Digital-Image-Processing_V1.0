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


package provide ethernet::tools 18.1

namespace eval ::ethernet::tools:: {

    proc create_temp_dir { {dir_name temp_qsys_dir} } {
        file mkdir $dir_name
        return ./${dir_name}
    }

    proc remove_temp_dir { {dir_name temp_qsys_dir} } {
        file delete -force $dir_name
    }

    # Recursively call add_fileset_file. Used to copy an
    # entire directory. Src must be a relative path
    proc copy_folder {src dst {option ""}} {
        set dst_folder [file tail $src];
        set dst_path [file join $dst $dst_folder];
        set glob_path [file join $src "*"]
        set files [glob -nocomplain -tails -directory . -- $glob_path]

        foreach file $files {
            set is_dir  [ file isdirectory $file ]; # isfile test doesn't work
            if {$is_dir} {
                if { [string compare $option recursive] == 0 } {
                    copy_folder $file $dst_path $option
                }
            } else {
                set dst_file_name [file tail $file];
                set dst_file_path [file join $dst_path $dst_file_name];
                add_fileset_file $dst_file_path OTHER PATH $file;
            }
        }
    }

    # Recursive copy for case that source is a absolute path
    proc copy_folder_abs {src dst} {
        set fl [findFiles ${src}]
        foreach file $fl {
            set rel_path [string map [list ${src} ""] $file]
            set f_path [file join $dst ./$rel_path]
            add_fileset_file $f_path OTHER PATH $file
        }
    }

    # Generates an ip core
    # Example usage to generate 40g ultra ethernet core
    # and place it in the current directory
    #
    # lappend parameters "SPEED_CONFIG=\"40 GbE\""
    # ::ethernet::tools::generate_ip_core alt_eth_ultra ex_40g "Arria 10" 10AX115S2F45I2SG "." true $parameters
    proc generate_ip_core {ip_name ip_core_name family device path gen_rtl {parameter_list {}}} {
        set ip_inst_name ${ip_name}_0; # IP instantiation name
        set qsysfile_generation_script ${path}/${ip_core_name}.tcl; #Tcl file for generating qsys file
        set fileId [open $qsysfile_generation_script "w"]

        puts $fileId "package require -exact qsys 16.0"
        puts $fileId "create_system ${ip_core_name}"
        puts $fileId "add_instance ${ip_inst_name} ${ip_name}"
        puts $fileId "set_instance_property ${ip_inst_name} AUTO_EXPORT 1"
        foreach item $parameter_list {
            set pair  [split  $item =]
            set param [lindex $pair 0]
            set val   [lindex $pair 1]
            puts $fileId "set_instance_parameter_value ${ip_inst_name} $param $val"
        }

        puts $fileId "set_project_property DEVICE_FAMILY \"${family}\""
        puts $fileId "set_project_property DEVICE ${device}"

        if {[is_qsys_edition QSYS_PRO]} {
            puts $fileId "save_system ${path}/${ip_core_name}.ip"
        } else {
            puts $fileId "save_system ${path}/${ip_core_name}.qsys"
        }

        close $fileId

        qsys_file_generate ${path} ${ip_core_name}

        if {$gen_rtl == true} {
            local_qsysgenerate ${path} ${ip_core_name} "./${ip_core_name}"
        }

        file delete -force $qsysfile_generation_script
    }

    proc qsys_file_generate { filepath qsysname} {
        set ip_generation_script ${filepath}/${qsysname}_gen.tcl
        set fh [open ${ip_generation_script} w]
        set qdir $::env(QUARTUS_ROOTDIR)

        set cmd "${qdir}/sopc_builder/bin/qsys-script"

        if {[is_qsys_edition QSYS_PRO]} {
            set cmd "${cmd} --pro"
        }

        set cmd "${cmd} --script=${filepath}/${qsysname}.tcl\n"
        puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
        puts $fh "puts \$temp"
        close $fh

        set result [source ${ip_generation_script}]
        file delete -force ${ip_generation_script}
        puts "run_tclsh_script result:${result}"
    }


    proc local_qsysgenerate { filepath qsysname subdir} {
        set ip_generation_script ${filepath}/${qsysname}_gen.tcl
        set fh [open ${ip_generation_script} w]
        set qdir $::env(QUARTUS_ROOTDIR)

        set cmd "${qdir}/sopc_builder/bin/qsys-generate"

        if {[is_qsys_edition QSYS_PRO]} {
            set cmd "${cmd} ${filepath}/${qsysname}.ip"
        } else {
            set cmd "${cmd} ${filepath}/${qsysname}.qsys"
        }

        set cmd "${cmd} --output-directory=${filepath}/${subdir}"
        set cmd "${cmd} --synthesis=VERILOG"
        set cmd "${cmd} --simulation=VERILOG"
        puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
        puts $fh "puts \$temp"
        close $fh

        set result [source ${ip_generation_script}]
        file delete -force ${ip_generation_script}
        puts "run_tclsh_script result:${result}"
    }

    proc generate_parameter_value_pairs {parameters} {
        foreach p $parameters {
            if {[get_parameter_property $p DERIVED] == 0} {
                set val \"[get_parameter_value $p]\"
                if {$p != "DEVICE_FAMILY" && $p != "DEVICE"} {
                    lappend parameter_pairs ${p}=${val}
                }
            }
        }
        return $parameter_pairs
    }

}
