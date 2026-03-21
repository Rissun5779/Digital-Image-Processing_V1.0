# Generated TCL File
# DO NOT MODIFY

# +-----------------------------------
# |
# | mgc_axi4lite_master_bfm "MGC AXI4-Lite Master BFM" 10.4c
# | Mentor Graphics 16.1
# | AXI4-Lite Master BFM
# |
# | ./mgc_axi4_master.sv sim
# |
# +-----------------------------------

# +-----------------------------------
# | Request TCL Packages.
package require -exact qsys 14.0
# |
# +-----------------------------------

# +-----------------------------------
# | module mgc_axi4lite_master
# |
set_module_property DESCRIPTION        "Mentor Graphics AXI4-Lite Master BFM (Altera Edition)"
set_module_property NAME               mgc_axi4lite_master
set_module_property VERSION            10.4.3.0
set_module_property AUTHOR             "Mentor Graphics Corporation"
set_module_property ICON_PATH          "../../common/Mentor_VIP_AE_icon.png"
set_module_property DISPLAY_NAME       "Mentor Graphics AXI4-Lite Master BFM (Altera Edition)"
set_module_property GROUP              "Verification/Simulation"
set_module_property EDITABLE           false
# |
# +-----------------------------------

# +-----------------------------------
# | files
# |
add_fileset          sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog top_level   mgc_axi4lite_master

add_fileset          sim_vhdl    SIM_VHDL    proc_sim_vhdl
set_fileset_property sim_vhdl    top_level   mgc_axi4lite_master_vhd

proc proc_sim_verilog { name } {
}

proc proc_sim_vhdl { name } {
}

# |
# +-----------------------------------

# +-----------------------------------
# | Documentation links
# |
add_documentation_link "AXI4-Lite Master BFM Reference Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/mentor-vip-axi4lite-ae-usr.pdf
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

add_parameter          READ_ISSUING_CAPABILITY INTEGER 8
set_parameter_property READ_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property READ_ISSUING_CAPABILITY DISPLAY_NAME "Maximum Outstanding Reads"
set_parameter_property READ_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property READ_ISSUING_CAPABILITY UNITS None
set_parameter_property READ_ISSUING_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Reads"
set_parameter_property READ_ISSUING_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property READ_ISSUING_CAPABILITY HDL_PARAMETER true
set_parameter_property READ_ISSUING_CAPABILITY ALLOWED_RANGES {1:16}

add_parameter          WRITE_ISSUING_CAPABILITY INTEGER 8
set_parameter_property WRITE_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property WRITE_ISSUING_CAPABILITY DISPLAY_NAME "Maximum Outstanding Writes"
set_parameter_property WRITE_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property WRITE_ISSUING_CAPABILITY UNITS None
set_parameter_property WRITE_ISSUING_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Writes"
set_parameter_property WRITE_ISSUING_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property WRITE_ISSUING_CAPABILITY HDL_PARAMETER true
set_parameter_property WRITE_ISSUING_CAPABILITY ALLOWED_RANGES {1:16}

add_parameter          COMBINED_ISSUING_CAPABILITY INTEGER 16
set_parameter_property COMBINED_ISSUING_CAPABILITY DEFAULT_VALUE 16
set_parameter_property COMBINED_ISSUING_CAPABILITY DISPLAY_NAME "Maximum Outstanding Transactions"
set_parameter_property COMBINED_ISSUING_CAPABILITY TYPE INTEGER
set_parameter_property COMBINED_ISSUING_CAPABILITY UNITS None
set_parameter_property COMBINED_ISSUING_CAPABILITY DESCRIPTION "Maximum Number of Outstanding Transactions"
set_parameter_property COMBINED_ISSUING_CAPABILITY AFFECTS_ELABORATION true
set_parameter_property COMBINED_ISSUING_CAPABILITY HDL_PARAMETER true
set_parameter_property COMBINED_ISSUING_CAPABILITY ALLOWED_RANGES {1:16}

# |
# +-----------------------------------

# +-----------------------------------
# | display items
# |
# +-----------------------------------

# +-----------------------------------
# | connection point altera_axi4lite_master
# |
add_interface          altera_axi4lite_master axi4lite start
set_interface_property altera_axi4lite_master associatedClock clock_sink
set_interface_property altera_axi4lite_master associatedReset reset_sink
set_interface_property altera_axi4lite_master ENABLED true

add_interface_port altera_axi4lite_master AWVALID    awvalid    Output 1
add_interface_port altera_axi4lite_master AWPROT     awprot     Output 3
add_interface_port altera_axi4lite_master AWREADY    awready    Input  1
add_interface_port altera_axi4lite_master ARVALID    arvalid    Output 1
add_interface_port altera_axi4lite_master ARPROT     arprot     Output 3
add_interface_port altera_axi4lite_master ARREADY    arready    Input  1
add_interface_port altera_axi4lite_master RVALID     rvalid     Input  1
add_interface_port altera_axi4lite_master RRESP      rresp      Input  2
add_interface_port altera_axi4lite_master RREADY     rready     Output 1
add_interface_port altera_axi4lite_master WVALID     wvalid     Output 1
add_interface_port altera_axi4lite_master WREADY     wready     Input  1
add_interface_port altera_axi4lite_master BVALID     bvalid     Input  1
add_interface_port altera_axi4lite_master BRESP      bresp      Input  2
add_interface_port altera_axi4lite_master BREADY     bready     Output 1
# |
# +-----------------------------------

set_module_property ELABORATION_CALLBACK my_elaborate

proc my_elaborate {} {
  set AXI4_ADDRESS_WIDTH   [get_parameter_value AXI4_ADDRESS_WIDTH]
  set AXI4_RDATA_WIDTH     [get_parameter_value AXI4_RDATA_WIDTH]
  set AXI4_WDATA_WIDTH     [get_parameter_value AXI4_WDATA_WIDTH]
  set READ_ISSUING_CAPABILITY         [ get_parameter_value READ_ISSUING_CAPABILITY ]
  set WRITE_ISSUING_CAPABILITY        [ get_parameter_value WRITE_ISSUING_CAPABILITY ]
  set COMBINED_ISSUING_CAPABILITY     [ get_parameter_value COMBINED_ISSUING_CAPABILITY ]

  set_interface_property altera_axi4lite_master readIssuingCapability $READ_ISSUING_CAPABILITY
  set_interface_property altera_axi4lite_master writeIssuingCapability $WRITE_ISSUING_CAPABILITY
  set_interface_property altera_axi4lite_master combinedIssuingCapability $COMBINED_ISSUING_CAPABILITY

  add_interface_port altera_axi4lite_master AWADDR     awaddr     Output $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4lite_master ARADDR     araddr     Output $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4lite_master RDATA      rdata      Input  $AXI4_RDATA_WIDTH
  add_interface_port altera_axi4lite_master WDATA      wdata      Output $AXI4_WDATA_WIDTH
  add_interface_port altera_axi4lite_master WSTRB      wstrb      Output [ expr ($AXI4_WDATA_WIDTH / 8) ]
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
