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


package provide altera_pcie_s10_hip_common 18.1

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_ast/nd/tcl/ct1_hssi_parameters.tcl
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_ast/nd/tcl/ct1_hssi_common_util.tcl
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_ast/nd/tcl/ct1_hssi_x16_pcie_rbc.tcl





namespace eval ::altera_pcie_s10_hip_common::parameters {

variable parameters
set parameters {\
{NAME                                             DERIVED AFFECTS_VALIDATION  HDL_PARAMETER           TYPE      DEFAULT_VALUE                   ALLOWED_RANGES                                                                                                                                   ENABLED                                  VISIBLE                               DISPLAY_HINT  DISPLAY_UNITS    DISPLAY_ITEM                                  DISPLAY_NAME                                                            VALIDATION_CALLBACK                                                               DESCRIPTION }\
    {device_family                                    false   true                false                   STRING    "Stratix 10"                    {"Stratix 10"}                                                                                                                                 true                                     false                                                                                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                                            NOVAL}\
    {base_device                                      false   true                false                   STRING    "Unknown"                       NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   ::altera_pcie_s10_hip_common::parameters::validate_base_device                           NOVAL}\
    {part_trait_device                                false   true                false                   STRING    "Unknown"                       NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                           NOVAL}\
    {design_environment                               false   true                false                   STRING    "Unknown"                       NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                                                          NOVAL}\
    {device                                           false   true                false                   STRING    "Unknown"                       NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         NOVAL                                         NOVAL                                                                   NOVAL                           NOVAL}\
\
    {select_design_example_hwtcl                      false   true                false                   STRING    "PIO"                           { "PIO"  "DMA"}                                                                                                                                          true                                     true                                  NOVAL         NOVAL         "Available Example Designs"                    "Select design"                                                         NOVAL                                                                                                                                               "When selecting DMA, a direct memory access application will be used in the autogenerated example design, showing PCI Express upstream and downstream transactions. When selecting PIO, a target application will be used in the auto-generated example design, showing PCI Express downstream transactions." }\
    {enable_example_design_qii_hwtcl                  false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                 boolean       NOVAL         "Example Design Files"                         "Generate a Quartus Project that includes the example design"           NOVAL                                                                             "When on, generate a Quartus Project that includes the example design" }\
    {enable_example_design_sim_hwtcl                  false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     true                                  boolean       NOVAL         "Example Design Files"                         "Simulation"                                                            NOVAL                                                                             "When Simulation box is checked, all necessary filesets required for simulation will be generated. When this box is NOT checked, No  filesets required for Simulation  will be NOT generated. Instead a qsys example design system will be generated." }\
    {enable_example_design_synth_hwtcl                false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     true                                  boolean       NOVAL         "Example Design Files"                         "Synthesis"                                                             NOVAL                                                                             "When Synthesis box is checked, all necessary filesets required for synthesis will be generated. When Synthesis box is NOT checked, No  filesets required for Synthesis will be NOT generated. Instead a qsys example design system will be generated." }\
    {enable_example_design_tb_hwtcl                   false   true                false                   INTEGER   1                               NOVAL                                                                                                                                          true                                     false                                 boolean       NOVAL         "Example Design Files"                         "Generate the example design testbench"                                 NOVAL                                                                             "When Simulation box is checked, all necessary filesets required for simulation will be generated. When this box is NOT checked, No  filesets required for Simulation  will be NOT generated. Instead a qsys example design system will be generated." }\
    {apps_type_hwtcl                                  false   true                false                   INTEGER   0                               NOVAL                                                                                                                                          true                                     false                                 NOVAL         NOVAL         "Example Designs"                              "Set apps_type_hwtcl BFM driver value"                                  NOVAL                                                                             "When on, override the default testbench partner apps_type_hwtcl bfm " }\
    {select_design_example_rtl_lang_hwtcl             false   true                false                   STRING    "Verilog"                       { "Verilog" }                                                                                                                                  true                                     true                                  NOVAL         NOVAL         "Generated HDL Format"                         "Generated File Format"                                                 NOVAL                                                                             "HDL format" }\
    {targeted_devkit_hwtcl                            false   true                false                   STRING    "NONE"                          { "NONE" }                                                                                                                                     true                                     true                                  NOVAL         NOVAL         "Target Development Kit"                       "Select board"                                                          NOVAL                                                                             "This option provides supports for various Development Kits listed. The details of Altera Development kits can be found on Altera website https://www.altera.com/products/boards_and_kits/all-development-kits.html. If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. If an Altera Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit" }\
}


proc ::altera_pcie_s10_hip_common::parameters::validate_base_device { PROP_NAME PROP_VALUE } {
   if { [string compare -nocase $PROP_VALUE "unknown"] == 0 } {
      send_message error "The current selected base_device \"$PROP_VALUE\" is invalid, please select a valid device to generate the IP."
   }
}


}


