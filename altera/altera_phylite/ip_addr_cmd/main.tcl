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


package provide altera_phylite::ip_addr_cmd::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_phylite::util::arch_expert
package require altera_phylite::ip_top::exports

namespace eval ::altera_phylite::ip_addr_cmd::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}


proc ::altera_phylite::ip_addr_cmd::main::create_parameters {} {

   set max_num_groups 18
   
   ::altera_phylite::ip_top::exports::inherit_top_level_parameter_defs
   add_user_param PLL_VCO_TO_MEM_CLK_FREQ_RATIO integer 267 {1:1000}
   add_user_param SIM_CMD_PHASE integer 267 {1:1000}
   set_parameter_property PHYLITE_NUM_GROUPS                  HDL_PARAMETER true
   set_parameter_property PHYLITE_RATE_ENUM                   HDL_PARAMETER true
   set_parameter_property PLL_VCO_TO_MEM_CLK_FREQ_RATIO	      HDL_PARAMETER true
   set_parameter_property SIM_CMD_PHASE                	      HDL_PARAMETER true

   return 1
}

proc ::altera_phylite::ip_addr_cmd::main::elaboration_callback {} {

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]
   set rate     [get_parameter_value  PHYLITE_RATE_ENUM]
   set rate_mult 4
   if {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
      set rate_mult 2
   } elseif {[string compare -nocase $rate "RATE_IN_FULL"] == 0} {
      set rate_mult 1
   }

   add_interface core_clk_out_conduit_end conduit end
   set_interface_property core_clk_out_conduit_end ENABLED true
   add_interface_port core_clk_out_conduit_end cmd_clk cmd_clk Input 1

   add_interface dut_lock_conduit_end conduit end
   set_interface_property dut_lock_conduit_end ENABLED true
   add_interface_port dut_lock_conduit_end interface_locked dut_locked Input 1

   set cmd_from_core_width [expr $rate_mult + $rate_mult + $rate_mult + [expr $num_grps*$rate_mult]]
   add_interface cmd_from_core_conduit_end conduit end
   set_interface_property cmd_from_core_conduit_end ENABLED true
   add_interface_port cmd_from_core_conduit_end cmd_from_core data_out Input $cmd_from_core_width
   add_interface_port cmd_from_core_conduit_end core_cmd_oe data_oe    Input $cmd_from_core_width 
   add_interface_port cmd_from_core_conduit_end core_cmd_clk    strobe_out Input $rate_mult*2
   add_interface_port cmd_from_core_conduit_end core_cmd_clk_oe strobe_oe  Input $rate_mult

   set cmd_interface "addr_cmd_interface_conduit_end"
   set cmd_out_width [expr { $num_grps + 3 } ]
   add_interface $cmd_interface conduit end
   set_interface_property $cmd_interface ENABLED true
   add_interface_port $cmd_interface cmd io_data_out Output $cmd_out_width
   add_interface_port $cmd_interface ck io_strobe_out Output 1

   return 1
}

proc ::altera_phylite::ip_addr_cmd::main::sim_vhdl_fileset_callback {top_level} {
  
   set rtl_only 1
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }   
}

proc ::altera_phylite::ip_addr_cmd::main::sim_verilog_fileset_callback {top_level} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_phylite::ip_addr_cmd::main::quartus_synth_fileset_callback {top_level} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}



proc ::altera_phylite::ip_addr_cmd::main::_generate_verilog_fileset {} {

   set file_list [list \
      rtl/phylite_addr_cmd.sv \
   ]
 
   return $file_list
}

proc ::altera_phylite::ip_addr_cmd::main::_init {} {
}

::altera_phylite::ip_addr_cmd::main::_init
