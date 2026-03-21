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


# $Id: //acds/rel/18.1std/ip/merlin/lib/terp.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

# ----------------------------------------------------
# Terp
#
# Proprietary TCL-based templating scheme. Only for
# Merlin component usage; backwards compatibility is
# unlikely. Use at your own peril.
# ----------------------------------------------------

# ----------------------------------------------------
# Replaces all instances of $parameters in the template
# with their actual value.
#
# Also executes each line preceded with @@ as a tcl 
# command.
#
# Do NOT, under any circumstances, use the variable
# terp_out in the template.
#
# Arguments:
# template      : template string 
# parameters    : hash of parameter name-value pairs
#
# Return: string
# ----------------------------------------------------
proc terp { template parameters } {
    puts stderr "I see you've tried to use a file which we've moved."
    puts stderr "Naughty Naughty.... Instead try changing your _hw.tcl file such that"
    puts stderr "you include the line \n\n package require -exact altera_terp 1.0 \n\n\n"
    puts stderr "and then change your terp call to altera_terp"
    puts stderr "if you really really must have the location of the file because you dont use Qsys/Sopc Builder"
    puts stderr "it's at ip/common/hw_tcl_packages/altera_terp.tcl"
    puts stderr "Questions? => bgordon@altera.com"

    return ""
}

