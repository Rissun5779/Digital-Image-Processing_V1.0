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


package provide altera_emif::ip_cal_slave::ip_core_nf::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_cal_slave::ip_core_nf::main:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}

proc ::altera_emif::ip_cal_slave::ip_core_nf::main::create_parameters {} {

   add_user_param ENABLE_JTAG_UART           boolean  true     ""                                    ""
   add_user_param ENABLE_SOFT_RAM            boolean  true     ""                                    ""
   add_user_param SOFT_RAM_HEXFILE           string   ""       ""                                    ""

}

proc ::altera_emif::ip_cal_slave::ip_core_nf::main::composition_callback {} {

   set jtag_uart_en    [get_parameter_value ENABLE_JTAG_UART]
   set soft_ram_en     [get_parameter_value ENABLE_SOFT_RAM]
   set hexfile         [get_parameter_value SOFT_RAM_HEXFILE]

   set clk_bridge "clk_bridge"
   add_instance $clk_bridge altera_clock_bridge
   set_instance_parameter_value $clk_bridge {NUM_CLOCK_OUTPUTS} {1}

   set rst_bridge "rst_bridge"
   add_instance $rst_bridge altera_reset_bridge
   set_instance_parameter_value $rst_bridge {SYNCHRONOUS_EDGES} none
   set_instance_parameter_value $rst_bridge {NUM_RESET_OUTPUTS} {1}

   add_interface "clk" clock sink
   add_interface "rst" reset sink
   set_interface_property "clk" EXPORT_OF "${clk_bridge}.in_clk"
   set_interface_property "rst" EXPORT_OF "${rst_bridge}.in_reset"
   set ioaux_master_clk_source "${clk_bridge}.out_clk"
   set ioaux_master_rst_source "${rst_bridge}.out_reset"

   set AVL_BRIDGE "ioaux_master_bridge"
   add_instance ${AVL_BRIDGE} altera_avalon_mm_bridge

   set_instance_parameter ${AVL_BRIDGE} DATA_WIDTH 32
   set_instance_parameter ${AVL_BRIDGE} SYMBOL_WIDTH 8
   set_instance_parameter ${AVL_BRIDGE} ADDRESS_WIDTH 16
   set_instance_parameter ${AVL_BRIDGE} ADDRESS_UNITS "SYMBOLS"

   add_connection "$ioaux_master_clk_source/${AVL_BRIDGE}.clk"
   add_connection "$ioaux_master_rst_source/${AVL_BRIDGE}.reset"

   add_interface "avl" avalon sink
   set_interface_property "avl" EXPORT_OF "${AVL_BRIDGE}.s0"

   if {$jtag_uart_en} {
      set jtag_uart "jtag_uart"
      add_instance $jtag_uart altera_avalon_jtag_uart
      
      set_instance_parameter_value $jtag_uart writeBufferDepth 512

      add_connection "${AVL_BRIDGE}.m0" "${jtag_uart}.avalon_jtag_slave"
      set_connection_parameter_value "${AVL_BRIDGE}.m0/${jtag_uart}.avalon_jtag_slave" baseAddress {0x00008000}

      add_connection "$ioaux_master_clk_source" "${jtag_uart}.clk"

      add_connection "$ioaux_master_rst_source" "${jtag_uart}.reset"
   }

   if {$soft_ram_en} {
      set onchip_memory "ioaux_soft_ram"
      set onchip_memory_size 16383
      add_instance $onchip_memory altera_avalon_onchip_memory2
      set_instance_parameter_value $onchip_memory {allowInSystemMemoryContentEditor} {0}
      set_instance_parameter_value $onchip_memory {blockType} {AUTO}
      set_instance_parameter_value $onchip_memory {dataWidth} {32}
      set_instance_parameter_value $onchip_memory {dualPort} {0}
      set_instance_parameter_value $onchip_memory {initMemContent} {1}
      set_instance_parameter_value $onchip_memory {initializationFileName} $hexfile
      set_instance_parameter_value $onchip_memory {instanceID} {NONE}
      set_instance_parameter_value $onchip_memory {memorySize} $onchip_memory_size
      set_instance_parameter_value $onchip_memory {readDuringWriteMode} {DONT_CARE}
      set_instance_parameter_value $onchip_memory {simAllowMRAMContentsFile} {0}
      set_instance_parameter_value $onchip_memory {simMemInitOnlyFilename} {0}
      set_instance_parameter_value $onchip_memory {singleClockOperation} {0}
      set_instance_parameter_value $onchip_memory {slave1Latency} {1}
      set_instance_parameter_value $onchip_memory {slave2Latency} {1}
      set_instance_parameter_value $onchip_memory {useNonDefaultInitFile} {1}
      set_instance_parameter_value $onchip_memory {copyInitFile} {1}
      set_instance_parameter_value $onchip_memory {useShallowMemBlocks} {0}
      set_instance_parameter_value $onchip_memory {writable} {0}
      set_instance_parameter_value $onchip_memory {ecc_enabled} {0}
      set_instance_parameter_value $onchip_memory {resetrequest_enabled} {0}

      add_connection "${AVL_BRIDGE}.m0" "${onchip_memory}.s1"
      set_connection_parameter_value "${AVL_BRIDGE}.m0/${onchip_memory}.s1" baseAddress {0x00000000}

      add_connection "$ioaux_master_clk_source"   "${onchip_memory}.clk1"

      add_connection "$ioaux_master_rst_source" "${onchip_memory}.reset1"
   }

   return 1
}



proc ::altera_emif::ip_cal_slave::ip_core_nf::main::_init {} {
}

::altera_emif::ip_cal_slave::ip_core_nf::main::_init

