# Generated TCL File
# DO NOT MODIFY

# +-----------------------------------
# |
# | mgc_axi4_master_bfm "MGC AXI4 Master BFM" 10.4c
# | Mentor Graphics 16.1
# | AXI4 Master BFM
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
# | module mgc_axi4_master
# |
set_module_property DESCRIPTION        "Mentor Graphics AXI4 Master BFM (Altera Edition)"
set_module_property NAME               mgc_axi4_master
set_module_property VERSION            10.4.3.0
set_module_property AUTHOR             "Mentor Graphics Corporation"
set_module_property ICON_PATH          "../../common/Mentor_VIP_AE_icon.png"
set_module_property DISPLAY_NAME       "Mentor Graphics AXI4 Master BFM (Altera Edition)"
set_module_property GROUP              "Verification/Simulation"
set_module_property EDITABLE           false
# |
# +-----------------------------------

# +-----------------------------------
# | files
# |
add_fileset          sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog top_level   mgc_axi4_master

add_fileset          sim_vhdl    SIM_VHDL    proc_sim_vhdl
set_fileset_property sim_vhdl    top_level   mgc_axi4_master_vhd

proc proc_sim_verilog { name } {
}

proc proc_sim_vhdl { name } {
}

# |
# +-----------------------------------

# +-----------------------------------
# | Documentation links
# |
add_documentation_link "AXI4 Master BFM Reference Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/mentor-vip-axi34-ae-usr.pdf
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

add_parameter          AXI4_ID_WIDTH INTEGER 18
set_parameter_property AXI4_ID_WIDTH DISPLAY_NAME      "AXI4 ID Bus Width"
set_parameter_property AXI4_ID_WIDTH DESCRIPTION       "The width of the AWID, ARID, RID and BID signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A2.2)."
set_parameter_property AXI4_ID_WIDTH ALLOWED_RANGES     1:18
set_parameter_property AXI4_ID_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_USER_WIDTH INTEGER 8
set_parameter_property AXI4_USER_WIDTH DISPLAY_NAME      "AXI4 User-defined Bus Width"
set_parameter_property AXI4_USER_WIDTH DESCRIPTION       "The width of the AWUSER, ARUSER, WUSER, RUSER and BUSER signals (see AMBA AXI and ACE Protocol Specification IHI0022D section A8.3)."
set_parameter_property AXI4_USER_WIDTH ALLOWED_RANGES     1:8
set_parameter_property AXI4_USER_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_REGION_MAP_SIZE INTEGER 16
set_parameter_property AXI4_REGION_MAP_SIZE DISPLAY_NAME      "AXI4_REGION_MAP_SIZE"
set_parameter_property AXI4_REGION_MAP_SIZE DESCRIPTION       ""
set_parameter_property AXI4_REGION_MAP_SIZE ALLOWED_RANGES     1:16
set_parameter_property AXI4_REGION_MAP_SIZE HDL_PARAMETER      true

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

add_parameter USE_AWID INTEGER 1 "Enable AWID signal"
set_parameter_property USE_AWID DEFAULT_VALUE 1
set_parameter_property USE_AWID DISPLAY_NAME USE_AWID
set_parameter_property USE_AWID WIDTH ""
set_parameter_property USE_AWID TYPE INTEGER
set_parameter_property USE_AWID UNITS None
set_parameter_property USE_AWID DESCRIPTION "Enable AWID signal"
set_parameter_property USE_AWID AFFECTS_GENERATION false
set_parameter_property USE_AWID DISPLAY_HINT "boolean"
set_parameter_property USE_AWID HDL_PARAMETER true

add_parameter USE_AWREGION INTEGER 1 "Enable AWREGION signal"
set_parameter_property USE_AWREGION DEFAULT_VALUE 1
set_parameter_property USE_AWREGION DISPLAY_NAME USE_AWREGION
set_parameter_property USE_AWREGION WIDTH ""
set_parameter_property USE_AWREGION TYPE INTEGER
set_parameter_property USE_AWREGION UNITS None
set_parameter_property USE_AWREGION DESCRIPTION "Enable AWREGION signal"
set_parameter_property USE_AWREGION AFFECTS_GENERATION false
set_parameter_property USE_AWREGION DISPLAY_HINT "boolean"
set_parameter_property USE_AWREGION HDL_PARAMETER true

