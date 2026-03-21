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
set_module_property NAME altera_jesd204_phy_adapter_xs_rcfg_shared_off
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B PHY Adapter for 10th Series"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B PHY Adapter XS RCFG_SHARED OFF"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
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


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../../top/altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_phy_adapter_hw 


set_fileset_property synth2       TOP_LEVEL altera_jesd204_phy_adapter_xs_rcfg_shared_off
set_fileset_property sim_verilog  TOP_LEVEL altera_jesd204_phy_adapter_xs_rcfg_shared_off
set_fileset_property sim_vhdl     TOP_LEVEL altera_jesd204_phy_adapter_xs_rcfg_shared_off

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Interface/Port
#------------------------------------------------------------------------
proc my_elaboration_callback {} {

   set reconfig_en [param_is_true "pll_reconfig_enable"]

   if {[param_matches DATA_PATH "TX" ]} {
      # tx_set_connections_xs <tx_enable>, 
      # if tx_enable = 1 : TX Interfaces & Ports  are exposed for connections
      # if tx_enable = 0 : Exposed TX Interfaces & Ports will be TERMINATED 
      # Likewise, for rx_set_connections
      tx_set_connections_xs 1
      rx_set_connections_xs 0
      xseries_avmm_adapter $reconfig_en
   } elseif {[param_matches DATA_PATH "RX" ]} {
      tx_set_connections_xs 0
      rx_set_connections_xs 1
      xseries_avmm_adapter $reconfig_en
   } elseif {[param_matches DATA_PATH "RX_TX" ]} {
      tx_set_connections_xs 1
      rx_set_connections_xs 1
      xseries_avmm_adapter $reconfig_en
   }
 
}


#--------------------------------------
# Series 10 Device Family Connections
#--------------------------------------

