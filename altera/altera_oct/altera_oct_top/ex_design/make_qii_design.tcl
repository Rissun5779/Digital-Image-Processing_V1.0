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



proc ls_recursive {base glob} {
   set files [list]

   foreach f [glob -nocomplain -types f -directory $base $glob] {
      set file_path [file join $base $f]
      lappend files $file_path
   }

   foreach d [glob -nocomplain -types d -directory $base *] {
      set files_recursive [ls_recursive [file join $base $d] $glob]
      lappend files {*}$files_recursive
   }

   return $files
}

proc get_relative_path {base path} {
   return [string trimleft [ string range $path [string length $base] [string length $path] ] "/"]
}

proc error_and_exit {msg} {
   post_message -type error "SCRIPT_ABORTED!!!"
   foreach line [split $msg "\n"] {
      post_message -type error $line
   }
   qexit -error
}

proc show_usage_and_exit {argv0} {
   post_message -type error  "USAGE: $argv0 \[device_name\]"
   qexit -error
}

set argv0 "quartus_sh -t [info script]"
set args $quartus(args)

if {[llength $args] == 1 } {
   set force_device [string toupper [string trim [lindex $args 0]]]
} else {
   set force_device ""
}

if {[llength $args] > 1} {
   show_usage_and_exit $argv0
}

set script_path [file dirname [file normalize [info script]]]

source "$script_path/params.tcl"

set ex_design_path         "$script_path/qii"
set system_name            $ed_params(SYNTH_QSYS_NAME)
set qsys_file              "${system_name}.qsys"
set family                 $device_family

if {$force_device == ""} {
   set device $ed_params(DEFAULT_DEVICE)
} else {
   set device $force_device
}

puts "\n"
puts "*************************************************************************"
puts "Altera OCT IP Example Design Builder                                    "
puts "                                                                         "
puts "Type  : Quartus Prime Project                                               "
puts "Family: $family"
puts "Device: $device" 
puts "                                                                         "
puts "This script takes ~1 minute to execute...                                "
puts "*************************************************************************"
puts "\n"

if {[file isdirectory $ex_design_path]} {
   error_and_exit "Directory $ex_design_path already exists.\nThis script does not overwrite an existing directory.\nRemove the directory before re-running the script."
}

file mkdir $ex_design_path
file copy -force "${script_path}/$qsys_file" "${ex_design_path}/$qsys_file"

if {$pro_edition} {
   file mkdir "${ex_design_path}/ip"
   file copy -force "${script_path}/ip/${system_name}" "${ex_design_path}/ip/."
}

puts "Generating example design files..."

set qsys_generate_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"

cd $ex_design_path
if {$pro_edition} {
   exec -ignorestderr $qsys_generate_exe_path $qsys_file --pro --synthesis --output-directory=. --family=$family --part=$device  >>& ip_generate.out
} else {
   exec -ignorestderr $qsys_generate_exe_path $qsys_file --synthesis --output-directory=. --family=$family --part=$device  >>& ip_generate.out
}

puts "Creating Quartus Prime project..."
project_new -family $family -part $device $system_name
set_global_assignment -name QSYS_FILE ${system_name}.qsys
if {$pro_edition} {
   foreach ip_file [ls_recursive "${ex_design_path}/ip" "*.ip"] {
      set ip_file [get_relative_path $ex_design_path $ip_file]
      set_global_assignment -name PBIP_FILE $ip_file
   }
}
set_instance_assignment -name IO_STANDARD "SSTL-15" -to ex_pad*
project_close 

puts "\n"
puts "*************************************************************************"
puts "Successfully generated example design at the following location:                                                    "
puts "                                                                         "
puts "   $ex_design_path                                                 "
puts "                                                                         "
puts "*************************************************************************"
puts "\n"
