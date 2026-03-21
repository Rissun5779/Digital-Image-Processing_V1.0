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




package provide altera_pcie_a10_hip::fileset 18.1

package require alt_xcvr::ip_tcl::ip_module
package require altera_pcie_a10_hip::parameters

package require altera_terp

namespace eval ::altera_pcie_a10_hip::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets

  set filesets {\
    { NAME            TYPE            CALLBACK                                                   }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_pcie_a10_hip::fileset::callback_quartus_synth     }\
    { sim_verilog     SIM_VERILOG     ::altera_pcie_a10_hip::fileset::callback_sim_verilog       }\
    { sim_vhdl        SIM_VHDL        ::altera_pcie_a10_hip::fileset::callback_sim_vhdl          }\
    { example_design  EXAMPLE_DESIGN  ::altera_pcie_a10_hip::fileset::callback_example_design    }\
  }

}



proc ::altera_pcie_a10_hip::fileset::declare_filesets {} {
   variable filesets
   declare_tb_partner
   ip_declare_filesets $filesets
}

proc ::altera_pcie_a10_hip::fileset::declare_pllnphy_fileset {} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set link_width                       [ip_get "parameter.link_width_hwtcl.value"]
   set lane_rate                        [ip_get "parameter.lane_rate_hwtcl.value"]
   set base_device                      [ip_get "parameter.base_device.value"]
   set set_embedded_debug_enable        [ip_get "parameter.set_embedded_debug_enable_hwtcl.value"]
   set set_capability_reg_enable        [ip_get "parameter.set_capability_reg_enable_hwtcl.value"]
   set set_csr_soft_logic_enable        [ip_get "parameter.set_csr_soft_logic_enable_hwtcl.value"]
   set set_prbs_soft_logic_enable       [ip_get "parameter.set_prbs_soft_logic_enable_hwtcl.value"]
   set rcfg_jtag_enable                 [ip_get "parameter.rcfg_jtag_enable_hwtcl.value"]
   set dis_adapt		        [ip_get "parameter.dis_adapt.value"]
   set enable_dfe_ip                    [ip_get "parameter.enable_soft_dfe.value"]
   set enable_dfe_ip_sim_mode           0

   set rx_pma_ctle_adaptation_mode "one-time"
 
   if { $dis_adapt == 0 } {
      set rx_pma_ctle_adaptation_mode
   } else {
      set rx_pma_ctle_adaptation_mode "manual"
   }

##### Create PHY instance #####
   #  See : //depot/ip/pci_express/custom_designs/a10/phyip/make_fileset.sh
   #
   if { [regexp Gen1 $lane_rate] &&  [regexp x1 $link_width] } {
      add_hdl_instance phy_g1x1 altera_xcvr_native_a10
      set_instance_property phy_g1x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error set_data_rate 2500 set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g1 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x1 $param $val
      }
   } elseif { [regexp Gen1 $lane_rate] &&  [regexp x2 $link_width] } {
      add_hdl_instance phy_g1x2 altera_xcvr_native_a10
      set_instance_property phy_g1x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 2 set_data_rate 2500 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g1 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x2 $param $val
      }
   } elseif { [regexp Gen1 $lane_rate] &&  [regexp x4 $link_width] } {
      add_hdl_instance phy_g1x4 altera_xcvr_native_a10
      set_instance_property phy_g1x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 4 set_data_rate 2500 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g1 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x4 $param $val
      }
   } elseif { [regexp Gen1 $lane_rate] &&  [regexp x8 $link_width] } {
      add_hdl_instance phy_g1x8 altera_xcvr_native_a10
      set_instance_property phy_g1x8 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 8 set_data_rate 2500 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g1 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15  enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g1x8 $param $val
      }
   } elseif { [regexp Gen2 $lane_rate] &&  [regexp x1 $link_width] } {
      add_hdl_instance phy_g2x1 altera_xcvr_native_a10
      set_instance_property phy_g2x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error set_data_rate 5000 set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g2 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x1 $param $val
      }
   } elseif { [regexp Gen2 $lane_rate] &&  [regexp x2 $link_width] } {
      add_hdl_instance phy_g2x2 altera_xcvr_native_a10
      set_instance_property phy_g2x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 2 set_data_rate 5000 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g2 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x2 $param $val
      }
   } elseif { [regexp Gen2 $lane_rate] &&  [regexp x4 $link_width] } {
      add_hdl_instance phy_g2x4 altera_xcvr_native_a10
      set_instance_property phy_g2x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 4 set_data_rate 5000 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g2 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x4 $param $val
      }
   } elseif { [regexp Gen2 $lane_rate] &&  [regexp x8 $link_width] } {
      add_hdl_instance phy_g2x8 altera_xcvr_native_a10
      set_instance_property phy_g2x8 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 8 set_data_rate 5000 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g2 enable_hip 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_shared 1 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable enable_port_rx_polinv 1 ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g2x8 $param $val
      }
   } elseif { [regexp Gen3 $lane_rate] &&  [regexp x1 $link_width] } {
      add_hdl_instance phy_g3x1 altera_xcvr_native_a10
      set_instance_property phy_g3x1 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error set_data_rate 5000 plls 2 set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g3 enable_hip 1 enable_skp_ports 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 pcie_rate_match {600 ppm} std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_multi_enable 1  rcfg_shared 0 rcfg_profile_select 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable rx_pma_ctle_adaptation_mode $rx_pma_ctle_adaptation_mode rx_pma_dfe_adaptation_mode "disabled" enable_port_rx_polinv 1  rcfg_profile_data0 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode pipe_g3 pma_mode basic duplex_mode duplex channels 1 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 1 enable_hard_reset 1 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match {600 ppm} std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} rcfg_profile_data1 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode basic_std_rm pma_mode basic duplex_mode duplex channels 1 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x2} std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode {basic (single width)} std_rx_rmfifo_pattern_n 0 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} enable_pcie_dfe_ip $enable_dfe_ip sim_reduced_counters $enable_dfe_ip_sim_mode ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x1 $param $val
      }
   } elseif { [regexp Gen3 $lane_rate] &&  [regexp x2 $link_width] } {
      add_hdl_instance phy_g3x2 altera_xcvr_native_a10
      set_instance_property phy_g3x2 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 2 set_data_rate 5000  plls 2 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g3 enable_hip 1 enable_skp_ports 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 pcie_rate_match {600 ppm} std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_multi_enable 1  rcfg_shared 1 rcfg_profile_select 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable rx_pma_ctle_adaptation_mode $rx_pma_ctle_adaptation_mode rx_pma_dfe_adaptation_mode "disabled" enable_port_rx_polinv 1 rcfg_profile_data0 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode pipe_g3 pma_mode basic duplex_mode duplex channels 2 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 1 enable_hard_reset 1 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match {600 ppm} std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} rcfg_profile_data1 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode basic_std_rm pma_mode basic duplex_mode duplex channels 2 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x2} std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode {basic (single width)} std_rx_rmfifo_pattern_n 0 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} enable_pcie_dfe_ip $enable_dfe_ip sim_reduced_counters $enable_dfe_ip_sim_mode ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x2 $param $val
      }
   } elseif { [regexp Gen3 $lane_rate] &&  [regexp x4 $link_width] } {
      add_hdl_instance phy_g3x4 altera_xcvr_native_a10
      set_instance_property phy_g3x4 SUPPRESS_ALL_INFO_MESSAGES true
      set param_val_list [list device_family {Arria 10} message_level error channels 4 set_data_rate 5000  plls 2 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g3 enable_hip 1 enable_skp_ports 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 pcie_rate_match {600 ppm} std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_multi_enable 1  rcfg_shared 1 rcfg_profile_select 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable rx_pma_ctle_adaptation_mode $rx_pma_ctle_adaptation_mode rx_pma_dfe_adaptation_mode "disabled" enable_port_rx_polinv 1 rcfg_profile_data0 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode pipe_g3 pma_mode basic duplex_mode duplex channels 4 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 1 enable_hard_reset 1 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match {600 ppm} std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} rcfg_profile_data1 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode basic_std_rm pma_mode basic duplex_mode duplex channels 4 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x2} std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode {basic (single width)} std_rx_rmfifo_pattern_n 0 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} enable_pcie_dfe_ip $enable_dfe_ip sim_reduced_counters $enable_dfe_ip_sim_mode ]      
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x4 $param $val
      }
   } elseif { [regexp Gen3 $lane_rate] &&  [regexp x8 $link_width] } {
      add_hdl_instance phy_g3x8 altera_xcvr_native_a10
      set_instance_property phy_g3x8 SUPPRESS_ALL_INFO_MESSAGES true
	  set param_val_list [list device_family {Arria 10} message_level error channels 8 set_data_rate 5000  plls 2 bonded_mode pma_pcs set_cdr_refclk_freq 100.000000 rx_ppm_detect_threshold 300 enable_ports_rx_manual_cdr_mode 1 protocol_mode pipe_g3 enable_hip 1 enable_skp_ports 1 enable_hard_reset 1 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 pcie_rate_match {600 ppm} std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 set_hip_cal_en 1 rcfg_enable 1 rcfg_multi_enable 1  rcfg_shared 1 rcfg_profile_select 0 generate_add_hdl_instance_example 0 base_device $base_device set_embedded_debug_enable $set_embedded_debug_enable set_capability_reg_enable $set_capability_reg_enable set_csr_soft_logic_enable $set_csr_soft_logic_enable set_prbs_soft_logic_enable $set_prbs_soft_logic_enable rcfg_jtag_enable $rcfg_jtag_enable rx_pma_ctle_adaptation_mode $rx_pma_ctle_adaptation_mode rx_pma_dfe_adaptation_mode "disabled" enable_port_rx_polinv 1 rcfg_profile_data0 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode pipe_g3 pma_mode basic duplex_mode duplex channels 8 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 1 enable_hard_reset 1 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x4} std_rx_byte_deser_mode {Deserialize x4} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode pipe std_rx_rmfifo_pattern_n 192892 std_rx_rmfifo_pattern_p 855683 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match {600 ppm} std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} rcfg_profile_data1 {enable_skp_ports 1 anlg_voltage 1_0V anlg_link sr support_mode user_mode protocol_mode basic_std_rm pma_mode basic duplex_mode duplex channels 8 set_data_rate 5000 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode pma_pcs set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 2 pll_select 0 enable_port_tx_analog_reset_ack 0 enable_port_tx_pma_clkout 0 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 set_cdr_refclk_freq 125.000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 enable_ports_adaptation 0 enable_port_rx_analog_reset_ack 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 std_tx_pcfifo_mode register_fifo std_rx_pcfifo_mode register_fifo enable_port_tx_std_pcfifo_full 0 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode {Serialize x2} std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 1 std_tx_8b10b_disp_ctrl_enable 1 std_rx_8b10b_enable 1 std_rx_rmfifo_mode {basic (single width)} std_rx_rmfifo_pattern_n 0 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 std_rx_word_aligner_pattern 380 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 16 std_rx_word_aligner_rgnumber 15 std_rx_word_aligner_fast_sync_status_enable 0 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 std_rx_polinv_enable 0 enable_port_rx_polinv 1 enable_port_rx_std_signaldetect 0 enable_ports_pipe_sw 1 enable_ports_pipe_hclk 1 enable_ports_pipe_g3_analog 1 enable_ports_pipe_rx_elecidle 1 enable_port_pipe_rx_polarity 1 enh_pcs_pma_width 40 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable s1_mode anlg_rx_eq_dc_gain_trim stg2_gain7 anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_1 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_3 anlg_rx_adp_vga_sel radp_vga_sel_2 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1} enable_pcie_dfe_ip $enable_dfe_ip sim_reduced_counters $enable_dfe_ip_sim_mode ]
      foreach {param val} $param_val_list {
        set_instance_parameter_value phy_g3x8 $param $val
      }
   }

   # PLL instantiation
   ##### Create PLL instance #####
   if { [regexp Gen1 $lane_rate] || [regexp Gen2 $lane_rate] }  {
     if { [regexp x1 $link_width] } {
       add_hdl_instance fpll_g1g2x1 altera_xcvr_fpll_a10
       set param_val_list [list gui_fpll_mode 2 gui_enable_hip_cal_done_port 1 gui_hip_cal_en 1 gui_hssi_prot_mode 2 gui_hssi_output_clock_frequency 2500.0 base_device $base_device enable_pll_reconfig 1]
       foreach {param val} $param_val_list {
          set_instance_parameter_value fpll_g1g2x1 $param $val
       }
     } else {
       add_hdl_instance fpll_g1g2xn altera_xcvr_fpll_a10
       set param_val_list [list gui_fpll_mode 2 gui_enable_hip_cal_done_port 1 gui_hip_cal_en 1 gui_hssi_prot_mode 2 gui_hssi_output_clock_frequency 2500.0 enable_mcgb 1 enable_bonding_clks 1 enable_mcgb_pcie_clksw 1 pma_width 10 base_device $base_device enable_pll_reconfig 1]
       foreach {param val} $param_val_list {
          set_instance_parameter_value fpll_g1g2xn $param $val
       }
     }
   } elseif { [regexp Gen3 $lane_rate] } {

      # FPLL
      add_hdl_instance fpll_g3 altera_xcvr_fpll_a10
      set param_val_list [list gui_fpll_mode 2 gui_enable_hip_cal_done_port 1 gui_hip_cal_en 1 gui_hssi_prot_mode 2 gui_hssi_output_clock_frequency 2500.0 base_device $base_device enable_pll_reconfig 1]
      foreach {param val} $param_val_list {
         set_instance_parameter_value fpll_g3 $param $val
      }

      if { [regexp x1 $link_width] } {
         # ATX PLL
         add_hdl_instance lcpll_g3x1 altera_xcvr_atx_pll_a10
         set param_val_list [list prot_mode {PCIe Gen 3} set_auto_reference_clock_frequency 100.0 bw_sel high set_output_clock_frequency 4000.0 enable_hip_cal_done_port 1 set_hip_cal_en 1 base_device $base_device enable_pll_reconfig 1]
         foreach {param val} $param_val_list {
            set_instance_parameter_value lcpll_g3x1 $param $val
         }
      } else {
         # ATX PLL
         add_hdl_instance lcpll_g3xn altera_xcvr_atx_pll_a10
         set param_val_list [list prot_mode {PCIe Gen 3} set_auto_reference_clock_frequency 100.0 enable_8G_path 0 bw_sel high enable_pcie_clk 1 enable_mcgb 1 set_output_clock_frequency 4000.0 enable_mcgb_pcie_clksw 1 mcgb_aux_clkin_cnt 1 enable_bonding_clks 1 pma_width 32 enable_hip_cal_done_port 1 set_hip_cal_en 1 base_device $base_device enable_pll_reconfig 1]
         foreach {param val} $param_val_list {
            set_instance_parameter_value lcpll_g3xn $param $val
         }
      }
   }
}

