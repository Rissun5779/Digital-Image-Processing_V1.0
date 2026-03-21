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


package require -exact qsys 12.1

set_module_property DESCRIPTION "AXI/AHB bridge for network topology determination"
set_module_property NAME altera_axi_bridge
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "AXI Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property HIDE_FROM_QUARTUS true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate

set_module_assignment embeddedsw.dts.vendor "altr"
set_module_assignment embeddedsw.dts.name "bridge"
set_module_assignment embeddedsw.dts.group "bridge"
set_module_assignment embeddedsw.dts.compatible "simple-bus"

# functions
source axi_interface.tcl


###################################################################################
# Helper function to enable parameters
# Arguments:
# parameter name
###################################################################################
proc set_enable {args} {
   set param_name [lindex $args 0]

   set_parameter_property $param_name ENABLED 1
}  

proc set_disable {args} {
   set param_name [lindex $args 0]

   set_parameter_property $param_name ENABLED 0
}   

#fileset

add_fileset synthesis_fileset QUARTUS_SYNTH synth_callback_procedure
set_fileset_property synthesis_fileset TOP_LEVEL altera_axi_bridge
add_fileset simulation_fileset SIM_VERILOG synth_callback_procedure
set_fileset_property simulation_fileset TOP_LEVEL altera_axi_bridge
add_fileset vhdl_fileset SIM_VHDL synth_callback_procedure_vhdl
set_fileset_property vhdl_fileset TOP_LEVEL altera_axi_bridge

proc synth_callback_procedure { entity_name } {
    add_fileset_file altera_axi_bridge.sv SYSTEM_VERILOG PATH "altera_axi_bridge.sv"
    add_fileset_file altera_avalon_st_pipeline_base.v SYSTEM_VERILOG PATH "altera_avalon_st_pipeline_base.v"
}

proc synth_callback_procedure_vhdl { entity_name } {
   if {1} {
      add_fileset_file mentor/altera_axi_bridge.sv SYSTEM_VERILOG_ENCRYPT PATH "mentor/altera_axi_bridge.sv" {MENTOR_SPECIFIC}
      add_fileset_file mentor/altera_avalon_st_pipeline_base.v SYSTEM_VERILOG_ENCRYPT PATH "mentor/altera_avalon_st_pipeline_base.v" {MENTOR_SPECIFIC}
   }
   
   add_fileset_file altera_axi_bridge.sv SYSTEM_VERILOG_ENCRYPT PATH "altera_axi_bridge.sv" {ALDEC_SPECIFIC CADENCE_SPECIFIC SYNOPSYS_SPECIFIC}
   add_fileset_file altera_avalon_st_pipeline_base.v SYSTEM_VERILOG_ENCRYPT PATH "altera_avalon_st_pipeline_base.v" {ALDEC_SPECIFIC CADENCE_SPECIFIC SYNOPSYS_SPECIFIC}
}

add_parameter USE_PIPELINE INTEGER 0 "Insert Pipeline to bridge"
set_parameter_property USE_PIPELINE DEFAULT_VALUE 1
set_parameter_property USE_PIPELINE DISPLAY_NAME "Insert Pipeline to bridge"
set_parameter_property USE_PIPELINE WIDTH ""
set_parameter_property USE_PIPELINE TYPE INTEGER
set_parameter_property USE_PIPELINE UNITS None
set_parameter_property USE_PIPELINE DESCRIPTION "Insert Pipeline to bridge"
set_parameter_property USE_PIPELINE AFFECTS_GENERATION false
set_parameter_property USE_PIPELINE DISPLAY_HINT "boolean"
set_parameter_property USE_PIPELINE HDL_PARAMETER true
set_parameter_property USE_PIPELINE VISIBLE false

add_parameter USE_M0_AWID INTEGER 1 "Use AWID signal on Master Side Interface"
set_parameter_property USE_M0_AWID DEFAULT_VALUE 1
set_parameter_property USE_M0_AWID DISPLAY_NAME "Use AWID signal"
set_parameter_property USE_M0_AWID WIDTH ""
set_parameter_property USE_M0_AWID TYPE INTEGER
set_parameter_property USE_M0_AWID UNITS None
set_parameter_property USE_M0_AWID DESCRIPTION "Use AWID signal on Master Side Interface"
set_parameter_property USE_M0_AWID AFFECTS_GENERATION false
set_parameter_property USE_M0_AWID DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWID HDL_PARAMETER true

add_parameter USE_M0_AWREGION INTEGER 0 "Use AWREGION signal on Master Side Interface"
set_parameter_property USE_M0_AWREGION DEFAULT_VALUE 1
set_parameter_property USE_M0_AWREGION DISPLAY_NAME "Use AWREGION signal"
set_parameter_property USE_M0_AWREGION WIDTH ""
set_parameter_property USE_M0_AWREGION TYPE INTEGER
set_parameter_property USE_M0_AWREGION UNITS None
set_parameter_property USE_M0_AWREGION DESCRIPTION "Use AWREGION signal on Master Side Interface"
set_parameter_property USE_M0_AWREGION AFFECTS_GENERATION false
set_parameter_property USE_M0_AWREGION DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWREGION HDL_PARAMETER true

add_parameter USE_M0_AWLEN INTEGER 1 "Use AWLEN signal on Master Side Interface"
set_parameter_property USE_M0_AWLEN DEFAULT_VALUE 1
set_parameter_property USE_M0_AWLEN DISPLAY_NAME "Use AWLEN signal"
set_parameter_property USE_M0_AWLEN WIDTH ""
set_parameter_property USE_M0_AWLEN TYPE INTEGER
set_parameter_property USE_M0_AWLEN UNITS None
set_parameter_property USE_M0_AWLEN DESCRIPTION "Use AWLEN signal on Master Side Interface"
set_parameter_property USE_M0_AWLEN AFFECTS_GENERATION false
set_parameter_property USE_M0_AWLEN DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWLEN HDL_PARAMETER true

add_parameter USE_M0_AWSIZE INTEGER 1 "Use AWSIZE signal on Master Side Interface"
set_parameter_property USE_M0_AWSIZE DEFAULT_VALUE 1
set_parameter_property USE_M0_AWSIZE DISPLAY_NAME "Use AWSIZE signal"
set_parameter_property USE_M0_AWSIZE WIDTH ""
set_parameter_property USE_M0_AWSIZE TYPE INTEGER
set_parameter_property USE_M0_AWSIZE UNITS None
set_parameter_property USE_M0_AWSIZE DESCRIPTION "Use AWSIZE signal on Master Side Interface"
set_parameter_property USE_M0_AWSIZE AFFECTS_GENERATION false
set_parameter_property USE_M0_AWSIZE DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWSIZE HDL_PARAMETER true

add_parameter USE_M0_AWBURST INTEGER 1 "Use AWBURST signal on Master Side Interface"
set_parameter_property USE_M0_AWBURST DEFAULT_VALUE 1
set_parameter_property USE_M0_AWBURST DISPLAY_NAME "Use AWBURST signal"
set_parameter_property USE_M0_AWBURST WIDTH ""
set_parameter_property USE_M0_AWBURST TYPE INTEGER
set_parameter_property USE_M0_AWBURST UNITS None
set_parameter_property USE_M0_AWBURST DESCRIPTION "Use AWBURST signal on Master Side Interface"
set_parameter_property USE_M0_AWBURST AFFECTS_GENERATION false
set_parameter_property USE_M0_AWBURST DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWBURST HDL_PARAMETER true

add_parameter USE_M0_AWLOCK INTEGER 1 "Use AWLOCK signal on Master Side Interface"
set_parameter_property USE_M0_AWLOCK DEFAULT_VALUE 1
set_parameter_property USE_M0_AWLOCK DISPLAY_NAME "Use AWLOCK signal"
set_parameter_property USE_M0_AWLOCK WIDTH ""
set_parameter_property USE_M0_AWLOCK TYPE INTEGER
set_parameter_property USE_M0_AWLOCK UNITS None
set_parameter_property USE_M0_AWLOCK DESCRIPTION "Use AWLOCK signal on Master Side Interface"
set_parameter_property USE_M0_AWLOCK AFFECTS_GENERATION false
set_parameter_property USE_M0_AWLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWLOCK HDL_PARAMETER true

add_parameter USE_M0_AWCACHE INTEGER 1 "Use AWCACHE signal on Master Side Interface"
set_parameter_property USE_M0_AWCACHE DEFAULT_VALUE 1
set_parameter_property USE_M0_AWCACHE DISPLAY_NAME "Use AWCACHE signal"
set_parameter_property USE_M0_AWCACHE WIDTH ""
set_parameter_property USE_M0_AWCACHE TYPE INTEGER
set_parameter_property USE_M0_AWCACHE UNITS None
set_parameter_property USE_M0_AWCACHE DESCRIPTION "Use AWCACHE signal on Master Side Interface"
set_parameter_property USE_M0_AWCACHE AFFECTS_GENERATION false
set_parameter_property USE_M0_AWCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWCACHE HDL_PARAMETER true

add_parameter USE_M0_AWQOS INTEGER 1 "Use AWQOS signal on Master Side Interface"
set_parameter_property USE_M0_AWQOS DEFAULT_VALUE 1
set_parameter_property USE_M0_AWQOS DISPLAY_NAME "Use AWQOS signal"
set_parameter_property USE_M0_AWQOS WIDTH ""
set_parameter_property USE_M0_AWQOS TYPE INTEGER
set_parameter_property USE_M0_AWQOS UNITS None
set_parameter_property USE_M0_AWQOS DESCRIPTION "Use AWQOS signal on Master Side Interface"
set_parameter_property USE_M0_AWQOS AFFECTS_GENERATION false
set_parameter_property USE_M0_AWQOS DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWQOS HDL_PARAMETER true

