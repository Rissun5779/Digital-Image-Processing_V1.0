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
source pcie_256_avmm_parameters.tcl
source pcie_256_avmm_port.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# +-----------------------------------
# altera_pcie_256_hip_avmm
#

source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic/altera_xcvr_pipe_common.tcl
pipe_decl_fileset_groups_sv_xcvr_pipe_native ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/av/av_xcvr_pipe_common.tcl
pipe_decl_fileset_groups_av_xcvr_pipe_native ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic
# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_256_hip_avmm
set_module_property DESCRIPTION "V-Series Avalon-MM DMA for PCI Express"
set_module_property DISPLAY_NAME "V-Series Avalon-MM DMA for PCI Express Intel FPGA IP"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express"
set_module_property AUTHOR "Altera Corporation"
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
set_module_property HIDE_FROM_QSYS false
set_module_property INTERNAL true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix V" "Arria V" "Cyclone V" "Arria V GZ"}

# # +-----------------------------------
# # | Global parameters
#   |
add_parameter INTENDED_DEVICE_FAMILY String "STRATIX V"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER true
add_parameter pcie_qsys integer 1
set_parameter_property pcie_qsys VISIBLE false

# # +-----------------------------------
# # | Testbench files
#   |
# This is to tell the testbench generator "my_partner_name" is a "my_partner_type"
set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_tbed
set_module_assignment testbench.partner.pcie_tb.version 18.1
set_module_assignment testbench.partner.map.refclk     pcie_tb.refclk
set_module_assignment testbench.partner.map.hip_ctrl   pcie_tb.hip_ctrl
set_module_assignment testbench.partner.map.npor       pcie_tb.npor
set_module_assignment testbench.partner.map.hip_pipe   pcie_tb.hip_pipe
set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altpcie_256_hip_avmm_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_verilog
set_fileset_property sim_vhdl TOP_LEVEL altpcie_256_hip_avmm_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcie_256_hip_avmm_hwtcl

# # +-----------------------------------
# # | Example QSYS Design
#   |
#add_fileset example_design {EXAMPLE_DESIGN} example_design_proc


# # +-----------------------------------
# # | Documentation
#   |
add_documentation_link "Application Note" https://documentation.altera.com/#/link/nik1412548086590/nik1412548063092
add_documentation_link "Application note" https://documentation.altera.com/#/link/nik1412473924913/nik1412473905263

# # +-----------------------------------
# # | elaboration items
# # |

# +-----------------------------------
# | parameters
# |
add_pcie_hip_parameters_ui_system_settings
add_pcie_hip_parameters_bar_avmm
add_pcie_hip_parameters_ui_pci_registers
add_pcie_hip_parameters_ui_pcie_cap_registers
add_avalon_mm_parameters
add_pcie_hip_hidden_rtl_parameters
add_pcie_hip_common_hidden_rtl_parameters

add_pcie_hip_parameters_cvav
add_pcie_hip_gen2_vod
add_pcie_pre_emph_vod_av
add_pcie_pre_emph_vod_cv

