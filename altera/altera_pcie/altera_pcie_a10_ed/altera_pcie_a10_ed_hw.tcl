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
source rd_pcie_a10_parameters.tcl
source rd_pcie_a10_port.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

# get xcvr PHY function definitions
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_xcvr_generic/alt_xcvr_common.tcl

# +-----------------------------------
# | module PCI Express
# |
set_module_property DESCRIPTION "Example : Intel Arria 10 Application for Avalon-Streaming hard IP for PCI Express"
set_module_property NAME altera_pcie_a10_ed
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "Example : Intel Arria 10 Application for Avalon-Streaming Hard IP for PCI Express"

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
set_module_property SUPPORTED_DEVICE_FAMILIES {"Arria 10" }

set_module_property ELABORATION_CALLBACK elaboration_callback

add_parameter INTENDED_DEVICE_FAMILY String "Arria 10"
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER FALSE
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE

# # +---------------------------------------------
# # | QIP Message suppression for design example
#   |
set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 12110 -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 10036                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10230                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 13410                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 12677                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 15610                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10036                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 12241                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 14320                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10858                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10036                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10222                    -entity altpcied_a10_hwtcl
set_instance_assignment -name MESSAGE_DISABLE 10036                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 10230                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 13410                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 12677                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 15610                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 10036                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 12241                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 14320                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 10858                    -entity altpcierd_example_app_chaining
set_instance_assignment -name MESSAGE_DISABLE 287001                   -entity altpcierd_example_app_chaining   "}

# # +-----------------------------------
# # | Documentation
#   |
add_documentation_link "User guide" http://www.altera.com/literature/ug/ug_a10_pcie.pdf
add_documentation_link "Release Notes:" http://www.altera.com/literature/rn/ip/#other_ip.html
add_documentation_link "Application Note" http://www.altera.com/literature/an/an690.pdf
add_documentation_link "Application note" http://www.altera.com/literature/an/an456.pdf

# # +-----------------------------------
# # | Example design RTL files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcied_a10_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcied_a10_hwtcl

add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altpcied_a10_hwtcl

# +-----------------------------------
# | parameters
# |
add_rdpcie_parameters_ui
add_rdpcie_hip_parameters_hidden

# +-----------------------------------
# | ports

# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {
  #validation_parameter_func
   rdpcie_hip_parameters_valid
   add_rdpcie_port_clk

   # Port updates
   add_rdpcie_port_ast_rx
   add_rdpcie_port_ast_tx
   add_rdpcie_port_rst
   add_rdpcie_port_interrupt
   add_rdpcie_port_status
   add_rdpcie_port_tl_cfg
   add_rdpcie_port_lmi
   add_rdpcie_port_pw_mngt
   add_fpgadevkitboard
}

# +-----------------------------------
# | Static IO
# |
add_interface no_connect conduit end

# ************** Global Variables ***************
set not_init "default"
# **************** Parameters *******************


