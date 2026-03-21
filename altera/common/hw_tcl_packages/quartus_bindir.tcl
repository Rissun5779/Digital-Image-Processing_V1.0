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


# +--------------------------------------------------------------------------
# |
# | Name: quartus_bindir.tcl
# |
# |
# | Description: This packages allows tha calculation of quartus binaries of the
# |              current Tcl interp to be run from a _hw.tcl script. 
# |
# |
# |
# | Version:    1.0
# |
# | Author:     Yadan Mu
# |
# |
# |
# |
# +---------------------------------------------------------------------------
package provide quartus_bindir  1.0


namespace eval quartus_bindir {

    namespace export quartus_bindir

    proc quartus_bindir {} {
        
        set platform    $::tcl_platform(platform)
        if {$platform eq "java"} {
            set platform    $::tcl_platform(host_platform)
        }

        set quartus_bindir  $::quartus(binpath)
        if {$quartus_bindir ne ""} {
            if {$platform eq "windows"} {
                set bindir_name "bin"
            } else {
                set bindir_name "linux"
            }
        }
        set pointer_size    $::tcl_platform(pointerSize)
        set machine         $::tcl_platform(machine)
        if {$pointer_size} {
            if {[string match "*64" $machine]} {
                set pointer_size    8
            } else {
                set pointer_size    4
            }
        }
        if {$pointer_size==8} {
            set bindir_name "${bindir_name}64"
        }
        set quartus_bindir  "$::env(QUARTUS_ROOTDIR)/$bindir_name/"
        send_message    debug   "Current quartus bindir: $quartus_bindir."
        return $quartus_bindir
    }

}