add_parameter USE_AWLEN INTEGER 1 "Enable AWLEN signal"
set_parameter_property USE_AWLEN DEFAULT_VALUE 1
set_parameter_property USE_AWLEN DISPLAY_NAME USE_AWLEN
set_parameter_property USE_AWLEN WIDTH ""
set_parameter_property USE_AWLEN TYPE INTEGER
set_parameter_property USE_AWLEN UNITS None
set_parameter_property USE_AWLEN DESCRIPTION "Enable AWLEN signal"
set_parameter_property USE_AWLEN AFFECTS_GENERATION false
set_parameter_property USE_AWLEN DISPLAY_HINT "boolean"
set_parameter_property USE_AWLEN HDL_PARAMETER true

add_parameter USE_AWSIZE INTEGER 1 "Enable AWSIZE signal"
set_parameter_property USE_AWSIZE DEFAULT_VALUE 1
set_parameter_property USE_AWSIZE DISPLAY_NAME USE_AWSIZE
set_parameter_property USE_AWSIZE WIDTH ""
set_parameter_property USE_AWSIZE TYPE INTEGER
set_parameter_property USE_AWSIZE UNITS None
set_parameter_property USE_AWSIZE DESCRIPTION "Enable AWSIZE signal"
set_parameter_property USE_AWSIZE AFFECTS_GENERATION false
set_parameter_property USE_AWSIZE DISPLAY_HINT "boolean"
set_parameter_property USE_AWSIZE HDL_PARAMETER true

add_parameter USE_AWBURST INTEGER 1 "Enable AWBURST signal"
set_parameter_property USE_AWBURST DEFAULT_VALUE 1
set_parameter_property USE_AWBURST DISPLAY_NAME USE_AWBURST
set_parameter_property USE_AWBURST WIDTH ""
set_parameter_property USE_AWBURST TYPE INTEGER
set_parameter_property USE_AWBURST UNITS None
set_parameter_property USE_AWBURST DESCRIPTION "Enable AWBURST signal"
set_parameter_property USE_AWBURST AFFECTS_GENERATION false
set_parameter_property USE_AWBURST DISPLAY_HINT "boolean"
set_parameter_property USE_AWBURST HDL_PARAMETER true

add_parameter USE_AWLOCK INTEGER 1 "Enable AWLOCK signal"
set_parameter_property USE_AWLOCK DEFAULT_VALUE 1
set_parameter_property USE_AWLOCK DISPLAY_NAME USE_AWLOCK
set_parameter_property USE_AWLOCK WIDTH ""
set_parameter_property USE_AWLOCK TYPE INTEGER
set_parameter_property USE_AWLOCK UNITS None
set_parameter_property USE_AWLOCK DESCRIPTION "Enable AWLOCK signal"
set_parameter_property USE_AWLOCK AFFECTS_GENERATION false
set_parameter_property USE_AWLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_AWLOCK HDL_PARAMETER true

add_parameter USE_AWCACHE INTEGER 1 "Enable AWCACHE signal"
set_parameter_property USE_AWCACHE DEFAULT_VALUE 1
set_parameter_property USE_AWCACHE DISPLAY_NAME USE_AWCACHE
set_parameter_property USE_AWCACHE WIDTH ""
set_parameter_property USE_AWCACHE TYPE INTEGER
set_parameter_property USE_AWCACHE UNITS None
set_parameter_property USE_AWCACHE DESCRIPTION "Enable AWCACHE signal"
set_parameter_property USE_AWCACHE AFFECTS_GENERATION false
set_parameter_property USE_AWCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_AWCACHE HDL_PARAMETER true

