# Generated TCL File
# DO NOT MODIFY

# +-----------------------------------
# |
# | mgc_axi4stream_inline_monitor_bfm "MGC AXI4STREAM Inline Monitor BFM" 10.4c
# | Mentor Graphics 16.1
# | AXI4STREAM Inline Monitor BFM
# |
# | ./mgc_axi4stream_inline_monitor.sv sim
# |
# +-----------------------------------

# +-----------------------------------
# | Request TCL Packages.
package require -exact qsys 14.0
# |
# +-----------------------------------

# +-----------------------------------
# | module mgc_axi4stream_inline_monitor
# |
set_module_property DESCRIPTION        "Mentor Graphics AXI4STREAM Inline Monitor BFM (Altera Edition)"
set_module_property NAME               mgc_axi4stream_inline_monitor
set_module_property VERSION            10.4.3.0
set_module_property AUTHOR             "Mentor Graphics Corporation"
set_module_property ICON_PATH          "../../common/Mentor_VIP_AE_icon.png"
set_module_property DISPLAY_NAME       "Mentor Graphics AXI4STREAM Inline Monitor BFM (Altera Edition)"
set_module_property GROUP              "Verification/Simulation"
set_module_property EDITABLE           false
# |
# +-----------------------------------

# +-----------------------------------
# | files
# |
add_fileset          sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog top_level   mgc_axi4stream_inline_monitor

add_fileset          sim_vhdl    SIM_VHDL    proc_sim_vhdl
set_fileset_property sim_vhdl    top_level   mgc_axi4stream_inline_monitor_vhd

proc proc_sim_verilog { name } {
}

proc proc_sim_vhdl { name } {
}

# |
# +-----------------------------------

# +-----------------------------------
# | Documentation links
# |
add_documentation_link "AXI4STREAM Inline Monitor BFM Reference Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/mentor-vip-axi4-stream-ae-usr.pdf
# |
# +-----------------------------------

# +-----------------------------------
# | Parameters
# |
add_parameter          AXI4_ID_WIDTH INTEGER 8
set_parameter_property AXI4_ID_WIDTH DISPLAY_NAME      "AXI4_ID_WIDTH"
set_parameter_property AXI4_ID_WIDTH DESCRIPTION       "The width of the <TID> signal (AXI4 Data Stream Identifier Width) (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)."
set_parameter_property AXI4_ID_WIDTH ALLOWED_RANGES     1:8
set_parameter_property AXI4_ID_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_USER_WIDTH INTEGER 8
set_parameter_property AXI4_USER_WIDTH DISPLAY_NAME      "AXI4_USER_WIDTH"
set_parameter_property AXI4_USER_WIDTH DESCRIPTION       "The width of the <TUSER> signal (AXI4 User Defined Sideband signal Width) (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)."
set_parameter_property AXI4_USER_WIDTH ALLOWED_RANGES     1:8
set_parameter_property AXI4_USER_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_DEST_WIDTH INTEGER 18
set_parameter_property AXI4_DEST_WIDTH DISPLAY_NAME      "AXI4_DEST_WIDTH"
set_parameter_property AXI4_DEST_WIDTH DESCRIPTION       "The width of the <TDEST> signal (Width of signal which provides AXI4 data stream routing information) (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)."
set_parameter_property AXI4_DEST_WIDTH ALLOWED_RANGES     1:18
set_parameter_property AXI4_DEST_WIDTH HDL_PARAMETER      true

add_parameter          AXI4_DATA_WIDTH INTEGER 1024
set_parameter_property AXI4_DATA_WIDTH DISPLAY_NAME      "AXI4_DATA_WIDTH"
set_parameter_property AXI4_DATA_WIDTH DESCRIPTION       "The width of the <TDATA> signal (AXI4 Payload Data Width) (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)."
set_parameter_property AXI4_DATA_WIDTH ALLOWED_RANGES     1:1024
set_parameter_property AXI4_DATA_WIDTH HDL_PARAMETER      true

add_parameter          index INTEGER 0
set_parameter_property index DISPLAY_NAME       "VHDL BFM instance ID"
set_parameter_property index DESCRIPTION        "The parameter 'index' is used to uniquely indentify VHDL BFM instances. It must be set to a different value for each VHDL BFM in the system. It is ignored for Verilog BFM instances"
set_parameter_property index ALLOWED_RANGES     0:1023
set_parameter_property index HDL_PARAMETER      true

# |
# +-----------------------------------

# +-----------------------------------
# | display items
# |
# +-----------------------------------

# +-----------------------------------
# | connection point altera_axi4stream_master and altera_axi4stream_slave
# |
add_interface          altera_axi4stream_master axi4stream start
set_interface_property altera_axi4stream_master associatedClock clock_sink
set_interface_property altera_axi4stream_master associatedReset reset_sink
set_interface_property altera_axi4stream_master ENABLED true

add_interface_port altera_axi4stream_master master_TVALID     tvalid     Output 1
add_interface_port altera_axi4stream_master master_TLAST      tlast      Output 1
add_interface_port altera_axi4stream_master master_TREADY     tready     Input  1

add_interface          altera_axi4stream_slave axi4stream end
set_interface_property altera_axi4stream_slave associatedClock clock_sink
set_interface_property altera_axi4stream_slave associatedReset reset_sink
set_interface_property altera_axi4stream_slave ENABLED true

add_interface_port altera_axi4stream_slave slave_TVALID     tvalid     Input  1
add_interface_port altera_axi4stream_slave slave_TLAST      tlast      Input  1
add_interface_port altera_axi4stream_slave slave_TREADY     tready     Output 1
# |
# +-----------------------------------

set_module_property ELABORATION_CALLBACK my_elaborate

proc my_elaborate {} {
  set AXI4_ID_WIDTH        [get_parameter_value AXI4_ID_WIDTH]
  set AXI4_USER_WIDTH      [get_parameter_value AXI4_USER_WIDTH]
  set AXI4_DEST_WIDTH      [get_parameter_value AXI4_DEST_WIDTH]
  set AXI4_DATA_WIDTH      [get_parameter_value AXI4_DATA_WIDTH]

  add_interface_port altera_axi4stream_master master_TDATA      tdata      Output $AXI4_DATA_WIDTH
  add_interface_port altera_axi4stream_master master_TSTRB      tstrb      Output [ expr ($AXI4_DATA_WIDTH / 8) ]
  add_interface_port altera_axi4stream_master master_TKEEP      tkeep      Output [ expr ($AXI4_DATA_WIDTH / 8) ]
  add_interface_port altera_axi4stream_master master_TID        tid        Output $AXI4_ID_WIDTH
  add_interface_port altera_axi4stream_master master_TUSER      tuser      Output $AXI4_USER_WIDTH
  add_interface_port altera_axi4stream_master master_TDEST      tdest      Output $AXI4_DEST_WIDTH

  add_interface_port altera_axi4stream_slave slave_TDATA      tdata      Input  $AXI4_DATA_WIDTH
  add_interface_port altera_axi4stream_slave slave_TSTRB      tstrb      Input  [ expr ($AXI4_DATA_WIDTH / 8) ]
  add_interface_port altera_axi4stream_slave slave_TKEEP      tkeep      Input  [ expr ($AXI4_DATA_WIDTH / 8) ]
  add_interface_port altera_axi4stream_slave slave_TID        tid        Input  $AXI4_ID_WIDTH
  add_interface_port altera_axi4stream_slave slave_TUSER      tuser      Input  $AXI4_USER_WIDTH
  add_interface_port altera_axi4stream_slave slave_TDEST      tdest      Input  $AXI4_DEST_WIDTH
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