add_parameter USE_S0_AWREGION INTEGER 1 "Use AWREGION signal on Slave Side Interface"
set_parameter_property USE_S0_AWREGION DEFAULT_VALUE 1
set_parameter_property USE_S0_AWREGION DISPLAY_NAME "Use AWREGION signal"
set_parameter_property USE_S0_AWREGION WIDTH ""
set_parameter_property USE_S0_AWREGION TYPE INTEGER
set_parameter_property USE_S0_AWREGION UNITS None
set_parameter_property USE_S0_AWREGION DESCRIPTION "Use AWREGION signal on Slave Side Interface"
set_parameter_property USE_S0_AWREGION AFFECTS_GENERATION false
set_parameter_property USE_S0_AWREGION DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWREGION HDL_PARAMETER true

add_parameter USE_S0_AWLOCK INTEGER 1 "Use AWLOCK signal on Slave Side Interface"
set_parameter_property USE_S0_AWLOCK DEFAULT_VALUE 1
set_parameter_property USE_S0_AWLOCK DISPLAY_NAME "Use AWLOCK signal"
set_parameter_property USE_S0_AWLOCK WIDTH ""
set_parameter_property USE_S0_AWLOCK TYPE INTEGER
set_parameter_property USE_S0_AWLOCK UNITS None
set_parameter_property USE_S0_AWLOCK DESCRIPTION "Use AWLOCK signal on Slave Side Interface"
set_parameter_property USE_S0_AWLOCK AFFECTS_GENERATION false
set_parameter_property USE_S0_AWLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWLOCK HDL_PARAMETER true

add_parameter USE_S0_AWCACHE INTEGER 1 "Use AWCACHE signal on Slave Side Interface"
set_parameter_property USE_S0_AWCACHE DEFAULT_VALUE 1
set_parameter_property USE_S0_AWCACHE DISPLAY_NAME "Use AWCACHE signal"
set_parameter_property USE_S0_AWCACHE WIDTH ""
set_parameter_property USE_S0_AWCACHE TYPE INTEGER
set_parameter_property USE_S0_AWCACHE UNITS None
set_parameter_property USE_S0_AWCACHE DESCRIPTION "Use AWCACHE signal on Slave Side Interface"
set_parameter_property USE_S0_AWCACHE AFFECTS_GENERATION false
set_parameter_property USE_S0_AWCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWCACHE HDL_PARAMETER true

add_parameter USE_S0_AWQOS INTEGER 1 "Use AWQOS signal on Slave Side Interface"
set_parameter_property USE_S0_AWQOS DEFAULT_VALUE 1
set_parameter_property USE_S0_AWQOS DISPLAY_NAME "Use AWQOS signal"
set_parameter_property USE_S0_AWQOS WIDTH ""
set_parameter_property USE_S0_AWQOS TYPE INTEGER
set_parameter_property USE_S0_AWQOS UNITS None
set_parameter_property USE_S0_AWQOS DESCRIPTION "Use AWQOS signal on Slave Side Interface"
set_parameter_property USE_S0_AWQOS AFFECTS_GENERATION false
set_parameter_property USE_S0_AWQOS DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWQOS HDL_PARAMETER true

add_parameter USE_S0_AWPROT INTEGER 1 "Use AWPROT signal on Slave Side Interface"
set_parameter_property USE_S0_AWPROT DEFAULT_VALUE 1
set_parameter_property USE_S0_AWPROT DISPLAY_NAME "Use AWPROT signal"
set_parameter_property USE_S0_AWPROT WIDTH ""
set_parameter_property USE_S0_AWPROT TYPE INTEGER
set_parameter_property USE_S0_AWPROT UNITS None
set_parameter_property USE_S0_AWPROT DESCRIPTION "Use AWPROT signal on Slave Side Interface"
set_parameter_property USE_S0_AWPROT AFFECTS_GENERATION false
set_parameter_property USE_S0_AWPROT DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWPROT HDL_PARAMETER true

add_parameter USE_M0_WSTRB INTEGER 1 "Use WSTRB signal on Master Side Interface"
set_parameter_property USE_M0_WSTRB DEFAULT_VALUE 1
set_parameter_property USE_M0_WSTRB DISPLAY_NAME "Use WSTRB signal"
set_parameter_property USE_M0_WSTRB WIDTH ""
set_parameter_property USE_M0_WSTRB TYPE INTEGER
set_parameter_property USE_M0_WSTRB UNITS None
set_parameter_property USE_M0_WSTRB DESCRIPTION "Use WSTRB signal on Master Side Interface"
set_parameter_property USE_M0_WSTRB AFFECTS_GENERATION false
set_parameter_property USE_M0_WSTRB DISPLAY_HINT "boolean"
set_parameter_property USE_M0_WSTRB HDL_PARAMETER true

add_parameter USE_S0_WLAST INTEGER 1 "Use WLAST signal on Slave Side Interface"
set_parameter_property USE_S0_WLAST DEFAULT_VALUE 1
set_parameter_property USE_S0_WLAST DISPLAY_NAME "Use WLAST signal"
set_parameter_property USE_S0_WLAST WIDTH ""
set_parameter_property USE_S0_WLAST TYPE INTEGER
set_parameter_property USE_S0_WLAST UNITS None
set_parameter_property USE_S0_WLAST DESCRIPTION "Use WLAST signal on Slave Side Interface"
set_parameter_property USE_S0_WLAST AFFECTS_GENERATION false
set_parameter_property USE_S0_WLAST DISPLAY_HINT "boolean"
set_parameter_property USE_S0_WLAST HDL_PARAMETER true

add_parameter USE_M0_BID INTEGER 1 "Use BID signal on Master Side Interface"
set_parameter_property USE_M0_BID DEFAULT_VALUE 1
set_parameter_property USE_M0_BID DISPLAY_NAME "Use BID signal"
set_parameter_property USE_M0_BID WIDTH ""
set_parameter_property USE_M0_BID TYPE INTEGER
set_parameter_property USE_M0_BID UNITS None
set_parameter_property USE_M0_BID DESCRIPTION "Use BID signal on Master Side Interface"
set_parameter_property USE_M0_BID AFFECTS_GENERATION false
set_parameter_property USE_M0_BID DISPLAY_HINT "boolean"
set_parameter_property USE_M0_BID HDL_PARAMETER true

add_parameter USE_M0_BRESP INTEGER 1 "Use BRESP signal on Master Side Interface"
set_parameter_property USE_M0_BRESP DEFAULT_VALUE 1
set_parameter_property USE_M0_BRESP DISPLAY_NAME "Use BRESP signal"
set_parameter_property USE_M0_BRESP WIDTH ""
set_parameter_property USE_M0_BRESP TYPE INTEGER
set_parameter_property USE_M0_BRESP UNITS None
set_parameter_property USE_M0_BRESP DESCRIPTION "Use BRESP signal on Master Side Interface"
set_parameter_property USE_M0_BRESP AFFECTS_GENERATION false
set_parameter_property USE_M0_BRESP DISPLAY_HINT "boolean"
set_parameter_property USE_M0_BRESP HDL_PARAMETER true

add_parameter USE_S0_BRESP INTEGER 1 "Use BRESP signal on Slave Side Interface"
set_parameter_property USE_S0_BRESP DEFAULT_VALUE 1
set_parameter_property USE_S0_BRESP DISPLAY_NAME "Use BRESP signal"
set_parameter_property USE_S0_BRESP WIDTH ""
set_parameter_property USE_S0_BRESP TYPE INTEGER
set_parameter_property USE_S0_BRESP UNITS None
set_parameter_property USE_S0_BRESP DESCRIPTION "Use BRESP signal on Slave Side Interface"
set_parameter_property USE_S0_BRESP AFFECTS_GENERATION false
set_parameter_property USE_S0_BRESP DISPLAY_HINT "boolean"
set_parameter_property USE_S0_BRESP HDL_PARAMETER true

add_parameter USE_M0_ARID INTEGER 1 "Use ARID signal on Master Side Interface"
set_parameter_property USE_M0_ARID DEFAULT_VALUE 1
set_parameter_property USE_M0_ARID DISPLAY_NAME "Use ARID signal"
set_parameter_property USE_M0_ARID WIDTH ""
set_parameter_property USE_M0_ARID TYPE INTEGER
set_parameter_property USE_M0_ARID UNITS None
set_parameter_property USE_M0_ARID DESCRIPTION "Use ARID signal on Master Side Interface"
set_parameter_property USE_M0_ARID AFFECTS_GENERATION false
set_parameter_property USE_M0_ARID DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARID HDL_PARAMETER true

add_parameter USE_M0_ARREGION INTEGER 1 "Use ARREGION signal on Master Side Interface"
set_parameter_property USE_M0_ARREGION DEFAULT_VALUE 1
set_parameter_property USE_M0_ARREGION DISPLAY_NAME "Use ARREGION signal"
set_parameter_property USE_M0_ARREGION WIDTH ""
set_parameter_property USE_M0_ARREGION TYPE INTEGER
set_parameter_property USE_M0_ARREGION UNITS None
set_parameter_property USE_M0_ARREGION DESCRIPTION "Use ARREGION signal on Master Side Interface"
set_parameter_property USE_M0_ARREGION AFFECTS_GENERATION false
set_parameter_property USE_M0_ARREGION DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARREGION HDL_PARAMETER true

add_parameter USE_M0_ARLEN INTEGER 1 "Use ARLEN signal on Master Side Interface"
set_parameter_property USE_M0_ARLEN DEFAULT_VALUE 1
set_parameter_property USE_M0_ARLEN DISPLAY_NAME "Use ARLEN signal"
set_parameter_property USE_M0_ARLEN WIDTH ""
set_parameter_property USE_M0_ARLEN TYPE INTEGER
set_parameter_property USE_M0_ARLEN UNITS None
set_parameter_property USE_M0_ARLEN DESCRIPTION "Use ARLEN signal on Master Side Interface"
set_parameter_property USE_M0_ARLEN AFFECTS_GENERATION false
set_parameter_property USE_M0_ARLEN DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARLEN HDL_PARAMETER true

