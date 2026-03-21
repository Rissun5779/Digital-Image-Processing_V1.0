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


package require -exact qsys 14.1
sopc::preview_add_transform name preview_avalon_mm_transform
source pcie_mc_parameters.tcl
source pcie_mc_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)


# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_channelizer
set_module_property DESCRIPTION "PCI Express Channelizer"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "PCI Express Multi-Channel DMA Interface"
set_module_property ELABORATION_CALLBACK elaboration_callback

# # +-----------------------------------
# # | Global parameters
#   |
add_parameter INTENDED_DEVICE_FAMILY String "STRATIX V"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE
add_parameter pcie_qsys integer 1
set_parameter_property pcie_qsys VISIBLE false

# # +-----------------------------------
# # | Component Properties
#   |
set_module_property EDITABLE FALSE
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property instantiateInSystemModule "true"
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL false
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix V"}



 add_documentation_link "User guide" http://www.altera.com/literature/ug_s5_pcie_avmm_dma.pdf
 add_documentation_link "Release Notes:" http://www.altera.com/literature/rn/ip/#pcie_channelizer_revision.html

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altpcieav_mc_intf

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcieav_mc_intf

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcieav_mc_intf

add_pcie_mc_parameters


# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {

   # Port updates
   add_mc_channels
}




proc proc_quartus_synth {name} {
         add_fileset_file altpcieav_mc_intf.sv SYSTEM_VERILOG PATH        altpcieav_mc_intf.sv
         add_fileset_file altpcieav_mc_arb.sv SYSTEM_VERILOG PATH         altpcieav_mc_arb.sv
         add_fileset_file altpcieav_mc_frag.sv SYSTEM_VERILOG PATH        altpcieav_mc_frag.sv
         add_fileset_file altpcieav_mc_prior_queue.sv SYSTEM_VERILOG PATH altpcieav_mc_prior_queue.sv
         add_fileset_file altpcieav_mc_reg_slave.sv SYSTEM_VERILOG PATH   altpcieav_mc_reg_slave.sv
                       }

proc proc_sim_vhdl {name} {
   set verilog_file_common_rtl  {  "altpcieav_mc_intf.sv"
                                   "altpcieav_mc_arb.sv"
                                   "altpcieav_mc_frag.sv"
                                   "altpcieav_mc_prior_queue.sv"
                                   "altpcieav_mc_reg_slave.sv"
                                    }
   foreach vf $verilog_file_common_rtl {
       add_fileset_file mentor/${vf} VERILOG_ENCRYPT PATH "../channelizer/mentor/${vf}" {MENTOR_SPECIFIC}
       add_fileset_file aldec/${vf} VERILOG_ENCRYPT PATH "../channelizer/aldec/${vf}" {ALDEC_SPECIFIC}
       #add_fileset_file aldec/${vf} VERILOG_ENCRYPT PATH "aldec/${vf}" {ALDEC_SPECIFIC}
       if { 0 } {
          add_fileset_file cadence/${vf} VERILOG_ENCRYPT PATH "../channelizer/cadence/${vf}" {CADENCE_SPECIFIC}
       }
       if { 0 } {
          add_fileset_file synopsys/${vf} VERILOG_ENCRYPT PATH "../channelizer/synopsys/${vf}" {SYNOPSYS_SPECIFIC}
       }
   }

}

proc proc_sim_verilog {name} {

    set verilog_file {"altpcieav_mc_intf.sv"
                                   "altpcieav_mc_arb.sv"
                                   "altpcieav_mc_frag.sv"
                                   "altpcieav_mc_prior_queue.sv"
                                   "altpcieav_mc_reg_slave.sv"
                                    }
   foreach vf $verilog_file {
       add_fileset_file ${vf} VERILOG PATH ${vf}
   }
}