# For series 10 device family only
# Expose Interface & Ports for RX connections OR TERMINATE THEM
# if rx_enable = 1 : RX Interfaces & Ports  are exposed for connections
# if rx_enable = 0 : Exposed RX Interfaces & Ports will be TERMINATED 
proc rx_set_connections_xs { rx_enable } {
   set d_L [get_parameter_value "L"]
 
   common_add_clock 		 rx_refclk 	    clock    input    1   std   true   [expr {$rx_enable == 0}]
   common_add_optional_conduit 	 rx_refclk_phy      clk      output   1   std   true   [expr {$rx_enable == 0}]
   common_add_clock 		 rxlink_clk 	    clock    input    1      std      true   [expr {$rx_enable == 0}]
   common_add_reset              rxlink_rst_n                input    rxlink_clk    [expr {$rx_enable == 0}]
   common_add_optional_conduit 	 phy_rxlink_clk	    export   output   1      std      true   [expr {$rx_enable == 0}]
   common_add_optional_conduit 	 phy_rxlink_rst_n   export   output   1      std      true   [expr {$rx_enable == 0}]
   common_add_optional_conduit 	 rxphy_clk          export   output   $d_L   vector   true   [expr {$rx_enable == 0}]  

   #Interfaces to Base
   common_add_optional_conduit   phy_csr_rx_locked_to_data   rx_is_lockedtodata   output   $d_L    vector   true   [expr {$rx_enable == 0}]
   common_add_optional_conduit   phy_csr_rx_cal_busy         rx_cal_busy          output   $d_L    vector   true   [expr {$rx_enable == 0}]
   common_add_optional_conduit   phy_csr_rx_pcfifo_full      export   output   $d_L    vector   true   [expr {$rx_enable == 0}]
   common_add_optional_conduit   phy_csr_rx_pcfifo_empty     export   output   $d_L    vector   true   [expr {$rx_enable == 0}]

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      common_add_optional_conduit   phy_rx_coreclkin    clk                  output   $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_clkout           clk                  input    $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_locked_to_data   rx_is_lockedtodata   input    $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_cal_busy         rx_cal_busy          input    $d_L   vector   true   [expr {$rx_enable == 0}]
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         common_add_optional_conduit   rx_pcfifo_full      rx_std_pcfifo_full   input    $d_L   vector   true   [expr {$rx_enable == 0}]
         common_add_optional_conduit   rx_pcfifo_empty     rx_std_pcfifo_empty  input    $d_L   vector   true   [expr {$rx_enable == 0}]
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
         common_add_optional_conduit   rx_pcfifo_full      rx_fifo_full         input    $d_L   vector   true   [expr {$rx_enable == 0}]
         common_add_optional_conduit   rx_pcfifo_empty     rx_fifo_empty        input    $d_L   vector   true   [expr {$rx_enable == 0}]
      }

      #Sink unused ports from XCVR
      common_add_optional_conduit   unused_rx_runningdisp       rx_runningdisp            input   $d_L*4   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   unused_rx_parallel_data     unused_rx_parallel_data   input   $d_L*[get_parameter_value "UNUSED_RX_PARALLEL_WIDTH"]  vector  true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   unused_rx_patterndetect     rx_patterndetect          input   $d_L*4   vector   true   [expr {$rx_enable == 0}]

      #TERMINATE unused ports for other pcs configuration

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      common_add_optional_conduit   phy_rx_coreclkin    clk                  output   $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_clkout           clk                  input    $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_locked_to_data   rx_is_lockedtodata   input    $d_L   vector   true   [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_cal_busy         rx_cal_busy          input    $d_L   vector   true   [expr {$rx_enable == 0}]
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         common_add_optional_conduit   rx_pcfifo_full      rx_enh_fifo_full     input    $d_L   vector   true   [expr {$rx_enable == 0}]
         common_add_optional_conduit   rx_pcfifo_empty     rx_enh_fifo_empty    input    $d_L   vector   true   [expr {$rx_enable == 0}]
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
         common_add_optional_conduit   rx_pcfifo_full      rx_fifo_full         input    $d_L   vector   true   [expr {$rx_enable == 0}]
         common_add_optional_conduit   rx_pcfifo_empty     rx_fifo_empty        input    $d_L   vector   true   [expr {$rx_enable == 0}]
      }
      #Sink unused ports from XCVR
      common_add_optional_conduit   unused_rx_parallel_data   unused_rx_parallel_data   input   $d_L*[get_parameter_value "UNUSED_RX_PARALLEL_WIDTH"]  vector  true   [expr {$rx_enable == 0}]

      #TERMINATE unused ports for other pcs configuration
      common_add_optional_conduit   unused_rx_runningdisp       rx_runningdisp            input   $d_L*4   vector   true   1
      common_add_optional_conduit   unused_rx_patterndetect     rx_patterndetect          input   $d_L*4   vector   true   1

    
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } else {
   }
}

