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
source sriov_dma_256_avmm_parameters.tcl
source sriov_dma_256_avmm_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# +-----------------------------------
# altera_pcie_256_sriov_dma_avmm
#

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_sriov_dma_avmm
set_module_property DESCRIPTION "Example : Avalon-MM DMA for SR-IOV PCI Express"
set_module_property VERSION 18.1
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_s5_pcie_sriov.pdf"
set_module_property GROUP "Interface Protocols/PCI Express/Example Design Components"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "Example : Avalon-MM DMA for PCI Express SR-IOV"
set_module_property ELABORATION_CALLBACK elaboration_callback

# # +-----------------------------------
# # | Component Properties
#   |
set_module_property EDITABLE false
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property instantiateInSystemModule "true"
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix V" "Arria V GZ" "Arria 10"}

# # +-----------------------------------
# # | Global parameters
#   |
add_parameter pcie_qsys integer 1
set_parameter_property pcie_qsys VISIBLE false

# # +-----------------------------------
# # | Testbench files
#   |
# This is to tell the testbench generator "my_partner_name" is a "my_partner_type"
#set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_tbed
#set_module_assignment testbench.partner.pcie_tb.version 18.1
#set_module_assignment testbench.partner.map.refclk     pcie_tb.refclk
#set_module_assignment testbench.partner.map.hip_ctrl   pcie_tb.hip_ctrl
#set_module_assignment testbench.partner.map.npor       pcie_tb.npor
#set_module_assignment testbench.partner.map.hip_pipe   pcie_tb.hip_pipe
#set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altpcie_256_sriov_dma_avmm_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcie_256_sriov_dma_avmm_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcie_256_sriov_dma_avmm_hwtcl

# # +-----------------------------------
# # | Example QSYS Design
#   |
add_fileset example_design {EXAMPLE_DESIGN} example_design_proc

# # +-----------------------------------
# # | elaboration items
# # |


# +-----------------------------------
# | parameters
# |
add_pcie_hip_parameters_ui_system_settings
add_pcie_hip_parameters_bar_avmm
add_avalon_mm_parameters
add_pcie_hip_hidden_rtl_parameters

proc elaboration_callback { } {
   validation_total_vf_count
   validation_parameter_system_setting
   validation_parameter_prj_setting
   validation_parameter_pf0_bar
   validation_parameter_pf0_vf_bar

   # SRIOV
   add_ed_sriov_port_ast_rx
   add_ed_sriov_port_ast_tx
   add_ed_sriov_port_completion
   add_ed_sriov_port_cfgstatus
   add_ed_sriov_port_flr
   add_ed_sriov_port_status
   add_ed_sriov_port_interrupt
   add_ed_sriov_port_lmi
   add_ed_sriov_port_hip_misc

   # Port updates
   add_pcie_hip_port_avmm_txslave
   add_pcie_hip_port_avmm_cra
   add_pcie_hip_port_rd_ast
   add_pcie_hip_port_avmm_rd_master
   add_pcie_hip_port_wr_ast
   add_pcie_hip_port_avmm_wr_master
   add_pcie_hip_port_avmm_pf0_rxmaster
   add_pcie_hip_port_avmm_pf0_vf_rxmaster

   # Parameter updates
   set avmm_width_hwtcl [ get_parameter_value  avmm_width_hwtcl ]


  #===================================
  # Check RXM_BAR* span violations
   for { set i 0 } { $i < 6 } { incr i } {
      set rxm_span [get_parameter_value "SLAVE_ADDRESS_MAP_${i}"]
      set rxm_bar_size [get_parameter_value "PF0_BAR${i}_SIZE"]
      if { $rxm_span  >  $rxm_bar_size } {
        send_message error "PF0_BAR$i exceeds the bar size : PF0_BAR${i}_SIZE =  $rxm_bar_size -- Actual PF0_RXM_SPAN = $rxm_span"
      }
   }

  #===================================
  # Check for PF0_VF_RXM_BAR* span violations
   for { set i 0 } { $i < 6 } { incr i } {
      set vf_rxm_span [get_parameter_value "PF0_VF_RXM_ADDR_MAP${i}"]
      set vf_rxm_bar_size [get_parameter_value "PF0_VF_BAR${i}_SIZE"]
      set active_vfs [get_parameter_value "ACTIVE_VFS"]

      if { $vf_rxm_span  >  ( $active_vfs << $vf_rxm_bar_size ) } {
        send_message error "PF0_VF_BAR$i exceeds the bar size : PF0_VF_BAR${i}_SIZE =  $vf_rxm_bar_size -- Actual PF0_VF_RXM_SPAN = $vf_rxm_span"
      }
   }

  ## set mask bit for read DMA
  set rd_span [get_parameter_value "RD_SLAVE_ADDRESS_MAP"]
  set_parameter_value "rd_dma_size_mask_hwtcl" $rd_span

  ## set mask bit for read DMA
  set wr_span [get_parameter_value "WR_SLAVE_ADDRESS_MAP"]
  set_parameter_value "wr_dma_size_mask_hwtcl" $wr_span
}



