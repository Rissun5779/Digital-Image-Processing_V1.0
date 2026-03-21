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


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# 
# altera_sld_agent_endpoint_bridge "altera_sld_agent_endpoint_bridge" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_sld_agent_endpoint_bridge
# 
set_module_property NAME altera_sld_agent_endpoint_bridge
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_sld_agent_endpoint_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_assignment debug.isTransparent true

# 
# parameters
# 
add_parameter IR_WIDTH INTEGER 2
set_parameter_property IR_WIDTH ALLOWED_RANGES {1:24}
set_parameter_property IR_WIDTH AFFECTS_ELABORATION true
set_parameter_property IR_WIDTH AFFECTS_GENERATION false
set_parameter_property IR_WIDTH HDL_PARAMETER true


# 
# display items
# 

#
# connection point clock
#
add_interface clock clock end
set_interface_property clock ENABLED true
add_interface_port clock tck clk Input 1


#
# connection point node
#
add_interface ext_node conduit start
set_interface_property ext_node associatedClock clock
set_interface_property ext_node ENABLED true
add_interface_port ext_node ext_tms tms Output 1
add_interface_port ext_node ext_tdi tdi Output 1
add_interface_port ext_node ext_tdo tdo Input 1
add_interface_port ext_node ext_ena ena Output 1
add_interface_port ext_node ext_usr1 usr1 Output 1
add_interface_port ext_node ext_clr clr Output 1
add_interface_port ext_node ext_clrn clrn Output 1
add_interface_port ext_node ext_jtag_state_tlr jtag_state_tlr Output 1
add_interface_port ext_node ext_jtag_state_rti jtag_state_rti Output 1
add_interface_port ext_node ext_jtag_state_sdrs jtag_state_sdrs Output 1
add_interface_port ext_node ext_jtag_state_cdr jtag_state_cdr Output 1
add_interface_port ext_node ext_jtag_state_sdr jtag_state_sdr Output 1
add_interface_port ext_node ext_jtag_state_e1dr jtag_state_e1dr Output 1
add_interface_port ext_node ext_jtag_state_pdr jtag_state_pdr Output 1
add_interface_port ext_node ext_jtag_state_e2dr jtag_state_e2dr Output 1
add_interface_port ext_node ext_jtag_state_udr jtag_state_udr Output 1
add_interface_port ext_node ext_jtag_state_sirs jtag_state_sirs Output 1
add_interface_port ext_node ext_jtag_state_cir jtag_state_cir Output 1
add_interface_port ext_node ext_jtag_state_sir jtag_state_sir Output 1
add_interface_port ext_node ext_jtag_state_e1ir jtag_state_e1ir Output 1
add_interface_port ext_node ext_jtag_state_pir jtag_state_pir Output 1
add_interface_port ext_node ext_jtag_state_e2ir jtag_state_e2ir Output 1
add_interface_port ext_node ext_jtag_state_uir jtag_state_uir Output 1
add_interface_port ext_node ext_ir_in ir_in Output IR_WIDTH
add_interface_port ext_node ext_irq irq Input 1
add_interface_port ext_node ext_ir_out ir_out Input IR_WIDTH

add_interface int_node conduit end
set_interface_property int_node associatedClock clock
set_interface_property int_node ENABLED true
add_interface_port int_node int_tms tms Input 1
add_interface_port int_node int_tdi tdi Input 1
add_interface_port int_node int_tdo tdo Output 1
add_interface_port int_node int_ena ena Input 1
add_interface_port int_node int_usr1 usr1 Input 1
add_interface_port int_node int_clr clr Input 1
add_interface_port int_node int_clrn clrn Input 1
add_interface_port int_node int_jtag_state_tlr jtag_state_tlr Input 1
add_interface_port int_node int_jtag_state_rti jtag_state_rti Input 1
add_interface_port int_node int_jtag_state_sdrs jtag_state_sdrs Input 1
add_interface_port int_node int_jtag_state_cdr jtag_state_cdr Input 1
add_interface_port int_node int_jtag_state_sdr jtag_state_sdr Input 1
add_interface_port int_node int_jtag_state_e1dr jtag_state_e1dr Input 1
add_interface_port int_node int_jtag_state_pdr jtag_state_pdr Input 1
add_interface_port int_node int_jtag_state_e2dr jtag_state_e2dr Input 1
add_interface_port int_node int_jtag_state_udr jtag_state_udr Input 1
add_interface_port int_node int_jtag_state_sirs jtag_state_sirs Input 1
add_interface_port int_node int_jtag_state_cir jtag_state_cir Input 1
add_interface_port int_node int_jtag_state_sir jtag_state_sir Input 1
add_interface_port int_node int_jtag_state_e1ir jtag_state_e1ir Input 1
add_interface_port int_node int_jtag_state_pir jtag_state_pir Input 1
add_interface_port int_node int_jtag_state_e2ir jtag_state_e2ir Input 1
add_interface_port int_node int_jtag_state_uir jtag_state_uir Input 1
add_interface_port int_node int_ir_in ir_in Input IR_WIDTH
add_interface_port int_node int_irq irq Output 1
add_interface_port int_node int_ir_out ir_out Output IR_WIDTH

set_interface_assignment ext_node debug.controlledBy int_node
set_port_property ext_tms driven_by int_tms
set_port_property ext_tdi driven_by int_tdi
set_port_property int_tdo driven_by ext_tdo
set_port_property ext_ena driven_by int_ena
set_port_property ext_usr1 driven_by int_usr1
set_port_property ext_clr driven_by int_clr
set_port_property ext_clrn driven_by int_clrn
set_port_property ext_jtag_state_tlr driven_by int_jtag_state_tlr
set_port_property ext_jtag_state_rti driven_by int_jtag_state_rti
set_port_property ext_jtag_state_sdrs driven_by int_jtag_state_sdrs
set_port_property ext_jtag_state_cdr driven_by int_jtag_state_cdr
set_port_property ext_jtag_state_sdr driven_by int_jtag_state_sdr
set_port_property ext_jtag_state_e1dr driven_by int_jtag_state_e1dr
set_port_property ext_jtag_state_pdr driven_by int_jtag_state_pdr
set_port_property ext_jtag_state_e2dr driven_by int_jtag_state_e2dr
set_port_property ext_jtag_state_udr driven_by int_jtag_state_udr
set_port_property ext_jtag_state_sirs driven_by int_jtag_state_sirs
set_port_property ext_jtag_state_cir driven_by int_jtag_state_cir
set_port_property ext_jtag_state_sir driven_by int_jtag_state_sir
set_port_property ext_jtag_state_e1ir driven_by int_jtag_state_e1ir
set_port_property ext_jtag_state_pir driven_by int_jtag_state_pir
set_port_property ext_jtag_state_e2ir driven_by int_jtag_state_e2ir
set_port_property ext_jtag_state_uir driven_by int_jtag_state_uir
set_port_property ext_ir_in driven_by int_ir_in
set_port_property int_irq driven_by ext_irq
set_port_property int_ir_out driven_by ext_ir_out



proc log2 x {expr {int(ceil(log($x) / log(2)))}}
