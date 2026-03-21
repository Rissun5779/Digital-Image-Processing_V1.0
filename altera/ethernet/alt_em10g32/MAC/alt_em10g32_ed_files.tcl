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


#namespace import ::fileutil::globfind::*


proc example_design_func {entityname} {

    set INSTANTIATE_STATISTICS [get_parameter_value INSTANTIATE_STATISTICS]
    set ENABLE_MEM_ECC [get_parameter_value ENABLE_MEM_ECC]
    set ENABLE_SUPP_ADDR [get_parameter_value ENABLE_SUPP_ADDR]
    set REGISTER_BASED_STATISTICS [get_parameter_value REGISTER_BASED_STATISTICS]
    
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS]    
    set ENABLE_ED_FILESET_SIM [get_parameter_value ENABLE_ED_FILESET_SIM]    
    set SELECT_ED_FILESET [get_parameter_value SELECT_ED_FILESET]
    set SELECT_SUPPORTED_VARIANT [get_parameter_value SELECT_SUPPORTED_VARIANT]    
    set SELECT_TARGETED_DEVICE [get_parameter_value SELECT_TARGETED_DEVICE]    
    set DEVICE [get_parameter_value DEVICE]
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]  
    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]
    set SELECT_CUSTOM_DEVICE [get_parameter_value SELECT_CUSTOM_DEVICE]
    
    if {$ENABLE_ED_FILESET_SYNTHESIS == 1 && $ENABLE_ED_FILESET_SIM == 1} {
        set synthesis_option "both"    
    } elseif {$ENABLE_ED_FILESET_SYNTHESIS == 1 && $ENABLE_ED_FILESET_SIM == 0} {
        set synthesis_option "synth"       
    } elseif {$ENABLE_ED_FILESET_SYNTHESIS == 0 && $ENABLE_ED_FILESET_SIM == 1} {    
        set synthesis_option "sim"
    }

    if {$SELECT_ED_FILESET == 1} {
        set languaue_option "VHDL"    
    } else {
        set languaue_option "VERILOG"
    }
    
    # Need to choose the correct device part number when user select 'None' or available devkit as 'Target Development Kit'
    if {$SELECT_TARGETED_DEVICE == 0} {
        set device_part_value "nomatch"    
        set device_part_number $DEVICE
    } elseif {$SELECT_TARGETED_DEVICE == 1} {
        ## Only support Si devkit in ACDS 15.1
        set device_part_value "match"
        if {$SELECT_CUSTOM_DEVICE == 1 && [validate_custom_device]} {
            set device_part_number $DEVICE
        } else {
            set device_part_number $DEVKIT_DEVICE
        }
    } elseif {$SELECT_TARGETED_DEVICE == 2} {
        set device_part_value "nomatch_custom"    
        set device_part_number $DEVICE
    }

    if {![string compare $DEVICE_FAMILY "Stratix 10"]} {
        set family_tag "_s10"
#        set device_part_number "ND5_40_PART1"
    } elseif {![string compare $DEVICE_FAMILY "Arria 10"]} {
        set family_tag "_a10"
    }

    # only support Arria 10 and onwards family
    if {[string compare $DEVICE_FAMILY "Arria 10"] && [string compare $DEVICE_FAMILY "Stratix 10"]} {
        send_message WARNING "Example Design is not supported for $DEVICE_FAMILY family. Please refer to User Guide for supported family"
        send_message WARNING "The current supported family is Arria 10 & Stratix 10."
    } elseif {$SELECT_SUPPORTED_VARIANT == 0} {
        send_message ERROR "No Example design is generated"
    } elseif {$ENABLE_ED_FILESET_SYNTHESIS == 0 && $ENABLE_ED_FILESET_SIM == 0} {
        # Ensure either synthesis or simulation fileset is selected, cannot both unchecked.
        send_message ERROR "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Example Design Files\" are selected to allow generation of Example Design Files."
    } elseif {$SELECT_SUPPORTED_VARIANT == 1 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_qse_lineside $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 2 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_qse_lineside_1588v2 $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag  
    } elseif {$SELECT_SUPPORTED_VARIANT == 3 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_10gbaser_regmode $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 4 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_1g_10g_lineside $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 5 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_1g_10g_lineside_1588v2 $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 6 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_1g_2_5g $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 7 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_1g_2_5g_10g $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 8 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_1g_2_5g_1588v2 $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 9 && ![string compare $DEVICE_FAMILY "Arria 10"]} {
        a10_10g_usxgmii $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } elseif {$SELECT_SUPPORTED_VARIANT == 10} {
        a10_10gbaser $synthesis_option $device_part_value $languaue_option $device_part_number $DEVICE_FAMILY $family_tag
    } else {
        send_message WARNING "The selected Example Design Preset is not supported for Stratix 10. Please refer to User Guide for supported family and Example Design variants"
    }
    

    
    #verilog_testbench_generator $ENABLE_ED_FILESET_SYNTHESIS $ENABLE_ED_FILESET_SIM $INSTANTIATE_STATISTICS $ENABLE_MEM_ECC
   
   
    
}


