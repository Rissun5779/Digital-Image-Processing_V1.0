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



package require -exact sopc 10.1
sopc::preview_add_transform name preview_avalon_mm_transform
source tbed_pcie_s10_parameters.tcl
source tbed_pcie_s10_port.tcl

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_s10_tbed
set_module_property VERSION 18.1
set_module_property DESCRIPTION "Testbench for Avalon-Streaming Stratix 10 hard IP for PCI Express"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_s5_pcie.pdf"                                    ;#TODO
set_module_property GROUP "Interface Protocols/PCI Express"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "Testbench for Avalon-Streaming Stratix 10 hard IP for PCI Express"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true

set_module_property EDITABLE true
set_module_property ANALYZE_HDL FALSE

set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL true

set_module_property ELABORATION_CALLBACK elaboration_callback

set_module_property instantiateInSystemModule "true"


# # +-----------------------------------
# # | Documentation
#   |
add_documentation_link "User guide" http://www.altera.com/literature/ug/ug_s10_pcie.pdf
add_documentation_link "Release Notes:" http://www.altera.com/literature/rn/ip/#other_ip.html
add_documentation_link "Application Note" http://www.altera.com/literature/an/an690.pdf
add_documentation_link "Application note" http://www.altera.com/literature/an/an456.pdf

# # +-----------------------------------
# # | Example design RTL files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcie_s10_tbed_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcie_s10_tbed_hwtcl

# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {
    # Port updates

    set bfm_drive_interface_clk_hwtcl       [ get_parameter_value bfm_drive_interface_clk_hwtcl     ]
    set bfm_drive_interface_npor_hwtcl      [ get_parameter_value bfm_drive_interface_npor_hwtcl    ]
    set bfm_drive_interface_pipe_hwtcl      [ get_parameter_value bfm_drive_interface_pipe_hwtcl    ]
    set bfm_drive_interface_control_hwtcl   [ get_parameter_value bfm_drive_interface_control_hwtcl ]
    set gen123_lane_rate_mode_hwtcl         [ get_parameter gen123_lane_rate_mode_hwtcl             ]

       set_module_assignment postgeneration.pcie_tb.device_family "STRATIX V"


    add_tbed_hip_port_serial

    if { $bfm_drive_interface_clk_hwtcl == 1 } {
      add_tbed_hip_port_clk
    }

    if { $bfm_drive_interface_pipe_hwtcl == 1 } {
      add_tbed_hip_port_pipe
    }

    if { $bfm_drive_interface_control_hwtcl == 1 } {
      add_tbed_hip_port_control
    }

    if { $bfm_drive_interface_npor_hwtcl == 1 } {
      add_tbed_hip_port_npor
    }
}


# +-----------------------------------
# | files
# |

# |
# +-----------------------------------

# +-----------------------------------
# | parameters
# |
add_tbed_pcie_parameters_ui

# +-----------------------------------
# | Static IO
# |
add_interface no_connect conduit end

# ************** Global Variables ***************
set not_init "default"
# **************** Parameters *******************