proc proc_quartus_synth {name} {

   global QUARTUS_ROOTDIR
   set port_type_hwtcl  [ get_parameter_value port_type_hwtcl ]
   set use_ep_simple_downstream_apps_hwtcl [get_parameter_value use_ep_simple_downstream_apps_hwtcl ]

   if { $use_ep_simple_downstream_apps_hwtcl == 1 } {
      add_fileset_file altpcied_a10_hwtcl.sv                SYSTEMVERILOG PATH altpcie_simple_downstream_apps/altpcied_simple_downstream_app.sv
      add_fileset_file altpcied_ep_64bit_downstream.v       VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_64bit_downstream.v
      add_fileset_file altpcied_ep_128bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_128bit_downstream.v
      add_fileset_file altpcied_ep_256bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_256bit_downstream.v
   } else {
      add_fileset_file altpcied_a10_hwtcl.sv                SYSTEMVERILOG PATH altpcied_a10_hwtcl.sv
      add_fileset_file altpcie_reset_delay_sync.v          VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcierd_tl_cfg_sample.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v


      if { [ regexp endpoint $port_type_hwtcl ] } {
         add_fileset_file altpcierd_ast256_downstream.v       VERILOG PATH example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v
         add_fileset_file altpcierd_cdma_app_icm.v            VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_app_icm.v
         add_fileset_file altpcierd_cdma_ast_msi.v            VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_msi.v
         add_fileset_file altpcierd_cdma_ast_rx.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx.v
         add_fileset_file altpcierd_cdma_ast_rx_128.v         VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_128.v
         add_fileset_file altpcierd_cdma_ast_rx_64.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_64.v
         add_fileset_file altpcierd_cdma_ast_tx.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx.v
         add_fileset_file altpcierd_cdma_ast_tx_128.v         VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_128.v
         add_fileset_file altpcierd_cdma_ast_tx_64.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_64.v
         add_fileset_file altpcierd_compliance_test.v         VERILOG PATH example_design/verilog/chaining_dma/altpcierd_compliance_test.v
         add_fileset_file altpcierd_cpld_rx_buffer.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cpld_rx_buffer.v
         add_fileset_file altpcierd_cplerr_lmi.v              VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v
         add_fileset_file altpcierd_dma_descriptor.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_descriptor.v
         add_fileset_file altpcierd_dma_dt.v                  VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_dt.v
         add_fileset_file altpcierd_dma_prg_reg.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_prg_reg.v
         add_fileset_file altpcierd_example_app_chaining.v    VERILOG PATH example_design/verilog/chaining_dma/altpcierd_example_app_chaining.v
         add_fileset_file altpcierd_npcred_monitor.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_npcred_monitor.v
         add_fileset_file altpcierd_pcie_reconfig_initiator.v VERILOG PATH example_design/verilog/chaining_dma/altpcierd_pcie_reconfig_initiator.v
         add_fileset_file altpcierd_rc_slave.v                VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rc_slave.v
         add_fileset_file altpcierd_read_dma_requester.v      VERILOG PATH example_design/verilog/chaining_dma/altpcierd_read_dma_requester.v
         add_fileset_file altpcierd_read_dma_requester_128.v  VERILOG PATH example_design/verilog/chaining_dma/altpcierd_read_dma_requester_128.v
         add_fileset_file altpcierd_reconfig_clk_pll.v        VERILOG PATH example_design/verilog/chaining_dma/altpcierd_reconfig_clk_pll.v
         add_fileset_file altpcierd_reg_access.v              VERILOG PATH example_design/verilog/chaining_dma/altpcierd_reg_access.v
         add_fileset_file altpcierd_rxtx_downstream_intf.v    VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rxtx_downstream_intf.v
         add_fileset_file altpcierd_write_dma_requester.v     VERILOG PATH example_design/verilog/chaining_dma/altpcierd_write_dma_requester.v
         add_fileset_file altpcierd_write_dma_requester_128.v VERILOG PATH example_design/verilog/chaining_dma/altpcierd_write_dma_requester_128.v
      }
   }

   add_fileset_file altpcied_a10.sdc                     SDC     PATH altpcied_a10.sdc
}

