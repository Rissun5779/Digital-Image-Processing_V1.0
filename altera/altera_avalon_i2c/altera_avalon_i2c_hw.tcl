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


package require -exact qsys 15.0

# 
# module altera_avalon_i2c
# 
set_module_property DESCRIPTION "I2C Core with Avalon MM Slave Interface for configuration"
set_module_property NAME altera_avalon_i2c
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Interface Protocols/Serial"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Avalon I2C (Master) Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_QUARTUS true
set_module_property ELABORATION_CALLBACK "elaborate"
set_module_property VALIDATION_CALLBACK "validate"

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_avalon_i2c
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_avalon_i2c.v VERILOG PATH altera_avalon_i2c.v TOP_LEVEL_FILE
add_fileset_file altera_avalon_i2c_csr.v VERILOG PATH altera_avalon_i2c_csr.v
add_fileset_file altera_avalon_i2c_clk_cnt.v VERILOG PATH altera_avalon_i2c_clk_cnt.v
add_fileset_file altera_avalon_i2c_condt_det.v VERILOG PATH altera_avalon_i2c_condt_det.v
add_fileset_file altera_avalon_i2c_condt_gen.v VERILOG PATH altera_avalon_i2c_condt_gen.v
add_fileset_file altera_avalon_i2c_fifo.v VERILOG PATH altera_avalon_i2c_fifo.v
add_fileset_file altera_avalon_i2c_mstfsm.v VERILOG PATH altera_avalon_i2c_mstfsm.v
add_fileset_file altera_avalon_i2c_rxshifter.v VERILOG PATH altera_avalon_i2c_rxshifter.v
add_fileset_file altera_avalon_i2c_txshifter.v VERILOG PATH altera_avalon_i2c_txshifter.v
add_fileset_file altera_avalon_i2c_spksupp.v VERILOG PATH altera_avalon_i2c_spksupp.v
add_fileset_file altera_avalon_i2c_txout.v VERILOG PATH altera_avalon_i2c_txout.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_avalon_i2c
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_avalon_i2c.v VERILOG PATH altera_avalon_i2c.v TOP_LEVEL_FILE
add_fileset_file altera_avalon_i2c_csr.v VERILOG PATH altera_avalon_i2c_csr.v
add_fileset_file altera_avalon_i2c_clk_cnt.v VERILOG PATH altera_avalon_i2c_clk_cnt.v
add_fileset_file altera_avalon_i2c_condt_det.v VERILOG PATH altera_avalon_i2c_condt_det.v
add_fileset_file altera_avalon_i2c_condt_gen.v VERILOG PATH altera_avalon_i2c_condt_gen.v
add_fileset_file altera_avalon_i2c_fifo.v VERILOG PATH altera_avalon_i2c_fifo.v
add_fileset_file altera_avalon_i2c_mstfsm.v VERILOG PATH altera_avalon_i2c_mstfsm.v
add_fileset_file altera_avalon_i2c_rxshifter.v VERILOG PATH altera_avalon_i2c_rxshifter.v
add_fileset_file altera_avalon_i2c_txshifter.v VERILOG PATH altera_avalon_i2c_txshifter.v
add_fileset_file altera_avalon_i2c_spksupp.v VERILOG PATH altera_avalon_i2c_spksupp.v
add_fileset_file altera_avalon_i2c_txout.v VERILOG PATH altera_avalon_i2c_txout.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL altera_avalon_i2c
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_avalon_i2c.v VERILOG PATH altera_avalon_i2c.v TOP_LEVEL_FILE
add_fileset_file altera_avalon_i2c_csr.v VERILOG PATH altera_avalon_i2c_csr.v
add_fileset_file altera_avalon_i2c_clk_cnt.v VERILOG PATH altera_avalon_i2c_clk_cnt.v
add_fileset_file altera_avalon_i2c_condt_det.v VERILOG PATH altera_avalon_i2c_condt_det.v
add_fileset_file altera_avalon_i2c_condt_gen.v VERILOG PATH altera_avalon_i2c_condt_gen.v
add_fileset_file altera_avalon_i2c_fifo.v VERILOG PATH altera_avalon_i2c_fifo.v
add_fileset_file altera_avalon_i2c_mstfsm.v VERILOG PATH altera_avalon_i2c_mstfsm.v
add_fileset_file altera_avalon_i2c_rxshifter.v VERILOG PATH altera_avalon_i2c_rxshifter.v
add_fileset_file altera_avalon_i2c_txshifter.v VERILOG PATH altera_avalon_i2c_txshifter.v
add_fileset_file altera_avalon_i2c_spksupp.v VERILOG PATH altera_avalon_i2c_spksupp.v
add_fileset_file altera_avalon_i2c_txout.v VERILOG PATH altera_avalon_i2c_txout.v


# 
# parameters
# 
add_parameter 		USE_AV_ST INTEGER 0 "User can configure to use either Avalon-MM Slave interface or Avalon-ST interface to access transfer command Fifo and receive data Fifo"
set_parameter_property 	USE_AV_ST DISPLAY_NAME "Interface for transfer command Fifo and receive data Fifo accesses"
set_parameter_property  USE_AV_ST ALLOWED_RANGES {"0: Avalon-MM Slave" "1: Avalon-ST"}
set_parameter_property  USE_AV_ST AFFECTS_ELABORATION true
set_parameter_property  USE_AV_ST AFFECTS_GENERATION true
set_parameter_property 	USE_AV_ST HDL_PARAMETER true