add_parameter USE_AWQOS INTEGER 1 "Enable AWQOS signal"
set_parameter_property USE_AWQOS DEFAULT_VALUE 1
set_parameter_property USE_AWQOS DISPLAY_NAME USE_AWQOS
set_parameter_property USE_AWQOS WIDTH ""
set_parameter_property USE_AWQOS TYPE INTEGER
set_parameter_property USE_AWQOS UNITS None
set_parameter_property USE_AWQOS DESCRIPTION "Enable AWQOS signal"
set_parameter_property USE_AWQOS AFFECTS_GENERATION false
set_parameter_property USE_AWQOS DISPLAY_HINT "boolean"
set_parameter_property USE_AWQOS HDL_PARAMETER true

add_parameter USE_WSTRB INTEGER 1 "Enable WSTRB signal"
set_parameter_property USE_WSTRB DEFAULT_VALUE 1
set_parameter_property USE_WSTRB DISPLAY_NAME USE_WSTRB
set_parameter_property USE_WSTRB WIDTH ""
set_parameter_property USE_WSTRB TYPE INTEGER
set_parameter_property USE_WSTRB UNITS None
set_parameter_property USE_WSTRB DESCRIPTION "Enable WSTRB signal"
set_parameter_property USE_WSTRB AFFECTS_GENERATION false
set_parameter_property USE_WSTRB DISPLAY_HINT "boolean"
set_parameter_property USE_WSTRB HDL_PARAMETER true

add_parameter USE_BID INTEGER 1 "Enable BID signal"
set_parameter_property USE_BID DEFAULT_VALUE 1
set_parameter_property USE_BID DISPLAY_NAME USE_BID
set_parameter_property USE_BID WIDTH ""
set_parameter_property USE_BID TYPE INTEGER
set_parameter_property USE_BID UNITS None
set_parameter_property USE_BID DESCRIPTION "Enable BID signal"
set_parameter_property USE_BID AFFECTS_GENERATION false
set_parameter_property USE_BID DISPLAY_HINT "boolean"
set_parameter_property USE_BID HDL_PARAMETER true

add_parameter USE_BRESP INTEGER 1 "Enable BRESP signal"
set_parameter_property USE_BRESP DEFAULT_VALUE 1
set_parameter_property USE_BRESP DISPLAY_NAME USE_BRESP
set_parameter_property USE_BRESP WIDTH ""
set_parameter_property USE_BRESP TYPE INTEGER
set_parameter_property USE_BRESP UNITS None
set_parameter_property USE_BRESP DESCRIPTION "Enable BRESP signal"
set_parameter_property USE_BRESP AFFECTS_GENERATION false
set_parameter_property USE_BRESP DISPLAY_HINT "boolean"
set_parameter_property USE_BRESP HDL_PARAMETER true

add_parameter USE_ARID INTEGER 1 "Enable ARID signal"
set_parameter_property USE_ARID DEFAULT_VALUE 1
set_parameter_property USE_ARID DISPLAY_NAME USE_ARID
set_parameter_property USE_ARID WIDTH ""
set_parameter_property USE_ARID TYPE INTEGER
set_parameter_property USE_ARID UNITS None
set_parameter_property USE_ARID DESCRIPTION "Enable ARID signal"
set_parameter_property USE_ARID AFFECTS_GENERATION false
set_parameter_property USE_ARID DISPLAY_HINT "boolean"
set_parameter_property USE_ARID HDL_PARAMETER true

add_parameter USE_ARREGION INTEGER 1 "Enable ARREGION signal"
set_parameter_property USE_ARREGION DEFAULT_VALUE 1
set_parameter_property USE_ARREGION DISPLAY_NAME USE_ARREGION
set_parameter_property USE_ARREGION WIDTH ""
set_parameter_property USE_ARREGION TYPE INTEGER
set_parameter_property USE_ARREGION UNITS None
set_parameter_property USE_ARREGION DESCRIPTION "Enable ARREGION signal"
set_parameter_property USE_ARREGION AFFECTS_GENERATION false
set_parameter_property USE_ARREGION DISPLAY_HINT "boolean"
set_parameter_property USE_ARREGION HDL_PARAMETER true

