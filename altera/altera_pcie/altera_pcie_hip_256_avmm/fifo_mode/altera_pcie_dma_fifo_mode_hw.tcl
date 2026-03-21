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


# altera_pcie_dma_fifo_mode "Avalon-MM DMA FIFO Mode Component for PCI Express" v1.0
# Altera Corporation 2014.08.05.10:32:35
# Avalon-MM DMA FIFO Mode Component for PCI Express
#

#
# request TCL package from ACDS 14.1
#
package require -exact qsys 14.1


#
# module altera_pcie_dma_fifo_mode
#
set_module_property DESCRIPTION "Avalon-MM DMA FIFO Mode IP Core for PCI Express"
set_module_property NAME altera_pcie_dma_fifo_mode
set_module_property VERSION 18.1
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Interface Protocols/PCI Express/QSYS Example Designs"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon-MM DMA FIFO Mode IP Core for PCI Express"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix V" "Arria V" "Cyclone V" "Arria V GZ" "Arria 10"}
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property HIDE_FROM_QUARTUS true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL true
add_interface no_connect conduit end

#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altpcieav_fifo_mode
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altpcieav_fifo_mode.v VERILOG PATH altpcieav_fifo_mode.v TOP_LEVEL_FILE
add_fileset_file altpcieav_fifo_rd.v VERILOG PATH altpcieav_fifo_rd.v
add_fileset_file altpcieav_fifo_wr.v VERILOG PATH altpcieav_fifo_wr.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altpcieav_fifo_mode
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altpcieav_fifo_mode.v VERILOG PATH altpcieav_fifo_mode.v
add_fileset_file altpcieav_fifo_rd.v VERILOG PATH altpcieav_fifo_rd.v
add_fileset_file altpcieav_fifo_wr.v VERILOG PATH altpcieav_fifo_wr.v


#
# documentation links
#
add_documentation_link "Avalon-MM DMA FIFO" http://www.altera.com/literature/ug/ug_dma_fifo.pdf
#
# parameters
#
add_parameter TXS_MODE INTEGER 0
set_parameter_property TXS_MODE DEFAULT_VALUE 0
set_parameter_property TXS_MODE DISPLAY_NAME TXS_MODE
set_parameter_property TXS_MODE TYPE INTEGER
set_parameter_property TXS_MODE UNITS None
set_parameter_property TXS_MODE ALLOWED_RANGES "0,1"
set_parameter_property TXS_MODE HDL_PARAMETER true
set_parameter_property TXS_MODE VISIBLE false
add_parameter DMA_WIDTH INTEGER 256
set_parameter_property DMA_WIDTH DEFAULT_VALUE 256
set_parameter_property DMA_WIDTH DISPLAY_NAME DMA_WIDTH
set_parameter_property DMA_WIDTH TYPE INTEGER
set_parameter_property DMA_WIDTH UNITS None
set_parameter_property DMA_WIDTH ALLOWED_RANGES "128,256"
set_parameter_property DMA_WIDTH HDL_PARAMETER true
set_parameter_property DMA_WIDTH VISIBLE false
add_parameter DMA_BRST_CNT_W INTEGER 5
set_parameter_property DMA_BRST_CNT_W DEFAULT_VALUE 5
set_parameter_property DMA_BRST_CNT_W DISPLAY_NAME DMA_BRST_CNT_W
set_parameter_property DMA_BRST_CNT_W TYPE INTEGER
set_parameter_property DMA_BRST_CNT_W UNITS None
set_parameter_property DMA_BRST_CNT_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DMA_BRST_CNT_W HDL_PARAMETER true
set_parameter_property DMA_BRST_CNT_W VISIBLE false
add_parameter DMA_BE_WIDTH INTEGER 32
set_parameter_property DMA_BE_WIDTH DEFAULT_VALUE 32
set_parameter_property DMA_BE_WIDTH DISPLAY_NAME DMA_BE_WIDTH
set_parameter_property DMA_BE_WIDTH TYPE INTEGER
set_parameter_property DMA_BE_WIDTH UNITS None
set_parameter_property DMA_BE_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DMA_BE_WIDTH HDL_PARAMETER true
set_parameter_property DMA_BE_WIDTH VISIBLE false
add_parameter RXDATA_WIDTH INTEGER 160
set_parameter_property RXDATA_WIDTH DEFAULT_VALUE 160
set_parameter_property RXDATA_WIDTH DISPLAY_NAME RXDATA_WIDTH
set_parameter_property RXDATA_WIDTH TYPE INTEGER
set_parameter_property RXDATA_WIDTH UNITS None
set_parameter_property RXDATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RXDATA_WIDTH HDL_PARAMETER true
set_parameter_property RXDATA_WIDTH VISIBLE false


