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




package provide altera_pcie_s10_hip_ast::fileset 18.1

package require alt_xcvr::ip_tcl::ip_module
package require altera_pcie_s10_hip_ast::parameters

package require altera_terp

namespace eval ::altera_pcie_s10_hip_ast::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets

  set filesets {\
    { NAME            TYPE            CALLBACK                                                       TOP_LEVEL                  }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_pcie_s10_hip_ast::fileset::callback_quartus_synth     altera_pcie_s10_hip_ast  }\
    { sim_verilog     SIM_VERILOG     ::altera_pcie_s10_hip_ast::fileset::callback_sim_verilog       altera_pcie_s10_hip_ast  }\
    { sim_vhdl        SIM_VHDL        ::altera_pcie_s10_hip_ast::fileset::callback_sim_vhdl          altera_pcie_s10_hip_ast  }\
    { example_design  EXAMPLE_DESIGN  ::altera_pcie_s10_hip_ast::fileset::callback_example_design    altera_pcie_s10_hip_ast  }\
  }

}

proc ::altera_pcie_s10_hip_ast::fileset::declare_filesets {} {
   variable filesets
   declare_tb_partner
   ip_declare_filesets $filesets
}

proc ::altera_pcie_s10_hip_ast::fileset::declare_tb_partner {} {
   set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_s10_tbed
   set_module_assignment testbench.partner.pcie_tb.version 18.1
   set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial
}


proc ::altera_pcie_s10_hip_ast::fileset::callback_quartus_synth {output_name} {
    ::altera_pcie_s10_hip_common::quartus_synth_common_fileset
}

proc ::altera_pcie_s10_hip_ast::fileset::callback_sim_verilog {output_name} {
    ::altera_pcie_s10_hip_common::sim_verilog_common_fileset
}


proc ::altera_pcie_s10_hip_ast::fileset::callback_sim_vhdl {output_name} {
    ::altera_pcie_s10_hip_common::sim_vhdl_common_fileset
}



proc ::altera_pcie_s10_hip_ast::fileset::callback_example_design {ip_name} {
    ::altera_pcie_s10_hip_ast::dynamic_example_design
}


proc ::altera_pcie_s10_hip_ast::fileset::declare_pllnphy_fileset {} {
    ::altera_pcie_s10_hip_common::declare_pllnphy_fileset
}




