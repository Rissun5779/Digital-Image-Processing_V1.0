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


# +-----------------------------------
# | request TCL package from ACDS 9.1
# |
package require -exact qsys 14.0
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_vic
# |
set_module_property NAME altera_vic
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Processors and Peripherals/Peripherals"
set_module_property DISPLAY_NAME "Vectored Interrupt Controller"
set_module_property DESCRIPTION "Vectored Interrupt Controller"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_embedded_ip.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property COMPOSITION_CALLBACK compose
set_module_property VALIDATION_CALLBACK validate

# |
# +-----------------------------------

# +-----------------------------------
# | parameters
# |
add_parameter NUMBER_OF_INT_PORTS INTEGER 8
set_parameter_property NUMBER_OF_INT_PORTS DISPLAY_NAME "Number of Interrupts"
set_parameter_property NUMBER_OF_INT_PORTS ALLOWED_RANGES 1:32
set_parameter_property NUMBER_OF_INT_PORTS DESCRIPTION "Number of Interrupt Inputs supported by the IRQ interface"

add_parameter RIL_WIDTH INTEGER 4
set_parameter_property RIL_WIDTH DISPLAY_NAME "Requested Interrupt Level (RIL) Width"
set_parameter_property RIL_WIDTH ALLOWED_RANGES 1:6
set_parameter_property RIL_WIDTH DESCRIPTION "Number of Bits used to represent the Requested Interrupt Level (RIL)"

add_parameter DAISY_CHAIN_ENABLE INTEGER 0
set_parameter_property DAISY_CHAIN_ENABLE DISPLAY_NAME DAISY_CHAIN_ENABLE
set_parameter_property DAISY_CHAIN_ENABLE DISPLAY_HINT boolean
set_parameter_property DAISY_CHAIN_ENABLE DESCRIPTION "Enable the Daisy-Chain input port"

add_parameter OVERRIDE_INTERRUPT_LATENCY BOOLEAN false
set_parameter_property OVERRIDE_INTERRUPT_LATENCY DISPLAY_NAME "Override Default Interrupt Signal Latency"
set_parameter_property OVERRIDE_INTERRUPT_LATENCY DESCRIPTION "Allows manual specification of the interrupt signal latency"

add_parameter INTERRUPT_LATENCY_CYCLES INTEGER 2
set_parameter_property INTERRUPT_LATENCY_CYCLES DISPLAY_NAME "Manual Interrupt Signal Latency"
set_parameter_property INTERRUPT_LATENCY_CYCLES ALLOWED_RANGES "2:2 3:3 4:4 5:5"
set_parameter_property INTERRUPT_LATENCY_CYCLES DESCRIPTION "Specifies the number of cycles it takes to process the incoming interrupt signals"

# |
# +-----------------------------------

# +-----------------------------------
# | simulation files
# |

# |
# +-----------------------------------
set NIOSII_TABLE "<html><table border=\"1\" width=\"100%\">
  <tr bgcolor=\"#C9DBF3\">
    <td valign=\"top\"><b>
      Number of Interrupts
    </b></td>
    <td valign=\"top\"><b>
      Interrupt Processing Latency
    </b></td>
  </tr>
    <tr bgcolor=\"#FFFFFF\">
    <td valign=\"top\">
      1
    </td>
    <td valign=\"top\">
      2 Cycles
    </td>
  </tr>
  </tr>
    <tr bgcolor=\"#FFFFFF\">
    <td valign=\"top\">
      2 - 4
    </td>
    <td valign=\"top\">
      3 Cycles
    </td>
  </tr>
  </tr>
    <tr bgcolor=\"#FFFFFF\">
    <td valign=\"top\">
      5 - 16
    </td>
    <td valign=\"top\">
      4 Cycles
    </td>
  </tr>
  </tr>
    <tr bgcolor=\"#FFFFFF\">
    <td valign=\"top\">
      17 - 32
    </td>
    <td valign=\"top\">
      5 Cycles
    </td>
  </tr>
       </table></html>"

