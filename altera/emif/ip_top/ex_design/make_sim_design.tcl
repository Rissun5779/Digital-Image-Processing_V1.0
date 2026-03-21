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

proc error_and_exit {msg} {
   post_message -type error "SCRIPT_ABORTED!!!"
   foreach line [split $msg "\n"] {
      post_message -type error $line
   }
   qexit -error
}

proc show_usage_and_exit {argv0} {
   post_message -type error  "USAGE: $argv0 \[VERILOG|VHDL\]"
   qexit -error
}

set argv0 "quartus_sh -t [info script]"
set args $quartus(args)

if {[llength $args] == 1 } {
   set lang [string toupper [string trim [lindex $args 0]]]
   if {$lang != "VERILOG" && $lang != "VHDL"} {
      show_usage_and_exit $argv0
   }
} else {
   set lang "VERILOG"
}

if {[llength $args] > 1} {
   show_usage_and_exit $argv0
}

if {[is_project_open]} {
   post_message "Closing currently opened project..."
   project_close
}

set script_path [file dirname [file normalize [info script]]]

source "$script_path/params.tcl"

set ex_design_path         "$script_path/sim"
set system_name            $ed_params(SIM_QSYS_NAME)
set qsys_file              "${system_name}.qsys"
set family                 $ip_params(SYS_INFO_DEVICE_FAMILY)
set device                 $ed_params(DEFAULT_DEVICE)

post_message " "
post_message "*************************************************************************"
post_message "Altera External Memory Interface IP Example Design Builder"
post_message " "
post_message "Type    : Simulation Design"
post_message "Family  : $family"
post_message "Language: $lang"
post_message " "
post_message "This script takes ~1 minute to execute..."
post_message "*************************************************************************"
post_message " "

if {!$ip_params(MEM_HAS_SIM_SUPPORT)} {
   error_and_exit "Simulation for this memory interface configuration is not supported by the current IP version."
}

if {[file isdirectory $ex_design_path]} {
   error_and_exit "Directory $ex_design_path has already been generated.\nThis script cannot overwrite generated example designs.\nIf you would like to regenerate the design by re-running the script, please remove the directory."
}

file mkdir $ex_design_path
file copy -force "${script_path}/$qsys_file" "${ex_design_path}/$qsys_file"

if {$pro_edition} {
   file mkdir "${ex_design_path}/ip"
   file copy -force "${script_path}/ip/${system_name}" "${ex_design_path}/ip/."
}

if {[file exists "${script_path}/quartus.ini"]} {
   file copy -force "${script_path}/quartus.ini" "${ex_design_path}/quartus.ini"
}

post_message "Generating example design files..."

set qsys_generate_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate"
set ip_make_simscript_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/ip-make-simscript"

cd $ex_design_path
if {$pro_edition} {
   exec -ignorestderr $qsys_generate_exe_path $qsys_file --pro --simulation=$lang --family=$family --part=$device >>& ip_generate.out
} else {
   exec -ignorestderr $qsys_generate_exe_path $qsys_file --simulation=$lang --output-directory=. --family=$family --part=$device >>& ip_generate.out
}
file delete -force ip_generate.out
file delete -force "${ex_design_path}/ed_sim/sim/synopsys"
file delete -force "${ex_design_path}/ed_sim/sim/cadence"
file delete -force "${ex_design_path}/ed_sim/sim/aldec"
file delete -force "${ex_design_path}/ed_sim/sim/mentor"

cd $system_name
set spd_file_list [ls_recursive "${ex_design_path}/ip/" "*.spd"]
lappend spd_file_list "$system_name.spd"
set spd_files [join $spd_file_list ","]
exec -ignorestderr $ip_make_simscript_exe_path --use-relative-paths --spd=$spd_files >>& make_simscript.out
file delete -force make_simscript.out

post_message "Finalizing..."

set sim_scripts [list]
set vcs_script "${ex_design_path}/ed_sim/synopsys/vcs/vcs_setup.sh"
if {$lang == "VERILOG"} {
   lappend sim_scripts $vcs_script
}
lappend sim_scripts "${ex_design_path}/ed_sim/synopsys/vcsmx/vcsmx_setup.sh"
lappend sim_scripts "${ex_design_path}/ed_sim/cadence/ncsim_setup.sh"

foreach sim_script $sim_scripts {
   set fh [open $sim_script r]
   set file_data [read $fh]
   close $fh

   set fh [open $sim_script w]
   foreach line [split $file_data "\n"] {
      if {[regexp -- {USER_DEFINED_SIM_OPTIONS\s*=.*\+vcs\+finish\+100} $line]} {
         regsub -- {\+vcs\+finish\+100} $line {} line
      }
      if {[regexp -- {USER_DEFINED_SIM_OPTIONS\s*=.*\-input \\\"\@run 100; exit\\\"} $line]} {
         regsub -- {\-input \\\"\@run 100; exit\\\"} $line {} line
      }
      if {$sim_script == $vcs_script && [regexp -- {TOP_LEVEL_NAME\s*=.*} $line]} {
         set line "TOP_LEVEL_NAME=\"${system_name}\""
      }
      puts $fh $line
   }
   close $fh
}

post_message " "
post_message "*************************************************************************"
post_message "Successfully generated example design at the following location:"
post_message " "
post_message "   $ex_design_path"
post_message " "
post_message "*************************************************************************"
post_message " "