proc ::altera_pcie_a10_hip::fileset::declare_tb_partner {} {
   set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_a10_tbed
   set_module_assignment testbench.partner.pcie_tb.version 18.1
   set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial
}

proc ::altera_pcie_a10_hip::fileset::render_top_level {output_name} {
  # get template
  set template_path "altpcie_a10_hip_hwtcl.v.terp" ;# path to the TERP template
  set template_fd [open $template_path] ;# file handle for template
  set template   [read $template_fd] ;# template contents
  close $template_fd ;# we are done with the file so we should close it
  set params(output_name) $output_name ;
  set contents [altera_terp $template params] ;
  return $contents
}

proc ::altera_pcie_a10_hip::fileset::callback_quartus_synth {ip_name} {

   set top_level_contents [::altera_pcie_a10_hip::fileset::render_top_level $ip_name]

   # adding a top level component file
   add_fileset_file ${ip_name}.v VERILOG TEXT $top_level_contents

   add_fileset_file altpcie_a10_hip_pipen1b.v                VERILOG PATH       altpcie_a10_hip_pipen1b.v
   add_fileset_file altpcie_sc_bitsync.v                     VERILOG PATH       altpcie_sc_bitsync.v
   add_fileset_file altpcie_reset_delay_sync.v               VERILOG PATH       altpcie_reset_delay_sync.v
   add_fileset_file altpcie_rs_a10_hip.v                     VERILOG PATH       altpcie_rs_a10_hip.v
   add_fileset_file altpcie_a10_hip_pllnphy.v                VERILOG PATH       altpcie_a10_hip_pllnphy.v
   add_fileset_file skp_det_g3.v                             VERILOG PATH       skp_det_g3.v
   add_fileset_file altera_xcvr_functions.sv                 SYSTEMVERILOG PATH ../../altera_xcvr_generic/altera_xcvr_functions.sv

   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]
   set enable_ast_trs_hwtcl                 [ip_get "parameter.enable_ast_trs_hwtcl.value"]
   set data_width_integer_hwtcl             [ip_get "parameter.data_width_integer_hwtcl.value"]
   set include_dma_hwtcl                    [ip_get "parameter.include_dma_hwtcl.value"]
   set internal_controller_hwtcl            [ip_get "parameter.internal_controller_hwtcl.value"]
   set include_sriov_hwtcl                  [ip_get "parameter.include_sriov_hwtcl.value"]
   set sriov2_en                            [ip_get "parameter.sriov2_en.value"]
   set cseb_autonomous_hwtcl                [ip_get "parameter.cseb_autonomous_hwtcl.value"]

   # First-level Signal Tap Debug files
   add_fileset_file debug/stp/alt_pcie_hip_a10.xml          OTHER   PATH          alt_pcie_hip_a10.txt
   add_fileset_file debug/stp/build_stp.tcl                 OTHER   PATH          build_stp.tcl

   set enable_skp_det                       [ip_get "parameter.enable_skp_det.value"]

   # TLP Inspector files
   add_fileset_file altpcie_tlp_inspector_a10.v             VERILOG PATH          altpcie_tlp_inspector_a10.v
   add_fileset_file altpcie_tlp_inspector_cseb_a10.sv       SYSTEM_VERILOG PATH   altpcie_tlp_inspector_cseb_a10.sv
   add_fileset_file altpcie_tlp_inspector_monitor_a10.sv    SYSTEM_VERILOG PATH   altpcie_tlp_inspector_monitor_a10.sv
   add_fileset_file altpcie_tlp_inspector_trigger_a10.v     VERILOG PATH          altpcie_tlp_inspector_trigger_a10.v
   add_fileset_file altpcie_tlp_inspector_pcsig_drive_a10.v VERILOG PATH          altpcie_tlp_inspector_pcsig_drive_a10.v
   add_fileset_file altpcie_a10_gbfifo.v                    VERILOG PATH          altpcie_a10_gbfifo.v
   add_fileset_file altpcie_a10_scfifo_ext.v                VERILOG PATH          altpcie_a10_scfifo_ext.v
   add_fileset_file altpcie_scfifo_a10.v                    VERILOG PATH          altpcie_scfifo_a10.v
   add_fileset_file altera_pci_express.sdc                  SDC     PATH          altera_pci_express.sdc

   if { $enable_skp_det==1 } {
      add_fileset_file altera_pcie_a10_skp.sdc              SDC     PATH          altera_pcie_a10_skp.sdc
   }

 if { $interface_type_integer_hwtcl==1 &&  $data_width_integer_hwtcl== 64} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav_stif_a2p_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_addrtrans.v
      add_fileset_file altpciexpav_stif_a2p_fixtrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_fixtrans.v
      add_fileset_file altpciexpav_stif_a2p_vartrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_vartrans.v
      add_fileset_file altpciexpav_stif_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_app.v
      add_fileset_file altpciexpav_stif_control_register.v VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_control_register.v
      add_fileset_file altpciexpav_stif_cr_avalon.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_avalon.v
      add_fileset_file altpciexpav_stif_cr_interrupt.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_interrupt.v
      add_fileset_file altpciexpav_stif_cr_rp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_rp.v
      add_fileset_file altpciexpav_stif_cfg_status.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cfg_status.v
      add_fileset_file altpciexpav_stif_cr_mailbox.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_mailbox.v
      add_fileset_file altpciexpav_stif_p2a_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_p2a_addrtrans.v
      add_fileset_file altpciexpav_stif_reg_fifo.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_reg_fifo.v
      add_fileset_file altpciexpav_stif_rx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx.v
      add_fileset_file altpciexpav_stif_rx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_cntrl.v
      add_fileset_file altpciexpav_stif_rx_resp.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_resp.v
      add_fileset_file altpciexpav_stif_tx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx.v
      add_fileset_file altpciexpav_stif_tx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx_cntrl.v
      add_fileset_file altpciexpav_stif_txavl_cntrl.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txavl_cntrl.v
      add_fileset_file altpciexpav_stif_txresp_cntrl.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txresp_cntrl.v
      add_fileset_file altpciexpav_clksync.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_clksync.v
      add_fileset_file altpciexpav_lite_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_lite/altpciexpav_lite_app.v
    }

 if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl== 128 && $include_dma_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav128_a2p_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_addrtrans.v
      add_fileset_file altpciexpav128_a2p_fixtrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_fixtrans.v
      add_fileset_file altpciexpav128_a2p_vartrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_vartrans.v
      add_fileset_file altpciexpav128_app.v                VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_app.v
      add_fileset_file altpciexpav128_clksync.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_control_register.v   VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_control_register.v
      add_fileset_file altpciexpav128_cr_avalon.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cr_rp.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_rp.v
      add_fileset_file altpciexpav128_cfg_status.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpciexpav128_p2a_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_p2a_addrtrans.v
      add_fileset_file altpciexpav128_rx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx.v
      add_fileset_file altpciexpav128_rx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_cntrl.v
      add_fileset_file altpciexpav128_fifo.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_fifo.v
      add_fileset_file altpciexpav128_rxm_adapter.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rxm_adapter.v
      add_fileset_file altpciexpav128_rx_resp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_resp.v
      add_fileset_file altpciexpav128_tx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx.v
      add_fileset_file altpciexpav128_tx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx_cntrl.v
      add_fileset_file altpciexpav128_txavl_cntrl.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txavl_cntrl.v
      add_fileset_file altpciexpav128_txresp_cntrl.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txresp_cntrl.v
    }

   if { $interface_type_integer_hwtcl==1 && $include_dma_hwtcl==1 && $enable_ast_trs_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_256_app.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv
      add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr.sv
      add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_readmem.sv
      add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_tlpgen.sv
      add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_wdalign.sv
      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
      add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_rdwr.sv
      add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_cpl.sv
      add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_txctrl.sv
      add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm.sv
      if ($internal_controller_hwtcl==1) {
        add_fileset_file altpcie_rxm_2_dma_controller_decode.v  VERILOG PATH ../altera_pcie_hip_256_avmm/altpcie_rxm_2_dma_controller_decode.v
        add_fileset_file dma_controller.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/dma_controller.sv
        add_fileset_file altpcie_dynamic_control.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/altpcie_dynamic_control.sv
      }
   }

   if { $interface_type_integer_hwtcl==1 && $enable_ast_trs_hwtcl==1} {
      add_fileset_file altpcie_ast_translator.sv           SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_ast_translator.sv
      add_fileset_file altpcie_a10_hip_ast_translator.sv   SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_a10_hip_ast_translator.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv

      add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr.sv
      add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_readmem.sv
      add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_tlpgen.sv
      add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_wdalign.sv

      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
   }
 if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl==256 && $include_dma_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav_256_cr_avalon.v            VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_avalon.v
      add_fileset_file altpciexpav_256_cr_interrupt.v         VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_interrupt.v
      add_fileset_file altpciexpav_256_cfg_status.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cfg_status.v
      add_fileset_file altpciexpav_256_cr_mailbox.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_control_register.v
    }

   if { $include_sriov_hwtcl==1 } {
     if { $sriov2_en==0 } {
          add_fileset_file altera_pcie_sriov_bridge.sv       SYSTEM_VERILOG PATH  ../altera_pcie_sriov/rtl/altera_pcie_sriov_bridge.sv
          add_fileset_file altpcied_sriov_top.v              VERILOG PATH         ../altera_pcie_sriov/rtl/altpcied_sriov_top.v
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH            altpcie_a10_lmi_burst_intf.v
          add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v

          add_fileset_file altpcied_sriov_rx_data_bridge.v              VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_rx_data_bridge.v
          add_fileset_file altpcied_sriov_tx_data_bridge.v              VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_tx_data_bridge.v
          add_fileset_file altpcied_sriov_cfg_dataflow.v                VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_dataflow.v
          add_fileset_file altpcied_sriov_cfg_fn0_regset.v              VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_fn0_regset.v
          add_fileset_file altpcied_sriov_cfg_fn1_regset.v              VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_fn1_regset.v
          add_fileset_file altpcied_sriov_rx_bar_check.v                VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_rx_bar_check.v
          add_fileset_file altpcied_sriov_cfg_vf_flr.v                  VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_flr.v
          add_fileset_file altpcied_sriov_cfg_vf_mux.v                  VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_mux.v
          add_fileset_file altpcied_sriov_cfg_vf_pci_cmd_status_reg.v   VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v
          add_fileset_file altpcied_sriov_cfg_vf_pcie_dev_status_reg.v  VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v
          add_fileset_file altpcied_sriov_cfg_vf_regset.v               VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_regset.v
          add_fileset_file altpcied_sriov_cfg_vf_msi_cap.v              VERILOG  PATH ../altera_pcie_sriov/rtl/altpcied_sriov_cfg_vf_msi_cap.v
      } else {

          add_fileset_file altera_pcie_sriov2_bridge.sv      SYSTEM_VERILOG PATH ../altera_pcie_sriov2/rtl/altera_pcie_sriov2_bridge.sv
          add_fileset_file altpcie_sriov2_top.v              VERILOG PATH        ../altera_pcie_sriov2/rtl/altpcie_sriov2_top.v
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH           altpcie_a10_lmi_burst_intf.v

          add_fileset_file altpcie_sriov2_bar_check_vf_mux.v                  VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_bar_check_vf_mux.v
          add_fileset_file altpcie_sriov2_cfg_dataflow.v                      VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_dataflow.v
          add_fileset_file altpcie_sriov2_cfg_fn0_regset.v                    VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_fn0_regset.v
          add_fileset_file altpcie_sriov2_cfg_fn123_regset.v                  VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_fn123_regset.v
          add_fileset_file altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_ats_cap.v
          add_fileset_file altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v
          add_fileset_file altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_msix_cap.v
          add_fileset_file altpcie_sriov2_cfg_vf_mux.v                        VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_mux.v
          add_fileset_file altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v
          add_fileset_file altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v
          add_fileset_file altpcie_sriov2_cfg_vf_regset.v                     VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_regset.v
          add_fileset_file altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v 
          add_fileset_file altpcie_sriov2_cfg_vf_status_array.v               VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_status_array.v
          add_fileset_file altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v
          add_fileset_file altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v
          add_fileset_file altpcie_sriov2_rx_bar_check.v                      VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_rx_bar_check.v
          add_fileset_file altpcie_sriov2_rx_data_bridge.v                    VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_rx_data_bridge.v
          add_fileset_file altpcie_sriov2_tx_data_bridge.v                    VERILOG PATH ../altera_pcie_sriov2/rtl/altpcie_sriov2_tx_data_bridge.v
          add_fileset_file altpcierd_hip_rs.v                                 VERILOG PATH ../altera_pcie_sriov2/rtl/altpcierd_hip_rs.v

      }
      if {($cseb_autonomous_hwtcl ==1)} {
         # Config-Bypass Speed Change Autonomous mode files
         add_fileset_file altpcie_sc_ctrl.v                      VERILOG PATH          altpcie_sc_ctrl.v
         add_fileset_file altpcie_sc_dprio_rd_wr.v               VERILOG PATH          altpcie_sc_dprio_rd_wr.v
         add_fileset_file altpcie_sc_dprio_seq.v                 VERILOG PATH          altpcie_sc_dprio_seq.v
         add_fileset_file altpcie_sc_dprio_top.v                 VERILOG PATH          altpcie_sc_dprio_top.v
         add_fileset_file altpcie_sc_hip_vecsync2.v              VERILOG PATH          altpcie_sc_hip_vecsync2.v
         add_fileset_file altpcie_sc_lvlsync.v                   VERILOG PATH          altpcie_sc_lvlsync.v
         add_fileset_file altpcie_sc_lvlsync2.v                  VERILOG PATH          altpcie_sc_lvlsync2.v
      }
   }
}