add_parameter USE_M0_ARSIZE INTEGER 1 "Use ARSIZE signal on Master Side Interface"
set_parameter_property USE_M0_ARSIZE DEFAULT_VALUE 1
set_parameter_property USE_M0_ARSIZE DISPLAY_NAME "Use ARSIZE signal"
set_parameter_property USE_M0_ARSIZE WIDTH ""
set_parameter_property USE_M0_ARSIZE TYPE INTEGER
set_parameter_property USE_M0_ARSIZE UNITS None
set_parameter_property USE_M0_ARSIZE DESCRIPTION "Use ARSIZE signal on Master Side Interface"
set_parameter_property USE_M0_ARSIZE AFFECTS_GENERATION false
set_parameter_property USE_M0_ARSIZE DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARSIZE HDL_PARAMETER true

add_parameter USE_M0_ARBURST INTEGER 1 "Use ARBURST signal on Master Side Interface"
set_parameter_property USE_M0_ARBURST DEFAULT_VALUE 1
set_parameter_property USE_M0_ARBURST DISPLAY_NAME "Use ARBURST signal"
set_parameter_property USE_M0_ARBURST WIDTH ""
set_parameter_property USE_M0_ARBURST TYPE INTEGER
set_parameter_property USE_M0_ARBURST UNITS None
set_parameter_property USE_M0_ARBURST DESCRIPTION "Use ARBURST signal on Master Side Interface"
set_parameter_property USE_M0_ARBURST AFFECTS_GENERATION false
set_parameter_property USE_M0_ARBURST DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARBURST HDL_PARAMETER true

add_parameter USE_M0_ARLOCK INTEGER 1 "Use ARLOCK signal on Master Side Interface"
set_parameter_property USE_M0_ARLOCK DEFAULT_VALUE 1
set_parameter_property USE_M0_ARLOCK DISPLAY_NAME "Use ARLOCK signal"
set_parameter_property USE_M0_ARLOCK WIDTH ""
set_parameter_property USE_M0_ARLOCK TYPE INTEGER
set_parameter_property USE_M0_ARLOCK UNITS None
set_parameter_property USE_M0_ARLOCK DESCRIPTION "Use ARLOCK signal on Master Side Interface"
set_parameter_property USE_M0_ARLOCK AFFECTS_GENERATION false
set_parameter_property USE_M0_ARLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARLOCK HDL_PARAMETER true

add_parameter USE_M0_ARCACHE INTEGER 1 "Use ARCACHE signal on Master Side Interface"
set_parameter_property USE_M0_ARCACHE DEFAULT_VALUE 1
set_parameter_property USE_M0_ARCACHE DISPLAY_NAME "Use ARCACHE signal"
set_parameter_property USE_M0_ARCACHE WIDTH ""
set_parameter_property USE_M0_ARCACHE TYPE INTEGER
set_parameter_property USE_M0_ARCACHE UNITS None
set_parameter_property USE_M0_ARCACHE DESCRIPTION "Use ARCACHE signal on Master Side Interface"
set_parameter_property USE_M0_ARCACHE AFFECTS_GENERATION false
set_parameter_property USE_M0_ARCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARCACHE HDL_PARAMETER true

add_parameter USE_M0_ARQOS INTEGER 1 "Use ARQOS signal on Master Side Interface"
set_parameter_property USE_M0_ARQOS DEFAULT_VALUE 1
set_parameter_property USE_M0_ARQOS DISPLAY_NAME "Use ARQOS signal"
set_parameter_property USE_M0_ARQOS WIDTH ""
set_parameter_property USE_M0_ARQOS TYPE INTEGER
set_parameter_property USE_M0_ARQOS UNITS None
set_parameter_property USE_M0_ARQOS DESCRIPTION "Use ARQOS signal on Master Side Interface"
set_parameter_property USE_M0_ARQOS AFFECTS_GENERATION false
set_parameter_property USE_M0_ARQOS DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARQOS HDL_PARAMETER true

add_parameter USE_S0_ARREGION INTEGER 1 "Use ARREGION signal on Slave Side Interface"
set_parameter_property USE_S0_ARREGION DEFAULT_VALUE 1
set_parameter_property USE_S0_ARREGION DISPLAY_NAME "Use ARREGION signal"
set_parameter_property USE_S0_ARREGION WIDTH ""
set_parameter_property USE_S0_ARREGION TYPE INTEGER
set_parameter_property USE_S0_ARREGION UNITS None
set_parameter_property USE_S0_ARREGION DESCRIPTION "Use ARREGION signal on Slave Side Interface"
set_parameter_property USE_S0_ARREGION AFFECTS_GENERATION false
set_parameter_property USE_S0_ARREGION DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARREGION HDL_PARAMETER true

add_parameter USE_S0_ARLOCK INTEGER 1 "Use ARLOCK signal on Slave Side Interface"
set_parameter_property USE_S0_ARLOCK DEFAULT_VALUE 1
set_parameter_property USE_S0_ARLOCK DISPLAY_NAME "Use ARLOCK signal"
set_parameter_property USE_S0_ARLOCK WIDTH ""
set_parameter_property USE_S0_ARLOCK TYPE INTEGER
set_parameter_property USE_S0_ARLOCK UNITS None
set_parameter_property USE_S0_ARLOCK DESCRIPTION "Use ARLOCK signal on Slave Side Interface"
set_parameter_property USE_S0_ARLOCK AFFECTS_GENERATION false
set_parameter_property USE_S0_ARLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARLOCK HDL_PARAMETER true

add_parameter USE_S0_ARCACHE INTEGER 1 "Use ARCACHE signal on Slave Side Interface"
set_parameter_property USE_S0_ARCACHE DEFAULT_VALUE 1
set_parameter_property USE_S0_ARCACHE DISPLAY_NAME "Use ARCACHE signal"
set_parameter_property USE_S0_ARCACHE WIDTH ""
set_parameter_property USE_S0_ARCACHE TYPE INTEGER
set_parameter_property USE_S0_ARCACHE UNITS None
set_parameter_property USE_S0_ARCACHE DESCRIPTION "Use ARCACHE signal on Slave Side Interface"
set_parameter_property USE_S0_ARCACHE AFFECTS_GENERATION false
set_parameter_property USE_S0_ARCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARCACHE HDL_PARAMETER true

add_parameter USE_S0_ARQOS INTEGER 1 "Use ARQOS signal on Slave Side Interface"
set_parameter_property USE_S0_ARQOS DEFAULT_VALUE 1
set_parameter_property USE_S0_ARQOS DISPLAY_NAME "Use ARQOS signal"
set_parameter_property USE_S0_ARQOS WIDTH ""
set_parameter_property USE_S0_ARQOS TYPE INTEGER
set_parameter_property USE_S0_ARQOS UNITS None
set_parameter_property USE_S0_ARQOS DESCRIPTION "Use ARQOS signal on Slave Side Interface"
set_parameter_property USE_S0_ARQOS AFFECTS_GENERATION false
set_parameter_property USE_S0_ARQOS DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARQOS HDL_PARAMETER true

add_parameter USE_S0_ARPROT INTEGER 1 "Use ARPROT signal on Slave Side Interface"
set_parameter_property USE_S0_ARPROT DEFAULT_VALUE 1
set_parameter_property USE_S0_ARPROT DISPLAY_NAME "Use ARPROT signal"
set_parameter_property USE_S0_ARPROT WIDTH ""
set_parameter_property USE_S0_ARPROT TYPE INTEGER
set_parameter_property USE_S0_ARPROT UNITS None
set_parameter_property USE_S0_ARPROT DESCRIPTION "Use ARPROT signal on Slave Side Interface"
set_parameter_property USE_S0_ARPROT AFFECTS_GENERATION false
set_parameter_property USE_S0_ARPROT DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARPROT HDL_PARAMETER true

add_parameter USE_M0_RID INTEGER 1 "Use RID signal on Master Side Interface"
set_parameter_property USE_M0_RID DEFAULT_VALUE 1
set_parameter_property USE_M0_RID DISPLAY_NAME "Use RID signal"
set_parameter_property USE_M0_RID WIDTH ""
set_parameter_property USE_M0_RID TYPE INTEGER
set_parameter_property USE_M0_RID UNITS None
set_parameter_property USE_M0_RID DESCRIPTION "Use RID signal on Master Side Interface"
set_parameter_property USE_M0_RID AFFECTS_GENERATION false
set_parameter_property USE_M0_RID DISPLAY_HINT "boolean"
set_parameter_property USE_M0_RID HDL_PARAMETER true

add_parameter USE_M0_RRESP INTEGER 1 "Use RRESP signal on Master Side Interface"
set_parameter_property USE_M0_RRESP DEFAULT_VALUE 1
set_parameter_property USE_M0_RRESP DISPLAY_NAME "Use RRESP signal"
set_parameter_property USE_M0_RRESP WIDTH ""
set_parameter_property USE_M0_RRESP TYPE INTEGER
set_parameter_property USE_M0_RRESP UNITS None
set_parameter_property USE_M0_RRESP DESCRIPTION "Use RRESP signal on Master Side Interface"
set_parameter_property USE_M0_RRESP AFFECTS_GENERATION false
set_parameter_property USE_M0_RRESP DISPLAY_HINT "boolean"
set_parameter_property USE_M0_RRESP HDL_PARAMETER true

add_parameter USE_M0_RLAST INTEGER 1 "Use RLAST signal on Master Side Interface"
set_parameter_property USE_M0_RLAST DEFAULT_VALUE 1
set_parameter_property USE_M0_RLAST DISPLAY_NAME "Use RLAST signal"
set_parameter_property USE_M0_RLAST WIDTH ""
set_parameter_property USE_M0_RLAST TYPE INTEGER
set_parameter_property USE_M0_RLAST UNITS None
set_parameter_property USE_M0_RLAST DESCRIPTION "Use RLAST signal on Master Side Interface"
set_parameter_property USE_M0_RLAST AFFECTS_GENERATION false
set_parameter_property USE_M0_RLAST DISPLAY_HINT "boolean"
set_parameter_property USE_M0_RLAST HDL_PARAMETER true