#
# display items
#


#
# connection point avmm_wr_dma_slave
#
proc add_avmm_wr_dma_slave {} {
add_interface avmm_wr_dma_slave avalon end
set_interface_property avmm_wr_dma_slave addressUnits SYMBOLS
set_interface_property avmm_wr_dma_slave associatedClock clk_i
set_interface_property avmm_wr_dma_slave associatedReset rstn_i
set_interface_property avmm_wr_dma_slave bitsPerSymbol 8
set_interface_property avmm_wr_dma_slave burstOnBurstBoundariesOnly false
set_interface_property avmm_wr_dma_slave burstcountUnits WORDS
set_interface_property avmm_wr_dma_slave explicitAddressSpan 0
set_interface_property avmm_wr_dma_slave holdTime 0
set_interface_property avmm_wr_dma_slave linewrapBursts false
set_interface_property avmm_wr_dma_slave maximumPendingReadTransactions 1
set_interface_property avmm_wr_dma_slave maximumPendingWriteTransactions 0
set_interface_property avmm_wr_dma_slave readLatency 0
set_interface_property avmm_wr_dma_slave readWaitTime 1
set_interface_property avmm_wr_dma_slave setupTime 0
set_interface_property avmm_wr_dma_slave timingUnits Cycles
set_interface_property avmm_wr_dma_slave writeWaitTime 0
set_interface_property avmm_wr_dma_slave ENABLED true
set_interface_property avmm_wr_dma_slave EXPORT_OF ""
set_interface_property avmm_wr_dma_slave PORT_NAME_MAP ""
set_interface_property avmm_wr_dma_slave CMSIS_SVD_VARIABLES ""
set_interface_property avmm_wr_dma_slave SVD_ADDRESS_GROUP ""

add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_read_i read Input 1
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_address_i address Input 64
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_burst_count_i burstcount Input DMA_BRST_CNT_W
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_chip_select_i chipselect Input 1
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_wait_request_o waitrequest Output 1
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_read_data_valid_o readdatavalid Output 1
add_interface_port avmm_wr_dma_slave avmm_wr_dma_slave_read_data_o readdata Output DMA_WIDTH
set_interface_assignment avmm_wr_dma_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avmm_wr_dma_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm_wr_dma_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm_wr_dma_slave embeddedsw.configuration.isPrintableDevice 0
}