proc ::altera_pcie_a10_hip::fileset::callback_sim_verilog {ip_name} {

   set top_level_contents [::altera_pcie_a10_hip::fileset::render_top_level $ip_name]

   # adding a top level component file
   add_fileset_file ${ip_name}.v VERILOG TEXT $top_level_contents
   add_fileset_file altpcie_a10_hip_pipen1b.v               VERILOG PATH       altpcie_a10_hip_pipen1b.v
   add_fileset_file altpcie_sc_bitsync.v                    VERILOG PATH       altpcie_sc_bitsync.v
   add_fileset_file altpcie_reset_delay_sync.v              VERILOG PATH       altpcie_reset_delay_sync.v
   add_fileset_file altpcie_rs_a10_hip.v                    VERILOG PATH       altpcie_rs_a10_hip.v
   add_fileset_file altpcie_a10_hip_pllnphy.v               VERILOG PATH       altpcie_a10_hip_pllnphy.v
   add_fileset_file skp_det_g3.v                            VERILOG PATH       skp_det_g3.v
   add_fileset_file altera_xcvr_functions.sv                SYSTEMVERILOG PATH ../../altera_xcvr_generic/altera_xcvr_functions.sv
   add_fileset_file altpcie_monitor_a10_dlhip_sim.sv        SYSTEMVERILOG PATH altpcie_monitor_a10_dlhip_sim.sv

   # TLP Inspector files
   add_fileset_file altpcie_tlp_inspector_a10.v             VERILOG PATH          altpcie_tlp_inspector_a10.v
   add_fileset_file altpcie_tlp_inspector_cseb_a10.sv       SYSTEM_VERILOG PATH   altpcie_tlp_inspector_cseb_a10.sv
   add_fileset_file altpcie_tlp_inspector_monitor_a10.sv    SYSTEM_VERILOG PATH   altpcie_tlp_inspector_monitor_a10.sv
   add_fileset_file altpcie_tlp_inspector_trigger_a10.v     VERILOG PATH          altpcie_tlp_inspector_trigger_a10.v
   add_fileset_file altpcie_tlp_inspector_pcsig_drive_a10.v VERILOG PATH          altpcie_tlp_inspector_pcsig_drive_a10.v
   add_fileset_file altpcie_a10_gbfifo.v                    VERILOG PATH          altpcie_a10_gbfifo.v
   add_fileset_file altpcie_scfifo_a10.v                    VERILOG PATH          altpcie_scfifo_a10.v
   add_fileset_file altpcie_a10_scfifo_ext.v                VERILOG PATH          altpcie_a10_scfifo_ext.v

   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]
   set enable_ast_trs_hwtcl                 [ip_get "parameter.enable_ast_trs_hwtcl.value"]
   set data_width_integer_hwtcl             [ip_get "parameter.data_width_integer_hwtcl.value"]
   set include_dma_hwtcl                    [ip_get "parameter.include_dma_hwtcl.value"]
   set internal_controller_hwtcl            [ip_get "parameter.internal_controller_hwtcl.value"]
   set include_sriov_hwtcl                  [ip_get "parameter.include_sriov_hwtcl.value"]
   set sriov2_en                            [ip_get "parameter.sriov2_en.value"]
   set cseb_autonomous_hwtcl                [ip_get "parameter.cseb_autonomous_hwtcl.value"]

 if { $interface_type_integer_hwtcl==1 &&  $data_width_integer_hwtcl== 64} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav_stif_a2p_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_addrtrans.v
      add_fileset_file altpciexpav_stif_a2p_fixtrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_fixtrans.v
      add_fileset_file altpciexpav_stif_a2p_vartrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_vartrans.v
      add_fileset_file altpciexpav_stif_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_app.v
      add_fileset_file altpciexpav_stif_control_register.v VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_control_register.v
      add_fileset_file altpciexpav_stif_cr_avalon.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_avalon.v
      add_fileset_file altpciexpav_stif_cr_interrupt.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_interrupt.v
      add_fileset_file altpciexpav_stif_cr_rp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_rp.v
      add_fileset_file altpciexpav_stif_cfg_status.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cfg_status.v
      add_fileset_file altpciexpav_stif_cr_mailbox.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_mailbox.v
      add_fileset_file altpciexpav_stif_p2a_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_p2a_addrtrans.v
      add_fileset_file altpciexpav_stif_reg_fifo.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_reg_fifo.v
      add_fileset_file altpciexpav_stif_rx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx.v
      add_fileset_file altpciexpav_stif_rx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_cntrl.v
      add_fileset_file altpciexpav_stif_rx_resp.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_resp.v
      add_fileset_file altpciexpav_stif_tx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx.v
      add_fileset_file altpciexpav_stif_tx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx_cntrl.v
      add_fileset_file altpciexpav_stif_txavl_cntrl.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txavl_cntrl.v
      add_fileset_file altpciexpav_stif_txresp_cntrl.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txresp_cntrl.v
      add_fileset_file altpciexpav_clksync.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_clksync.v
      add_fileset_file altpciexpav_lite_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_lite/altpciexpav_lite_app.v
    }

 if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl== 128 && $include_dma_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav128_a2p_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_addrtrans.v
      add_fileset_file altpciexpav128_a2p_fixtrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_fixtrans.v
      add_fileset_file altpciexpav128_a2p_vartrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_vartrans.v
      add_fileset_file altpciexpav128_app.v                VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_app.v
      add_fileset_file altpciexpav128_clksync.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_control_register.v   VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_control_register.v
      add_fileset_file altpciexpav128_cr_avalon.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cr_rp.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_rp.v
      add_fileset_file altpciexpav128_cfg_status.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpciexpav128_p2a_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_p2a_addrtrans.v
      add_fileset_file altpciexpav128_rx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx.v
      add_fileset_file altpciexpav128_rx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_cntrl.v
      add_fileset_file altpciexpav128_fifo.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_fifo.v
      add_fileset_file altpciexpav128_rxm_adapter.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rxm_adapter.v
      add_fileset_file altpciexpav128_rx_resp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_resp.v
      add_fileset_file altpciexpav128_tx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx.v
      add_fileset_file altpciexpav128_tx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx_cntrl.v
      add_fileset_file altpciexpav128_txavl_cntrl.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txavl_cntrl.v
      add_fileset_file altpciexpav128_txresp_cntrl.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txresp_cntrl.v
    }

   if { $interface_type_integer_hwtcl==1 && $include_dma_hwtcl==1 && $enable_ast_trs_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_256_app.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv

      add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr.sv
      add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_readmem.sv
      add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_tlpgen.sv
      add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_wdalign.sv

      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
      add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_rdwr.sv
      add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_cpl.sv
      add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_txctrl.sv
      add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm.sv
      if ($internal_controller_hwtcl==1) {
        add_fileset_file altpcie_rxm_2_dma_controller_decode.v  VERILOG PATH ../altera_pcie_hip_256_avmm/altpcie_rxm_2_dma_controller_decode.v
        add_fileset_file dma_controller.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/dma_controller.sv
        add_fileset_file altpcie_dynamic_control.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/altpcie_dynamic_control.sv
      }
   }

   if { $interface_type_integer_hwtcl==1 && $enable_ast_trs_hwtcl==1} {
      add_fileset_file altpcie_ast_translator.sv           SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_ast_translator.sv
      add_fileset_file altpcie_a10_hip_ast_translator.sv   SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_a10_hip_ast_translator.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv

       add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr.sv
       add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_readmem.sv
       add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_tlpgen.sv
       add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_wdalign.sv

      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
   }

 if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl==256 && $include_dma_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav_256_cr_avalon.v            VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_avalon.v
      add_fileset_file altpciexpav_256_cr_interrupt.v         VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_interrupt.v
      add_fileset_file altpciexpav_256_cfg_status.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cfg_status.v
      add_fileset_file altpciexpav_256_cr_mailbox.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_control_register.v
    }

 if { $include_sriov_hwtcl==1 } {
   if { $sriov2_en==0 } {
          add_fileset_file altera_pcie_sriov_bridge.sv       SYSTEM_VERILOG PATH  ../altera_pcie_sriov/rtl/altera_pcie_sriov_bridge.sv
          add_fileset_file altpcied_sriov_top.v              VERILOG PATH         ../altera_pcie_sriov/rtl/altpcied_sriov_top.v
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH            altpcie_a10_lmi_burst_intf.v
          add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
          # Mentor
       if {1} {
          add_fileset_file mentor/altpcied_sriov_rx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_rx_data_bridge.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_tx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_tx_data_bridge.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_dataflow.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_dataflow.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_fn0_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_fn0_regset.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_fn1_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_fn1_regset.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_rx_bar_check.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_rx_bar_check.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_flr.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_flr.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_mux.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v   VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_regset.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_regset.v              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_msi_cap.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_msi_cap.v             MENTOR_SPECIFIC
       }

          # Cadence
       if {1} {
          add_fileset_file cadence/altpcied_sriov_rx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_rx_data_bridge.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_tx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_tx_data_bridge.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_dataflow.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_dataflow.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_fn0_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_fn0_regset.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_fn1_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_fn1_regset.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_rx_bar_check.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_rx_bar_check.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_flr.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_flr.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_mux.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v   VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_regset.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_regset.v              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_msi_cap.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_msi_cap.v             CADENCE_SPECIFIC
       }

          # Synopsys
       if {1} {
          add_fileset_file synopsys/altpcied_sriov_rx_data_bridge.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_rx_data_bridge.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_tx_data_bridge.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_tx_data_bridge.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_dataflow.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_dataflow.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_fn0_regset.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_fn0_regset.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_fn1_regset.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_fn1_regset.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_rx_bar_check.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_rx_bar_check.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_flr.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_flr.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_mux.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_mux.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_regset.v              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_msi_cap.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_msi_cap.v             SYNOPSYS_SPECIFIC
       }

          # Aldec
       if {1} {
          add_fileset_file aldec/altpcied_sriov_rx_data_bridge.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_rx_data_bridge.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_tx_data_bridge.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_tx_data_bridge.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_dataflow.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_dataflow.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_fn0_regset.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_fn0_regset.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_fn1_regset.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_fn1_regset.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_rx_bar_check.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_rx_bar_check.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_flr.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_flr.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_mux.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_mux.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v     VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_regset.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_regset.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_msi_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_msi_cap.v                ALDEC_SPECIFIC

        }
    } else {

          add_fileset_file altera_pcie_sriov2_bridge.sv      SYSTEM_VERILOG PATH ../altera_pcie_sriov2/rtl/altera_pcie_sriov2_bridge.sv
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH           altpcie_a10_lmi_burst_intf.v

          # Mentor
       if {1} {
          add_fileset_file mentor/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_top.v                              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_bar_check_vf_mux.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_dataflow.v                     MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_fn0_regset.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_fn123_regset.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_mux.v                       MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_regset.v                    MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_status_array.v              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_rx_bar_check.v                     MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_rx_data_bridge.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_tx_data_bridge.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcierd_hip_rs.v                                MENTOR_SPECIFIC

           }
          # Cadence
       if {1} {
          add_fileset_file cadence/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_top.v                              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_bar_check_vf_mux.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_dataflow.v                     CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_fn0_regset.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_fn123_regset.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_mux.v                       CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_regset.v                    CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_status_array.v              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_rx_bar_check.v                     CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_rx_data_bridge.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_tx_data_bridge.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcierd_hip_rs.v                                CADENCE_SPECIFIC

           }
          # Synopsys
       if {1} {
          add_fileset_file synopsys/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_top.v                              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_bar_check_vf_mux.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_dataflow.v                     SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_fn0_regset.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_fn123_regset.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_mux.v                       SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_regset.v                    SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_status_array.v              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_rx_bar_check.v                     SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_rx_data_bridge.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_tx_data_bridge.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcierd_hip_rs.v                                SYNOPSYS_SPECIFIC

           }
          # Aldec
       if {1} {
          add_fileset_file aldec/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_top.v                              ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_bar_check_vf_mux.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_dataflow.v                     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_fn0_regset.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_fn123_regset.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_mux.v                       ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_regset.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_status_array.v              ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_rx_bar_check.v                     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_rx_data_bridge.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_tx_data_bridge.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcierd_hip_rs.v                                ALDEC_SPECIFIC

           }

           }


      if {($cseb_autonomous_hwtcl ==1)} {
         # Config-Bypass Speed Change Autonomous mode files
         add_fileset_file altpcie_sc_ctrl.v                      VERILOG PATH          altpcie_sc_ctrl.v
         add_fileset_file altpcie_sc_dprio_rd_wr.v               VERILOG PATH          altpcie_sc_dprio_rd_wr.v
         add_fileset_file altpcie_sc_dprio_seq.v                 VERILOG PATH          altpcie_sc_dprio_seq.v
         add_fileset_file altpcie_sc_dprio_top.v                 VERILOG PATH          altpcie_sc_dprio_top.v
         add_fileset_file altpcie_sc_hip_vecsync2.v              VERILOG PATH          altpcie_sc_hip_vecsync2.v
         add_fileset_file altpcie_sc_lvlsync.v                   VERILOG PATH          altpcie_sc_lvlsync.v
         add_fileset_file altpcie_sc_lvlsync2.v                  VERILOG PATH          altpcie_sc_lvlsync2.v
      }
  }
}