# +-----------------------------------
# | Static IO
# |
add_interface no_connect conduit end
add_pcie_hip_port_clk_rst


# ************** Global Variables ***************
set not_init "default"
# **************** Parameters *******************


proc proc_quartus_synth {name} {
   global QUARTUS_ROOTDIR
   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]
   set INTENDED_DEVICE_FAMILY                         [ get_parameter_value INTENDED_DEVICE_FAMILY]

   if { ([string compare -nocase $INTENDED_DEVICE_FAMILY "Arria 10"] != 0) } {
      add_fileset_file altera_pci_express.sdc              SDC            PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/altera_pci_express.sdc
   }
   add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcie_sc_bitsync.v                VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_sc_bitsync.v
   add_fileset_file altpcie_reset_delay_sync.v          VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v
   add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_256_app.sv
   add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
   add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
   add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
   add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
   add_fileset_file altpcieav_sriov_vf_mux.sv           SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_sriov_vf_mux.sv
   add_fileset_file altpcieav_dma_wr.sv                 SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr.sv
   
   add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
   add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
   add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv
   add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
  
   add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
   add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
   add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_rdwr.sv
   add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_cpl.sv
   add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_txctrl.sv
   add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm.sv
   add_fileset_file dma_controller.sv                   SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/dynamic_controller/dma_controller.sv
   add_fileset_file altpcie_dynamic_control.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/dynamic_controller/altpcie_dynamic_control.sv
   add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
   add_fileset_file altpcie_256_sriov_dma_avmm_hwtcl.v  VERILOG PATH altpcie_256_sriov_dma_avmm_hwtcl.v
#   common_add_fileset_files { S5 ALL_HDL } { PLAIN }

}

