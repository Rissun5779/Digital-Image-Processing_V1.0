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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 16.0
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204_tx_mlpcs
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B MegaCore Function"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B TX MLPCS"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true


########################
# Declare the callbacks
######################## 
set_module_property ELABORATION_CALLBACK my_elaboration_callback

########################
# Add fileset
########################
add_fileset synth2 QUARTUS_SYNTH synthproc
add_fileset sim_verilog SIM_VERILOG verilogsimproc
add_fileset sim_vhdl SIM_VHDL vhdlsimproc

set_fileset_property synth2 TOP_LEVEL altera_jesd204_tx_mlpcs
set_fileset_property sim_verilog TOP_LEVEL altera_jesd204_tx_mlpcs
set_fileset_property sim_vhdl TOP_LEVEL altera_jesd204_tx_mlpcs


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../top/altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_tx_mlpcs_hw


##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
proc my_elaboration_callback {} {
   set d_L [get_parameter_value "L"]
   set d_PMA_WIDTH [get_parameter_value "PMA_WIDTH"]
   set d_SER_SIZE [get_parameter_value "SER_SIZE"]

#  common_add_optional_conduit    { port_name   signal_type   port_dir   width  vhdl_type  used   terminate }    
   common_add_optional_conduit 	   txlink_clk 		       export 	input 1   std    true 0
   common_add_optional_conduit 	   txlink_rst_n 	       export 	input 1   std    true 0
   common_add_optional_conduit 	   jesd204_tx_pcs_data         export 	input $d_L*32   vector   true 0
   common_add_optional_conduit     jesd204_tx_pcs_kchar_data   export 	input $d_L*4    vector   true 0
   common_add_optional_conduit     csr_lane_polarity           export 	input $d_L      vector   true 0
   common_add_optional_conduit     csr_bit_reversal	       export 	input 1   std    true 0
   common_add_optional_conduit     csr_byte_reversal	       export 	input 1   std    true 0
   common_add_optional_conduit     csr_lane_powerdown          export   input $d_L  vector  true 0	

  #PHY interfaces
   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      common_add_optional_conduit     txphy_clk             [expr {[device_is_vseries]? "tx_std_clkout" : "export"}]  input   $d_L   vector   true  0
      common_add_optional_conduit     tx_parallel_data      tx_parallel_data   output  $d_L*$d_PMA_WIDTH   vector   true 0
      common_add_optional_conduit     tx_datak              tx_datak           output  $d_L*$d_SER_SIZE    vector   true 0
      common_add_optional_conduit     phy_lane_polarity     [expr {[device_is_vseries]? "tx_std_polinv" : "tx_polinv"}]  output  $d_L   vector   true 0
      common_add_optional_conduit     csr_pcfifo_full       export             output  $d_L                vector   true 1
      common_add_optional_conduit     csr_pcfifo_empty      export             output  $d_L                vector   true 1 

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      common_add_optional_conduit     txphy_clk             [expr {[device_is_vseries]? "tx_10g_clkout" : "export"}]  input   $d_L   vector   true  0
      common_add_optional_conduit     tx_parallel_data      tx_parallel_data   output  $d_L*$d_PMA_WIDTH   vector   true 0
      common_add_optional_conduit     tx_datak              tx_datak           output  $d_L*$d_SER_SIZE    vector   true 1
      common_add_optional_conduit     phy_lane_polarity     tx_std_polinv      output  $d_L                vector   true 1
      common_add_optional_conduit     csr_pcfifo_full       export             output  $d_L                vector   true 1
      common_add_optional_conduit     csr_pcfifo_empty      export             output  $d_L                vector   true 1 

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} {
      common_add_optional_conduit     txphy_clk             [expr {[device_is_vseries]? "tx_pma_clkout" : "export"}]  input   $d_L   vector   true  0
      common_add_optional_conduit     tx_parallel_data      tx_pma_parallel_data   output  $d_L*$d_PMA_WIDTH   vector   true 0
      common_add_optional_conduit     tx_datak              tx_datak           output  $d_L*$d_SER_SIZE    vector   true 1
      common_add_optional_conduit     phy_lane_polarity     tx_std_polinv      output  $d_L                vector   true 1

      # adding ports for CFG4
      common_add_optional_conduit     csr_pcfifo_full   export   output   $d_L  vector  true 0
      common_add_optional_conduit     csr_pcfifo_empty  export   output   $d_L  vector  true 0 
   } 
}