proc local_qsysgenerate {location variant variant_folder file_set qsys_file qsys_type languaue_option part_number device_family family_tag is_qsys_pro} {

    set qsys_ext ""

    if {![string compare $device_family "Arria 10"] || [string compare $device_family "Arria 10"] && $qsys_type == "qsys_system"} {
        set qsys_ext ".qsys"
    } else {
        set qsys_ext ".ip"
    }

    if {[string match "*_mac" $qsys_file]} {
        # need to resolve MAC .qsys terp file before qsys-generate the MAC IP
        mod_mac_terp $location $variant $variant_folder $qsys_file $qsys_type $family_tag $qsys_ext $device_family $is_qsys_pro
    } else {
        copy_file_mkdir $location $variant $variant_folder $qsys_file $qsys_type $family_tag $qsys_ext $device_family $is_qsys_pro
    }

    generate_copy $location $variant $variant_folder $file_set "${qsys_file}${qsys_ext}" $qsys_type $languaue_option $part_number $device_family $is_qsys_pro

}

proc copy_mod_qsys {location variant variant_folder qsys_file instance file_set instantiate_statistics enable_mem_ecc languaue_option part_number} {

    copy_file_mkdir $location $variant $variant_folder $qsys_file
    set temp_param_file [file join $location/$variant_folder/temp_param.tcl]
    set fh [open $temp_param_file w]
        
    puts $fh "package require -exact qsys 15.0 \n"
    puts $fh "load_system ${location}/$variant_folder/$qsys_file \n"
    puts $fh "set_instance_parameter_value $instance INSTANTIATE_STATISTICS $instantiate_statistics \n"
    puts $fh "set_instance_parameter_value $instance ENABLE_MEM_ECC $enable_mem_ecc \n"


    puts $fh "save_system ${location}/$variant_folder/$qsys_file"
    
    close $fh
    set mod_qsys_param "qsys-script --script=$temp_param_file"
    set status [catch {exec $mod_qsys_param} result]
    
    generate_copy $location $variant $variant_folder $file_set $qsys_file $languaue_option $part_number
    
    add_fileset_file "./$variant/$variant_folder/$qsys_file" OTHER PATH ${location}/$variant_folder/$qsys_file

}

# 
# Copy file and make directory for its
#
proc copy_file_mkdir {location variant variant_folder qsys_file qsys_type family_tag qsys_ext device_family is_qsys_pro} {

    set target_folder_normalize [file join ${location}/$variant_folder]
    set target_file_normalize [file join $target_folder_normalize/${qsys_file}${qsys_ext}]
    set source_file_normalize [file join ../example_design/$variant/$variant_folder/${qsys_file}${family_tag}${qsys_ext}]
    set source_folder_normalize [file join ../example_design/$variant/$variant_folder/ip${family_tag}]
    file mkdir $target_folder_normalize
    copyFiles $source_file_normalize $target_file_normalize

}