proc proc_sim_vhdl {name} {
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]

     set verilog_file_common_rtl  {
                                   "altpcie_fifo.v"
                                   "altpcieav_dma_rxm.sv"
                                   "altpcieav_hip_interface.sv"
                                   "altpcieav_dma_txs.sv"
                                   "altpcieav_dma_rd.sv"
                                   "altpcieav_sriov_vf_mux.sv"
                                   "altpcieav_dma_wr.sv"
                                   "altpcieav_dma_wr_2.sv"        
                                   "altpcieav_dma_wr_readmem_2.sv"
                                   "altpcieav_dma_wr_wdalign_2.sv"
                                   "altpcieav_dma_wr_tlpgen_2.sv"                                 
                                   "altpcieav_arbiter.sv"
                                   "altpcieav_cra.sv"
                                   "altpcieav_dma_hprxm_rdwr.sv"
                                   "altpcieav_dma_hprxm_cpl.sv"
                                   "altpcieav_dma_hprxm_txctrl.sv"
                                   "altpcieav_dma_hprxm.sv"
                                   "dma_controller.sv"
                                   "altpcie_dynamic_control.sv"
                         }
  foreach vf $verilog_file_common_rtl {
      add_fileset_file mentor/${vf} VERILOG_ENCRYPT PATH "mentor/${vf}" {MENTOR_SPECIFIC}
      add_fileset_file aldec/${vf} VERILOG_ENCRYPT PATH "aldec/${vf}" {ALDEC_SPECIFIC}
      if { 0 } {
         add_fileset_file cadence/${vf} VERILOG_ENCRYPT PATH "cadence/${vf}" {CADENCE_SPECIFIC}
      }
      if { 0 } {
         add_fileset_file synopsys/${vf} VERILOG_ENCRYPT PATH "synopsys/${vf}" {SYNOPSYS_SPECIFIC}
      }
   }

   add_fileset_file altpcie_256_sriov_dma_avmm_hwtcl.v   VERILOG PATH  altpcie_256_sriov_dma_avmm_hwtcl.v
   add_fileset_file altpcierd_hip_rs.v                   VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcie_sc_bitsync.v                 VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_sc_bitsync.v
   add_fileset_file altpcie_reset_delay_sync.v           VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v

   if { $dev_family == "Stratix V" } {
      # The following files are needed for Gen3 RP BFM. These files are listed in altera_pcie_hip_ast_ed_hw.tcl
      add_fileset_file altpcied_sv_hwtcl.sv          SYSTEMVERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/altpcied_sv_hwtcl.sv
      add_fileset_file altpcierd_tl_cfg_sample.v           VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v
      add_fileset_file altpcierd_cdma_app_icm.v            VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_app_icm.v
      add_fileset_file altpcierd_cdma_ast_msi.v            VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_msi.v
      add_fileset_file altpcierd_cdma_ast_rx.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx.v
      add_fileset_file altpcierd_cdma_ast_rx_128.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_128.v
      add_fileset_file altpcierd_cdma_ast_rx_64.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_64.v
      add_fileset_file altpcierd_cdma_ast_tx.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx.v
      add_fileset_file altpcierd_cdma_ast_tx_128.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_128.v
      add_fileset_file altpcierd_cdma_ast_tx_64.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_64.v
      add_fileset_file altpcierd_compliance_test.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_compliance_test.v
      add_fileset_file altpcierd_cpld_rx_buffer.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cpld_rx_buffer.v
      add_fileset_file altpcierd_cplerr_lmi.v              VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v
      add_fileset_file altpcierd_dma_descriptor.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_descriptor.v
      add_fileset_file altpcierd_dma_dt.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_dt.v
      add_fileset_file altpcierd_dma_prg_reg.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_prg_reg.v
      add_fileset_file altpcierd_example_app_chaining.v    VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_example_app_chaining.v
      add_fileset_file altpcierd_npcred_monitor.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_npcred_monitor.v
      add_fileset_file altpcierd_pcie_reconfig_initiator.v VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_pcie_reconfig_initiator.v
      add_fileset_file altpcierd_rc_slave.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_rc_slave.v
      add_fileset_file altpcierd_read_dma_requester.v      VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_read_dma_requester.v
      add_fileset_file altpcierd_read_dma_requester_128.v  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_read_dma_requester_128.v
      add_fileset_file altpcierd_reconfig_clk_pll.v        VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_reconfig_clk_pll.v
      add_fileset_file altpcierd_reg_access.v              VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_reg_access.v
      add_fileset_file altpcierd_rxtx_downstream_intf.v    VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_rxtx_downstream_intf.v
      add_fileset_file altpcierd_write_dma_requester.v     VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_write_dma_requester.v
      add_fileset_file altpcierd_write_dma_requester_128.v VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_write_dma_requester_128.v

   }
      # common_add_fileset_files { S5 ALL_HDL } { PLAIN MENTOR}
}

