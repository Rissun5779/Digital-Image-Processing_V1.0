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


#add_fileset example_design EXAMPLE_DESIGN designexampleproc

source ../example/ed_sim/scripts/seriallite_iii_ed_sim_hw.tcl
#source ../../ed/ed_synth/scripts/altera_sl3_ed_synth_hw.tcl
proc designexampleproc {name} {
    set enable_ed_sim [get_parameter_value ENABLE_ED_FILESET_SIM]
	
	
    if {$enable_ed_sim} {
       ed_sim
    }
	   #ed_synth
}
