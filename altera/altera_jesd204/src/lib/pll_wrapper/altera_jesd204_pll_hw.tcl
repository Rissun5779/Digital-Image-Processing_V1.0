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

#########################################
### Source required procs
#########################################
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204_pll_wrapper
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B PLL wrapper"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B PLL Wrapper"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true

########################
# Declare the callbacks
######################## 
set_module_property COMPOSITION_CALLBACK my_compose_callback


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../../top/altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_pll_wrapper_hw


#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------

proc my_compose_callback {} {
   # Case:368924 Use only 1 TX PLL
   set single_tx_pll 1
   if { [expr {$single_tx_pll == 1}] } {
      set g_xs_PLL 1
   } else {
      set g_xs_PLL [expr { ceil ([get_parameter_value "L"]*1.00/6) }]
   }

   # Add ATX PLL A10
   my_pll_add_instance $g_xs_PLL
   my_pll_add_connection $g_xs_PLL

}

proc my_pll_add_instance {g_xs_PLL} {
   set d_L [get_parameter_value "L"]
   set pma_width [expr {[param_matches PCS_CONFIG "JESD_PCS_CFG1"] ? 20 : [param_matches PCS_CONFIG "JESD_PCS_CFG2"] ? 40 : 10}]
   add_instance                  pll_refclk_bridge      altera_clock_bridge        18.1
   set_instance_parameter_value  pll_refclk_bridge      NUM_CLOCK_OUTPUTS  $g_xs_PLL

   add_sig_adapter  pll_cal_busy_adapter  [expr {$g_xs_PLL > 1 ? "and_gate" : "direct"}]   conduit 1 1 pll_cal_busy 1 export  1 

   if {[param_matches bonded_mode "bonded"]} {
#     add_jesd_fanout {inst_name   fanout   interface_type   signal_type   width}
      add_jesd_fanout tx_bonding_clocks_0_fanout [expr {$g_xs_PLL > 1 ? 6 : $d_L}] hssi_bonded_clock clk 6
      if {[expr {$g_xs_PLL > 1}]} {
         add_jesd_fanout tx_bonding_clocks_1_fanout [expr {($d_L-6)}] hssi_bonded_clock clk 6
      }
   } else {
      # Case:368924 Multi-channel x1/xN non-bonded
      #add_jesd_fanout tx_serial_clk_0_fanout [expr {$g_xs_PLL > 1 ? 6 : $d_L}] hssi_serial_clock clk 1
      add_jesd_fanout tx_serial_clk_0_fanout [expr {$d_L > 6 ? 6 : $d_L}] hssi_serial_clock clk 1
      if {[expr {$g_xs_PLL > 1 || [expr {$g_xs_PLL == 1 && $d_L > 6}]}]} {
         add_jesd_fanout tx_serial_clk_1_fanout [expr {$d_L-6}] hssi_serial_clock clk 1
      }
   }

   for {set i 0} {$i < $g_xs_PLL} {incr i} {
      add_instance                  inst_atx_pll_${i}      [get_xcvr_atx_pll_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         set_instance_parameter_value  inst_atx_pll_${i}      enable_pll_reconfig 0
         set_instance_parameter_value  inst_atx_pll_${i}      generate_docs 0
      }
      set_instance_parameter_value  inst_atx_pll_${i}      rcfg_debug 0
#      set_instance_parameter_value  inst_atx_pll_${i}      rcfg_file_prefix "altera_xcvr_atx_pll_a10"
      set_instance_parameter_value  inst_atx_pll_${i}      support_mode "user_mode"
      set_instance_parameter_value  inst_atx_pll_${i}      message_level "error"
 #     set_instance_parameter_value  inst_atx_pll_${i}      speed_grade "fastest"
      set_instance_parameter_value  inst_atx_pll_${i}      prot_mode "Basic"
      # Case:368924 Set to medium bandwidth.
      set_instance_parameter_value  inst_atx_pll_${i}      bw_sel "medium"
      set_instance_parameter_value  inst_atx_pll_${i}      refclk_cnt 1
      set_instance_parameter_value  inst_atx_pll_${i}      refclk_index 0
      set_instance_parameter_value  inst_atx_pll_${i}      silicon_rev "false"
      set_instance_parameter_value  inst_atx_pll_${i}      primary_pll_buffer "GX clock output buffer"
      set_instance_parameter_value  inst_atx_pll_${i}      enable_8G_path 1
      set_instance_parameter_value  inst_atx_pll_${i}      enable_16G_path 0
      set_instance_parameter_value  inst_atx_pll_${i}      enable_pcie_clk 0
      set_instance_parameter_value  inst_atx_pll_${i}      set_output_clock_frequency [expr {[get_parameter_value "lane_rate"]/2}]
      #set_instance_parameter_value  inst_atx_pll_${i}      set_auto_reference_clock_frequency [expr {[get_parameter_value "lane_rate"]*1.000/$pma_width}]
      set_instance_parameter_value  inst_atx_pll_${i}      set_auto_reference_clock_frequency [get_parameter_value "REFCLK_FREQ"]
      # Case:368924 MCGB to be enabled whenever bonded, or non-bonded with xN.
      set_instance_parameter_value  inst_atx_pll_${i}      enable_mcgb  [expr {[param_matches bonded_mode "bonded"] || [expr {[param_matches bonded_mode "non_bonded"] && $d_L > 6 && $g_xs_PLL == 1}] }]
      set_instance_parameter_value  inst_atx_pll_${i}      mcgb_div 1
      # Case:368924 Enable non-bonded xN high-speed output clk.
      set_instance_parameter_value  inst_atx_pll_${i}      enable_hfreq_clk [expr {[param_matches bonded_mode "non_bonded"] && $d_L > 6 && $g_xs_PLL == 1}]
      set_instance_parameter_value  inst_atx_pll_${i}      enable_mcgb_pcie_clksw 0
      set_instance_parameter_value  inst_atx_pll_${i}      mcgb_aux_clkin_cnt 0
      set_instance_parameter_value  inst_atx_pll_${i}      enable_bonding_clks [param_matches bonded_mode "bonded"]
      # Case:368924 Single TX PLL does not require fb compensation.
      set_instance_parameter_value  inst_atx_pll_${i}      enable_fb_comp_bonding [expr {[param_matches bonded_mode "bonded"] && $g_xs_PLL > 1}]
      set_instance_parameter_value  inst_atx_pll_${i}      pma_width $pma_width

      # Retain pll_powerdown connection for A10.
      if { [expr {[param_matches DEVICE_FAMILY "Arria 10"]} ] } {
         if { [expr {[param_matches bonded_mode "non_bonded"] && $d_L < 6 || [expr {[param_matches bonded_mode "non_bonded"] && $d_L > 6 && $g_xs_PLL > 1 }] }] } {
            add_jesd_fanout  pll_powerdown_${i}_fanout   1   conduit   pll_powerdown   1
         } else {
            add_jesd_fanout  pll_powerdown_${i}_fanout   2   conduit   pll_powerdown   1
            add_sig_adapter  pll_powerdown_${i}_adapter  "direct"  conduit 1 1 pll_powerdown 1 mcgb_rst 1
         }
      }
      add_sig_adapter  pll_locked_${i}_adapter     "direct"  conduit 1 1 pll_locked 1 export 1
   }
}
proc my_pll_add_connection {g_xs_PLL} {
  set d_L [get_parameter_value "L"]

  set_export_interface   pll_refclk   clock    sink    pll_refclk_bridge   in_clk   1
  set_connections        pll_refclk_bridge.out_clk        inst_atx_pll_0.pll_refclk0    1
  set_connections        pll_refclk_bridge.out_clk_1      inst_atx_pll_1.pll_refclk0    [expr {$g_xs_PLL > 1}]

  set_export_interface   pll_cal_busy   conduit    start  pll_cal_busy_adapter   sig_out   1
  set_connections        inst_atx_pll_0.pll_cal_busy  pll_cal_busy_adapter.sig_in_0    1
  set_connections        inst_atx_pll_1.pll_cal_busy  pll_cal_busy_adapter.sig_in_1    [expr {$g_xs_PLL > 1}]

  if {[param_matches bonded_mode "bonded"]} {
  set_connections        inst_atx_pll_0.tx_bonding_clocks  tx_bonding_clocks_0_fanout.sig_input  1
  set_connections        inst_atx_pll_1.tx_bonding_clocks  tx_bonding_clocks_1_fanout.sig_input  [expr {$g_xs_PLL > 1}]

  if {$d_L == 1} {
     set_export_interface   tx_bonding_clocks   hssi_bonded_clock    start  tx_bonding_clocks_0_fanout   sig_fanout0   1
  } else {
     if {$g_xs_PLL > 1} {
        for {set i 0} {$i < 6} {incr i} {
           set_export_interface   tx_bonding_clocks_ch${i}   hssi_bonded_clock    start  tx_bonding_clocks_0_fanout   sig_fanout${i}   1
        }
        for {set j 0} {$j < $d_L-6} {incr j} {
           set_export_interface   tx_bonding_clocks_ch[expr {$j+6}]   hssi_bonded_clock    start  tx_bonding_clocks_1_fanout   sig_fanout${j}   1
        }
     } else {
        for {set i 0} {$i < $d_L} {incr i} {
           set_export_interface   tx_bonding_clocks_ch${i}   hssi_bonded_clock    start  tx_bonding_clocks_0_fanout   sig_fanout${i}   1
        }
     }
  }

  } else {
  set_connections        inst_atx_pll_0.tx_serial_clk  tx_serial_clk_0_fanout.sig_input  1
  set_connections        inst_atx_pll_1.tx_serial_clk  tx_serial_clk_1_fanout.sig_input  [expr {$g_xs_PLL > 1}]
  # Case:368924 Non-bonded x1/xN mode - connect mcgb_serial_clk to remaining channels.
  set_connections        inst_atx_pll_0.mcgb_serial_clk  tx_serial_clk_1_fanout.sig_input  [expr {$d_L > 6 && $g_xs_PLL == 1}]

  if {$d_L == 1} {
     set_export_interface   tx_serial_clk0   hssi_serial_clock    start  tx_serial_clk_0_fanout   sig_fanout0   1
  } else {
     # Case:368924 Add in non-bonded x1/xN mode.
     if {$g_xs_PLL > 1 || [expr {$g_xs_PLL == 1 && $d_L > 6}]} {
        for {set i 0} {$i < 6} {incr i} {
           set_export_interface   tx_serial_clk0_ch${i}   hssi_serial_clock    start  tx_serial_clk_0_fanout   sig_fanout${i}   1
        }
        for {set j 0} {$j < $d_L-6} {incr j} {
           set_export_interface   tx_serial_clk0_ch[expr {$j+6}]    hssi_serial_clock    start  tx_serial_clk_1_fanout   sig_fanout${j}   1
        }

     } else {
        for {set i 0} {$i < $d_L} {incr i} {
           set_export_interface   tx_serial_clk0_ch${i}   hssi_serial_clock    start  tx_serial_clk_0_fanout   sig_fanout${i}   1
        }
     }
  }
  }

  for {set i 0} {$i < $g_xs_PLL} {incr i} {
     # Retain pll_powerdown connection for A10.
     if { [expr {[param_matches DEVICE_FAMILY "Arria 10"]} ] } {
        set_export_interface   pll_powerdown_${i}   conduit    end      pll_powerdown_${i}_fanout    sig_input  1
        set_connections        pll_powerdown_${i}_fanout.sig_fanout0    inst_atx_pll_${i}.pll_powerdown     1
        # Connect pll_powerdown to mcgb_rst.  
        set_connections        pll_powerdown_${i}_fanout.sig_fanout1    pll_powerdown_${i}_adapter.sig_in_0     [expr {[param_matches bonded_mode "bonded"] || [expr {[param_matches bonded_mode "non_bonded"] && $d_L > 6 && $g_xs_PLL == 1}] }]
        set_connections        pll_powerdown_${i}_adapter.sig_out       inst_atx_pll_${i}.mcgb_rst          [expr {[param_matches bonded_mode "bonded"] || [expr {[param_matches bonded_mode "non_bonded"] && $d_L > 6 && $g_xs_PLL == 1}] }]
     }

     set_export_interface   pll_locked_${i}      conduit    start    pll_locked_${i}_adapter      sig_out    1
     set_connections        inst_atx_pll_${i}.pll_locked         pll_locked_${i}_adapter.sig_in_0        1
  } 
}
