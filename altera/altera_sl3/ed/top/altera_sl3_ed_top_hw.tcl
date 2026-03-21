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


add_fileset example_design EXAMPLE_DESIGN designexampleproc

source ../../ed/ed_sim/scripts/altera_sl3_ed_sim_hw.tcl
source ../../ed/ed_synth/scripts/altera_sl3_ed_synth_hw.tcl

proc designexampleproc {name} {
    set synthesis [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS]
    set simulation [get_parameter_value ENABLE_ED_FILESET_SIM]
	
	if {$synthesis} {
       ed_synth 
	}
	
	if {$simulation} {
       ed_sim
    }
	
	if {$simulation == 0 && $synthesis == 0} {
          send_message error "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Files Types Generated\" are selected to allow generation of Example Design Files."
       } else {
          send_message INFO "Adding example design"
       }
    
}