add_parameter USE_ARLEN INTEGER 1 "Enable ARLEN signal"
set_parameter_property USE_ARLEN DEFAULT_VALUE 1
set_parameter_property USE_ARLEN DISPLAY_NAME USE_ARLEN
set_parameter_property USE_ARLEN WIDTH ""
set_parameter_property USE_ARLEN TYPE INTEGER
set_parameter_property USE_ARLEN UNITS None
set_parameter_property USE_ARLEN DESCRIPTION "Enable ARLEN signal"
set_parameter_property USE_ARLEN AFFECTS_GENERATION false
set_parameter_property USE_ARLEN DISPLAY_HINT "boolean"
set_parameter_property USE_ARLEN HDL_PARAMETER true

add_parameter USE_ARSIZE INTEGER 1 "Enable ARSIZE signal"
set_parameter_property USE_ARSIZE DEFAULT_VALUE 1
set_parameter_property USE_ARSIZE DISPLAY_NAME USE_ARSIZE
set_parameter_property USE_ARSIZE WIDTH ""
set_parameter_property USE_ARSIZE TYPE INTEGER
set_parameter_property USE_ARSIZE UNITS None
set_parameter_property USE_ARSIZE DESCRIPTION "Enable ARSIZE signal"
set_parameter_property USE_ARSIZE AFFECTS_GENERATION false
set_parameter_property USE_ARSIZE DISPLAY_HINT "boolean"
set_parameter_property USE_ARSIZE HDL_PARAMETER true

add_parameter USE_ARBURST INTEGER 1 "Enable ARBURST signal"
set_parameter_property USE_ARBURST DEFAULT_VALUE 1
set_parameter_property USE_ARBURST DISPLAY_NAME USE_ARBURST
set_parameter_property USE_ARBURST WIDTH ""
set_parameter_property USE_ARBURST TYPE INTEGER
set_parameter_property USE_ARBURST UNITS None
set_parameter_property USE_ARBURST DESCRIPTION "Enable ARBURST signal"
set_parameter_property USE_ARBURST AFFECTS_GENERATION false
set_parameter_property USE_ARBURST DISPLAY_HINT "boolean"
set_parameter_property USE_ARBURST HDL_PARAMETER true

add_parameter USE_ARLOCK INTEGER 1 "Enable ARLOCK signal"
set_parameter_property USE_ARLOCK DEFAULT_VALUE 1
set_parameter_property USE_ARLOCK DISPLAY_NAME USE_ARLOCK
set_parameter_property USE_ARLOCK WIDTH ""
set_parameter_property USE_ARLOCK TYPE INTEGER
set_parameter_property USE_ARLOCK UNITS None
set_parameter_property USE_ARLOCK DESCRIPTION "Enable ARLOCK signal"
set_parameter_property USE_ARLOCK AFFECTS_GENERATION false
set_parameter_property USE_ARLOCK DISPLAY_HINT "boolean"
set_parameter_property USE_ARLOCK HDL_PARAMETER true

add_parameter USE_ARCACHE INTEGER 1 "Enable ARCACHE signal"
set_parameter_property USE_ARCACHE DEFAULT_VALUE 1
set_parameter_property USE_ARCACHE DISPLAY_NAME USE_ARCACHE
set_parameter_property USE_ARCACHE WIDTH ""
set_parameter_property USE_ARCACHE TYPE INTEGER
set_parameter_property USE_ARCACHE UNITS None
set_parameter_property USE_ARCACHE DESCRIPTION "Enable ARCACHE signal"
set_parameter_property USE_ARCACHE AFFECTS_GENERATION false
set_parameter_property USE_ARCACHE DISPLAY_HINT "boolean"
set_parameter_property USE_ARCACHE HDL_PARAMETER true

