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
source pio_ed_parameters.tcl
source pio_ed_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME pio_ed
set_module_property DESCRIPTION "Simple PIO Example Design for Data width of 64 or 128."
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "64b or 128b PIO AVST "
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
set_module_property SUPPORTED_DEVICE_FAMILIES {"Arria 10"}

add_parameter INTENDED_DEVICE_FAMILY String "Arria 10"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER FALSE
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE

# # +---------------------------------------------
# # | QIP Message suppression for design example
#   |
 set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 12110 -entity pio_ed
 set_instance_assignment -name MESSAGE_DISABLE 10230 -entity pio_ed
 set_instance_assignment -name MESSAGE_DISABLE 10036 -entity pio_ed
 set_instance_assignment -name MESSAGE_DISABLE 10030 -entity pio_ed
 set_instance_assignment -name MESSAGE_DISABLE 10858 -entity pio_ed
 set_instance_assignment -name MESSAGE_DISABLE 276020 -entity pio_ed "}

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL pio_ed

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL pio_ed

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL pio_ed

# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {

   add_port_clk
   add_port_rst
   add_pcie_ast_rx_hip
   add_pcie_ast_bar_hip
   add_pcie_ast_tx_hip
   add_pcie_avmm_rxm
   add_port_hip_tlcfg
   add_port_hip_power_mgnt
   add_port_hip_currentspeed 

   
   add_port_hip_status
   add_port_hip_rst
   add_port_hip_txcredit
   
   add_port_hip_int_msi
   
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
   
      add_fileset_file pio_ed.sv                     SYSTEM_VERILOG PATH  pio_ed.sv 
      add_fileset_file pio_top.sv                    SYSTEM_VERILOG PATH  pio_top.sv              
      add_fileset_file pio_avst_to_mm.sv             SYSTEM_VERILOG PATH  pio_avst_to_mm.sv      
      add_fileset_file pio_mm_to_avst.sv             SYSTEM_VERILOG PATH  pio_mm_to_avst.sv
      add_fileset_file pio_ram_2port.sv              SYSTEM_VERILOG PATH  pio_ram_2port.sv   
      add_fileset_file pio_fifo.sv                   SYSTEM_VERILOG PATH  pio_fifo.sv      
      add_fileset_file pio_avmm_interface.sv         SYSTEM_VERILOG PATH  pio_avmm_interface.sv       
      add_fileset_file pio_avmm_interface_fifo.sv    SYSTEM_VERILOG PATH  pio_avmm_interface_fifo.sv  
      add_fileset_file pio_avmm_read_controller.sv   SYSTEM_VERILOG PATH  pio_avmm_read_controller.sv 
      add_fileset_file pio_avmm_write_controller.sv  SYSTEM_VERILOG PATH  pio_avmm_write_controller.sv
      add_fileset_file pio_tlp_parser.sv             SYSTEM_VERILOG PATH  pio_tlp_parser.sv           
   }                                                 

   proc proc_sim_vhdl {name} {
   
      add_fileset_file pio_ed.sv                     SYSTEM_VERILOG PATH  pio_ed.sv 
      add_fileset_file pio_top.sv                    SYSTEM_VERILOG PATH  pio_top.sv              
      add_fileset_file pio_avst_to_mm.sv             SYSTEM_VERILOG PATH  pio_avst_to_mm.sv      
      add_fileset_file pio_mm_to_avst.sv             SYSTEM_VERILOG PATH  pio_mm_to_avst.sv
      add_fileset_file pio_ram_2port.sv              SYSTEM_VERILOG PATH  pio_ram_2port.sv   
      add_fileset_file pio_fifo.sv                   SYSTEM_VERILOG PATH  pio_fifo.sv         
      add_fileset_file pio_avmm_interface.sv         SYSTEM_VERILOG PATH  pio_avmm_interface.sv       
      add_fileset_file pio_avmm_interface_fifo.sv    SYSTEM_VERILOG PATH  pio_avmm_interface_fifo.sv  
      add_fileset_file pio_avmm_read_controller.sv   SYSTEM_VERILOG PATH  pio_avmm_read_controller.sv 
      add_fileset_file pio_avmm_write_controller.sv  SYSTEM_VERILOG PATH  pio_avmm_write_controller.sv
      add_fileset_file pio_tlp_parser.sv             SYSTEM_VERILOG PATH  pio_tlp_parser.sv     

   }

   proc proc_sim_verilog {name} {
   
      add_fileset_file pio_ed.sv                     SYSTEM_VERILOG PATH  pio_ed.sv 
      add_fileset_file pio_top.sv                    SYSTEM_VERILOG PATH  pio_top.sv              
      add_fileset_file pio_avst_to_mm.sv             SYSTEM_VERILOG PATH  pio_avst_to_mm.sv      
      add_fileset_file pio_mm_to_avst.sv             SYSTEM_VERILOG PATH  pio_mm_to_avst.sv
      add_fileset_file pio_ram_2port.sv              SYSTEM_VERILOG PATH  pio_ram_2port.sv   
      add_fileset_file pio_fifo.sv                   SYSTEM_VERILOG PATH  pio_fifo.sv        
      add_fileset_file pio_avmm_interface.sv         SYSTEM_VERILOG PATH  pio_avmm_interface.sv       
      add_fileset_file pio_avmm_interface_fifo.sv    SYSTEM_VERILOG PATH  pio_avmm_interface_fifo.sv  
      add_fileset_file pio_avmm_read_controller.sv   SYSTEM_VERILOG PATH  pio_avmm_read_controller.sv 
      add_fileset_file pio_avmm_write_controller.sv  SYSTEM_VERILOG PATH  pio_avmm_write_controller.sv
      add_fileset_file pio_tlp_parser.sv             SYSTEM_VERILOG PATH  pio_tlp_parser.sv      

   }