proc ::altera_pcie_a10_hip::fileset::callback_sim_vhdl {ip_name} {

   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]
   set enable_ast_trs_hwtcl                 [ip_get "parameter.enable_ast_trs_hwtcl.value"]
   set data_width_integer_hwtcl             [ip_get "parameter.data_width_integer_hwtcl.value"]
   set include_dma_hwtcl                    [ip_get "parameter.include_dma_hwtcl.value"]
   set internal_controller_hwtcl            [ip_get "parameter.internal_controller_hwtcl.value"]
   set include_sriov_hwtcl                  [ip_get "parameter.include_sriov_hwtcl.value"]
   set sriov2_en                            [ip_get "parameter.sriov2_en.value"]
   set cseb_autonomous_hwtcl                [ip_get "parameter.cseb_autonomous_hwtcl.value"]

   set top_level_contents [::altera_pcie_a10_hip::fileset::render_top_level $ip_name]

   # adding a top level component file
   add_fileset_file ${ip_name}.v VERILOG TEXT $top_level_contents

    if {1} {
#        add_fileset_file mentor/altpcie_a10_hip_hwtcl.v                 VERILOG_ENCRYPT       PATH      mentor/altpcie_a10_hip_hwtcl.v                              MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_a10_hip_pipen1b.v               VERILOG_ENCRYPT       PATH      mentor/altpcie_a10_hip_pipen1b.v                            MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_sc_bitsync.v                    VERILOG_ENCRYPT       PATH      mentor/altpcie_sc_bitsync.v                                 MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_reset_delay_sync.v              VERILOG_ENCRYPT       PATH      mentor/altpcie_reset_delay_sync.v                           MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_rs_a10_hip.v                    VERILOG_ENCRYPT       PATH      mentor/altpcie_rs_a10_hip.v                                 MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_a10_hip_pllnphy.v               VERILOG_ENCRYPT       PATH      mentor/altpcie_a10_hip_pllnphy.v                            MENTOR_SPECIFIC
         add_fileset_file mentor/skp_det_g3.v                            VERILOG_ENCRYPT       PATH      mentor/skp_det_g3.v
         add_fileset_file mentor/altera_xcvr_functions.sv                SYSTEMVERILOG_ENCRYPT PATH      ../../altera_xcvr_generic/mentor/altera_xcvr_functions.sv   MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_monitor_a10_dlhip_sim.sv        SYSTEMVERILOG_ENCRYPT PATH      mentor/altpcie_monitor_a10_dlhip_sim.sv                     MENTOR_SPECIFIC

         # TLP Inspector files
         add_fileset_file mentor/altpcie_tlp_inspector_a10.v             VERILOG_ENCRYPT PATH          mentor/altpcie_tlp_inspector_a10.v                   MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_tlp_inspector_cseb_a10.sv       SYSTEM_VERILOG_ENCRYPT PATH   mentor/altpcie_tlp_inspector_cseb_a10.sv             MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_tlp_inspector_monitor_a10.sv    SYSTEM_VERILOG_ENCRYPT PATH   mentor/altpcie_tlp_inspector_monitor_a10.sv          MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_tlp_inspector_trigger_a10.v     VERILOG_ENCRYPT PATH          mentor/altpcie_tlp_inspector_trigger_a10.v           MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_tlp_inspector_pcsig_drive_a10.v VERILOG_ENCRYPT PATH          mentor/altpcie_tlp_inspector_pcsig_drive_a10.v       MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_a10_gbfifo.v                    VERILOG_ENCRYPT PATH          mentor/altpcie_a10_gbfifo.v                          MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_a10_scfifo_ext.v                VERILOG_ENCRYPT PATH          mentor/altpcie_a10_scfifo_ext.v                      MENTOR_SPECIFIC
         add_fileset_file mentor/altpcie_scfifo_a10.v                    VERILOG_ENCRYPT PATH          mentor/altpcie_scfifo_a10.v                          MENTOR_SPECIFIC

      }

      # TLP Inspector files SYNOPSYS
      add_fileset_file synopsys/altpcie_tlp_inspector_a10.v              VERILOG         PATH          altpcie_tlp_inspector_a10.v                   SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_tlp_inspector_cseb_a10.sv        SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_cseb_a10.sv             SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_tlp_inspector_monitor_a10.sv     SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_monitor_a10.sv          SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_tlp_inspector_trigger_a10.v      VERILOG         PATH          altpcie_tlp_inspector_trigger_a10.v           SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_tlp_inspector_pcsig_drive_a10.v  VERILOG         PATH          altpcie_tlp_inspector_pcsig_drive_a10.v       SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_a10_gbfifo.v                     VERILOG         PATH          altpcie_a10_gbfifo.v                          SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_a10_scfifo_ext.v                 VERILOG         PATH          altpcie_a10_scfifo_ext.v                      SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_scfifo_a10.v                     VERILOG         PATH          altpcie_scfifo_a10.v                          SYNOPSYS_SPECIFIC

      # TLP Inspector files CADENCE
      add_fileset_file cadence/altpcie_tlp_inspector_a10.v               VERILOG         PATH          altpcie_tlp_inspector_a10.v                  CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_tlp_inspector_cseb_a10.sv         SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_cseb_a10.sv            CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_tlp_inspector_monitor_a10.sv      SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_monitor_a10.sv         CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_tlp_inspector_trigger_a10.v       VERILOG         PATH          altpcie_tlp_inspector_trigger_a10.v          CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_tlp_inspector_pcsig_drive_a10.v   VERILOG         PATH          altpcie_tlp_inspector_pcsig_drive_a10.v      CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_a10_gbfifo.v                      VERILOG         PATH          altpcie_a10_gbfifo.v                         CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_a10_scfifo_ext.v                  VERILOG         PATH          altpcie_a10_scfifo_ext.v                     CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_scfifo_a10.v                      VERILOG         PATH          altpcie_scfifo_a10.v                         CADENCE_SPECIFIC

      # TLP Inspector files ALDEC
      add_fileset_file aldec/altpcie_tlp_inspector_a10.v                 VERILOG         PATH          altpcie_tlp_inspector_a10.v                   ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_tlp_inspector_cseb_a10.sv           SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_cseb_a10.sv             ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_tlp_inspector_monitor_a10.sv        SYSTEM_VERILOG  PATH          altpcie_tlp_inspector_monitor_a10.sv          ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_tlp_inspector_trigger_a10.v         VERILOG         PATH          altpcie_tlp_inspector_trigger_a10.v           ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_tlp_inspector_pcsig_drive_a10.v     VERILOG         PATH          altpcie_tlp_inspector_pcsig_drive_a10.v       ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_a10_gbfifo.v                        VERILOG         PATH          altpcie_a10_gbfifo.v                          ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_a10_scfifo_ext.v                    VERILOG         PATH          altpcie_a10_scfifo_ext.v                      ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_scfifo_a10.v                        VERILOG         PATH          altpcie_scfifo_a10.v                          ALDEC_SPECIFIC

#      add_fileset_file synopsys/altpcie_a10_hip_hwtcl.v                 VERILOG       PATH      altpcie_a10_hip_hwtcl.v                                     SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_a10_hip_pipen1b.v                VERILOG       PATH      altpcie_a10_hip_pipen1b.v                                   SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_sc_bitsync.v                     VERILOG       PATH      altpcie_sc_bitsync.v                                        SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_reset_delay_sync.v               VERILOG       PATH      altpcie_reset_delay_sync.v                                  SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_rs_a10_hip.v                     VERILOG       PATH      altpcie_rs_a10_hip.v                                        SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_a10_hip_pllnphy.v                VERILOG       PATH      altpcie_a10_hip_pllnphy.v                                   SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/skp_det_g3.v                             VERILOG       PATH      skp_det_g3.v                                                SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altera_xcvr_functions.sv                 SYSTEMVERILOG PATH      ../../altera_xcvr_generic/altera_xcvr_functions.sv          SYNOPSYS_SPECIFIC
      add_fileset_file synopsys/altpcie_monitor_a10_dlhip_sim.sv         SYSTEMVERILOG PATH      altpcie_monitor_a10_dlhip_sim.sv                            SYNOPSYS_SPECIFIC
#      add_fileset_file cadence/altpcie_a10_hip_hwtcl.v                   VERILOG       PATH      altpcie_a10_hip_hwtcl.v                                     CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_a10_hip_pipen1b.v                 VERILOG       PATH      altpcie_a10_hip_pipen1b.v                                   CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_sc_bitsync.v                      VERILOG       PATH      altpcie_sc_bitsync.v                                        CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_reset_delay_sync.v                VERILOG       PATH      altpcie_reset_delay_sync.v                                  CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_rs_a10_hip.v                      VERILOG       PATH      altpcie_rs_a10_hip.v                                        CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_a10_hip_pllnphy.v                 VERILOG       PATH      altpcie_a10_hip_pllnphy.v                                   CADENCE_SPECIFIC
      add_fileset_file cadence/skp_det_g3.v                              VERILOG       PATH      skp_det_g3.v                                                CADENCE_SPECIFIC
      add_fileset_file cadence/altera_xcvr_functions.sv                  SYSTEMVERILOG PATH      ../../altera_xcvr_generic/altera_xcvr_functions.sv          CADENCE_SPECIFIC
      add_fileset_file cadence/altpcie_monitor_a10_dlhip_sim.sv          SYSTEMVERILOG PATH      altpcie_monitor_a10_dlhip_sim.sv                            CADENCE_SPECIFIC
#      add_fileset_file aldec/altpcie_a10_hip_hwtcl.v                     VERILOG       PATH      altpcie_a10_hip_hwtcl.v                                     ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_a10_hip_pipen1b.v                   VERILOG       PATH      altpcie_a10_hip_pipen1b.v                                   ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_sc_bitsync.v                        VERILOG       PATH      altpcie_sc_bitsync.v                                        ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_reset_delay_sync.v                  VERILOG       PATH      altpcie_reset_delay_sync.v                                  ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_rs_a10_hip.v                        VERILOG       PATH      altpcie_rs_a10_hip.v                                        ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_a10_hip_pllnphy.v                   VERILOG       PATH      altpcie_a10_hip_pllnphy.v                                   ALDEC_SPECIFIC
      add_fileset_file aldec/skp_det_g3.v                                VERILOG       PATH      skp_det_g3.v                                                ALDEC_SPECIFIC
      add_fileset_file aldec/altera_xcvr_functions.sv                    SYSTEMVERILOG PATH      ../../altera_xcvr_generic/altera_xcvr_functions.sv          ALDEC_SPECIFIC
      add_fileset_file aldec/altpcie_monitor_a10_dlhip_sim.sv            SYSTEMVERILOG PATH      altpcie_monitor_a10_dlhip_sim.sv                            ALDEC_SPECIFIC



 if { $interface_type_integer_hwtcl==1 &&  $data_width_integer_hwtcl== 64} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav_stif_a2p_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_addrtrans.v
      add_fileset_file altpciexpav_stif_a2p_fixtrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_fixtrans.v
      add_fileset_file altpciexpav_stif_a2p_vartrans.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_a2p_vartrans.v
      add_fileset_file altpciexpav_stif_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_app.v
      add_fileset_file altpciexpav_stif_control_register.v VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_control_register.v
      add_fileset_file altpciexpav_stif_cr_avalon.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_avalon.v
      add_fileset_file altpciexpav_stif_cr_interrupt.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_interrupt.v
      add_fileset_file altpciexpav_stif_cr_rp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_rp.v
      add_fileset_file altpciexpav_stif_cfg_status.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cfg_status.v
      add_fileset_file altpciexpav_stif_cr_mailbox.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_cr_mailbox.v
      add_fileset_file altpciexpav_stif_p2a_addrtrans.v    VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_p2a_addrtrans.v
      add_fileset_file altpciexpav_stif_reg_fifo.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_reg_fifo.v
      add_fileset_file altpciexpav_stif_rx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx.v
      add_fileset_file altpciexpav_stif_rx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_cntrl.v
      add_fileset_file altpciexpav_stif_rx_resp.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_rx_resp.v
      add_fileset_file altpciexpav_stif_tx.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx.v
      add_fileset_file altpciexpav_stif_tx_cntrl.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_tx_cntrl.v
      add_fileset_file altpciexpav_stif_txavl_cntrl.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txavl_cntrl.v
      add_fileset_file altpciexpav_stif_txresp_cntrl.v     VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_stif_txresp_cntrl.v
      add_fileset_file altpciexpav_clksync.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_stif/altpciexpav_clksync.v
      add_fileset_file altpciexpav_lite_app.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_lite/altpciexpav_lite_app.v
    }

