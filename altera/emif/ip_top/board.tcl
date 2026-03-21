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


package provide altera_emif::ip_top::board 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_top::protocol_expert

namespace eval ::altera_emif::ip_top::board:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}


proc ::altera_emif::ip_top::board::create_parameters {is_top_level_component} {


   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_BOARD $is_top_level_component

   return 1   
}

proc ::altera_emif::ip_top::board::set_family_specific_defaults {family_enum base_family_enum is_hps} {

   
   
   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_BOARD $family_enum $base_family_enum $is_hps
   
   return 1
}

proc ::altera_emif::ip_top::board::add_display_items {tabs} {

   set board_tab [lindex $tabs 0]

   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_BOARD $tabs
   
   return 1
}

proc ::altera_emif::ip_top::board::validate {} {
   
   
   ::altera_emif::ip_top::protocol_expert::validate FUNC_BOARD

   return 1
}


proc ::altera_emif::ip_top::board::_init {} {
}

::altera_emif::ip_top::board::_init
