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


# +--------------------------------------------
# | 
# | SDI II PHY Adapter v12.1 (Stratix V series)
# | Intel Corporation 2011.08.19.17:10:07
# | 
# +-------------------------------------------

package require -exact qsys 16.0

source ../../sdi_ii/sdi_ii_interface.tcl
source ../../sdi_ii/sdi_ii_params.tcl

# +-----------------------------------
# | module SDI II PHY Adapter
# | 
set_module_property DESCRIPTION "SDI II PHY Adapter"
set_module_property NAME sdi_ii_phy_adapter
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II/SDI II PHY Adapter"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II PHY ADAPTER"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_phy_adapter.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_phy_adapter
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------

# +-----------------------------------
# | IEEE Encryption
# |

add_fileset          simulation_verilog SIM_VERILOG   generate_ed_files
add_fileset          simulation_vhdl    SIM_VHDL      generate_ed_files
add_fileset          synthesis_fileset  QUARTUS_SYNTH generate_ed_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_phy_adapter
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_phy_adapter
set_fileset_property synthesis_fileset  TOP_LEVEL   sdi_ii_phy_adapter

proc generate_files {name} {
  if {0} {
    add_fileset_file mentor/src_hdl/sdi_ii_phy_adapter.v    VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_phy_adapter.v"   {MENTOR_SPECIFIC}
  }
  if {0} {
    add_fileset_file aldec/src_hdl/sdi_ii_phy_adapter.v     VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_phy_adapter.v"    {ALDEC_SPECIFIC}
  }
#  if {0} {
#    add_fileset_file cadence/src_hdl/sdi_ii_phy_adapter.v   VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_phy_adapter.v"  {CADENCE_SPECIFIC}
#  }
  if {0} {
    add_fileset_file synopsys/src_hdl/sdi_ii_phy_adapter.v  VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_phy_adapter.v" {SYNOPSYS_SPECIFIC}
  }
}

#proc sim_vhd {name} {
#  if {0} {
#    add_fileset_file mentor/src_hdl/sdi_ii_phy_adapter.v     VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_phy_adapter.v"    {MENTOR_SPECIFIC}
#  }
  #if {0} {
  #  add_fileset_file aldec/src_hdl/sdi_ii_phy_adapter.v     VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_phy_adapter.v"     {ALDEC_SPECIFIC}
  #}
  #if {0} {
  #  add_fileset_file cadence/src_hdl/sdi_ii_phy_adapter.v   VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_phy_adapter.v"   {CADENCE_SPECIFIC}
  #}
  #if {0} {
  #  add_fileset_file synopsys/src_hdl/sdi_ii_phy_adapter.v  VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_phy_adapter.v"  {SYNOPSYS_SPECIFIC}
  #}
#}

# | 
# +-----------------------------------


# +-----------------------------------
# | files
# | 
proc generate_ed_files {name} {
   add_fileset_file sdi_ii_phy_adapter.v                  VERILOG PATH src_hdl/sdi_ii_phy_adapter.v
}

#set module_dir [get_module_property MODULE_DIRECTORY]
#add_file ${module_dir}/src_hdl/sdi_ii_phy_adapter.v  {SYNTHESIS}

# | 
# +-----------------------------------

sdi_ii_common_params
# set_parameter_property FAMILY                  HDL_PARAMETER false
#set_parameter_property VIDEO_STANDARD         HDL_PARAMETER false
set_parameter_property TRANSCEIVER_PROTOCOL    HDL_PARAMETER false
set_parameter_property RX_INC_ERR_TOLERANCE    HDL_PARAMETER false
set_parameter_property RX_CRC_ERROR_OUTPUT     HDL_PARAMETER false
# set_parameter_property RX_EN_TRS_MISC          HDL_PARAMETER false
set_parameter_property RX_EN_VPID_EXTRACT      HDL_PARAMETER false
set_parameter_property RX_EN_A2B_CONV          HDL_PARAMETER false
set_parameter_property RX_EN_B2A_CONV          HDL_PARAMETER false
set_parameter_property TX_HD_2X_OVERSAMPLING   HDL_PARAMETER false
set_parameter_property TX_EN_VPID_INSERT       HDL_PARAMETER false
set_parameter_property SD_BIT_WIDTH            HDL_PARAMETER false
set_parameter_property XCVR_TX_PLL_SEL         HDL_PARAMETER true
set_parameter_property HD_FREQ                 HDL_PARAMETER false
# set_parameter_property ED_TXPLL_TYPE           HDL_PARAMETER true
set_parameter_property ED_TXPLL_SWITCH         HDL_PARAMETER true