add_parameter USE_S0_RRESP INTEGER 1 "Use RRESP signal on Slave Side Interface"
set_parameter_property USE_S0_RRESP DEFAULT_VALUE 1
set_parameter_property USE_S0_RRESP DISPLAY_NAME "Use RRESP signal"
set_parameter_property USE_S0_RRESP WIDTH ""
set_parameter_property USE_S0_RRESP TYPE INTEGER
set_parameter_property USE_S0_RRESP UNITS None
set_parameter_property USE_S0_RRESP DESCRIPTION "Use RRESP signal on Slave Side Interface"
set_parameter_property USE_S0_RRESP AFFECTS_GENERATION false
set_parameter_property USE_S0_RRESP DISPLAY_HINT "boolean"
set_parameter_property USE_S0_RRESP HDL_PARAMETER true

add_parameter M0_ID_WIDTH INTEGER 8 "ID Width on Master Side Interface"
set_parameter_property M0_ID_WIDTH DEFAULT_VALUE 8
set_parameter_property M0_ID_WIDTH DISPLAY_NAME "ID Width"
set_parameter_property M0_ID_WIDTH WIDTH ""
set_parameter_property M0_ID_WIDTH TYPE INTEGER
set_parameter_property M0_ID_WIDTH UNITS None
set_parameter_property M0_ID_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M0_ID_WIDTH DESCRIPTION "ID Width on Master Side Interface"
set_parameter_property M0_ID_WIDTH AFFECTS_GENERATION false
set_parameter_property M0_ID_WIDTH HDL_PARAMETER true

add_parameter S0_ID_WIDTH INTEGER 8 "ID Width on Slave Side Interface"
set_parameter_property S0_ID_WIDTH DEFAULT_VALUE 8
set_parameter_property S0_ID_WIDTH DISPLAY_NAME "ID Width"
set_parameter_property S0_ID_WIDTH TYPE INTEGER
set_parameter_property S0_ID_WIDTH UNITS None
set_parameter_property S0_ID_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S0_ID_WIDTH DESCRIPTION "ID Width on Slave Side Interface"
set_parameter_property S0_ID_WIDTH AFFECTS_GENERATION false
set_parameter_property S0_ID_WIDTH HDL_PARAMETER true      

add_parameter DATA_WIDTH INTEGER 32 "Bridge Data Width"
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH WIDTH ""
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DESCRIPTION "Bridge Data Width"
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter WRITE_ADDR_USER_WIDTH INTEGER 64 "AWUSER Width"
set_parameter_property WRITE_ADDR_USER_WIDTH DEFAULT_VALUE 64
set_parameter_property WRITE_ADDR_USER_WIDTH DISPLAY_NAME "AWUSER Width"
set_parameter_property WRITE_ADDR_USER_WIDTH TYPE INTEGER
set_parameter_property WRITE_ADDR_USER_WIDTH UNITS None
set_parameter_property WRITE_ADDR_USER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WRITE_ADDR_USER_WIDTH DESCRIPTION "AWUSER Width"
set_parameter_property WRITE_ADDR_USER_WIDTH AFFECTS_GENERATION false
set_parameter_property WRITE_ADDR_USER_WIDTH HDL_PARAMETER true

add_parameter READ_ADDR_USER_WIDTH INTEGER 64 "ARUSER Width"
set_parameter_property READ_ADDR_USER_WIDTH DEFAULT_VALUE 64
set_parameter_property READ_ADDR_USER_WIDTH DISPLAY_NAME "ARUSER Width"
set_parameter_property READ_ADDR_USER_WIDTH TYPE INTEGER
set_parameter_property READ_ADDR_USER_WIDTH UNITS None
set_parameter_property READ_ADDR_USER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property READ_ADDR_USER_WIDTH DESCRIPTION "ARUSER Width"
set_parameter_property READ_ADDR_USER_WIDTH AFFECTS_GENERATION false
set_parameter_property READ_ADDR_USER_WIDTH HDL_PARAMETER true

add_parameter WRITE_DATA_USER_WIDTH INTEGER 64 "WUSER Width"
set_parameter_property WRITE_DATA_USER_WIDTH DEFAULT_VALUE 64
set_parameter_property WRITE_DATA_USER_WIDTH DISPLAY_NAME "WUSER Width"
set_parameter_property WRITE_DATA_USER_WIDTH TYPE INTEGER
set_parameter_property WRITE_DATA_USER_WIDTH UNITS None
set_parameter_property WRITE_DATA_USER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WRITE_DATA_USER_WIDTH DESCRIPTION "WUSER Width"
set_parameter_property WRITE_DATA_USER_WIDTH AFFECTS_GENERATION false
set_parameter_property WRITE_DATA_USER_WIDTH HDL_PARAMETER true

add_parameter WRITE_RESP_USER_WIDTH INTEGER 64 "BUSER Width"
set_parameter_property WRITE_RESP_USER_WIDTH DEFAULT_VALUE 64
set_parameter_property WRITE_RESP_USER_WIDTH DISPLAY_NAME "BUSER Width"
set_parameter_property WRITE_RESP_USER_WIDTH TYPE INTEGER
set_parameter_property WRITE_RESP_USER_WIDTH UNITS None
set_parameter_property WRITE_RESP_USER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WRITE_RESP_USER_WIDTH DESCRIPTION "BUSER Width"
set_parameter_property WRITE_RESP_USER_WIDTH AFFECTS_GENERATION false
set_parameter_property WRITE_RESP_USER_WIDTH HDL_PARAMETER true

add_parameter READ_DATA_USER_WIDTH INTEGER 64 "RUSER Width"
set_parameter_property READ_DATA_USER_WIDTH DEFAULT_VALUE 64
set_parameter_property READ_DATA_USER_WIDTH DISPLAY_NAME "RUSER Width"
set_parameter_property READ_DATA_USER_WIDTH TYPE INTEGER
set_parameter_property READ_DATA_USER_WIDTH UNITS None
set_parameter_property READ_DATA_USER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property READ_DATA_USER_WIDTH DESCRIPTION "RUSER Width"
set_parameter_property READ_DATA_USER_WIDTH AFFECTS_GENERATION false
set_parameter_property READ_DATA_USER_WIDTH HDL_PARAMETER true

add_parameter ADDR_WIDTH INTEGER 11 "Address Width"
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 11
set_parameter_property ADDR_WIDTH DISPLAY_NAME "Address Width"
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_WIDTH DESCRIPTION "Bridge Address Width"
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter USE_S0_AWUSER INTEGER 0 "Use AWUSER signal on Slave Side Interface"
set_parameter_property USE_S0_AWUSER DEFAULT_VALUE 0
set_parameter_property USE_S0_AWUSER DISPLAY_NAME "Use AWUSER signal"
set_parameter_property USE_S0_AWUSER WIDTH ""
set_parameter_property USE_S0_AWUSER TYPE INTEGER
set_parameter_property USE_S0_AWUSER UNITS None
set_parameter_property USE_S0_AWUSER DESCRIPTION "Use AWUSER signal on Slave Side Interface"
set_parameter_property USE_S0_AWUSER AFFECTS_GENERATION false
set_parameter_property USE_S0_AWUSER DISPLAY_HINT "boolean"
set_parameter_property USE_S0_AWUSER HDL_PARAMETER true

add_parameter USE_S0_ARUSER INTEGER 0 "Use ARUSER signal on Slave Side Interface"
set_parameter_property USE_S0_ARUSER DEFAULT_VALUE 0
set_parameter_property USE_S0_ARUSER DISPLAY_NAME "Use ARUSER signal"
set_parameter_property USE_S0_ARUSER WIDTH ""
set_parameter_property USE_S0_ARUSER TYPE INTEGER
set_parameter_property USE_S0_ARUSER UNITS None
set_parameter_property USE_S0_ARUSER DESCRIPTION "Use ARUSER signal on Slave Side Interface"
set_parameter_property USE_S0_ARUSER AFFECTS_GENERATION false
set_parameter_property USE_S0_ARUSER DISPLAY_HINT "boolean"
set_parameter_property USE_S0_ARUSER HDL_PARAMETER true

add_parameter USE_S0_WUSER INTEGER 0 "Use WUSER signal on Slave Side Interface"
set_parameter_property USE_S0_WUSER DEFAULT_VALUE 0
set_parameter_property USE_S0_WUSER DISPLAY_NAME "Use WUSER signal"
set_parameter_property USE_S0_WUSER WIDTH ""
set_parameter_property USE_S0_WUSER TYPE INTEGER
set_parameter_property USE_S0_WUSER UNITS None
set_parameter_property USE_S0_WUSER DESCRIPTION "Use WUSER signal on Slave Side Interface"
set_parameter_property USE_S0_WUSER AFFECTS_GENERATION false
set_parameter_property USE_S0_WUSER DISPLAY_HINT "boolean"
set_parameter_property USE_S0_WUSER HDL_PARAMETER true

add_parameter USE_S0_RUSER INTEGER 0 "Use RUSER signal on Slave Side Interface"
set_parameter_property USE_S0_RUSER DEFAULT_VALUE 0
set_parameter_property USE_S0_RUSER DISPLAY_NAME "Use RUSER signal"
set_parameter_property USE_S0_RUSER WIDTH ""
set_parameter_property USE_S0_RUSER TYPE INTEGER
set_parameter_property USE_S0_RUSER UNITS None
set_parameter_property USE_S0_RUSER DESCRIPTION "Use RUSER signal on Slave Side Interface"
set_parameter_property USE_S0_RUSER AFFECTS_GENERATION false
set_parameter_property USE_S0_RUSER DISPLAY_HINT "boolean"
set_parameter_property USE_S0_RUSER HDL_PARAMETER true

