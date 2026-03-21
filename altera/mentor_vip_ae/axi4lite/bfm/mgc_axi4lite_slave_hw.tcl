# Generated TCL File
# DO NOT MODIFY

# +-----------------------------------
# |
# | mgc_axi4lite_slave_bfm "MGC AXI4-Lite Slave BFM" 10.4c
# | Mentor Graphics 16.1
# | AXI4-Lite Slave BFM
# |
# | ./mgc_axi4_slave.sv sim
# |
# +-----------------------------------

# +-----------------------------------
# | Request TCL Packages.
package require -exact qsys 14.0
# |
# +-----------------------------------

# +-----------------------------------
# | module mgc_axi4lite_slave
# |
set_module_property DESCRIPTION        "Mentor Graphics AXI4-Lite Slave BFM (Altera Edition)"
set_module_property NAME               mgc_axi4lite_slave
set_module_property VERSION            10.4.3.0
set_module_property AUTHOR             "Mentor Graphics Corporation"
set_module_property ICON_PATH          "../../common/Mentor_VIP_AE_icon.png"
set_module_property DISPLAY_NAME       "Mentor Graphics AXI4-Lite Slave BFM (Altera Edition)"
set_module_property GROUP              "Verification/Simulation"
set_module_property EDITABLE           false
# |
# +-----------------------------------

# +-----------------------------------
# | files
# |
add_fileset          sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog top_level   mgc_axi4lite_slave

add_fileset          sim_vhdl    SIM_VHDL    proc_sim_vhdl
set_fileset_property sim_vhdl    top_level   mgc_axi4lite_slave_vhd

proc proc_sim_verilog { name } {
}

proc proc_sim_vhdl { name } {
}

# |
# +-----------------------------------

# +-----------------------------------
# | Documentation links
# |
add_documentation_link "AXI4-Lite Slave BFM Reference Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/mentor-vip-axi4lite-ae-usr.pdf
# |
# +-----------------------------------

# +-----------------------------------
# | Parameters
# |
add_parameter          AXI4_ADDRESS_WIDTH INTEGER 64
set_parameter_property AXI4_ADDRESS_WIDTH DISPLAY_NAME      "AXI4 Address Bus Width"
set_parameter_property AXI4_ADDRESS_WIDTH DESCRIPTION       "The width of the AWADDR and ARADDR signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)."
set_parameter_property AXI4_ADDRESS_WIDTH ALLOWED_RANGES     1:64
set_parameter_property AXI4_ADDRESS_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_RDATA_WIDTH INTEGER 1024
set_parameter_property AXI4_RDATA_WIDTH DISPLAY_NAME      "AXI4 Read Data Bus Width"
set_parameter_property AXI4_RDATA_WIDTH DESCRIPTION       "The width of the RDATA signal (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.6)."
set_parameter_property AXI4_RDATA_WIDTH ALLOWED_RANGES     1:1024
set_parameter_property AXI4_RDATA_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_WDATA_WIDTH INTEGER 1024
set_parameter_property AXI4_WDATA_WIDTH DISPLAY_NAME      "AXI4 Write Data Bus Width"
set_parameter_property AXI4_WDATA_WIDTH DESCRIPTION       "The width of the WDATA signal (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.3)."
set_parameter_property AXI4_WDATA_WIDTH ALLOWED_RANGES     1:1024
set_parameter_property AXI4_WDATA_WIDTH HDL_PARAMETER      true

add_parameter          index INTEGER 0
set_parameter_property index DISPLAY_NAME       "VHDL BFM instance ID"
set_parameter_property index DESCRIPTION        "The parameter 'index' is used to uniquely indentify VHDL BFM instances. It must be set to a different value for each VHDL BFM in the system. It is ignored for Verilog BFM instances"
set_parameter_property index ALLOWED_RANGES     0:1023
set_parameter_property index HDL_PARAMETER      true

add_parameter          READ_ACCEPTANCE_CAPABILITY INTEGER 8
set_parameter_property READ_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property READ_ACCEPTANCE_CAPABILITY DISPLAY_NAME "READ_ACCEPTANCE_CAPABILITY"
set_parameter_property READ_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property READ_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property READ_ACCEPTANCE_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Reads"
set_parameter_property READ_ACCEPTANCE_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property READ_ACCEPTANCE_CAPABILITY HDL_PARAMETER true
set_parameter_property READ_ACCEPTANCE_CAPABILITY ALLOWED_RANGES {1:16}