proc proc_sim_vhdl {name} {
   set use_ep_simple_downstream_apps_hwtcl [get_parameter_value use_ep_simple_downstream_apps_hwtcl ]
   global QUARTUS_ROOTDIR

   # Reconfig IP files

   if { $use_ep_simple_downstream_apps_hwtcl == 1 } {
      add_fileset_file altpcied_a10_hwtcl.sv                SYSTEMVERILOG PATH altpcie_simple_downstream_apps/altpcied_simple_downstream_app.sv
      add_fileset_file altpcied_ep_64bit_downstream.v       VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_64bit_downstream.v
      add_fileset_file altpcied_ep_128bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_128bit_downstream.v
      add_fileset_file altpcied_ep_256bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_256bit_downstream.v
   } else {
      set verilog_file {"example_design/verilog/chaining_dma/altpcierd_hip_rs.v" "example_design/verilog/chaining_dma/altpcierd_rx_ecrc_128_sim.v" "example_design/verilog/chaining_dma/altpcierd_rx_ecrc_64_sim.v" "example_design/verilog/chaining_dma/altpcierd_tx_ecrc_128_sim.v" "example_design/verilog/chaining_dma/altpcierd_tx_ecrc_64_sim.v"  }

      if {1} {
         foreach vf $verilog_file {
            # Co-simulation clear text verilog files
            # Mentor only co-simulation files encrypted
            add_fileset_file mentor/${vf} VERILOG_ENCRYPT PATH mentor/${vf} {MENTOR_SPECIFIC}
         }
         add_fileset_file mentor/altpcied_a10_hwtcl.sv          SYSTEMVERILOG_ENCRYPT PATH mentor/altpcied_a10_hwtcl.sv {MENTOR_SPECIFIC}
         add_fileset_file mentor/altpcie_reset_delay_sync.v     VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/mentor/altpcie_reset_delay_sync.v  {MENTOR_SPECIFIC}
      }

      foreach vf $verilog_file {
         add_fileset_file synopsys/${vf} VERILOG PATH ${vf} SYNOPSYS_SPECIFIC
         add_fileset_file cadence/${vf}  VERILOG PATH ${vf} CADENCE_SPECIFIC
         add_fileset_file aldec/${vf}    VERILOG PATH ${vf} ALDEC_SPECIFIC
      }

      add_fileset_file synopsys/altpcied_a10_hwtcl.sv VERILOG PATH altpcied_a10_hwtcl.sv SYNOPSYS_SPECIFIC
      add_fileset_file cadence/altpcied_a10_hwtcl.sv  VERILOG PATH altpcied_a10_hwtcl.sv CADENCE_SPECIFIC
      add_fileset_file aldec/altpcied_a10_hwtcl.sv    VERILOG PATH altpcied_a10_hwtcl.sv ALDEC_SPECIFIC

      add_fileset_file synopsys/altpcie_reset_delay_sync.v VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v SYNOPSYS_SPECIFIC
      add_fileset_file cadence/altpcie_reset_delay_sync.v  VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v CADENCE_SPECIFIC
      add_fileset_file aldec/altpcie_reset_delay_sync.v    VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v ALDEC_SPECIFIC

      set port_type_hwtcl  [ get_parameter_value port_type_hwtcl ]

      add_fileset_file altpcierd_tl_cfg_sample.vhd            VHDL PATH example_design/vhdl/chaining_dma/altpcierd_tl_cfg_sample.vhd

      if { [ regexp endpoint $port_type_hwtcl ] } {
         add_fileset_file altpcierd_ast256_downstream.vhd        VHDL PATH example_design/vhdl/chaining_dma/altpcierd_ast256_downstream.vhd
         add_fileset_file altpcierd_cdma_app_icm.vhd             VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_app_icm.vhd
         add_fileset_file altpcierd_cdma_ast_msi.vhd             VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_msi.vhd
         add_fileset_file altpcierd_cdma_ast_rx.vhd              VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_rx.vhd
         add_fileset_file altpcierd_cdma_ast_rx_128.vhd          VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_rx_128.vhd
         add_fileset_file altpcierd_cdma_ast_rx_64.vhd           VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_rx_64.vhd
         add_fileset_file altpcierd_cdma_ast_tx.vhd              VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_tx.vhd
         add_fileset_file altpcierd_cdma_ast_tx_128.vhd          VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_tx_128.vhd
         add_fileset_file altpcierd_cdma_ast_tx_64.vhd           VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ast_tx_64.vhd
         add_fileset_file altpcierd_cdma_ecrc_check_128.vhd      VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_check_128.vhd
         add_fileset_file altpcierd_cdma_ecrc_check_64.vhd       VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_check_64.vhd
         add_fileset_file altpcierd_cdma_ecrc_gen.vhd            VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_gen.vhd
         add_fileset_file altpcierd_cdma_ecrc_gen_calc.vhd       VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_gen_calc.vhd
         add_fileset_file altpcierd_cdma_ecrc_gen_ctl_128.vhd    VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_gen_ctl_128.vhd
         add_fileset_file altpcierd_cdma_ecrc_gen_ctl_64.vhd     VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_gen_ctl_64.vhd
         add_fileset_file altpcierd_cdma_ecrc_gen_datapath.vhd   VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cdma_ecrc_gen_datapath.vhd
         add_fileset_file altpcierd_compliance_test.vhd          VHDL PATH example_design/vhdl/chaining_dma/altpcierd_compliance_test.vhd
         add_fileset_file altpcierd_cpld_rx_buffer.vhd           VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cpld_rx_buffer.vhd
         add_fileset_file altpcierd_cplerr_lmi.vhd               VHDL PATH example_design/vhdl/chaining_dma/altpcierd_cplerr_lmi.vhd
         add_fileset_file altpcierd_dma_descriptor.vhd           VHDL PATH example_design/vhdl/chaining_dma/altpcierd_dma_descriptor.vhd
         add_fileset_file altpcierd_dma_dt.vhd                   VHDL PATH example_design/vhdl/chaining_dma/altpcierd_dma_dt.vhd
         add_fileset_file altpcierd_dma_prg_reg.vhd              VHDL PATH example_design/vhdl/chaining_dma/altpcierd_dma_prg_reg.vhd
         add_fileset_file altpcierd_example_app_chaining.vhd     VHDL PATH example_design/vhdl/chaining_dma/altpcierd_example_app_chaining.vhd
         add_fileset_file altpcierd_pcie_reconfig_initiator.vhd  VHDL PATH example_design/vhdl/chaining_dma/altpcierd_pcie_reconfig_initiator.vhd
         add_fileset_file altpcierd_rc_slave.vhd                 VHDL PATH example_design/vhdl/chaining_dma/altpcierd_rc_slave.vhd
         add_fileset_file altpcierd_read_dma_requester.vhd       VHDL PATH example_design/vhdl/chaining_dma/altpcierd_read_dma_requester.vhd
         add_fileset_file altpcierd_read_dma_requester_128.vhd   VHDL PATH example_design/vhdl/chaining_dma/altpcierd_read_dma_requester_128.vhd
         add_fileset_file altpcierd_reconfig_clk_pll.vhd         VHDL PATH example_design/vhdl/chaining_dma/altpcierd_reconfig_clk_pll.vhd
         add_fileset_file altpcierd_reg_access.vhd               VHDL PATH example_design/vhdl/chaining_dma/altpcierd_reg_access.vhd
         add_fileset_file altpcierd_rxtx_downstream_intf.vhd     VHDL PATH example_design/vhdl/chaining_dma/altpcierd_rxtx_downstream_intf.vhd
         add_fileset_file altpcierd_tx_ecrc_ctl_fifo.vhd         VHDL PATH example_design/vhdl/chaining_dma/altpcierd_tx_ecrc_ctl_fifo.vhd
         add_fileset_file altpcierd_tx_ecrc_data_fifo.vhd        VHDL PATH example_design/vhdl/chaining_dma/altpcierd_tx_ecrc_data_fifo.vhd
         add_fileset_file altpcierd_tx_ecrc_fifo.vhd             VHDL PATH example_design/vhdl/chaining_dma/altpcierd_tx_ecrc_fifo.vhd
         add_fileset_file altpcierd_write_dma_requester.vhd      VHDL PATH example_design/vhdl/chaining_dma/altpcierd_write_dma_requester.vhd
         add_fileset_file altpcierd_write_dma_requester_128.vhd  VHDL PATH example_design/vhdl/chaining_dma/altpcierd_write_dma_requester_128.vhd
      } else {
         # Currently No VHDL support for RP simulation Verilog only
         add_fileset_file altpcietb_bfm_vc_intf_ast.v  VERILOG PATH example_design/verilog/root_port/altpcietb_bfm_vc_intf_ast.v
         add_fileset_file altpcierd_reconfig_clk_pll.v VERILOG PATH example_design/verilog/root_port/altpcierd_reconfig_clk_pll.v
         add_fileset_file altpcierd_cdma_ecrc_check.v  VERILOG PATH example_design/verilog/root_port/altpcierd_cdma_ecrc_check.v
         add_fileset_file pcie_example_design_master_0.v VERILOG PATH a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v
      }
   }

}