# 
# generate qsys file and copy to respective directory
#
proc generate_copy {location variant variant_folder file_set qsys_file qsys_type language_option part_number device_family is_qsys_pro} {

    set path_normalize [file join $location/$variant_folder]
    set qsys_file_normalize [file join $path_normalize/$qsys_file]
    set ENABLE_ADME [get_parameter_value ENABLE_ADME]

    global tcl_platform
    global env

    regexp (Windows*|Linux*) $tcl_platform(os) os_used 
    #send_message INFO "$os_used is os"
    set qsys_path_normalize [file join $env(QUARTUS_ROOTDIR)/sopc_builder/bin/]
    if {$os_used == "Windows"} {
        set qsys_generate_command "qsys-generate.EXE"
        set qsys_script_command "qsys-script.EXE"
    } else {
        set qsys_generate_command "qsys-generate"
        set qsys_script_command "qsys-script"
    }
    
    set combine_qsys_generate_command_normalize [file join "$qsys_path_normalize/$qsys_generate_command"]
    set combine_qsys_script_command_normalize [file join "$qsys_path_normalize/$qsys_script_command"]
    set a10_tcl_file [file join "$path_normalize/a10_script"]
    set is_a10_phy "0"

    if {![string compare $device_family "Arria 10"]} {
        # A10: To modify setting for PHY
        
        if {$qsys_file == "altera_eth_10gbaser_phy.qsys" || $qsys_file == "low_latency_baser.qsys"} {
            # 10g-baser native phy
            set out [ open $a10_tcl_file w ]
            puts $out "package require -exact qsys 16.0"
            puts $out "load_system {$qsys_file_normalize}"
            puts $out "set_instance_parameter_value xcvr_native_a10_0 {rcfg_jtag_enable} {$ENABLE_ADME}"
            puts $out "save_system"
            close $out
            set is_a10_phy "1"
        } elseif {$qsys_file == "altera_eth_10gkr_phy.qsys"} {
            # 1g/10g PHY
            set out [ open $a10_tcl_file w ]
            puts $out "package require -exact qsys 16.0"
            puts $out "load_system {$qsys_file_normalize}"
            puts $out "set_instance_parameter_value xcvr_10gkr_a10_0 {HARD_PRBS_ENABLE} {$ENABLE_ADME}"
            puts $out "save_system"
            close $out    
            set is_a10_phy "1"
        } elseif {$qsys_file == "alt_mge_1g_2p5g_phy.qsys" || $qsys_file == "alt_mgbaset_phy.qsys"  || $qsys_file == "alt_usxgmii_phy.qsys"} {
            # MGE PHY
            set out [ open $a10_tcl_file w ]
            puts $out "package require -exact qsys 16.0"
            puts $out "load_system {$qsys_file_normalize}"
            puts $out "set_instance_parameter_value alt_mge_phy_0 {XCVR_RCFG_JTAG_ENABLE} {$ENABLE_ADME}"
            puts $out "save_system"
            close $out       
            set is_a10_phy "1"
        }
    }
        
    # Arria 10 does not have .ip file checked-in. Need to use qsys-script to convert the qsys file to qsys pro
    if {![string compare $device_family "Arria 10"]} {
        if {$is_a10_phy == "1"} {
            set qsys_script [list $combine_qsys_script_command_normalize --quartus-project=none --script=$a10_tcl_file]
        } else {
            set qsys_script [list $combine_qsys_script_command_normalize --package-version=16.0 --quartus-project=none --system-file=$qsys_file_normalize --cmd="save_system"]
        }
    }
        
    set qsys_generate_ip_upgrade [list $combine_qsys_generate_command_normalize $qsys_file_normalize --part=$part_number --upgrade-ip-cores]
    
    if {$file_set == "both"} {
        set qsys_generate [list $combine_qsys_generate_command_normalize $qsys_file_normalize --part=$part_number --synthesis=$language_option --simulation=$language_option]
    } elseif {$file_set == "synth"} {
        set qsys_generate [list $combine_qsys_generate_command_normalize $qsys_file_normalize --part=$part_number --synthesis=$language_option]
    } elseif {$file_set == "sim"} {
        set qsys_generate [list $combine_qsys_generate_command_normalize $qsys_file_normalize --part=$part_number --simulation=$language_option]
    } else {
        set qsys_generate [list $combine_qsys_generate_command_normalize $qsys_file_normalize --part=$part_number --synthesis=$language_option --simulation=$language_option]
    }
    
    if {![string compare $device_family "Arria 10"]} {
        exec_qsys_command $qsys_script
    }
 
    ## upgrade the ip before generate
    exec_qsys_command $qsys_generate_ip_upgrade
    
    ## generate the ip
    exec_qsys_command $qsys_generate
    
    #set fl [globfind ${location}/${variant_folder}]
   

}

