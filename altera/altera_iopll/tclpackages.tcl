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


###############################################################################
## altera_iopll::util
###############################################################################
package ifneeded altera_iopll::util    14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll common altera_iopll_util.tcl]]


###############################################################################
## altera_iopll::mif
###############################################################################
package ifneeded altera_iopll::mif  14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll common altera_iopll_mif.tcl]]
#package ifneeded altera_iopll_reconfig::mif_validation 14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll_reconfig iopll_reconfig_hw.tcl]]
package ifneeded altera_iopll_reconfig::mif_validation 14.0 [list source [file join .. .. altera_iopll_reconfig iopll_reconfig_hw_mif_validation.tcl]]

###############################################################################
## altera_iopll::test
###############################################################################
package ifneeded altera_iopll::test    		14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll test altera_iopll_test.tcl]]
package ifneeded altera_iopll::test::util   14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll test altera_iopll_util_tests.tcl]]
package ifneeded altera_iopll::test::hwtcl  14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll test altera_iopll_hwtcl_tests.tcl]]
package ifneeded altera_iopll::update_callbacks   14.0 [list source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_iopll common altera_iopll_hw_update_callbacks.tcl]]