if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl== 128 && $include_dma_hwtcl==0 } {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpciexpav128_a2p_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_addrtrans.v
      add_fileset_file altpciexpav128_a2p_fixtrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_fixtrans.v
      add_fileset_file altpciexpav128_a2p_vartrans.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_a2p_vartrans.v
      add_fileset_file altpciexpav128_app.v                VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_app.v
      add_fileset_file altpciexpav128_clksync.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_clksync.v
      add_fileset_file altpciexpav128_control_register.v   VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_control_register.v
      add_fileset_file altpciexpav128_cr_avalon.v          VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_avalon.v
      add_fileset_file altpciexpav128_cr_interrupt.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_interrupt.v
      add_fileset_file altpciexpav128_cr_rp.v              VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_rp.v
      add_fileset_file altpciexpav128_cfg_status.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cfg_status.v
      add_fileset_file altpciexpav128_cr_mailbox.v         VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_cr_mailbox.v
      add_fileset_file altpciexpav128_p2a_addrtrans.v      VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_p2a_addrtrans.v
      add_fileset_file altpciexpav128_rx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx.v
      add_fileset_file altpciexpav128_rx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_cntrl.v
      add_fileset_file altpciexpav128_fifo.v               VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_fifo.v
      add_fileset_file altpciexpav128_rxm_adapter.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rxm_adapter.v
      add_fileset_file altpciexpav128_rx_resp.v            VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_rx_resp.v
      add_fileset_file altpciexpav128_tx.v                 VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx.v
      add_fileset_file altpciexpav128_tx_cntrl.v           VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_tx_cntrl.v
      add_fileset_file altpciexpav128_txavl_cntrl.v        VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txavl_cntrl.v
      add_fileset_file altpciexpav128_txresp_cntrl.v       VERILOG PATH ../altera_pcie_av_hip_avmm/avalon_mm_128/altpciexpav128_txresp_cntrl.v
    }

   if { $interface_type_integer_hwtcl==1 && $include_dma_hwtcl==1  && $enable_ast_trs_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                  VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_app.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_256_app.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv

      add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr.sv
      add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_readmem.sv
      add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_tlpgen.sv
      add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav128_dma_wr_wdalign.sv

      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
      add_fileset_file altpcieav_dma_hprxm_rdwr.sv         SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_rdwr.sv
      add_fileset_file altpcieav_dma_hprxm_cpl.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_cpl.sv
      add_fileset_file altpcieav_dma_hprxm_txctrl.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm_txctrl.sv
      add_fileset_file altpcieav_dma_hprxm.sv              SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_hprxm.sv

      if ($internal_controller_hwtcl==1) {
        add_fileset_file altpcie_rxm_2_dma_controller_decode.v  VERILOG PATH ../altera_pcie_hip_256_avmm/altpcie_rxm_2_dma_controller_decode.v
        add_fileset_file dma_controller.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/dma_controller.sv
        add_fileset_file altpcie_dynamic_control.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/dynamic_controller/altpcie_dynamic_control.sv
      }
    }



   if { $interface_type_integer_hwtcl==1 && $enable_ast_trs_hwtcl==1} {
      add_fileset_file altpcie_ast_translator.sv           SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_ast_translator.sv
      add_fileset_file altpcie_a10_hip_ast_translator.sv   SYSTEM_VERILOG PATH a10_hip_ast_translator/altpcie_a10_hip_ast_translator.sv
      add_fileset_file altpcieav_hip_interface.sv          SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_hip_interface.sv
      add_fileset_file altpcieav_dma_rxm.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rxm.sv
      add_fileset_file altpcieav_dma_txs.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_txs.sv
      add_fileset_file altpcieav_dma_rd.sv                 SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_rd.sv
      add_fileset_file altpcieav_dma_wr_2.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_2.sv
      add_fileset_file altpcieav_dma_wr_readmem_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_readmem_2.sv
      add_fileset_file altpcieav_dma_wr_tlpgen_2.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_tlpgen_2.sv
      add_fileset_file altpcieav_dma_wr_wdalign_2.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma_wr_wdalign_2.sv

       add_fileset_file altpcieav128_dma_wr.sv               SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma128_wr.sv
       add_fileset_file altpcieav128_dma_wr_readmem.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma128_wr_readmem.sv
       add_fileset_file altpcieav128_dma_wr_tlpgen.sv        SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma128_wr_tlpgen.sv
       add_fileset_file altpcieav128_dma_wr_wdalign.sv       SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_dma128_wr_wdalign.sv

      add_fileset_file altpcieav_arbiter.sv                SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_arbiter.sv
      add_fileset_file altpcieav_cra.sv                    SYSTEM_VERILOG PATH ../altera_pcie_hip_256_avmm/rtl/altpcieav_cra.sv
      add_fileset_file altpcie_fifo.sv                     VERILOG PATH        ../altera_pcie_hip_256_avmm/rtl/altpcie_fifo.v
   }

 if { $interface_type_integer_hwtcl==1 && $data_width_integer_hwtcl==256 && $include_dma_hwtcl==0} {
      add_fileset_file altpcierd_hip_rs.v                     VERILOG PATH        ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
      add_fileset_file altpcieav_256_rp_app.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_app.sv
      add_fileset_file altpcieav_256_rp_hip_interface.sv      SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_hip_interface.sv
      add_fileset_file altpcieav_256_rp_txs.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_txs.sv
      add_fileset_file altpcieav_256_rp_arbiter.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_arbiter.sv
      add_fileset_file altpcie_256_rp_fifo.v                  VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_fifo.v
      add_fileset_file altpcieav_256_rp_rxm_rdwr.sv           SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_rdwr.sv
      add_fileset_file altpcieav_256_rp_rxm_cpl.sv            SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_cpl.sv
      add_fileset_file altpcieav_256_rp_rxm_txctrl.sv         SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm_txctrl.sv
      add_fileset_file altpcieav_256_rp_rxm.sv                SYSTEM_VERILOG PATH ./rp_avmm_256/rtl/altpcieav_256_rp_rxm.sv
      add_fileset_file altpcie_256_rp_cr.v                    VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_rp_cr.v
      add_fileset_file altpciexpav_256_cr_avalon.v            VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_avalon.v
      add_fileset_file altpciexpav_256_cr_interrupt.v         VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_interrupt.v
      add_fileset_file altpciexpav_256_cfg_status.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cfg_status.v
      add_fileset_file altpciexpav_256_cr_mailbox.v           VERILOG PATH        ./rp_avmm_256/rtl/altpciexpav_256_cr_mailbox.v
      add_fileset_file altpcie_256_control_register.v         VERILOG PATH        ./rp_avmm_256/rtl/altpcie_256_control_register.v
    }

 if { $include_sriov_hwtcl==1 } {
    if { $sriov2_en==0 } {
          add_fileset_file altera_pcie_sriov_bridge.sv       SYSTEM_VERILOG PATH  ../altera_pcie_sriov/rtl/altera_pcie_sriov_bridge.sv
          add_fileset_file altpcied_sriov_top.v              VERILOG PATH         ../altera_pcie_sriov/rtl/altpcied_sriov_top.v
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH            altpcie_a10_lmi_burst_intf.v
          add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ../altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
          # Mentor
       if {1} {
          add_fileset_file mentor/altpcied_sriov_rx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_rx_data_bridge.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_tx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_tx_data_bridge.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_dataflow.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_dataflow.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_fn0_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_fn0_regset.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_fn1_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_fn1_regset.v             MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_rx_bar_check.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_rx_bar_check.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_flr.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_flr.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_mux.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v   VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_regset.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_regset.v              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcied_sriov_cfg_vf_msi_cap.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/mentor/rtl/altpcied_sriov_cfg_vf_msi_cap.v             MENTOR_SPECIFIC
       }

          # Cadence
       if {1} {
          add_fileset_file cadence/altpcied_sriov_rx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_rx_data_bridge.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_tx_data_bridge.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_tx_data_bridge.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_dataflow.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_dataflow.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_fn0_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_fn0_regset.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_fn1_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_fn1_regset.v             CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_rx_bar_check.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_rx_bar_check.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_flr.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_flr.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_mux.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v   VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_regset.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_regset.v              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcied_sriov_cfg_vf_msi_cap.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/cadence/rtl/altpcied_sriov_cfg_vf_msi_cap.v             CADENCE_SPECIFIC
       }

          # Synopsys
       if {1} {
          add_fileset_file synopsys/altpcied_sriov_rx_data_bridge.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_rx_data_bridge.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_tx_data_bridge.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_tx_data_bridge.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_dataflow.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_dataflow.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_fn0_regset.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_fn0_regset.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_fn1_regset.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_fn1_regset.v             SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_rx_bar_check.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_rx_bar_check.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_flr.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_flr.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_mux.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_mux.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v  SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_regset.v              VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_regset.v              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcied_sriov_cfg_vf_msi_cap.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov/synopsys/rtl/altpcied_sriov_cfg_vf_msi_cap.v             SYNOPSYS_SPECIFIC
       }

          # Aldec
       if {1} {
          add_fileset_file aldec/altpcied_sriov_rx_data_bridge.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_rx_data_bridge.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_tx_data_bridge.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_tx_data_bridge.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_dataflow.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_dataflow.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_fn0_regset.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_fn0_regset.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_fn1_regset.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_fn1_regset.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_rx_bar_check.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_rx_bar_check.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_flr.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_flr.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_mux.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_mux.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v     VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_regset.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_regset.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcied_sriov_cfg_vf_msi_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov/aldec/rtl/altpcied_sriov_cfg_vf_msi_cap.v                ALDEC_SPECIFIC

       }
    } else {
          add_fileset_file altera_pcie_sriov2_bridge.sv      SYSTEM_VERILOG PATH ../altera_pcie_sriov2/rtl/altera_pcie_sriov2_bridge.sv
          add_fileset_file altpcie_a10_lmi_burst_intf.v      VERILOG PATH           altpcie_a10_lmi_burst_intf.v

          # Mentor
       if {1} {
          add_fileset_file mentor/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_top.v                              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_bar_check_vf_mux.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_dataflow.v                     MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_fn0_regset.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_fn123_regset.v                 MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_mux.v                       MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_regset.v                    MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_status_array.v              MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_rx_bar_check.v                     MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_rx_data_bridge.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcie_sriov2_tx_data_bridge.v                   MENTOR_SPECIFIC
          add_fileset_file mentor/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/mentor/rtl/altpcierd_hip_rs.v                                MENTOR_SPECIFIC

           }
          # Cadence
       if {1} {
          add_fileset_file cadence/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_top.v                              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_bar_check_vf_mux.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_dataflow.v                     CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_fn0_regset.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_fn123_regset.v                 CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_mux.v                       CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_regset.v                    CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_status_array.v              CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_rx_bar_check.v                     CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_rx_data_bridge.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcie_sriov2_tx_data_bridge.v                   CADENCE_SPECIFIC
          add_fileset_file cadence/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/cadence/rtl/altpcierd_hip_rs.v                                CADENCE_SPECIFIC

           }
          # Synopsys
       if {1} {
          add_fileset_file synopsys/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_top.v                              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_bar_check_vf_mux.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_dataflow.v                     SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_fn0_regset.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_fn123_regset.v                 SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_mux.v                       SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_regset.v                    SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_status_array.v              SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_rx_bar_check.v                     SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_rx_data_bridge.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcie_sriov2_tx_data_bridge.v                   SYNOPSYS_SPECIFIC
          add_fileset_file synopsys/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/synopsys/rtl/altpcierd_hip_rs.v                                SYNOPSYS_SPECIFIC

           }
          # Aldec
       if {1} {
          add_fileset_file aldec/altpcie_sriov2_top.v                               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_top.v                              ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_bar_check_vf_mux.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_bar_check_vf_mux.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_dataflow.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_dataflow.v                     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_fn0_regset.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_fn0_regset.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_fn123_regset.v                  VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_fn123_regset.v                 ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_ats_cap.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_ats_cap.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_error_status_fifo.v          VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_error_status_fifo.v         ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_msix_cap.v                   VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_msix_cap.v                  ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_mux.v                        VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_mux.v                       ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_pci_cmd_reg.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_pci_cmd_reg.v               ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_pci_status_reg.v             VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_pci_status_reg.v            ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_regset.v                     VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_regset.v                    ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_virtio_cap.v                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_virtio_cap.v                ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_status_array.v               VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_status_array.v              ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_tph_req_cap.v                VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_tph_req_cap.v               ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_cfg_vf_trans_pend_status_array.v    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_cfg_vf_trans_pend_status_array.v   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_rx_bar_check.v                      VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_rx_bar_check.v                     ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_rx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_rx_data_bridge.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcie_sriov2_tx_data_bridge.v                    VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcie_sriov2_tx_data_bridge.v                   ALDEC_SPECIFIC
          add_fileset_file aldec/altpcierd_hip_rs.v                                 VERILOG_ENCRYPT PATH ../altera_pcie_sriov2/aldec/rtl/altpcierd_hip_rs.v                                ALDEC_SPECIFIC

           }

       }


   if {($cseb_autonomous_hwtcl ==1)} {
      # Config-Bypass Speed Change Autonomous mode files
      add_fileset_file altpcie_sc_ctrl.v                      VERILOG PATH          altpcie_sc_ctrl.v
      add_fileset_file altpcie_sc_dprio_rd_wr.v               VERILOG PATH          altpcie_sc_dprio_rd_wr.v
      add_fileset_file altpcie_sc_dprio_seq.v                 VERILOG PATH          altpcie_sc_dprio_seq.v
      add_fileset_file altpcie_sc_dprio_top.v                 VERILOG PATH          altpcie_sc_dprio_top.v
      add_fileset_file altpcie_sc_hip_vecsync2.v              VERILOG PATH          altpcie_sc_hip_vecsync2.v
      add_fileset_file altpcie_sc_lvlsync.v                   VERILOG PATH          altpcie_sc_lvlsync.v
      add_fileset_file altpcie_sc_lvlsync2.v                  VERILOG PATH          altpcie_sc_lvlsync2.v
   }
 }
}