proc find_files_copy_back {location variant} {
    
    set fl [f_find ${location}]
    
    foreach file $fl {
        set f_path [string map [list ${location} ""] $file]
        if {[file ext $file] == ".v"} {
            add_fileset_file "./$variant/$f_path" VERILOG PATH $file
        } elseif {[file ext $file] == ".sv"} {
            add_fileset_file "./$variant/$f_path" SYSTEM_VERILOG PATH $file
        } elseif {[file ext $file] == ".mif"} {
            add_fileset_file "./$variant/$f_path" MIF PATH $file
        } elseif {[file ext $file] == ".hex"} {
            add_fileset_file "./$variant/$f_path" HEX PATH $file
        } elseif {[file ext $file] == ".vhd"} {
            add_fileset_file "./$variant/$f_path" VHDL PATH $file
        } elseif {[file ext $file] == ".sdc"} {
            add_fileset_file "./$variant/$f_path" SDC PATH $file
        } elseif {[file ext $file] == ".qsys" || [file ext $file] == ".qip" || [file ext $file] == ".tcl" || [file ext $file] == ".vo" || [file ext $file] == ".vho" || [file ext $file] == ".do" || [file ext $file] == ".sh" || [file ext $file] == ".setup" || [file ext $file] == ".lib" || [file ext $file] == ".var" || [file ext $file] == ".spd" || [file ext $file] == ".rpt" || [file ext $file] == ".xml" || [file ext $file] == ".ip" || [file ext $file] == ".json" || [file ext $file] == ".txt" || [file ext $file] == ".ocp" || [file ext $file] == ".csv" || [file ext $file] == ".h"} {
            add_fileset_file "./$variant/$f_path" OTHER PATH $file
        } else {
            
        }
    }


}

proc exec_qsys_command {command} {
    # Set this to 1 to display all messages returned by the executed command
    set display_full_message 1
    
    # Set this to 1 to suppress warning to info
    set suppress_warning_to_info 1
    
    set status [catch {exec {*}$command} result]
    
    if {$display_full_message == 1} {
        set result [split $result "\n"]
        
        # Categorize each Qsys returned messages
        foreach line $result {
            if {[string match {*Error: *} $line]} {
                regexp {(?!.*Error:)( .*)} $line -> newLine
                send_message ERROR [string trim $newLine " "]
            } elseif {[string match {*Warning: *} $line]} {
                regexp {(?!.*Warning:)( .*)} $line -> newLine
                if {$suppress_warning_to_info == 1} {
                    send_message INFO [string trim $newLine " "]
                } else {
                    send_message WARNING [string trim $newLine " "]
                }
            } elseif {[string match {*Info: *} $line]} {
                regexp {(?!.*Info:)( .*)} $line -> newLine
                send_message INFO [string trim $newLine " "]
            } else {
                send_message INFO $line
            }
        }
    } else {
        # Return Code   Description
        # -----------   ------------------------------
        # 0             Execution was successful
        # 2             Execution failed due to an internal error
        # 3             Execution failed due to user error(s)
        # 4             Execution was stopped by the user
        if {$status == 0} {
            # process no issue/error. related information will be display in standard out
            send_message INFO "$command succeeded."
        } elseif {[string equal $::errorCode NONE]} {
            # standard out contain some information but exited without issue
            if {$suppress_warning_to_info == 1} {
                send_message INFO "$command succeeded."
            } else {
                send_message WARNING "$command succeeded with exit code $status, error code: $::errorCode."
            }
        } else {
            send_message ERROR "$command failed with exit code $status, error code: $::errorCode."
        }
    }
}