proc ::altera_pcie_s10_hip_common::quartus_synth_common_fileset { } {
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   set verilog_files { "altera_pcie_s10_hip_ast.v"
                       "altera_pcie_s10_hip_ast_pipen1b.v"
                       "altera_pcie_s10_hip_ast_pllnphy.v"
                       "altera_pcie_s10_reset_delay_sync.v"
                       "altera_pcie_s10_sc_bitsync.v"
   }

   foreach vf $verilog_files {
      add_fileset_file  $vf   VERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_ast/$vf
   }
   set std_sync_path [file join .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
   add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path

}

proc ::altera_pcie_s10_hip_common::sim_verilog_common_fileset { } {
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   set verilog_files { "altera_pcie_s10_hip_ast.v"
                       "altera_pcie_s10_hip_ast_pipen1b.v"
                       "altera_pcie_s10_hip_ast_pllnphy.v"
                       "altera_pcie_s10_reset_delay_sync.v"
                       "altera_pcie_s10_sc_bitsync.v"
   }



   foreach vf $verilog_files {
      add_fileset_file  $vf   VERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_ast/$vf
   }
   set std_sync_path [file join .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
   add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path


}

proc ::altera_pcie_s10_hip_common::sim_vhdl_common_fileset { } {

   ::altera_pcie_s10_hip_common::sim_verilog_common_fileset

}




proc ::altera_pcie_s10_hip_common::declare_pllnphy_fileset { } {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set virtual_link_width_hwtcl                       [ip_get "parameter.virtual_link_width_hwtcl.value"]
   set virtual_link_rate_hwtcl                        [ip_get "parameter.virtual_link_rate_hwtcl.value"]
   set device_family                                  [ip_get "parameter.device_family.value"]
   set device                                         [ip_get "parameter.device.value"]
   set base_device                                    [ip_get "parameter.base_device.value"]
   set design_environment                             [ip_get "parameter.design_environment.value"]

##### Create PHY instance #####
   #  See : //depot/ip/pci_express/custom_designs/a10/phyip/make_fileset.sh
   #
  if { [regexp Gen1 $virtual_link_rate_hwtcl] &&  [regexp x16 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g1x16 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g1x16 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g1 USED_CHANNELS 16 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x16 $param $val
      }
   }  elseif { [regexp Gen1 $virtual_link_rate_hwtcl] &&  [regexp x1 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g1x1 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g1x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g1 USED_CHANNELS 1 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x1 $param $val
      }
   }  elseif { [regexp Gen1 $virtual_link_rate_hwtcl] &&  [regexp x2 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g1x2 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g1x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g1 USED_CHANNELS 2 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x2 $param $val
      }
   }  elseif { [regexp Gen1 $virtual_link_rate_hwtcl] &&  [regexp x4 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g1x4 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g1x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g1 USED_CHANNELS 4 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x4 $param $val
      }
   }  elseif { [regexp Gen1 $virtual_link_rate_hwtcl] &&  [regexp x8 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g1x8 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g1x8 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g1 USED_CHANNELS 8 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x8 $param $val
      }
   }  elseif { [regexp Gen2 $virtual_link_rate_hwtcl] &&  [regexp x16 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g2x16 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g2x16 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g2 USED_CHANNELS 16 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x16 $param $val
      }
   }  elseif { [regexp Gen2 $virtual_link_rate_hwtcl] &&  [regexp x1 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g2x1 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g2x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g2 USED_CHANNELS 1 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x1 $param $val
      }
   }  elseif { [regexp Gen2 $virtual_link_rate_hwtcl] &&  [regexp x2 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g2x2 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g2x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g2 USED_CHANNELS 2 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x2 $param $val
      }
   }  elseif { [regexp Gen2 $virtual_link_rate_hwtcl] &&  [regexp x4 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g2x4 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g2x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g2 USED_CHANNELS 4 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x4 $param $val
      }
   }  elseif { [regexp Gen2 $virtual_link_rate_hwtcl] &&  [regexp x8 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g2x8 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g2x8 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g2 USED_CHANNELS 8 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x8 $param $val
      }
   } elseif { [regexp Gen3 $virtual_link_rate_hwtcl] &&  [regexp x16 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g3x16 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g3x16 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g3 USED_CHANNELS 16 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x16 $param $val
      }
   }  elseif { [regexp Gen3 $virtual_link_rate_hwtcl] &&  [regexp x1 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g3x1 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g3x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g3 USED_CHANNELS 1 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x1 $param $val
      }
   }  elseif { [regexp Gen3 $virtual_link_rate_hwtcl] &&  [regexp x2 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g3x2 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g3x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g3 USED_CHANNELS 2 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x2 $param $val
      }
   }  elseif { [regexp Gen3 $virtual_link_rate_hwtcl] &&  [regexp x4 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g3x4 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g3x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g3 USED_CHANNELS 4 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x4 $param $val
      }
   }  elseif { [regexp Gen3 $virtual_link_rate_hwtcl] &&  [regexp x8 $virtual_link_width_hwtcl] } {
      add_hdl_instance phy_g3x8 altera_xcvr_pcie_hip_native_s10
      set_instance_property phy_g3x8 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list HIP_PROTOCOL_MODE pipe_g3 USED_CHANNELS 8 device_family $device_family device $device base_device $base_device design_environment $design_environment ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x8 $param $val
      }
   }



   # TODO HACK: Set the PROT MODE:
   set lcl_pll_ip_prot_mode "3"
   if { [regexp Gen1 $virtual_link_rate_hwtcl] } {
     set lcl_pll_ip_prot_mode "1"
   }
   if { [regexp Gen2 $virtual_link_rate_hwtcl] } {
     set lcl_pll_ip_prot_mode "2"
   }


   # PLL instantiation
   ##### Create PLL instance #####
   if { [regexp Gen1 $virtual_link_rate_hwtcl] || [regexp Gen2 $virtual_link_rate_hwtcl] }  {

      if { [regexp x16 $virtual_link_width_hwtcl] } {
       add_hdl_instance fpll_g1g2xn altera_xcvr_fpll_s10
       set param_val_list [list device_family $device_family set_primary_use 2 set_enable_hclk_out 1 enable_hip_cal_done_port 1 set_hip_cal_en 1 set_prot_mode $lcl_pll_ip_prot_mode set_output_clock_frequency 2500.0 enable_mcgb 1 enable_mcgb_hip_cal_done_port 1 enable_bonding_clks 1 enable_mcgb_pcie_clksw 1 pma_width 10 base_device $base_device enable_pcie_hip_connectivity 1]
       foreach {param val} $param_val_list {
          set_instance_parameter_value fpll_g1g2xn $param $val
       }
     } elseif { [regexp x1 $virtual_link_width_hwtcl] } {
       add_hdl_instance fpll_g1g2x1 altera_xcvr_fpll_s10
       set param_val_list [list device_family $device_family set_primary_use 2 set_enable_hclk_out 1 enable_hip_cal_done_port 1 set_hip_cal_en 1 set_prot_mode $lcl_pll_ip_prot_mode set_output_clock_frequency 2500.0 base_device $base_device enable_pcie_hip_connectivity 1]
       foreach {param val} $param_val_list {
          set_instance_parameter_value fpll_g1g2x1 $param $val
       }
     } else {
       add_hdl_instance fpll_g1g2xn altera_xcvr_fpll_s10
       set param_val_list [list device_family $device_family set_primary_use 2 set_enable_hclk_out 1 enable_hip_cal_done_port 1 set_hip_cal_en 1 set_prot_mode $lcl_pll_ip_prot_mode set_output_clock_frequency 2500.0 enable_mcgb 1 enable_mcgb_hip_cal_done_port 1 enable_bonding_clks 1 enable_mcgb_pcie_clksw 1 pma_width 10 base_device $base_device enable_pcie_hip_connectivity 1]
       foreach {param val} $param_val_list {
          set_instance_parameter_value fpll_g1g2xn $param $val
       }
     }
   } elseif { [regexp Gen3 $virtual_link_rate_hwtcl] } {

      # FPLL
      add_hdl_instance fpll_g3 altera_xcvr_fpll_s10
      set param_val_list [list device_family $device_family set_primary_use 2 set_enable_hclk_out 1 enable_hip_cal_done_port 1 set_hip_cal_en 1 set_prot_mode 3 set_output_clock_frequency 2500.0 base_device $base_device enable_pcie_hip_connectivity 1]
      foreach {param val} $param_val_list {
         set_instance_parameter_value fpll_g3 $param $val
      }

      if { [regexp x16 $virtual_link_width_hwtcl] } {
         # ATX PLL
         add_hdl_instance lcpll_g3xn altera_xcvr_atx_pll_s10
         set param_val_list [list prot_mode {PCIe Gen 3} set_auto_reference_clock_frequency 100.0 enable_8G_path 0 bw_sel high enable_pcie_clk 1 enable_mcgb 1 set_output_clock_frequency 4000.0 enable_mcgb_pcie_clksw 1 mcgb_aux_clkin_cnt 1 enable_bonding_clks 1 pma_width 32 enable_hip_cal_done_port 1 set_hip_cal_en 1 base_device $base_device enable_pcie_hip_connectivity 1]
         foreach {param val} $param_val_list {
            set_instance_parameter_value lcpll_g3xn $param $val
         }
      } elseif { [regexp x1 $virtual_link_width_hwtcl] } {
         # ATX PLL
         add_hdl_instance lcpll_g3x1 altera_xcvr_atx_pll_s10
         set param_val_list [list prot_mode {PCIe Gen 3} set_auto_reference_clock_frequency 100.0 bw_sel high enable_pcie_clk 1 set_output_clock_frequency 4000.0 enable_hip_cal_done_port 1 set_hip_cal_en 1 base_device $base_device enable_pcie_hip_connectivity 1]
         foreach {param val} $param_val_list {
            set_instance_parameter_value lcpll_g3x1 $param $val
         }
      } else {
         # ATX PLL
         add_hdl_instance lcpll_g3xn altera_xcvr_atx_pll_s10
         set param_val_list [list prot_mode {PCIe Gen 3} set_auto_reference_clock_frequency 100.0 enable_8G_path 0 bw_sel high enable_pcie_clk 1 enable_mcgb 1 set_output_clock_frequency 4000.0 enable_mcgb_pcie_clksw 1 mcgb_aux_clkin_cnt 1 enable_bonding_clks 1 pma_width 32 enable_hip_cal_done_port 1 set_hip_cal_en 1 base_device $base_device enable_pcie_hip_connectivity 1]
         foreach {param val} $param_val_list {
            set_instance_parameter_value lcpll_g3xn $param $val
         }
      }
   }


}



proc ::altera_pcie_s10_hip_common::parameters::get_parameters {} {
   variable parameters
   return $parameters
}




