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


package require -exact qsys 14.1

set_module_property author "Altera Corporation"
set_module_property display_name "AXI Timeout Bridge"
set_module_property elaboration_callback elaborate
set_module_property group "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property hide_from_quartus true
set_module_property name altera_axi_timeout_bridge
set_module_property version 18.1

set_module_assignment embeddedsw.dts.vendor "altr"
set_module_assignment embeddedsw.dts.name "bridge"
set_module_assignment embeddedsw.dts.group "bridge"
set_module_assignment embeddedsw.dts.compatible "simple-bus"

add_parameter ID_WIDTH integer 1 "The width of awid, bid, arid or rid."
set_parameter_property ID_WIDTH allowed_ranges 1:64
set_parameter_property ID_WIDTH display_name "ID width"
set_parameter_property ID_WIDTH hdl_parameter true

add_parameter ADDRESS_WIDTH integer 4 "The width of awaddr or araddr."
set_parameter_property ADDRESS_WIDTH allowed_ranges 1:64
set_parameter_property ADDRESS_WIDTH display_name "Address width"
set_parameter_property ADDRESS_WIDTH hdl_parameter true

add_parameter DATA_WIDTH integer 8 "The width of wdata or rdata."
set_parameter_property DATA_WIDTH allowed_ranges {8 16 32 64 128 256 512 1024}
set_parameter_property DATA_WIDTH display_name "Data width"
set_parameter_property DATA_WIDTH hdl_parameter true

add_parameter USER_WIDTH integer 1 "The width of awuser, wuser, buser, aruser or ruser."
set_parameter_property USER_WIDTH allowed_ranges 1:64
set_parameter_property USER_WIDTH display_name "User width"
set_parameter_property USER_WIDTH hdl_parameter true

add_parameter MAX_OUTSTANDING_WRITES integer 1 "The maximum number of outstanding writes the bridge should expect."
set_parameter_property MAX_OUTSTANDING_WRITES allowed_ranges 1:64
set_parameter_property MAX_OUTSTANDING_WRITES display_name "Maximum number of outstanding writes"
set_parameter_property MAX_OUTSTANDING_WRITES hdl_parameter true

add_parameter MAX_OUTSTANDING_READS integer 1 "The maximum number of outstanding reads the bridge should expect."
set_parameter_property MAX_OUTSTANDING_READS allowed_ranges 1:64
set_parameter_property MAX_OUTSTANDING_READS display_name "Maximum number of outstanding reads"
set_parameter_property MAX_OUTSTANDING_READS hdl_parameter true

add_parameter MAX_CYCLES integer 256 "The number of cycles within which a burst must complete."
set_parameter_property MAX_CYCLES allowed_ranges 256:65536
set_parameter_property MAX_CYCLES display_name "Maximum number of cycles"
set_parameter_property MAX_CYCLES hdl_parameter true

add_fileset quartus_synth quartus_synth quartus_synth
set_fileset_property quartus_synth top_level altera_axi_timeout_bridge

add_fileset sim_verilog sim_verilog quartus_synth
set_fileset_property sim_verilog top_level altera_axi_timeout_bridge

proc quartus_synth {name} {
    # #todo Find out the correct way to add `altera_avalon_sc_fifo`.
    add_fileset_file altera_avalon_sc_fifo.v system_verilog path $::env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/altera_avalon_sc_fifo/altera_avalon_sc_fifo.v
    add_fileset_file altera_axi_timeout_bridge.sv system_verilog path altera_axi_timeout_bridge.sv
}

