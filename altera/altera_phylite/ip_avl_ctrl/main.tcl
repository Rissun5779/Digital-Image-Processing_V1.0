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


package provide altera_phylite::ip_avl_ctrl::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_phylite::util::arch_expert
package require altera_phylite::ip_top::exports

namespace eval ::altera_phylite::ip_avl_ctrl::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}


proc ::altera_phylite::ip_avl_ctrl::main::create_parameters {} {


   return 1
}

proc ::altera_phylite::ip_avl_ctrl::main::elaboration_callback {} {


   _elaborate_avalon_in_interface
   _elaborate_avalon_out_interface

   return 1
}

proc ::altera_phylite::ip_avl_ctrl::main::sim_vhdl_fileset_callback {top_level} {
  
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

proc ::altera_phylite::ip_avl_ctrl::main::sim_verilog_fileset_callback {top_level} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_phylite::ip_avl_ctrl::main::quartus_synth_fileset_callback {top_level} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}



proc ::altera_phylite::ip_avl_ctrl::main::_generate_verilog_fileset {} {

   set file_list [list \
      rtl/altera_phylite_avl_ctrl.sv \
      rtl/altera_phylite_avl_ctrl_addr_offsets.iv \
      rtl/altera_phylite_avl_ctrl_registers.iv \
   ]
 
   return $file_list
}

proc ::altera_phylite::ip_avl_ctrl::main::_elaborate_avalon_in_interface {} {

   add_interface avalon_in_interface_conduit_end conduit end
   set_interface_property avalon_in_interface_conduit_end ENABLED true
   add_interface_port avalon_in_interface_conduit_end avl_in_clk            avl_clk            Input   1
   add_interface_port avalon_in_interface_conduit_end avl_in_reset_n        avl_reset_n        Input   1
   add_interface_port avalon_in_interface_conduit_end avl_in_read           avl_read           Input   1
   add_interface_port avalon_in_interface_conduit_end avl_in_write          avl_write          Input   1
   add_interface_port avalon_in_interface_conduit_end avl_in_byteenable     avl_byteenable     Input   4
   set_port_property avl_in_byteenable VHDL_TYPE std_logic_vector
   add_interface_port avalon_in_interface_conduit_end avl_in_writedata      avl_writedata      Input  32
   set_port_property avl_in_writedata VHDL_TYPE std_logic_vector
   add_interface_port avalon_in_interface_conduit_end avl_in_address        avl_address        Input  32
   set_port_property avl_in_address VHDL_TYPE std_logic_vector
   add_interface_port avalon_in_interface_conduit_end avl_in_readdata       avl_readdata       Output   32
   set_port_property avl_in_readdata VHDL_TYPE std_logic_vector
   add_interface_port avalon_in_interface_conduit_end avl_in_readdata_valid avl_readdata_valid Output    1
   add_interface_port avalon_in_interface_conduit_end avl_in_waitrequest    avl_waitrequest    Output    1

}

proc ::altera_phylite::ip_avl_ctrl::main::_elaborate_avalon_out_interface {} {

   add_interface avalon_out_interface_conduit_end conduit end
   set_interface_property avalon_out_interface_conduit_end ENABLED true
   add_interface_port avalon_out_interface_conduit_end avl_out_clk            avl_clk            Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_reset_n        avl_reset_n        Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_read           avl_read           Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_write          avl_write          Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_byteenable     avl_byteenable     Output   4
   set_port_property avl_out_byteenable VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_writedata      avl_writedata      Output  32
   set_port_property avl_out_writedata VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_address        avl_address        Output  28
   set_port_property avl_out_address VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_readdata       avl_readdata       Input   32
   set_port_property avl_out_readdata VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_readdata_valid avl_readdata_valid Input    1
   add_interface_port avalon_out_interface_conduit_end avl_out_waitrequest    avl_waitrequest    Input    1

}


proc ::altera_phylite::ip_avl_ctrl::main::_init {} {
}

::altera_phylite::ip_avl_ctrl::main::_init