add_display_item {} {Parameter} GROUP
add_display_item {} {Interrupt Latency Processing} GROUP
add_display_item {Interrupt Latency Processing} {Default Interrupt Latency} GROUP

add_display_item {Parameter} NUMBER_OF_INT_PORTS PARAMETER
add_display_item {Parameter} RIL_WIDTH PARAMETER
add_display_item {Parameter} DAISY_CHAIN_ENABLE PARAMETER

add_display_item {Default Interrupt Latency} "text_0" text ${NIOSII_TABLE}
add_display_item {Interrupt Latency Processing} OVERRIDE_INTERRUPT_LATENCY PARAMETER
add_display_item {Interrupt Latency Processing} INTERRUPT_LATENCY_CYCLES PARAMETER

proc compose {} {

   set num_ports [get_parameter_value NUMBER_OF_INT_PORTS]
   set ril_value [get_parameter_value RIL_WIDTH]
   set override_latency [get_parameter_value OVERRIDE_INTERRUPT_LATENCY]
   set latency_value [get_parameter_value INTERRUPT_LATENCY_CYCLES]
   set dc_enable [get_parameter_value DAISY_CHAIN_ENABLE]
   set pri_ports [expr $num_ports + $dc_enable]

   if {$pri_ports >= 2} {
      set delay_clks 1;
   }

   if {$pri_ports >= 5} {
      set delay_clks 2;
   }

   if {$pri_ports >= 17} {
      set delay_clks 3;
   }

   # determines the final priority latency value
   # valid number is 0 - 3, where
   # 0: No register          - No register at end of each compare blocks
   # 1: 1 register           - Add register at the 2nd blocks
   # 2: 2 registers			 - Add register at the 1st and 2nd compare blocks 
   # 3: 3 registers or Auto  - Add register at the 1st, 2nd, 3rd compare blocks
   if {$override_latency} {
   	   set final_priority_latency_value [ expr $latency_value - 2 ]
   	   set delay_clks $final_priority_latency_value
   } else {
   	   set final_priority_latency_value 3
   }

#  Clock Source 
   add_interface clk clock end
   add_instance clk altera_clock_bridge
   set_interface_property clk export_of clk.in_clk

   add_interface reset reset end
   add_instance reset altera_reset_bridge
   set_interface_property reset export_of reset.in_reset

   add_connection clk.out_clk reset.clk


#  CSR Block with Daisy-Chain 
   add_instance vic_csr altera_vic_csr
   set_instance_parameter vic_csr NUMBER_OF_INT_PORTS $num_ports
   set_instance_parameter vic_csr RIL_WIDTH $ril_value
   set_instance_parameter vic_csr RRS_WIDTH 6
   set_instance_parameter vic_csr DAISY_CHAIN_ENABLE $dc_enable

#  Interrupt input port
   add_interface irq_input interrupt start
   set_interface_property irq_input export_of vic_csr.i1

   add_interface csr_access avalon end
   set_interface_property csr_access export_of vic_csr.s1

   if {$dc_enable} {
      add_interface interrupt_controller_in avalon_streaming end
      set_interface_property interrupt_controller_in export_of vic_csr.dc_in
      set_interface_property interrupt_controller_in ENABLED true
   }


#  Priority Block 
   add_instance vic_priority altera_vic_priority
   set_instance_parameter vic_priority NUMBER_OF_INT_PORTS $pri_ports
   set_instance_parameter vic_priority PRIORITY_WIDTH $ril_value
   set_instance_parameter vic_priority PRIORITY_LATENCY $final_priority_latency_value
   set_instance_parameter vic_priority DATA_WIDTH 19


#  Avalon ST Delay 
   if {$dc_enable && $delay_clks > 0} {
      add_instance dc_delay altera_avalon_st_delay
      set_instance_parameter dc_delay NUMBER_OF_DELAY_CLOCKS $delay_clks
      set_instance_parameter dc_delay DATA_WIDTH 32
      set_instance_parameter dc_delay BITS_PER_SYMBOL 32
      set_instance_parameter dc_delay USE_PACKETS 0
      set_instance_parameter dc_delay USE_CHANNEL 0
      set_instance_parameter dc_delay CHANNEL_WIDTH 1
      set_instance_parameter dc_delay USE_ERROR 0
      set_instance_parameter dc_delay ERROR_WIDTH 1
   }


#  Vector Block 
   add_instance vic_vector altera_vic_vector
   set_instance_parameter vic_vector DAISY_CHAIN_ENABLE $dc_enable

   add_interface interrupt_controller_out avalon_streaming start
   set_interface_property interrupt_controller_out export_of vic_vector.out


#  Connections
   add_connection clk.out_clk     vic_csr.clk
   add_connection reset.out_reset     vic_csr.clk_reset
   add_connection clk.out_clk     vic_priority.clk
   add_connection reset.out_reset     vic_priority.clk_reset
   add_connection clk.out_clk     vic_vector.clk
   add_connection reset.out_reset     vic_vector.clk_reset

   for {set i 0} {$i < $pri_ports} {incr i} {
      add_connection vic_csr.out${i}/vic_priority.in${i}
   }

   if {$dc_enable && $delay_clks > 0} {
      add_connection vic_csr.dc_out/dc_delay.in
      add_connection dc_delay.out/vic_vector.dc
      add_connection clk.out_clk     dc_delay.clk
      add_connection reset.out_reset     dc_delay.clk_reset
   }
   
   if {$dc_enable && $delay_clks == 0} {
      add_connection vic_csr.dc_out/vic_vector.dc
   }

   add_connection vic_priority.out/vic_vector.in

   add_connection vic_csr.control/vic_vector.control
   add_connection vic_vector.status vic_csr.status
   
   if {$dc_enable} {
      # EIC port identification for BSP tools
      set_interface_assignment interrupt_controller_in \
        embeddedsw.configuration.isInterruptControllerReceiver 1
      
      set_interface_assignment interrupt_controller_out \
        embeddedsw.configuration.transportsInterruptsFromReceivers \
          interrupt_controller_in
   }
   # EIC sender port identification for BSP tools
   set_interface_assignment interrupt_controller_out \
     embeddedsw.configuration.isInterruptControllerSender 1
}

