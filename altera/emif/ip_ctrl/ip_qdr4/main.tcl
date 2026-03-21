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


package provide altera_emif::ip_ctrl::ip_qdr4::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::exports
package require altera_emif::ip_ctrl::util
package require altera_emif::ip_ctrl::ip_qdr4::ctrl_expert_exports
package require altera_emif::ip_ctrl::ip_qdr4::enum_defs

namespace eval ::altera_emif::ip_ctrl::ip_qdr4::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_ctrl::ip_qdr4::main::create_parameters {} {
     
   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs
   
   ::altera_emif::ip_ctrl::util::define_common_hdl_parameters
   
   add_derived_hdl_param      CTRL_DATA_INV_ENA                  boolean        false
   add_derived_hdl_param      CTRL_ADDR_INV_ENA                  boolean        false
   add_derived_hdl_param      CTRL_RAW_TURNAROUND_DELAY_CYC      integer        3
   add_derived_hdl_param      CTRL_WAR_TURNAROUND_DELAY_CYC      integer        10

   return 1
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
   
   set if_ports_names [altera_emif::ip_ctrl::util::register_ctrl_interfaces CTRL_QDR4_IF]
   set if_ports [dict get $if_ports_names IF_PORTS]
   set if_names [dict get $if_ports_names IF_NAMES]
   
   ::altera_emif::ip_ctrl::util::derive_common_hdl_parameters $if_ports
   
   _derive_mem_model_parameters
   
   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::sim_vhdl_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_vhdl_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::sim_verilog_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_verilog_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::quartus_synth_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::quartus_synth_fileset_callback $top_level [_generate_verilog_fileset]
}


proc ::altera_emif::ip_ctrl::ip_qdr4::main::_derive_mem_model_parameters {} {
   set ctrl_param_list   [list \
                            RAW_TURNAROUND_DELAY_CYC \
                            WAR_TURNAROUND_DELAY_CYC
                         ]

   foreach ctrl_param $ctrl_param_list {
      set_parameter_value "CTRL_${ctrl_param}"  [get_parameter_value "CTRL_QDR4_${ctrl_param}"]   
   }

   set ctrl_mem_param_list   [list \
                                DATA_INV_ENA \
                                ADDR_INV_ENA
                             ]

   foreach ctrl_mem_param $ctrl_mem_param_list {
      set_parameter_value "CTRL_${ctrl_mem_param}"  [get_parameter_value "MEM_QDR4_${ctrl_mem_param}"]   
   }
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::_generate_verilog_fileset {} {
   
   set qdir $::env(QUARTUS_ROOTDIR)
   set common_dir "${qdir}/../ip/altera/emif/ip_ctrl/common/rtl"
   
   set file_list [list \
      rtl/altera_emif_ctrl_qdr4_top.sv \
      rtl/altera_emif_ctrl_qdr4.sv \
      rtl/altera_emif_ctrl_qdr4_afi_channel_fifo.sv \
      rtl/altera_emif_ctrl_qdr4_afi_in_adjust_timeslot.sv \
      rtl/altera_emif_ctrl_qdr4_afi_out_adjust_timeslot.sv \
      rtl/altera_emif_ctrl_qdr4_ainv_block.sv \
      rtl/altera_emif_ctrl_qdr4_ainv_block_calc_if_inv.sv \
      rtl/altera_emif_ctrl_qdr4_avl_fsm.sv \
      rtl/altera_emif_ctrl_qdr4_cmd_scheduler.sv \
      rtl/altera_emif_ctrl_qdr4_dinv_read_block.sv \
      rtl/altera_emif_ctrl_qdr4_dinv_write_block.sv \
      rtl/altera_emif_ctrl_qdr4_dinv_write_block_calc_if_inv.sv \
      rtl/altera_emif_ctrl_qdr4_fifo.sv \
      rtl/altera_emif_ctrl_qdr4_fifo_lookahead.sv]
 
   return $file_list
}

proc ::altera_emif::ip_ctrl::ip_qdr4::main::_init {} {
}

::altera_emif::ip_ctrl::ip_qdr4::main::_init