#
# connection point avmm_rd_dma_slave
#
proc add_avmm_rd_dma_slave {} {
add_interface avmm_rd_dma_slave avalon end
set_interface_property avmm_rd_dma_slave addressUnits SYMBOLS
set_interface_property avmm_rd_dma_slave associatedClock clk_i
set_interface_property avmm_rd_dma_slave associatedReset rstn_i
set_interface_property avmm_rd_dma_slave bitsPerSymbol 8
set_interface_property avmm_rd_dma_slave burstOnBurstBoundariesOnly false
set_interface_property avmm_rd_dma_slave burstcountUnits WORDS
set_interface_property avmm_rd_dma_slave explicitAddressSpan 0
set_interface_property avmm_rd_dma_slave holdTime 0
set_interface_property avmm_rd_dma_slave linewrapBursts false
set_interface_property avmm_rd_dma_slave maximumPendingReadTransactions 0
set_interface_property avmm_rd_dma_slave maximumPendingWriteTransactions 0
set_interface_property avmm_rd_dma_slave readLatency 0
set_interface_property avmm_rd_dma_slave readWaitTime 1
set_interface_property avmm_rd_dma_slave setupTime 0
set_interface_property avmm_rd_dma_slave timingUnits Cycles
set_interface_property avmm_rd_dma_slave writeWaitTime 0
set_interface_property avmm_rd_dma_slave ENABLED true
set_interface_property avmm_rd_dma_slave EXPORT_OF ""
set_interface_property avmm_rd_dma_slave PORT_NAME_MAP ""
set_interface_property avmm_rd_dma_slave CMSIS_SVD_VARIABLES ""
set_interface_property avmm_rd_dma_slave SVD_ADDRESS_GROUP ""

add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_write_i write Input 1
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_address_i address Input 64
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_write_data_i writedata Input DMA_WIDTH
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_chip_select_i chipselect Input 1
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_wait_request_o waitrequest Output 1
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_burst_count_i burstcount Input DMA_BRST_CNT_W
add_interface_port avmm_rd_dma_slave avmm_rd_dma_slave_byte_enable_i byteenable Input DMA_BE_WIDTH
set_interface_assignment avmm_rd_dma_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avmm_rd_dma_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm_rd_dma_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm_rd_dma_slave embeddedsw.configuration.isPrintableDevice 0
}

#
# connection point avmm_tx_slave
#
proc add_avmm_tx_slave {} {


set TXS_MODE [ get_parameter_value TXS_MODE ]
set DMA_WIDTH [ get_parameter_value DMA_WIDTH ]
set DMA_BRST_CNT_W [ get_parameter_value DMA_BRST_CNT_W ]
set DMA_BE_WIDTH [ get_parameter_value DMA_BE_WIDTH ]


if { $TXS_MODE == 1 } {
add_interface avmm_tx_slave avalon end
#set_interface_property avmm_tx_slave addressUnits WORDS
set_interface_property avmm_tx_slave associatedClock clk_i
set_interface_property avmm_tx_slave associatedReset rstn_i
set_interface_property avmm_tx_slave bitsPerSymbol 8
set_interface_property avmm_tx_slave burstOnBurstBoundariesOnly false
#set_interface_property avmm_tx_slave burstcountUnits WORDS
set_interface_property avmm_tx_slave explicitAddressSpan 0
set_interface_property avmm_tx_slave holdTime 0
set_interface_property avmm_tx_slave linewrapBursts false
set_interface_property avmm_tx_slave maximumPendingReadTransactions 1
set_interface_property avmm_tx_slave maximumPendingWriteTransactions 0
set_interface_property avmm_tx_slave readLatency 0
set_interface_property avmm_tx_slave readWaitTime 1
set_interface_property avmm_tx_slave setupTime 0
set_interface_property avmm_tx_slave timingUnits Cycles
set_interface_property avmm_tx_slave writeWaitTime 0
set_interface_property avmm_tx_slave ENABLED true
set_interface_property avmm_tx_slave EXPORT_OF ""
set_interface_property avmm_tx_slave PORT_NAME_MAP ""
set_interface_property avmm_tx_slave CMSIS_SVD_VARIABLES ""
set_interface_property avmm_tx_slave SVD_ADDRESS_GROUP ""
add_interface_port avmm_tx_slave avmm_tx_slave_read_i read Input 1
add_interface_port avmm_tx_slave avmm_tx_slave_write_i write Input 1
add_interface_port avmm_tx_slave avmm_tx_slave_address_i address Input 64
add_interface_port avmm_tx_slave avmm_tx_slave_write_data_i writedata Input DMA_WIDTH
add_interface_port avmm_tx_slave avmm_tx_slave_burst_count_i burstcount Input DMA_BRST_CNT_W
add_interface_port avmm_tx_slave avmm_tx_slave_wait_request_o waitrequest Output 1
add_interface_port avmm_tx_slave avmm_tx_slave_read_data_valid_o readdatavalid Output 1
add_interface_port avmm_tx_slave avmm_tx_slave_read_data_o readdata Output DMA_WIDTH
add_interface_port avmm_tx_slave avmm_tx_slave_byte_enable_i byteenable Input DMA_BE_WIDTH
set_interface_assignment avmm_tx_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avmm_tx_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm_tx_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm_tx_slave embeddedsw.configuration.isPrintableDevice 0
} else {
  add_to_no_connect            avmm_tx_slave_read_i 1 Input
  add_to_no_connect            avmm_tx_slave_write_i 1 Input
  add_to_no_connect            avmm_tx_slave_address_i 64 Input
  add_to_no_connect            avmm_tx_slave_write_data_i $DMA_WIDTH Input
  add_to_no_connect            avmm_tx_slave_burst_count_i $DMA_BRST_CNT_W Input
  add_to_no_connect            avmm_tx_slave_wait_request_o 1 Output
  add_to_no_connect            avmm_tx_slave_read_data_valid_o 1 Output
  add_to_no_connect            avmm_tx_slave_read_data_o $DMA_WIDTH Output
  add_to_no_connect            avmm_tx_slave_byte_enable_i $DMA_BE_WIDTH Input
}
}