add_parameter USE_S0_BUSER INTEGER 0 "Use BUSER signal on Slave Side Interface"
set_parameter_property USE_S0_BUSER DEFAULT_VALUE 0
set_parameter_property USE_S0_BUSER DISPLAY_NAME "Use BUSER signal"
set_parameter_property USE_S0_BUSER WIDTH ""
set_parameter_property USE_S0_BUSER TYPE INTEGER
set_parameter_property USE_S0_BUSER UNITS None
set_parameter_property USE_S0_BUSER DESCRIPTION "Use BUSER signal on Slave Side Interface"
set_parameter_property USE_S0_BUSER AFFECTS_GENERATION false
set_parameter_property USE_S0_BUSER DISPLAY_HINT "boolean"
set_parameter_property USE_S0_BUSER HDL_PARAMETER true

add_parameter USE_M0_AWUSER INTEGER 0 "Use AWUSER signal on Master Side Interface"
set_parameter_property USE_M0_AWUSER DEFAULT_VALUE 0
set_parameter_property USE_M0_AWUSER DISPLAY_NAME "Use AWUSER signal"
set_parameter_property USE_M0_AWUSER WIDTH ""
set_parameter_property USE_M0_AWUSER TYPE INTEGER
set_parameter_property USE_M0_AWUSER UNITS None
set_parameter_property USE_M0_AWUSER DESCRIPTION "Use AWUSER signal on Master Side Interface"
set_parameter_property USE_M0_AWUSER AFFECTS_GENERATION false
set_parameter_property USE_M0_AWUSER DISPLAY_HINT "boolean"
set_parameter_property USE_M0_AWUSER HDL_PARAMETER true

add_parameter USE_M0_ARUSER INTEGER 0 "Use ARUSER signal on Master Side Interface"
set_parameter_property USE_M0_ARUSER DEFAULT_VALUE 0
set_parameter_property USE_M0_ARUSER DISPLAY_NAME "Use ARUSER signal"
set_parameter_property USE_M0_ARUSER WIDTH ""
set_parameter_property USE_M0_ARUSER TYPE INTEGER
set_parameter_property USE_M0_ARUSER UNITS None
set_parameter_property USE_M0_ARUSER DESCRIPTION "Use ARUSER signal on Master Side Interface"
set_parameter_property USE_M0_ARUSER AFFECTS_GENERATION false
set_parameter_property USE_M0_ARUSER DISPLAY_HINT "boolean"
set_parameter_property USE_M0_ARUSER HDL_PARAMETER true


add_parameter USE_M0_WUSER INTEGER 0 "Use WUSER signal on Master Side Interface"
set_parameter_property USE_M0_WUSER DEFAULT_VALUE 0
set_parameter_property USE_M0_WUSER DISPLAY_NAME "Use WUSER signal"
set_parameter_property USE_M0_WUSER WIDTH ""
set_parameter_property USE_M0_WUSER TYPE INTEGER
set_parameter_property USE_M0_WUSER UNITS None
set_parameter_property USE_M0_WUSER DESCRIPTION "Use WUSER signal on Master Side Interface"
set_parameter_property USE_M0_WUSER AFFECTS_GENERATION false
set_parameter_property USE_M0_WUSER DISPLAY_HINT "boolean"
set_parameter_property USE_M0_WUSER HDL_PARAMETER true

add_parameter USE_M0_RUSER INTEGER 0 "Use RUSER signal on Master Side Interface"
set_parameter_property USE_M0_RUSER DEFAULT_VALUE 0
set_parameter_property USE_M0_RUSER DISPLAY_NAME "Use RUSER signal"
set_parameter_property USE_M0_RUSER WIDTH ""
set_parameter_property USE_M0_RUSER TYPE INTEGER
set_parameter_property USE_M0_RUSER UNITS None
set_parameter_property USE_M0_RUSER DESCRIPTION "Use RUSER signal on Master Side Interface"
set_parameter_property USE_M0_RUSER AFFECTS_GENERATION false
set_parameter_property USE_M0_RUSER DISPLAY_HINT "boolean"
set_parameter_property USE_M0_RUSER HDL_PARAMETER true

add_parameter USE_M0_BUSER INTEGER 0 "Use BUSER signal on Master Side Interface"
set_parameter_property USE_M0_BUSER DEFAULT_VALUE 0
set_parameter_property USE_M0_BUSER DISPLAY_NAME "Use BUSER signal"
set_parameter_property USE_M0_BUSER WIDTH ""
set_parameter_property USE_M0_BUSER TYPE INTEGER
set_parameter_property USE_M0_BUSER UNITS None
set_parameter_property USE_M0_BUSER DESCRIPTION "Use BUSER signal on Master Side Interface"
set_parameter_property USE_M0_BUSER AFFECTS_GENERATION false
set_parameter_property USE_M0_BUSER DISPLAY_HINT "boolean"
set_parameter_property USE_M0_BUSER HDL_PARAMETER true

add_parameter AXI_VERSION STRING "AXI3" "AXI Version"
set_parameter_property AXI_VERSION DEFAULT_VALUE "AXI3"
set_parameter_property AXI_VERSION DISPLAY_NAME "AXI Version"
set_parameter_property AXI_VERSION DESCRIPTION "AXI Version"
set_parameter_property AXI_VERSION ALLOWED_RANGES "AXI3,AXI4"
set_parameter_property AXI_VERSION AFFECTS_GENERATION false
set_parameter_property AXI_VERSION HDL_PARAMETER true

add_parameter BURST_LENGTH_WIDTH INTEGER 4 "Burst Length Width"
set_parameter_property BURST_LENGTH_WIDTH DISPLAY_NAME "Burst Length Width"
set_parameter_property BURST_LENGTH_WIDTH TYPE INTEGER
set_parameter_property BURST_LENGTH_WIDTH DERIVED true
set_parameter_property BURST_LENGTH_WIDTH UNITS None
set_parameter_property BURST_LENGTH_WIDTH ENABLED true
set_parameter_property BURST_LENGTH_WIDTH DESCRIPTION "Burst Length Width"
set_parameter_property BURST_LENGTH_WIDTH AFFECTS_ELABORATION true
set_parameter_property BURST_LENGTH_WIDTH HDL_PARAMETER true
set_parameter_property BURST_LENGTH_WIDTH ALLOWED_RANGES 4:8
set_parameter_property BURST_LENGTH_WIDTH VISIBLE false

add_parameter LOCK_WIDTH INTEGER 2 "Lock Width"
set_parameter_property LOCK_WIDTH DISPLAY_NAME "Lock Width"
set_parameter_property LOCK_WIDTH TYPE INTEGER
set_parameter_property LOCK_WIDTH DERIVED true
set_parameter_property LOCK_WIDTH UNITS None
set_parameter_property LOCK_WIDTH ENABLED true
set_parameter_property LOCK_WIDTH DESCRIPTION "Lock Width"
set_parameter_property LOCK_WIDTH AFFECTS_ELABORATION true
set_parameter_property LOCK_WIDTH HDL_PARAMETER true
set_parameter_property LOCK_WIDTH ALLOWED_RANGES 1:2
set_parameter_property LOCK_WIDTH VISIBLE false

add_parameter WRITE_ISSUING_CAPABILITY INTEGER 16 "Write Issuing Capability"
set_parameter_property WRITE_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property WRITE_ISSUING_CAPABILITY DISPLAY_NAME "Write Issuing Capability"
set_parameter_property WRITE_ISSUING_CAPABILITY WIDTH ""
set_parameter_property WRITE_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property WRITE_ISSUING_CAPABILITY UNITS None
set_parameter_property WRITE_ISSUING_CAPABILITY DESCRIPTION "Write Issuing Capability"
set_parameter_property WRITE_ISSUING_CAPABILITY AFFECTS_GENERATION false
set_parameter_property WRITE_ISSUING_CAPABILITY HDL_PARAMETER false

add_parameter READ_ISSUING_CAPABILITY INTEGER 16 "Read Issuing Capability"
set_parameter_property READ_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property READ_ISSUING_CAPABILITY DISPLAY_NAME "Read Issuing Capability"
set_parameter_property READ_ISSUING_CAPABILITY WIDTH ""
set_parameter_property READ_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property READ_ISSUING_CAPABILITY UNITS None
set_parameter_property READ_ISSUING_CAPABILITY DESCRIPTION "Read Issuing Capability"
set_parameter_property READ_ISSUING_CAPABILITY AFFECTS_GENERATION false
set_parameter_property READ_ISSUING_CAPABILITY HDL_PARAMETER false

add_parameter COMBINED_ISSUING_CAPABILITY INTEGER 16 "Combined Issuing Capability"
set_parameter_property COMBINED_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property COMBINED_ISSUING_CAPABILITY DISPLAY_NAME "Combined Issuing Capability"
set_parameter_property COMBINED_ISSUING_CAPABILITY WIDTH ""
set_parameter_property COMBINED_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property COMBINED_ISSUING_CAPABILITY UNITS None
set_parameter_property COMBINED_ISSUING_CAPABILITY DESCRIPTION "Combined Issuing Capability"
set_parameter_property COMBINED_ISSUING_CAPABILITY AFFECTS_GENERATION false
set_parameter_property COMBINED_ISSUING_CAPABILITY HDL_PARAMETER false

add_parameter WRITE_ACCEPTANCE_CAPABILITY INTEGER 16 "Write Acceptance Capability"
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DISPLAY_NAME "Write Acceptance Capability"
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY WIDTH ""
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DESCRIPTION "Write Acceptance Capability"
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY AFFECTS_GENERATION false
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY HDL_PARAMETER false

