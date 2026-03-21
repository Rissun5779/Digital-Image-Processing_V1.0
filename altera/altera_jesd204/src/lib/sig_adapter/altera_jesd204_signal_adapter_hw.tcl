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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 16.0

#########################################
### Source required procs
#########################################
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204_signal_adapter
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B Signal Adapter"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B Signal Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true

########################
# Declare the callbacks
######################## 
set_module_property ELABORATION_CALLBACK my_elaboration_callback

########################
# Add fileset
########################
add_fileset synth2 QUARTUS_SYNTH synthproc
add_fileset sim_verilog SIM_VERILOG verilogsimproc
add_fileset sim_vhdl SIM_VHDL vhdlsimproc

set_fileset_property synth2 TOP_LEVEL altera_jesd204_signal_adapter
set_fileset_property sim_verilog TOP_LEVEL altera_jesd204_signal_adapter
set_fileset_property sim_vhdl TOP_LEVEL altera_jesd204_signal_adapter


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------

add_parameter "MODE" STRING "direct"
set_parameter_property "MODE" DEFAULT_VALUE "direct"
set_parameter_property "MODE" DISPLAY_NAME "Signal Adapter Mode"
set_parameter_property "MODE" TYPE STRING
set_parameter_property "MODE" UNITS None
set_parameter_property "MODE" ALLOWED_RANGES {"direct" "bit_multiple" "bus_to_bit" "invert_output" "and_gate" "concatenate" "split" "terminate"}
set_parameter_property "MODE" HDL_PARAMETER true
set_parameter_property "MODE" AFFECTS_GENERATION false
set_parameter_property "MODE" AFFECTS_ELABORATION true
set_parameter_property "MODE" AFFECTS_VALIDATION false


add_parameter "INTERFACE_TYPE" STRING "conduit"
set_parameter_property "INTERFACE_TYPE" DEFAULT_VALUE "conduit"
set_parameter_property "INTERFACE_TYPE" DISPLAY_NAME "Interface Type"
set_parameter_property "INTERFACE_TYPE" TYPE STRING
set_parameter_property "INTERFACE_TYPE" UNITS None
set_parameter_property "INTERFACE_TYPE" HDL_PARAMETER false
set_parameter_property "INTERFACE_TYPE" AFFECTS_GENERATION true
set_parameter_property "INTERFACE_TYPE" AFFECTS_ELABORATION true
set_parameter_property "INTERFACE_TYPE" AFFECTS_VALIDATION false


add_parameter "FROM_SIG_TYPE" STRING "export"
set_parameter_property "FROM_SIG_TYPE" DEFAULT_VALUE "export"
set_parameter_property "FROM_SIG_TYPE" DISPLAY_NAME "From Signal Type"
set_parameter_property "FROM_SIG_TYPE" TYPE STRING
set_parameter_property "FROM_SIG_TYPE" UNITS None
set_parameter_property "FROM_SIG_TYPE" HDL_PARAMETER false
set_parameter_property "FROM_SIG_TYPE" AFFECTS_GENERATION true
set_parameter_property "FROM_SIG_TYPE" AFFECTS_ELABORATION true
set_parameter_property "FROM_SIG_TYPE" AFFECTS_VALIDATION false

add_parameter "TO_SIG_TYPE" STRING "export"
set_parameter_property "TO_SIG_TYPE" DEFAULT_VALUE "export"
set_parameter_property "TO_SIG_TYPE" DISPLAY_NAME "To Signal Type"
set_parameter_property "TO_SIG_TYPE" TYPE STRING
set_parameter_property "TO_SIG_TYPE" UNITS None
set_parameter_property "TO_SIG_TYPE" HDL_PARAMETER false
set_parameter_property "TO_SIG_TYPE" AFFECTS_GENERATION true
set_parameter_property "TO_SIG_TYPE" AFFECTS_ELABORATION true
set_parameter_property "TO_SIG_TYPE" AFFECTS_VALIDATION false


add_parameter "IN_WIDTH_0" INTEGER 1
set_parameter_property "IN_WIDTH_0" DEFAULT_VALUE 1
set_parameter_property "IN_WIDTH_0" DISPLAY_NAME "Signal input Width"
set_parameter_property "IN_WIDTH_0" TYPE INTEGER
set_parameter_property "IN_WIDTH_0" UNITS None
set_parameter_property "IN_WIDTH_0" ALLOWED_RANGES 1:99
set_parameter_property "IN_WIDTH_0" HDL_PARAMETER true
set_parameter_property "IN_WIDTH_0" AFFECTS_GENERATION false
set_parameter_property "IN_WIDTH_0" AFFECTS_ELABORATION true
set_parameter_property "IN_WIDTH_0" AFFECTS_VALIDATION false

add_parameter "IN_WIDTH_1" INTEGER 1
set_parameter_property "IN_WIDTH_1" DEFAULT_VALUE 1
set_parameter_property "IN_WIDTH_1" DISPLAY_NAME "Signal input Width"
set_parameter_property "IN_WIDTH_1" TYPE INTEGER
set_parameter_property "IN_WIDTH_1" UNITS None
set_parameter_property "IN_WIDTH_1" ALLOWED_RANGES 1:99
set_parameter_property "IN_WIDTH_1" HDL_PARAMETER true
set_parameter_property "IN_WIDTH_1" AFFECTS_GENERATION false
set_parameter_property "IN_WIDTH_1" AFFECTS_ELABORATION true
set_parameter_property "IN_WIDTH_1" AFFECTS_VALIDATION false