#
# connection point ast_wr_dma_desc_tx
#
proc add_ast_wr_dma_desc_tx {} {

set RXDATA_WIDTH [ get_parameter_value RXDATA_WIDTH ]
add_interface ast_wr_dma_desc_tx avalon_streaming start
set_interface_property ast_wr_dma_desc_tx associatedClock clk_i
set_interface_property ast_wr_dma_desc_tx associatedReset rstn_i
set_interface_property ast_wr_dma_desc_tx dataBitsPerSymbol $RXDATA_WIDTH
set_interface_property ast_wr_dma_desc_tx errorDescriptor ""
set_interface_property ast_wr_dma_desc_tx firstSymbolInHighOrderBits true
set_interface_property ast_wr_dma_desc_tx maxChannel 0
set_interface_property ast_wr_dma_desc_tx readyLatency 3
set_interface_property ast_wr_dma_desc_tx ENABLED true
set_interface_property ast_wr_dma_desc_tx EXPORT_OF ""
set_interface_property ast_wr_dma_desc_tx PORT_NAME_MAP ""
set_interface_property ast_wr_dma_desc_tx CMSIS_SVD_VARIABLES ""
set_interface_property ast_wr_dma_desc_tx SVD_ADDRESS_GROUP ""

add_interface_port ast_wr_dma_desc_tx ast_wr_dma_desc_tx_data_o data Output RXDATA_WIDTH
add_interface_port ast_wr_dma_desc_tx ast_wr_dma_desc_tx_ready_i ready Input 1
add_interface_port ast_wr_dma_desc_tx ast_wr_dma_desc_tx_valid_o valid Output 1
}