proc proc_sim_verilog {name} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set port_type_hwtcl             [ get_parameter_value port_type_hwtcl ]
   set gen123_lane_rate_mode_hwtcl [ get_parameter gen123_lane_rate_mode_hwtcl ]
   set apps_type_hwtcl             [ get_parameter_value apps_type_hwtcl ]

   set set_bfm_driver_to_config_only            1
   set set_bfm_driver_to_chaining_dma           2
   set set_bfm_driver_to_config_target          3
   set set_bfm_driver_to_config_bypass          10
   set set_bfm_driver_to_simple_ep_downstream   11
   set set_bfm_driver_to_sriov_dma              12
   set set_bfm_driver_to_sriov_target           13

   add_fileset_file altpcietb_ltssm_mon.v                VERILOG PATH verilog/altpcietb_ltssm_mon.v
   add_fileset_file altpcietb_pipe_phy.v                 VERILOG PATH verilog/altpcietb_pipe_phy.v
   add_fileset_file altpcietb_pipe32_hip_interface.v     VERILOG PATH verilog/altpcietb_pipe32_hip_interface.v
   add_fileset_file altpcietb_pipe32_driver.v            VERILOG PATH verilog/altpcietb_pipe32_driver.v
   add_fileset_file altpcie_s10_tbed_hwtcl.v             VERILOG PATH altpcie_s10_tbed_hwtcl.v
   add_fileset_file altera_pcie_s10_tbed_reset_delay_sync VERILOG PATH verilog/altera_pcie_s10_tbed_reset_delay_sync.v
   add_fileset_file altpcietb_bfm_log.v                  VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v
   add_fileset_file altpcietb_bfm_configure.v            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v
   add_fileset_file altpcietb_bfm_constants.v            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v
   add_fileset_file altpcietb_bfm_rdwr.v                 VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v
   add_fileset_file altpcietb_bfm_req_intf.v             VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v
   add_fileset_file altpcietb_bfm_shmem.v                VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v
   add_fileset_file altpcietb_bfm_tlp_inspector.v        VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v
   if { [ regexp endpoint $port_type_hwtcl ] } {
         # Use testbench BFM Gen3 x8
         add_fileset_file altpcietb_bfm_top_rp.v                VERILOG PATH verilog/altpcietb_bfm_top_rp.v
         add_fileset_file altpcietb_g3bfm_log.v                 VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v
         add_fileset_file altpcietb_g3bfm_configure.v           VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v
         add_fileset_file altpcietb_g3bfm_constants.v           VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v
         add_fileset_file altpcietb_g3bfm_rdwr.v                VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v
         add_fileset_file altpcietb_g3bfm_req_intf.v            VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v
         add_fileset_file altpcietb_g3bfm_shmem.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v
         add_fileset_file altpcietb_g3bfm_vc_intf_ast_common.v  VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v
         add_fileset_file altpcierd_tl_cfg_sample.v          VERILOG PATH ../altera_pcie_s10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v
         add_fileset_file altpcied_s10_hwtcl.sv              SYSTEMVERILOG PATH ../altera_pcie_s10_ed/altpcied_s10_hwtcl.sv
         add_fileset_file altpcietb_bfm_rp_gen3_x8.sv        SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv

        } else {
       add_fileset_file stratixiv_hssi_atoms.v                           VERILOG PATH verilog/stratixiv_hssi_atoms.v
      add_fileset_file stratixiv_pcie_hip_atoms.v                       VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v
      # For pipe simulation
      add_fileset_file sv_xcvr.sv                                       SYSTEMVERILOG PATH verilog/sv_xcvr.sv
      add_fileset_file stratixv_hssi_atoms.v                            VERILOG PATH verilog/stratixv_hssi_atoms.v
      add_fileset_file mentor/stratixv_hssi_atoms_ncrypt.v              VERILOG_ENCRYPT PATH verilog/mentor/stratixv_hssi_atoms_ncrypt.v       MENTOR_SPECIFIC
      add_fileset_file synopsys/stratixv_hssi_atoms_ncrypt.v            VERILOG_ENCRYPT PATH verilog/synopsys/stratixv_hssi_atoms_ncrypt.v     SYNOPSYS_SPECIFIC
      add_fileset_file cadence/stratixv_hssi_atoms_ncrypt.v             VERILOG_ENCRYPT PATH verilog/cadence/stratixv_hssi_atoms_ncrypt.v      CADENCE_SPECIFIC
      add_fileset_file aldec/stratixv_hssi_atoms_ncrypt.v               VERILOG_ENCRYPT PATH verilog/aldec/stratixv_hssi_atoms_ncrypt.v        ALDEC_SPECIFIC
      # Use testbench EP BFM
      add_fileset_file altpcietb_bfm_top_ep.v                           VERILOG PATH verilog/altpcietb_bfm_top_ep.v
      add_fileset_file altpcietb_bfm_ep_example_chaining_pipen1b.v      VERILOG PATH verilog/altpcietb_bfm_ep_example_chaining_pipen1b.v
      add_fileset_file altpcietb_bfm_driver_rp.v                        VERILOG PATH verilog/altpcietb_bfm_driver_rp.v
      add_fileset_file altpcietb_bfm_vc_intf_64.v                       VERILOG PATH verilog/altpcietb_bfm_vc_intf_64.v
      add_fileset_file altpcietb_bfm_vc_intf_128.v                      VERILOG PATH verilog/altpcietb_bfm_vc_intf_128.v
   }



#  Adding sim scripts
#   add_fileset_file pcie_sim_script/pcie_mti_setup.tcl OTHER PATH verilog/pcie_mti_setup.tcl
}

proc proc_sim_vhdl {name} {
}


