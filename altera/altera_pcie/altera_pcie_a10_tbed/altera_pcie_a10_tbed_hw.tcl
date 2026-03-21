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
source tbed_pcie_a10_parameters.tcl
source tbed_pcie_a10_port.tcl

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_a10_tbed
set_module_property VERSION 18.1
set_module_property DESCRIPTION "Testbench for Avalon-Streaming Arria 10 hard IP for PCI Express"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_s5_pcie.pdf"                                    ;#TODO
set_module_property GROUP "Interface Protocols/PCI Express"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Testbench for Avalon-Streaming Arria 10 hard IP for PCI Express"
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
add_documentation_link "User guide" http://www.altera.com/literature/ug/ug_a10_pcie.pdf
add_documentation_link "Release Notes:" http://www.altera.com/literature/rn/ip/#other_ip.html
add_documentation_link "Application Note" http://www.altera.com/literature/an/an690.pdf
add_documentation_link "Application note" http://www.altera.com/literature/an/an456.pdf

# # +-----------------------------------
# # | Example design RTL files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcie_a10_tbed_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcie_a10_tbed_hwtcl

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

    ##if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
       ##set_module_assignment postgeneration.pcie_tb.device_family "STRATIX V"
    ##} else {
    ##   set_module_assignment postgeneration.pcie_tb.device_family "STRATIX IV"
    ##}

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
   set set_bfm_driver_to_rp_avmm                15

   set encrypted_files { "stratixv_hssi_atoms.v" "stratixv_pcie_hip_atoms.v" "pcie_stratixv_hssi_atoms.v" "pcie_stratixv_pcie_hip_atoms.v" }

   add_fileset_file altpcietb_ltssm_mon.v                VERILOG PATH verilog/altpcietb_ltssm_mon.v
   add_fileset_file altpcietb_pipe_phy.v                 VERILOG PATH verilog/altpcietb_pipe_phy.v
   add_fileset_file altpcietb_pipe32_hip_interface.v     VERILOG PATH verilog/altpcietb_pipe32_hip_interface.v
   add_fileset_file altpcietb_pipe32_driver.v            VERILOG PATH verilog/altpcietb_pipe32_driver.v
   add_fileset_file altpcie_a10_tbed_hwtcl.v             VERILOG PATH altpcie_a10_tbed_hwtcl.v
   add_fileset_file altpcietb_bfm_log.v                  VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v
   add_fileset_file altpcietb_bfm_configure.v            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v
   add_fileset_file altpcietb_bfm_constants.v            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v
   add_fileset_file altpcietb_bfm_rdwr.v                 VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v
   add_fileset_file altpcietb_bfm_req_intf.v             VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v
   add_fileset_file altpcietb_bfm_shmem.v                VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v
   add_fileset_file altpcietb_bfm_tlp_inspector.v        VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v

   add_fileset_file stratixiv_hssi_atoms.v                VERILOG PATH verilog/stratixiv_hssi_atoms.v      
   add_fileset_file stratixiv_pcie_hip_atoms.v            VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v 
   add_fileset_file altera_avalon_packets_to_master.v     VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/altera_avalon_packets_to_master.v
   add_fileset_file pcie_example_design_master_0.v        VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v

   foreach enc_file $encrypted_files {
    if {[file exist "mentor/verilog/${enc_file}"]} {
      add_fileset_file mentor/${enc_file}                 VERILOG_ENCRYPT PATH mentor/verilog/${enc_file}               MENTOR_SPECIFIC
    }

    if {[file exist "synopsys/verilog/${enc_file}"]} {
      add_fileset_file synopsys/${enc_file}                 VERILOG_ENCRYPT PATH synopsys/verilog/${enc_file}               SYNOPSYS_SPECIFIC
    }

    if {[file exist "cadence/verilog/${enc_file}"]} {
      add_fileset_file cadence/${enc_file}                 VERILOG_ENCRYPT PATH cadence/verilog/${enc_file}               CADENCE_SPECIFIC
    }

    if {[file exist "aldec/verilog/${enc_file}"]} {
      add_fileset_file aldec/${enc_file}                 VERILOG_ENCRYPT PATH aldec/verilog/${enc_file}               ALDEC_SPECIFIC
    }
   }

   if { [ regexp endpoint $port_type_hwtcl ] || $apps_type_hwtcl == 15 } {
      if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] || $apps_type_hwtcl == 15 } {
         # Use testbench BFM Gen3 x8
         add_fileset_file altpcietb_bfm_top_rp.v                VERILOG PATH verilog/altpcietb_bfm_top_rp.v
         add_fileset_file altpcietb_g3bfm_log.v                 VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v
         add_fileset_file altpcietb_g3bfm_configure.v           VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v
         add_fileset_file altpcietb_g3bfm_constants.v           VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v
         add_fileset_file altpcietb_g3bfm_rdwr.v                VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v
         add_fileset_file altpcietb_g3bfm_req_intf.v            VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v
         add_fileset_file altpcietb_g3bfm_shmem.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v
         add_fileset_file altpcietb_g3bfm_vc_intf_ast_common.v  VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v
         if { $apps_type_hwtcl == 15 || $apps_type_hwtcl ==  3 || $apps_type_hwtcl ==  4 || $apps_type_hwtcl == 5 || $apps_type_hwtcl == 6 || ($apps_type_hwtcl ==  $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target) }  {
            add_fileset_file altpcierd_tl_cfg_sample.v          VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v
            add_fileset_file altpcied_a10_hwtcl.sv              SYSTEMVERILOG PATH ../altera_pcie_a10_ed/altpcied_a10_hwtcl.sv
         }
         if { $apps_type_hwtcl == 15 } {
	    add_fileset_file altpcierd_cplerr_lmi.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v
            add_fileset_file altpcierd_ast256_downstream.v      VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v
	 }
         if { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
            add_fileset_file altpcietb_bfm_cfbp.v               VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
            add_fileset_file altpcietb_bfm_rp_gen3_x8_cfgbp.sv  SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8_cfgbp.sv
         } else { 
            add_fileset_file altpcietb_bfm_rp_gen3_x8.sv        SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv
         }

      } else {
         # For pipe simulation
         add_fileset_file sv_xcvr.sv                                       SYSTEMVERILOG PATH verilog/sv_xcvr.sv
         # Use testbench BFM Gen2 x8
         add_fileset_file altpcietb_bfm_top_rp.v                           VERILOG PATH verilog/altpcietb_bfm_top_rp.v
         add_fileset_file altpcietb_bfm_rp_gen2_x8.v                       VERILOG PATH verilog/altpcietb_bfm_rp_gen2_x8.v
         if { $apps_type_hwtcl == $set_bfm_driver_to_config_target } {
           add_fileset_file altpcietb_bfm_driver_downstream.v              VERILOG PATH verilog/altpcietb_bfm_driver_downstream.v
         } elseif { $apps_type_hwtcl == 4 || $apps_type_hwtcl == 5 } {
           add_fileset_file altpcietb_bfm_driver_avmm.v                    VERILOG PATH verilog/altpcietb_bfm_driver_avmm.v
         } elseif { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
           add_fileset_file altpcietb_bfm_cfbp.v                           VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
           add_fileset_file altpcietb_bfm_driver_cfgbp.v                   VERILOG PATH  ../altera_pcie_hip_ast_ed/altera_pcie_cfgbp_ed/sim_bfm/altpcietb_bfm_driver_cfgbp.v
         } elseif { $apps_type_hwtcl == $set_bfm_driver_to_simple_ep_downstream } {
           add_fileset_file altpcietb_bfm_driver_simple_ep_downstream.v    VERILOG PATH  verilog/altpcietb_bfm_driver_simple_ep_downstream.v
         } else {
            add_fileset_file altpcietb_bfm_driver_chaining.v               VERILOG PATH verilog/altpcietb_bfm_driver_chaining.v
         }
      }
   } else {

      #add_fileset_file stratixiv_hssi_atoms.v                           VERILOG PATH verilog/stratixiv_hssi_atoms.v
      #add_fileset_file stratixiv_pcie_hip_atoms.v                       VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v
      # For pipe simulation
      add_fileset_file sv_xcvr.sv                                       SYSTEMVERILOG PATH verilog/sv_xcvr.sv
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

   set encrypted_files { "stratixv_hssi_atoms.v" "stratixv_pcie_hip_atoms.v" "pcie_stratixv_hssi_atoms.v" "pcie_stratixv_pcie_hip_atoms.v" }

   add_fileset_file stratixiv_hssi_atoms.v                VERILOG PATH verilog/stratixiv_hssi_atoms.v     
   add_fileset_file stratixiv_pcie_hip_atoms.v            VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v

   foreach enc_file $encrypted_files {
    if {[file exist "mentor/verilog/${enc_file}"]} {
      add_fileset_file mentor/${enc_file}                 VERILOG_ENCRYPT PATH mentor/verilog/${enc_file}               MENTOR_SPECIFIC
    }

    if {[file exist "synopsys/verilog/${enc_file}"]} {
      add_fileset_file synopsys/${enc_file}                 VERILOG_ENCRYPT PATH synopsys/verilog/${enc_file}               SYNOPSYS_SPECIFIC
    }

    if {[file exist "cadence/verilog/${enc_file}"]} {
      add_fileset_file cadence/${enc_file}                 VERILOG_ENCRYPT PATH cadence/verilog/${enc_file}               CADENCE_SPECIFIC
    }

    if {[file exist "aldec/verilog/${enc_file}"]} {
      add_fileset_file aldec/${enc_file}                 VERILOG_ENCRYPT PATH aldec/verilog/${enc_file}               ALDEC_SPECIFIC
    }
   }

   #MENTOR Specific Files
   if {1} {
      add_fileset_file mentor/altpcietb_ltssm_mon.v                          VERILOG         PATH verilog/altpcietb_ltssm_mon.v                          MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_pipe_phy.v                           VERILOG         PATH verilog/altpcietb_pipe_phy.v                           MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_pipe32_hip_interface.v               VERILOG         PATH verilog/altpcietb_pipe32_hip_interface.v               MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_pipe32_driver.v                      VERILOG         PATH verilog/altpcietb_pipe32_driver.v                      MENTOR_SPECIFIC
      add_fileset_file mentor/altpcie_a10_tbed_hwtcl.v                       VERILOG         PATH altpcie_a10_tbed_hwtcl.v                               MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_log.v                            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v                                   MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_configure.v                      VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v                             MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_constants.v                      VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v                             MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_rdwr.v                           VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v                                  MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_req_intf.v                       VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v                              MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_shmem.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v                                 MENTOR_SPECIFIC
      add_fileset_file mentor/altpcietb_bfm_tlp_inspector.v                  VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v                         MENTOR_SPECIFIC
      add_fileset_file altera_avalon_packets_to_master.v  VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/altera_avalon_packets_to_master.v MENTOR_SPECIFIC
      add_fileset_file pcie_example_design_master_0.v     VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v MENTOR_SPECIFIC


      if { [ regexp endpoint $port_type_hwtcl ] || $apps_type_hwtcl == 15 } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] || $apps_type_hwtcl == 15 } {
            # Use testbench BFM Gen3 x8
            add_fileset_file mentor/altpcietb_bfm_top_rp.v                   VERILOG         PATH verilog/altpcietb_bfm_top_rp.v                         MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_log.v                    VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v                                 MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_configure.v              VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v                           MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_constants.v              VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v                           MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_rdwr.v                   VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v                                MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_req_intf.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v                            MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_shmem.v                  VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v                               MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_g3bfm_vc_intf_ast_common.v     VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v                  MENTOR_SPECIFIC
            if { $apps_type_hwtcl == 15 || $apps_type_hwtcl ==  4 || $apps_type_hwtcl == 5 || $apps_type_hwtcl == 6 || ($apps_type_hwtcl ==  $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target) }  {
               add_fileset_file mentor/altpcierd_tl_cfg_sample.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v        MENTOR_SPECIFIC
               add_fileset_file mentor/altpcied_a10_hwtcl.sv                 SYSTEMVERILOG PATH ../altera_pcie_a10_ed/altpcied_a10_hwtcl.sv                                          MENTOR_SPECIFIC
            }
            if { $apps_type_hwtcl == 15 } {
               add_fileset_file altpcierd_cplerr_lmi.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v  MENTOR_SPECIFIC
               add_fileset_file altpcierd_ast256_downstream.v      VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v  MENTOR_SPECIFIC
            }
            if { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
               add_fileset_file altpcietb_bfm_cfbp.v                         VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
               add_fileset_file mentor/altpcietb_bfm_rp_gen3_x8_cfgbp.sv     SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8_cfgbp.sv                           MENTOR_SPECIFIC
            } else {
               add_fileset_file mentor/altpcietb_bfm_rp_gen3_x8.sv           SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv                           MENTOR_SPECIFIC
            }
         } else {
            # For pipe simulation
            add_fileset_file mentor/sv_xcvr.sv                               SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                              MENTOR_SPECIFIC
            # Use testbench BFM Gen2 x8
            add_fileset_file mentor/altpcietb_bfm_top_rp.v                   VERILOG PATH verilog/altpcietb_bfm_top_rp.v                         MENTOR_SPECIFIC
            add_fileset_file mentor/altpcietb_bfm_rp_gen2_x8.v               VERILOG PATH verilog/altpcietb_bfm_rp_gen2_x8.v                     MENTOR_SPECIFIC
            if { $apps_type_hwtcl == $set_bfm_driver_to_config_target } {
              add_fileset_file mentor/altpcietb_bfm_driver_downstream.v      VERILOG PATH verilog/altpcietb_bfm_driver_downstream.v                             MENTOR_SPECIFIC
            } elseif { $apps_type_hwtcl == 4 || $apps_type_hwtcl == 5 } {
              add_fileset_file mentor/altpcietb_bfm_driver_avmm.v            VERILOG PATH verilog/altpcietb_bfm_driver_avmm.v                                   MENTOR_SPECIFIC
            } elseif { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
              add_fileset_file altpcietb_bfm_cfbp.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
              add_fileset_file altpcietb_bfm_driver_cfgbp.v                  VERILOG PATH  ../altera_pcie_hip_ast_ed/altera_pcie_cfgbp_ed/sim_bfm/altpcietb_bfm_driver_cfgbp.v      MENTOR_SPECIFIC
            } else {
              add_fileset_file mentor/altpcietb_bfm_driver_chaining.v        VERILOG PATH verilog/altpcietb_bfm_driver_chaining.v                               MENTOR_SPECIFIC
            }
         }
      } else {
         # For pipe simulation
         add_fileset_file mentor/sv_xcvr.sv                                  SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                              MENTOR_SPECIFIC
         # Use testbench EP BFM
         add_fileset_file mentor/altpcietb_bfm_top_ep.v                      VERILOG         PATH verilog/altpcietb_bfm_top_ep.v                         MENTOR_SPECIFIC
         add_fileset_file mentor/altpcietb_bfm_ep_example_chaining_pipen1b.v VERILOG         PATH verilog/altpcietb_bfm_ep_example_chaining_pipen1b.v    MENTOR_SPECIFIC
         add_fileset_file mentor/altpcietb_bfm_driver_rp.v                   VERILOG         PATH verilog/altpcietb_bfm_driver_rp.v                      MENTOR_SPECIFIC
         add_fileset_file mentor/altpcietb_bfm_vc_intf_64.v                  VERILOG         PATH verilog/altpcietb_bfm_vc_intf_64.v                            MENTOR_SPECIFIC
         add_fileset_file mentor/altpcietb_bfm_vc_intf_128.v                 VERILOG         PATH verilog/altpcietb_bfm_vc_intf_128.v                    MENTOR_SPECIFIC
      }
   }

      #SYNOPSYS Specific Files
      add_fileset_file synopsys/altpcietb_ltssm_mon.v                          VERILOG         PATH verilog/altpcietb_ltssm_mon.v                               SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_pipe_phy.v                           VERILOG         PATH verilog/altpcietb_pipe_phy.v                                SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_pipe32_hip_interface.v               VERILOG         PATH verilog/altpcietb_pipe32_hip_interface.v                    SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_a10_tbed_hwtcl.v                       VERILOG         PATH altpcie_a10_tbed_hwtcl.v                                    SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_log.v                            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v                                 SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_configure.v                      VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v                           SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_constants.v                      VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v                           SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_rdwr.v                           VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v                                SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_req_intf.v                       VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v                            SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_shmem.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v                               SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_bfm_tlp_inspector.v                  VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v                       SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcietb_pipe32_driver.v                      VERILOG         PATH verilog/altpcietb_pipe32_driver.v                           SYNOPSYS_SPECIFIC
      add_fileset_file altera_avalon_packets_to_master.v  VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/altera_avalon_packets_to_master.v SYNOPSYS_SPECIFIC
      add_fileset_file pcie_example_design_master_0.v     VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v SYNOPSYS_SPECIFIC



      if { [ regexp endpoint $port_type_hwtcl ] || $apps_type_hwtcl == 15 } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] || $apps_type_hwtcl == 15 } {
            # Use testbench BFM Gen3 x8
            add_fileset_file synopsys/altpcietb_bfm_top_rp.v                   VERILOG         PATH verilog/altpcietb_bfm_top_rp.v                              SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_log.v                    VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v                               SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_configure.v              VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v                         SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_constants.v              VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v                         SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_rdwr.v                   VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v                              SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_req_intf.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v                          SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_shmem.v                  VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v                             SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_g3bfm_vc_intf_ast_common.v     VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v                SYNOPSYS_SPECIFIC
            if { $apps_type_hwtcl == 15 || $apps_type_hwtcl ==  4 || $apps_type_hwtcl == 5 || $apps_type_hwtcl == 6 || ($apps_type_hwtcl ==  $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target) }  {
               add_fileset_file synopsys/altpcierd_tl_cfg_sample.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v       SYNOPSYS_SPECIFIC
               add_fileset_file synopsys/altpcied_a10_hwtcl.sv                  SYSTEMVERILOG PATH ../altera_pcie_a10_ed/altpcied_a10_hwtcl.sv                                        SYNOPSYS_SPECIFIC
            }
            if { $apps_type_hwtcl == 15 } {
               add_fileset_file altpcierd_cplerr_lmi.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v SYNOPSYS_SPECIFIC
               add_fileset_file altpcierd_ast256_downstream.v      VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v SYNOPSYS_SPECIFIC
            }
            if { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
               add_fileset_file altpcietb_bfm_cfbp.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
               add_fileset_file synopsys/altpcietb_bfm_rp_gen3_x8_cfgpb.sv    SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8_cfgbp.sv                         SYNOPSYS_SPECIFIC
            } else {
               add_fileset_file synopsys/altpcietb_bfm_rp_gen3_x8.sv          SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv                         SYNOPSYS_SPECIFIC
            }
         } else {
            #add_fileset_file synopsys/stratixiv_hssi_atoms.v                   VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      SYNOPSYS_SPECIFIC
            #add_fileset_file synopsys/stratixiv_pcie_hip_atoms.v               VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  SYNOPSYS_SPECIFIC
            # For pipe simulation
            add_fileset_file synopsys/sv_xcvr.sv                               SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                            SYNOPSYS_SPECIFIC
            # Use testbench BFM Gen2 x8
            add_fileset_file synopsys/altpcietb_bfm_top_rp.v                   VERILOG PATH verilog/altpcietb_bfm_top_rp.v                                      SYNOPSYS_SPECIFIC
            add_fileset_file synopsys/altpcietb_bfm_rp_gen2_x8.v               VERILOG PATH verilog/altpcietb_bfm_rp_gen2_x8.v                                  SYNOPSYS_SPECIFIC
            if { $apps_type_hwtcl == 3 } {
               add_fileset_file synopsys/altpcietb_bfm_driver_downstream.v     VERILOG PATH verilog/altpcietb_bfm_driver_downstream.v                           SYNOPSYS_SPECIFIC
            } elseif { $apps_type_hwtcl == 4 || $apps_type_hwtcl == 5 } {
               add_fileset_file synopsys/altpcietb_bfm_driver_avmm.v           VERILOG PATH verilog/altpcietb_bfm_driver_avmm.v                                 SYNOPSYS_SPECIFIC
            } elseif { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
              add_fileset_file altpcietb_bfm_cfbp.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
              add_fileset_file altpcietb_bfm_driver_cfgbp.v                  VERILOG PATH  ../altera_pcie_hip_ast_ed/altera_pcie_cfgbp_ed/sim_bfm/altpcietb_bfm_driver_cfgbp.v      SYNOPSYS_SPECIFIC
            } else {
               add_fileset_file synopsys/altpcietb_bfm_driver_chaining.v       VERILOG PATH verilog/altpcietb_bfm_driver_chaining.v                             SYNOPSYS_SPECIFIC
            }
         }
      } else {
         #add_fileset_file synopsys/stratixiv_hssi_atoms.v                      VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      SYNOPSYS_SPECIFIC
         #add_fileset_file synopsys/stratixiv_pcie_hip_atoms.v                  VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  SYNOPSYS_SPECIFIC
         # For pipe simulation
         add_fileset_file synopsys/sv_xcvr.sv                                  SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                            SYNOPSYS_SPECIFIC
         # Use testbench EP BFM
         add_fileset_file synopsys/altpcietb_bfm_top_ep.v                      VERILOG PATH verilog/altpcietb_bfm_top_ep.v                                      SYNOPSYS_SPECIFIC
         add_fileset_file synopsys/altpcietb_bfm_ep_example_chaining_pipen1b.v VERILOG PATH verilog/altpcietb_bfm_ep_example_chaining_pipen1b.v                 SYNOPSYS_SPECIFIC
         add_fileset_file synopsys/altpcietb_bfm_driver_rp.v                   VERILOG PATH verilog/altpcietb_bfm_driver_rp.v                                   SYNOPSYS_SPECIFIC
         add_fileset_file synopsys/altpcietb_bfm_vc_intf_64.v                  VERILOG PATH verilog/altpcietb_bfm_vc_intf_64.v                                  SYNOPSYS_SPECIFIC
         add_fileset_file synopsys/altpcietb_bfm_vc_intf_128.v                 VERILOG PATH verilog/altpcietb_bfm_vc_intf_128.v                                 SYNOPSYS_SPECIFIC
      }

      #CADENCE Specific Files
      add_fileset_file cadence/altpcietb_ltssm_mon.v                           VERILOG         PATH verilog/altpcietb_ltssm_mon.v                               CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_pipe_phy.v                            VERILOG         PATH verilog/altpcietb_pipe_phy.v                                CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_pipe32_hip_interface.v                VERILOG         PATH verilog/altpcietb_pipe32_hip_interface.v                    CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_pipe32_driver.v                       VERILOG         PATH verilog/altpcietb_pipe32_driver.v                           CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_a10_tbed_hwtcl.v                        VERILOG         PATH altpcie_a10_tbed_hwtcl.v                                    CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_log.v                             VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v                                 CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_configure.v                       VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v                           CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_constants.v                       VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v                           CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_rdwr.v                            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v                                CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_req_intf.v                        VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v                            CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_shmem.v                           VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v                               CADENCE_SPECIFIC
      add_fileset_file cadence/altpcietb_bfm_tlp_inspector.v                   VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v                       CADENCE_SPECIFIC
      add_fileset_file altera_avalon_packets_to_master.v  VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/altera_avalon_packets_to_master.v CADENCE_SPECIFIC
      add_fileset_file pcie_example_design_master_0.v     VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v CADENCE_SPECIFIC



      if { [ regexp endpoint $port_type_hwtcl ] || $apps_type_hwtcl == 15 } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] || $apps_type_hwtcl == 15 } {
            # Use testbench BFM Gen3 x8
            add_fileset_file cadence/altpcietb_bfm_top_rp.v                    VERILOG         PATH verilog/altpcietb_bfm_top_rp.v                              CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_log.v                     VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v                               CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_configure.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v                         CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_constants.v               VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v                         CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_rdwr.v                    VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v                              CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_req_intf.v                VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v                          CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_shmem.v                   VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v                             CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_g3bfm_vc_intf_ast_common.v      VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v                CADENCE_SPECIFIC
            if { $apps_type_hwtcl == 15 || $apps_type_hwtcl ==  4 || $apps_type_hwtcl == 5 || $apps_type_hwtcl == 6 || ($apps_type_hwtcl ==  $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target) }  {
               add_fileset_file cadence/altpcierd_tl_cfg_sample.v              VERILOG       PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v    CADENCE_SPECIFIC
               add_fileset_file cadence/altpcied_a10_hwtcl.sv                   SYSTEMVERILOG PATH ../altera_pcie_a10_ed/altpcied_a10_hwtcl.sv                                           CADENCE_SPECIFIC
            }
            if { $apps_type_hwtcl ==  15 } {
               add_fileset_file altpcierd_cplerr_lmi.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v CADENCE_SPECIFIC 
               add_fileset_file altpcierd_ast256_downstream.v      VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v CADENCE_SPECIFIC 
            }
            if { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
               add_fileset_file altpcietb_bfm_cfbp.v                         VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
               add_fileset_file cadence/altpcietb_bfm_rp_gen3_x8_cfgbp.sv    SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8_cfgbp.sv                         CADENCE_SPECIFIC
            } else {
               add_fileset_file cadence/altpcietb_bfm_rp_gen3_x8.sv          SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv                         CADENCE_SPECIFIC
            }
         } else {
            #add_fileset_file cadence/stratixiv_hssi_atoms.v                    VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      CADENCE_SPECIFIC
            #add_fileset_file cadence/stratixiv_pcie_hip_atoms.v                VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  CADENCE_SPECIFIC
            # For pipe simulation
            add_fileset_file cadence/sv_xcvr.sv                                SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                            CADENCE_SPECIFIC
            # Use testbench BFM Gen2 x8
            add_fileset_file cadence/altpcietb_bfm_top_rp.v                    VERILOG PATH verilog/altpcietb_bfm_top_rp.v                                      CADENCE_SPECIFIC
            add_fileset_file cadence/altpcietb_bfm_rp_gen2_x8.v                VERILOG PATH verilog/altpcietb_bfm_rp_gen2_x8.v                                  CADENCE_SPECIFIC
            if { $apps_type_hwtcl == 3 } {
               add_fileset_file cadence/altpcietb_bfm_driver_downstream.v      VERILOG PATH verilog/altpcietb_bfm_driver_downstream.v                           CADENCE_SPECIFIC
            } elseif { $apps_type_hwtcl == 4 || $apps_type_hwtcl == 5 } {
               add_fileset_file cadence/altpcietb_bfm_driver_avmm.v            VERILOG PATH verilog/altpcietb_bfm_driver_avmm.v                                 CADENCE_SPECIFIC
            } elseif { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
              add_fileset_file altpcietb_bfm_cfbp.v                            VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
              add_fileset_file altpcietb_bfm_driver_cfgbp.v                    VERILOG PATH  ../altera_pcie_hip_ast_ed/altera_pcie_cfgbp_ed/sim_bfm/altpcietb_bfm_driver_cfgbp.v      CADENCE_SPECIFIC
            } else {
               add_fileset_file cadence/altpcietb_bfm_driver_chaining.v        VERILOG PATH verilog/altpcietb_bfm_driver_chaining.v                             CADENCE_SPECIFIC
            }
         }
      } else {
         #add_fileset_file cadence/stratixiv_hssi_atoms.v                       VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      CADENCE_SPECIFIC
         #add_fileset_file cadence/stratixiv_pcie_hip_atoms.v                   VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  CADENCE_SPECIFIC
         # For pipe simulation
         add_fileset_file cadence/sv_xcvr.sv                                  SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                             CADENCE_SPECIFIC
         # Use testbench EP BFM
         add_fileset_file cadence/altpcietb_bfm_top_ep.v                       VERILOG PATH verilog/altpcietb_bfm_top_ep.v                                      CADENCE_SPECIFIC
         add_fileset_file cadence/altpcietb_bfm_ep_example_chaining_pipen1b.v  VERILOG PATH verilog/altpcietb_bfm_ep_example_chaining_pipen1b.v                 CADENCE_SPECIFIC
         add_fileset_file cadence/altpcietb_bfm_driver_rp.v                    VERILOG PATH verilog/altpcietb_bfm_driver_rp.v                                   CADENCE_SPECIFIC
         add_fileset_file cadence/altpcietb_bfm_vc_intf_64.v                   VERILOG PATH verilog/altpcietb_bfm_vc_intf_64.v                                  CADENCE_SPECIFIC
         add_fileset_file cadence/altpcietb_bfm_vc_intf_128.v                  VERILOG PATH verilog/altpcietb_bfm_vc_intf_128.v                                 CADENCE_SPECIFIC
      }


      add_fileset_file aldec/altpcietb_ltssm_mon.v                             VERILOG         PATH verilog/altpcietb_ltssm_mon.v                               ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_pipe_phy.v                              VERILOG         PATH verilog/altpcietb_pipe_phy.v                                ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_pipe32_hip_interface.v                  VERILOG         PATH verilog/altpcietb_pipe32_hip_interface.v                    ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_pipe32_driver.v                         VERILOG         PATH verilog/altpcietb_pipe32_driver.v                           ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_a10_tbed_hwtcl.v                          VERILOG         PATH altpcie_a10_tbed_hwtcl.v                                    ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_log.v                               VERILOG_INCLUDE PATH verilog/altpcietb_bfm_log.v                                 ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_configure.v                         VERILOG_INCLUDE PATH verilog/altpcietb_bfm_configure.v                           ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_constants.v                         VERILOG_INCLUDE PATH verilog/altpcietb_bfm_constants.v                           ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_rdwr.v                              VERILOG_INCLUDE PATH verilog/altpcietb_bfm_rdwr.v                                ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_req_intf.v                          VERILOG_INCLUDE PATH verilog/altpcietb_bfm_req_intf.v                            ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_shmem.v                             VERILOG_INCLUDE PATH verilog/altpcietb_bfm_shmem.v                               ALDEC_SPECIFIC
      add_fileset_file aldec/altpcietb_bfm_tlp_inspector.v                     VERILOG_INCLUDE PATH verilog/altpcietb_bfm_tlp_inspector.v                       ALDEC_SPECIFIC
      add_fileset_file altera_avalon_packets_to_master.v  VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/altera_avalon_packets_to_master.v ALDEC_SPECIFIC
      add_fileset_file pcie_example_design_master_0.v     VERILOG_INCLUDE PATH ../altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v ALDEC_SPECIFIC


      if { [ regexp endpoint $port_type_hwtcl ] || $apps_type_hwtcl == 15 } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] || $apps_type_hwtcl == 15 } {
            # Use testbench BFM Gen3 x8
            add_fileset_file aldec/altpcietb_bfm_top_rp.v                      VERILOG         PATH verilog/altpcietb_bfm_top_rp.v                              ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_log.v                       VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_log.v                               ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_configure.v                 VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_configure.v                         ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_constants.v                 VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_constants.v                         ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_rdwr.v                      VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_rdwr.v                              ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_req_intf.v                  VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_req_intf.v                          ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_shmem.v                     VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_shmem.v                             ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_g3bfm_vc_intf_ast_common.v        VERILOG_INCLUDE PATH verilog/altpcietb_g3bfm_vc_intf_ast_common.v                ALDEC_SPECIFIC
            if { $apps_type_hwtcl == 15 || $apps_type_hwtcl ==  4 || $apps_type_hwtcl == 5 || $apps_type_hwtcl == 6 }  {
               add_fileset_file aldec/altpcierd_tl_cfg_sample.v                VERILOG       PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v    ALDEC_SPECIFIC
               add_fileset_file aldec/altpcied_a10_hwtcl.sv                     SYSTEMVERILOG PATH ../altera_pcie_a10_ed/altpcied_a10_hwtcl.sv                                           ALDEC_SPECIFIC
            }
            if { $apps_type_hwtcl ==  15 } {
               add_fileset_file altpcierd_cplerr_lmi.v             VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_cplerr_lmi.v ALDEC_SPECIFIC
               add_fileset_file altpcierd_ast256_downstream.v      VERILOG PATH ../altera_pcie_a10_ed/example_design/verilog/chaining_dma/altpcierd_ast256_downstream.v ALDEC_SPECIFIC
            }
            if { ($apps_type_hwtcl == $set_bfm_driver_to_config_bypass) || ($apps_type_hwtcl == $set_bfm_driver_to_sriov_dma)|| ($apps_type_hwtcl == $set_bfm_driver_to_sriov_target)} {
               add_fileset_file altpcietb_bfm_cfbp.v                         VERILOG_INCLUDE PATH verilog/altpcietb_bfm_cfbp.v
               add_fileset_file aldec/altpcietb_bfm_rp_gen3_x8_cfgbp.sv        SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8_cfgbp.sv                         ALDEC_SPECIFIC
            } else {
               add_fileset_file aldec/altpcietb_bfm_rp_gen3_x8.sv              SYSTEMVERILOG   PATH verilog/altpcietb_bfm_rp_gen3_x8.sv                         ALDEC_SPECIFIC
            }
         } else {
            #add_fileset_file aldec/stratixiv_hssi_atoms.v                      VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      ALDEC_SPECIFIC
            #add_fileset_file aldec/stratixiv_pcie_hip_atoms.v                  VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  ALDEC_SPECIFIC
            # For pipe simulation
            add_fileset_file aldec/sv_xcvr.sv                                  SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                            ALDEC_SPECIFIC
            # Use testbench BFM Gen2 x8
            add_fileset_file aldec/altpcietb_bfm_top_rp.v                      VERILOG PATH verilog/altpcietb_bfm_top_rp.v                                      ALDEC_SPECIFIC
            add_fileset_file aldec/altpcietb_bfm_rp_gen2_x8.v                  VERILOG PATH verilog/altpcietb_bfm_rp_gen2_x8.v                                  ALDEC_SPECIFIC
            if { $apps_type_hwtcl == 3 } {
               add_fileset_file aldec/altpcietb_bfm_driver_downstream.v        VERILOG PATH verilog/altpcietb_bfm_driver_downstream.v                           ALDEC_SPECIFIC
            } elseif { $apps_type_hwtcl == 4 || $apps_type_hwtcl == 5 } {
               add_fileset_file aldec/altpcietb_bfm_driver_avmm.v              VERILOG PATH verilog/altpcietb_bfm_driver_avmm.v                                 ALDEC_SPECIFIC
            } else {
               add_fileset_file aldec/altpcietb_bfm_driver_chaining.v          VERILOG PATH verilog/altpcietb_bfm_driver_chaining.v                             ALDEC_SPECIFIC
            }
         }
      } else {
         #add_fileset_file aldec/stratixiv_hssi_atoms.v                         VERILOG PATH verilog/stratixiv_hssi_atoms.v                                      ALDEC_SPECIFIC
         #add_fileset_file aldec/stratixiv_pcie_hip_atoms.v                     VERILOG PATH verilog/stratixiv_pcie_hip_atoms.v                                  ALDEC_SPECIFIC
         # For pipe simulation
         add_fileset_file aldec/sv_xcvr.sv                                     SYSTEMVERILOG PATH verilog/sv_xcvr.sv                                            ALDEC_SPECIFIC
         # Use testbench EP BFM
         add_fileset_file aldec/altpcietb_bfm_top_ep.v                         VERILOG PATH verilog/altpcietb_bfm_top_ep.v                                      ALDEC_SPECIFIC
         add_fileset_file aldec/altpcietb_bfm_ep_example_chaining_pipen1b.v    VERILOG PATH verilog/altpcietb_bfm_ep_example_chaining_pipen1b.v                 ALDEC_SPECIFIC
         add_fileset_file aldec/altpcietb_bfm_driver_rp.v                      VERILOG PATH verilog/altpcietb_bfm_driver_rp.v                                   ALDEC_SPECIFIC
         add_fileset_file aldec/altpcietb_bfm_vc_intf_64.v                     VERILOG PATH verilog/altpcietb_bfm_vc_intf_64.v                                  ALDEC_SPECIFIC
         add_fileset_file aldec/altpcietb_bfm_vc_intf_128.v                    VERILOG PATH verilog/altpcietb_bfm_vc_intf_128.v                                 ALDEC_SPECIFIC
      }
}