proc elaborate {} {
    # Clock.
    add_interface clock clock sink

    add_interface_port clock clk clk input 1

    # Reset.
    add_interface reset reset sink
    set_interface_property reset associatedClock clock

    add_interface_port reset reset reset input 1

    # Slave.
    add_interface slave axi4 slave
    set_interface_property slave associatedClock clock
    set_interface_property slave associatedReset reset
    set_interface_property slave writeAcceptanceCapability [get_parameter_value MAX_OUTSTANDING_WRITES]
    set_interface_property slave readAcceptanceCapability [get_parameter_value MAX_OUTSTANDING_READS]
    # #todo Why does `combinedAcceptanceCapability` have an upper limit of 16?
    set_interface_property slave combinedAcceptanceCapability [expr min([get_parameter_value MAX_OUTSTANDING_WRITES] + [get_parameter_value MAX_OUTSTANDING_READS], 16)]
    set_interface_property slave bridgesToMaster master

    add_interface_port slave s_awid awid input [get_parameter_value ID_WIDTH]
    add_interface_port slave s_awaddr awaddr input [get_parameter_value ADDRESS_WIDTH]
    add_interface_port slave s_awlen awlen input 8
    add_interface_port slave s_awsize awsize input 3
    add_interface_port slave s_awburst awburst input 2
    add_interface_port slave s_awlock awlock input 1
    add_interface_port slave s_awcache awcache input 4
    add_interface_port slave s_awprot awprot input 3
    add_interface_port slave s_awqos awqos input 4
    add_interface_port slave s_awregion awregion input 4
    add_interface_port slave s_awuser awuser input [get_parameter_value USER_WIDTH]
    add_interface_port slave s_awvalid awvalid input 1
    add_interface_port slave s_awready awready output 1

    add_interface_port slave s_wdata wdata input [get_parameter_value DATA_WIDTH]
    add_interface_port slave s_wstrb wstrb input [expr [get_parameter_value DATA_WIDTH] / 8]
    add_interface_port slave s_wlast wlast input 1
    add_interface_port slave s_wuser wuser input [get_parameter_value USER_WIDTH]
    add_interface_port slave s_wvalid wvalid input 1
    add_interface_port slave s_wready wready output 1

    add_interface_port slave s_bid bid output [get_parameter_value ID_WIDTH]
    add_interface_port slave s_bresp bresp output 2
    add_interface_port slave s_buser buser output [get_parameter_value USER_WIDTH]
    add_interface_port slave s_bvalid bvalid output 1
    add_interface_port slave s_bready bready input 1

    add_interface_port slave s_arid arid input [get_parameter_value ID_WIDTH]
    add_interface_port slave s_araddr araddr input [get_parameter_value ADDRESS_WIDTH]
    add_interface_port slave s_arlen arlen input 8
    add_interface_port slave s_arsize arsize input 3
    add_interface_port slave s_arburst arburst input 2
    add_interface_port slave s_arlock arlock input 1
    add_interface_port slave s_arcache arcache input 4
    add_interface_port slave s_arprot arprot input 3
    add_interface_port slave s_arqos arqos input 4
    add_interface_port slave s_arregion arregion input 4
    add_interface_port slave s_aruser aruser input [get_parameter_value USER_WIDTH]
    add_interface_port slave s_arvalid arvalid input 1
    add_interface_port slave s_arready arready output 1

    add_interface_port slave s_rid rid output [get_parameter_value ID_WIDTH]
    add_interface_port slave s_rdata rdata output [get_parameter_value DATA_WIDTH]
    add_interface_port slave s_rresp rresp output 2
    add_interface_port slave s_rlast rlast output 1
    add_interface_port slave s_ruser ruser output [get_parameter_value USER_WIDTH]
    add_interface_port slave s_rvalid rvalid output 1
    add_interface_port slave s_rready rready input 1

    # Master.
    add_interface master axi4 master
    set_interface_property master associatedClock clock
    set_interface_property master associatedReset reset
    set_interface_property master writeIssuingCapability [get_parameter_value MAX_OUTSTANDING_WRITES]
    set_interface_property master readIssuingCapability [get_parameter_value MAX_OUTSTANDING_READS]
    # #todo Why does `combinedIssuingCapability` have an upper limit of 16?
    set_interface_property master combinedIssuingCapability [expr min([get_parameter_value MAX_OUTSTANDING_WRITES] + [get_parameter_value MAX_OUTSTANDING_READS], 16)]

    add_interface_port master m_awid awid output [get_parameter_value ID_WIDTH]
    add_interface_port master m_awaddr awaddr output [get_parameter_value ADDRESS_WIDTH]
    add_interface_port master m_awlen awlen output 8
    add_interface_port master m_awsize awsize output 3
    add_interface_port master m_awburst awburst output 2
    add_interface_port master m_awlock awlock output 1
    add_interface_port master m_awcache awcache output 4
    add_interface_port master m_awprot awprot output 3
    add_interface_port master m_awqos awqos output 4
    add_interface_port master m_awregion awregion output 4
    add_interface_port master m_awuser awuser output [get_parameter_value USER_WIDTH]
    add_interface_port master m_awvalid awvalid output 1
    add_interface_port master m_awready awready input 1

    add_interface_port master m_wdata wdata output [get_parameter_value DATA_WIDTH]
    add_interface_port master m_wstrb wstrb output [expr [get_parameter_value DATA_WIDTH] / 8]
    add_interface_port master m_wlast wlast output 1
    add_interface_port master m_wuser wuser output [get_parameter_value USER_WIDTH]
    add_interface_port master m_wvalid wvalid output 1
    add_interface_port master m_wready wready input 1

    add_interface_port master m_bid bid input [get_parameter_value ID_WIDTH]
    add_interface_port master m_bresp bresp input 2
    add_interface_port master m_buser buser input [get_parameter_value USER_WIDTH]
    add_interface_port master m_bvalid bvalid input 1
    add_interface_port master m_bready bready output 1

    add_interface_port master m_arid arid output [get_parameter_value ID_WIDTH]
    add_interface_port master m_araddr araddr output [get_parameter_value ADDRESS_WIDTH]
    add_interface_port master m_arlen arlen output 8
    add_interface_port master m_arsize arsize output 3
    add_interface_port master m_arburst arburst output 2
    add_interface_port master m_arlock arlock output 1
    add_interface_port master m_arcache arcache output 4
    add_interface_port master m_arprot arprot output 3
    add_interface_port master m_arqos arqos output 4
    add_interface_port master m_arregion arregion output 4
    add_interface_port master m_aruser aruser output [get_parameter_value USER_WIDTH]
    add_interface_port master m_arvalid arvalid output 1
    add_interface_port master m_arready arready input 1

    add_interface_port master m_rid rid input [get_parameter_value ID_WIDTH]
    add_interface_port master m_rdata rdata input [get_parameter_value DATA_WIDTH]
    add_interface_port master m_rresp rresp input 2
    add_interface_port master m_rlast rlast input 1
    add_interface_port master m_ruser ruser input [get_parameter_value USER_WIDTH]
    add_interface_port master m_rvalid rvalid input 1
    add_interface_port master m_rready rready output 1

    # CSR.
    add_interface csr axi4lite slave
    set_interface_property csr associatedClock clock
    set_interface_property csr associatedReset reset

    add_interface_port csr csr_awaddr awaddr input 4
    add_interface_port csr csr_awprot awprot input 3
    add_interface_port csr csr_awvalid awvalid input 1
    add_interface_port csr csr_awready awready output 1

    add_interface_port csr csr_wdata wdata input 32
    add_interface_port csr csr_wstrb wstrb input 4
    add_interface_port csr csr_wvalid wvalid input 1
    add_interface_port csr csr_wready wready output 1

    add_interface_port csr csr_bresp bresp output 2
    add_interface_port csr csr_bvalid bvalid output 1
    add_interface_port csr csr_bready bready input 1

    add_interface_port csr csr_araddr araddr input 4
    add_interface_port csr csr_arprot arprot input 3
    add_interface_port csr csr_arvalid arvalid input 1
    add_interface_port csr csr_arready arready output 1

    add_interface_port csr csr_rdata rdata output 32
    add_interface_port csr csr_rresp rresp output 2
    add_interface_port csr csr_rvalid rvalid output 1
    add_interface_port csr csr_rready rready input 1

    # Interrupt.
    add_interface interrupt interrupt sender

    add_interface_port interrupt irq irq output 1
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959313611
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1416836145555/hco1416836653221
