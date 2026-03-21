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
source ast2avmm_bridge_256_parameters.tcl
source ast2avmm_bridge_256_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME ast2avmm_bridge_256
set_module_property DESCRIPTION "256 Bits AST to AVMM Bridge with Burst RX Master, TX Slave and CRA Interfaces"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "256 Bits AST2AVMM Bridge"
set_module_property ELABORATION_CALLBACK elaboration_callback

# # +-----------------------------------
# # | Component Properties
#   |
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property instantiateInSystemModule "true"
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Arria 10"}

add_parameter INTENDED_DEVICE_FAMILY String "Arria 10"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER FALSE
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE

# # +---------------------------------------------
# # | QIP Message suppression for design example
#   |
set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 12110 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10230 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 13410 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 12677 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 15610 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10036 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 12241 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10858 -entity ast2avmm_bridge_256_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 287001 -entity ast2avmm_bridge_256_hwtcl   "}

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL ast2avmm_bridge_256_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL ast2avmm_bridge_256_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL ast2avmm_bridge_256_hwtcl

# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {
  set show_sriov [ get_parameter_value SRIOV_EN]
  set cstm_features [ get_parameter CUSTOM_FEATURE]
# Parameter update
   validation_parameter_bar
   if ($show_sriov) {
     validation_total_vf_count
   }
# Port updates
   set show_cra [ get_parameter_value ENABLE_CRA]
   set show_txs [ get_parameter_value ENABLE_TXS]
   add_port_clk
   add_port_rst
   add_pcie_ast_rx_hip
   add_pcie_ast_bar_hip
   add_pcie_ast_tx_hip
   add_pcie_avmm_rxm
   if ($show_txs) {
   add_pcie_avmm_txs
   }
   if ($show_cra) {
   add_pcie_avmm_cra
   }
   if ($show_sriov) {
     add_pcie_ast_sideband_tx_app
     add_pcie_ast_sideband_rx_app
     add_pcie_cfg_status
     add_pcie_sriov_lmiapp
     add_pcie_config_tl
     add_pcie_sriov_flr
     if ($cstm_features) {
       add_extra_bar
       add_dev_hide
       add_dev_iep
       add_test_ebar
	 }
   } else {
   add_port_hip_tlcfg
   add_port_hip_power_mgnt
   add_port_hip_currentspeed 
   }
   
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
      global QUARTUS_ROOTDIR

      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav128_clksync.v               VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_cr_avalon.v             VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v          VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cfg_status.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_control_register.v
      add_fileset_file ast2avmm_bridge_256_hwtcl.sv           SYSTEM_VERILOG PATH ast2avmm_bridge_256_hwtcl.sv

   }

   proc proc_sim_vhdl {name} {
      global QUARTUS_ROOTDIR

      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav128_clksync.v               VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_cr_avalon.v             VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v          VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cfg_status.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_control_register.v
      add_fileset_file ast2avmm_bridge_256_hwtcl.sv           SYSTEM_VERILOG PATH ast2avmm_bridge_256_hwtcl.sv

   }

   proc proc_sim_verilog {name} {
      global QUARTUS_ROOTDIR

      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav128_clksync.v               VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_cr_avalon.v             VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v          VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cfg_status.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v            VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/rp_avmm_256/rtl/altpcie_256_control_register.v
      add_fileset_file ast2avmm_bridge_256_hwtcl.sv           SYSTEM_VERILOG PATH ast2avmm_bridge_256_hwtcl.sv

   }