add_parameter USE_ARQOS INTEGER 1 "Enable ARQOS signal"
set_parameter_property USE_ARQOS DEFAULT_VALUE 1
set_parameter_property USE_ARQOS DISPLAY_NAME USE_ARQOS
set_parameter_property USE_ARQOS WIDTH ""
set_parameter_property USE_ARQOS TYPE INTEGER
set_parameter_property USE_ARQOS UNITS None
set_parameter_property USE_ARQOS DESCRIPTION "Enable ARQOS signal"
set_parameter_property USE_ARQOS AFFECTS_GENERATION false
set_parameter_property USE_ARQOS DISPLAY_HINT "boolean"
set_parameter_property USE_ARQOS HDL_PARAMETER true

add_parameter USE_RID INTEGER 1 "Enable RID signal"
set_parameter_property USE_RID DEFAULT_VALUE 1
set_parameter_property USE_RID DISPLAY_NAME USE_RID
set_parameter_property USE_RID WIDTH ""
set_parameter_property USE_RID TYPE INTEGER
set_parameter_property USE_RID UNITS None
set_parameter_property USE_RID DESCRIPTION "Enable RID signal"
set_parameter_property USE_RID AFFECTS_GENERATION false
set_parameter_property USE_RID DISPLAY_HINT "boolean"
set_parameter_property USE_RID HDL_PARAMETER true

add_parameter USE_RRESP INTEGER 1 "Enable RRESP signal"
set_parameter_property USE_RRESP DEFAULT_VALUE 1
set_parameter_property USE_RRESP DISPLAY_NAME USE_RRESP
set_parameter_property USE_RRESP WIDTH ""
set_parameter_property USE_RRESP TYPE INTEGER
set_parameter_property USE_RRESP UNITS None
set_parameter_property USE_RRESP DESCRIPTION "Enable RRESP signal"
set_parameter_property USE_RRESP AFFECTS_GENERATION false
set_parameter_property USE_RRESP DISPLAY_HINT "boolean"
set_parameter_property USE_RRESP HDL_PARAMETER true

add_parameter USE_RLAST INTEGER 1 "Enable RLAST signal"
set_parameter_property USE_RLAST DEFAULT_VALUE 1
set_parameter_property USE_RLAST DISPLAY_NAME USE_RLAST
set_parameter_property USE_RLAST WIDTH ""
set_parameter_property USE_RLAST TYPE INTEGER
set_parameter_property USE_RLAST UNITS None
set_parameter_property USE_RLAST DESCRIPTION "Enable RLAST signal"
set_parameter_property USE_RLAST AFFECTS_GENERATION false
set_parameter_property USE_RLAST DISPLAY_HINT "boolean"
set_parameter_property USE_RLAST HDL_PARAMETER true

add_parameter USE_AWUSER INTEGER 1 "Enable AWUSER signal"
set_parameter_property USE_AWUSER DEFAULT_VALUE 1
set_parameter_property USE_AWUSER DISPLAY_NAME USE_AWUSER
set_parameter_property USE_AWUSER WIDTH ""
set_parameter_property USE_AWUSER TYPE INTEGER
set_parameter_property USE_AWUSER UNITS None
set_parameter_property USE_AWUSER DESCRIPTION "Enable AWUSER signal"
set_parameter_property USE_AWUSER AFFECTS_GENERATION false
set_parameter_property USE_AWUSER DISPLAY_HINT "boolean"
set_parameter_property USE_AWUSER HDL_PARAMETER true

add_parameter USE_ARUSER INTEGER 1 "Enable ARUSER signal"
set_parameter_property USE_ARUSER DEFAULT_VALUE 1
set_parameter_property USE_ARUSER DISPLAY_NAME USE_ARUSER
set_parameter_property USE_ARUSER WIDTH ""
set_parameter_property USE_ARUSER TYPE INTEGER
set_parameter_property USE_ARUSER UNITS None
set_parameter_property USE_ARUSER DESCRIPTION "Enable ARUSER signal"
set_parameter_property USE_ARUSER AFFECTS_GENERATION false
set_parameter_property USE_ARUSER DISPLAY_HINT "boolean"
set_parameter_property USE_ARUSER HDL_PARAMETER true