#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------
global env
proc common_fileset {language gensim simulator} {
	global env
	set qdir $env(QUARTUS_ROOTDIR)
	set topdir "${qdir}/../ip/altera/altera_jesd204/src/top"
	set tmpdir "."
	
   if {[string compare -nocase ${simulator} synopsys] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "synopsys"
       set simulator_specific "SYNOPSYS_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} mentor] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "mentor"
       set simulator_specific "MENTOR_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} cadence] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "cadence"
       set simulator_specific "CADENCE_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} aldec] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "aldec"
       set simulator_specific "ALDEC_SPECIFIC"
   } else { 
       #for synthesis
       set filekind "VERILOG"
       set filekind_systemverilog "SYSTEMVERILOG"
       set simulator_path "."
       set simulator_specific ""
   } 

    # Top level - verilog file
    add_fileset_file ${simulator_path}/altera_jesd204_tx_mlpcs.v      $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_tx_mlpcs.v $simulator_specific  

    # source files for jesd204 tx
    add_fileset_file ${simulator_path}/altera_jesd204_8b10b_enc.v     $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_8b10b_enc.v $simulator_specific   
    add_fileset_file ${simulator_path}/altera_jesd204_tx_pcs.v        $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_tx_pcs.v $simulator_specific  
    add_fileset_file ${simulator_path}/altera_jesd204_wys_lut.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_wys_lut.v $simulator_specific     
    add_fileset_file ${simulator_path}/altera_jesd204_xn_8b10b_enc.v  $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_xn_8b10b_enc.v $simulator_specific 
    if {[ get_parameter_value DATA_PATH ] == "TX" || [ get_parameter_value DATA_PATH ] == "RX_TX"} {
       add_fileset_file ${simulator_path}/altera_jesd204_pcfifo.v        $filekind PATH ${tmpdir}/../lib/pcfifo/${simulator_path}/altera_jesd204_pcfifo.v $simulator_specific 
       add_fileset_file ${simulator_path}/altera_jesd204_mixed_width_dcfifo.v     $filekind PATH ${tmpdir}/../lib/pcfifo/${simulator_path}/altera_jesd204_mixed_width_dcfifo.v $simulator_specific 
    }

    # Add SDC, OCP and debug_stp files for Synthesis
    #-----------------------------------
    # Terp for SDC file
    #-----------------------------------
    if {[param_matches wrapper_opt "phy"] || [param_matches wrapper_opt "base_phy"] } {
       set margin [get_parameter_value sdc_constraint]
       #Set up Terp Variables
       set g_device_family [get_parameter_value DEVICE_FAMILY]
       set g_wrapper_opt [ get_parameter_value wrapper_opt ]
       set g_DATA_PATH   [ get_parameter_value DATA_PATH ]
       set g_REFCLK_FREQ   [ get_parameter_value d_refclk_freq ]
       set g_lane_rate  [ get_parameter_value lane_rate ]
       set g_TEST_COMPONENTS_EN  [ get_parameter_value TEST_COMPONENTS_EN ]
       set g_pcs_config  [ get_parameter_value PCS_CONFIG ]
       set g_reconfig_en  [ get_parameter_value pll_reconfig_enable ]
       set g_rcfg_shared  [ get_parameter_value rcfg_shared ]
       set g_L  [ get_parameter_value L ]
       set refclk_period_ns  [format %0.3f [expr { 1000.000/[extract_Int_frm_str $g_REFCLK_FREQ]}] ]
       set linkclk_period_ns  [format %0.3f [expr {40.000*1000/($g_lane_rate*$margin)}] ]
       # Set avs_clk = 125MHz * sdc_constraint
       set avsclk_period_ns  [format %0.3f [expr {1000.000/(125*$margin)}] ]
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG4"]} {
          set phyclk_period_ns [expr {$linkclk_period_ns*2}]
       } else {
          set phyclk_period_ns $linkclk_period_ns         
       }
 

       #Do Terp
       set template_file [ file join $topdir "altera_jesd204.sdc.terp" ]  
       set template   [ read [ open $template_file r ] ]
       set params(device_family) $g_device_family
       set params(wrapper) $g_wrapper_opt  
       set params(data_path) $g_DATA_PATH
       set params(test_components_en) $g_TEST_COMPONENTS_EN
       set params(pcs_config) $g_pcs_config
       set params(reconfig_en) $g_reconfig_en
       set params(rcfg_shared) $g_rcfg_shared
       set params(L) $g_L
       set params(refclk_period_ns) $refclk_period_ns
       set params(linkclk_period_ns) $linkclk_period_ns
       set params(avsclk_period_ns) $avsclk_period_ns
       set params(phyclk_period_ns) $phyclk_period_ns
       set result   [ altera_terp $template params ]

       if {[string compare -nocase ${simulator} synthesis] == 0} {
          if {$g_DATA_PATH == "TX"} {
             add_fileset_file altera_jesd204.sdc SDC TEXT $result $simulator_specific
             if { $g_device_family == "Arria 10" } {
                add_fileset_file debug/stp/README.txt OTHER PATH ../lib/debug_stp/README.txt
                add_fileset_file debug/stp/build_stp.tcl OTHER PATH ../lib/debug_stp/build_stp.tcl
                add_fileset_file debug/stp/jesd204b_base_phy_simplex.xml OTHER PATH ../lib/debug_stp/jesd204b_base_phy_simplex.xml.txt
             }
          } elseif {$g_DATA_PATH == "RX_TX"} {
             add_fileset_file altera_jesd204.sdc SDC TEXT $result $simulator_specific
             if { $g_device_family == "Arria 10" } {
                add_fileset_file debug/stp/README.txt OTHER PATH ../lib/debug_stp/README.txt
                add_fileset_file debug/stp/build_stp.tcl OTHER PATH ../lib/debug_stp/build_stp.tcl
                add_fileset_file debug/stp/jesd204b_base_phy_duplex.xml OTHER PATH ../lib/debug_stp/jesd204b_base_phy_duplex.xml.txt
             }
          }
          # OCP file
          add_fileset_file altera_jesd204_tx_mlpcs.ocp OTHER PATH ${tmpdir}/${simulator_path}/altera_jesd204_tx_mlpcs.ocp $simulator_specific	  
       } 
    }

}

#------------------------------------------------------------------------
# 4. Customer Demo Testbench
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 5. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset "verilog" 0 synthesis
   
}

proc verilogsimproc {name} {

    if {1} {
    common_fileset "verilog" 1 mentor
    }
    if {1} {
    common_fileset "verilog" 1 synopsys
    }
    if {1} {
    common_fileset "verilog" 1 cadence
    }
    if {1} {
    common_fileset "verilog" 1 aldec
    }

}

proc vhdlsimproc {name} {
 
    if {1} {
    common_fileset "vhdl" 1 mentor
    }
    if {1} {
    common_fileset "vhdl" 1 synopsys
    }
    if {1} {
    common_fileset "vhdl" 1 cadence
    }
    if {1} {
    common_fileset "vhdl" 1 aldec
    }

 
} 