# Get the VIC parameters that software cares about and export to the software
# build flow (for system.h C macros)
proc validate {} {  
   set_module_assignment embeddedsw.CMacro.NUMBER_OF_INT_PORTS \
      [get_parameter_value NUMBER_OF_INT_PORTS]
      
   set_module_assignment embeddedsw.CMacro.RIL_WIDTH \
      [get_parameter_value RIL_WIDTH]    
   
   set_module_assignment embeddedsw.CMacro.DAISY_CHAIN_ENABLE \
     [get_parameter_value DAISY_CHAIN_ENABLE] 
     
   set override [ get_parameter_value OVERRIDE_INTERRUPT_LATENCY ]
   set int_ports [ get_parameter_value NUMBER_OF_INT_PORTS ]
   set int_latency [ get_parameter_value INTERRUPT_LATENCY_CYCLES ]
   
   set_parameter_property INTERRUPT_LATENCY_CYCLES ENABLED $override
   
   # let's validate the interrupt latency cycles per number of interrupts set
   if { $override } {
   	   if { $int_ports == 1 } {
   	   	   set max_latency 2
   	   } elseif { $int_ports > 1 && $int_ports < 5  } {
   	   	   set max_latency 3
   	   } elseif { $int_ports > 4 && $int_ports < 17  } {
   	   	   set max_latency 4
   	   } else {
   	   	   set max_latency 5
   	   }
   	   
   	   if { $int_latency > $max_latency } { 
   	   	   send_message error "Manual interrupt signal latency cannot be more than ${max_latency}"
   	   }
   	   
   }
   
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1401399659862
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