add_parameter XCVR_RST_CTRL_CHS integer 1
set_parameter_property XCVR_RST_CTRL_CHS       ALLOWED_RANGES {1 2}
set_parameter_property XCVR_RST_CTRL_CHS       HDL_PARAMETER true

set common_composed_mode 0

proc elaboration_callback {} {
  set dir [get_parameter_value DIRECTION] 
  set video_std [get_parameter_value VIDEO_STANDARD]
  set device_family [get_parameter_value FAMILY]
  set xcvr_tx_pll_sel [get_parameter_value XCVR_TX_PLL_SEL]
  # set ed_tx_pll [get_parameter_value ED_TXPLL_TYPE]
  set ed_pll_switch [get_parameter_value ED_TXPLL_SWITCH]
  
  if { $xcvr_tx_pll_sel == "1" } {
    set txpll_num 2
  } else {
    set txpll_num 1
  }

  if { $xcvr_tx_pll_sel != "0" } {
    set refclk_cnt 2
  } else {
    set refclk_cnt 1
  }
  
  if { $video_std == "hd" | $video_std == "dl" } {
     set clock_rate "74250000"
  } else {
     set clock_rate "148500000"
  }
  
  if { $xcvr_tx_pll_sel == "1" } {
     set rcfg_frm_xcvr_width 138
     set rcfg_to_xcvr_width  210
  } else {
     if {$dir == "rx" } {
        set rcfg_frm_xcvr_width 46
        set rcfg_to_xcvr_width  70
      } else {
        set rcfg_frm_xcvr_width 92
        set rcfg_to_xcvr_width  140
      }
  }

  if { $device_family == "Arria 10" } {
     set tx_parallel_data_width 128
     set rx_parallel_data_width 128
  } elseif { $device_family == "Stratix V" || $device_family == "Arria V GZ" } {
     set tx_parallel_data_width 64
     set rx_parallel_data_width 64
  } else {
     set tx_parallel_data_width 44
     set rx_parallel_data_width 64
  }
  
  if { $video_std == "mr" } {
     set num_streams 4
  } else {
     set num_streams 1
  }
  
  if { $device_family != "Arria 10" } {
     common_add_clock            xcvr_refclk            input  true
  } else {
     if {$dir == "du" | $dir == "rx"} {
        common_add_clock            xcvr_refclk                  input  true
     }
  }

  if { $xcvr_tx_pll_sel == "1" | $ed_pll_switch == "1" } {
    set pll_pwrdwn_width 2
  } else {
    set pll_pwrdwn_width 1
  }

  common_add_clock            xcvr_refclk_alt   input           true
  common_add_clock            tx_pclk           input           true
  common_add_clock            reconfig_clk_in   input           true
  common_add_clock            tx_clkout         output          true
  common_add_clock            xcvr_rxclk        output          true 
  common_add_clock            xcvr_rxclk_b      output          true 
  set_interface_property      tx_clkout         clockRateKnown  true
  set_interface_property      tx_clkout         clockRate       $clock_rate
  set_interface_property      xcvr_rxclk        clockRateKnown  true
  set_interface_property      xcvr_rxclk        clockRate       $clock_rate
  set_interface_property      xcvr_rxclk_b      clockRateKnown  true
  set_interface_property      xcvr_rxclk_b      clockRate       $clock_rate

  common_add_reset            reconfig_rst_in            input          reconfig_clk_in
  common_add_reset            reset_to_xcvr_rst_ctrl     output         xcvr_rxclk
  common_add_reset            reset_to_xcvr_rst_ctrl_b   output         xcvr_rxclk

  common_add_optional_conduit    reconfig_from_xcvr              reconfig_from_xcvr     output  $rcfg_frm_xcvr_width  true
  common_add_optional_conduit    reconfig_to_xcvr                reconfig_to_xcvr       input   $rcfg_to_xcvr_width   true
  common_add_optional_conduit    xcvr_reconfig_from_xcvr         reconfig_from_xcvr     input   $rcfg_frm_xcvr_width  true
  common_add_optional_conduit    xcvr_reconfig_to_xcvr           reconfig_to_xcvr       output  $rcfg_to_xcvr_width   true  
  common_add_optional_conduit    reconfig_from_xcvr_b            reconfig_from_xcvr     output  $rcfg_frm_xcvr_width  true
  common_add_optional_conduit    reconfig_to_xcvr_b              reconfig_to_xcvr       input   $rcfg_to_xcvr_width   true
  common_add_optional_conduit    xcvr_reconfig_from_xcvr_b       reconfig_from_xcvr     input   $rcfg_frm_xcvr_width  true
  common_add_optional_conduit    xcvr_reconfig_to_xcvr_b         reconfig_to_xcvr       output  $rcfg_to_xcvr_width   true  
  common_add_optional_conduit    xcvr_refclk_sel                 export                 input  1  true
  common_add_optional_conduit    tx_pll_locked_alt               export                 output 1  true
  common_add_optional_conduit    tx_pll_refclk                   tx_pll_refclk          output $refclk_cnt  true
  common_add_optional_conduit    tx_std_coreclkin                tx_std_coreclkin       output 1  true
  common_add_optional_conduit    sdi_tx_from_xcvr                tx_serial_data         input  1  true
  common_add_optional_conduit    tx_pll_locked_from_xcvr         pll_locked             input  $txpll_num  true
  common_add_optional_conduit    sdi_tx                          export                 output 1  true
  common_add_optional_conduit    tx_pll_locked                   export                 output 1  true
  common_add_optional_conduit    tx_pll_refclk_b                 tx_pll_refclk          output $refclk_cnt  true
  common_add_optional_conduit    tx_std_coreclkin_b              tx_std_coreclkin       output 1  true
  common_add_optional_conduit    sdi_tx_from_xcvr_b              tx_serial_data         input  1  true
  common_add_optional_conduit    sdi_tx_b                        export                 output 1  true
  common_add_optional_conduit    rx_std_coreclkin                rx_std_coreclkin       output 1  true
  common_add_optional_conduit    rx_pma_clkout                   rx_pma_clkout          input  1  true
  common_add_optional_conduit    trig_rst_ctrl                   export                 input  1  true
  common_add_optional_conduit    sdi_rx                          export                 input  1  true
  common_add_optional_conduit    rx_set_locktodata               export                 input  1  true
  common_add_optional_conduit    sdi_rx_to_xcvr                  rx_serial_data         output 1  true
  common_add_optional_conduit    rx_set_locktodata_to_xcvr       rx_set_locktodata      output 1  true
  common_add_optional_conduit    rx_set_locktoref_to_xcvr        rx_set_locktoref       output 1  true
  # common_add_optional_conduit    rx_pll_locked                   export                 output 1  true
  common_add_optional_conduit    rx_std_coreclkin_b              rx_std_coreclkin       output 1  true
  common_add_optional_conduit    rx_pma_clkout_b                 rx_pma_clkout          input  1  true
  common_add_optional_conduit    trig_rst_ctrl_b                 export                 input  1  true
  common_add_optional_conduit    sdi_rx_b                        export                 input  1  true
  common_add_optional_conduit    rx_set_locktodata_b             export                 input  1  true
  common_add_optional_conduit    sdi_rx_to_xcvr_b                rx_serial_data         output 1  true
  common_add_optional_conduit    rx_set_locktodata_to_xcvr_b     rx_set_locktodata      output 1  true
  common_add_optional_conduit    rx_set_locktoref_to_xcvr_b      rx_set_locktoref       output 1  true
  # common_add_optional_conduit    rx_pll_locked_b                 export                 output 1  true
  common_add_optional_conduit    reconfig_clk_out                clk                    output 1  true
  common_add_optional_conduit    reconfig_rst_out                reset                  output 1  true
  common_add_optional_conduit    tx_datain_to_xcvr               tx_parallel_data       output $tx_parallel_data_width  true
  common_add_optional_conduit    tx_pll_select_to_xcvr_rst       pll_select             output 1  true  
  common_add_optional_conduit    tx_serial_clk_out               clk                    output 1  true
  common_add_optional_conduit    tx_serial_clk_alt_out           clk                    output 1  true
  common_add_optional_conduit    pll_powerdown_in                pll_powerdown          input  $pll_pwrdwn_width  true
  common_add_optional_conduit    pll_powerdown_out               pll_powerdown          output 1  true
  common_add_optional_conduit    pll_powerdown_out_b             pll_powerdown          output 1  true
  common_add_optional_conduit    pll_locked_in                   pll_locked             input  1  true
  common_add_optional_conduit    pll_locked_in_b                 pll_locked             input  1  true
  common_add_optional_conduit    pll_locked_out                  pll_locked             output 2  true
  common_add_optional_conduit    tx_cal_busy_in                  tx_cal_busy            input  1  true
  common_add_optional_conduit    pll_cal_busy_in                 pll_cal_busy           input  1  true
  common_add_optional_conduit    pll_cal_busy_in_alt             pll_cal_busy           input  1  true
  common_add_optional_conduit    tx_datain_to_xcvr_b             tx_parallel_data       output $tx_parallel_data_width true
  common_add_optional_conduit    tx_analogreset_in               tx_analogreset         input  2  true
  common_add_optional_conduit    tx_analogreset_out              tx_analogreset         output 1  true
  common_add_optional_conduit    tx_analogreset_out_b            tx_analogreset         output 1  true
  common_add_optional_conduit    tx_digitalreset_in              tx_digitalreset        input  2  true
  common_add_optional_conduit    tx_digitalreset_out             tx_digitalreset        output 1  true
  common_add_optional_conduit    tx_digitalreset_out_b           tx_digitalreset        output 1  true
  common_add_optional_conduit    tx_cal_busy_in_b                tx_cal_busy            input  1  true
  common_add_optional_conduit    tx_pll_select_to_xcvr_rst_b     pll_select             output 1  true
  common_add_optional_conduit    xcvr_tx_ready_b                 tx_ready               input  1  true
  common_add_optional_conduit    rx_dataout_from_xcvr            rx_parallel_data       input  $rx_parallel_data_width true
  common_add_optional_conduit    xcvr_rx_is_lockedtoref          rx_is_lockedtoref      input  1  true
  common_add_optional_conduit    xcvr_rx_is_lockedtodata         rx_is_lockedtodata     input  1  true
  common_add_optional_conduit    rx_dataout_from_xcvr_b          rx_parallel_data       input  $rx_parallel_data_width true
  common_add_optional_conduit    xcvr_rx_is_lockedtoref_b        rx_is_lockedtoref      input  1  true
  common_add_optional_conduit    xcvr_rx_is_lockedtodata_b       rx_is_lockedtodata     input  1  true
  common_add_optional_conduit    rx_analogreset_in               rx_analogreset         input  2  true
  common_add_optional_conduit    rx_analogreset_out              rx_analogreset         output 1  true
  common_add_optional_conduit    rx_analogreset_out_b            rx_analogreset         output 1  true
  common_add_optional_conduit    rx_digitalreset_in              rx_digitalreset        input  2  true
  common_add_optional_conduit    rx_digitalreset_out             rx_digitalreset        output 1  true
  common_add_optional_conduit    rx_digitalreset_out_b           rx_digitalreset        output 1  true
  common_add_optional_conduit    rx_cal_busy_in                  rx_cal_busy            input  1  true
  common_add_optional_conduit    rx_cal_busy_in_b                rx_cal_busy            input  1  true
  common_add_optional_conduit    rx_cal_busy_out                 rx_cal_busy            output 2  true
  common_add_optional_conduit    rx_locked_to_xcvr_ctrl_b        rx_is_lockedtodata     output 1  true
  common_add_optional_conduit    rx_manual_b                     rx_reset_mode          output 1  true
  common_add_optional_conduit    rx_ready_from_xcvr_b            rx_ready               input  1  true
  common_add_optional_conduit    rx_std                          export                 input  3  true
  common_add_optional_conduit    rx_control                      rx_control             input  20 true
  common_add_optional_conduit    tx_control                      tx_control             output 18 true
  common_add_optional_conduit    tx_enh_data_valid               tx_enh_data_valid      output 1  true
  common_add_optional_conduit    unused_tx_clkout                clk                    input  1  true
  common_add_optional_conduit    unused_rx_clkout                clk                    input  1  true

  add_interface                  tx_serial_clk_in                hssi_serial_clock            input
  add_interface_port             tx_serial_clk_in                tx_serial_clk_in       clk   input  1
  add_interface                  tx_serial_clk_alt_in            hssi_serial_clock            input
  add_interface_port             tx_serial_clk_alt_in            tx_serial_clk_alt_in   clk   input 1

  if { $device_family == "Arria 10" } {
     common_add_optional_conduit    xcvr_tx_datain               tx_parallel_data                 input  20*$num_streams true
     common_add_optional_conduit    xcvr_tx_datain_b             tx_parallel_data                 input  20 true
     common_add_optional_conduit    xcvr_rx_dataout              rx_parallel_data       output 20*$num_streams true
     common_add_optional_conduit    xcvr_rx_ready                rx_ready               output 1  true
     common_add_optional_conduit    xcvr_rx_dataout_b            rx_parallel_data       output 20 true
     common_add_optional_conduit    xcvr_rx_ready_b              rx_ready               output 1  true
     common_add_optional_conduit    tx_clkout_from_xcvr          clk                    input  1  true
     common_add_optional_conduit    rx_cdr_refclk                clk                    output 1  true
     common_add_optional_conduit    rx_set_locktoref             rx_set_locktoref       input  1  true
     common_add_optional_conduit    rxclk_from_xcvr              clk                    input  1  true
     common_add_optional_conduit    tx_clkout_from_xcvr_b        clk                    input  1  true
     common_add_optional_conduit    rxclk_from_xcvr_b            clk                    input  1  true
     common_add_optional_conduit    rx_set_locktoref_b           rx_set_locktoref       input  1  true
     common_add_optional_conduit    rx_cdr_refclk_b              clk                    output 1  true
  } else {
     common_add_optional_conduit    xcvr_tx_datain               export                 input  20*$num_streams true
     common_add_optional_conduit    xcvr_tx_datain_b             export                 input  20 true
     common_add_optional_conduit    xcvr_rx_dataout              export                 output 20*$num_streams true
     common_add_optional_conduit    xcvr_rx_ready                export                 output 1  true
     common_add_optional_conduit    xcvr_rx_dataout_b            export                 output 20 true
     common_add_optional_conduit    xcvr_rx_ready_b              export                 output 1  true  
     common_add_optional_conduit    tx_clkout_from_xcvr          tx_std_clkout          input  1   true
     common_add_optional_conduit    rx_cdr_refclk                rx_cdr_refclk          output 1  true
     common_add_optional_conduit    rx_set_locktoref             export                 input  1  true
     common_add_optional_conduit    rxclk_from_xcvr              rx_std_clkout          input  1  true
     common_add_optional_conduit    tx_clkout_from_xcvr_b        tx_std_clkout          input  1  true
     common_add_optional_conduit    rx_cdr_refclk_b              rx_cdr_refclk          output 1 true
     common_add_optional_conduit    rxclk_from_xcvr_b            rx_std_clkout          input  1  true
     common_add_optional_conduit    rx_set_locktoref_b           export                 input  1  true
  }

  if {$video_std != "dl"} {
     common_add_optional_conduit    xcvr_tx_ready                tx_ready                input  1  true
     common_add_optional_conduit    tx_cal_busy_out              tx_cal_busy             output 1  true
  } else {
     common_add_optional_conduit    tx_cal_busy_out              tx_cal_busy             output 2  true
     if { $device_family == "Arria 10" } {
        common_add_optional_conduit  xcvr_tx_ready               tx_ready                input  2  true
     } else {
        common_add_optional_conduit  xcvr_tx_ready               tx_ready                input  1  true
     }
  }

  if { $device_family == "Arria 10" & $video_std == "dl"} {
     common_add_optional_conduit    rx_locked_to_xcvr_ctrl       rx_is_lockedtodata      output 2  true
     common_add_optional_conduit    rx_manual                    rx_reset_mode           output 2  true
     common_add_optional_conduit    rx_ready_from_xcvr           rx_ready                input  2  true
  } else {
     common_add_optional_conduit    rx_locked_to_xcvr_ctrl       rx_is_lockedtodata      output 1  true
     common_add_optional_conduit    rx_manual                    rx_reset_mode           output 1  true
     common_add_optional_conduit    rx_ready_from_xcvr           rx_ready                input  1  true
  }

  if { $device_family == "Arria 10" } {
     terminate_port   reconfig_from_xcvr          output
     terminate_port   reconfig_to_xcvr            input
     terminate_port   xcvr_reconfig_from_xcvr     input
     terminate_port   xcvr_reconfig_to_xcvr       output
  }

  if { $device_family != "Arria 10" | ($device_family == "Arria 10" & $ed_pll_switch != "1" & $video_std != "tr" & $video_std != "ds" & $video_std != "mr" ) } {
     terminate_port   reconfig_clk_in             input  
     terminate_port   reconfig_clk_out            output  
     terminate_port   reconfig_rst_in             input
     terminate_port   reconfig_rst_out            output     
  }
  
  if { $device_family == "Arria 10" | $video_std != "dl"} {
     terminate_port   reconfig_from_xcvr_b        output
     terminate_port   reconfig_to_xcvr_b          input
     terminate_port   xcvr_reconfig_from_xcvr_b   input
     terminate_port   xcvr_reconfig_to_xcvr_b     output
  }  

  if { $xcvr_tx_pll_sel != "1" & $ed_pll_switch != "1" } {
     terminate_port   xcvr_refclk_sel             input
  }

  if { $device_family == "Arria 10" | $xcvr_tx_pll_sel != "1" } {
     terminate_port   tx_pll_locked_alt           output
  }

  if { $device_family == "Arria 10" | $xcvr_tx_pll_sel == "0" } {
     terminate_port   xcvr_refclk_alt             input
  }

  if { $device_family == "Arria 10" | ($dir != "du" & $dir != "tx") } {
     terminate_port   tx_pclk                     input    
     terminate_port   tx_pll_refclk               output 
     terminate_port   tx_std_coreclkin            output
     terminate_port   sdi_tx_from_xcvr            input
     terminate_port   tx_pll_locked_from_xcvr     input  
     terminate_port   sdi_tx                      output 
     terminate_port   tx_pll_locked               output
  }

  if { $device_family == "Arria 10" |($dir != "du" & $dir != "tx") | $video_std != "dl" } {
     terminate_port   tx_pll_refclk_b             output
     terminate_port   tx_std_coreclkin_b          output
     terminate_port   sdi_tx_from_xcvr_b          input
     terminate_port   sdi_tx_b                    output
  }

  if { $device_family == "Arria 10" | ($dir != "du" & $dir != "rx") } {
     terminate_port   rx_std_coreclkin            output
     terminate_port   rx_pma_clkout               input
     terminate_port   trig_rst_ctrl               input
     terminate_port   sdi_rx                      input
     terminate_port   rx_set_locktodata           input
     terminate_port   sdi_rx_to_xcvr              output
     terminate_port   rx_set_locktodata_to_xcvr   output
     terminate_port   rx_set_locktoref_to_xcvr    output
     # terminate_port   rx_pll_locked               output
     terminate_port   reset_to_xcvr_rst_ctrl        output  
  }

  if { ($device_family == "Arria 10" & $video_std != "dl") | ($dir != "du" & $dir != "rx") } {
     terminate_port   xcvr_rx_ready               output
  }

  if { $device_family == "Arria 10" | ($dir != "du" & $dir != "rx") | $video_std != "dl"} {
     terminate_port   rx_std_coreclkin_b          output
     terminate_port   rx_pma_clkout_b             input
     terminate_port   trig_rst_ctrl_b             input
     terminate_port   sdi_rx_b                    input 
     terminate_port   rx_set_locktodata_b         input
     terminate_port   sdi_rx_to_xcvr_b            output
     terminate_port   rx_set_locktodata_to_xcvr_b   output
     terminate_port   rx_set_locktoref_to_xcvr_b    output
     # terminate_port   rx_pll_locked_b             output
     terminate_port   reset_to_xcvr_rst_ctrl_b      output
     terminate_port   rx_locked_to_xcvr_ctrl_b      output 
     terminate_port   rx_manual_b                   output 
     terminate_port   rx_ready_from_xcvr_b          input  
  }

  if { ($device_family == "Arria 10" & $video_std != "dl") | ($dir != "du" & $dir != "rx") | $video_std != "dl"} {
     terminate_port   xcvr_rx_ready_b             output
   }
  
  if {$dir != "du" & $dir != "tx"} {
     terminate_port   tx_clkout                   output
     terminate_port   xcvr_tx_datain              input
     terminate_port   tx_datain_to_xcvr           output
     terminate_port   tx_pll_select_to_xcvr_rst   output
     terminate_port   tx_clkout_from_xcvr         input
     terminate_port   xcvr_tx_ready               input 
  }

  if { ($dir != "du" & $dir != "tx") | $video_std != "dl" } {
     terminate_port   tx_clkout_from_xcvr_b       input 
  }
  
  if { ($dir != "du" & $dir != "tx") | $device_family != "Arria 10" } {
     terminate_port   tx_serial_clk_in            input
     terminate_port   tx_serial_clk_out           output
     terminate_port   tx_cal_busy_in              input
     terminate_port   tx_cal_busy_out             output
     terminate_port   pll_cal_busy_in             input
  }

  if { ($dir != "du" & $dir != "tx") | $device_family != "Arria 10" | $ed_pll_switch != "1" } {
     terminate_port   tx_serial_clk_alt_in        input
     terminate_port   tx_serial_clk_alt_out       input
     terminate_port   pll_cal_busy_in_alt         input 
  }

  if { ($dir != "du" & $dir != "tx") | ($ed_pll_switch != "1" & !($device_family != "Arria 10" & $video_std == "dl") )} {
     terminate_port   pll_powerdown_in            input  
  }

  if { ($dir != "du" & $dir != "tx") | $ed_pll_switch != "1" } { 
     terminate_port   pll_powerdown_out           output  
     terminate_port   pll_powerdown_out_b         output  
     terminate_port   pll_locked_in               input  
     terminate_port   pll_locked_in_b             input   
     terminate_port   pll_locked_out              output  
  }

  if { ($dir != "du" & $dir != "tx") | $video_std != "dl" } {
     terminate_port   xcvr_tx_datain_b            input  
     terminate_port   tx_datain_to_xcvr_b         output 
  }

  if { ($dir != "du" & $dir != "tx") | $video_std != "dl" | ($video_std == "dl" && $device_family != "Arria 10") } {
     terminate_port   tx_analogreset_in           input 
     terminate_port   tx_analogreset_out          output 
     terminate_port   tx_analogreset_out_b        output  
     terminate_port   tx_digitalreset_in          input 
     terminate_port   tx_digitalreset_out         output 
     terminate_port   tx_digitalreset_out_b       output 
     terminate_port   tx_cal_busy_in_b            input  
  }

  if { ($dir != "du" & $dir != "tx") | $video_std != "dl" | ($video_std == "dl" && $device_family == "Arria 10") } {
     terminate_port   tx_pll_select_to_xcvr_rst_b   output 
     terminate_port   xcvr_tx_ready_b               input 
  }
  
  if {$dir != "du" & $dir != "rx"} {
     terminate_port   xcvr_rxclk                    output
     terminate_port   rx_dataout_from_xcvr          input 
     terminate_port   xcvr_rx_is_lockedtoref        input 
     terminate_port   xcvr_rx_is_lockedtodata       input 
     terminate_port   xcvr_rx_dataout               output 
     terminate_port   rx_cdr_refclk                 output
     terminate_port   rx_set_locktoref              input 
     terminate_port   rxclk_from_xcvr               input 
     terminate_port   rx_locked_to_xcvr_ctrl        output
     terminate_port   rx_manual                     output
     terminate_port   rx_ready_from_xcvr            input
  }

  if { ($dir != "du" & $dir != "rx") | $video_std != "dl" } {
     terminate_port   xcvr_rxclk_b                  output
     terminate_port   rx_dataout_from_xcvr_b        input 
     terminate_port   xcvr_rx_is_lockedtoref_b      input 
     terminate_port   xcvr_rx_is_lockedtodata_b     input 
     terminate_port   xcvr_rx_dataout_b             output 
     terminate_port   rxclk_from_xcvr_b             input 
     terminate_port   rx_set_locktoref_b            input 
     terminate_port   rx_cdr_refclk_b               output
  }

  if { ($dir != "du" & $dir != "rx") | $video_std != "dl" | $device_family != "Arria 10" } {
     terminate_port   rx_analogreset_in             input  
     terminate_port   rx_analogreset_out            output 
     terminate_port   rx_analogreset_out_b          output 
     terminate_port   rx_digitalreset_in            input  
     terminate_port   rx_digitalreset_out           output  
     terminate_port   rx_digitalreset_out_b         output 
     terminate_port   rx_cal_busy_in                input 
     terminate_port   rx_cal_busy_in_b              input 
     terminate_port   rx_cal_busy_out               output 
  }
  
  if { $device_family == "Arria 10" } {
     terminate_port   xcvr_tx_ready            input 
     terminate_port   xcvr_tx_ready_b          input 
  }
  
  if { $video_std != "mr" } {
     terminate_port   unused_tx_clkout         input
     terminate_port   unused_rx_clkout         input
     terminate_port   rx_std                   input
     terminate_port   rx_control               input
     terminate_port   tx_enh_data_valid        output
     terminate_port   tx_control               output
  }

}
