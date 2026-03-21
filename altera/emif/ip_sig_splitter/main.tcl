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


package provide altera_emif::ip_sig_splitter::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs

namespace eval ::altera_emif::ip_sig_splitter::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}



proc ::altera_emif::ip_sig_splitter::main::create_parameters {} {
   
   add_user_param     NUM_OF_FANOUTS            integer    1                         {1:128}                   ""
   add_user_param     INTERFACE_TYPE            string     "conduit"                 {conduit reset clock}     ""
   add_user_param     PORT_ROLE                 string     ""                        ""                        ""
   add_user_param     PORT_WIDTH                integer    1                         {1:128}                   ""
   add_user_param     PORT_IS_STD_LOGIC_VECTOR  boolean    false                     ""                        ""
}

proc ::altera_emif::ip_sig_splitter::main::elaboration_callback {} {

   set num_of_fanouts [get_parameter_value NUM_OF_FANOUTS]
   set if_type        [get_parameter_value INTERFACE_TYPE]
   set port_role      [get_parameter_value PORT_ROLE]
   set port_width     [get_parameter_value PORT_WIDTH]
   set port_is_vector [get_parameter_value PORT_IS_STD_LOGIC_VECTOR]
   
   if {$if_type == "reset" || $if_type == "clock"} {
      set input_if_dir "sink"
      set output_if_dir "source"
   } else {
      set input_if_dir "end"
      set output_if_dir "end"
   }
      
   add_interface "sig_input_if" $if_type $input_if_dir
   add_interface_port "sig_input_if" "sig_input" $port_role input $port_width
   
   for { set i 0 } { $i < $num_of_fanouts } { incr i } {
      add_interface "sig_output_if_$i" $if_type $output_if_dir
      add_interface_port "sig_output_if_$i" "sig_output_$i" $port_role output $port_width
      set_port_property "sig_output_$i" DRIVEN_BY "sig_input"
   }
   
   if {$port_width == 1 && $port_is_vector} {
      set_port_property "sig_input" VHDL_TYPE STD_LOGIC_VECTOR
      for { set i 0 } { $i < $num_of_fanouts } { incr i } {
         set_port_property "sig_output_$i" VHDL_TYPE STD_LOGIC_VECTOR
      }
   }
   
   if {$if_type == "reset"} {
      set_interface_property "sig_input_if" synchronousEdges NONE
      for { set i 0 } { $i < $num_of_fanouts } { incr i } {
         set_interface_property "sig_output_if_$i" synchronousEdges NONE
      }
   }
   
   return 1
}



proc ::altera_emif::ip_sig_splitter::main::_init {} {
}

::altera_emif::ip_sig_splitter::main::_init
