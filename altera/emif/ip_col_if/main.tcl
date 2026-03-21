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


package provide altera_emif::ip_col_if::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_col_if::main:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}

proc ::altera_emif::ip_col_if::main::create_parameters {} {
   ::altera_emif::util::device_family::create_parameters

   ::altera_emif::util::hwtcl_utils::_add_parameter ENABLE_JTAG_AVALON_MASTER boolean true
   set_parameter_property ENABLE_JTAG_AVALON_MASTER DISPLAY_NAME [get_string PARAM_ENABLE_JTAG_AVALON_MASTER_NAME]
   set_parameter_property ENABLE_JTAG_AVALON_MASTER DESCRIPTION [get_string PARAM_ENABLE_JTAG_AVALON_MASTER_DESCRIPTION]

   ::altera_emif::util::hwtcl_utils::_add_parameter NUM_AVALON_INTERFACES INTEGER 0
   set_parameter_property NUM_AVALON_INTERFACES DISPLAY_NAME [get_string PARAM_NUM_AVALON_INTERFACES_NAME]
   set_parameter_property NUM_AVALON_INTERFACES DESCRIPTION [get_string PARAM_NUM_AVALON_INTERFACES_DESCRIPTION]
   set_parameter_property NUM_AVALON_INTERFACES ALLOWED_RANGES [list 0 1 2 3 4 5 6 7 8 9 10]

   ::altera_emif::util::hwtcl_utils::_add_parameter ADDR_WIDTH INTEGER 30
   set_parameter_property ADDR_WIDTH DISPLAY_NAME [get_string PARAM_ADDR_WIDTH_NAME]
   set_parameter_property ADDR_WIDTH DESCRIPTION [get_string PARAM_ADDR_WIDTH_DESCRIPTION]
   set_parameter_property ADDR_WIDTH ALLOWED_RANGES {1:64}

   ::altera_emif::util::hwtcl_utils::_add_parameter JTAG_MASTER_NAME string "colmaster"
   set_parameter_property JTAG_MASTER_NAME DISPLAY_NAME [get_string PARAM_JTAG_MASTER_NAME_NAME]
   set_parameter_property JTAG_MASTER_NAME DESCRIPTION [get_string PARAM_JTAG_MASTER_NAME_DESCRIPTION]
   set_parameter_property JTAG_MASTER_NAME VISIBLE true
}

proc ::altera_emif::ip_col_if::main::add_display_items {} {

   set phy_tab "Parameters"
   set interfaces_grp "Interfaces"


   add_display_item "" $phy_tab GROUP tab

   add_display_item $phy_tab $interfaces_grp GROUP

   add_param_to_gui $interfaces_grp ENABLE_JTAG_AVALON_MASTER
   add_param_to_gui $interfaces_grp NUM_AVALON_INTERFACES

   return 1
}



set_module_property COMPOSITION_CALLBACK ::altera_emif::ip_col_if::main::composition_callback

proc ::altera_emif::ip_col_if::main::ip_derive_parameters {} {
}

proc ::altera_emif::ip_col_if::main::ip_update_range_parameters {} {
}

proc ::altera_emif::ip_col_if::main::ip_validate {} {

   ::altera_emif::util::device_family::load_data true

   ip_derive_parameters

   ip_update_range_parameters

   if {![get_parameter_value ENABLE_JTAG_AVALON_MASTER] && ![get_parameter_value NUM_AVALON_INTERFACES]} {
      ::altera_emif::util::messaging::post_ipgen_e_msg MSG_NO_JTAG_MASTER_OR_AVALON_SLAVE
   }

   if {[::altera_emif::util::qini::ini_is_on "altera_emif_print_user_parameters"]} {
      ::altera_emif::util::hwtcl_debug::print_user_parameter_values
   }
}

proc ::altera_emif::ip_col_if::main::composition_callback {} {

   ip_validate

   if {[has_pending_ipgen_e_msg]} {
      issue_pending_ipgen_e_msg_and_terminate
   } else {
      _compose

      issue_pending_ipgen_e_msg_and_terminate
   }
}

