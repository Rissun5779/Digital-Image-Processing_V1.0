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


package provide altera_emif::util::hwtcl_debug 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini


namespace eval ::altera_emif::util::hwtcl_debug:: {
   
   
   namespace import ::altera_emif::util::messaging::*
   
}



proc ::altera_emif::util::hwtcl_debug::_init {} {

   return 1
}


::altera_emif::util::hwtcl_debug::_init
