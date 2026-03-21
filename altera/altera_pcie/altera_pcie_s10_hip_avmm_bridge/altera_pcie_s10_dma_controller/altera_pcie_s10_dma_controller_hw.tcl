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


package require -exact qsys 15.1

#sopc::preview_add_transform name preview_avalon_mm_transform
source altera_pcie_s10_dma_controller_parameters.tcl
source altera_pcie_s10_dma_controller_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_s10_dma_controller
set_module_property DESCRIPTION "DMA Controller Block for Altera PCIE S10 AVMM Bridge"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "S10 PCIE DMA CONTROLLER"
set_module_property ELABORATION_CALLBACK elaboration_callback

# # +-----------------------------------
# # | Component Properties
#   |
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property instantiateInSystemModule "true"
set_module_property HIDE_FROM_QUARTUS false
set_module_property HIDE_FROM_QSYS false
set_module_property INTERNAL false
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix 10"}

add_parameter INTENDED_DEVICE_FAMILY String "Stratix 10"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER FALSE
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE

# # +---------------------------------------------
# # | QIP Message suppression for design example
#   |
# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altera_pcie_s10_dma_controller_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altera_pcie_s10_dma_controller_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altera_pcie_s10_dma_controller_hwtcl

# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {

# Parameter update

# Port updates
add_port_clk
add_port_rst
add_port_hip_msiintfc

add_pcie_avmm_readdcslave
add_pcie_avmm_avmm_readdcmaster
add_pcie_avmm_readdtslave
add_pcie_rd_ast_tx
add_pcie_rd_ast_rx

add_pcie_avmm_writedcslave
add_pcie_avmm_avmm_writedcmaster
add_pcie_avmm_writedtslave
add_pcie_wr_ast_tx
add_pcie_wr_ast_rx

}

#+-----------------------------------
#| parameters
#|
add_parameters_ui_system_settings

   # +-----------------------------------
   # | Static IO
   # |



   # ************** Global Variables ***************
   # set not_init "default"
   # **************** Parameters *******************


   proc proc_quartus_synth {name} {
      global QUARTUS_ROOTDIR

      add_fileset_file altera_pcie_s10_dynamic_control.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dynamic_control.sv
      add_fileset_file altera_pcie_s10_dma_controller.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller.sv
      add_fileset_file altera_pcie_s10_dma_controller_hwtcl.sv  SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller_hwtcl.sv

   }

   proc proc_sim_vhdl {name} {
      global QUARTUS_ROOTDIR

      add_fileset_file altera_pcie_s10_dynamic_control.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dynamic_control.sv
      add_fileset_file altera_pcie_s10_dma_controller.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller.sv
      add_fileset_file altera_pcie_s10_dma_controller_hwtcl.sv  SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller_hwtcl.sv

   }

   proc proc_sim_verilog {name} {
      global QUARTUS_ROOTDIR

      add_fileset_file altera_pcie_s10_dynamic_control.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dynamic_control.sv
      add_fileset_file altera_pcie_s10_dma_controller.sv        SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller.sv
      add_fileset_file altera_pcie_s10_dma_controller_hwtcl.sv  SYSTEM_VERILOG PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/altera_pcie_s10_dma_controller_hwtcl.sv

   }