add_parameter          WRITE_ACCEPTANCE_CAPABILITY INTEGER 8
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DISPLAY_NAME "WRITE_ACCEPTANCE_CAPABILITY"
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Writes"
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY HDL_PARAMETER true
set_parameter_property WRITE_ACCEPTANCE_CAPABILITY ALLOWED_RANGES {1:16}

add_parameter          COMBINED_ACCEPTANCE_CAPABILITY INTEGER 8
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DEFAULT_VALUE 16
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DISPLAY_NAME "COMBINED_ACCEPTANCE_CAPABILITY"
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY TYPE INTEGER
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY UNITS None
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Transactions"
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY HDL_PARAMETER true
set_parameter_property COMBINED_ACCEPTANCE_CAPABILITY ALLOWED_RANGES {1:16}

# |
# +-----------------------------------

# +-----------------------------------
# | display items
# |
# +-----------------------------------

# +-----------------------------------
# | connection point altera_axi4lite_slave
# |
add_interface          altera_axi4lite_slave axi4lite end
set_interface_property altera_axi4lite_slave associatedClock clock_sink
set_interface_property altera_axi4lite_slave associatedReset reset_sink
set_interface_property altera_axi4lite_slave ENABLED true

add_interface_port altera_axi4lite_slave AWVALID    awvalid    Input  1
add_interface_port altera_axi4lite_slave AWPROT     awprot     Input  3
add_interface_port altera_axi4lite_slave AWREADY    awready    Output 1
add_interface_port altera_axi4lite_slave ARVALID    arvalid    Input  1
add_interface_port altera_axi4lite_slave ARPROT     arprot     Input  3
add_interface_port altera_axi4lite_slave ARREADY    arready    Output 1
add_interface_port altera_axi4lite_slave RVALID     rvalid     Output 1
add_interface_port altera_axi4lite_slave RRESP      rresp      Output 2
add_interface_port altera_axi4lite_slave RREADY     rready     Input  1
add_interface_port altera_axi4lite_slave WVALID     wvalid     Input  1
add_interface_port altera_axi4lite_slave WREADY     wready     Output 1
add_interface_port altera_axi4lite_slave BVALID     bvalid     Output 1
add_interface_port altera_axi4lite_slave BRESP      bresp      Output 2
add_interface_port altera_axi4lite_slave BREADY     bready     Input  1
# |
# +-----------------------------------

set_module_property ELABORATION_CALLBACK my_elaborate

proc my_elaborate {} {
  set AXI4_ADDRESS_WIDTH   [get_parameter_value AXI4_ADDRESS_WIDTH]
  set AXI4_RDATA_WIDTH     [get_parameter_value AXI4_RDATA_WIDTH]
  set AXI4_WDATA_WIDTH     [get_parameter_value AXI4_WDATA_WIDTH]
  set READ_ACCEPTANCE_CAPABILITY          [ get_parameter_value READ_ACCEPTANCE_CAPABILITY ]
  set WRITE_ACCEPTANCE_CAPABILITY         [ get_parameter_value WRITE_ACCEPTANCE_CAPABILITY ]
  set COMBINED_ACCEPTANCE_CAPABILITY   [ get_parameter_value COMBINED_ACCEPTANCE_CAPABILITY ]

  set_interface_property altera_axi4lite_slave readAcceptanceCapability $READ_ACCEPTANCE_CAPABILITY
  set_interface_property altera_axi4lite_slave writeAcceptanceCapability $WRITE_ACCEPTANCE_CAPABILITY
  set_interface_property altera_axi4lite_slave combinedAcceptanceCapability $COMBINED_ACCEPTANCE_CAPABILITY

  add_interface_port altera_axi4lite_slave AWADDR     awaddr     Input  $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4lite_slave ARADDR     araddr     Input  $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4lite_slave RDATA      rdata      Output $AXI4_RDATA_WIDTH
  add_interface_port altera_axi4lite_slave WDATA      wdata      Input  $AXI4_WDATA_WIDTH
  add_interface_port altera_axi4lite_slave WSTRB      wstrb      Input  [ expr ($AXI4_WDATA_WIDTH / 8) ]
}

# +-----------------------------------
# | connection point clock_sink
# |
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0

set_interface_property clock_sink ENABLED true

add_interface_port clock_sink ACLK clk Input 1
# |
# +-----------------------------------

# +-----------------------------------
# | connection point reset_sink
# |
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT

set_interface_property reset_sink ENABLED true

add_interface_port reset_sink ARESETn reset_n Input 1
# |
# +-----------------------------------