proc ::altera_pcie_a10_hip::fileset::check_support_hw_a10_devkit {} {
   global env
   set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
   set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
   send_message info "Checking support for Development kit board"
   set support_hw_a10_devkit 1
   set support_hw_a10_devkit_str ""
   set port_type_hwtcl              [ip_get "parameter.port_type_hwtcl.value"]
   set targeted_devkit_hwtcl        [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set vendor_id_hwtcl              [ip_get "parameter.vendor_id_hwtcl.value"]
   if { ${port_type_hwtcl} == "Native endpoint" } {
      set interface_type_hwtcl [ip_get "parameter.interface_type_hwtcl.value"]
      if { $interface_type_hwtcl == "Avalon-ST with SR-IOV" } {
         set support_hw_a10_devkit 0
         set support_hw_a10_devkit_str $interface_type_hwtcl
      }
   } else {
      set support_hw_a10_devkit 0
      set support_hw_a10_devkit_str $port_type_hwtcl
   }
   if { ${support_hw_a10_devkit} == 0 } {
      send_message info "There is no software application available for the Arria 10"
      send_message info "development kit hardware design when selecting"
      send_message info "${support_hw_a10_devkit_str}"
   } elseif { [ regexp Development ${targeted_devkit_hwtcl} ] } {
      set IPRD_SOFT ${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/software/windows/interop
      add_fileset_file software/windows/interop/Altera_PCIe_Interop_Test.zip OTHER PATH ${IPRD_SOFT}/Altera_PCIe_Interop_Test_zip.v
      add_fileset_file software/windows/interop/readme_Altera_PCIe_interop_Test.txt OTHER PATH ${IPRD_SOFT}/readme_Altera_PCIe_interop_Test.txt
      send_message info "adding software/windows/interop/readme_Altera_PCIe_interop_Test.txt"
      send_message info "adding software/windows/interop/Altera_PCIe_Interop_Test.zip"
      send_message info "The file readme_Altera_PCIe_interop_Test.txt describes"
      send_message info "how to install and run the PCI Express interop software"
      send_message info "application (Altera_PCIe_Interop_Test.zip) on the windows host machine."
      if { $vendor_id_hwtcl != 4466 } {
         send_message info "The parameter \"Vendor ID\" is set to \"${vendor_id_hwtcl}\""
         send_message info "The Windows drivers installed with the interop software requires to set the \"Vendor ID\" parameter to \"4466\" \"(0x1172)\""
      }
   }
}

proc ::altera_pcie_a10_hip::fileset::filetype { file_name } {
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

proc ::altera_pcie_a10_hip::fileset::filedelete { item } {
   if { [ file exist $item ] == 1 } {
      file delete $item
   }
}
proc ::altera_pcie_a10_hip::fileset::folder_worker { item } {
   set DirectoryContent  [glob -nocomplain -directory [file join [pwd] $item] -tails *]
   if { $DirectoryContent>0} {
      foreach top_item $DirectoryContent {
         set relative_item [file join $item $top_item]
         set absolute_path [file join [pwd] $relative_item]
         if { [file isdirectory $relative_item] == 1 } {
            ::altera_pcie_a10_hip::fileset::folder_worker $relative_item
         } elseif { [file exist $absolute_path] == 1 } {
            add_fileset_file $relative_item [ ::altera_pcie_a10_hip::fileset::filetype $absolute_path ] PATH $absolute_path
            send_message info "adding $relative_item "
         } else {
            send_message info "Unable to locate $absolute_path"
         }
      }
   }
}

proc ::altera_pcie_a10_hip::fileset::add_files_recursive { root } {
   set old_path [pwd]
   cd $root
   set DirectoryContent [glob -nocomplain -directory [pwd]  -tails *]
   if { $DirectoryContent>0} {
      foreach top_item $DirectoryContent {
         set absolute_path [file join [pwd] $top_item]
         if { [file isdirectory $top_item] == 1 } {
            ::altera_pcie_a10_hip::fileset::folder_worker $top_item
         } elseif { [file exist $absolute_path] == 1 } {
            add_fileset_file $top_item [ ::altera_pcie_a10_hip::fileset::filetype $absolute_path ] PATH $absolute_path
            send_message info "adding $top_item "
         } else {
            send_message info "Unable to locate $absolute_path"
         }
      }
   }
   cd $old_path
}

proc ::altera_pcie_a10_hip::fileset::empty_dir { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      file delete -force $absolute_path
   }
   cd $old_path
}
proc ::altera_pcie_a10_hip::fileset::alteracion_ed_message { param_string } {
   send_message info "To ensure proper functionality of the application driver in simulation or in hardware, ${param_string}"
}

proc ::altera_pcie_a10_hip::fileset::generate_design_example_files { qsys_design_example_fullpath exdes_prj } {

   set family [get_parameter_value device_family]
	
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
   
    if {$family == "Arria 10" } {
      set a10pcie_devkit_prj "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/a10-pcie-devkit-prj.tcl"
    } else {
      set a10pcie_devkit_prj "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/c10-pcie-devkit-prj.tcl" 
	}
	
   #
   # Copy QSYS system and qshell/qsys script to temp directory
   #
   if { [ file exist $qsys_design_example_fullpath ] == 0 } {
      file copy "${qsys_design_example_fullpath}"  "${TEMPPATH}/${exdes_prj}.qsys"
   }
   send_message info "Targeting Arria 10 FPGA Development kit ...."
   ::altera_pcie_a10_hip::fileset::check_support_hw_a10_devkit
   # If targeting on Devkit, override DEVICE to the Devkit device number.
   # Otherwise, use the real device number provided by Quartus or Qsys (
   # no pin assignments will be generated in this case).
   
    if {$family == "Arria 10" } {
       if { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit ES2" } {
          set DeviceQSF "10AX115S1F45I1SGE2"
       } elseif { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit" } {
          set DeviceQSF "10AX115S1F45I1SG"
       } else {
          set DeviceQSF     [ip_get "parameter.part_trait_device.value"]
       }
    } else {
          set DeviceQSF     [ip_get "parameter.part_trait_device.value"] 
	}

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
   puts  $GScript "quartus_sh -t ${a10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   puts  $GScript "#                                                                                       "
   puts  $GScript "# IP Upgrade                                                                            "
   puts  $GScript "quartus_sh --ip_upgrade -variation_files ${exdes_prj}.qsys ${exdes_prj}                 "
   puts  $GScript "#                                                                                       "
   puts  $GScript "# Compile generate QUARTUS project                                                      "
   puts  $GScript "quartus_sh --flow compile ${exdes_prj}.qpf                                              "
   puts  $GScript "#                                                                                       "
   close $GScript
   send_message info "Running: quartus_sh -t ${a10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   set foo [catch  "exec quartus_sh -t ${a10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"]
   set FAILGEN "${TEMPPATH}/${exdes_prj}_fail.txt"

   if { [ file exist $FAILGEN ] == 1 } {
      add_fileset_file ${exdes_prj}.qsys OTHER PATH ${qsys_design_example_fullpath}
      send_message info "adding ${exdes_prj}.qsys"
      send_message error "Unable to generate HDL files for the system ${exdes_prj}.qsys "
   } else {
      # Copy all generated file to the example design user directory
      #
      ::altera_pcie_a10_hip::fileset::add_files_recursive [ pwd ]
   }
   catch { cd $ORIDIR}
}



proc ::altera_pcie_a10_hip::fileset::validate_design_example {} {

   send_message info "Validating example design selection"

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
      # else {
         # if { $select_design_example_hwtcl == "PIO" }  {
            # set valid 0
            # set recommend_design "DMA"
         # }
      # }
   } elseif { $interface_type_hwtcl == "Avalon-MM" } {
      if { $select_design_example_hwtcl == "DMA" }  {
         set valid 0
         set recommend_design "PIO"
      }
   } elseif { $interface_type_hwtcl == "Avalon-MM with DMA" } {
      if { $select_design_example_hwtcl == "PIO" }  {
         set valid 0
         set recommend_design "DMA"
      }
   } elseif { $interface_type_hwtcl == "Avalon-ST with SR-IOV" } {
         set valid 0
         set recommend_design "DMA"
   }

   if { $valid == 0 } {
           if { $interface_type_hwtcl == "Avalon-ST with SR-IOV" } {
                  global env
                  set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
          set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
          return "Example design generation is not avaialble for \"Application interface type\"=$interface_type_hwtcl . <br/>
                 To obtain an example design please disable the invalid option(s) and try again.  <br/>
                 Alternatively, you can select an example design from one of several available in the ACDS Installation <br/>
                 Directory here: ${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/a10.  <br/>
                 Information on using those designs can be found in the IP QuickStart/IP User Guide."
           } else {
              return "Please select ${recommend_design} from the \"Available example designs\", the $select_design_example_hwtcl example design is not available when selecting \"Application interface type\"=$interface_type_hwtcl and \"Application data width\"= $data_width_integer_hwtcl bit."
       }
   } else {
      return $valid
   }
}


proc ::altera_pcie_a10_hip::fileset::generate_dynamic_rp_qsys {} {

   set family [get_parameter_value device_family]
	
   send_message info "Auto-generation of QSYS example design in progress based on variant parameter settings"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set data_width_integer_hwtcl     [ip_get "parameter.data_width_integer_hwtcl.value"]
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]

   set targeted_devkit_hwtcl        [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set ACDSVERSION 18.1


   global env
   set QSYS_ROOTDIR $env(QUARTUS_ROOTDIR)

   # QSYS script to auto-generate QSYS system
   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set QSYSTemName "pcie_example_design"
   set QSYSTem "${QSYSTemName}.qsys"
   set QSYSTemPath "${TEMPPATH}${QSYSTem}"
   set QSYSScript "gen_pcie_example_design.tcl"
   set QSYSScriptCC "gen_pcie_example_design_cc.tcl"
   set QSYSScriptPath "${TEMPPATH}${QSYSScript}"
   set QSYSScriptBACKUPPath "${TEMPPATH}${QSYSScriptCC}"

   if { [ file exist $QSYSScriptPath ] == 1 } {
      file delete $QSYSScriptPath
   }

   set ScriptFile [open $QSYSScriptPath "w"]
   catch { cd $TEMPPATH}

   set instance "DUT"
   # If targeting on Devkit, override DEVICE to the Devkit device number.
   # Otherwise, use the real device number provided by Quartus or Qsys (
   # no pin assignments will be generated in this case).
   #  put package requirement as first line in gen_pcie_example_design
   puts $ScriptFile "package require -exact qsys ${ACDSVERSION}"
   
    if {$family == "Arria 10" } {
        puts $ScriptFile "set_project_property DEVICE_FAMILY {Arria 10}"        
		if { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit ES2" } {
           set DeviceQSF "10AX115S1F45I1SGE2"
        } elseif { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit" } {
           set DeviceQSF "10AX115S1F45I1SG"
        } else {
           set DeviceQSF     [ip_get "parameter.part_trait_device.value"]
        }
    } else {
        puts $ScriptFile "set_project_property DEVICE_FAMILY {Cyclone 10 GX}"		
		set DeviceQSF     [ip_get "parameter.part_trait_device.value"]
	}


   puts $ScriptFile "set qsys_system ${QSYSTem}"

   puts $ScriptFile "set_project_property DEVICE ${DeviceQSF}"

   puts $ScriptFile "# Adding Arria 10 / Cyclone 10 PCIe IP"
   puts $ScriptFile "add_instance ${instance} altera_pcie_a10_hip"

   puts $ScriptFile "# Setting Parameters to Arria 10 / Cyclone 10 PCIe IP"
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   foreach param $nf_hip_parameters {
      set derived [ ip_get "parameter.${param}.DERIVED" ]
      if { $derived == 0 } {
         set value [ip_get "parameter.${param}.value"]
         puts $ScriptFile "set_instance_parameter_value ${instance} ${param} {${value}}"
        
         if { [ regexp interface_type_hwtcl $param ] } {
            set interface_type_hwtcl $value
         }
      }
   }
  

   puts $ScriptFile "# Enabling Devkit component to support Arria FPGA Development kit"
   puts $ScriptFile "add_instance DK altpcie_devkit"
   puts $ScriptFile "add_interface          board_pins conduit end"
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
   puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 15"
   puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl              {32}"
   puts $ScriptFile "set_instance_parameter_value ${instance} enable_g3_bypass_equlz_rp_sim_hwtcl {1}"

   if { $interface_type_hwtcl != "Avalon-MM" } {
      # AVMM only Parameters - Set to Zero when non AVMM
      puts $ScriptFile "set_instance_parameter_value ${instance} cb_pcie_mode_hwtcl                 {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cb_pcie_rx_lite_hwtcl              {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cg_enable_advanced_interrupt_hwtcl {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cg_enable_a2p_interrupt_hwtcl      {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl              {64}"
   }

   if { $interface_type_hwtcl == "Avalon-MM" } {
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "# Adding on-chip memory"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "# Set TB BFM to 15 apps_type_hwtcl config only             1"
      puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 15"
      puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
      puts $ScriptFile "set_instance_parameter_value MEM blockType                  {AUTO}             "
      puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
      puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {${family}}        "
      puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {false}             "
      puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
      puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {4096}              "
      puts $ScriptFile "set_instance_parameter_value MEM readDuringWriteMode        {DONT_CARE}        "
      puts $ScriptFile "set_instance_parameter_value MEM resetrequest_enabled       {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM slave1Latency              {1}                "
      puts $ScriptFile "set_instance_parameter_value MEM useNonDefaultInitFile      {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM useShallowMemBlocks        {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM writable                   {true}             "
      puts $ScriptFile "# Connection Section"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset1"

      puts $ScriptFile "add_instance mm_clock_crossing_bridge altera_avalon_mm_clock_crossing_bridge"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip mm_clock_crossing_bridge.m0_clk"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status mm_clock_crossing_bridge.m0_reset"
      puts $ScriptFile "set_instance_parameter_value mm_clock_crossing_bridge USE_AUTO_ADDRESS_WIDTH 1"

      set TxSConnected 0
      set CRAConnected 0
      set TxSUsed 1
      set CRAUsed [ip_get "parameter.cg_impl_cra_av_slave_port_hwtcl.value"]
      if { [ip_get "parameter.cb_pcie_mode_hwtcl.value"] || [ip_get "parameter.cb_pcie_rx_lite_hwtcl.value"] } {
         set TxSUsed 0
         # When 0 No TXs Port
      }
      if { ${TxSUsed} == 1} {
         puts $ScriptFile "# Limit TxS Address Space"
         set avmm_addr_width_hwtcl    [ip_get "parameter.avmm_addr_width_hwtcl.value"]
         if { $avmm_addr_width_hwtcl == 64 } {
            puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl {32}"
            ::altera_pcie_a10_hip::fileset::alteracion_ed_message "change Avalon-MM address width to 32 bit."
             send_message info "The Avalon-MM generated example design application operates with Avalon-MM address width of 32-bit."
         }
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_pass_thru_bits_hwtcl {24}"
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_num_entries_hwtcl {2}"
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_impl_cra_av_slave_port_hwtcl {1}"
         set CRAUsed 1
      }

      if { ${CRAUsed} == 1 } {
         puts $ScriptFile "add_connection ${instance}.rxm_irq ${instance}.cra_irq"
         puts $ScriptFile "auto_assign_irqs ${instance}"
      }

      for { set i 0 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar 1
         }
         if { $bar == 1 } {

            puts $ScriptFile "add_connection ${instance}.rxm_bar${i} MEM.s1"
            puts $ScriptFile "set_connection_parameter_value ${instance}.rxm_bar${i}./MEM.s1 baseAddress {0}"
            puts $ScriptFile "lock_avalon_base_address MEM.s1"

            if { ${TxSUsed} == 1} {
               if {$TxSConnected == 0} {
                  puts $ScriptFile "add_connection mm_clock_crossing_bridge.m0 ${instance}.txs"
                  set TxSConnected 1
                  puts $ScriptFile "set_connection_parameter_value mm_clock_crossing_bridge.m0/${instance}.txs baseAddress {0x80000000}"
                  puts $ScriptFile "lock_avalon_base_address ${instance}.txs"
               }
            }

            if { ${CRAUsed} == 1 } {
               puts $ScriptFile "add_connection mm_clock_crossing_bridge.m0 ${instance}.cra"
               if { $CRAConnected == 0} {
                  set CRAConnected 1
               }
               puts $ScriptFile "set_connection_parameter_value mm_clock_crossing_bridge.m0/${instance}.cra baseAddress {0x00004000}"
               puts $ScriptFile "lock_avalon_base_address ${instance}.cra"
            }
         }
      }
      set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
      if { $dynamic_reconfig ==1 } {
         puts $ScriptFile "add_connection clock_bridge.out_clk ${instance}.hip_reconfig_clk"
         puts $ScriptFile "add_connection reset_bridge.out_reset ${instance}.hip_reconfig_rst"
      }

   }

   puts $ScriptFile "set_interface_property board_pins EXPORT_OF DK.dk_board"
   puts $ScriptFile "add_connection DK.dk_hip ${instance}.dk_hip"
   puts $ScriptFile "add_connection ${instance}.coreclkout_hip DK.clock"

   puts $ScriptFile "add_instance clock_bridge altera_clock_bridge"
   puts $ScriptFile "# Clock dynamic reconfiguration interface"
   puts $ScriptFile "add_interface          jtag_refclk clock end"
   puts $ScriptFile "set_interface_property jtag_refclk EXPORT_OF clock_bridge.in_clk"
   puts $ScriptFile "set_instance_parameter_value clock_bridge EXPLICIT_CLOCK_RATE {100000000}"
   puts $ScriptFile "add_connection clock_bridge.out_clk mm_clock_crossing_bridge.s0_clk"

   puts $ScriptFile "add_instance reset_bridge altera_reset_bridge"
   #puts $ScriptFile "set_instance_parameter_value reset_bridge ACTIVE_LOW_RESET {1}"
   puts $ScriptFile "add_connection reset_bridge.out_reset mm_clock_crossing_bridge.s0_reset"
   puts $ScriptFile "add_connection clock_bridge.out_clk reset_bridge.clk"
   puts $ScriptFile "add_connection ${instance}.app_nreset_status reset_bridge.in_reset"

   puts $ScriptFile "add_instance master_0 altera_jtag_avalon_master"
   puts $ScriptFile "add_connection master_0.master mm_clock_crossing_bridge.s0" 
   puts $ScriptFile "add_connection clock_bridge.out_clk master_0.clk"
   puts $ScriptFile "add_connection reset_bridge.out_reset master_0.clk_reset"

   puts $ScriptFile "set_connection_parameter_value master_0.master/mm_clock_crossing_bridge.s0 baseAddress {0}"
   puts $ScriptFile "lock_avalon_base_address mm_clock_crossing_bridge.s0"
   puts $ScriptFile "auto_assign_system_base_addresses"

   puts $ScriptFile "remove_dangling_connections"
   send_message info "save_system ${QSYSTem}"
   puts $ScriptFile "save_system ${QSYSTem}"

   puts $ScriptFile "load_instantiation master_0"
   puts $ScriptFile "set_instantiation_property IP_FILE {}"
   puts $ScriptFile "set_instantiation_property HDL_COMPILATION_LIBRARY {pcie_example_design_master_0}"
   puts $ScriptFile "set_instantiation_property HDL_ENTITY_NAME {pcie_example_design_master_0}"
   puts $ScriptFile "add_instantiation_hdl_file {$QSYS_ROOTDIR/../ip/altera/altera_pcie/altera_pcie_a10_ed/a10_avmm_rp_jtagmaster_bfm/pcie_example_design_master_0.v} SIM_VERILOG"
   puts $ScriptFile "set_instantiation_hdl_file_property {pcie_example_design_master_0.v} IS_TOP_LEVEL true"
   puts $ScriptFile "save_instantiation"

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

	   if {$family == "Arria 10" } {
         send_message info "Running: qsys-script --script=${QSYSScript} --new-quartus-project=pcie_example_design"
         set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --script=${QSYSScriptPath} --new-quartus-project=pcie_example_design"] 
       } else {
         send_message info "Running: qsys-script --script=${QSYSScript} --new-quartus-project=pcie_example_design --device=${DeviceQSF} --deviceFamily=$family"
         set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --script=${QSYSScriptPath} --new-quartus-project=pcie_example_design --device=${DeviceQSF} --deviceFamily=$family"]       
	   }

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
      ::altera_pcie_a10_hip::fileset::generate_design_example_files  ${QSYSTemPath} ${QSYSTemName}
   } else {
      add_fileset_file ${QSYSScript} OTHER PATH ${QSYSScriptPath}
      send_message info "Unable to create ${QSYSTem}"
      send_message info "Copied ${QSYSScript} in the example design directory, exiting ........."
   }
}


proc ::altera_pcie_a10_hip::fileset::generate_dynamic_ep_qsys {} {

   set family [get_parameter_value device_family]
	
   send_message info "Auto-generation of QSYS example design in progress based on variant parameter settings"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set data_width_integer_hwtcl     [ip_get "parameter.data_width_integer_hwtcl.value"]
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]

   set link_width_integer_hwtcl     [ip_get "parameter.link_width_integer_hwtcl.value"]
   set lane_rate_integer_hwtcl      [ip_get "parameter.lane_rate_integer_hwtcl.value"]
   set lane_rate_hwtcl              [ip_get "parameter.lane_rate_hwtcl.value"]
   set pld_clk_mhz_integer_hwtcl    [ip_get "parameter.pld_clk_mhz_integer_hwtcl.value"]
   set targeted_devkit_hwtcl        [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set bar2_type_integer_hwtcl      [ip_get "parameter.bar2_type_integer_hwtcl.value"]
   set bar2_address_width_hwtcl  7
   set ACDSVERSION 18.1


   # QSYS script to auto-generate QSYS system
   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set QSYSTemName "pcie_example_design"
   set QSYSTem "${QSYSTemName}.qsys"
   set QSYSTemPath "${TEMPPATH}${QSYSTem}"
   set QSYSScript "gen_pcie_example_design.tcl"
   set QSYSScriptCC "gen_pcie_example_design_cc.tcl"
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
   # If targeting on Devkit, override DEVICE to the Devkit device number.
   # Otherwise, use the real device number provided by Quartus or Qsys (
   # no pin assignments will be generated in this case).
   #  put package requirement as first line in gen_pcie_example_design
   puts $ScriptFile "package require -exact qsys ${ACDSVERSION}"
   
    if {$family == "Arria 10" } {
        puts $ScriptFile "set_project_property DEVICE_FAMILY {Arria 10}"        
		if { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit ES2" } {
           set DeviceQSF "10AX115S1F45I1SGE2"
        } elseif { $targeted_devkit_hwtcl == "Arria 10 GX FPGA Development Kit" } {
           set DeviceQSF "10AX115S1F45I1SG"
        } else {
           set DeviceQSF     [ip_get "parameter.part_trait_device.value"]
        }
    } else {
        puts $ScriptFile "set_project_property DEVICE_FAMILY {Cyclone 10 GX}"		
		set DeviceQSF     [ip_get "parameter.part_trait_device.value"]
	}


   puts $ScriptFile "set qsys_system ${QSYSTem}"

   puts $ScriptFile "set_project_property DEVICE ${DeviceQSF}"

   puts $ScriptFile "# Adding Arria 10 / Cyclone 10 PCIe IP"
   puts $ScriptFile "add_instance ${instance} altera_pcie_a10_hip"

   puts $ScriptFile "# Setting Parameters to Arria 10 / Cyclone 10 PCIe IP"
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
         if { [ regexp interface_type_hwtcl $param ] } {
            set interface_type_hwtcl $value
         }
      }
   }

   puts $ScriptFile "# Enabling Devkit component to support Arria FPGA Development kit"
   puts $ScriptFile "add_instance DK altpcie_devkit"
   puts $ScriptFile "add_interface          board_pins conduit end"
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

   if { $interface_type_hwtcl != "Avalon-MM" } {
      # AVMM only Parameters - Set to Zero when non AVMM
      puts $ScriptFile "set_instance_parameter_value ${instance} cb_pcie_mode_hwtcl                 {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cb_pcie_rx_lite_hwtcl              {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cg_enable_advanced_interrupt_hwtcl {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cg_enable_a2p_interrupt_hwtcl      {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl              {64}"
   }

   if { $interface_type_hwtcl != "Avalon-ST" } {
      # AVST only Parameters - Set to Zero when non AVST
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_avst_reset_hwtcl            {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} use_rx_st_be_hwtcl                 {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} use_ast_parity_hwtcl               {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} multiple_packets_per_cycle_hwtcl   {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} use_tx_cons_cred_sel_hwtcl         {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cseb_config_bypass_hwtcl           {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} cseb_autonomous_hwtcl              {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_lmi_hwtcl                   {0}"
   }

   if { $interface_type_hwtcl != "Avalon-MM with DMA" } {
      # AVMM with DMA only Parameters - Set to Zero when non AVMM with DMA
      puts $ScriptFile "set_instance_parameter_value ${instance} internal_controller_hwtcl         {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_rxm_burst_hwtcl            {0}"
   }

   if { $interface_type_hwtcl == "Avalon-ST" } {
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "add_interface          currentspeed conduit end"
      puts $ScriptFile "set_interface_property currentspeed EXPORT_OF ${instance}.currentspeed"
      # Exception common code
      if { $enable_avst_reset_hwtcl == 0 } {
         ::altera_pcie_a10_hip::fileset::alteracion_ed_message "the option \"Enable Avalon-ST Reset output port\" is enabled when using the Avalon-ST Interface"
         puts $ScriptFile "set_instance_parameter_value ${instance} enable_avst_reset_hwtcl 1"
      }
      if { $use_tx_cons_cred_sel_hwtcl == 1 } {
         ::altera_pcie_a10_hip::fileset::alteracion_ed_message "the option \"Enable credit consumed selection port\" is disabled when using the Avalon-ST Interface"
         puts $ScriptFile "set_instance_parameter_value ${instance} use_tx_cons_cred_sel_hwtcl 0"
      }
      puts $ScriptFile "# Disabling non-relevant AVMM parameters"
      puts $ScriptFile "set_instance_parameter_value ${instance} cg_impl_cra_av_slave_port_hwtcl    {0}"
      if { $data_width_integer_hwtcl == 256 } {
         puts $ScriptFile "add_instance APPS ast2avmm_bridge_256"
         for { set i 0 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.bar${i}_type_hwtcl.value"]
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
         puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {${family}}          "
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
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.pld_clk"
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
               puts $ScriptFile "add_connection ${instance}.clr_st ${instance}.hip_reconfig_rst"
         }
		 
		 set xcvr_reconfig_hwtcl          [ip_get "parameter.xcvr_reconfig_hwtcl.value"]
		 if {$xcvr_reconfig_hwtcl == 1} {
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.xcvr_reconfig_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll0_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll1_clk"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.xcvr_reconfig_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll0_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll1_reset"
		 }
      } else {
        if { $select_design_example_hwtcl == "PIO" } {
         puts $ScriptFile ""
         puts $ScriptFile "add_instance APPS pio_ed"

         puts $ScriptFile "set_instance_parameter_value APPS DBUS_WIDTH                {${data_width_integer_hwtcl}}"

         puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
         puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {32}"
         puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {${family}}         "
         puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
         puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
         puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
         puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {65536}             "
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
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.pld_clk"
         puts $ScriptFile "add_connection ${instance}.clr_st APPS.clr_st"
         puts $ScriptFile "add_connection ${instance}.hip_rst APPS.hip_rst"
         puts $ScriptFile "add_connection ${instance}.hip_status APPS.hip_status"
         puts $ScriptFile "add_connection ${instance}.currentspeed APPS.currentspeed"
         puts $ScriptFile "add_connection ${instance}.rx_st APPS.rx_st_hip"
         puts $ScriptFile "add_connection ${instance}.rx_bar APPS.rx_bar"
         puts $ScriptFile "add_connection ${instance}.tx_cred APPS.tx_cred"
         puts $ScriptFile "add_connection ${instance}.int_msi APPS.int_msi"
         puts $ScriptFile "add_connection ${instance}.power_mgnt APPS.power_mgnt"
         puts $ScriptFile "add_connection ${instance}.config_tl APPS.config_tl"
         puts $ScriptFile "add_connection APPS.tx_st_hip ${instance}.tx_st"
         puts $ScriptFile "add_connection ${instance}.clr_st MEM.reset1"
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
         puts $ScriptFile "add_connection APPS.hprxm MEM.s1"

         set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
         if { $dynamic_reconfig ==1 } {
               puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
               puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
         }
		 
		 set xcvr_reconfig_hwtcl          [ip_get "parameter.xcvr_reconfig_hwtcl.value"]
		 if {$xcvr_reconfig_hwtcl == 1} {
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.xcvr_reconfig_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll0_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll1_clk"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.xcvr_reconfig_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll0_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll1_reset"
		 }

        } else {
         puts $ScriptFile ""
         puts $ScriptFile "add_instance APPS altera_pcie_a10_ed                                                       "
         puts $ScriptFile "set_instance_parameter_value APPS enable_avst_reset_hwtcl              {1}                 "
         puts $ScriptFile "set_instance_parameter_value APPS ast_width_hwtcl                      {Avalon-ST ${data_width_integer_hwtcl}-bit}  "
         puts $ScriptFile "set_instance_parameter_value APPS avalon_waddr_hwltcl                  {12}                "
         puts $ScriptFile "set_instance_parameter_value APPS check_bus_master_ena_hwtcl           {1}                 "
         puts $ScriptFile "set_instance_parameter_value APPS check_rx_buffer_cpl_hwtcl            {1}                 "
         puts $ScriptFile "set_instance_parameter_value APPS device_family_hwtcl                  {${family}}           "
         puts $ScriptFile "set_instance_parameter_value APPS enable_fpga_devkit_board_hwtcl       {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS enable_fpga_devkit_cbb_hwtcl         {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS enable_lmi_hwtcl                     {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS extend_tag_field_hwtcl               {64}                "
         puts $ScriptFile "set_instance_parameter_value APPS gen123_lane_rate_mode_hwtcl          {${lane_rate_hwtcl}}"
         puts $ScriptFile "set_instance_parameter_value APPS lane_mask_hwtcl                      {x1}                "
         puts $ScriptFile "set_instance_parameter_value APPS max_payload_size_hwtcl               {128}               "
         puts $ScriptFile "set_instance_parameter_value APPS multiple_packets_per_cycle_hwtcl     {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS num_of_func_hwtcl                    {1}                 "
         puts $ScriptFile "set_instance_parameter_value APPS pld_clockrate_hwtcl                  {${pld_clk_mhz_integer_hwtcl}00000}         "
         puts $ScriptFile "set_instance_parameter_value APPS port_type_hwtcl                      {Native endpoint}   "
         puts $ScriptFile "set_instance_parameter_value APPS track_rxfc_cplbuf_ovf_hwtcl          {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS use_crc_forwarding_hwtcl             {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS use_ep_simple_downstream_apps_hwtcl  {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS use_rx_st_be_hwtcl                   {0}                 "
         puts $ScriptFile "set_instance_parameter_value APPS use_tx_cons_cred_sel_hwtcl           {0}                 "

         puts $ScriptFile ""
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip APPS.coreclkout_hip"
         puts $ScriptFile "add_connection APPS.pld_clk_hip ${instance}.pld_clk"
         puts $ScriptFile "add_connection ${instance}.config_tl APPS.config_tl"
         puts $ScriptFile "add_connection ${instance}.rx_st APPS.rx_st"
         puts $ScriptFile "add_connection ${instance}.tx_cred APPS.tx_cred"
         puts $ScriptFile "add_connection ${instance}.clr_st APPS.clr_st"
         puts $ScriptFile "add_connection APPS.tx_st ${instance}.tx_st"
         puts $ScriptFile "add_connection APPS.hip_rst ${instance}.hip_rst"
         puts $ScriptFile "add_connection APPS.int_msi ${instance}.int_msi"
         puts $ScriptFile "add_connection APPS.hip_status ${instance}.hip_status"
         puts $ScriptFile "add_connection APPS.power_mngt ${instance}.power_mgnt"
         puts $ScriptFile "add_connection APPS.rx_bar_be ${instance}.rx_bar"
         set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
         if { $dynamic_reconfig ==1 } {
               puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
               puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
         }
         if { $bar2_type_integer_hwtcl == 0 } {
             puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 3"
             ::altera_pcie_a10_hip::fileset::alteracion_ed_message "enable BAR2."
             send_message info "The generated example design performs memory read-write transactions from the host to the FPGA Endpoint."
         }  elseif { $bar2_address_width_hwtcl == 7 } {
            puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 3"
            ::altera_pcie_a10_hip::fileset::alteracion_ed_message "change BAR2 Size to be more than 8 Bits."
             send_message info "The generated example design performs memory read-write transactions from the host to the FPGA Endpoint."
         }
		 
		 set xcvr_reconfig_hwtcl          [ip_get "parameter.xcvr_reconfig_hwtcl.value"]
		 if {$xcvr_reconfig_hwtcl == 1} {
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.xcvr_reconfig_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll0_clk"
		       puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.reconfig_pll1_clk"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.xcvr_reconfig_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll0_reset"
		       puts $ScriptFile "add_connection ${instance}.clr_st         ${instance}.reconfig_pll1_reset"
		 }
      }
      }
   } elseif { $interface_type_hwtcl == "Avalon-MM" } {
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "# Adding on-chip memory"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "# Set TB BFM to 3 apps_type_hwtcl config only             1"
      puts $ScriptFile "#               3  apps_type_hwtcl chaining_dma           2"
      puts $ScriptFile "#               3  apps_type_hwtcl Target only            3"
      puts $ScriptFile "#               3  apps_type_hwtcl simple_ep_downstream   11"
      puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 3"
      puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
      puts $ScriptFile "set_instance_parameter_value MEM blockType                  {AUTO}             "
      puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
      puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {${family}}          "
      puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
      puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {256}              "
      puts $ScriptFile "set_instance_parameter_value MEM readDuringWriteMode        {DONT_CARE}        "
      puts $ScriptFile "set_instance_parameter_value MEM resetrequest_enabled       {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM singleClockOperation       {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM slave1Latency              {2}                "
      puts $ScriptFile "set_instance_parameter_value MEM slave2Latency              {1}                "
      puts $ScriptFile "set_instance_parameter_value MEM useNonDefaultInitFile      {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM useShallowMemBlocks        {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM writable                   {true}             "
      puts $ScriptFile "# Connection Section"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset1"
      set TxSConnected 0
      set CRAConnected 0
      set TxSUsed 1
      set CRAUsed [ip_get "parameter.cg_impl_cra_av_slave_port_hwtcl.value"]
      if { [ip_get "parameter.cb_pcie_mode_hwtcl.value"] || [ip_get "parameter.cb_pcie_rx_lite_hwtcl.value"] } {
         set TxSUsed 0
         # When 0 No TXs Port
      }
      if { ${TxSUsed} == 1} {
         puts $ScriptFile "# Limit TxS Address Space"
         set avmm_addr_width_hwtcl    [ip_get "parameter.avmm_addr_width_hwtcl.value"]
         if { $avmm_addr_width_hwtcl == 64 } {
            puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl {32}"
            ::altera_pcie_a10_hip::fileset::alteracion_ed_message "change Avalon-MM address width to 32 bit."
             send_message info "The Avalon-MM generated example design application operates with Avalon-MM address width of 32-bit."
         }
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_pass_thru_bits_hwtcl {12}"
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_num_entries_hwtcl {2}"
         puts $ScriptFile "set_instance_parameter_value ${instance} cg_impl_cra_av_slave_port_hwtcl {1}"
         set CRAUsed 1
      }

      if { ${CRAUsed} == 1 } {
         puts $ScriptFile "add_connection ${instance}.rxm_irq ${instance}.cra_irq"
         puts $ScriptFile "auto_assign_irqs ${instance}"
      }

      for { set i 0 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar 1
         }
         if { $bar == 1 } {
            if { ${TxSUsed} == 1} {
               if {$TxSConnected == 0} {
                  puts $ScriptFile "add_connection ${instance}.rxm_bar${i} ${instance}.txs"
                  set TxSConnected 1
               }
            }

            puts $ScriptFile "add_connection ${instance}.rxm_bar${i} MEM.s1"
            puts $ScriptFile "set_connection_parameter_value ${instance}.rxm_bar${i}/MEM.s1 baseAddress {0}"

            if { ${CRAUsed} == 1 } {
               puts $ScriptFile "add_connection ${instance}.rxm_bar${i} ${instance}.cra"
               if { $CRAConnected == 0} {
                  set CRAConnected 1
               }
            }
         }
      }
      set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
      if { $dynamic_reconfig ==1 } {
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
         puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
      }
      puts $ScriptFile "lock_avalon_base_address MEM.s1"

   } elseif { $interface_type_hwtcl == "Avalon-MM with DMA" } {
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "# Adding on-chip memory"
      puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
      puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
      puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {${family}}         "
      puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {true}             "
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
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk2"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset1"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset2"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master MEM.s1"
      puts $ScriptFile "add_connection ${instance}.dma_wr_master MEM.s2"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master ${instance}.rd_dts_slave"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master ${instance}.wr_dts_slave"

      puts $ScriptFile "add_connection ${instance}.rd_dcm_master ${instance}.txs"
      puts $ScriptFile "add_connection ${instance}.wr_dcm_master ${instance}.txs"

      puts $ScriptFile "# DMA Controller uses BAR 0-1 (64-bits)"
      if { $bar0_type_hwtcl != "64-bit prefetchable memory" } {
         puts $ScriptFile "set_instance_parameter_value ${instance} bar0_type_hwtcl   {64-bit prefetchable memory}"
         puts $ScriptFile "set_instance_parameter_value ${instance} bar1_type_hwtcl   {Disabled}"
         ::altera_pcie_a10_hip::fileset::alteracion_ed_message "the option BAR0 is set to 64-bit prefetchable memory when using the Avalon-MM DMA Interface"
      }
      if { $internal_controller_hwtcl == 0 } {
         puts $ScriptFile "set_instance_parameter_value ${instance} internal_controller_hwtcl 1"
         ::altera_pcie_a10_hip::fileset::alteracion_ed_message "the option \"Instantiate internal descriptor controller\" is enabled when using the Avalon-MM DMA Interface."
      }

      set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
      if { $dynamic_reconfig ==1 } {
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
         puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
      }

      puts $ScriptFile "# Non DMA Controller BAR"
      set CRAConnected 0
      set NoAppBAR 1
      set CRAUsed [ip_get "parameter.cg_impl_cra_av_slave_port_hwtcl.value"]
      if { ${CRAUsed} == 0 } {
         set CRAConnected 1
      }
      for { set i 2 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar 1
         }
         if { $bar == 1 } {
            puts $ScriptFile "add_connection DUT.rxm_bar${i} MEM.s1"
            set NoAppBAR 0
            if { ${CRAConnected} == 0 } {
               puts $ScriptFile "add_connection DUT.rxm_bar${i} DUT.cra"
               set CRAConnected 1
            }
         }
      }
      if { ${NoAppBAR} == 1 && ${CRAConnected} == 0 } {
         puts $ScriptFile "set_instance_parameter_value DUT bar2_type_hwtcl   {64-bit prefetchable memory}"
         puts $ScriptFile "add_connection DUT.rxm_bar2 DUT.cra"
         send_message info "Adding BAR2 to enable CRA access from RX Master"
      }

      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/DUT.rd_dts_slave baseAddress {0x01000000}"
      puts $ScriptFile "lock_avalon_base_address DUT.rd_dts_slave"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/DUT.wr_dts_slave baseAddress {0x01002000}"
      puts $ScriptFile "lock_avalon_base_address DUT.wr_dts_slave"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/MEM.s1 baseAddress {0}"
      puts $ScriptFile "lock_avalon_base_address MEM.s1"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_wr_master/MEM.s2 baseAddress {0}"
      puts $ScriptFile "lock_avalon_base_address MEM.s2"
      puts $ScriptFile "auto_assign_system_base_addresses"
   }
   puts $ScriptFile "set_interface_property board_pins EXPORT_OF DK.dk_board"
   puts $ScriptFile "add_connection DK.dk_hip ${instance}.dk_hip"
   puts $ScriptFile "add_connection ${instance}.coreclkout_hip DK.clock"

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

	   if {$family == "Arria 10" } {
         send_message info "Running: qsys-script --script=${QSYSScript} --new-quartus-project=pcie_example_design"
         set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --script=${QSYSScriptPath} --new-quartus-project=pcie_example_design"] 
       } else {
         send_message info "Running: qsys-script --script=${QSYSScript} --new-quartus-project=pcie_example_design --device=${DeviceQSF} --deviceFamily=$family"
         set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --script=${QSYSScriptPath} --new-quartus-project=pcie_example_design --device=${DeviceQSF} --deviceFamily=$family"]       
	   }

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
      ::altera_pcie_a10_hip::fileset::generate_design_example_files  ${QSYSTemPath} ${QSYSTemName}
   } else {
      add_fileset_file ${QSYSScript} OTHER PATH ${QSYSScriptPath}
      send_message info "Unable to create ${QSYSTem}"
      send_message info "Copied ${QSYSScript} in the example design directory, exiting ........."
   }
}