#
# connection point ast_wr_dma_desc_rx
#
proc add_ast_wr_dma_desc_rx {} {
add_interface ast_wr_dma_desc_rx avalon_streaming end
set_interface_property ast_wr_dma_desc_rx associatedClock clk_i
set_interface_property ast_wr_dma_desc_rx associatedReset rstn_i
set_interface_property ast_wr_dma_desc_rx dataBitsPerSymbol 32
set_interface_property ast_wr_dma_desc_rx errorDescriptor ""
set_interface_property ast_wr_dma_desc_rx firstSymbolInHighOrderBits true
set_interface_property ast_wr_dma_desc_rx maxChannel 0
set_interface_property ast_wr_dma_desc_rx readyLatency 0
set_interface_property ast_wr_dma_desc_rx ENABLED true
set_interface_property ast_wr_dma_desc_rx EXPORT_OF ""
set_interface_property ast_wr_dma_desc_rx PORT_NAME_MAP ""
set_interface_property ast_wr_dma_desc_rx CMSIS_SVD_VARIABLES ""
set_interface_property ast_wr_dma_desc_rx SVD_ADDRESS_GROUP ""

add_interface_port ast_wr_dma_desc_rx ast_wr_dma_desc_rx_data_i data Input 32
add_interface_port ast_wr_dma_desc_rx ast_wr_dma_desc_rx_valid_i valid Input 1
}

#
# connection point ast_rd_dma_desc_tx
#
proc add_ast_rd_dma_desc_tx {} {
set RXDATA_WIDTH [ get_parameter_value RXDATA_WIDTH ]
add_interface ast_rd_dma_desc_tx avalon_streaming start
set_interface_property ast_rd_dma_desc_tx associatedClock clk_i
set_interface_property ast_rd_dma_desc_tx associatedReset rstn_i
set_interface_property ast_rd_dma_desc_tx dataBitsPerSymbol $RXDATA_WIDTH
set_interface_property ast_rd_dma_desc_tx errorDescriptor ""
set_interface_property ast_rd_dma_desc_tx firstSymbolInHighOrderBits true
set_interface_property ast_rd_dma_desc_tx maxChannel 0
set_interface_property ast_rd_dma_desc_tx readyLatency 3
set_interface_property ast_rd_dma_desc_tx ENABLED true
set_interface_property ast_rd_dma_desc_tx EXPORT_OF ""
set_interface_property ast_rd_dma_desc_tx PORT_NAME_MAP ""
set_interface_property ast_rd_dma_desc_tx CMSIS_SVD_VARIABLES ""
set_interface_property ast_rd_dma_desc_tx SVD_ADDRESS_GROUP ""

add_interface_port ast_rd_dma_desc_tx ast_rd_dma_desc_tx_data_o data Output RXDATA_WIDTH
add_interface_port ast_rd_dma_desc_tx ast_rd_dma_desc_tx_valid_o valid Output 1
add_interface_port ast_rd_dma_desc_tx ast_rd_dma_desc_tx_ready_i ready Input 1
}

#
# connection point ast_rd_dma_desc_rx
#
proc add_ast_rd_dma_desc_rx {} {
add_interface ast_rd_dma_desc_rx avalon_streaming end
set_interface_property ast_rd_dma_desc_rx associatedClock clk_i
set_interface_property ast_rd_dma_desc_rx associatedReset rstn_i
set_interface_property ast_rd_dma_desc_rx dataBitsPerSymbol 32
set_interface_property ast_rd_dma_desc_rx errorDescriptor ""
set_interface_property ast_rd_dma_desc_rx firstSymbolInHighOrderBits true
set_interface_property ast_rd_dma_desc_rx maxChannel 0
set_interface_property ast_rd_dma_desc_rx readyLatency 0
set_interface_property ast_rd_dma_desc_rx ENABLED true
set_interface_property ast_rd_dma_desc_rx EXPORT_OF ""
set_interface_property ast_rd_dma_desc_rx PORT_NAME_MAP ""
set_interface_property ast_rd_dma_desc_rx CMSIS_SVD_VARIABLES ""
set_interface_property ast_rd_dma_desc_rx SVD_ADDRESS_GROUP ""

add_interface_port ast_rd_dma_desc_rx ast_rd_dma_desc_rx_data_i data Input 32
add_interface_port ast_rd_dma_desc_rx ast_rd_dma_desc_rx_valid_i valid Input 1
}