add_parameter READ_ACCEPTANCE_CAPABILITY INTEGER 16 "Read Acceptance Capability"
set_parameter_property READ_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property READ_ACCEPTANCE_CAPABILITY DISPLAY_NAME "Read Acceptance Capability"
set_parameter_property READ_ACCEPTANCE_CAPABILITY WIDTH ""
set_parameter_property READ_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property READ_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property READ_ACCEPTANCE_CAPABILITY DESCRIPTION "Read Acceptance Capability"
set_parameter_property READ_ACCEPTANCE_CAPABILITY AFFECTS_GENERATION false
set_parameter_property READ_ACCEPTANCE_CAPABILITY HDL_PARAMETER false

add_parameter COMBINED_ACCEPTANCE_CAPABILITY INTEGER 16 "Combined Acceptance Capability"
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DISPLAY_NAME "Combined Acceptance Capability"
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY WIDTH ""
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DESCRIPTION "Combined Acceptance Capability"
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY AFFECTS_GENERATION false
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY HDL_PARAMETER false

add_parameter READ_DATA_REORDERING_DEPTH INTEGER 1 "Read Data Reordering Depth"
set_parameter_property READ_DATA_REORDERING_DEPTH DEFAULT_VALUE 1
set_parameter_property READ_DATA_REORDERING_DEPTH DISPLAY_NAME "Read Data Reordering Depth"
set_parameter_property READ_DATA_REORDERING_DEPTH WIDTH ""
set_parameter_property READ_DATA_REORDERING_DEPTH TYPE INTEGER
set_parameter_property READ_DATA_REORDERING_DEPTH UNITS None
set_parameter_property READ_DATA_REORDERING_DEPTH DESCRIPTION "Read Data Reordering Depth"
set_parameter_property READ_DATA_REORDERING_DEPTH AFFECTS_GENERATION false
set_parameter_property READ_DATA_REORDERING_DEPTH HDL_PARAMETER false
set_parameter_property READ_DATA_REORDERING_DEPTH VISIBLE false

source axi_gui.tcl

#
# connection point clk
#
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true

add_interface_port clk aclk clk Input 1
#
# connection point reset_sink
#
add_interface clk_reset reset end
set_interface_property clk_reset associatedClock clk
set_interface_property clk_reset synchronousEdges DEASSERT
set_interface_property clk_reset ENABLED true

add_interface_port clk_reset aresetn reset_n Input 1