proc proc_sim_verilog {name} {

   global QUARTUS_ROOTDIR
   set port_type_hwtcl  [ get_parameter_value port_type_hwtcl ]
   set use_ep_simple_downstream_apps_hwtcl [get_parameter_value use_ep_simple_downstream_apps_hwtcl ]

   if { $use_ep_simple_downstream_apps_hwtcl == 1 } {
      add_fileset_file altpcied_a10_hwtcl.sv                SYSTEMVERILOG PATH altpcie_simple_downstream_apps/altpcied_simple_downstream_app.sv
      add_fileset_file altpcied_ep_64bit_downstream.v       VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_64bit_downstream.v
      add_fileset_file altpcied_ep_128bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_128bit_downstream.v
      add_fileset_file altpcied_ep_256bit_downstream.v      VERILOG PATH altpcie_simple_downstream_apps/altpcied_ep_256bit_downstream.v
   } else {
      add_fileset_file altpcied_a10_hwtcl.sv                 SYSTEMVERILOG PATH altpcied_a10_hwtcl.sv
      add_fileset_file altpcie_reset_delay_sync.v            VERILOG PATH $QUARTUS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_hip/altpcie_reset_delay_sync.v
      add_fileset_file altpcierd_hip_rs.v                    VERILOG PATH example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcierd_tl_cfg_sample.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v

      if { [ regexp endpoint $port_type_hwtcl ] } {
         add_fileset_file altpcierd_rx_ecrc_128_sim.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rx_ecrc_128_sim.v
         add_fileset_file altpcierd_rx_ecrc_64_sim.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rx_ecrc_64_sim.v
         add_fileset_file altpcierd_tx_ecrc_128_sim.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tx_ecrc_128_sim.v
         add_fileset_file altpcierd_tx_ecrc_64_sim.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tx_ecrc_64_sim.v
         add_fileset_file altpcierd_ast256_downstream.v        VERILOG PATH example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v
         add_fileset_file altpcierd_cdma_app_icm.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_app_icm.v
         add_fileset_file altpcierd_cdma_ast_msi.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_msi.v
         add_fileset_file altpcierd_cdma_ast_rx.v              VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx.v
         add_fileset_file altpcierd_cdma_ast_rx_128.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_128.v
         add_fileset_file altpcierd_cdma_ast_rx_64.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_rx_64.v
         add_fileset_file altpcierd_cdma_ast_tx.v              VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx.v
         add_fileset_file altpcierd_cdma_ast_tx_128.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_128.v
         add_fileset_file altpcierd_cdma_ast_tx_64.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ast_tx_64.v
         add_fileset_file altpcierd_cdma_ecrc_check_128.v      VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_check_128.v
         add_fileset_file altpcierd_cdma_ecrc_check_64.v       VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_check_64.v
         add_fileset_file altpcierd_cdma_ecrc_gen.v            VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_gen.v
         add_fileset_file altpcierd_cdma_ecrc_gen_calc.v       VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_gen_calc.v
         add_fileset_file altpcierd_cdma_ecrc_gen_ctl_128.v    VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_gen_ctl_128.v
         add_fileset_file altpcierd_cdma_ecrc_gen_ctl_64.v     VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_gen_ctl_64.v
         add_fileset_file altpcierd_cdma_ecrc_gen_datapath.v   VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cdma_ecrc_gen_datapath.v
         add_fileset_file altpcierd_compliance_test.v          VERILOG PATH example_design/verilog/chaining_dma/altpcierd_compliance_test.v
         add_fileset_file altpcierd_cpld_rx_buffer.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cpld_rx_buffer.v
         add_fileset_file altpcierd_cplerr_lmi.v               VERILOG PATH example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v
         add_fileset_file altpcierd_dma_descriptor.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_descriptor.v
         add_fileset_file altpcierd_dma_dt.v                   VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_dt.v
         add_fileset_file altpcierd_dma_prg_reg.v              VERILOG PATH example_design/verilog/chaining_dma/altpcierd_dma_prg_reg.v
         add_fileset_file altpcierd_example_app_chaining.v     VERILOG PATH example_design/verilog/chaining_dma/altpcierd_example_app_chaining.v
         add_fileset_file altpcierd_npcred_monitor.v           VERILOG PATH example_design/verilog/chaining_dma/altpcierd_npcred_monitor.v
         add_fileset_file altpcierd_pcie_reconfig_initiator.v  VERILOG PATH example_design/verilog/chaining_dma/altpcierd_pcie_reconfig_initiator.v
         add_fileset_file altpcierd_rc_slave.v                 VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rc_slave.v
         add_fileset_file altpcierd_read_dma_requester.v       VERILOG PATH example_design/verilog/chaining_dma/altpcierd_read_dma_requester.v
         add_fileset_file altpcierd_read_dma_requester_128.v   VERILOG PATH example_design/verilog/chaining_dma/altpcierd_read_dma_requester_128.v
         add_fileset_file altpcierd_reconfig_clk_pll.v         VERILOG PATH example_design/verilog/chaining_dma/altpcierd_reconfig_clk_pll.v
         add_fileset_file altpcierd_reg_access.v               VERILOG PATH example_design/verilog/chaining_dma/altpcierd_reg_access.v
         add_fileset_file altpcierd_rxtx_downstream_intf.v     VERILOG PATH example_design/verilog/chaining_dma/altpcierd_rxtx_downstream_intf.v
         add_fileset_file altpcierd_tx_ecrc_ctl_fifo.v         VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tx_ecrc_ctl_fifo.v
         add_fileset_file altpcierd_tx_ecrc_data_fifo.v        VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tx_ecrc_data_fifo.v
         add_fileset_file altpcierd_tx_ecrc_fifo.v             VERILOG PATH example_design/verilog/chaining_dma/altpcierd_tx_ecrc_fifo.v
         add_fileset_file altpcierd_write_dma_requester.v      VERILOG PATH example_design/verilog/chaining_dma/altpcierd_write_dma_requester.v
         add_fileset_file altpcierd_write_dma_requester_128.v  VERILOG PATH example_design/verilog/chaining_dma/altpcierd_write_dma_requester_128.v
      } else {
         add_fileset_file altpcietb_bfm_vc_intf_ast.v          VERILOG PATH example_design/verilog/root_port/altpcietb_bfm_vc_intf_ast.v
         add_fileset_file altpcierd_reconfig_clk_pll.v         VERILOG PATH example_design/verilog/root_port/altpcierd_reconfig_clk_pll.v
         add_fileset_file altpcierd_cdma_ecrc_check.v          VERILOG PATH example_design/verilog/root_port/altpcierd_cdma_ecrc_check.v
         add_fileset_file pcie_example_design_master_0.v       VERILOG PATH a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v
      }
   }

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/lbl1414599283601/nik1410905278518
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697736501