#
# connection point ast_wr_fifo_ctrl_tx
#
proc add_ast_wr_fifo_ctrl_tx {} {
add_interface ast_wr_fifo_ctrl_tx avalon_streaming start
set_interface_property ast_wr_fifo_ctrl_tx associatedClock clk_i
set_interface_property ast_wr_fifo_ctrl_tx associatedReset rstn_i
set_interface_property ast_wr_fifo_ctrl_tx dataBitsPerSymbol 8
set_interface_property ast_wr_fifo_ctrl_tx errorDescriptor ""
set_interface_property ast_wr_fifo_ctrl_tx firstSymbolInHighOrderBits true
set_interface_property ast_wr_fifo_ctrl_tx maxChannel 0
set_interface_property ast_wr_fifo_ctrl_tx readyLatency 0
set_interface_property ast_wr_fifo_ctrl_tx ENABLED true
set_interface_property ast_wr_fifo_ctrl_tx EXPORT_OF ""
set_interface_property ast_wr_fifo_ctrl_tx PORT_NAME_MAP ""
set_interface_property ast_wr_fifo_ctrl_tx CMSIS_SVD_VARIABLES ""
set_interface_property ast_wr_fifo_ctrl_tx SVD_ADDRESS_GROUP ""

add_interface_port ast_wr_fifo_ctrl_tx ast_wr_fifo_ctrl_tx_desc_status_data_o data Output 32
add_interface_port ast_wr_fifo_ctrl_tx ast_wr_fifo_ctrl_tx_desc_status_valid_o valid Output 1
}

#
# connection point ast_rd_fifo_ctrl_tx
#
proc add_ast_rd_fifo_ctrl_tx {} {
add_interface ast_rd_fifo_ctrl_tx avalon_streaming start
set_interface_property ast_rd_fifo_ctrl_tx associatedClock clk_i
set_interface_property ast_rd_fifo_ctrl_tx associatedReset rstn_i
set_interface_property ast_rd_fifo_ctrl_tx dataBitsPerSymbol 8
set_interface_property ast_rd_fifo_ctrl_tx errorDescriptor ""
set_interface_property ast_rd_fifo_ctrl_tx firstSymbolInHighOrderBits true
set_interface_property ast_rd_fifo_ctrl_tx maxChannel 0
set_interface_property ast_rd_fifo_ctrl_tx readyLatency 0
set_interface_property ast_rd_fifo_ctrl_tx ENABLED true
set_interface_property ast_rd_fifo_ctrl_tx EXPORT_OF ""
set_interface_property ast_rd_fifo_ctrl_tx PORT_NAME_MAP ""
set_interface_property ast_rd_fifo_ctrl_tx CMSIS_SVD_VARIABLES ""
set_interface_property ast_rd_fifo_ctrl_tx SVD_ADDRESS_GROUP ""

add_interface_port ast_rd_fifo_ctrl_tx ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o data Output 32
add_interface_port ast_rd_fifo_ctrl_tx ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o valid Output 1
}

#
# connection point ast_wr_fifo_data_rx
#
proc add_ast_wr_fifo_data_rx {} {
add_interface ast_wr_fifo_data_rx avalon_streaming end
set_interface_property ast_wr_fifo_data_rx associatedClock clk_i
set_interface_property ast_wr_fifo_data_rx associatedReset rstn_i
set_interface_property ast_wr_fifo_data_rx dataBitsPerSymbol 8
set_interface_property ast_wr_fifo_data_rx errorDescriptor ""
set_interface_property ast_wr_fifo_data_rx firstSymbolInHighOrderBits true
set_interface_property ast_wr_fifo_data_rx maxChannel 0
set_interface_property ast_wr_fifo_data_rx readyLatency 0
set_interface_property ast_wr_fifo_data_rx ENABLED true
set_interface_property ast_wr_fifo_data_rx EXPORT_OF ""
set_interface_property ast_wr_fifo_data_rx PORT_NAME_MAP ""
set_interface_property ast_wr_fifo_data_rx CMSIS_SVD_VARIABLES ""
set_interface_property ast_wr_fifo_data_rx SVD_ADDRESS_GROUP ""

add_interface_port ast_wr_fifo_data_rx ast_wr_fifo_data_rx_ready_o ready Output 1
add_interface_port ast_wr_fifo_data_rx ast_wr_fifo_data_rx_data_i data Input DMA_WIDTH
add_interface_port ast_wr_fifo_data_rx ast_wr_fifo_data_rx_valid_i valid Input 1
}