proc proc_sim_verilog {name} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]

   add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_256_app.sv
   add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
   add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
   add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
   add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
   add_fileset_file altpcieav_sriov_vf_mux.sv           SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_sriov_vf_mux.sv
   add_fileset_file altpcieav_dma_wr.sv                 SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr.sv

   add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
   add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
   add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv
   add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
   
   add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
   add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
   add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
   add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_rdwr.sv
   add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_cpl.sv
   add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_txctrl.sv
   add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm.sv
   add_fileset_file dma_controller.sv                   SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/dynamic_controller/dma_controller.sv
   add_fileset_file altpcie_dynamic_control.sv          SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/dynamic_controller/altpcie_dynamic_control.sv


   add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
   add_fileset_file altpcie_256_sriov_dma_avmm_hwtcl.v  VERILOG PATH altpcie_256_sriov_dma_avmm_hwtcl.v
   add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcie_sc_bitsync.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_sc_bitsync.v
   add_fileset_file altpcie_reset_delay_sync.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v

   if { $dev_family == "Stratix V" } {
      # The following files are needed for Gen3 RP BFM. These files are listed in altera_pcie_hip_ast_ed_hw.tcl
      add_fileset_file altpcied_sv_hwtcl.sv          SYSTEMVERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/altpcied_sv_hwtcl.sv
      add_fileset_file altpcierd_tl_cfg_sample.v           VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v
      add_fileset_file altpcierd_cdma_app_icm.v            VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_app_icm.v
      add_fileset_file altpcierd_cdma_ast_msi.v            VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_msi.v
      add_fileset_file altpcierd_cdma_ast_rx.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx.v
      add_fileset_file altpcierd_cdma_ast_rx_128.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_128.v
      add_fileset_file altpcierd_cdma_ast_rx_64.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_64.v
      add_fileset_file altpcierd_cdma_ast_tx.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx.v
      add_fileset_file altpcierd_cdma_ast_tx_128.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_128.v
      add_fileset_file altpcierd_cdma_ast_tx_64.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_64.v
      add_fileset_file altpcierd_compliance_test.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_compliance_test.v
      add_fileset_file altpcierd_cpld_rx_buffer.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cpld_rx_buffer.v
      add_fileset_file altpcierd_cplerr_lmi.v              VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v
      add_fileset_file altpcierd_dma_descriptor.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_descriptor.v
      add_fileset_file altpcierd_dma_dt.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_dt.v
      add_fileset_file altpcierd_dma_prg_reg.v             VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_dma_prg_reg.v
      add_fileset_file altpcierd_example_app_chaining.v    VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_example_app_chaining.v
      add_fileset_file altpcierd_npcred_monitor.v          VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_npcred_monitor.v
      add_fileset_file altpcierd_pcie_reconfig_initiator.v VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_pcie_reconfig_initiator.v
      add_fileset_file altpcierd_rc_slave.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_rc_slave.v
      add_fileset_file altpcierd_read_dma_requester.v      VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_read_dma_requester.v
      add_fileset_file altpcierd_read_dma_requester_128.v  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_read_dma_requester_128.v
      add_fileset_file altpcierd_reconfig_clk_pll.v        VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_reconfig_clk_pll.v
      add_fileset_file altpcierd_reg_access.v              VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_reg_access.v
      add_fileset_file altpcierd_rxtx_downstream_intf.v    VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_rxtx_downstream_intf.v
      add_fileset_file altpcierd_write_dma_requester.v     VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_write_dma_requester.v
      add_fileset_file altpcierd_write_dma_requester_128.v VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_write_dma_requester_128.v

   }
   #common_add_fileset_files { S5 ALL_HDL } { PLAIN }
}

proc example_design_proc { outputName } {

   # example_designs/ep_g1x1.qsys
   # example_designs/ep_g1x4.qsys
   # example_designs/ep_g1x8.qsys
   # example_designs/ep_g2x1.qsys
   # example_designs/ep_g2x4.qsys
   # example_designs/ep_g2x8.qsys
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]

   add_fileset_file ep_g1x1.qsys     OTHER PATH example_designs/ep_g1x1.qsys
   add_fileset_file altpcied_qii.tcl OTHER PATH ../altera_pcie_hip_ast_ed/example_design/altpcied_qii.tcl

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_s5_pcie_sriov.pdf