proc elaborate {} {
    # Read all parameters
    # general parameters
    set axi3_slave                         [ get_parameter_value AXI_VERSION ]
    set axi3_master                        [ get_parameter_value AXI_VERSION ]
    set m0_id_width                        [ get_parameter_value M0_ID_WIDTH ]
    set s0_id_width                        [ get_parameter_value S0_ID_WIDTH ]
    set addr_width                         [ get_parameter_value ADDR_WIDTH ]
    set data_width                         [ get_parameter_value DATA_WIDTH ]
    set wstrb_width                        [ expr [ get_parameter_value DATA_WIDTH ] / 8 ]
    
    # sideband signal parameters
    set use_s0_wuser                       [ get_parameter_value USE_S0_WUSER ]
    set use_s0_buser                       [ get_parameter_value USE_S0_BUSER ]
    set use_s0_ruser                       [ get_parameter_value USE_S0_RUSER ]
    set use_s0_awuser                      [ get_parameter_value USE_S0_AWUSER ]
    set use_s0_aruser                      [ get_parameter_value USE_S0_ARUSER ]
    set use_m0_wuser                       [ get_parameter_value USE_M0_WUSER ]
    set use_m0_ruser                       [ get_parameter_value USE_M0_RUSER ]
    set use_m0_buser                       [ get_parameter_value USE_M0_BUSER ]
    set use_m0_awuser                      [ get_parameter_value USE_M0_AWUSER ]
    set use_m0_aruser                      [ get_parameter_value USE_M0_ARUSER ]
    set write_addr_user_width              [ get_parameter_value WRITE_ADDR_USER_WIDTH ]
    set read_addr_user_width               [ get_parameter_value READ_ADDR_USER_WIDTH ]
    set write_data_user_width              [ get_parameter_value WRITE_DATA_USER_WIDTH ]
    set read_data_user_width               [ get_parameter_value READ_DATA_USER_WIDTH ]
    set write_resp_user_width              [ get_parameter_value WRITE_RESP_USER_WIDTH ]
    # Read write address channel parameters
    set use_m0_awid      [ get_parameter_value USE_M0_AWID ]
    set use_m0_awregion  [ get_parameter_value USE_M0_AWREGION ]
    set use_m0_awlen     [ get_parameter_value USE_M0_AWLEN ]
    set use_m0_awsize    [ get_parameter_value USE_M0_AWSIZE ]
    set use_m0_awburst   [ get_parameter_value USE_M0_AWBURST ]
    set use_m0_awlock    [ get_parameter_value USE_M0_AWLOCK ]
    set use_m0_awcache   [ get_parameter_value USE_M0_AWCACHE ]
    set use_m0_awqos     [ get_parameter_value USE_M0_AWQOS ]
    # Slave side
    set use_s0_awregion  [ get_parameter_value USE_S0_AWREGION ]
    set use_s0_awlock    [ get_parameter_value USE_S0_AWLOCK ]
    set use_s0_awcache   [ get_parameter_value USE_S0_AWCACHE ]
    set use_s0_awprot    [ get_parameter_value USE_S0_AWPROT ]
    set use_s0_awqos     [ get_parameter_value USE_S0_AWQOS ]
    # Read read address channel parameters
    set use_m0_arid      [ get_parameter_value USE_M0_ARID ]
    set use_m0_arregion  [ get_parameter_value USE_M0_ARREGION ]
    set use_m0_arlen     [ get_parameter_value USE_M0_ARLEN ]
    set use_m0_arsize    [ get_parameter_value USE_M0_ARSIZE ]
    set use_m0_arburst   [ get_parameter_value USE_M0_ARBURST ]
    set use_m0_arlock    [ get_parameter_value USE_M0_ARLOCK ]
    set use_m0_arcache   [ get_parameter_value USE_M0_ARCACHE ]
    set use_m0_arqos     [ get_parameter_value USE_M0_ARQOS ]
    # Slave side
    set use_s0_arregion  [ get_parameter_value USE_S0_ARREGION ]
    set use_s0_arlock    [ get_parameter_value USE_S0_ARLOCK ]
    set use_s0_arcache   [ get_parameter_value USE_S0_ARCACHE ]
    set use_s0_arprot    [ get_parameter_value USE_S0_ARPROT ]
    set use_s0_arqos     [ get_parameter_value USE_S0_ARQOS ]
    # Read write data channel parameters
    set use_m0_wstrb     [ get_parameter_value USE_M0_WSTRB ]
    set use_s0_wlast     [ get_parameter_value USE_S0_WLAST ]
    # Read write response channel parameters
    set use_m0_bid       [ get_parameter_value USE_M0_BID ]
    set use_m0_bresp     [ get_parameter_value USE_M0_BRESP ]
    set use_s0_bresp     [ get_parameter_value USE_S0_BRESP ]
    # Read read response channel parameters
    set use_m0_rid       [ get_parameter_value USE_M0_RID ]
    set use_m0_rresp     [ get_parameter_value USE_M0_RRESP ]
    set use_m0_rlast     [ get_parameter_value USE_M0_RLAST ]
    set use_s0_rresp     [ get_parameter_value USE_S0_RRESP ]
    # Read master interface properties
    set write_issuing_capability    [ get_parameter_value WRITE_ISSUING_CAPABILITY  ]
    set read_issuing_capability     [ get_parameter_value READ_ISSUING_CAPABILITY  ]
    set combined_issuing_capability [ get_parameter_value COMBINED_ISSUING_CAPABILITY  ]
    # Read slave interface properties
    set read_acceptance_capability     [ get_parameter_value READ_ACCEPTANCE_CAPABILITY ]
    set write_acceptance_capability    [ get_parameter_value WRITE_ACCEPTANCE_CAPABILITY ]
    set combined_acceptance_capability [ get_parameter_value COMBINED_ACCEPTANCE_CAPABILITY ]
    set read_data_reordering_depth     [ get_parameter_value READ_DATA_REORDERING_DEPTH ]

    set master_name m0
    set slave_name s0
    # Add correct interface type based on what kind of master.
    # One case when 1x1 system: AXI3 <-> AXI4
    # The slave side is AXI3
    # The master side interface is AXI4
    # For all other cases: AXI Translator will have all in AXI4 interface
    if { $axi3_master == "AXI3" } {
        add_axi3_slave_interface  $slave_name
    } else {
        add_axi4_slave_interface $slave_name
    }
    if { $axi3_slave == "AXI3"} {
        add_axi3_master_interface $master_name
    } else {
        add_axi4_master_interface $master_name
    }

    set_interface_property $slave_name bridgesToMaster $master_name

    # set porperties
    set_interface_property $master_name writeIssuingCapability $write_issuing_capability
    set_interface_property $master_name readIssuingCapability $read_issuing_capability
    set_interface_property $master_name combinedIssuingCapability $combined_issuing_capability
    set_interface_property $slave_name readAcceptanceCapability $read_acceptance_capability
    set_interface_property $slave_name writeAcceptanceCapability $write_acceptance_capability
    set_interface_property $slave_name combinedAcceptanceCapability $combined_acceptance_capability
    set_interface_property $slave_name readDataReorderingDepth $read_data_reordering_depth

    # This to change the width of these two signal between AXI3 and AXI4
    if { $axi3_master == "AXI4" } {
        set burst_length 8
        set lock_width   1
    } else {
        set burst_length 4
        set lock_width   2
    }
    if { $axi3_slave == "AXI4" } {
        set burst_length 8
        set lock_width   1
    } else {
        set burst_length 4
        set lock_width   2
    }
    set_parameter_value BURST_LENGTH_WIDTH $burst_length
    set_parameter_value LOCK_WIDTH         $lock_width
    # Debugging
    send_message Info "Burst length BURST_LENGTH_WIDTH [ get_parameter_value BURST_LENGTH_WIDTH ]"
    send_message Info "Lock signals width LOCK_WIDTH [ get_parameter_value LOCK_WIDTH ]"
    #-----
    set_port_property ${master_name}_awlen     WIDTH_EXPR [ get_parameter_value BURST_LENGTH_WIDTH ]
    set_port_property ${master_name}_awlen vhdl_type std_logic_vector
    set_port_property ${master_name}_arlen     WIDTH_EXPR [ get_parameter_value BURST_LENGTH_WIDTH ]
    set_port_property ${master_name}_arlen vhdl_type std_logic_vector
    set_port_property ${master_name}_awlock    WIDTH_EXPR [ get_parameter_value LOCK_WIDTH ]
    set_port_property ${master_name}_awlock vhdl_type std_logic_vector
    set_port_property ${master_name}_arlock    WIDTH_EXPR [ get_parameter_value LOCK_WIDTH ]
    set_port_property ${master_name}_arlock vhdl_type std_logic_vector
    set_port_property ${slave_name}_awlen      WIDTH_EXPR [ get_parameter_value BURST_LENGTH_WIDTH ]
    set_port_property ${slave_name}_awlen vhdl_type std_logic_vector
    set_port_property ${slave_name}_arlen      WIDTH_EXPR [ get_parameter_value BURST_LENGTH_WIDTH ]
    set_port_property ${slave_name}_arlen vhdl_type std_logic_vector
    set_port_property ${slave_name}_awlock     WIDTH_EXPR [ get_parameter_value LOCK_WIDTH ]
    set_port_property ${slave_name}_awlock vhdl_type std_logic_vector
    set_port_property ${slave_name}_arlock     WIDTH_EXPR [ get_parameter_value LOCK_WIDTH ]
    set_port_property ${slave_name}_arlock vhdl_type std_logic_vector

    # Check on each optinal signals on master side
    # to terminate the port
    # this is only apply for AXI4 only
    if { $axi3_master == "AXI4" } {
        # Handle VHDL simulation, WID is not in AXI4 but it is on HDL for need create port here
        add_interface my_export_axi4_m conduit end
        add_interface_port my_export_axi4_m ${master_name}_wid ${master_name}_wid output $m0_id_width
        set_port_property ${master_name}_wid TERMINATION true

        set_port_property ${master_name}_awid WIDTH_EXPR $m0_id_width
        set_port_property ${master_name}_awid vhdl_type std_logic_vector
        if { $use_m0_awid == 0 } {
            set_port_property ${master_name}_awid TERMINATION true
        }

        if { $use_m0_awregion == 0 } {
            set_port_property ${master_name}_awregion TERMINATION true
        }
        set_port_property ${master_name}_awregion vhdl_type std_logic_vector

        if { $use_m0_awlen == 0 } {
            set_port_property ${master_name}_awlen TERMINATION true
        }
        set_port_property ${master_name}_awlen vhdl_type std_logic_vector

        if { $use_m0_awsize == 0 } {
            set_port_property ${master_name}_awsize TERMINATION true
        }
        set_port_property ${master_name}_awsize vhdl_type std_logic_vector

        if { $use_m0_awburst == 0 } {
            set_port_property ${master_name}_awburst TERMINATION true
        }
        set_port_property ${master_name}_awburst vhdl_type std_logic_vector

        if { $use_m0_awlock == 0 } {
            set_port_property ${master_name}_awlock TERMINATION true
        }
        set_port_property ${master_name}_awlock vhdl_type std_logic_vector

        if { $use_m0_awcache == 0 } {
            set_port_property ${master_name}_awcache TERMINATION true
        }
        set_port_property ${master_name}_awcache vhdl_type std_logic_vector

        if { $use_m0_awqos == 0 } {
            set_port_property ${master_name}_awqos TERMINATION true
        }
        set_port_property ${master_name}_awqos vhdl_type std_logic_vector

        set_port_property ${master_name}_wstrb WIDTH_EXPR $wstrb_width
        set_port_property ${master_name}_wstrb vhdl_type std_logic_vector
        if { $use_m0_wstrb == 0 } {
            set_port_property ${master_name}_wstrb TERMINATION true
            set_port_property ${master_name}_wstrb TERMINATION_VALUE  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        }

        set_port_property ${master_name}_bid WIDTH_EXPR $m0_id_width
        set_port_property ${master_name}_bid vhdl_type std_logic_vector
        if { $use_m0_bid == 0 } {
            set_port_property ${master_name}_bid TERMINATION true
        }


        if { $use_m0_bresp == 0 } {
            set_port_property ${master_name}_bresp TERMINATION true
        }
        set_port_property ${master_name}_bresp vhdl_type std_logic_vector

        set_port_property ${master_name}_arid WIDTH_EXPR $m0_id_width
        set_port_property ${master_name}_arid vhdl_type std_logic_vector
        if { $use_m0_arid == 0 } {
            set_port_property ${master_name}_arid TERMINATION true
        }

        if { $use_m0_arregion == 0 } {
            set_port_property ${master_name}_arregion TERMINATION true
        }
        set_port_property ${master_name}_arregion vhdl_type std_logic_vector

        if { $use_m0_arlen == 0 } {
            set_port_property ${master_name}_arlen TERMINATION true
        }
        set_port_property ${master_name}_arlen vhdl_type std_logic_vector

        if { $use_m0_arsize == 0 } {
            set_port_property ${master_name}_arsize TERMINATION true
        }
        set_port_property ${master_name}_arsize vhdl_type std_logic_vector

        if { $use_m0_arburst == 0 } {
            set_port_property ${master_name}_arburst TERMINATION true
        }
        set_port_property ${master_name}_arburst vhdl_type std_logic_vector

        if { $use_m0_arlock == 0 } {
            set_port_property ${master_name}_arlock TERMINATION true
        }
        set_port_property ${master_name}_arlock vhdl_type std_logic_vector

        if { $use_m0_arcache == 0 } {
            set_port_property ${master_name}_arcache TERMINATION true
        }
        set_port_property ${master_name}_arcache vhdl_type std_logic_vector

        if { $use_m0_arqos == 0 } {
            set_port_property ${master_name}_arqos TERMINATION true
        }
        set_port_property ${master_name}_arqos vhdl_type std_logic_vector

        set_port_property ${master_name}_rid WIDTH_EXPR $m0_id_width
        set_port_property ${master_name}_rid vhdl_type std_logic_vector
        if { $use_m0_rid == 0 } {
            set_port_property ${master_name}_rid TERMINATION true
        }


        if { $use_m0_rresp == 0 } {
            set_port_property ${master_name}_rresp TERMINATION true
        }
        set_port_property ${master_name}_rresp vhdl_type std_logic_vector

        if { $use_m0_rlast == 0 } {
            set_port_property ${master_name}_rlast TERMINATION true
        }

        set_port_property ${master_name}_wuser WIDTH_EXPR $write_data_user_width
        set_port_property ${master_name}_wuser vhdl_type std_logic_vector
        if { $use_m0_wuser == 0 } {
            set_port_property ${master_name}_wuser TERMINATION true
        }

        set_port_property ${master_name}_ruser WIDTH_EXPR $read_data_user_width
        set_port_property ${master_name}_ruser vhdl_type std_logic_vector
        if { $use_m0_ruser == 0 } {
            set_port_property ${master_name}_ruser TERMINATION true
        }

        set_port_property ${master_name}_buser WIDTH_EXPR $write_resp_user_width
        set_port_property ${master_name}_buser vhdl_type std_logic_vector
        if { $use_m0_buser == 0 } {
            set_port_property ${master_name}_buser TERMINATION true
        }
    }

    # Check on each optinal signals on slave side
    # to terminate the port
    # this is only apply for AXI4 only
    if { $axi3_slave == "AXI4" } {
        # Handle VHDL simulation, WID is not in AXI4 but it is on HDL for need create port here
        add_interface my_export_axi4_m conduit end
        add_interface_port my_export_axi4_m ${slave_name}_wid ${slave_name}_wid input $s0_id_width
        set_port_property ${slave_name}_wid TERMINATION true
        # Master side Write address channel signals
        if { $use_s0_awregion == 0 } {
            set_port_property ${slave_name}_awregion TERMINATION true
        }
        set_port_property ${slave_name}_awregion vhdl_type std_logic_vector

        if { $use_s0_awlock == 0 } {
            set_port_property ${slave_name}_awlock TERMINATION true
        }
        set_port_property ${slave_name}_awlock vhdl_type std_logic_vector

        if { $use_s0_awcache == 0 } {
            set_port_property ${slave_name}_awcache TERMINATION true
        }
        set_port_property ${slave_name}_awcache vhdl_type std_logic_vector

        if { $use_s0_awqos == 0 } {
            set_port_property ${slave_name}_awqos TERMINATION true
        }
        set_port_property ${slave_name}_awqos vhdl_type std_logic_vector

        if { $use_s0_awprot == 0 } {
            set_port_property ${slave_name}_awprot TERMINATION true
        }
        set_port_property ${slave_name}_awprot vhdl_type std_logic_vector

        # Master side Write data channel signals
        if { $use_s0_wlast == 0 } {
            set_port_property ${slave_name}_wlast TERMINATION true
        }

        # Master side Read address channel
        if { $use_s0_arregion == 0 } {
            set_port_property ${slave_name}_arregion TERMINATION true
        }
        set_port_property ${slave_name}_arregion vhdl_type std_logic_vector

        if { $use_s0_arlock == 0 } {
            set_port_property ${slave_name}_arlock TERMINATION true
        }
        set_port_property ${slave_name}_arlock vhdl_type std_logic_vector

        if { $use_s0_arcache == 0 } {
            set_port_property ${slave_name}_arcache TERMINATION true
        }
        set_port_property ${slave_name}_arcache vhdl_type std_logic_vector

        if { $use_s0_arqos == 0 } {
            set_port_property ${slave_name}_arqos TERMINATION true
        }
        set_port_property ${slave_name}_arqos vhdl_type std_logic_vector

        if { $use_s0_arprot == 0 } {
            set_port_property ${slave_name}_arprot TERMINATION true
        }
        set_port_property ${slave_name}_arprot vhdl_type std_logic_vector

        # Master side Write response channel
        if { $use_s0_bresp == 0 } {
            set_port_property ${slave_name}_bresp TERMINATION true
        }
        set_port_property ${slave_name}_bresp vhdl_type std_logic_vector

        # Master side Read response channel
        if { $use_s0_rresp == 0 } {
            set_port_property ${slave_name}_rresp TERMINATION true
        }
        set_port_property ${slave_name}_rresp vhdl_type std_logic_vector


        # User signals
        set_port_property ${slave_name}_wuser WIDTH_EXPR $write_data_user_width
        set_port_property ${slave_name}_wuser vhdl_type std_logic_vector
        if { $use_s0_wuser == 0 } {
            set_port_property ${slave_name}_wuser TERMINATION true
        }

        set_port_property ${slave_name}_ruser WIDTH_EXPR $read_data_user_width
        set_port_property ${slave_name}_ruser vhdl_type std_logic_vector
        if { $use_s0_ruser == 0 } {
            set_port_property ${slave_name}_ruser TERMINATION true
        }

        set_port_property ${slave_name}_buser WIDTH_EXPR $write_resp_user_width
        set_port_property ${slave_name}_buser vhdl_type std_logic_vector
        if { $use_s0_buser == 0 } {
            set_port_property ${slave_name}_buser TERMINATION true
        }
    }
    # Do setting porperty for ports
    # some are same for both, some only apply for AXI3
    set_port_property ${master_name}_awaddr WIDTH_EXPR $addr_width
    set_port_property ${master_name}_awaddr vhdl_type std_logic_vector
    set_port_property ${slave_name}_awaddr  WIDTH_EXPR $addr_width
    set_port_property ${master_name}_awaddr vhdl_type std_logic_vector
    set_port_property ${master_name}_araddr WIDTH_EXPR $addr_width
    set_port_property ${master_name}_araddr vhdl_type std_logic_vector
    set_port_property ${slave_name}_araddr  WIDTH_EXPR $addr_width
    set_port_property ${master_name}_araddr vhdl_type std_logic_vector
    set_port_property ${master_name}_wdata  WIDTH_EXPR $data_width
    set_port_property ${master_name}_wdata vhdl_type std_logic_vector
    set_port_property ${master_name}_rdata  WIDTH_EXPR $data_width
    set_port_property ${master_name}_rdata vhdl_type std_logic_vector
    set_port_property ${slave_name}_wdata   WIDTH_EXPR $data_width
    set_port_property ${master_name}_wdata vhdl_type std_logic_vector
    set_port_property ${slave_name}_rdata   WIDTH_EXPR $data_width
    set_port_property ${master_name}_rdata vhdl_type std_logic_vector
    set_port_property ${master_name}_wstrb  WIDTH_EXPR $wstrb_width
    set_port_property ${master_name}_wstrb vhdl_type std_logic_vector
    set_port_property ${master_name}_awid WIDTH_EXPR $m0_id_width
    set_port_property ${master_name}_awid vhdl_type std_logic_vector
    set_port_property ${master_name}_wid  WIDTH_EXPR $m0_id_width
    set_port_property ${master_name}_wid vhdl_type std_logic_vector  
    set_port_property ${master_name}_bid  WIDTH_EXPR $m0_id_width
    set_port_property ${master_name}_bid vhdl_type std_logic_vector
    set_port_property ${master_name}_arid WIDTH_EXPR $m0_id_width
    set_port_property ${master_name}_arid vhdl_type std_logic_vector
    set_port_property ${master_name}_rid  WIDTH_EXPR $m0_id_width
    set_port_property ${master_name}_rid vhdl_type std_logic_vector
    set_port_property ${slave_name}_awid WIDTH_EXPR $s0_id_width
    set_port_property  ${slave_name}_awid vhdl_type std_logic_vector
    set_port_property ${slave_name}_wid  WIDTH_EXPR $s0_id_width
    set_port_property  ${slave_name}_wid vhdl_type std_logic_vector
    set_port_property ${slave_name}_bid  WIDTH_EXPR $s0_id_width
    set_port_property  ${slave_name}_bid vhdl_type std_logic_vector
    set_port_property ${slave_name}_arid WIDTH_EXPR $s0_id_width
    set_port_property  ${slave_name}_arid vhdl_type std_logic_vector
    set_port_property ${slave_name}_rid  WIDTH_EXPR $s0_id_width
    set_port_property  ${slave_name}_rid vhdl_type std_logic_vector
    set_port_property ${slave_name}_wstrb WIDTH_EXPR $wstrb_width
    set_port_property  ${slave_name}_wstrb vhdl_type std_logic_vector


    if { $axi3_master == "AXI3" } {
        # This is crazy stuff to make VHDL simulation
        # VHDL need all ports of entity must be avaiable in the top level
        # but for AXI3, some signals are not avaiable in Qsys but they are
        # always exist in HDL (qos, region ...)
        add_interface my_export_s conduit end
        add_interface_port my_export_s ${slave_name}_awqos ${slave_name}_awqos input 4
        set_port_property  ${slave_name}_awqos vhdl_type std_logic_vector
        set_port_property ${slave_name}_awqos TERMINATION true
        add_interface_port my_export_s ${slave_name}_arqos ${slave_name}_arqos input 4
        set_port_property  ${slave_name}_arqos vhdl_type std_logic_vector
        set_port_property ${slave_name}_arqos TERMINATION true
        add_interface_port my_export_s ${slave_name}_awregion ${slave_name}_awregion input 4
        set_port_property  ${slave_name}_awregion vhdl_type std_logic_vector
        set_port_property ${slave_name}_awregion TERMINATION true
        add_interface_port my_export_s ${slave_name}_arregion ${slave_name}_arregion input 4
        set_port_property  ${slave_name}_arregion vhdl_type std_logic_vector
        set_port_property ${slave_name}_arregion TERMINATION true
        add_interface_port my_export_s ${slave_name}_wuser ${slave_name}_wuser input $write_data_user_width
        set_port_property  ${slave_name}_wuser vhdl_type std_logic_vector
        set_port_property ${slave_name}_wuser TERMINATION true
        add_interface_port my_export_s ${slave_name}_ruser ${slave_name}_ruser output $read_data_user_width
        set_port_property  ${slave_name}_ruser vhdl_type std_logic_vector
        set_port_property ${slave_name}_ruser TERMINATION true
        add_interface_port my_export_s ${slave_name}_buser ${slave_name}_buser output $write_resp_user_width
        set_port_property  ${slave_name}_buser vhdl_type std_logic_vector
        set_port_property ${slave_name}_buser TERMINATION true
    }
    if { $axi3_slave == "AXI3" } {
        add_interface my_export_m conduit end
        add_interface_port my_export_m ${master_name}_awqos ${master_name}_awqos output 4
        set_port_property  ${master_name}_awqos vhdl_type std_logic_vector
        set_port_property ${master_name}_awqos TERMINATION true
        add_interface_port my_export_m ${master_name}_arqos ${master_name}_arqos output 4
        set_port_property  ${master_name}_arqos vhdl_type std_logic_vector
        set_port_property ${master_name}_arqos TERMINATION true
        add_interface_port my_export_m ${master_name}_awregion ${master_name}_awregion output 4
        set_port_property  ${master_name}_awregion vhdl_type std_logic_vector
        set_port_property ${master_name}_awregion TERMINATION true
        add_interface_port my_export_m ${master_name}_arregion ${master_name}_arregion output 4
        set_port_property  ${master_name}_arregion vhdl_type std_logic_vector
        set_port_property ${master_name}_arregion TERMINATION true
        add_interface_port my_export_m ${master_name}_wuser ${master_name}_wuser output $write_data_user_width
        set_port_property  ${master_name}_wuser vhdl_type std_logic_vector
        set_port_property ${master_name}_wuser TERMINATION true
        add_interface_port my_export_m ${master_name}_ruser ${master_name}_ruser input $read_data_user_width
        set_port_property  ${master_name}_ruser vhdl_type std_logic_vector
        set_port_property ${master_name}_ruser TERMINATION true
        add_interface_port my_export_m ${master_name}_buser ${master_name}_buser input $write_resp_user_width
        set_port_property  ${master_name}_buser vhdl_type std_logic_vector
        set_port_property ${master_name}_buser TERMINATION true
    }

    # Address side band signals
    set_port_property ${slave_name}_awuser WIDTH_EXPR $write_addr_user_width
    set_port_property  ${slave_name}_awuser vhdl_type std_logic_vector
    if { $use_s0_awuser == 0 } {
        set_port_property ${slave_name}_awuser TERMINATION true
    }

    set_port_property ${slave_name}_aruser WIDTH_EXPR $read_addr_user_width
    set_port_property  ${slave_name}_aruser vhdl_type std_logic_vector
    if { $use_s0_aruser == 0 } {
        set_port_property ${slave_name}_aruser TERMINATION true
    }

    set_port_property ${master_name}_awuser WIDTH_EXPR $write_addr_user_width
    set_port_property  ${master_name}_awuser vhdl_type std_logic_vector
    if { $use_m0_awuser == 0 } {
        set_port_property ${master_name}_awuser TERMINATION true
    }

    set_port_property ${master_name}_aruser WIDTH_EXPR $read_addr_user_width
    set_port_property  ${master_name}_aruser vhdl_type std_logic_vector
    if { $use_m0_aruser == 0 } {
        set_port_property ${master_name}_aruser TERMINATION true
    }

    validate_parameters
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959300571
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1416836145555/hco1416836653221
