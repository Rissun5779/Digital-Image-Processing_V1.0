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
package require -exact qsys 13.1
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################


##########################
# module altera_vid
##########################
set_module_property NAME altera_vid
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "SmartVID Controller IP"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Low Power"
set_module_property DISPLAY_NAME "SmartVID Controller IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Arria 10"}
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_smartvid.pdf"

########################
# Declare the callbacks
######################## 
set_module_property ELABORATION_CALLBACK validate

########################
# Add fileset
########################
add_fileset synth2 QUARTUS_SYNTH synthproc
add_fileset sim_verilog SIM_VERILOG verilogsimproc
add_fileset sim_vhdl SIM_VHDL vhdlsimproc

set_fileset_property synth2 TOP_LEVEL altera_vid_ctl_wrapper
set_fileset_property sim_verilog TOP_LEVEL altera_vid_ctl_wrapper
set_fileset_property sim_vhdl TOP_LEVEL altera_vid_ctl_wrapper


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
# +---------------------------------------------
# | add display tabs
# |
add_display_item "" "General" GROUP 
add_display_item "" "AVS" GROUP 

source parameters.tcl
declare_parameters

#############################################################
#                  Validation Callback
#############################################################
# +-----------------------------------
# | Validation
# | 
proc validate {} {
  validate_parameter
  validate_connections
}

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
source interfaces.tcl
add_connection

#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------
global env
proc common_fileset {language gensim simulator} {
	global env
	set qdir $env(QUARTUS_ROOTDIR)
	set topdir "${qdir}/../ip/altera/altera_vid/tcl"
	set tmpdir "${qdir}/../ip/altera/altera_vid/vid_ctl"
	
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
       set simulator_specific "SYNTHESIS"
   } 

    # Top level - verilog file
    add_fileset_file ${simulator_path}/altera_vid_ctl_wrapper.v        $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_wrapper.v    $simulator_specific     
    
    # source files for jesd204 rx     
    add_fileset_file ${simulator_path}/altera_vid_ctl_csr.v            $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_csr.v         $simulator_specific     
    add_fileset_file ${simulator_path}/altera_vid_ctl_csr_core.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_csr_core.v    $simulator_specific     
    add_fileset_file ${simulator_path}/altera_vid_ctl_fuse.v           $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_fuse.v        $simulator_specific
    add_fileset_file ${simulator_path}/altera_vid_ctl_temp.v           $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_temp.v        $simulator_specific        
    add_fileset_file ${simulator_path}/altera_vid_ctl_tmgr.v           $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_tmgr.v        $simulator_specific
    add_fileset_file ${simulator_path}/altera_vid_ctl_vid.v            $filekind PATH ${tmpdir}/${simulator_path}/altera_vid_ctl_vid.v         $simulator_specific
  
    # Add SDC and OCP files for Synthesis
    #-----------------------------------
    # Terp for SDC file
    #-----------------------------------
    


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


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/vgo1411127252655/vgo1411127508220
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697970212 