#
# connection point ast_rd_fifo_data_tx
#
proc add_ast_rd_fifo_data_tx {} {
add_interface ast_rd_fifo_data_tx avalon_streaming start
set_interface_property ast_rd_fifo_data_tx associatedClock clk_i
set_interface_property ast_rd_fifo_data_tx associatedReset rstn_i
set_interface_property ast_rd_fifo_data_tx dataBitsPerSymbol 8
set_interface_property ast_rd_fifo_data_tx errorDescriptor ""
set_interface_property ast_rd_fifo_data_tx firstSymbolInHighOrderBits true
set_interface_property ast_rd_fifo_data_tx maxChannel 0
set_interface_property ast_rd_fifo_data_tx readyLatency 3
set_interface_property ast_rd_fifo_data_tx ENABLED true
set_interface_property ast_rd_fifo_data_tx EXPORT_OF ""
set_interface_property ast_rd_fifo_data_tx PORT_NAME_MAP ""
set_interface_property ast_rd_fifo_data_tx CMSIS_SVD_VARIABLES ""
set_interface_property ast_rd_fifo_data_tx SVD_ADDRESS_GROUP ""

add_interface_port ast_rd_fifo_data_tx ast_rd_fifo_data_tx_ready_i ready Input 1
add_interface_port ast_rd_fifo_data_tx ast_rd_fifo_data_tx_data_w_dword_valid_o data Output DMA_WIDTH+8
add_interface_port ast_rd_fifo_data_tx ast_rd_fifo_data_tx_valid_o valid Output 1
}

#
# connection point ast_wr_fifo_desc_rx
#
proc add_ast_wr_fifo_desc_rx {} {
add_interface ast_wr_fifo_desc_rx avalon_streaming end
set_interface_property ast_wr_fifo_desc_rx associatedClock clk_i
set_interface_property ast_wr_fifo_desc_rx associatedReset rstn_i
set_interface_property ast_wr_fifo_desc_rx dataBitsPerSymbol 8
set_interface_property ast_wr_fifo_desc_rx errorDescriptor ""
set_interface_property ast_wr_fifo_desc_rx firstSymbolInHighOrderBits true
set_interface_property ast_wr_fifo_desc_rx maxChannel 0
set_interface_property ast_wr_fifo_desc_rx readyLatency 0
set_interface_property ast_wr_fifo_desc_rx ENABLED true
set_interface_property ast_wr_fifo_desc_rx EXPORT_OF ""
set_interface_property ast_wr_fifo_desc_rx PORT_NAME_MAP ""
set_interface_property ast_wr_fifo_desc_rx CMSIS_SVD_VARIABLES ""
set_interface_property ast_wr_fifo_desc_rx SVD_ADDRESS_GROUP ""

add_interface_port ast_wr_fifo_desc_rx ast_wr_fifo_desc_rx_data_i data Input RXDATA_WIDTH
add_interface_port ast_wr_fifo_desc_rx ast_wr_fifo_desc_rx_valid_i valid Input 1
add_interface_port ast_wr_fifo_desc_rx ast_wr_fifo_desc_rx_ready_o ready Output 1
}