add_parameter USE_WUSER INTEGER 1 "Enable WUSER signal"
set_parameter_property USE_WUSER DEFAULT_VALUE 1
set_parameter_property USE_WUSER DISPLAY_NAME USE_WUSER
set_parameter_property USE_WUSER WIDTH ""
set_parameter_property USE_WUSER TYPE INTEGER
set_parameter_property USE_WUSER UNITS None
set_parameter_property USE_WUSER DESCRIPTION "Enable WUSER signal"
set_parameter_property USE_WUSER AFFECTS_GENERATION false
set_parameter_property USE_WUSER DISPLAY_HINT "boolean"
set_parameter_property USE_WUSER HDL_PARAMETER true

add_parameter USE_RUSER INTEGER 1 "Enable RUSER signal"
set_parameter_property USE_RUSER DEFAULT_VALUE 1
set_parameter_property USE_RUSER DISPLAY_NAME USE_RUSER
set_parameter_property USE_RUSER WIDTH ""
set_parameter_property USE_RUSER TYPE INTEGER
set_parameter_property USE_RUSER UNITS None
set_parameter_property USE_RUSER DESCRIPTION "Enable RUSER signal"
set_parameter_property USE_RUSER AFFECTS_GENERATION false
set_parameter_property USE_RUSER DISPLAY_HINT "boolean"
set_parameter_property USE_RUSER HDL_PARAMETER true

add_parameter USE_BUSER INTEGER 1 "Enable BUSER signal"
set_parameter_property USE_BUSER DEFAULT_VALUE 1
set_parameter_property USE_BUSER DISPLAY_NAME USE_BUSER
set_parameter_property USE_BUSER WIDTH ""
set_parameter_property USE_BUSER TYPE INTEGER
set_parameter_property USE_BUSER UNITS None
set_parameter_property USE_BUSER DESCRIPTION "Enable BUSER signal"
set_parameter_property USE_BUSER AFFECTS_GENERATION false
set_parameter_property USE_BUSER DISPLAY_HINT "boolean"
set_parameter_property USE_BUSER HDL_PARAMETER true

# |
# +-----------------------------------

# +-----------------------------------
# | display items
# |
# +-----------------------------------

# +-----------------------------------
# | connection point altera_axi4_master
# |
add_interface          altera_axi4_master axi4 start
set_interface_property altera_axi4_master associatedClock clock_sink
set_interface_property altera_axi4_master associatedReset reset_sink
set_interface_property altera_axi4_master ENABLED true

add_interface_port altera_axi4_master AWVALID    awvalid    Output 1
add_interface_port altera_axi4_master AWPROT     awprot     Output 3
add_interface_port altera_axi4_master AWREGION   awregion   Output 4
add_interface_port altera_axi4_master AWLEN      awlen      Output 8
add_interface_port altera_axi4_master AWSIZE     awsize     Output 3
add_interface_port altera_axi4_master AWBURST    awburst    Output 2
add_interface_port altera_axi4_master AWLOCK     awlock     Output 1
add_interface_port altera_axi4_master AWCACHE    awcache    Output 4
add_interface_port altera_axi4_master AWQOS      awqos      Output 4
add_interface_port altera_axi4_master AWREADY    awready    Input  1
add_interface_port altera_axi4_master ARVALID    arvalid    Output 1
add_interface_port altera_axi4_master ARPROT     arprot     Output 3
add_interface_port altera_axi4_master ARREGION   arregion   Output 4
add_interface_port altera_axi4_master ARLEN      arlen      Output 8
add_interface_port altera_axi4_master ARSIZE     arsize     Output 3
add_interface_port altera_axi4_master ARBURST    arburst    Output 2
add_interface_port altera_axi4_master ARLOCK     arlock     Output 1
add_interface_port altera_axi4_master ARCACHE    arcache    Output 4
add_interface_port altera_axi4_master ARQOS      arqos      Output 4
add_interface_port altera_axi4_master ARREADY    arready    Input  1
add_interface_port altera_axi4_master RVALID     rvalid     Input  1
add_interface_port altera_axi4_master RRESP      rresp      Input  2
add_interface_port altera_axi4_master RLAST      rlast      Input  1
add_interface_port altera_axi4_master RREADY     rready     Output 1
add_interface_port altera_axi4_master WVALID     wvalid     Output 1
add_interface_port altera_axi4_master WLAST      wlast      Output 1
add_interface_port altera_axi4_master WREADY     wready     Input  1
add_interface_port altera_axi4_master BVALID     bvalid     Input  1
add_interface_port altera_axi4_master BRESP      bresp      Input  2
add_interface_port altera_axi4_master BREADY     bready     Output 1
# |
# +-----------------------------------