# For series 10 device family only
# Expose Interface & Ports for TX connections OR TERMINATE THEM
# if tx_enable = 1 : TX Interfaces & Ports  are exposed for connections
# if tx_enable = 0 : Exposed TX Interfaces & Ports will be TERMINATED 
proc tx_set_connections_xs { tx_enable } {
   set d_L [get_parameter_value "L"]
   set bonded_mode [get_parameter_value "bonded_mode"]

   if {$d_L == "1"} {
      common_add_clock 		     tx_serial_clk0      hssi_serial_clock   input    $d_L     vector   true   [expr {$tx_enable == 0 || $bonded_mode == "bonded"}]
      common_add_clock 		     tx_bonding_clocks   hssi_bonded_clock   input    $d_L*6   vector   true   [expr {$tx_enable == 0 || $bonded_mode == "non_bonded"}] 
   } else {
      add_fragmented_qsys_interface  tx_serial_clk0      hssi_serial_clock   clk   input    1  $d_L     vector  true  [expr {$tx_enable == 0 || $bonded_mode == "bonded"}]
      add_fragmented_qsys_interface  tx_bonding_clocks   hssi_bonded_clock   clk   input    6  $d_L*6   vector  true  [expr {$tx_enable == 0 || $bonded_mode == "non_bonded"}]
   }
   common_add_optional_conduit 	 phy_tx_serial_clk0      clk                 output   $d_L     vector   true   [expr {$tx_enable == 0 || $bonded_mode == "bonded"}]
   common_add_optional_conduit 	 phy_tx_bonding_clocks   clk                 output   $d_L*6   vector   true   [expr {$tx_enable == 0 || $bonded_mode == "non_bonded"}]
   common_add_clock 		 txlink_clk 	    clock    input    1      std      true   [expr {$tx_enable == 0}] 
   common_add_reset              txlink_rst_n                input    txlink_clk    [expr {$tx_enable == 0}] 
   common_add_optional_conduit   phy_txlink_clk	    export   output   1      std      true   [expr {$tx_enable == 0}]
   common_add_optional_conduit 	 phy_txlink_rst_n   export   output   1      std      true   [expr {$tx_enable == 0}]
   common_add_optional_conduit 	 txphy_clk          export   output   $d_L   vector   true   [expr {$tx_enable == 0}]  

   # Interfaces to Base
   common_add_optional_conduit   phy_csr_tx_cal_busy       tx_cal_busy  output   $d_L   vector   true   [expr {$tx_enable == 0}]
   common_add_optional_conduit   phy_csr_tx_pcfifo_full    export  output   $d_L   vector   true   [expr {$tx_enable == 0}]
   common_add_optional_conduit   phy_csr_tx_pcfifo_empty   export  output   $d_L   vector   true   [expr {$tx_enable == 0}]
   common_add_optional_conduit   phy_tx_elecidle           export  input    $d_L   vector   true   [expr {$tx_enable == 0}]

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      common_add_optional_conduit   phy_tx_coreclkin  clk                  output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_clkout         clk                  input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_cal_busy       tx_cal_busy          input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_elecidle       tx_pma_elecidle      output   $d_L   vector   true   [expr {$tx_enable == 0}]      
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         common_add_optional_conduit   tx_pcfifo_full    tx_std_pcfifo_full   input    $d_L   vector   true   [expr {$tx_enable == 0}]
         common_add_optional_conduit   tx_pcfifo_empty   tx_std_pcfifo_empty  input    $d_L   vector   true   [expr {$tx_enable == 0}]
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
         common_add_optional_conduit   tx_pcfifo_full    tx_fifo_full         input    $d_L   vector   true   [expr {$tx_enable == 0}]
         common_add_optional_conduit   tx_pcfifo_empty   tx_fifo_empty        input    $d_L   vector   true   [expr {$tx_enable == 0}]
      }

      #GND unused ports from XCVR
      common_add_optional_conduit   unused_tx_parallel_data   unused_tx_parallel_data  output  $d_L*[get_parameter_value "UNUSED_TX_PARALLEL_WIDTH"]  vector   true   [expr {$tx_enable == 0}]

      #GND unused ports from XCVR
      common_add_optional_conduit   unused_tx_enh_data_valid       tx_enh_data_valid         output   $d_L      vector   true   1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      common_add_optional_conduit   phy_tx_coreclkin  clk                  output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_clkout         clk                  input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_cal_busy       tx_cal_busy          input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_elecidle       tx_pma_elecidle      output   $d_L   vector   true   [expr {$tx_enable == 0}]      
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         common_add_optional_conduit   tx_pcfifo_full    tx_enh_fifo_full     input    $d_L   vector   true   [expr {$tx_enable == 0}]
         common_add_optional_conduit   tx_pcfifo_empty   tx_enh_fifo_empty    input    $d_L   vector   true   [expr {$tx_enable == 0}]
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
         common_add_optional_conduit   tx_pcfifo_full    tx_fifo_full         input    $d_L   vector   true   [expr {$tx_enable == 0}]
         common_add_optional_conduit   tx_pcfifo_empty   tx_fifo_empty        input    $d_L   vector   true   [expr {$tx_enable == 0}]
      }

      #GND unused ports from XCVR
      common_add_optional_conduit   unused_tx_parallel_data      unused_tx_parallel_data   output   $d_L*[get_parameter_value "UNUSED_TX_PARALLEL_WIDTH"]  vector  true  [expr {$tx_enable == 0}]
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         common_add_optional_conduit   unused_tx_enh_data_valid     tx_enh_data_valid         output   $d_L      vector   true   [expr {$tx_enable == 0}]
      }
      #TERMINATE unused ports for other pcs configurations

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } else {
   }
}