add_parameter 		FIFO_DEPTH INTEGER 4 "Configures the depth of Fifo"
set_parameter_property 	FIFO_DEPTH DISPLAY_NAME "Depth of Fifo"
set_parameter_property  FIFO_DEPTH ALLOWED_RANGES {"4" "8" "16" "32" "64" "128" "256"}
set_parameter_property  FIFO_DEPTH AFFECTS_ELABORATION false
set_parameter_property  FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property  FIFO_DEPTH AFFECTS_VALIDATION true
set_parameter_property 	FIFO_DEPTH HDL_PARAMETER true

add_parameter FIFO_DEPTH_LOG2 INTEGER 2
set_parameter_property  FIFO_DEPTH_LOG2 DERIVED true
set_parameter_property  FIFO_DEPTH_LOG2 AFFECTS_ELABORATION false
set_parameter_property  FIFO_DEPTH_LOG2 AFFECTS_GENERATION false
set_parameter_property  FIFO_DEPTH_LOG2 AFFECTS_VALIDATION true
set_parameter_property  FIFO_DEPTH_LOG2 VISIBLE false
set_parameter_property  FIFO_DEPTH_LOG2 HDL_PARAMETER true

# SYSTEM_INFO parameter to obtain clockrate
add_parameter           clockRate      INTEGER 0
set_parameter_property  clockRate      DISPLAY_NAME {clockRate}
set_parameter_property  clockRate      VISIBLE {0}
set_parameter_property  clockRate      HDL_PARAMETER {0}
set_parameter_property  clockRate      SYSTEM_INFO {CLOCK_RATE clock}
set_parameter_property  clockRate      SYSTEM_INFO_TYPE {CLOCK_RATE}
set_parameter_property  clockRate      SYSTEM_INFO_ARG {clock}


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true

add_interface_port reset_sink rst_n reset_n Input 1


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint "csr"
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset_sink
set_interface_property interrupt_sender ENABLED true

add_interface_port interrupt_sender intr irq Output 1


# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clock
set_interface_property csr associatedReset reset_sink
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 2
set_interface_property csr readWaitTime 0
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr addr address Input 4
add_interface_port csr read read Input 1
add_interface_port csr write write Input 1
add_interface_port csr writedata writedata Input 32
add_interface_port csr readdata readdata Output 32


# 
# connection point I2C serial
# 
add_interface i2c_serial conduit end
set_interface_property i2c_serial ENABLED true

add_interface_port i2c_serial sda_in sda_in Input 1
add_interface_port i2c_serial scl_in scl_in Input 1
add_interface_port i2c_serial sda_oe sda_oe Output 1
add_interface_port i2c_serial scl_oe scl_oe Output 1


# 
# connection point transfer command source
# 
add_interface rx_data_source avalon_streaming start
set_interface_property rx_data_source dataBitsPerSymbol 8
set_interface_property rx_data_source errorDescriptor ""
set_interface_property rx_data_source maxChannel 0
set_interface_property rx_data_source readyLatency 0
set_interface_property rx_data_source symbolsPerBeat 1

set_interface_property rx_data_source ASSOCIATED_CLOCK clock

add_interface_port rx_data_source src_data data Output 8
add_interface_port rx_data_source src_valid valid Output 1
add_interface_port rx_data_source src_ready ready Input 1

# 
# connection point receive data sink
# 
add_interface transfer_command_sink avalon_streaming end
set_interface_property transfer_command_sink dataBitsPerSymbol 8
set_interface_property transfer_command_sink errorDescriptor ""
set_interface_property transfer_command_sink maxChannel 0
set_interface_property transfer_command_sink readyLatency 0
set_interface_property transfer_command_sink symbolsPerBeat 2

set_interface_property transfer_command_sink ASSOCIATED_CLOCK clock

add_interface_port transfer_command_sink snk_data data Input 16
add_interface_port transfer_command_sink snk_valid valid Input 1
add_interface_port transfer_command_sink snk_ready ready Output 1


proc elaborate {} {
    if { [get_parameter_value USE_AV_ST] == 1} {
        set_interface_property transfer_command_sink ENABLED true
        set_interface_property rx_data_source ENABLED true
    } else {
        set_interface_property transfer_command_sink ENABLED false
        set_interface_property rx_data_source ENABLED false
    }
}


proc validate {} {
    set_parameter_value FIFO_DEPTH_LOG2 [ expr { log([get_parameter_value FIFO_DEPTH]) / log(2) } ]
    set_module_assignment embeddedsw.CMacro.FIFO_DEPTH [get_parameter_value FIFO_DEPTH]
    set_module_assignment embeddedsw.CMacro.FREQ [get_parameter_value clockRate]
    set_module_assignment embeddedsw.CMacro.USE_AV_ST [get_parameter_value USE_AV_ST]
}