proc f_find {path} {

    package require fileutil

    set filesToUpload [fileutil::find $path]
    return $filesToUpload
}

proc copyFiles {source_file dest_file} {
    set source_fh [open $source_file r]
    set dest_fh [open $dest_file w]
    while {[gets $source_fh line] >= 0} {
        puts $dest_fh $line
    }
    close $source_fh
    close $dest_fh
}


proc mod_top_and_tb_terp {location variant variant_folder terp_file type} {

    
    set NUM_CHANNELS [get_parameter_value SELECT_NUMBER_OF_CHANNEL]
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    
    set template_file [ file join ${location} ${terp_file}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(NUM_CHANNELS) $NUM_CHANNELS
    set params(DEVICE_FAMILY) $DEVICE_FAMILY
    
    set result   [ altera_terp $template params ]
    
    add_fileset_file "./$variant/$variant_folder/$terp_file" $type TEXT $result
}

proc mod_tb_terp {location variant variant_folder terp_file type} {

    
    set NUM_CHANNELS [get_parameter_value SELECT_NUMBER_OF_CHANNEL]
    
    set template_file [ file join ${location} ${terp_file}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(NUM_CHANNELS) $NUM_CHANNELS
    
    set result   [ altera_terp $template params ]
    
    add_fileset_file "./$variant/$variant_folder/$terp_file" $type TEXT $result
}

proc mod_mac_terp {location variant variant_folder terp_file qsys_type family_tag qsys_ext device_family is_qsys_pro} {

    set INSTANTIATE_STATISTICS [get_parameter_value INSTANTIATE_STATISTICS]
    set ENABLE_MEM_ECC [get_parameter_value ENABLE_MEM_ECC]
    set ENABLE_SUPP_ADDR [get_parameter_value ENABLE_SUPP_ADDR]
    set REGISTER_BASED_STATISTICS [get_parameter_value REGISTER_BASED_STATISTICS]
    set ENABLE_ADME [get_parameter_value ENABLE_ADME]
    
    set template_file [ file join "../example_design/$variant/$variant_folder" ${terp_file}${family_tag}${qsys_ext}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(ENABLE_SUPP_ADDR) $ENABLE_SUPP_ADDR
    set params(ENABLE_MEM_ECC) $ENABLE_MEM_ECC
    set params(INSTANTIATE_STATISTICS) $INSTANTIATE_STATISTICS
    set params(REGISTER_BASED_STATISTICS) $REGISTER_BASED_STATISTICS
    set params(ENABLE_ADME) $ENABLE_ADME
    
    set result   [ altera_terp $template params ]

    # save the result .qsys file to temporary folder
    file mkdir [file join ${location}/$variant_folder]
    set terp_file_normalize [file join "$location/$variant_folder/${terp_file}${qsys_ext}"]
    set save_file [open $terp_file_normalize w]
    puts $save_file $result
    close $save_file

}

proc mod_qsf_terp {location variant variant_folder terp_file virtual_pin device type is_qsys_pro} {
    
    set NUM_CHANNELS [get_parameter_value SELECT_NUMBER_OF_CHANNEL]
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    
    set template_file [ file join ${location} ${terp_file}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(DEVICE) $device
    set params(CHANNEL) $NUM_CHANNELS
    set params(DEVICE_FAMILY) $DEVICE_FAMILY
    set params(qsys_pro) $is_qsys_pro

    if {![string compare -nocase $virtual_pin "virtual_pin"]} {
        set params(VIRTUAL_PIN) "set_instance_assignment -name VIRTUAL_PIN ON"
        set params(virtual) 1
    } elseif {![string compare -nocase $virtual_pin "blank"]} {
        set params(VIRTUAL_PIN) "set_location_assignment <blank>"
        set params(virtual) 0
    } else {
        set params(VIRTUAL_PIN) "set_instance_assignment -name VIRTUAL_PIN ON"
        set params(virtual) 1
    }
    
    set result   [ altera_terp $template params ]
    add_fileset_file "./$variant/$variant_folder/$terp_file" $type TEXT $result

}

proc mod_devkit_qsf_terp {location variant variant_folder terp_file sdc_file device type is_qsys_pro} {

    set NUM_CHANNELS [get_parameter_value SELECT_NUMBER_OF_CHANNEL]
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]

    set template_file [ file join ${location} ${terp_file}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(DEVKIT_DEVICE) $device
    set params(CHANNEL) $NUM_CHANNELS
    set params(DEVICE_FAMILY) $DEVICE_FAMILY
    set params(qsys_pro) $is_qsys_pro
    
    set result   [ altera_terp $template params ]
    add_fileset_file "./$variant/$variant_folder/$sdc_file" $type TEXT $result

}

proc mod_sdc_terp {location variant variant_folder terp_file type} {

    set SELECT_NUMBER_OF_CHANNEL [get_parameter_value SELECT_NUMBER_OF_CHANNEL]    
    
    set template_file [ file join ${location} ${terp_file}.terp ]  
    set template   [ read [ open $template_file r ] ] 
    
    set params(SELECT_NUMBER_OF_CHANNEL) $SELECT_NUMBER_OF_CHANNEL
    
    set result   [ altera_terp $template params ]
    add_fileset_file "./$variant/$variant_folder/$terp_file" $type TEXT $result

}

## To-Do: seems like no one is using this function. review to be removed
proc mac_add_synth_files {variant} {


    
    global compilation_files
    global compilation_files_misc
    global compilation_files_1588
    global compilation_or_sim


    add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/synth/altera_reset_controller.sdc SDC PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/merlin/altera_reset_controller/altera_reset_controller.sdc" {SYNTHESIS}
    
    foreach {files type} $compilation_files {
        add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/synth/$files $type PATH $files 
    
    } 

    foreach {files type} $compilation_files_misc {
        add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/synth/$files $type PATH $files 
    
    }

    foreach {files_to type files_from} $compilation_or_sim {
        add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/synth/$files_to $type PATH $files_from 
    
    }

    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    if {$ENABLE_TIMESTAMPING} {

        foreach {files type} $compilation_files_1588 {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/synth/rtl/$files $type PATH ../1588/$files 
    
        } 

        
    }
    # To-Do: need review as function arguments changed
#    mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/altera_eth_10g_mac/synth altera_eth_10g_mac.v VERILOG
    

}

## To-Do: seems like no one is using this function. review to be removed
proc mac_add_sim_files {variant} {

    global simulation_files
    global simulation_files_1588
    global compilation_or_sim

    foreach {file_name filetype} $simulation_files {
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/mentor/$file_name $filetype PATH mentor/$file_name  {MENTOR_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/aldec/$file_name $filetype PATH aldec/$file_name  {ALDEC_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/synopsys/$file_name $filetype PATH synopsys/$file_name  {SYNOPSYS_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/cadence/$file_name $filetype PATH cadence/$file_name  {CADENCE_SPECIFIC}
        }        
    }
    
    foreach {file_name filetype} $simulation_files_1588 {
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/mentor/rtl/$file_name $filetype PATH ../1588/mentor/$file_name  {MENTOR_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/aldec/rtl/$file_name $filetype PATH ../1588/aldec/$file_name  {ALDEC_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/synopsys/rtl/$file_name $filetype PATH ../1588/synopsys/$file_name  {SYNOPSYS_SPECIFIC}
        }
        if {1} {
            add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/cadence/rtl/$file_name $filetype PATH ../1588/cadence/$file_name  {CADENCE_SPECIFIC}
        }
    }
    
    foreach {files_to type files_from} $compilation_or_sim {
        add_fileset_file $variant/rtl/mac/altera_eth_10g_mac/sim/$files_to $type PATH $files_from 
    
    }

    # To-Do: need review as function arguments changed
#    mod_mac_terp ../example_design/$variant/rtl/mac $variant rtl/mac/altera_eth_10g_mac/sim altera_eth_10g_mac.v VERILOG    
    

}