proc xseries_avmm_adapter { enable } {
   set d_L [get_parameter_value "L"]

   common_add_optional_conduit   phy_reconfig_clk    clk       output   [expr {$d_L*1}]   vector   true   !$enable
   common_add_optional_conduit   phy_reconfig_reset  reset     output   [expr {$d_L*1}]   vector   true   !$enable

   add_interface 	      phy_reconfig_avmm	      conduit 		        output
   set_interface_property     phy_reconfig_avmm       ENABLED                   $enable
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_address         address 	output 	RECONFIG_ADDRESS_WIDTH
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_read 	        read 		output 	[expr {$d_L*1}]
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_readdata	readdata 	input 	[expr {$d_L*32}]
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_waitrequest	waitrequest 	input 	[expr {$d_L*1}]
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_write 	        write 		output 	[expr {$d_L*1}]
   add_interface_port         phy_reconfig_avmm       phy_reconfig_avmm_writedata	writedata 	output 	[expr {$d_L*32}]
   set_port_property          phy_reconfig_avmm_read            VHDL_TYPE               std_logic_vector
   set_port_property          phy_reconfig_avmm_waitrequest     VHDL_TYPE               std_logic_vector
   set_port_property          phy_reconfig_avmm_write           VHDL_TYPE               std_logic_vector

#   common_add_reset 	      reconfig_reset      input   reconfig_clk  [expr {!$enable}]

   common_add_clock       reconfig_clk 	  conduit  input   [expr {$d_L*1}]   vector   true  [expr {!$enable}]

   add_interface          reconfig_reset   conduit             sink
   add_interface_port     reconfig_reset   reconfig_reset      reset input [expr {$d_L*1}]
   set_port_property      reconfig_reset   VHDL_TYPE           std_logic_vector


   if {!$enable} {
      set_port_property       reconfig_reset   TERMINATION         true
      set_port_property       reconfig_reset   TERMINATION_VALUE   0
   }

   add_interface 	      reconfig_avmm       conduit 		        end
   set_interface_property     reconfig_avmm       ENABLED                       $enable
   add_interface_port         reconfig_avmm       reconfig_avmm_address 	address 	Input 	RECONFIG_ADDRESS_WIDTH
   add_interface_port         reconfig_avmm       reconfig_avmm_read 		read 		Input 	[expr {$d_L*1}]
   add_interface_port         reconfig_avmm       reconfig_avmm_readdata	readdata 	Output 	[expr {$d_L*32}]
   add_interface_port         reconfig_avmm       reconfig_avmm_waitrequest	waitrequest 	Output 	[expr {$d_L*1}]
   add_interface_port         reconfig_avmm       reconfig_avmm_write 		write 		Input 	[expr {$d_L*1}]
   add_interface_port         reconfig_avmm       reconfig_avmm_writedata	writedata 	Input 	[expr {$d_L*32}]
   set_port_property          reconfig_avmm_read          VHDL_TYPE     std_logic_vector 
   set_port_property          reconfig_avmm_waitrequest   VHDL_TYPE     std_logic_vector
   set_port_property          reconfig_avmm_write         VHDL_TYPE     std_logic_vector
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

    # Add Verilog files
    add_fileset_file ${simulator_path}/altera_jesd204_phy_adapter_xs_rcfg_shared_off.v  $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_phy_adapter_xs_rcfg_shared_off.v $simulator_specific   
}


#------------------------------------------------------------------------
# 4. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset verilog 0 synthesis 

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
    common_fileset  "vhdl" 1 cadence
    }
    if {1} {
    common_fileset "vhdl" 1 aldec
    }

} 