proc ::altera_emif::ip_col_if::main::_compose {} {

   add_interface avl_clk_in clock sink
   add_interface avl_clk_out clock source

   set clk_bridge "clk_bridge"
   add_instance $clk_bridge altera_clock_bridge
   set_instance_parameter_value $clk_bridge NUM_CLOCK_OUTPUTS 2
   set_interface_property avl_clk_in export_of "${clk_bridge}.in_clk"
   set_interface_property avl_clk_out export_of "${clk_bridge}.out_clk"

   add_interface avl_rst_in reset end
   add_interface avl_rst_out reset source

   set rst_bridge "rst_bridge"
   add_instance $rst_bridge altera_reset_bridge
   set_instance_parameter_value $rst_bridge NUM_RESET_OUTPUTS 2
   set_interface_property avl_rst_in export_of "${rst_bridge}.in_reset"
   set_interface_property avl_rst_out export_of "${rst_bridge}.out_reset"
   add_connection "${clk_bridge}.out_clk_1" " ${rst_bridge}.clk"

   set AVL_BRIDGE_OUT "avl_bridge_out"
   add_instance ${AVL_BRIDGE_OUT} altera_avalon_mm_bridge

   set_instance_parameter ${AVL_BRIDGE_OUT} DATA_WIDTH 32
   set_instance_parameter ${AVL_BRIDGE_OUT} SYMBOL_WIDTH 8
   set_instance_parameter ${AVL_BRIDGE_OUT} ADDRESS_WIDTH [get_parameter_value ADDR_WIDTH]
   set_instance_parameter ${AVL_BRIDGE_OUT} ADDRESS_UNITS "WORDS"

   add_connection "${clk_bridge}.out_clk_1/${AVL_BRIDGE_OUT}.clk"
   add_connection "${rst_bridge}.out_reset_1/${AVL_BRIDGE_OUT}.reset"

   set IOAUX_IF to_ioaux
   add_interface $IOAUX_IF avalon start
   set_interface_property $IOAUX_IF export_of ${AVL_BRIDGE_OUT}.m0

   for {set i 0} {$i < [get_parameter_value NUM_AVALON_INTERFACES]} {incr i} {
      set AVL_BRIDGE "avl_bridge_${i}"
      set AVL_IF "avl_${i}"

      add_instance ${AVL_BRIDGE} altera_avalon_mm_bridge

      set_instance_parameter ${AVL_BRIDGE} DATA_WIDTH 32
      set_instance_parameter ${AVL_BRIDGE} SYMBOL_WIDTH 8
      set_instance_parameter ${AVL_BRIDGE} ADDRESS_WIDTH [get_parameter_value ADDR_WIDTH]
      set_instance_parameter ${AVL_BRIDGE} ADDRESS_UNITS "WORDS"

      add_connection "${clk_bridge}.out_clk_1/${AVL_BRIDGE}.clk"
      add_connection "${rst_bridge}.out_reset_1/${AVL_BRIDGE}.reset"

      add_connection "${AVL_BRIDGE}.m0/${AVL_BRIDGE_OUT}.s0"
      set_connection_parameter_value "${AVL_BRIDGE}.m0/${AVL_BRIDGE_OUT}.s0" baseAddress "0x0"

      add_interface $AVL_IF avalon end
      set_interface_property $AVL_IF export_of ${AVL_BRIDGE}.s0
   }

   if {[get_parameter_value ENABLE_JTAG_AVALON_MASTER]} {
      set JTAG_MASTER [get_parameter_value JTAG_MASTER_NAME]
      add_instance $JTAG_MASTER alt_mem_if_jtag_master

      set_instance_parameter $JTAG_MASTER USE_PLI "0"
      set_instance_parameter $JTAG_MASTER PLI_PORT "50000"

      add_connection "${clk_bridge}.out_clk_1/${JTAG_MASTER}.clk"
      add_connection "${rst_bridge}.out_reset_1/${JTAG_MASTER}.clk_reset"

      add_connection "${JTAG_MASTER}.master/${AVL_BRIDGE_OUT}.s0"
      set_connection_parameter_value "${JTAG_MASTER}.master/${AVL_BRIDGE_OUT}.s0" arbitrationPriority "1"
      set_connection_parameter_value "${JTAG_MASTER}.master/${AVL_BRIDGE_OUT}.s0" baseAddress "0x0000"
   }
}



proc ::altera_emif::ip_col_if::main::_init {} {
}

::altera_emif::ip_col_if::main::_init