#
# connection point ast_rd_fifo_desc_rx
#
proc add_ast_rd_fifo_desc_rx {} {
add_interface ast_rd_fifo_desc_rx avalon_streaming end
set_interface_property ast_rd_fifo_desc_rx associatedClock clk_i
set_interface_property ast_rd_fifo_desc_rx associatedReset rstn_i
set_interface_property ast_rd_fifo_desc_rx dataBitsPerSymbol 8
set_interface_property ast_rd_fifo_desc_rx errorDescriptor ""
set_interface_property ast_rd_fifo_desc_rx firstSymbolInHighOrderBits true
set_interface_property ast_rd_fifo_desc_rx maxChannel 0
set_interface_property ast_rd_fifo_desc_rx readyLatency 0
set_interface_property ast_rd_fifo_desc_rx ENABLED true
set_interface_property ast_rd_fifo_desc_rx EXPORT_OF ""
set_interface_property ast_rd_fifo_desc_rx PORT_NAME_MAP ""
set_interface_property ast_rd_fifo_desc_rx CMSIS_SVD_VARIABLES ""
set_interface_property ast_rd_fifo_desc_rx SVD_ADDRESS_GROUP ""

add_interface_port ast_rd_fifo_desc_rx ast_rd_fifo_desc_rx_data_i data Input RXDATA_WIDTH
add_interface_port ast_rd_fifo_desc_rx ast_rd_fifo_desc_rx_valid_i valid Input 1
add_interface_port ast_rd_fifo_desc_rx ast_rd_fifo_desc_rx_ready_o ready Output 1
}

#
# connection point clk_i
#
proc add_clk_i {} {
add_interface clk_i clock end
set_interface_property clk_i clockRate 0
set_interface_property clk_i ENABLED true
set_interface_property clk_i EXPORT_OF ""
set_interface_property clk_i PORT_NAME_MAP ""
set_interface_property clk_i CMSIS_SVD_VARIABLES ""
set_interface_property clk_i SVD_ADDRESS_GROUP ""

add_interface_port clk_i Clk_i clk Input 1
}

#
# connection point rstn_i
#
proc add_rstn_i {} {
add_interface rstn_i reset end
set_interface_property rstn_i associatedClock clk_i
set_interface_property rstn_i synchronousEdges DEASSERT
set_interface_property rstn_i ENABLED true
set_interface_property rstn_i EXPORT_OF ""
set_interface_property rstn_i PORT_NAME_MAP ""
set_interface_property rstn_i CMSIS_SVD_VARIABLES ""
set_interface_property rstn_i SVD_ADDRESS_GROUP ""

add_interface_port rstn_i Rstn_i reset_n Input 1
}

set_module_property ELABORATION_CALLBACK elaboration_callback

proc elaboration_callback {} {
send_message warning "PRELIMINARY SUPPORT: Component 'Avalon-MM DMA FIFO Mode Component for PCI Express'"
add_avmm_wr_dma_slave
add_avmm_rd_dma_slave
add_avmm_tx_slave
add_ast_wr_dma_desc_tx
add_ast_wr_dma_desc_rx
add_ast_rd_dma_desc_rx
add_ast_rd_dma_desc_tx
add_ast_wr_fifo_ctrl_tx
add_ast_rd_fifo_ctrl_tx
add_ast_wr_fifo_data_rx
add_ast_rd_fifo_data_tx
add_ast_wr_fifo_desc_rx
add_ast_rd_fifo_desc_rx
add_clk_i
add_rstn_i
}

proc add_to_no_connect { signal_name signal_width direction } {
#send_message debug "proc add_to_no_connect $signal_name $signal_width $direction"
   if { [ regexp In $direction ] } {
      add_interface_port no_connect $signal_name $signal_name Input $signal_width
      set_port_property $signal_name TERMINATION true
      set_port_property $signal_name TERMINATION_VALUE 0
   } else {
      add_interface_port no_connect $signal_name $signal_name Output $signal_width
      set_port_property  $signal_name TERMINATION true
   }
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/lbl1411591294497/lbl1411591409707