set_module_property ELABORATION_CALLBACK my_elaborate

proc my_elaborate {} {
  set AXI4_ADDRESS_WIDTH   [get_parameter_value AXI4_ADDRESS_WIDTH]
  set AXI4_RDATA_WIDTH     [get_parameter_value AXI4_RDATA_WIDTH]
  set AXI4_WDATA_WIDTH     [get_parameter_value AXI4_WDATA_WIDTH]
  set AXI4_ID_WIDTH        [get_parameter_value AXI4_ID_WIDTH]
  set AXI4_USER_WIDTH      [get_parameter_value AXI4_USER_WIDTH]
  set AXI4_REGION_MAP_SIZE [get_parameter_value AXI4_REGION_MAP_SIZE]
  set READ_ISSUING_CAPABILITY         [ get_parameter_value READ_ISSUING_CAPABILITY ]
  set WRITE_ISSUING_CAPABILITY        [ get_parameter_value WRITE_ISSUING_CAPABILITY ]
  set COMBINED_ISSUING_CAPABILITY     [ get_parameter_value COMBINED_ISSUING_CAPABILITY ]

  set_interface_property altera_axi4_master readIssuingCapability $READ_ISSUING_CAPABILITY
  set_interface_property altera_axi4_master writeIssuingCapability $WRITE_ISSUING_CAPABILITY
  set_interface_property altera_axi4_master combinedIssuingCapability $COMBINED_ISSUING_CAPABILITY

  add_interface_port altera_axi4_master AWADDR     awaddr     Output $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4_master AWID       awid       Output $AXI4_ID_WIDTH
  add_interface_port altera_axi4_master AWUSER     awuser     Output $AXI4_USER_WIDTH
  add_interface_port altera_axi4_master ARADDR     araddr     Output $AXI4_ADDRESS_WIDTH
  add_interface_port altera_axi4_master ARID       arid       Output $AXI4_ID_WIDTH
  add_interface_port altera_axi4_master ARUSER     aruser     Output $AXI4_USER_WIDTH
  add_interface_port altera_axi4_master RUSER      ruser      Input  $AXI4_USER_WIDTH
  add_interface_port altera_axi4_master WUSER      wuser      Output $AXI4_USER_WIDTH
  add_interface_port altera_axi4_master BUSER      buser      Input  $AXI4_USER_WIDTH
  add_interface_port altera_axi4_master RDATA      rdata      Input  $AXI4_RDATA_WIDTH
  add_interface_port altera_axi4_master RID        rid        Input  $AXI4_ID_WIDTH
  add_interface_port altera_axi4_master WDATA      wdata      Output $AXI4_WDATA_WIDTH
  add_interface_port altera_axi4_master WSTRB      wstrb      Output [ expr ($AXI4_WDATA_WIDTH / 8) ]
  add_interface_port altera_axi4_master BID        bid        Input  $AXI4_ID_WIDTH

  set use_wuser [ get_parameter_value USE_WUSER ]
  set use_buser [ get_parameter_value USE_BUSER ]
  set use_ruser [ get_parameter_value USE_RUSER ]
  set use_awuser [ get_parameter_value USE_AWUSER ]
  set use_aruser [ get_parameter_value USE_ARUSER ]
  set use_awid      [ get_parameter_value USE_AWID ]
  set use_awsize    [ get_parameter_value USE_AWSIZE ]
  set use_awburst   [ get_parameter_value USE_AWBURST ]
  set use_awlen     [ get_parameter_value USE_AWLEN ]
  set use_awregion  [ get_parameter_value USE_AWREGION ]
  set use_awlock    [ get_parameter_value USE_AWLOCK ]
  set use_awcache   [ get_parameter_value USE_AWCACHE ]
  set use_awqos     [ get_parameter_value USE_AWQOS ]
  set use_arid      [ get_parameter_value USE_ARID ]
  set use_arregion  [ get_parameter_value USE_ARREGION ]
  set use_arsize    [ get_parameter_value USE_ARSIZE ]
  set use_arburst   [ get_parameter_value USE_ARBURST ]
  set use_arlen     [ get_parameter_value USE_ARLEN ]
  set use_arlock    [ get_parameter_value USE_ARLOCK ]
  set use_arcache   [ get_parameter_value USE_ARCACHE ]
  set use_arqos     [ get_parameter_value USE_ARQOS ]
  set use_wstrb     [ get_parameter_value USE_WSTRB ]
  set use_bid       [ get_parameter_value USE_BID ]
  set use_bresp     [ get_parameter_value USE_BRESP ]
  set use_rid       [ get_parameter_value USE_RID ]
  set use_rresp     [ get_parameter_value USE_RRESP ]
  set use_rlast     [ get_parameter_value USE_RLAST ]
  if {$use_wuser == 0} {
      set_port_property WUSER TERMINATION true
  }
  if {$use_buser == 0} {
      set_port_property BUSER TERMINATION true
  }
  if {$use_ruser == 0} {
      set_port_property RUSER TERMINATION true
  }
  if {$use_awuser == 0} {
      set_port_property AWUSER TERMINATION true
  }
  if {$use_aruser == 0} {
      set_port_property ARUSER TERMINATION true
  }
  if {$use_awid == 0} {
      set_port_property AWID TERMINATION true
  }
  if {$use_awregion == 0} {
      set_port_property AWREGION TERMINATION true
  }
  if {$use_awsize == 0} {
      set_port_property AWSIZE TERMINATION true
  }
  if {$use_awlen == 0} {
      set_port_property AWLEN TERMINATION true
  }
  if {$use_awburst == 0} {
      set_port_property AWBURST TERMINATION true
  }
  if {$use_awlock == 0} {
      set_port_property AWLOCK TERMINATION true
  }
  if {$use_awcache == 0} {
      set_port_property AWCACHE TERMINATION true
  }
  if {$use_awqos == 0} {
      set_port_property AWQOS TERMINATION true
  }
  if {$use_wstrb == 0} {
      set_port_property WSTRB TERMINATION true
  }
  if {$use_bid == 0} {
      set_port_property BID TERMINATION true
  }
  if {$use_bresp == 0} {
      set_port_property BRESP TERMINATION true
  }
  if {$use_arid == 0} {
      set_port_property ARID TERMINATION true
  }
  if {$use_arregion == 0} {
      set_port_property ARREGION TERMINATION true
  }
  if {$use_arsize == 0} {
      set_port_property ARSIZE TERMINATION true
  }
  if {$use_arlen == 0} {
      set_port_property ARLEN TERMINATION true
  }
  if {$use_arburst == 0} {
      set_port_property ARBURST TERMINATION true
  }
  if {$use_arlock == 0} {
      set_port_property ARLOCK TERMINATION true
  }
  if {$use_arcache == 0} {
      set_port_property ARCACHE TERMINATION true
  }
  if {$use_arqos == 0} {
      set_port_property ARQOS TERMINATION true
  }
  if {$use_rid == 0} {
      set_port_property RID TERMINATION true
  }
  if {$use_rresp == 0} {
      set_port_property RRESP TERMINATION true
  }
  if {$use_rlast == 0} {
      set_port_property RLAST TERMINATION true
  }
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