proc ::altera_pcie_s10_hip_ast::dynamic_example_design {} {

   send_message info "Auto-generation of QSYS example design parameter checking"

   set virtual_link_width_integer_hwtcl     [ip_get "parameter.virtual_link_width_integer_hwtcl.value"]
   set virtual_rp_ep_mode_integer_hwtcl     [ip_get "parameter.virtual_rp_ep_mode_integer_hwtcl.value"]
   set virtual_link_rate_integer_hwtcl      [ip_get "parameter.virtual_link_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]

   # This block of code uses these unique variables; we'll initialize those here
   set strInterfaceType  ""
   set intInterfaceWidth ""
   set strPortType       ""
   set strParamValue     ""
   set strParamValue     ""
   set strDesignName     ""
   set strBaseDesign     ""
   set strGenerationPossible "True"
   set strParameterException ""

   #####################################################################
   # BEGIN
   # Example design Parameter Exception
   # Step 1; let's determine what the Interface type (AvST, AVMM)
   #
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   set ACDSVERSION 18.1
   foreach param $nf_hip_parameters {
      set strParamName ${param}
      set strParamValue [ip_get "parameter.${param}.value"]
      set intInterfaceWidth "256"

      if {$strParamName=="interface_type_hwtcl"} {
         set strInterfaceType $strParamValue
      }
      if {$strParamName=="port_type_hwtcl"} {
         set strPortType $strParamValue
      }
      #Check exception parameters that will cause the generated example designs to fail.  The current list of
      #exceptions includes the following parameters and values:

      #1.  "Enable byte parity ports on Avalon-ST interface":  use_ast_parity_hwtcl = 1
      if {$strParamName=="use_ast_parity_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strParameterException "${strParameterException} Enable byte parity ports on Avalon-ST interface"
         set strGenerationPossible "False"
      }

      #2 "Enable dynamic reconfiguration of PCIe read-only registers":  hip_reconfig_hwtcl = 1
      if {$strParamName=="hip_reconfig_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException " ${strParameterException} Enable dynamic reconfiguration of PCIe read-only registers"
      }
      #3   "Implement MSI-X" : enable_function_msix_support_hwtcl = 1
      if {$strParamName=="enable_function_msix_support_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Implement MSI-X"
      }
   }
   # Example design Parameter Exception
   # END
   #####################################################################


   set valid_design_example [ ::altera_pcie_s10_hip_ast::validate_design_example ]
   #Note:  In the standard message window, 60characters can be seen on the first line and 89 characters on the following lines.


   if {$strGenerationPossible=="False"} {

      global env
      set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
      set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
      send_message error "The example design cannot be generated with the following parameter settings: <br/>
      ${strParameterException}."
                send_message info "To obtain an example design please disable the invalid option(s) and try again.  <br/>
                Alternatively, you can select an example design from one of several available in the ACDS Installation <br/>
                Directory here: ${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_s10_ed/example_design/s10.  <br/>
                Information on using those designs can be found in the IP QuickStart/IP User Guide."

   } elseif { $valid_design_example != 1 } {
      send_message error "$valid_design_example"
   } else {
      ::altera_pcie_s10_hip_ast::generate_dynamic_qsys
   }

}


proc ::altera_pcie_s10_hip_ast::validate_design_example {} {

   send_message info "Validating example design selection"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set data_width_integer_hwtcl     [ip_get "parameter.data_width_integer_hwtcl.value"]
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]

   set valid 1
   set recommend_design "PIO"
   # Validate Example design TAB
   if { $interface_type_hwtcl == "Avalon-ST" } {
      if { $data_width_integer_hwtcl == 256 } {
         if { $select_design_example_hwtcl == "DMA" }  {
            set valid 0
            set recommend_design "PIO"
         }
         }
   }
   if { $valid == 0 } {
      return "Please select ${recommend_design} from the \"Available example designs\", the $select_design_example_hwtcl example design is not available when selecting \"Application interface type\"=$interface_type_hwtcl and \"Application data width\"= $data_width_integer_hwtcl bit."
   } else {
      return $valid
   }
}


proc ::altera_pcie_s10_hip_ast::generate_dynamic_qsys {} {

   send_message info "Auto-generation of QSYS example design in progress based on variant parameter settings"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set data_width_integer_hwtcl     256
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]

   set virtual_link_width_integer_hwtcl     [ip_get "parameter.virtual_link_width_integer_hwtcl.value"]
   set virtual_rp_ep_mode_integer_hwtcl     [ip_get "parameter.virtual_rp_ep_mode_integer_hwtcl.value"]
   set virtual_link_rate_integer_hwtcl      [ip_get "parameter.virtual_link_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]

   set pld_clk_mhz_integer_hwtcl    [ip_get "parameter.pld_clk_mhz_integer_hwtcl.value"]
   set targeted_devkit_hwtcl        [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set pf0_bar2_type_integer_hwtcl      [ip_get "parameter.pf0_bar2_type_integer_hwtcl.value"]
   set pf0_bar2_address_width_hwtcl  7
   set ACDSVERSION 18.1


   # QSYS script to auto-generate QSYS system
   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set QSYSTemName "pcie_example_design"
   set QSYSTem "${QSYSTemName}.qsys"
   set QSYSTemPath "${TEMPPATH}${QSYSTem}"
   set QSYSScript "pcie_example_design.tcl"
   set QSYSScriptCC "pcie_example_design_cc.tcl"
   set QSYSScriptPath "${TEMPPATH}${QSYSScript}"
   set QSYSScriptBACKUPPath "${TEMPPATH}${QSYSScriptCC}"

   # Corrected variant parameter
   set enable_avst_reset_hwtcl 1

   if { [ file exist $QSYSScriptPath ] == 1 } {
      file delete $QSYSScriptPath
   }

   set ScriptFile [open $QSYSScriptPath "w"]
   catch { cd $TEMPPATH}

   set instance "DUT"
   set DeviceQSF "ND5_40_PART1"


   puts $ScriptFile "package require -exact qsys 16.0"
   puts $ScriptFile "set qsys_system ${QSYSTem}"
   puts $ScriptFile "set_project_property DEVICE_FAMILY {Stratix 10}"
   puts $ScriptFile "set_project_property DEVICE ${DeviceQSF}"

   if { $interface_type_hwtcl == "Avalon-ST" } {
      puts $ScriptFile "# Adding Avalon-ST Stratix 10 PCIe IP"
      puts $ScriptFile "add_instance ${instance} altera_pcie_s10_hip_ast"
   } elseif { $interface_type_hwtcl == "Avalon-MM" } {
      puts $ScriptFile "# Adding Avalon-ST Stratix 10 PCIe IP"
      puts $ScriptFile "add_instance ${instance} altera_pcie_s10_hip_avmm_bridge"
   } else {}



   puts $ScriptFile "# Setting Parameters to Stratix 10 PCIe IP"
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   set use_tx_cons_cred_sel_hwtcl 0
   set enable_avst_reset_hwtcl 0
   set bar2_address_width_hwtcl 0
   set bar0_type_hwtcl "Disabled"
   set internal_controller_hwtcl 0
   foreach param $nf_hip_parameters {
      set derived [ ip_get "parameter.${param}.DERIVED" ]
      if { $derived == 0 } {
         set value [ip_get "parameter.${param}.value"]
         puts $ScriptFile "set_instance_parameter_value ${instance} ${param} {${value}}"
         if { [ regexp enable_avst_reset_hwtcl $param ] } {
            set enable_avst_reset_hwtcl $value
         }
         if { [ regexp bar2_address_width_hwtcl $param ] } {
            set bar2_address_width_hwtcl $value
         }
         if { [ regexp bar0_type_hwtcl $param ] } {
            set bar0_type_hwtcl $value
         }
         if { [ regexp use_tx_cons_cred_sel_hwtcl $param ] } {
            set use_tx_cons_cred_sel_hwtcl $value
         }
      }
   }

   puts $ScriptFile "# Enabling Devkit component to support Stratix FPGA Development kit"
   puts $ScriptFile "#add_instance DK altpcie_devkit"
   puts $ScriptFile "#add_interface          board_pins conduit end"
   puts $ScriptFile ""

   puts $ScriptFile "# PCIe serial/pipe interface"
   puts $ScriptFile "add_interface          refclk clock end"
   puts $ScriptFile "set_interface_property refclk EXPORT_OF ${instance}.refclk"
   puts $ScriptFile "add_interface          pcie_rstn conduit end"
   puts $ScriptFile "set_interface_property pcie_rstn EXPORT_OF ${instance}.npor"
   puts $ScriptFile "add_interface          xcvr conduit end"
   puts $ScriptFile "set_interface_property xcvr EXPORT_OF ${instance}.hip_serial"
   puts $ScriptFile "add_interface          pipe_sim_only conduit end"
   puts $ScriptFile "set_interface_property pipe_sim_only EXPORT_OF ${instance}.hip_pipe"
   puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 3"



   if { $interface_type_hwtcl == "Avalon-ST" } {
      puts $ScriptFile "#set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "add_interface          currentspeed conduit end"
      puts $ScriptFile "set_interface_property currentspeed EXPORT_OF ${instance}.currentspeed"
      # Exception common code
      if { $enable_avst_reset_hwtcl == 0 } {
         ::altera_pcie_s10_hip_common::alteracion_ed_message "the option \"Enable Avalon-ST Reset output port\" is enabled when using the Avalon-ST Interface"
         puts $ScriptFile "set_instance_parameter_value ${instance} enable_avst_reset_hwtcl 1"
      }
      if { $use_tx_cons_cred_sel_hwtcl == 1 } {
         ::altera_pcie_s10_hip_common::alteracion_ed_message "the option \"Enable credit consumed selection port\" is disabled when using the Avalon-ST Interface"
         puts $ScriptFile "set_instance_parameter_value ${instance} use_tx_cons_cred_sel_hwtcl 0"
      }

         puts $ScriptFile "add_instance APPS s10_ast2avmm_bridge_256"
         for { set i 0 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.pf0_bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar $i
            break
            }
         }

         puts $ScriptFile "set_instance_parameter_value APPS BAR_NUMBER                {${bar}}"
         puts $ScriptFile "set_instance_parameter_value APPS BAR_SIZE_MASK             {12}"
         puts $ScriptFile "set_instance_parameter_value APPS BAR_TYPE                  {0}"
         puts $ScriptFile "set_instance_parameter_value APPS BURST_COUNT_WIDTH         {6}"
         puts $ScriptFile "set_instance_parameter_value APPS DBUS_WIDTH                {256}"
         puts $ScriptFile "set_instance_parameter_value APPS ENABLE_CRA                {0}"
         puts $ScriptFile "set_instance_parameter_value APPS ENABLE_TXS                {0}"
         puts $ScriptFile "set_instance_parameter_value APPS PORT_TYPE                 {Native endpoint}"
         puts $ScriptFile "set_instance_parameter_value APPS TX_S_ADDR_WIDTH           {32}"

         puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
         puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
         puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {Stratix 10}         "
         puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
         puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
         puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {8192}             "
         puts $ScriptFile "set_instance_parameter_value MEM readDuringWriteMode        {DONT_CARE}        "
         puts $ScriptFile "set_instance_parameter_value MEM resetrequest_enabled       {true}             "
         puts $ScriptFile "set_instance_parameter_value MEM singleClockOperation       {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM slave1Latency              {2}                "
         puts $ScriptFile "set_instance_parameter_value MEM slave2Latency              {1}                "
         puts $ScriptFile "set_instance_parameter_value MEM useNonDefaultInitFile      {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM useShallowMemBlocks        {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM writable                   {true}             "

         puts $ScriptFile ""
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip APPS.pld_clk"
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
         puts $ScriptFile "add_connection ${instance}.hip_rst APPS.hip_rst"
         puts $ScriptFile "add_connection ${instance}.hip_status APPS.hip_status"
         puts $ScriptFile "add_connection ${instance}.currentspeed APPS.currentspeed"
         puts $ScriptFile "add_connection ${instance}.rx_st APPS.rx_st_hip"
         puts $ScriptFile "add_connection ${instance}.clr_st APPS.clr_st"
         puts $ScriptFile "add_connection ${instance}.clr_st MEM.reset1"
         puts $ScriptFile "add_connection ${instance}.rx_bar APPS.rx_bar"
         puts $ScriptFile "add_connection ${instance}.tx_cred APPS.tx_cred"
         puts $ScriptFile "add_connection ${instance}.int_msi APPS.int_msi"
         puts $ScriptFile "add_connection ${instance}.power_mgnt APPS.power_mgnt"
         puts $ScriptFile "add_connection ${instance}.config_tl APPS.config_tl"
         puts $ScriptFile "add_connection APPS.tx_st_hip ${instance}.tx_st"
         puts $ScriptFile "add_connection APPS.hprxm MEM.s1"
         set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
         if { $dynamic_reconfig ==1 } {
               puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
               puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
         }

   }


   puts $ScriptFile "#set_interface_property board_pins EXPORT_OF DK.dk_board"
   puts $ScriptFile "#add_connection DK.dk_hip ${instance}.dk_hip"
   puts $ScriptFile "#add_connection ${instance}.coreclkout_hip DK.clock"

   puts $ScriptFile "auto_assign_system_base_addresses"
   puts $ScriptFile "remove_dangling_connections"
   send_message info "save_system ${QSYSTem}"
   puts $ScriptFile "save_system ${QSYSTem}"
   close $ScriptFile


   global env
   set QSYS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set QSYS_ROOTDIR "${QSYS_ROOTDIR}/sopc_builder/bin/"

   if { [ file exist $QSYSScriptPath ] == 1 } {
      if { [ file exist ${QSYSScriptBACKUPPath}  ] == 1 } {
         file delete ${QSYSScriptBACKUPPath}
      }
      file copy ${QSYSScriptPath} ${QSYSScriptBACKUPPath}
      send_message info "Generating QSYS system ${QSYSTem}"
      send_message info "Running: qsys-script --pro --script=${QSYSScript}"
      set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --pro --script=${QSYSScriptPath}"]
   } else {
      send_message error "ERROR:Unable to locate ${QSYSScriptPath}"
   }
   catch { cd $ORIDIR}
   if { [ file exist $QSYSTemPath ] == 1 } {
      file delete ${QSYSScriptPath}
      if { [ file exist ${QSYSScriptBACKUPPath}  ] == 1 } {
         file copy ${QSYSScriptBACKUPPath} ${QSYSScriptPath}
         file delete ${QSYSScriptBACKUPPath}
      }
      ::altera_pcie_s10_hip_ast::generate_design_example_files  ${QSYSTemPath} ${QSYSTemName}
   } else {
      add_fileset_file ${QSYSScript} OTHER PATH ${QSYSScriptPath}
      send_message info "Unable to create ${QSYSTem}"
      send_message info "Copied ${QSYSScript} in the example design directory, exiting ........."
   }
}


proc ::altera_pcie_s10_hip_ast::generate_design_example_files { qsys_design_example_fullpath exdes_prj } {

   global env
   set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
   set IP_ROOTDIR "${IP_ROOTDIR}/../ip"

   send_message info "Fileset generation"

   set ed_qii_hwtcl           1
   set ed_synth_hwtcl         [ip_get "parameter.enable_example_design_synth_hwtcl.value"]
   set targeted_devkit_hwtcl  [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set ed_tb_hwtcl            [ip_get "parameter.enable_example_design_tb_hwtcl.value"   ]
   set ed_sim_hwtcl           [ip_get "parameter.enable_example_design_sim_hwtcl.value"  ]

   if { $ed_sim_hwtcl >0 } {
      send_message info "Generating the example design simulation files"
      set ed_tb_hwtcl  1
   } else {
      send_message info "Skip the generation of the example design simulation files"
      set ed_tb_hwtcl  0
   }

   if { $ed_synth_hwtcl >0 } {
      send_message info "Generating the example design synthesis files"
   } else {
      send_message info "Skip the generation of the example synthesis simulation files"
   }

   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set s10pcie_devkit_prj "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_s10_ed/example_design/s10-pcie-devkit-prj.tcl"
   #
   # Copy QSYS system and qshell/qsys script to temp directory
   #
   if { [ file exist $qsys_design_example_fullpath ] == 0 } {
      file copy "${qsys_design_example_fullpath}"  "${TEMPPATH}/${exdes_prj}.qsys"
   }
   send_message info "Targeting Stratix 10 FPGA Development kit ...."
   #::altera_pcie_s10_hip::fileset::check_support_hw_s10_devkit
   set DeviceQSF "ND5_40_PART1"

   #
   # Generate required file in Temp directory
   #
   catch { cd $TEMPPATH}
   #
   # Generate required file in Temp directory
   #
   set    GScript [open "${exdes_prj}_script.sh" w]
   puts  $GScript "#################################################################################################"
   puts  $GScript "#                                                                                       "
   puts  $GScript "# Generate quartus project from a QSYS file                                             "
   puts  $GScript "quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   puts  $GScript "#                                                                                       "
   puts  $GScript "# IP Upgrade                                                                            "
   puts  $GScript "quartus_sh --ip_upgrade -variation_files ${exdes_prj}.qsys ${exdes_prj}                 "
   puts  $GScript "#                                                                                       "
   puts  $GScript "# Compile generate QUARTUS project                                                      "
   puts  $GScript "quartus_sh --flow compile ${exdes_prj}.qpf                                              "
   puts  $GScript "#                                                                                       "
   close $GScript
   send_message info "Running: quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   set foo [catch  "exec quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"]
   set FAILGEN "${TEMPPATH}/${exdes_prj}_fail.txt"

   if { [ file exist $FAILGEN ] == 1 } {
      add_fileset_file ${exdes_prj}.qsys OTHER PATH ${qsys_design_example_fullpath}
      send_message info "adding ${exdes_prj}.qsys"
      send_message error "Unable to generate HDL files for the system ${exdes_prj}.qsys "
   } else {
      # Copy all generated file to the example design user directory
      #
      ::altera_pcie_s10_hip_ast::fileset::add_files_recursive [ pwd ]
   }
   catch { cd $ORIDIR}
}












proc ::altera_pcie_s10_hip_ast::fileset::filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

proc ::altera_pcie_s10_hip_ast::fileset::filedelete { item } {
   if { [ file exist $item ] == 1 } {
      file delete $item
   }
}

proc ::altera_pcie_s10_hip_ast::fileset::folder_worker { item } {
   foreach top_item [glob -directory [file join [pwd] $item] -tails *] {
      set relative_item [file join $item $top_item]
      set absolute_path [file join [pwd] $relative_item]
      if {[file isdirectory $relative_item] == 1 } {
         ::altera_pcie_s10_hip_ast::fileset::folder_worker $relative_item
      } else {
         add_fileset_file $relative_item [ ::altera_pcie_s10_hip_ast::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $relative_item "
      }
   }
}



proc ::altera_pcie_s10_hip_ast::fileset::add_files_recursive { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      if {[file isdirectory $top_item] == 1 } {
         ::altera_pcie_s10_hip_ast::fileset::folder_worker $top_item
      } else {
         add_fileset_file $top_item [ ::altera_pcie_s10_hip_ast::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $top_item "
      }
   }
   cd $old_path
}

proc ::altera_pcie_s10_hip_ast::fileset::empty_dir { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      file delete -force $absolute_path
   }
   cd $old_path
}

