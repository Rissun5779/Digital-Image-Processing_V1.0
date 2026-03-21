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


#HLS Tcl Common - This is where we're eventually going to build up the common utilies for HLS IP cores. 
#Likely candidates include: 
#	Location of executable
#	Terping of header file
#	Exectuable Function Call

#Return the full path of the HLS executable
proc get_HLS_executable {} {
	return  [file join [get_hls_bindir] i++]
}

proc get_hls_cosim_debug_option {} {
   return "-ghdl"
}

proc get_hls_bindir {} {
    set_hls_env
    set hls_dir $::env(ALTERAOCLSDKROOT)
    return [file join $hls_dir bin]
}

proc set_hls_env {} {
   #expects QUARTUS_ROOTDIR to be set appropriately by the tool that call this
   #tcl file, which appears to be true at present. Set appropriately means
   #respecting any user QUARTUS_ROOTDIR_OVERRIDE and without the user having
   #to set QUARTUS_ROOTDIR
   #Also supports the HLS test environment (never present in any kind of ACDS
   #distribution)
   if { [info exists ::env(ACLTEST_ROOT)] } {
      set ::env(ALTERAOCLSDKROOT) $::env(ACLTEST_ROOT)
   } else {
   set ::env(ALTERAOCLSDKROOT) [file join $::env(QUARTUS_ROOTDIR) .. hls]
   }
}

proc get_hls_ip_compile_command { output_file_name device_family include_dir_list source_file_list \
                                  { use_fpc 0 } { clock_freq 0 } args } {
   lappend args {*}[list --simulator none]
   lappend args {*}[list -o $output_file_name]
   lappend args -march=$device_family
   if { $use_fpc } {
      lappend args --fpc
   }
   if { $clock_freq != 0 } {
      lappend args {*}[list --clock $clock_freq]
   }
   foreach dir $include_dir_list {
      lappend args -I$dir
   }
   return [list [get_HLS_executable] {*}$args {*}$source_file_list]
}

proc is_s10_or_a10 { family } {
   return [expr ([string match -nocase arria*10 $family] || [string match -nocase stratix*10 $family] ) ]
}