add_parameter "OUT_WIDTH" INTEGER 1
set_parameter_property "OUT_WIDTH" DEFAULT_VALUE 1
set_parameter_property "OUT_WIDTH" DISPLAY_NAME "Signal output Width"
set_parameter_property "OUT_WIDTH" TYPE INTEGER
set_parameter_property "OUT_WIDTH" UNITS None
set_parameter_property "OUT_WIDTH" ALLOWED_RANGES 1:3000
set_parameter_property "OUT_WIDTH" HDL_PARAMETER true
set_parameter_property "OUT_WIDTH" AFFECTS_GENERATION false
set_parameter_property "OUT_WIDTH" AFFECTS_ELABORATION true
set_parameter_property "OUT_WIDTH" AFFECTS_VALIDATION false

add_parameter "BIT_MULTIPLIER" INTEGER 1
set_parameter_property "BIT_MULTIPLIER" DEFAULT_VALUE 1
set_parameter_property "BIT_MULTIPLIER" DISPLAY_NAME "Bit Multiplier"
set_parameter_property "BIT_MULTIPLIER" TYPE INTEGER
set_parameter_property "BIT_MULTIPLIER" UNITS None
set_parameter_property "BIT_MULTIPLIER" ALLOWED_RANGES 1:99
set_parameter_property "BIT_MULTIPLIER" HDL_PARAMETER true
set_parameter_property "BIT_MULTIPLIER" AFFECTS_GENERATION false
set_parameter_property "BIT_MULTIPLIER" AFFECTS_ELABORATION true
set_parameter_property "BIT_MULTIPLIER" AFFECTS_VALIDATION false



#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------

proc my_elaboration_callback {} {
   set in_width_0  [get_parameter_value "IN_WIDTH_0"]
   set in_width_1  [get_parameter_value "IN_WIDTH_1"]
   set out_width [get_parameter_value "OUT_WIDTH"]
   # common_add_optional_conduit { port_name signal_type port_dir width vhdl_type used terminate }
   if {[param_matches INTERFACE_TYPE "conduit"]} {
      common_add_optional_conduit sig_in_0  [get_parameter_value "FROM_SIG_TYPE"] input  $in_width_0  vector true [expr { [param_matches MODE "terminate"]}]
      common_add_optional_conduit sig_in_1  [get_parameter_value "FROM_SIG_TYPE"] input  $in_width_1  vector true [expr { ![param_matches MODE "and_gate"] && ![param_matches MODE "concatenate"]}]
      common_add_optional_conduit sig_out   [get_parameter_value "TO_SIG_TYPE"]   output $out_width   vector true 0
      common_add_optional_conduit sig_out_1 [get_parameter_value "TO_SIG_TYPE"]   output $out_width   vector true [expr { ![param_matches MODE "split"]}]

   } elseif {[param_matches INTERFACE_TYPE "hssi_bonded_clock"]} {
      common_add_clock sig_in_0  [get_parameter_value "INTERFACE_TYPE"]  input  $in_width_0  vector true [expr { [param_matches MODE "terminate"]}]
      common_add_clock sig_in_1  [get_parameter_value "INTERFACE_TYPE"]  input  $in_width_1  vector true [expr { ![param_matches MODE "and_gate"] && ![param_matches MODE "concatenate"]}]
      common_add_clock sig_out   [get_parameter_value "INTERFACE_TYPE"]  output $out_width   vector true 0
      common_add_clock sig_out_1 [get_parameter_value "INTERFACE_TYPE"]  output $out_width   vector true [expr { ![param_matches MODE "split"]}]

   }  elseif {[param_matches INTERFACE_TYPE "hssi_serial_clock"]} {
      common_add_clock sig_in_0  [get_parameter_value "INTERFACE_TYPE"]  input  $in_width_0  vector true [expr { [param_matches MODE "terminate"]}]
      common_add_clock sig_in_1  [get_parameter_value "INTERFACE_TYPE"]  input  $in_width_1  vector true [expr { ![param_matches MODE "and_gate"] && ![param_matches MODE "concatenate"]}]
      common_add_clock sig_out   [get_parameter_value "INTERFACE_TYPE"]  output $out_width   vector true 0
      common_add_clock sig_out_1 [get_parameter_value "INTERFACE_TYPE"]  output $out_width   vector true [expr { ![param_matches MODE "split"]}]
   } 

}

#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------

proc common_fileset {language gensim simulator} {
	global env
	set qdir $env(QUARTUS_ROOTDIR)
	set topdir "${qdir}/../ip/altera/altera_jesd204/src/top"
	set tmpdir "."
	
   if {[string compare -nocase ${simulator} synopsys] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "synopsys"
       set simulator_specific "SYNOPSYS_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} mentor] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "mentor"
       set simulator_specific "MENTOR_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} cadence] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "cadence"
       set simulator_specific "CADENCE_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} aldec] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "aldec"
       set simulator_specific "ALDEC_SPECIFIC"
   } else { 
       #for synthesis
       set filekind "VERILOG"
       set filekind_systemverilog "SYSTEMVERILOG"
       set simulator_path "."
       set simulator_specific ""
   } 
   add_fileset_file ${simulator_path}/altera_jesd204_signal_adapter.v  $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_signal_adapter.v $simulator_specific    
}

#------------------------------------------------------------------------
# 4. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset "verilog" 0 synthesis
   
}

proc verilogsimproc {name} {

    if {1} {
    common_fileset "verilog" 1 mentor
    }
    if {1} {
    common_fileset "verilog" 1 synopsys
    }
    if {1} {
    common_fileset "verilog" 1 cadence
    }
    if {1} {
    common_fileset "verilog" 1 aldec
    }

}

proc vhdlsimproc {name} {
 
    if {1} {
    common_fileset "vhdl" 1 mentor
    }
    if {1} {
    common_fileset "vhdl" 1 synopsys
    }
    if {1} {
    common_fileset "vhdl" 1 cadence
    }
    if {1} {
    common_fileset "vhdl" 1 aldec
    }

 
} 
