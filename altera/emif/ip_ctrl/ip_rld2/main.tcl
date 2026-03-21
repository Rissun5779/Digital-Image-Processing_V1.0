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


package provide altera_emif::ip_ctrl::ip_rld2::main 0.1

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
package require altera_emif::ip_ctrl::ip_rld2::ctrl_expert_exports
package require altera_emif::ip_ctrl::ip_rld2::enum_defs

namespace eval ::altera_emif::ip_ctrl::ip_rld2::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_ctrl::ip_rld2::main::create_parameters {} {
     
   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs
   
   ::altera_emif::ip_ctrl::util::define_common_hdl_parameters

   add_derived_hdl_param      MEM_CS_WIDTH                         integer      1
   add_derived_hdl_param      MEM_T_RC                             integer      1
   add_derived_hdl_param      MEM_T_WL                             integer      1
   add_derived_hdl_param      CTL_T_REFI                           integer      1
   add_derived_hdl_param      MEM_BUS_TURNAROUND_CYCLES_RD_TO_WR   integer      3
   add_derived_hdl_param      MEM_BUS_TURNAROUND_CYCLES_WR_TO_RD   integer      0
   add_derived_hdl_param      CTL_BURST_LENGTH                     integer      1
   add_derived_hdl_param      CTL_ADDR_WIDTH                       integer      1
   add_derived_hdl_param      CTL_CHIPADDR_WIDTH                   integer      1
   add_derived_hdl_param      CTL_BANKADDR_WIDTH                   integer      1
   add_derived_hdl_param      CTL_BEATADDR_WIDTH                   integer      1
   add_derived_hdl_param      CTL_CONTROL_WIDTH                    integer      1
   add_derived_hdl_param      CTL_CS_WIDTH                         integer      1
   add_derived_hdl_param      MEGAFUNC_DEVICE_FAMILY               string       ""       
  
   return 1
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
   
   set family_enum [get_device_family_enum]
   set_parameter_value MEGAFUNC_DEVICE_FAMILY [enum_data $family_enum MEGAFUNC_NAME]
   
   set if_ports_names [altera_emif::ip_ctrl::util::register_ctrl_interfaces CTRL_RLD2_IF]
   set if_ports [dict get $if_ports_names IF_PORTS]
   set if_names [dict get $if_ports_names IF_NAMES]
   
   ::altera_emif::ip_ctrl::util::derive_common_hdl_parameters $if_ports
   _derive_ctrl_parameters

   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::sim_vhdl_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_vhdl_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::sim_verilog_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_verilog_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::quartus_synth_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::quartus_synth_fileset_callback $top_level [_generate_verilog_fileset]
}


proc ::altera_emif::ip_ctrl::ip_rld2::main::_derive_ctrl_parameters {} {
   set cs_width             [get_parameter_value "MEM_RLD2_CS_WIDTH"]
   set mem_addr_width       [get_parameter_value "MEM_RLD2_ADDR_WIDTH"]
   set mem_bankaddr_width   [get_parameter_value "MEM_RLD2_BANK_ADDR_WIDTH"]
   set mem_clk_freq         [get_parameter_value "PHY_RLD2_MEM_CLK_FREQ_MHZ"]
   set rate_enum            [get_parameter_value "PHY_RLD2_RATE_ENUM"]
   set refresh_interval_us  [get_parameter_value "MEM_RLD2_REFRESH_INTERVAL_US"]
   set user_clk_ratio       [enum_data $rate_enum RATIO]
   set ctl_bl               [expr { [get_parameter_value "MEM_RLD2_BL"] / ( $user_clk_ratio * 2 ) } ]
   set ctl_beataddr_width   [expr { int(ceil(log($ctl_bl)/log(2))) } ]
   set ctl_chipaddr_width   [expr { int(ceil(log($cs_width)/log(2))) } ]
   set mem_clk_us           [expr { 1.0 / $mem_clk_freq } ]
   set mem_t_refi           [expr { int($refresh_interval_us / $mem_clk_us) } ]

   if {$user_clk_ratio == 2} {
      set ctl_t_refi [expr { $mem_t_refi / 2 }]
   } else {
      set ctl_t_refi $mem_t_refi
   }

   set_parameter_value "MEM_CS_WIDTH"                 $cs_width
   set_parameter_value "MEM_T_RC"                     [get_parameter_value "MEM_RLD2_TRC"]
   set_parameter_value "MEM_T_WL"                     [get_parameter_value "MEM_RLD2_TWL"]
   set_parameter_value "CTL_ADDR_WIDTH"               $mem_addr_width
   set_parameter_value "CTL_BANKADDR_WIDTH"           $mem_bankaddr_width
   set_parameter_value "CTL_BURST_LENGTH"             $ctl_bl
   set_parameter_value "CTL_BEATADDR_WIDTH"           $ctl_beataddr_width
   set_parameter_value "CTL_CHIPADDR_WIDTH"           $ctl_chipaddr_width
   set_parameter_value "CTL_CS_WIDTH"                 $cs_width
   set_parameter_value "CTL_T_REFI"                   $ctl_t_refi
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::_generate_verilog_fileset {} {
   
   set qdir $::env(QUARTUS_ROOTDIR)
	set common_dir "${qdir}/../ip/altera/emif/ip_ctrl/common/rtl"
   
   set file_list [list \
      rtl/altera_emif_ctrl_rld2_top.sv \
      rtl/altera_emif_ctrl_rld2_afi.sv \
      rtl/altera_emif_ctrl_rld2_bank_timer.sv \
      rtl/altera_emif_ctrl_rld2_controller.sv \
      rtl/altera_emif_ctrl_rld2_fsm.sv \
      rtl/altera_emif_ctrl_rld2_refresh.sv \
      rtl/altera_emif_ctrl_rld2_timers.sv \
      rtl/memctl_beat_valid_fifo.sv \
      rtl/memctl_burst_adapter.sv \
      rtl/memctl_burst_latency_shifter.sv \
      rtl/memctl_data_if.sv \
      rtl/memctl_reset_sync.v \
      rtl/memctl_wdata_fifo.sv \
      rtl/memctl_wdata_rdata_logic.sv
   ]
 
   return $file_list
}

proc ::altera_emif::ip_ctrl::ip_rld2::main::_init {} {
}

::altera_emif::ip_ctrl::ip_rld2::main::_init