proc ::altera_pcie_a10_hip::fileset::fixed_design_example { from_dynamic_design_example parameter_exception } {

   send_message info "Copying-fixed QSYS example design in progress"

   global env
   set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
   set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
   set link_width_integer_hwtcl     [ip_get "parameter.link_width_integer_hwtcl.value"]
   set port_type_integer_hwtcl      [ip_get "parameter.port_type_integer_hwtcl.value"]
   set lane_rate_integer_hwtcl      [ip_get "parameter.lane_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl [ip_get "parameter.interface_type_integer_hwtcl.value"]
   set exdes_prj "ep_g${lane_rate_integer_hwtcl}x${link_width_integer_hwtcl}"

   if { ${lane_rate_integer_hwtcl} == "3" && ${link_width_integer_hwtcl} == "8" } {
      set interface_type_hwtcl [ip_get "parameter.interface_type_hwtcl.value"]
      if { ${interface_type_hwtcl} == "Avalon-MM with DMA" }    {
         set exdes_prj "ep_g3x8_avmm256_integrated"
      } else {
         set exdes_prj "ep_g3x8_ast_pio"
      }
   }

   if { $from_dynamic_design_example == 1 } {
      send_message info "INFO ====================================================<br/>
                         Generating a fixed (not customized) ${exdes_prj} example design <br/>
                         when using ${parameter_exception}<br/>
                         The parameter values will not exactly match all the values currently set in the <br/>
                         IP Parameter Editor."
   }

   set ori_qsys "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/a10/${exdes_prj}.qsys"
   ::altera_pcie_a10_hip::fileset::generate_design_example_files  ${ori_qsys} ${exdes_prj}
}

proc ::altera_pcie_a10_hip::fileset::dynamic_example_design {} {

   send_message info "Auto-generation of QSYS example design parameter checking"

   set link_width_integer_hwtcl     [ip_get "parameter.link_width_integer_hwtcl.value"]
   set port_type_integer_hwtcl      [ip_get "parameter.port_type_integer_hwtcl.value"]
   set lane_rate_integer_hwtcl      [ip_get "parameter.lane_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl [ip_get "parameter.interface_type_integer_hwtcl.value"]

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
   # Step 1; let's determine what the Interface type (AvST, AVMM. SRIOV, AvMM w/DMA) and app interface width (64, 128, 256) are.
   #
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   set ACDSVERSION 18.1
   foreach param $nf_hip_parameters {
      set strParamName ${param}
      set strParamValue [ip_get "parameter.${param}.value"]
      if {$strParamValue=="64-bit"} {
         set intInterfaceWidth "64"
      }
      if {$strParamValue=="128-bit"} {
         set intInterfaceWidth "128"
      }
      if {$strParamValue=="256-bit"} {
         set intInterfaceWidth "256"
      }
      if {$strParamName=="interface_type_hwtcl"} {
         set strInterfaceType $strParamValue
      }
      if {$strParamName=="port_type_hwtcl"} {
         set strPortType $strParamValue
      }
      #Check exception parameters that will cause the generated example designs to fail.  The current list of
      #exceptions includes the following parameters and values:
      #1.  "Enable Configuration Bypass":  cseb_config_bypass_hwtcl = 1

      if {$strParamName=="cseb_config_bypass_hwtcl" && $strParamValue=="1"} {
             if {$strParamName=="include_sriov_hwtcl" && $strParamValue=="0"} {
            set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
            set strParameterException "${strParameterException} Enable Configuration Bypass"
            set strGenerationPossible "False"
                 }
      }
      #2.  "Enable byte parity ports on Avalon-ST interface":  use_ast_parity_hwtcl = 1
      if {$strParamName=="use_ast_parity_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strParameterException "${strParameterException} Enable byte parity ports on Avalon-ST interface"
         set strGenerationPossible "False"
      }
      #2.1 "Enable multiple packets per cycle for the 256-bit Avalon-ST interface":  multiple_packets_per_cycle_hwtcl = 1
      if {$strParamName=="multiple_packets_per_cycle_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strParameterException "${strParameterException} Enable multiple packets per cycle for the 256-bit Avalon-ST interface"
         set strGenerationPossible "False"
      }
      #3.  "Enable local management interface (LMI)":  enable_lmi_hwtcl = 1
      if {$strParamName=="enable_lmi_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable local management interface (LMI)"
      }
      #4.  "Enable ECRC forwarding on the Avalon-ST Interface": use_crc_forwarding_hwtcl = 1
      if {$strParamName=="use_crc_forwarding_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable ECRC forwarding on the Avalon-ST Interface"
      }
      #5.  "Track Rx completion buffer overflow on the Avalon-ST interface"  : track_rxfc_cplbuf_ovf_hwtcl = 1
      if {$strParamName=="track_rxfc_cplbuf_ovf_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Track Rx completion buffer overflow on the Avalon-ST interface"
      }
      #6   "Implement MSI-X" : enable_function_msix_support_hwtcl = 1
      if {$strParamName=="enable_function_msix_support_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Implement MSI-X"
      }
      #7.   "Enable Completer-Only EP":  cb_pcie_mode_hwtcl = 1
      if {$strParamName=="cb_pcie_mode_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable completer-only Endpoint"
      }
      #8.  "Enable completer-only EP with 4-byte payload":  cb_pcie_rx_lite_hwtcl = 1
      if {$strParamName=="cb_pcie_rx_lite_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable completer-only Endpoint with 4-byte payload"
      }
      #9.  "Export MSI/MSI-X conduit interfaces":     cg_enable_advanced_interrupt_hwtcl = 1
      if {$strParamName=="cg_enable_advanced_interrupt_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Export MSI/MSI-X conduit interfaces"
      }
      #10.  "Enable Hard IP Status Bus when using the AVMM interface":  enable_hip_status_for_avmm_hwtcl = 1
      if {$strParamName=="enable_hip_status_for_avmm_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable Hard IP Status Bus when using the AVMM interface"
      }
      #11.  "Port type: Root port":  port_type_hwtcl = Root port
      if {$strParamName=="port_type_hwtcl" && $strParamValue=="Root port"} {
         if {$strInterfaceType=="Avalon-ST" || $strInterfaceType=="Avalon-ST with SR-IOV" || $strInterfaceType=="Avalon-MM with DMA"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Application interface type: A10 Root Port example design only supports Avalon-MM interface type" 
         } 
         #elseif { ${lane_rate_integer_hwtcl} != "3" || ${link_width_integer_hwtcl} != "8" } {
         #set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         #set strGenerationPossible "False"
         #set strParameterException "${strParameterException} Hard IP rate: A10 Root Port example design currently only supports Gen3x8"
         #}
      }
   }
   # Example design Parameter Exception
   # END
   #####################################################################




   set valid_design_example [ ::altera_pcie_a10_hip::fileset::validate_design_example ]
   #Note:  In the standard message window, 60characters can be seen on the first line and 89 characters on the following lines.

   if {$strGenerationPossible=="False"} {
      global env
      set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
      set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
      send_message error "The example design cannot be generated with the following parameter settings: <br/>
      ${strParameterException}."
                send_message info "To obtain an example design please disable the invalid option(s) and try again.  <br/>
                Alternatively, you can select an example design from one of several available in the ACDS Installation <br/>
                Directory here: ${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/a10.  <br/>
                Information on using those designs can be found in the IP QuickStart/IP User Guide."

   } elseif { $valid_design_example != 1 } {
      send_message error "$valid_design_example"
   } elseif {$strInterfaceType=="Avalon-ST" && $intInterfaceWidth=="256"} {
      ::altera_pcie_a10_hip::fileset::fixed_design_example  1 "${strInterfaceType}, ${intInterfaceWidth}"
   } elseif {$strInterfaceType=="Avalon-ST with SR-IOV"} {
      ::altera_pcie_a10_hip::fileset::fixed_design_example  1 ${strInterfaceType}
   } elseif {$strPortType=="Legacy endpoint"} {
      ::altera_pcie_a10_hip::fileset::fixed_design_example  1 ${strPortType}
   } elseif {$strPortType=="Root port" && $strInterfaceType=="Avalon-MM"} {
      ::altera_pcie_a10_hip::fileset::generate_dynamic_rp_qsys
   } else {
      ::altera_pcie_a10_hip::fileset::generate_dynamic_ep_qsys
   }
}




proc ::altera_pcie_a10_hip::fileset::callback_example_design {ip_name} {

   set use_dynamic_design_example_hwtcl  [ip_get "parameter.use_dynamic_design_example_hwtcl.value"]

   if { $use_dynamic_design_example_hwtcl == 1 } {
      ::altera_pcie_a10_hip::fileset::dynamic_example_design
   } else {
      ::altera_pcie_a10_hip::fileset::fixed_design_example  0 "Empty"
   }
}