proc elaboration_callback { } {

   update_default_value_hidden_parameter_common
   set_pcie_cvp_parameters_common
   validation_parameter_system_setting
   validation_parameter_bar
   validation_parameter_base_limit_reg
   validation_parameter_pcie_cap_reg
   validation_parameter_prj_setting
   update_default_value_hidden_avmm_parameter

   # Port updates
   add_pcie_hip_port_avmm_rxmaster
   add_pcie_hip_port_avmm_hprxmaster
   add_pcie_hip_port_avmm_txslave
   add_pcie_hip_port_avmm_cra
   add_pcie_hip_port_avmm_rd_master
   add_pcie_hip_port_avmm_wr_master
   add_pcie_hip_port_avmm_dts_slave
   add_pcie_hip_port_avmm_dcm_master
   add_pcie_hip_port_rd_ast
   add_pcie_hip_port_wr_ast
   add_pcie_hip_port_interrupt
   add_pcie_hip_port_reconfig
   add_pcie_hip_port_serial
   add_pcie_hip_port_pipe
   add_pcie_hip_port_control
   add_pcie_hip_port_status
   add_pcie_hip_port_tl_cfg

   # Parameter updates

   set_module_assignment testbench.partner.pcie_tb.parameter.lane_mask_hwtcl                 [get_parameter lane_mask_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.pll_refclk_freq_hwtcl           [get_parameter pll_refclk_freq_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.port_type_hwtcl                 [get_parameter port_type_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.gen123_lane_rate_mode_hwtcl     "Gen3 (8.0 Gbps)"
   set_module_assignment testbench.partner.pcie_tb.parameter.serial_sim_hwtcl                [get_parameter serial_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_tl_only_sim_hwtcl        [get_parameter enable_tl_only_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.deemphasis_enable_hwtcl         [get_parameter deemphasis_enable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.pld_clk_MHz                     [get_parameter pld_clk_MHz ]
   set_module_assignment testbench.partner.pcie_tb.parameter.millisecond_cycle_count_hwtcl   [get_parameter millisecond_cycle_count_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.use_crc_forwarding_hwtcl        [get_parameter use_crc_forwarding_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_check_capable_hwtcl        [get_parameter ecrc_check_capable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_gen_capable_hwtcl          [get_parameter ecrc_gen_capable_hwtcl ]

   set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
   set internal_controller_hwtcl [ get_parameter_value internal_controller_hwtcl ]

   set avmm_width_hwtcl [ get_parameter_value  avmm_width_hwtcl ]


   # set the mask bit for each Rxm master
   for { set i 0 } { $i < 6 } { incr i } {
      set span [get_parameter_value "SLAVE_ADDRESS_MAP_${i}"]
      if { $span < 0 } {
         set_parameter_value "bar${i}_size_mask_hwtcl" 1
      } else {
         if { $i == 0 && $internal_controller_hwtcl == 1 } {
            set_parameter_value "bar${i}_size_mask_hwtcl" 9
         } else {
            set_parameter_value "bar${i}_size_mask_hwtcl" $span
         }
      }
   }

   ## set mask bit for read DMA
   set rd_span [get_parameter_value "RD_SLAVE_ADDRESS_MAP"]
   set_parameter_value "rd_dma_size_mask_hwtcl" $rd_span

   ## set mask bit for read DMA
   set wr_span [get_parameter_value "WR_SLAVE_ADDRESS_MAP"]
   set_parameter_value "wr_dma_size_mask_hwtcl" $wr_span

   # Update value for AV and CV
   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   if { $INTENDED_DEVICE_FAMILY == "Arria V" || $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
      set_pcie_hip_flow_control_settings_avcv
      update_pcie_parameters_avcv
      set_module_assignment testbench.partner.pcie_tb.parameter.use_stratixv_tb_device       "true"
      set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 6
   } else {
      set_pcie_hip_flow_control_settings_common
      set_module_assignment testbench.partner.pcie_tb.parameter.use_stratixv_tb_device       "false"
      set override_tbpartner_driver_setting_hwtcl [get_parameter_value override_tbpartner_driver_setting_hwtcl ]
      if { $override_tbpartner_driver_setting_hwtcl>0 } {
        set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl  $override_tbpartner_driver_setting_hwtcl
      } else {
         set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 6
      }
   }
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

   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]
   set INTENDED_DEVICE_FAMILY                         [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   add_fileset_file altpcie_256_hip_avmm_hwtcl.v        VERILOG PATH altpcie_256_hip_avmm_hwtcl.v
   add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH rtl/altpcieav_256_app.sv
   add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH rtl/altpcieav_hip_interface.sv
   add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH rtl/altpcieav_dma_rxm.sv
   add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH rtl/altpcieav_dma_txs.sv
   add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH rtl/altpcieav_dma_rd.sv
   add_fileset_file altpcieav_sriov_vf_mux.sv           SYSTEM_VERILOG PATH rtl/altpcieav_sriov_vf_mux.sv
   add_fileset_file altpcieav_dma_wr.sv                 SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr.sv

   add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_2.sv
   add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_readmem_2.sv
   add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_wdalign_2.sv
   add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_tlpgen_2.sv

   add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr.sv
   add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_readmem.sv
   add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_wdalign.sv
   add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_tlpgen.sv

   add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH rtl/altpcieav_arbiter.sv
   add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH rtl/altpcieav_cra.sv
   add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_rdwr.sv
   add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_cpl.sv
   add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_txctrl.sv
   add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm.sv
   add_fileset_file dma_controller.sv                   SYSTEM_VERILOG PATH dynamic_controller/dma_controller.sv
   add_fileset_file altpcie_dynamic_control.sv          SYSTEM_VERILOG PATH dynamic_controller/altpcie_dynamic_control.sv
   add_fileset_file altpcie_fifo.sv                     VERILOG PATH rtl/altpcie_fifo.v

   if { $INTENDED_DEVICE_FAMILY == "Arria V" || $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
      add_fileset_file altpcie_cv_hip_ast_hwtcl.v          VERILOG PATH ../altera_pcie_cv_hip_ast/altpcie_cv_hip_ast_hwtcl.v
      add_fileset_file altpcie_av_hip_128bit_atom.v        VERILOG PATH ../altera_pcie_av_hip_ast/altpcie_av_hip_128bit_atom.v
      add_fileset_file altpcie_av_hip_ast_hwtcl.v          VERILOG PATH ../altera_pcie_av_hip_ast/altpcie_av_hip_ast_hwtcl.v
      add_fileset_file altpcie_rs_hip.v                    VERILOG PATH ../altera_pcie_sv_hip_ast/altpcie_rs_hip.v
      add_fileset_file altpcie_rs_serdes.v                 VERILOG PATH ../altera_pcie_sv_hip_ast/altpcie_rs_serdes.v
      common_add_fileset_files { A5 ALL_HDL } { PLAIN }
   } else {
      # SV AVGZ
      ############################################
      # HIP AST
      #
      add_quartus_sv_ast_common_fileset

      ############################################
      #
      #  PHY IP
      common_add_fileset_files { S5 ALL_HDL } { PLAIN }
   }

   #########################
   #
   # SDC Files addition
   #
   set hip_hard_reset_hwtcl                  [ get_parameter_value hip_hard_reset_hwtcl ]
   set enable_pcisigtest_hwtcl               [ get_parameter_value enable_pcisigtest_hwtcl ]
   set generate_sdc_for_qsys_design_example  [ get_parameter_value generate_sdc_for_qsys_design_example ]

#  add_fileset_file altera_pci_express.sdc              SDC     PATH altera_pci_express.sdc
   add_fileset_file altera_pcie_sv_hip_ast_pipen1b.sdc                     SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_pipen1b.sdc

   if { $enable_pcisigtest_hwtcl == 1 } {
      add_fileset_file altera_pcie_sv_hip_ast_enable_pcisigtest.sdc  SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_pcisigtest.sdc
   }
   if { $hip_hard_reset_hwtcl == 0 } {
      add_fileset_file altera_pcie_sv_hip_ast_rs_serdes.sdc          SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_rs_serdes.sdc
      set enable_power_on_rst_pulse_hwtcl   [ get_parameter_value enable_power_on_rst_pulse_hwtcl ]
      if { $enable_power_on_rst_pulse_hwtcl == 1 } {
         add_fileset_file altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc          SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc
      }
   }

   if { $generate_sdc_for_qsys_design_example == 1 } {
      add_fileset_file altpcie_qsys_design_example.sdc          SDC     PATH altpcie_qsys_design_example.sdc
   }
}

proc proc_sim_vhdl {name} {
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
                                   "altpcieav128_dma_wr.sv"
                                   "altpcieav128_dma_wr_readmem.sv"
                                   "altpcieav128_dma_wr_wdalign.sv"
                                   "altpcieav128_wr_tlpgen.sv"
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

   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   if { $INTENDED_DEVICE_FAMILY == "Arria V" || $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
      # AV/CV
      common_add_fileset_files { A5 ALL_HDL } { PLAIN MENTOR}

      add_fileset_file mentor/altpcie_256_hip_avmm_hwtcl.v        VERILOG_ENCRYPT PATH "mentor/altpcie_256_hip_avmm_hwtcl.v"                                                       {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcie_cv_hip_ast_hwtcl.v          VERILOG_ENCRYPT PATH "../altera_pcie_cv_hip_ast/mentor/altpcie_cv_hip_ast_hwtcl.v"                               {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcie_av_hip_ast_hwtcl.v          VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/mentor/altpcie_av_hip_ast_hwtcl.v"                               {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcie_av_hip_128bit_atom.v        VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/mentor/altpcie_av_hip_128bit_atom.v"                             {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcierd_hip_rs.v                  VERILOG_ENCRYPT PATH "../altera_pcie_hip_ast_ed/mentor/example_design/verilog/chaining_dma/altpcierd_hip_rs.v"   {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcie_rs_hip.v                    VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/mentor/altpcie_rs_hip.v"                                         {MENTOR_SPECIFIC}
      add_fileset_file mentor/altpcie_rs_serdes.v                 VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/mentor/altpcie_rs_serdes.v"                                      {MENTOR_SPECIFIC}

      add_fileset_file aldec/altpcie_256_hip_avmm_hwtcl.v         VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                              {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcie_cv_hip_ast_hwtcl.v           VERILOG_ENCRYPT PATH "../altera_pcie_cv_hip_ast/altpcie_cv_hip_ast_hwtcl.v"                                      {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcie_av_hip_ast_hwtcl.v           VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_ast_hwtcl.v"                                      {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcie_av_hip_128bit_atom.v         VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_128bit_atom.v"                                    {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcierd_hip_rs.v                   VERILOG_ENCRYPT PATH "../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v"          {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcie_rs_hip.v                     VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_hip.v"                                                {ALDEC_SPECIFIC}
      add_fileset_file aldec/altpcie_rs_serdes.v                  VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_serdes.v"                                             {ALDEC_SPECIFIC}

      if { 0 } {
         add_fileset_file  altpcie_256_hip_avmm_hwtcl.v        VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                                 {CADENCE_SPECIFIC}
         add_fileset_file altpcie_cv_hip_ast_hwtcl.v           VERILOG_ENCRYPT PATH "../altera_pcie_cv_hip_ast/altpcie_cv_hip_ast_hwtcl.v"                                         {CADENCE_SPECIFIC}
         add_fileset_file altpcie_av_hip_ast_hwtcl.v           VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_ast_hwtcl.v"                                         {CADENCE_SPECIFIC}
         add_fileset_file altpcie_av_hip_128bit_atom.v         VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_128bit_atom.v"                                       {CADENCE_SPECIFIC}
         add_fileset_file altpcierd_hip_rs.v                   VERILOG_ENCRYPT PATH "../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v"             {CADENCE_SPECIFIC}
         add_fileset_file altpcie_rs_hip.v                     VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_hip.v"                                                   {CADENCE_SPECIFIC}
         add_fileset_file altpcie_rs_serdes.v                  VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_serdes.v"                                                {CADENCE_SPECIFIC}
      }
      if { 0 } {
         add_fileset_file  altpcie_256_hip_avmm_hwtcl.v         VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                                {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcie_cv_hip_ast_hwtcl.v            VERILOG_ENCRYPT PATH "../altera_pcie_cv_hip_ast/altpcie_cv_hip_ast_hwtcl.v"                                        {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcie_av_hip_ast_hwtcl.v            VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_ast_hwtcl.v"                                        {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcie_av_hip_128bit_atom.v          VERILOG_ENCRYPT PATH "../altera_pcie_av_hip_ast/altpcie_av_hip_128bit_atom.v"                                      {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcierd_hip_rs.v                    VERILOG_ENCRYPT PATH "../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v"            {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcie_rs_hip.v                      VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_hip.v"                                                  {SYNOPSYS_SPECIFIC}
         add_fileset_file altpcie_rs_serdes.v                   VERILOG_ENCRYPT PATH "../altera_pcie_sv_hip_ast/altpcie_rs_serdes.v"                                               {SYNOPSYS_SPECIFIC}
      }
   } else {
      ############################################
      #
      #  HIP
      add_simvhdl_sv_ast_common_fileset

      ############################################
      #
      #  PHY IP
      common_add_fileset_files { S5 ALL_HDL } { PLAIN MENTOR}

      add_fileset_file mentor/altpcie_256_hip_avmm_hwtcl.v        VERILOG_ENCRYPT PATH "mentor/altpcie_256_hip_avmm_hwtcl.v"                                                       {MENTOR_SPECIFIC}


      add_fileset_file aldec/altpcie_256_hip_avmm_hwtcl.v         VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                              {ALDEC_SPECIFIC}

      if { 0 } {
         add_fileset_file  altpcie_256_hip_avmm_hwtcl.v           VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                                 {CADENCE_SPECIFIC}
      }
      if { 0 } {
         add_fileset_file  altpcie_256_hip_avmm_hwtcl.v           VERILOG_ENCRYPT PATH "altpcie_256_hip_avmm_hwtcl.v"                                                                {SYNOPSYS_SPECIFIC}
      }

   }
}

proc proc_sim_verilog {name} {


   add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH rtl/altpcieav_256_app.sv
   add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH rtl/altpcieav_hip_interface.sv
   add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH rtl/altpcieav_dma_rxm.sv
   add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH rtl/altpcieav_dma_rd.sv
   add_fileset_file altpcieav_sriov_vf_mux.sv           SYSTEM_VERILOG PATH rtl/altpcieav_sriov_vf_mux.sv
   add_fileset_file altpcieav_dma_wr.sv                 SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr.sv

   add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_2.sv
   add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_readmem_2.sv
   add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_wdalign_2.sv
   add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH rtl/altpcieav_dma_wr_tlpgen_2.sv

   add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr.sv
   add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_readmem.sv
   add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_wdalign.sv
   add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH rtl/altpcieav128_dma_wr_tlpgen.sv

   add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH rtl/altpcieav_dma_txs.sv
   add_fileset_file altpcieav_dma_arbiter.sv            SYSTEM_VERILOG PATH rtl/altpcieav_arbiter.sv
   add_fileset_file altpcieav_dma_cra.sv                SYSTEM_VERILOG PATH rtl/altpcieav_cra.sv
   add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_rdwr.sv
   add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_cpl.sv
   add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm_txctrl.sv
   add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH rtl/altpcieav_dma_hprxm.sv
   add_fileset_file dma_controller.sv                   SYSTEM_VERILOG PATH dynamic_controller/dma_controller.sv
   add_fileset_file altpcie_dynamic_control.sv          SYSTEM_VERILOG PATH dynamic_controller/altpcie_dynamic_control.sv
   add_fileset_file altpcie_fifo.v                      SYSTEM_VERILOG PATH rtl/altpcie_fifo.v
   add_fileset_file altpcie_256_hip_avmm_hwtcl.v        VERILOG PATH  altpcie_256_hip_avmm_hwtcl.v
   add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   # Even for AV/CV, SV files are added because they are required by Gen3 BFM
   add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v

   ############################################
   #
   #  HIP
   add_simverilog_sv_ast_common_fileset

   ############################################
   #
   #  PHY IP
   common_add_fileset_files { S5 ALL_HDL } { PLAIN }

   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   if { $INTENDED_DEVICE_FAMILY == "Arria V" || $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
      add_fileset_file altpcie_cv_hip_ast_hwtcl.v          VERILOG PATH ../altera_pcie_cv_hip_ast/altpcie_cv_hip_ast_hwtcl.v
      add_fileset_file altpcie_av_hip_ast_hwtcl.v          VERILOG PATH ../altera_pcie_av_hip_ast/altpcie_av_hip_ast_hwtcl.v
      add_fileset_file altpcie_av_hip_128bit_atom.v        VERILOG PATH ../altera_pcie_av_hip_ast/altpcie_av_hip_128bit_atom.v
      common_add_fileset_files { A5 ALL_HDL } { PLAIN }
   }


}

proc example_design_proc { outputName } {

   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   if { $INTENDED_DEVICE_FAMILY == "Arria V" }           {
      add_fileset_file  pcie_de_ep_dma_g1x8_av_integrated.qsys   OTHER PATH example_design/av/pcie_de_ep_dma_g1x8_av_integrated.qsys
   } elseif { $INTENDED_DEVICE_FAMILY == "Cyclone V" }   {
      add_fileset_file  pcie_de_ep_dma_g2x4_cv.qsys OTHER PATH example_design/cv/pcie_de_ep_dma_g2x4_cv.qsys
   } else                                                {
      add_fileset_file pcie_de_ep_dma_g3x8_integrated.qsys OTHER PATH example_design/sv/pcie_de_ep_dma_g3x8_integrated.qsys
   }
   add_fileset_file altpcied_qii.tcl OTHER PATH ../altera_pcie_hip_ast_ed/example_design/altpcied_qii.tcl

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nik1410905927419/nik1410905278518
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698001659
