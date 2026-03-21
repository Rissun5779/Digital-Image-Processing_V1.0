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


# (C) 2001-2010 Altera Corporation. All rights reserved.
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


# +-----------------------------------
# | 
# | altera_rapidio
# | 
# | $Header: //acds/rel/18.1std/ip/altera_rapidio/src/altera_rapidio_hw.tcl#1 $
# | 
# |   
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 13.1
# | 
   package require -exact qsys 13.1
   package require -exact altera_terp 1.0


# | 
# +-----------------------------------

# +-----------------------------------
# | Source TCL file from PHY IP to determine the reconfig_* ports width
# | 
global env
set qdir $env(QUARTUS_ROOTDIR)
source $qdir/../ip/altera/altera_xcvr_generic/alt_xcvr_common.tcl
# | 
# +-----------------------------------


# +-----------------------------------
# | module altera_rapidio
# | 
set_module_property NAME altera_rapidio
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "RapidIO MegaCore function."
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/RapidIO"
set_module_property DISPLAY_NAME "RapidIO (IDLE1 up to 5.0 Gbaud) Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property HIDE_FROM_SOPC true
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_rapidio.pdf"
set_module_property SUPPORTED_DEVICE_FAMILIES {{Stratix V} {Arria II GX} {Cyclone IV GX} {STRATIX IV} {ARRIA II GZ} {ARRIA V} {CYCLONE V} {ARRIA V GZ} {ARRIA 10}} 


# Declare the callbacks
set_module_property VALIDATION_CALLBACK my_validation_callback   
set_module_property ELABORATION_CALLBACK my_elaboration_callback   

# set_module_property GENERATION_CALLBACK my_generation_callback   
add_fileset synth2 quartus_synth synthproc
add_fileset sim_vhdl sim_vhdl vhdlsimproc
add_fileset sim_verilog sim_verilog verilogsimproc



# +-----------------------------------
# | parameters
# | 

    add_display_item "" "Physical Layer" GROUP "tab"
    add_display_item "Physical Layer" "Device Options" GROUP

    add_parameter "deviceFamily" string "Stratix IV"
    set_parameter_property "deviceFamily" DISPLAY_NAME "Device family"
    set_parameter_property "deviceFamily" SYSTEM_INFO DEVICE_FAMILY
    set_parameter_property "deviceFamily" ALLOWED_RANGES {"Arria II GX" "Cyclone IV GX" "Stratix IV" "Stratix V" "Arria II GZ" "Arria V" "Cyclone V" "Arria V GZ" "Arria 10"}
    set_parameter_property "deviceFamily" HDL_PARAMETER false
    set_parameter_property "deviceFamily" DESCRIPTION "Displays the device family"
    set_parameter_property "deviceFamily" AFFECTS_GENERATION true
    set_parameter_property "deviceFamily" ENABLED 0
    add_display_item "Device Options" "deviceFamily" PARAMETER 

    add_parameter "mode_selection" string "SERIAL_1X"
    set_parameter_property "mode_selection" DISPLAY_NAME "Mode selection"
    set_parameter_property "mode_selection" DESCRIPTION "Selects the RapidIO mode (1x serial port, 2x serial port or 4x serial port)"
    set_parameter_property "mode_selection" ALLOWED_RANGES {"SERIAL_1X:1x serial" "SERIAL_2X:2x serial" "SERIAL_4X:4x serial"}
    add_display_item "Device Options" "mode_selection" PARAMETER 

    add_parameter "phy_selection" string "stratixivgx"
    set_parameter_property "phy_selection" DISPLAY_NAME "Transceiver selection"
    set_parameter_property "phy_selection" DERIVED true
    set_parameter_property "phy_selection" ALLOWED_RANGES {"stratixivgx:Stratix IV GX PHY" "stratixvgx:Stratix V GX PHY" "arriav:Arria V GX PHY" "arriavgz:Arria V GZ PHY" "cyclonev:Cyclone V GX PHY" "arriaiigx:Arria II GX PHY" "cycloneivgx:Cyclone IV GX PHY" "arriaiigz:Arria II GZ PHY" "arria10:Arria 10 PHY"}
    set_parameter_property "phy_selection" DESCRIPTION "Selects the transceiver (must match target device family)"
    set_parameter_property "deviceFamily" ENABLED 0
    add_display_item "Device Options" "phy_selection" PARAMETER 

#    add_parameter "XCVR_RECONFIG" boolean true
#    set_parameter_property "XCVR_RECONFIG" DISPLAY_NAME "Enable transceiver dynamic reconfiguration"
#    set_parameter_property "XCVR_RECONFIG" VISIBLE false 
#    set_parameter_property "XCVR_RECONFIG" DESCRIPTION "Specifies that the IP core instantiates Transceiver Native PHY with dynamic reconfiguration enabled"
#    add_display_item "Device Options" "XCVR_RECONFIG" PARAMETER 
      
    add_parameter "p_SYNC_ACKID" boolean false
    set_parameter_property "p_SYNC_ACKID" DISPLAY_NAME "Automatically synchronize transmitted ackID"
    set_parameter_property "p_SYNC_ACKID" DESCRIPTION "Allows the RapidIO link partner to specify the initial ackID value"
    add_display_item "Device Options" "p_SYNC_ACKID" PARAMETER 

    add_parameter "p_SEND_RESET_DEVICE" boolean false
    set_parameter_property "p_SEND_RESET_DEVICE" DISPLAY_NAME "Send link-request reset-device on fatal errors"
    set_parameter_property "p_SEND_RESET_DEVICE" DESCRIPTION "Specifies whether the IP core responds to fatal errors by transmitting requests to the link partner to reset"
    add_display_item "Device Options" "p_SEND_RESET_DEVICE" PARAMETER 

    add_parameter "p_LINK_REQUEST_ATTEMPTS" integer 7
    set_parameter_property "p_LINK_REQUEST_ATTEMPTS" DISPLAY_NAME "Link request attempts"
    set_parameter_property "p_LINK_REQUEST_ATTEMPTS" ALLOWED_RANGES {1:7}
    set_parameter_property "p_LINK_REQUEST_ATTEMPTS" DESCRIPTION "Specifies the maximum number of times to send a link-request control symbol before declaring a fatal error if no link-response is received."
    add_display_item "Device Options" "p_LINK_REQUEST_ATTEMPTS" PARAMETER 

    add_parameter "p_timeout_enable" boolean true
    set_parameter_property "p_timeout_enable" DISPLAY_NAME "Packet-Not-Accepted to Link Request timeout"
    set_parameter_property "p_timeout_enable" DESCRIPTION "Specifies whether the IP core will go to Fatal Error if it does not receive any Link Request Control Symbol after sending Packet-Not-Accepted Control Symbol and timeout happens"
    add_display_item "Device Options" "p_timeout_enable" PARAMETER 


    add_display_item "Physical Layer" "Data Settings" GROUP

    add_parameter "p_data_rate" integer 2500
    set_parameter_property "p_data_rate" DISPLAY_NAME "Baud rate"
    set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 5000 }
    set_parameter_property "p_data_rate" DISPLAY_UNITS "Mbaud"
    set_parameter_property "p_data_rate" DESCRIPTION "Specifies the RapidIO link baud rate in Mbaud"
    add_display_item "Data Settings" "p_data_rate" PARAMETER 

    add_parameter "p_ref_clk_freq" string "125"
    set_parameter_property "p_ref_clk_freq" DISPLAY_NAME "Reference clock frequency"
    set_parameter_property "p_ref_clk_freq" ALLOWED_RANGES { "50" "62.5" "78.125" "97.65625" "100" "125" "156.25" "195.3125" "200" "250" "312.5" "390.625" "400" "500" }
    set_parameter_property "p_ref_clk_freq" UNITS Megahertz
    set_parameter_property "p_ref_clk_freq" DESCRIPTION "Specifies the reference clock frequency for the transceiver block in MHz"
    add_display_item "Data Settings" "p_ref_clk_freq" PARAMETER 


    add_parameter "p_RXBUFRSIZE" integer 32
    set_parameter_property "p_RXBUFRSIZE" DISPLAY_NAME "Receive buffer size"
    set_parameter_property "p_RXBUFRSIZE" ALLOWED_RANGES { 4 8 16 32 }
    set_parameter_property "p_RXBUFRSIZE" DISPLAY_UNITS "Kbytes" 
    set_parameter_property "p_RXBUFRSIZE" DESCRIPTION "Specifies the size of receive buffer in Kbytes" 
    add_display_item "Data Settings" "p_RXBUFRSIZE" PARAMETER 

    add_parameter "p_TXBUFRSIZE" integer 32
    set_parameter_property "p_TXBUFRSIZE" DISPLAY_NAME "Transmit buffer size"
    set_parameter_property "p_TXBUFRSIZE" ALLOWED_RANGES { 4 8 16 32 }
    set_parameter_property "p_TXBUFRSIZE" DISPLAY_UNITS "Kbytes" 
    set_parameter_property "p_TXBUFRSIZE" DESCRIPTION "Specifies the size of the transmit buffer in Kbytes"  
    add_display_item "Data Settings" "p_TXBUFRSIZE" PARAMETER 

    add_display_item "Data Settings" "Receive Priority Retry Threshold" GROUP

    add_parameter "auto_cfg_rx" boolean true
    set_parameter_property "auto_cfg_rx" DISPLAY_NAME "Auto-configured from receiver buffer size"
    set_parameter_property "auto_cfg_rx" DESCRIPTION "Specifies whether the receive priority retry thresholds are configured automatically based on the receive buffer size; turn on to auto-configure and turn off to specify thresholds manually"
    add_display_item "Receive Priority Retry Threshold" "auto_cfg_rx" PARAMETER 


    add_parameter "p_rx_threshold_0" integer 20
    set_parameter_property "p_rx_threshold_0" DISPLAY_NAME "Priority 0"
    set_parameter_property "p_rx_threshold_0" ALLOWED_RANGES {20:63}
    set_parameter_property "p_rx_threshold_0" DESCRIPTION "Specifies receive priority retry threshold 0 (number of 64-byte buffers)"
    add_display_item "Receive Priority Retry Threshold" "p_rx_threshold_0" PARAMETER 

    add_parameter "p_rx_threshold_1" integer 15
    set_parameter_property "p_rx_threshold_1" DISPLAY_NAME "Priority 1"
    set_parameter_property "p_rx_threshold_1" ALLOWED_RANGES {15:58}
    set_parameter_property "p_rx_threshold_1" DESCRIPTION "Specifies receive priority retry threshold 1 (number of 64-byte buffers)"
    add_display_item "Receive Priority Retry Threshold" "p_rx_threshold_1" PARAMETER 

    add_parameter "p_rx_threshold_2" integer 10
    set_parameter_property "p_rx_threshold_2" DISPLAY_NAME "Priority 2"
    set_parameter_property "p_rx_threshold_2" ALLOWED_RANGES {10:54}
    set_parameter_property "p_rx_threshold_2" DESCRIPTION "Specifies receive priority retry threshold 2 (number of 64-byte buffers)"
    add_display_item "Receive Priority Retry Threshold" "p_rx_threshold_2" PARAMETER 

    add_display_item "Receive Priority Retry Threshold" id2 TEXT "<html>Receive priority retry thresholds are expressed as numbers of 64-byte buffers.<br>"


    add_display_item "Physical Layer" "Transceiver Settings" GROUP
    set_display_item_property "Transceiver Settings" VISIBLE false

    add_parameter "XCVR_RECONFIG" boolean true
    set_parameter_property "XCVR_RECONFIG" DISPLAY_NAME "Enable transceiver dynamic reconfiguration"
    set_parameter_property "XCVR_RECONFIG" VISIBLE false 
    set_parameter_property "XCVR_RECONFIG" DESCRIPTION "Specifies that the IP core instantiates Transceiver Native PHY with dynamic reconfiguration enabled"
    add_display_item "Transceiver Settings" "XCVR_RECONFIG" PARAMETER 

    add_parameter "XCVR_CAPABILITY_REG_EN" boolean false
    set_parameter_property "XCVR_CAPABILITY_REG_EN" HDL_PARAMETER false
    set_parameter_property "XCVR_CAPABILITY_REG_EN" DISPLAY_NAME "Enable transceiver capability registers"
    set_parameter_property "XCVR_CAPABILITY_REG_EN" VISIBLE true 
    set_parameter_property "XCVR_CAPABILITY_REG_EN" DESCRIPTION "Enables transceiver capability registers, which provide high level information about the transceiver channel's configuration."
    add_display_item "Transceiver Settings" "XCVR_CAPABILITY_REG_EN" PARAMETER

    add_parameter "XCVR_SET_USER_IDENTIFIER" integer 0
    set_parameter_property "XCVR_SET_USER_IDENTIFIER" HDL_PARAMETER false
    set_parameter_property "XCVR_SET_USER_IDENTIFIER" DISPLAY_NAME "Set user-defined IP identifier"
    set_parameter_property "XCVR_SET_USER_IDENTIFIER" VISIBLE true 
    set_parameter_property "XCVR_SET_USER_IDENTIFIER" DESCRIPTION "Sets a user-defined numeric identifier that can be read from the user_identifer offset when the capability registers are enabled."
    set_parameter_property "XCVR_SET_USER_IDENTIFIER" ALLOWED_RANGES {0:255}
    add_display_item "Transceiver Settings" "XCVR_SET_USER_IDENTIFIER" PARAMETER

    add_parameter "XCVR_CSR_SOFT_LOG_EN" boolean false
    set_parameter_property "XCVR_CSR_SOFT_LOG_EN" HDL_PARAMETER false
    set_parameter_property "XCVR_CSR_SOFT_LOG_EN" DISPLAY_NAME "Enable transceiver control and status registers"
    set_parameter_property "XCVR_CSR_SOFT_LOG_EN" VISIBLE true 
    set_parameter_property "XCVR_CSR_SOFT_LOG_EN" DESCRIPTION "Enables transceiver soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Signals include rx_is_locktoref, rx_is_locktodata, tx_cal_busy, rx_cal_busy, rx_serial_loopback, set_rx_locktodata, set_rx_locktoref, tx_analogreset, tx_digitalreset, rx_analogreset and rx_digitalreset. For more information, please refer to the Transceiver User Guide."
    add_display_item "Transceiver Settings" "XCVR_CSR_SOFT_LOG_EN" PARAMETER

    add_parameter "XCVR_PRBS_SOFT_LOG_EN" boolean false
    set_parameter_property "XCVR_PRBS_SOFT_LOG_EN" HDL_PARAMETER false
    set_parameter_property "XCVR_PRBS_SOFT_LOG_EN" DISPLAY_NAME "Enable transceiver PRBS soft accumulators"
    set_parameter_property "XCVR_PRBS_SOFT_LOG_EN" VISIBLE true 
    set_parameter_property "XCVR_PRBS_SOFT_LOG_EN" DESCRIPTION "Enables transceiver soft logic for doing prbs bit and error accumulation when using the hard prbs generator and checker."
    add_display_item "Transceiver Settings" "XCVR_PRBS_SOFT_LOG_EN" PARAMETER


    add_display_item "" "Transport and Maintenance" GROUP "tab"
    add_display_item "Transport and Maintenance" "Transport Layer" GROUP

    add_parameter "p_TRANSPORT" boolean true
    set_parameter_property "p_TRANSPORT" DISPLAY_NAME "Enable Transport layer"
    set_parameter_property "p_TRANSPORT" VISIBLE false
    add_display_item "Transport Layer" "p_TRANSPORT" PARAMETER 

    add_parameter "p_TRANSPORT_LARGE" boolean false
    set_parameter_property "p_TRANSPORT_LARGE" DISPLAY_NAME "Enable 16-bit device ID width"
    set_parameter_property "p_TRANSPORT_LARGE" DESCRIPTION "Specifies 8-bit or 16-bit device ID width"
    add_display_item "Transport Layer" "p_TRANSPORT_LARGE" PARAMETER 

    add_parameter "p_GENERIC_LOGICAL" boolean false
    set_parameter_property "p_GENERIC_LOGICAL" DISPLAY_NAME "Enable Avalon-ST pass-through interface"
    set_parameter_property "p_GENERIC_LOGICAL" DESCRIPTION "Specifies that the IP core includes an Avalon-ST pass-through interface"
    add_display_item "Transport Layer" "p_GENERIC_LOGICAL" PARAMETER 

    add_parameter "p_PROMISCUOUS" boolean false
    set_parameter_property "p_PROMISCUOUS" DISPLAY_NAME "Disable destination ID checking by default"
    set_parameter_property "p_PROMISCUOUS" DESCRIPTION "Specifies whether the IP core is initially enabled to process a request packet with a supported ftype but a destination ID not assigned to this endpoint"
    add_display_item "Transport Layer" "p_PROMISCUOUS" PARAMETER 

    add_display_item "Transport and Maintenance" "I/O Maintenance Logical Layer Module" GROUP

    add_parameter "rio_p_maintenance_master_slave" string "AVALONMASTERSLAVE"
    set_parameter_property "rio_p_maintenance_master_slave" DISPLAY_NAME "Maintenance Logical layer interface(s)"
    set_parameter_property "rio_p_maintenance_master_slave" ALLOWED_RANGES { "AVALONMASTERSLAVE:Avalon-MM Master and Slave" "AVALONMASTER:Avalon-MM Master" "AVALONSLAVE:Avalon-MM Slave" "NONE:None"}
    set_parameter_property "rio_p_maintenance_master_slave" DESCRIPTION "Specifies whether the IP core includes a Maintenance Logical layer slave port, a Maintenance Logical layer master port, both, or neither"
    add_display_item "I/O Maintenance Logical Layer Module" "rio_p_maintenance_master_slave" PARAMETER 

    add_parameter "p_MAINTENANCE_WINDOWS" integer 16
    set_parameter_property "p_MAINTENANCE_WINDOWS" DISPLAY_NAME "Number of transmit address translation windows"
    set_parameter_property "p_MAINTENANCE_WINDOWS" DESCRIPTION "Specifies the number of transmit address translation windows available to the Maintenance Logical layer slave port"
    set_parameter_property "p_MAINTENANCE_WINDOWS" ALLOWED_RANGES {1:16}
    add_display_item "I/O Maintenance Logical Layer Module" "p_MAINTENANCE_WINDOWS" PARAMETER 

    add_display_item "I/O Maintenance Logical Layer Module" id2 TEXT "<html>Each transmit window maps the local Avalon-MM Slave address space into RapidIO Maintenance transactions to a specific endpoint.<br>"

    add_parameter "p_TX_PORT_WRITE" boolean false
    set_parameter_property "p_TX_PORT_WRITE" DISPLAY_NAME "Port write Tx enable"
    set_parameter_property "p_TX_PORT_WRITE" DESCRIPTION "Enables the Maintenance Logical layer module to transmit port-write requests"
    add_display_item "I/O Maintenance Logical Layer Module" "p_TX_PORT_WRITE" PARAMETER
 
    add_parameter "p_RX_PORT_WRITE" boolean false
    set_parameter_property "p_RX_PORT_WRITE" DISPLAY_NAME "Port write Rx enable"
    set_parameter_property "p_RX_PORT_WRITE" DESCRIPTION "Enables the Maintenance Logical layer module to receive port-write requests"
    add_display_item "I/O Maintenance Logical Layer Module" "p_RX_PORT_WRITE" PARAMETER

    add_display_item "" "I/O and Doorbell" GROUP "tab"
    add_display_item "I/O and Doorbell" "I/O Logical Layer Interfaces" GROUP

    add_parameter "rio_p_io_master_slave" string "AVALONMASTERSLAVE"
    set_parameter_property "rio_p_io_master_slave" DISPLAY_NAME "I/O Logical layer interface(s)"
    set_parameter_property "rio_p_io_master_slave" DESCRIPTION "Specifies whether the IP core includes an I/O Avalon-MM Logical layer slave port, an Avalon-MM Logical layer master port, both, or neither"
    set_parameter_property "rio_p_io_master_slave" ALLOWED_RANGES { "AVALONMASTERSLAVE:Avalon-MM Master and Slave" "AVALONMASTER:Avalon-MM Master" "AVALONSLAVE:Avalon-MM Slave" "NONE:None"}
    add_display_item "I/O Logical Layer Interfaces" "rio_p_io_master_slave" PARAMETER 

    add_parameter "p_IO_SLAVE_WIDTH" integer 30
    set_parameter_property "p_IO_SLAVE_WIDTH" DISPLAY_NAME "I/O Slave address width"
    set_parameter_property "p_IO_SLAVE_WIDTH" DESCRIPTION "Specifies the number of bits in the I/O Avalon-MM Slave Logical layer address"
    set_parameter_property "p_IO_SLAVE_WIDTH" ALLOWED_RANGES {20:32}
    add_display_item "I/O Logical Layer Interfaces" "p_IO_SLAVE_WIDTH" PARAMETER 


    add_parameter "p_READ_WRITE_ORDER" boolean false
    set_parameter_property "p_READ_WRITE_ORDER" DISPLAY_NAME "I/O read and write order preservation"
    set_parameter_property "p_READ_WRITE_ORDER" DESCRIPTION "Enforces transaction order preservation between read and write operations handled by different Avalon-MM Slave ports"
    add_display_item "I/O Logical Layer Interfaces" "p_READ_WRITE_ORDER" PARAMETER 

    add_display_item "I/O Logical Layer Interfaces" "Avalon-MM Master" GROUP

    add_parameter "p_IO_MASTER_WINDOWS" integer 16
    set_parameter_property "p_IO_MASTER_WINDOWS" DISPLAY_NAME "Number of Rx address translation windows"
    set_parameter_property "p_IO_MASTER_WINDOWS" DESCRIPTION "Specifies the number of receive address translation windows available to the Avalon-MM Logical layer master port"
    set_parameter_property "p_IO_MASTER_WINDOWS" ALLOWED_RANGES {1:16}
    add_display_item "Avalon-MM Master" "p_IO_MASTER_WINDOWS" PARAMETER 


    add_display_item "Avalon-MM Master" id2 TEXT "<html>The Avalon-MM Master module transforms RapidIO input/output inbound transactions received from remote endpoints into read or write transfers on its local Avalon-MM Master interfaces.<br>"
    add_display_item "I/O Logical Layer Interfaces" "Avalon-MM Slave" GROUP

    add_parameter "p_IO_SLAVE_WINDOWS" integer 16
    set_parameter_property "p_IO_SLAVE_WINDOWS" DISPLAY_NAME "Number of Tx address translation windows"
    set_parameter_property "p_IO_SLAVE_WINDOWS" DESCRIPTION "Specifies the number of transmit address translation windows available to the Avalon-MM Logical layer slave port"
    set_parameter_property "p_IO_SLAVE_WINDOWS" ALLOWED_RANGES {1:16}
    add_display_item "Avalon-MM Slave" "p_IO_SLAVE_WINDOWS" PARAMETER 


    add_display_item "Avalon-MM Slave" id2 TEXT "<html>The Avalon-MM Slave module transforms read or write transfers on its local Avalon-MM Slave interfaces into RapidIO input/output outbound transactions sent to remote endpoints.<br>"


    add_display_item "I/O and Doorbell" "Doorbell Slave" GROUP

    add_parameter "p_DRBELL_TX" boolean false
    set_parameter_property "p_DRBELL_TX" DISPLAY_NAME "Doorbell Tx enable"
    set_parameter_property "p_DRBELL_TX" DESCRIPTION "Enables the RapidIO IP core to transmit DOORBELL messages on the RapidIO link"
    add_display_item "Doorbell Slave" "p_DRBELL_TX" PARAMETER 

    add_parameter "p_DRBELL_RX" boolean false
    set_parameter_property "p_DRBELL_RX" DISPLAY_NAME "Doorbell Rx enable"
    set_parameter_property "p_DRBELL_RX" DESCRIPTION "Enables the RapidIO IP core to process inbound DOORBELL messages received on the RapidIO link"
    add_display_item "Doorbell Slave" "p_DRBELL_RX" PARAMETER 


    add_parameter "p_DRBELL_WRITE_ORDER" boolean false
    set_parameter_property "p_DRBELL_WRITE_ORDER" DISPLAY_NAME "Prevent doorbell messages from passing write transactions"
    set_parameter_property "p_DRBELL_WRITE_ORDER" DESCRIPTION "Enforces transaction order preservation between DOORBELL messages and I/O write request transactions"
    add_display_item "Doorbell Slave" "p_DRBELL_WRITE_ORDER" PARAMETER 

    add_display_item "" "Capability Registers" GROUP "tab"
    add_display_item "Capability Registers" "Device Registers" GROUP


    add_parameter "p_DEVICE_ID" integer 0x0000
    set_parameter_property "p_DEVICE_ID" DISPLAY_NAME "Device ID"
    set_parameter_property "p_DEVICE_ID" DESCRIPTION "Specifies the value in the DEVICE_ID field of the Device Identity register, which uniquely identifies the type of device from the vendor"
    set_parameter_property "p_DEVICE_ID" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_DEVICE_ID" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Device Registers" "p_DEVICE_ID" PARAMETER 


    add_parameter "p_DEVICE_VENDOR_ID" integer 0x0000
    set_parameter_property "p_DEVICE_VENDOR_ID" DISPLAY_NAME "Vendor ID"
    set_parameter_property "p_DEVICE_VENDOR_ID" DESCRIPTION "Specifies the value in the VENDOR_ID field of the Device Identity register; use this parameter to uniquely identify the vendor"
    set_parameter_property "p_DEVICE_VENDOR_ID" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_DEVICE_VENDOR_ID" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Device Registers" "p_DEVICE_VENDOR_ID" PARAMETER 


    add_parameter "p_DEVICE_REV" long 0xffffffff
    set_parameter_property "p_DEVICE_REV" DISPLAY_NAME "Revision ID"
    set_parameter_property "p_DEVICE_REV" DESCRIPTION "Specifies the value in the DEVICE INFORMATION CAR"
    set_parameter_property "p_DEVICE_REV" ALLOWED_RANGES {0x00000000:0xFFFFFFFF}
    set_parameter_property "p_DEVICE_REV" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Device Registers" "p_DEVICE_REV" PARAMETER 

    add_display_item "Capability Registers" "Assembly Registers" GROUP

    add_parameter "p_ASSEMBLY_ID" integer 0x0000
    set_parameter_property "p_ASSEMBLY_ID" DISPLAY_NAME "Assembly ID"
    set_parameter_property "p_ASSEMBLY_ID" DESCRIPTION "Specifies the value in the ASSY_ID field of the Assembly Identity CAR"
    set_parameter_property "p_ASSEMBLY_ID" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_ASSEMBLY_ID" DISPLAY_HINT "HEXADECIMAL"

    add_display_item "Assembly Registers" "p_ASSEMBLY_ID" PARAMETER 
    add_parameter "p_ASSEMBLY_VENDOR_ID" integer 0x0000
    set_parameter_property "p_ASSEMBLY_VENDOR_ID" DISPLAY_NAME "Assembly vendor ID"
    set_parameter_property "p_ASSEMBLY_VENDOR_ID" DESCRIPTION "Specifies the value in the ASSY_VENDOR_ID field of the Assembly Identity CAR"
    set_parameter_property "p_ASSEMBLY_VENDOR_ID" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_ASSEMBLY_VENDOR_ID" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Assembly Registers" "p_ASSEMBLY_VENDOR_ID" PARAMETER 

    add_parameter "p_ASSEMBLY_REVISION" integer 0x0000
    set_parameter_property "p_ASSEMBLY_REVISION" DISPLAY_NAME "Assembly revision ID"
    set_parameter_property "p_ASSEMBLY_REVISION" DESCRIPTION "Specifies the value in the ASSY_REV field of the Assembly Information CAR"
    set_parameter_property "p_ASSEMBLY_REVISION" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_ASSEMBLY_REVISION" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Assembly Registers" "p_ASSEMBLY_REVISION" PARAMETER 

    add_parameter "p_FIRST_EF_PTR" integer 0x0100
    set_parameter_property "p_FIRST_EF_PTR" DISPLAY_NAME "Extended features pointer"
    set_parameter_property "p_FIRST_EF_PTR" DESCRIPTION "Specifies the value in the EXT_FEATURE_PTR field of the Assembly Information CAR; points to the first entry in the extended feature list"
    set_parameter_property "p_FIRST_EF_PTR" ALLOWED_RANGES {0x0000:0xFFFF}
    set_parameter_property "p_FIRST_EF_PTR" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Assembly Registers" "p_FIRST_EF_PTR" PARAMETER 

    add_display_item "Capability Registers" "Processing Element Features" GROUP

    add_parameter "p_BRIDGE" boolean false
    set_parameter_property "p_BRIDGE" DISPLAY_NAME "Bridge support"
    set_parameter_property "p_BRIDGE" DESCRIPTION "Specifies the value in the BRIDGE bit of the Processing Element Features CAR; indicates whether the RapidIO IP core can bridge to another interface"
    add_display_item "Processing Element Features" "p_BRIDGE" PARAMETER 

    add_parameter "p_MEMORY" boolean false
    set_parameter_property "p_MEMORY" DISPLAY_NAME "Memory access"
    set_parameter_property "p_MEMORY" DESCRIPTION "Specifies the value in the MEMORY bit of the Processing Element Features CAR; indicates whether the RapidIO IP core connects locally (not through the RapidIO link) to local address space"
    add_display_item "Processing Element Features" "p_MEMORY" PARAMETER 

    add_parameter "p_PROCESSOR" boolean false
    set_parameter_property "p_PROCESSOR" DISPLAY_NAME "Processor present"
    set_parameter_property "p_PROCESSOR" DESCRIPTION "Specifies the value in the PROCESSOR bit of the Processing Element Features CAR; indicates whether the RapidIO IP core connects locally (not through the RapidIO link) to a processor"
    add_display_item "Processing Element Features" "p_PROCESSOR" PARAMETER 

    add_display_item "Processing Element Features" "Switch Support" GROUP

    add_parameter "p_SWITCH" boolean false
    set_parameter_property "p_SWITCH" DISPLAY_NAME "Enable switch support"
    set_parameter_property "p_SWITCH" DESCRIPTION "Specifies the value in the SWITCH bit of the Processing Element Features CAR"
    add_display_item "Switch Support" "p_SWITCH" PARAMETER 

    add_parameter "p_PORT_TOTAL" integer 1
    set_parameter_property "p_PORT_TOTAL" DISPLAY_NAME "Number of ports"
    set_parameter_property "p_PORT_TOTAL" DESCRIPTION "Specifies the value in the PORT_TOTAL field of the Switch Port Information CAR"
    add_display_item "Switch Support" "p_PORT_TOTAL" PARAMETER 

    add_parameter "p_PORT_NUMBER" integer 0x00
    set_parameter_property "p_PORT_NUMBER" DISPLAY_NAME "Port number"
    set_parameter_property "p_PORT_NUMBER" DESCRIPTION "Specifies the number of the port from which the Maintenance read operation accesses the Switch Port Information CAR; this value is stored in the PORT_NUMBER field of the Switch Port Information CAR"
    set_parameter_property "p_PORT_NUMBER" ALLOWED_RANGES {0x0000:0xFF}
    set_parameter_property "p_PORT_NUMBER" DISPLAY_HINT "HEXADECIMAL"
    add_display_item "Switch Support" "p_PORT_NUMBER" PARAMETER 

    add_display_item "Capability Registers" "Data Messages" GROUP

    add_parameter "p_SOURCE_OPERATION_DATA_MESSAGE" boolean false
    set_parameter_property "p_SOURCE_OPERATION_DATA_MESSAGE" DISPLAY_NAME "Source operation"
    set_parameter_property "p_SOURCE_OPERATION_DATA_MESSAGE" DESCRIPTION "Indicates that this RapidIO endpoint can issue Data Message request packets"
    add_display_item "Data Messages" "p_SOURCE_OPERATION_DATA_MESSAGE" PARAMETER 

    add_parameter "p_DESTINATION_OPERATION_DATA_MESSAGE" boolean false
    set_parameter_property "p_DESTINATION_OPERATION_DATA_MESSAGE" DISPLAY_NAME "Destination operation"
    set_parameter_property "p_DESTINATION_OPERATION_DATA_MESSAGE" DESCRIPTION "Indicates that this RapidIO endpoint can process incoming Data Message request packets"
    add_display_item "Data Messages" "p_DESTINATION_OPERATION_DATA_MESSAGE" PARAMETER 

    add_parameter "BASE_DEVICE" string "Unknown"
    set_parameter_property "BASE_DEVICE" SYSTEM_INFO_TYPE PART_TRAIT
    set_parameter_property "BASE_DEVICE" SYSTEM_INFO_ARG BASE_DEVICE
    set_parameter_property "BASE_DEVICE" VISIBLE false
    set_parameter_property "BASE_DEVICE" ENABLED 0

    add_parameter "DEVICE" string ""
    set_parameter_property "DEVICE" SYSTEM_INFO_TYPE PART_TRAIT
    set_parameter_property "DEVICE" SYSTEM_INFO_ARG DEVICE
    set_parameter_property "DEVICE" VISIBLE false
    set_parameter_property "DEVICE" ENABLED 0

    add_parameter p_x4_mode boolean false
    set_parameter_property p_x4_mode VISIBLE false 
    set_parameter_property p_x4_mode DERIVED true
    
    add_parameter p_x2_mode boolean false
    set_parameter_property p_x2_mode VISIBLE false 
    set_parameter_property p_x2_mode DERIVED true

    add_parameter "p_IO_MASTER" boolean false
    set_parameter_property "p_IO_MASTER" VISIBLE false 
    set_parameter_property "p_IO_MASTER" DERIVED true

    add_parameter "p_IO_SLAVE" boolean false
    set_parameter_property "p_IO_SLAVE" VISIBLE false 
    set_parameter_property "p_IO_SLAVE" DERIVED true

    add_parameter "p_MAINTENANCE" boolean false
    set_parameter_property "p_MAINTENANCE" VISIBLE false 
    set_parameter_property "p_MAINTENANCE" DERIVED true

    add_parameter "p_MAINTENANCE_MASTER" boolean false
    set_parameter_property "p_MAINTENANCE_MASTER" VISIBLE false 
    set_parameter_property "p_MAINTENANCE_MASTER" DERIVED true

    add_parameter "p_MAINTENANCE_SLAVE" boolean false
    set_parameter_property "p_MAINTENANCE_SLAVE" VISIBLE false 
    set_parameter_property "p_MAINTENANCE_SLAVE" DERIVED true

    add_parameter "p_ADAT" integer 32
    set_parameter_property "p_ADAT" VISIBLE false 
    set_parameter_property "p_ADAT" DERIVED true

	
    add_parameter "p_UNDER_SOPC" boolean false
    set_parameter_property "p_UNDER_SOPC" VISIBLE false
    
    add_parameter "p_SYS_CLK_PERIOD" integer 6400
    set_parameter_property "p_SYS_CLK_PERIOD" VISIBLE false
    set_parameter_property "p_SYS_CLK_PERIOD" DERIVED true
    
    add_parameter "p_PRESCALER_VALUE" integer 3
    set_parameter_property "p_PRESCALER_VALUE" VISIBLE false
    set_parameter_property "p_PRESCALER_VALUE" DERIVED true

###

#    add_parameter "p_DPA" integer 0
#    set_parameter_property "p_DPA" VISIBLE false 

#    add_parameter "p_IO_MASTER_PENDING_READS" integer 8
#    set_parameter_property "p_IO_MASTER_PENDING_READS" VISIBLE false 

    add_parameter "p_IO_SLAVE_OUTSTANDING_NREADS" integer 16 
    set_parameter_property "p_IO_SLAVE_OUTSTANDING_NREADS" VISIBLE false 

    add_parameter "p_IO_SLAVE_OUTSTANDING_NWRITE_RS" integer 8
    set_parameter_property "p_IO_SLAVE_OUTSTANDING_NWRITE_RS" VISIBLE false 

#    add_parameter "p_MAINTENANCE_MASTER_LOOPBACK" boolean false
#    set_parameter_property "p_MAINTENANCE_MASTER_LOOPBACK" VISIBLE false 

#    add_parameter "p_MAINTENANCE_PENDING_RW" boolean false
#    set_parameter_property "p_MAINTENANCE_PENDING_RW" VISIBLE false 

#    add_parameter "p_PASS_THROUGH_TEXT" boolean false
#    set_parameter_property "p_PASS_THROUGH_TEXT" VISIBLE false 

#    add_parameter "p_RECONFIG_START_CHANNEL" boolean false
#    set_parameter_property "p_RECONFIG_START_CHANNEL" VISIBLE false 

#    add_parameter "p_SYS_mnt_slaveLAVE_BASE" boolean false
#    set_parameter_property "p_SYS_mnt_slaveLAVE_BASE" VISIBLE false 

#    add_parameter "p_VCCH" boolean false
#    set_parameter_property "p_VCCH" VISIBLE false 



proc param_matches {param value} {
    if {[string compare -nocase [get_parameter_value $param] $value] == 0} {
	return 1
    }
    return 0
}

proc param_is_true {param} {
    return [param_matches $param "true"]
}

proc param_is_false {param} {
    return [param_matches $param "false"]
}

proc param_enable {param} {
    set_parameter_property $param ENABLED 1
}

proc param_disable {param} {
    set_parameter_property $param ENABLED 0
}

proc check_freq {baud freq legal_freq} {
    foreach testfreq $legal_freq {
	if {[string compare $freq $testfreq] == 0 } {
	    return 
	}
    }
    send_message error  "Legal frequencies at $baud Mbaud are: $legal_freq (current value is $freq)"
}

proc log2 x {
    expr int(log($x) / log(2))
}

proc common_add_tagged_conduit { port_name port_dir width port_role } {
	array set in_out [list {output} {start} {input} {end} ]
	add_interface $port_name conduit $in_out($port_dir)
	set_interface_assignment $port_name "ui.blockdiagram.direction" $port_dir
    add_interface_port $port_name $port_name $port_role $port_dir $width 

	if {$port_dir == "input"} {
		set_port_property $port_name TERMINATION_VALUE 0
	}
	set_port_property $port_name VHDL_TYPE STD_LOGIC_VECTOR
}

proc cust_demo_tb {name} {
# This function add the fileset required for the customer demo testbench and create the package
# which store the parameters value for the variant. 

    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set tmpdir "."
    set demo_tb_lib  "${tmpdir}/../demo_tb"
	
    send_message info "Testbench customizing started"
    
     # Create package to store parameterization for IP variant
     set output_file [ create_temp_file altera_rapidio_tb_var_functions.sv ]
     set out         [ open $output_file w ]

     puts $out "\/\/ Package Declaration"
     puts $out "package altera_rapidio_tb_var_functions\;"
         
     foreach param [get_parameters] {
        set type  [ get_parameter_property $param TYPE ] 
        set value [ get_parameter_value $param ]  
        if { [ string compare -nocase $type BOOLEAN ] == 0 } { 
            if { [ string compare -nocase $value true ] == 0 } {
                set argument "-parameterization.$param:1"
                puts $out "parameter ${param}    = 1\'b1\;"
                
            } else {
                 if { [ string compare -nocase $param p_DRBELL_WRITE_ORDER ] == 0 } {
                           set value [ get_parameter_value p_DRBELL_TX ]
                            if { [ string compare -nocase $value true ] == 0 } {
                                puts $out "parameter ${param}    =1\'b1 \;"
                            } else {
                                puts $out "parameter ${param}    =1\'b0 \;"
                            }
                 } elseif { [ string compare -nocase $param p_READ_WRITE_ORDER ] == 0 } {
                      if { [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
                            puts $out "parameter ${param}    =1\'b1 \;"
                      } else {
                                puts $out "parameter ${param}    =1\'b0 \;"
                      }
                 } else {
                     set argument "-parameterization.$param:0"
                    puts $out "parameter ${param}    =1\'b0 \;"
                }
            }
        } elseif { [ string compare -nocase $type INTEGER ] == 0 } {  
            set argument "-parameterization.$param:$value"
            puts $out "parameter ${param}    =${value}\;"
        } else {
            puts $out "parameter ${param}    =\"${value}\"\;"
            
        }
    }

    if { [param_matches mode_selection "SERIAL_4X"] } {
        puts $out "parameter SUPPORT_4X    = 1\'b1\;"
        puts $out "parameter SUPPORT_2X    = 1\'b0\;"
        puts $out "parameter SUPPORT_1X    = 1\'b0\;"
        puts $out "parameter LSIZE    =4\;"
    } elseif { [param_matches mode_selection "SERIAL_2X"] } {
        puts $out "parameter SUPPORT_2X    = 1\'b1\;"
        puts $out "parameter SUPPORT_4X    = 1\'b0\;"
        puts $out "parameter SUPPORT_1X    = 1\'b0\;"
        puts $out "parameter LSIZE    =2\;"
    } else {
        puts $out "parameter SUPPORT_1X    = 1\'b1\;"
        puts $out "parameter SUPPORT_2X    = 1\'b0\;"
        puts $out "parameter SUPPORT_4X    = 1\'b0\;"
          puts $out "parameter LSIZE    =1\;"
    } 
    
    puts $out "parameter IO_SLAVE_ADDRESS_WIDTH    =32\;"
    puts $out "parameter IO_MASTER_ADDRESS_WIDTH    =32\;"
    
    if { [param_matches p_ref_clk_freq "50"] } {
        set clk_period 20000
    } elseif { [param_matches p_ref_clk_freq "62.5"] } {
        set clk_period 16000
    } elseif { [param_matches p_ref_clk_freq "78.125"] } {
        set clk_period 12800
    } elseif { [param_matches p_ref_clk_freq "100"] } {
        set clk_period 10000
    } elseif { [param_matches p_ref_clk_freq "125"] } {
        set clk_period 8000
    } elseif { [param_matches p_ref_clk_freq "156.25"] } {
        set clk_period 6400
    } elseif { [param_matches p_ref_clk_freq "195.3125"] } {
        set clk_period 5120
    } elseif { [param_matches p_ref_clk_freq "200"] } {
        set clk_period 5000
    } elseif { [param_matches p_ref_clk_freq "250"] } {
        set clk_period 4000
    } elseif { [param_matches p_ref_clk_freq "312.5"] } {
        set clk_period 3200
    } elseif { [param_matches p_ref_clk_freq "390.625"] } {
        set clk_period 2560
    } elseif { [param_matches p_ref_clk_freq "400"] } {
        set clk_period 2500
    } elseif { [param_matches p_ref_clk_freq "500"] } {
        set clk_period 2000
    } elseif { [param_matches p_ref_clk_freq "625"] } {
        set clk_period 1600
    } else {
        set clk_period 6400
    }
    puts $out "parameter REF_CLK_PERIOD =$clk_period\;"
    
    puts $out "endpackage"  
    close $out
        
       
      #Rename the RapidIO instance name
      set fileID2 [open "${demo_tb_lib}/altera_rapidio_top_with_reset_ctrl_pll.sv" r]
      set temp2 ""
      set tx_pll_generated_name [get_instance_property altera_rapidio_tx_pll HDLINSTANCE_GET_GENERATED_NAME]
      set xcvr_rst_generated_name [get_instance_property altera_rapidio_xcvr_rst HDLINSTANCE_GET_GENERATED_NAME]
      while {[eof $fileID2] != 1} {
        gets $fileID2 lineInfo2
        # replace the top level entity name with the name provided during generation
        regsub -all "altera_rapidio_top " $lineInfo2 "${name} " lineInfo2
        # replace TX PLL module name with dynamic generated name
        regsub -all "altera_rapidio_tx_pll" $lineInfo2 "${tx_pll_generated_name}" lineInfo2
        # replace xcvr reset controller module name with dynamic generated name
        regsub -all "altera_rapidio_xcvr_rst" $lineInfo2 "${xcvr_rst_generated_name}" lineInfo2
        append temp2 "${lineInfo2}\n"
      }
   
      close $fileID2
   
    add_fileset_file tb/verbosity_pkg.sv SYSTEM_VERILOG PATH ${qdir}/../ip/altera/sopc_builder_ip/verification/lib/verbosity_pkg.sv
    add_fileset_file tb/avalon_utilities_pkg.sv SYSTEM_VERILOG PATH ${qdir}/../ip/altera/sopc_builder_ip/verification/lib/avalon_utilities_pkg.sv
    add_fileset_file tb/avalon_mm_pkg.sv SYSTEM_VERILOG PATH ${qdir}/../ip/altera/sopc_builder_ip/verification/lib/avalon_mm_pkg.sv

    set_fileset_file_attribute tb/verbosity_pkg.sv        COMMON_SYSTEMVERILOG_PACKAGE avalon_vip_verbosity_pkg
    set_fileset_file_attribute tb/avalon_mm_pkg.sv        COMMON_SYSTEMVERILOG_PACKAGE avalon_vip_avalon_mm_pkg
    set_fileset_file_attribute tb/avalon_utilities_pkg.sv COMMON_SYSTEMVERILOG_PACKAGE avalon_vip_avalon_utilities_pkg

    add_fileset_file tb/tb_hutil.sv SYSTEM_VERILOG PATH ${demo_tb_lib}/tb_hutil.sv
    add_fileset_file tb/tb_hutil.sv SYSTEM_VERILOG PATH ${demo_tb_lib}/avalon_bfm_slave.sv
    add_fileset_file tb/tb_hutil.sv SYSTEM_VERILOG PATH ${demo_tb_lib}/avalon_bfm_master.sv
    add_fileset_file tb/altera_rapidio_tb_var_functions.sv SYSTEM_VERILOG PATH ${output_file}
    add_fileset_file tb/altera_rapidio_top_with_reset_ctrl_pll.sv SYSTEM_VERILOG TEXT $temp2
    add_fileset_file tb/tb_rio.sv SYSTEM_VERILOG PATH ${demo_tb_lib}/tb_rio_a10.sv
      
             
    send_message info "Finish customizing testbench"
}



proc common_add_fileset_static { name simulation_req simulator gen_top_module} {
# This function generates the file set for Arria 10 and above family devices. If the simulation_req is set, the fileset
# for simulation is generated. If the simulation_req is set to 0, fileset for synthesis is generated. The simulator variable indicates
# which simulator the simulation fileset refers to. gen_top_module refers whether to generate the top level design file for tb directory or not.

      global env
	   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
     
        if {[string compare -nocase ${simulator} synopsys] == 0} {
            set filekind "VERILOG_ENCRYPT"
            set simulator_path "synopsys"
            set simulator_specific "SYNOPSYS_SPECIFIC"
        } elseif {[string compare -nocase ${simulator} mentor] == 0} {
            set filekind "VERILOG_ENCRYPT"
            set simulator_path "mentor"
            set simulator_specific "MENTOR_SPECIFIC"
        } elseif {[string compare -nocase ${simulator} cadence] == 0} {
            set filekind "VERILOG_ENCRYPT"
            set simulator_path "cadence"
            set simulator_specific "CADENCE_SPECIFIC"
        } elseif {[string compare -nocase ${simulator} aldec] == 0} {
            set filekind "VERILOG_ENCRYPT"
            set simulator_path "aldec"
            set simulator_specific "ALDEC_SPECIFIC"
        } else { 
            #for synthesis
            set filekind "VERILOG"
            set simulator_path "."
            set simulator_specific ""
        } 
	     
      set rapidio_pll_xcvr_dir "${QUARTUS_ROOTDIR}/../ip/altera/altera_rapidio/demo_tb/"
        
            
      if { [expr $simulation_req == 1] } {
         set rtldir "${QUARTUS_ROOTDIR}/../ip/altera/altera_rapidio/src/${simulator}/"
               
         
      } else {
         # Add SDC files for Synthesis
        set rtldir "${QUARTUS_ROOTDIR}/../ip/altera/altera_rapidio/src"
        set template_file [ file join $rtldir "altera_rapidio.sdc.terp" ]
        set template   [ read [ open $template_file r ] ]
        set params(support_4x) [param_matches mode_selection "SERIAL_4X"]
        set params(support_2x) [param_matches mode_selection "SERIAL_2X"]
	set params(support_1x) [param_matches mode_selection "SERIAL_1X"]
      
        if { [param_matches p_ref_clk_freq "50"] } {
          set clk_period 20
        } elseif { [param_matches p_ref_clk_freq "62.5"] } {
          set clk_period 16
        } elseif { [param_matches p_ref_clk_freq "78.125"] } {
          set clk_period 12.8
        } elseif { [param_matches p_ref_clk_freq "100"] } {
          set clk_period 10
        } elseif { [param_matches p_ref_clk_freq "125"] } {
          set clk_period 8
        } elseif { [param_matches p_ref_clk_freq "156.25"] } {
          set clk_period 6.4
        } elseif { [param_matches p_ref_clk_freq "195.3125"] } {
          set clk_period 5.12
        } elseif { [param_matches p_ref_clk_freq "200"] } {
          set clk_period 5
        } elseif { [param_matches p_ref_clk_freq "250"] } {
          set clk_period 4
        } elseif { [param_matches p_ref_clk_freq "312.5"] } {
          set clk_period 3.2
        } elseif { [param_matches p_ref_clk_freq "390.625"] } {
          set clk_period 2.56
        } elseif { [param_matches p_ref_clk_freq "400"] } {
          set clk_period 2.5
        } elseif { [param_matches p_ref_clk_freq "500"] } {
          set clk_period 2
        } elseif { [param_matches p_ref_clk_freq "625"] } {
          set clk_period 1.6
        } else {
          set clk_period 6.4
        }
       
        if { [param_matches mode_selection SERIAL_1X] || [param_matches mode_selection SERIAL_2X] } {
          if { [param_matches p_data_rate "5000"] } {
           set sysclk_period 8
	  } elseif { [param_matches p_data_rate "3125"]} {
	   set sysclk_period 12.8
	  } elseif { [param_matches p_data_rate "2500"]} {
	   set sysclk_period 16
          } else {
           set sysclk_period 32
	  } 
        } else {
          if { [param_matches p_data_rate "5000"] } {
           set sysclk_period 4
	  } elseif { [param_matches p_data_rate "3125"]} {
	   set sysclk_period 6.4
	  } elseif { [param_matches p_data_rate "2500"]} {
	   set sysclk_period 8
          } else {
           set sysclk_period 16
	  } 
        }
        set params(clk_period) $clk_period
        set params(sysclk_period) $sysclk_period
        set params(inst_name) ${name}
            
        set result          [ altera_terp $template params ]

        add_fileset_file ${name}.sdc SDC TEXT $result $simulator_specific
        #add_fileset_file altera_rapidio_riophy_dcore.ocp OTHER PATH ${rtldir}/altera_rapidio_riophy_dcore.ocp 
       
            
      }
      
       # Print wrapper name
       set native_phy_generated_name [get_instance_property altera_rapidio_xcvr_native_phy HDLINSTANCE_GET_GENERATED_NAME]            
       set tx_pll_generated_name [get_instance_property altera_rapidio_tx_pll HDLINSTANCE_GET_GENERATED_NAME]
       set xcvr_rst_generated_name [get_instance_property altera_rapidio_xcvr_rst HDLINSTANCE_GET_GENERATED_NAME]
 
       send_message INFO "Native_PHY_wrapper_name: $native_phy_generated_name"
       send_message INFO "ATX_PLL_wrapper_name: $tx_pll_generated_name"
       send_message INFO "PHY_Reset_Controller_wrapper_name: $xcvr_rst_generated_name"

        if {[expr $gen_top_module == 1]} {
            set fileID [open "${QUARTUS_ROOTDIR}/../ip/altera/altera_rapidio/src/altera_rapidio_top.v" r]
            set temp ""
            # read the contents of the file
            while {[eof $fileID] != 1} {
                gets $fileID lineInfo
                # replace the top level entity name with the name provided during generation
                regsub -all "altera_rapidio_top" $lineInfo "${name}" lineInfo
                # replace native phy module name with dynamic generated name
                regsub -all "altera_rapidio_xcvr_native_phy" $lineInfo "${native_phy_generated_name}" lineInfo
                append temp "${lineInfo}\n"
            }
            
            close $fileID
        
            add_fileset_file ${name}.v VERILOG TEXT $temp
            
        } 
      
      set transport_type_dir "tl_small"
      if { [param_is_true p_TRANSPORT_LARGE] } {
          set transport_type_dir "tl_large"
      }           
            
            
     
                      
      set iomasterfile "altera_rapidio_io_master"
      set iomasterfileext "_x1"
      if { [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
           if {[param_matches mode_selection SERIAL_1X] } {
               set iomasterfileext "_x1"
           } else {
               set iomasterfileext "_x2_x4"
           }
         
         add_fileset_file ${simulator}/${iomasterfile}_${transport_type_dir}${iomasterfileext}.v $filekind PATH ${rtldir}/logical/io_master/${transport_type_dir}/${iomasterfile}${iomasterfileext}.v $simulator_specific
         
      }
       
      set ioslavefile "altera_rapidio_io_slave"
      set ioslavefileext "_x1"
      if { [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
           if {[param_matches mode_selection SERIAL_1X] } {
               set ioslavefileext "_x1"
           } else {
               set ioslavefileext "_x2_x4"
           }
         add_fileset_file ${simulator}/${ioslavefile}_${transport_type_dir}${ioslavefileext}.v $filekind PATH ${rtldir}/logical/io_slave/${transport_type_dir}/${ioslavefile}${ioslavefileext}.v $simulator_specific
         
      }
       
      set mntfile "altera_rapidio_maintenance"
      set mntfileext "_x1"
      if { [param_matches rio_p_maintenance_master_slave AVALONMASTER] || [param_matches rio_p_maintenance_master_slave AVALONSLAVE] || [param_matches rio_p_maintenance_master_slave AVALONMASTERSLAVE] } {
           if {[param_matches mode_selection SERIAL_1X] } {
               set mntfileext "_x1"
           } else {
               set mntfileext "_x2_x4"
           }
           
           if {[param_is_true p_RX_PORT_WRITE] || [param_is_true p_TX_PORT_WRITE]} {
                set pwext "_pw"
            } else {
                set pwext ""
            }
            
            set lane_pw_var_name [concat ${mntfileext}${pwext}]
            
         add_fileset_file ${simulator}/${mntfile}_${transport_type_dir}${lane_pw_var_name}.v $filekind  PATH ${rtldir}/logical/maintenance/${transport_type_dir}/${mntfile}${lane_pw_var_name}.v $simulator_specific
     }
     
     add_fileset_file ${simulator}/altera_rapidio_concentrator.v $filekind  PATH ${rtldir}/logical/maintenance/altera_rapidio_concentrator.v $simulator_specific

       
      if {[string compare -nocase [get_parameter_value p_DRBELL_TX] true] == 0 || [string compare -nocase [get_parameter_value p_DRBELL_RX] true] == 0} {
         add_fileset_file ${simulator}/altera_rapidio_drbell.v $filekind  PATH ${rtldir}/logical/drbell/altera_rapidio_drbell.v $simulator_specific
      }
      
          add_fileset_file ${simulator}/altera_rapidio_phy_mnt.v  $filekind PATH ${rtldir}/altera_rapidio_phy_mnt.v $simulator_specific
      
      if { [param_is_true p_DRBELL_TX] || [param_is_true p_DRBELL_RX] } {
        add_fileset_file ${simulator}/altera_rapidio_reg_mnt_${transport_type_dir}_drbell.v  $filekind PATH ${rtldir}/reg_mnt/${transport_type_dir}/altera_rapidio_reg_mnt_drbell.v $simulator_specific
      } else {
        add_fileset_file ${simulator}/altera_rapidio_reg_mnt_${transport_type_dir}.v  $filekind PATH ${rtldir}/reg_mnt/${transport_type_dir}/altera_rapidio_reg_mnt.v $simulator_specific

      }

      if { [expr $simulation_req == 1] } {
        add_fileset_file ${simulator}/altera_rapidio_rio.v  $filekind PATH ${rtldir}/../altera_rapidio_rio.v $simulator_specific
      } else {
        add_fileset_file ${simulator}/altera_rapidio_rio.v  $filekind PATH ${rtldir}/altera_rapidio_rio.v $simulator_specific
      }

      set physicalfile "altera_rapidio_riophy_dcore"
      set physicalfileext "_x1"
      
      if {[param_matches mode_selection SERIAL_1X] } {
        if {[param_matches p_timeout_enable true]} {
                set physicalfileext "_x1"
        } else {
            set physicalfileext "_x1_notimeout"
        }
      } elseif {[param_matches mode_selection SERIAL_2X] } {
        if {[param_matches p_timeout_enable true]} {
            set physicalfileext "_x2"
        } else {
            set physicalfileext "_x2_notimeout"
        }
      } else {
        if {[param_matches p_timeout_enable true]} {
            set physicalfileext "_x4"
        } else {
            set physicalfileext "_x4_notimeout"
        }
      }
      
      add_fileset_file ${simulator}/${physicalfile}${physicalfileext}.v VERILOG PATH ${rtldir}/physical/${physicalfile}${physicalfileext}.v $simulator_specific
      # Add riophy OCP file
      if { [expr $simulation_req != 1] } {
            add_fileset_file ${physicalfile}${physicalfileext}.ocp OTHER PATH ${rtldir}/physical/${physicalfile}${physicalfileext}.ocp 
      }

      set transportfile "altera_rapidio_transport"
      set transportfileext "_x1"
      
      if {[param_matches mode_selection SERIAL_1X] } {
        set transportfileext "_x1"
      } else {
        set transportfileext "_x2_x4"
      }
      
      if { [param_is_true p_DRBELL_TX] || [param_is_true p_DRBELL_RX] } {
        set dbext "_db"
      } else {
        set dbext ""
      }
      
     if {[param_is_true p_GENERIC_LOGICAL]} {
         set ptext "_pt"
     } else {
         set ptext ""
     }
     
     set pt_db_var_name [concat ${ptext}${dbext}]

     if { [expr $simulation_req == 1] } {
        add_fileset_file ${simulator}/${transportfile}_${transport_type_dir}${transportfileext}${pt_db_var_name}.v  VERILOG PATH ${rtldir}/../transport/${transport_type_dir}/${transportfile}${transportfileext}${pt_db_var_name}.v $simulator_specific
     } else {
        add_fileset_file ${simulator}/${transportfile}_${transport_type_dir}${transportfileext}${pt_db_var_name}.v  VERILOG PATH ${rtldir}/transport/${transport_type_dir}/${transportfile}${transportfileext}${pt_db_var_name}.v $simulator_specific
     }     
      
#workaround for alt3pram EOL
     if { [expr $simulation_req == 1] } {
           add_fileset_file ${simulator}/custom_alt3pram_width_12.v VERILOG PATH ${rtldir}/../transport/custom_ram/custom_alt3pram_width_12.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_12.v VERILOG PATH ${rtldir}/../transport/custom_ram/ram2port_width_12.v $simulator_specific
        if {[param_matches mode_selection SERIAL_1X]} {
           add_fileset_file ${simulator}/custom_alt3pram_width_7.v VERILOG PATH ${rtldir}/../transport/custom_ram/custom_alt3pram_width_7.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_7.v VERILOG PATH ${rtldir}/../transport/custom_ram/ram2port_width_7.v $simulator_specific
        } else {	
           add_fileset_file ${simulator}/custom_alt3pram_width_6.v VERILOG PATH ${rtldir}/../transport/custom_ram/custom_alt3pram_width_6.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_6.v VERILOG PATH ${rtldir}/../transport/custom_ram/ram2port_width_6.v $simulator_specific
        }
     } else {
           add_fileset_file ${simulator}/custom_alt3pram_width_12.v VERILOG PATH ${rtldir}/transport/custom_ram/custom_alt3pram_width_12.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_12.v VERILOG PATH ${rtldir}/transport/custom_ram/ram2port_width_12.v $simulator_specific
        if {[param_matches mode_selection SERIAL_1X]} {
           add_fileset_file ${simulator}/custom_alt3pram_width_7.v VERILOG PATH ${rtldir}/transport/custom_ram/custom_alt3pram_width_7.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_7.v VERILOG PATH ${rtldir}/transport/custom_ram/ram2port_width_7.v $simulator_specific
        } else {	
           add_fileset_file ${simulator}/custom_alt3pram_width_6.v VERILOG PATH ${rtldir}/transport/custom_ram/custom_alt3pram_width_6.v $simulator_specific
           add_fileset_file ${simulator}/ram2port_width_6.v VERILOG PATH ${rtldir}/transport/custom_ram/ram2port_width_6.v $simulator_specific
        }
     }



#     if { [expr $simulation_req == 1] } {
#        if {[param_matches mode_selection SERIAL_4X]} {
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/../altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x4/altera_rapidio_xcvr_rst.v $simulator_specific
#        } elseif {[param_matches mode_selection SERIAL_2X]} {
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/../altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x2/altera_rapidio_xcvr_rst.v $simulator_specific
#        } else {	
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/../altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x1/altera_rapidio_xcvr_rst.v $simulator_specific
#        }
#     } else {
#        if {[param_matches mode_selection SERIAL_4X]} {
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x4/altera_rapidio_xcvr_rst.v $simulator_specific
#        } elseif {[param_matches mode_selection SERIAL_2X]} {
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x2/altera_rapidio_xcvr_rst.v $simulator_specific
#        } else {	
#           add_fileset_file ${simulator}/xcvr_rst_ctrl.v $filekind PATH ${rtldir}/altera_rapidio_xcvr_phy_ip/xcvr_rst_ctl/x1/altera_rapidio_xcvr_rst.v $simulator_specific
#        }
#     }
        # Submodules of Reset Controller
        # Workaround for Case:71346
#     if {[string compare -nocase ${simulator} mentor] == 0} {
#        add_fileset_file ${simulator}/altera_xcvr_functions.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_xcvr_generic/altera_xcvr_functions.sv $simulator_specific
#        add_fileset_file ${simulator}/altera_xcvr_reset_control.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/alt_xcvr/altera_xcvr_reset_control/mentor/altera_xcvr_reset_control.sv $simulator_specific
#        add_fileset_file ${simulator}/alt_xcvr_reset_counter.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/alt_xcvr/altera_xcvr_reset_control/mentor/alt_xcvr_reset_counter.sv $simulator_specific
#    } else {
        #use non-encrypted files for other simulators
#         if { [expr $simulation_req == 0] || [string compare -nocase ${simulator} aldec] == 0 || [string compare -nocase ${simulator} cadence] == 0 || [string compare -nocase ${simulator} synopsys] == 0} {
#              add_fileset_file ${simulator}/altera_xcvr_functions.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_xcvr_generic/altera_xcvr_functions.sv $simulator_specific
#         }         
         
#        add_fileset_file ${simulator}/altera_xcvr_reset_control.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/alt_xcvr/altera_xcvr_reset_control/altera_xcvr_reset_control.sv $simulator_specific
#        add_fileset_file ${simulator}/alt_xcvr_reset_counter.sv SYSTEM_VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/alt_xcvr/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv $simulator_specific
#    }
    
       add_fileset_file ${simulator}/altera_std_synchronizer_nocut.v VERILOG PATH $env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v $simulator_specific

         	
}


# The validation callback
proc my_validation_callback {} {

    set family [get_parameter_value deviceFamily]
    
    # Add a check to verify the BASE_DEVICE parameter before passing it to A10 PHY/PLL IP.  
    if {[param_matches deviceFamily "Arria 10" ]} {
       set local_base_device [get_parameter_value "BASE_DEVICE"]
       if { [string compare -nocase $local_base_device "unknown"] == 0 } {
          set local_device [get_parameter_value "DEVICE"]
          send_message error "The current selected device \"$local_device\" is invalid, please select a valid device to generate the IP."
       }
    }
    
    if {[param_is_true p_TRANSPORT]} {
		param_enable "p_TRANSPORT_LARGE" 
		param_enable "p_GENERIC_LOGICAL"
		param_enable "p_PROMISCUOUS"

		# Case:221047
		if {[param_matches rio_p_io_master_slave NONE] && [param_matches rio_p_maintenance_master_slave NONE] && [param_is_false p_DRBELL_TX] && [param_is_false p_DRBELL_RX] && [param_is_false p_GENERIC_LOGICAL]} {
			send_message error "At least one of the logical layer modules or the pass-through interface must be enabled if the transport layer is enabled"
		}
    } else {
		param_disable "p_TRANSPORT_LARGE" 
		param_disable "p_GENERIC_LOGICAL"
		param_disable "p_PROMISCUOUS"
    }

    set baud [get_parameter_value p_data_rate]
    set freq [get_parameter_value p_ref_clk_freq]

    #Cyclone IV GX: supported input clock frequency is up to 156.25MHz only
    if {[param_matches deviceFamily "Cyclone IV GX" ]} {
        if { [expr $baud == 1250] } {
		check_freq $baud $freq [list "62.5" "78.125" "125" "156.25"]
        } elseif { [expr $baud == 2500] } {
		check_freq $baud $freq [list "50" "62.5" "78.125" "100" "125" "156.25"]
        } elseif { [expr $baud == 3125] } {
		check_freq $baud $freq [list "62.5" "78.125" "97.65625" "125" "156.25"]
        }
    } elseif {[param_matches deviceFamily "Arria 10" ]} {
        if { [expr $baud == 1250] } {
		    check_freq $baud $freq [list "125" "156.25" "250" "312.5"]
        } elseif { [expr $baud == 2500] } {
		    check_freq $baud $freq [list "100" "125" "156.25" "250" "312.5"]
        } elseif { [expr $baud == 3125] } {
 		    check_freq $baud $freq [list "125" "156.25" "195.3125" "312.5" "390.625"]
        } elseif { [expr $baud == 5000] } {
		    check_freq $baud $freq [list "100" "125" "156.25" "200" "250" "312.5" "400" "500"]
        }
        
    } else { 
    #supported frequencies for device families other than C4GX and Arria 10
        if { [expr $baud == 1250] } {
		check_freq $baud $freq [list "62.5" "78.125" "125" "156.25" "250" "312.5"]
        } elseif { [expr $baud == 2500] } {
		check_freq $baud $freq [list "50" "62.5" "78.125" "100" "125" "156.25" "250" "312.5"]
        } elseif { [expr $baud == 3125] } {
 		check_freq $baud $freq [list "62.5" "78.125" "97.65625" "125" "156.25" "195.3125" "312.5" "390.625"]
        } elseif { [expr $baud == 5000] } {
		check_freq $baud $freq [list "100" "125" "156.25" "200" "250" "312.5" "400" "500"]
        }
    }
    
    # 2x serial is only supported for 28nm families, Stratix V, Arria V, Cyclone V and Arria V GZ. New family addition should 
    # be added by default into the list. Error message is issued for unsupported device familes
    if {[param_matches mode_selection SERIAL_2X] } {
        if {[param_matches deviceFamily "Cyclone IV GX" ] ||
            [param_matches deviceFamily "Arria II GX" ] ||
            [param_matches deviceFamily "Arria GX" ] ||
            [param_matches deviceFamily "Stratix II GX"] || 
            [param_matches deviceFamily "Stratix IV"] ||
            [param_matches deviceFamily "Arria II GZ"] ||
            [param_matches deviceFamily "HardCopy IV"] } {
            send_message error  "2x serial is not supported in this device family"
        } 
    }

    if {[param_is_false auto_cfg_rx]} {
		param_enable "p_rx_threshold_0"
		param_enable "p_rx_threshold_1"
		param_enable "p_rx_threshold_2"
		set t0 [get_parameter_value "p_rx_threshold_0"]
		set t1 [get_parameter_value "p_rx_threshold_1"]
		set t2 [get_parameter_value "p_rx_threshold_2"]
		set limit0 [expr $t1 + 4]
		set limit1 [expr $t2 + 4]
		if { [expr $t0 <= [expr $t1 + 4]] } {
			send_message error  "Priority 0 must be greater than Priority 1 plus 4 ($limit0)"
		}
		if { [expr $t1 <= [expr $t2 + 4]] } {
			send_message error  "Priority 1 must be greater than Priority 2 plus 4 ($limit1)"
		}

	} else {
		param_disable "p_rx_threshold_0"
		param_disable "p_rx_threshold_1"
		param_disable "p_rx_threshold_2"
    }
	
   if {[param_matches rio_p_maintenance_master_slave "AVALONMASTERSLAVE"] || [param_matches rio_p_maintenance_master_slave "AVALONSLAVE"] } {
 		param_enable "p_MAINTENANCE_WINDOWS"
                param_enable "p_TX_PORT_WRITE"
                param_enable "p_RX_PORT_WRITE" 
   } else {
		param_disable "p_MAINTENANCE_WINDOWS"
		param_disable "p_TX_PORT_WRITE"
		param_disable "p_RX_PORT_WRITE"
   }

   if {[param_matches rio_p_io_master_slave "AVALONMASTERSLAVE"] || [param_matches rio_p_io_master_slave "AVALONSLAVE"] } {
   		param_enable "p_IO_SLAVE_WIDTH"
                param_enable "p_READ_WRITE_ORDER"
		param_enable "p_IO_SLAVE_WINDOWS"  
		if {[param_is_true p_DRBELL_TX]} {
                    param_enable "p_DRBELL_WRITE_ORDER"
		} else {
                    param_disable "p_DRBELL_WRITE_ORDER"	
		}
   } else {
		param_disable "p_IO_SLAVE_WIDTH"
		param_disable "p_READ_WRITE_ORDER"
		param_disable "p_IO_SLAVE_WINDOWS"
		param_disable "p_DRBELL_WRITE_ORDER"
   } 
 	
   if {[param_matches rio_p_io_master_slave "AVALONMASTERSLAVE"] || [param_matches rio_p_io_master_slave "AVALONMASTER"] } {
   		param_enable "p_IO_MASTER_WINDOWS"
	} else {
		param_disable "p_IO_MASTER_WINDOWS"
   } 
 	
    if {[param_is_true p_SWITCH]} {
   		param_enable "p_PORT_TOTAL"
   		param_enable "p_PORT_NUMBER"	
	} else {
   		param_disable "p_PORT_TOTAL"
   		param_disable "p_PORT_NUMBER"		
	}

    if {[param_is_false p_GENERIC_LOGICAL]} {
                param_disable "p_SOURCE_OPERATION_DATA_MESSAGE"
                param_disable "p_DESTINATION_OPERATION_DATA_MESSAGE"
   	} else {
                param_enable "p_SOURCE_OPERATION_DATA_MESSAGE"
                param_enable "p_DESTINATION_OPERATION_DATA_MESSAGE"		
   	}
	

     if {[param_matches deviceFamily "Arria 10" ] } {
        param_enable "XCVR_RECONFIG"
        if {[param_is_true XCVR_RECONFIG]} {
            param_enable "XCVR_CAPABILITY_REG_EN"
            param_enable "XCVR_CSR_SOFT_LOG_EN"
            param_enable "XCVR_PRBS_SOFT_LOG_EN"
            if {[param_is_true XCVR_CAPABILITY_REG_EN]} {
                param_enable "XCVR_SET_USER_IDENTIFIER"
            } else {
                param_disable "XCVR_SET_USER_IDENTIFIER"
            }

        } else {
            param_disable "XCVR_CAPABILITY_REG_EN"
            param_disable "XCVR_SET_USER_IDENTIFIER"
            param_disable "XCVR_CSR_SOFT_LOG_EN"
            param_disable "XCVR_PRBS_SOFT_LOG_EN"
        }
    } else {
        param_disable "XCVR_RECONFIG"
        param_disable "XCVR_CAPABILITY_REG_EN"
        param_disable "XCVR_SET_USER_IDENTIFIER"
        param_disable "XCVR_CSR_SOFT_LOG_EN"
        param_disable "XCVR_PRBS_SOFT_LOG_EN"
    }

}

proc my_elaboration_callback {} {

    set family [get_parameter_value deviceFamily]
    set io_interface [get_parameter_value rio_p_io_master_slave]
    set mode_selection [get_parameter_value mode_selection]  
    set txbuf_addr_width [log2 [get_parameter_value p_TXBUFRSIZE]]
    set rxbuf_addr_width [log2 [get_parameter_value p_RXBUFRSIZE]]
    set use_xcvr_phy_mode 0
    set use_native_phy_mode 0

    if {[param_matches deviceFamily "Stratix II GX"]} {
	set_parameter_value phy_selection stratixiigx
    } elseif {[param_matches deviceFamily "Stratix IV"]} {
	set_parameter_value phy_selection stratixivgx
    } elseif {[param_matches deviceFamily "Stratix V"]} {
	set_parameter_value phy_selection stratixvgx
	set use_xcvr_phy_mode 1
	} elseif {[param_matches deviceFamily "Arria V"]} {
	set_parameter_value phy_selection arriav
	set use_xcvr_phy_mode 1
	} elseif {[param_matches deviceFamily "Cyclone V"]} {
	set_parameter_value phy_selection cyclonev
	set use_xcvr_phy_mode 1
        } elseif {[param_matches deviceFamily "Arria V GZ"]} {
	set_parameter_value phy_selection arriavgz
	set use_xcvr_phy_mode 1
    } elseif {[param_matches deviceFamily "HardCopy IV"]} {
	set_parameter_value phy_selection hardcopyivgx
    } elseif {[param_matches deviceFamily "Arria GX"]} {
	set_parameter_value phy_selection stratixiigxlite
    } elseif {[param_matches deviceFamily "Arria II GX"]} {
	set_parameter_value phy_selection arriaiigx
    } elseif {[param_matches deviceFamily "Cyclone IV GX"]} {
	set_parameter_value phy_selection cycloneivgx
    } elseif {[param_matches deviceFamily "Arria II GZ"]} {
	set_parameter_value phy_selection arriaiigz
    } elseif {[param_matches deviceFamily "Arria 10"]} {
	set_parameter_value phy_selection arria10
	set use_native_phy_mode 1
   }

    #Supported frequencies
    if {[param_matches deviceFamily "Stratix II GX" ] || [param_matches deviceFamily "Arria II GX"] || [param_matches deviceFamily "HardCopy IV"]} {
        set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 }
    } elseif {[param_matches deviceFamily "Stratix IV"]} {
        set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 5000 }
    } elseif {[param_matches deviceFamily "Stratix V"] || [param_matches deviceFamily "Arria V GZ"]} {
        set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 5000 }
    } elseif {[param_matches deviceFamily "Arria GX"] || [param_matches deviceFamily "Cyclone IV GX"] || [param_matches deviceFamily "Cyclone V"]} {
        if { [param_matches mode_selection SERIAL_4X] } {
            set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 }
        } else {
            set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 5000 }
        }
    } elseif {[param_matches deviceFamily "Arria II GZ"] || [param_matches deviceFamily "Arria V"]} {
        if { [param_matches mode_selection SERIAL_4X] } {
            set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 }
        } else {
            set_parameter_property "p_data_rate" ALLOWED_RANGES { 1250 2500 3125 5000 }
        }
    } 

    if { [param_matches mode_selection SERIAL_4X] } {
	set_parameter_value p_x4_mode true
	set_parameter_value p_x2_mode false
	set_parameter_value p_ADAT 64
	set io_slave_addr_width [expr [get_parameter_value p_IO_SLAVE_WIDTH] - 3]
    } elseif { [param_matches mode_selection SERIAL_2X] } {
        set_parameter_value p_x2_mode true
	set_parameter_value p_x4_mode false
        set_parameter_value p_ADAT 64
        set io_slave_addr_width [expr [get_parameter_value p_IO_SLAVE_WIDTH] - 3]
	} else {
	set_parameter_value p_x4_mode false
	set_parameter_value p_x2_mode false
	set_parameter_value p_ADAT 32
	set io_slave_addr_width [expr [get_parameter_value p_IO_SLAVE_WIDTH] - 2]
    }
    
    # Send message on resetting parameter value when greyed out
    if { [param_is_false p_GENERIC_LOGICAL] && [param_is_true p_SOURCE_OPERATION_DATA_MESSAGE] } {
        send_message info  "Capability Registers: Source operation is disabled because Avalon-ST pass-through interface is turned off"
    }
    # Send message on resetting parameter value when greyed out
    if { [param_is_false p_GENERIC_LOGICAL] && [param_is_true p_DESTINATION_OPERATION_DATA_MESSAGE] } {
        send_message info  "Capability Registers: Destination operation is disabled because Avalon-ST pass-through interface is turned off"
    }

    #For Arria 10 and above family devices, sub-variants are generated compare to previous families. Thus, error messages are issue for the following conditions below:
    # 1) the minimum layer is Transport and Maintenance. Physical only layer is removed. Error messages is issue if user use the Physical only layer
    # 2) Maintenance Avalon Slave & Master is the only variants allowed. Avalon Master only and Avalon Slave only variants are not allowed. Error message is issued to user if this condition is detected
    # 3) Disable ID checking is set to true as default for all variants
    # 4) Auto Sync Ackid feature in Physical layer is turned on by default
    # 5) IO Slave and IO Master or None the only variant allowed. IO Slave only or IO Maseter only variants are not allowed. Error message is issued to user if this condition is detected. 
    # 6) Doorbell TX and Doorbell RX or None are the only variants allowed. Doorbell TX only or Doorbell RX only are not allowed. Error message is issued to user if this condition is detected.
    # 7) p_DRBELL_WRITE_ORDER is defaulted to true and set as visible.
    # 8) RX Port Write and TX Port Write Feature need to be enabled together 
    # 9) Set the rxbuf_addr_width and txbuf_addr_width to 32 
    if  {$use_native_phy_mode == 1} {
      if { [param_matches rio_p_maintenance_master_slave NONE] } {
         param_disable "p_TX_PORT_WRITE" 
         param_disable "p_RX_PORT_WRITE" 
         if { [param_is_false p_GENERIC_LOGICAL] } {
            send_message error "Maintenance & Transport layer is the minimum layer to be selected. Please select Avalon-ST pass-through interface"
         }
      }
      
      if {[param_is_false p_TX_PORT_WRITE] && [param_is_true p_RX_PORT_WRITE] } {
          send_message error "TX Port Write and RX Port Write Feature need to be enabled together. Pelase select TX Port Write"  
      } elseif {[param_is_false p_RX_PORT_WRITE] && [param_is_true p_TX_PORT_WRITE]} {
          send_message error "TX Port Write and RX Port Write Feature need to be enabled together. Pelase select RX Port Write"  
      }
      #if { [param_matches rio_p_maintenance_master_slave AVALONSLAVE] || [param_matches rio_p_maintenance_master_slave AVALONMASTER] } {
          set_parameter_property "rio_p_maintenance_master_slave" ALLOWED_RANGES { "AVALONMASTERSLAVE:Avalon-MM Master and Slave" "NONE:None"}
          #send_message info "Maintenance Avalon Master only or Slave only is not supported."
      #}
      
      param_enable "p_PROMISCUOUS"
      set_parameter_property "p_PROMISCUOUS" VISIBLE false
      send_message info "Disable destination ID checking is set to true by default"
      
      param_enable "p_SYNC_ACKID"
      set_parameter_property "p_SYNC_ACKID" VISIBLE false
      send_message info "Auto Sync Ackid Feature is set to true as default"
      
      set_parameter_property "p_READ_WRITE_ORDER" VISIBLE false
      send_message info "IO read and write order preservation is set to true as default"

      #if { [param_matches rio_p_io_master_slave AVALONSLAVE] ||  [param_matches rio_p_io_master_slave AVALONMASTER] } {
         set_parameter_property "rio_p_io_master_slave" ALLOWED_RANGES { "AVALONMASTERSLAVE:Avalon-MM Master and Slave" "NONE:None"}
         #send_message error "IO Master only or IO Slave only is not supported.Please select IO Slave & IO Master option"
      #}
      
      if {[param_is_true p_DRBELL_TX] && [param_is_false p_DRBELL_RX]} {
         send_message error "Doorbell TX only or Doorbell RX only are not supported. Please select Doorbell TX & Doorbell RX option"
      } elseif  {[param_is_true p_DRBELL_RX] && [param_is_false p_DRBELL_TX]} {
         send_message error "Doorbell TX only or Doorbell RX only are not supported. Please select Doorbell TX & Doorbell RX option"
      }
      
      set_parameter_property "p_DRBELL_WRITE_ORDER" VISIBLE false
       if {[param_is_true p_DRBELL_TX] || [param_is_true p_DRBELL_RX]} {
           send_message info "Doorbell read write order is set to true as default"
       }
       
       #For Arria 10, we are setting the buffer size to be constant 32
        set txbuf_addr_width 5
        set rxbuf_addr_width 5
     } 
    

    if { [param_matches rio_p_io_master_slave AVALONMASTER] ||  [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
	set_parameter_value "p_IO_MASTER" true
    } else {
	set_parameter_value "p_IO_MASTER" false
    }

    if { [param_matches rio_p_io_master_slave AVALONSLAVE] ||  [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
	set_parameter_value "p_IO_SLAVE" true

        if {[param_is_false p_DRBELL_TX] && [param_is_true p_DRBELL_WRITE_ORDER]} {
            send_message info  "I/O and Doorbell: The Prevent doorbell messages from passing write transactions option is disabled because the Doorbell Tx capability is turned off"
        }
    } else {
	set_parameter_value "p_IO_SLAVE" false
        # Send message on resetting p_READ_WRITE_ORDER and p_DRBELL_WRITE_ORDER parameters to zero when IO Slave is disabled
        if {[param_is_true p_READ_WRITE_ORDER]} {
	    send_message info  "I/O and Doorbell: I/O read and write order preservation is disabled because no I/O Logical layer Slave module is present"
        }

        if {[param_is_true p_DRBELL_WRITE_ORDER]} {
	    send_message info  "I/O and Doorbell: The Prevent doorbell messages from passing write transactions option is disabled because no I/O Logical layer Slave module is present"
        }
    }

    if { [param_matches rio_p_maintenance_master_slave NONE] } {
	set_parameter_value "p_MAINTENANCE" false
    } else {
	set_parameter_value "p_MAINTENANCE" true
    }

    if { [param_matches rio_p_maintenance_master_slave AVALONMASTER] ||  [param_matches rio_p_maintenance_master_slave AVALONMASTERSLAVE] } {
	set_parameter_value "p_MAINTENANCE_MASTER" true
    } else {
	set_parameter_value "p_MAINTENANCE_MASTER" false
    }

    if { [param_matches rio_p_maintenance_master_slave AVALONSLAVE] ||  [param_matches rio_p_maintenance_master_slave AVALONMASTERSLAVE] } {
	set_parameter_value "p_MAINTENANCE_SLAVE" true
    } else {
	set_parameter_value "p_MAINTENANCE_SLAVE" false
        # Send message on resetting parameter value when greyed out
        if {[param_is_true p_TX_PORT_WRITE]} {
	    send_message info  "Transport and Maintenance: Port write Tx capability is turned off because the Maintenance Logical layer module has no slave port"
        }
        if {[param_is_true p_RX_PORT_WRITE]} {
	    send_message info  "Transport and Maintenance: Port write Rx capability is turned off because the Maintenance Logical layer module has no slave port"
        }
    }

    # Clocks
    if {[param_matches phy_selection "stratixiigx"] || [param_matches phy_selection "stratixiigxlite"] ||  [param_matches phy_selection "stratixivgx"] || [param_matches phy_selection "hardcopyivgx"] || [param_matches phy_selection "arriaiigx"] || [param_matches phy_selection "arriaiigz"] || [param_matches phy_selection "cycloneivgx"]} {
      add_interface cal_blk_clk clock end
      add_interface_port cal_blk_clk cal_blk_clk clk input 1
    }

    if {$use_xcvr_phy_mode == 1} {
      add_interface phy_mgmt_clk clock end
      add_interface_port phy_mgmt_clk phy_mgmt_clk clk input 1
      add_interface_port phy_mgmt_clk phy_mgmt_clk_reset reset Input 1
    }

    add_interface clock clock end
    add_interface_port clock sysclk clk input 1
    add_interface_port clock reset_n reset_n Input 1

    add_interface clk clock end
    add_interface_port clk clk clk input 1

    add_interface exported_connections conduit end
    add_interface_port exported_connections multicast_event_tx  export input 1

    add_interface_port exported_connections rxclk export output 1
    add_interface_port exported_connections txclk export output 1
    
    add_interface_port exported_connections rxgxbclk export output 1
    

    if {[param_matches phy_selection "stratixiigx"] || [param_matches phy_selection "stratixiigxlite"] ||  [param_matches phy_selection "stratixivgx"] || [param_matches phy_selection "hardcopyivgx"] || [param_matches phy_selection "arriaiigx"] || [param_matches phy_selection "arriaiigz"] || [param_matches phy_selection "cycloneivgx"]} {
      add_interface_port exported_connections reconfig_clk export input 1
    }

    if {[param_is_true p_TRANSPORT] && [param_is_false p_GENERIC_LOGICAL] } {
	add_interface_port exported_connections rx_packet_dropped export output 1
    }

    if {[param_matches phy_selection "stratixiigx"] || [param_matches phy_selection "stratixiigxlite"] } {
	add_interface_port exported_connections reconfig_togxb  export input 3
    } elseif {[param_matches phy_selection "stratixivgx"] || [param_matches phy_selection "hardcopyivgx"] || [param_matches phy_selection "arriaiigx"] || [param_matches phy_selection "arriaiigz"] || [param_matches phy_selection "cycloneivgx"]}  {
	add_interface_port exported_connections reconfig_togxb  export input 4
    }

    if {[param_matches phy_selection "stratixiigx"] || [param_matches phy_selection "stratixiigxlite"] ||  [param_matches phy_selection "stratixivgx"] || [param_matches phy_selection "hardcopyivgx"] || [param_matches phy_selection "arriaiigx"] || [param_matches phy_selection "arriaiigz"] || [param_matches phy_selection "cycloneivgx"]} {
      add_interface_port exported_connections gxb_powerdown  export input 1
    }

    # x1 , x4
    if {[param_matches mode_selection "SERIAL_1X" ]} {
	add_interface_port exported_connections rd export input 1
	add_interface_port exported_connections td export output 1
	add_interface_port exported_connections rx_errdetect export output 2
    } elseif { [param_matches mode_selection "SERIAL_2X" ] } {
    	add_interface_port exported_connections rd export input 2 
    	add_interface_port exported_connections td export output 2
	add_interface_port exported_connections rx_errdetect export output 8 
	} else {
	add_interface_port exported_connections rd export input 4 
	add_interface_port exported_connections td export output 4
	add_interface_port exported_connections rx_errdetect export output 8
    }

    add_interface_port exported_connections ef_ptr  export input 16
    add_interface_port exported_connections no_sync_indicator export output 1

    if {[param_matches phy_selection "stratixiigx"] || [param_matches phy_selection "stratixiigxlite"] } {
	add_interface_port exported_connections reconfig_fromgxb export output 1
    } elseif {[param_matches phy_selection "cycloneivgx"]} {
	add_interface_port exported_connections reconfig_fromgxb export output 5
    } elseif {[param_matches phy_selection "stratixivgx"] || [param_matches phy_selection "hardcopyivgx"] || [param_matches phy_selection "arriaiigx"] || [param_matches phy_selection "arriaiigz"]} {
	add_interface_port exported_connections reconfig_fromgxb export output 17
    }

    # Stratix V reconfiguration ports
    if {$use_xcvr_phy_mode == 1} {
        
        # Create reconfig_fromgxb and reconfig_togxb ports according to PHY IP dynamically
        if {[param_matches mode_selection "SERIAL_1X" ]} {
            set lanes 1
        } elseif {[param_matches mode_selection "SERIAL_2X" ]} {
            set lanes 2
        } else {
            set lanes 4
        }
        set reconfig_interfaces [common_get_reconfig_interface_count $family $lanes 1]
        common_add_tagged_conduit reconfig_togxb input [common_get_reconfig_to_xcvr_total_width $family $reconfig_interfaces ] reconfig_to_xcvr
    	common_add_tagged_conduit reconfig_fromgxb output [common_get_reconfig_from_xcvr_total_width $family $reconfig_interfaces] reconfig_from_xcvr 
    	
    	# Display message to let user know the number of reconfiguration interface required
        common_display_reconfig_interface_message $family $lanes 1
    }

    add_interface_port exported_connections master_enable export output 1
    # For Arria 10 and above family devices, the TX PLL is absorbed by user design instead of RapidIO IP but we will request
    # the PLL locked signal to deassert the reset signal for RapidIO
    if  {$use_native_phy_mode == 0} {
        add_interface_port exported_connections gxbpll_locked export output 1
    } else {
        add_interface_port exported_connections gxbpll_locked export input 1
        
    }
    
    add_interface_port exported_connections port_initialized export output 1
    add_interface_port exported_connections atxwlevel export output [expr $txbuf_addr_width + 4]
    add_interface_port exported_connections atxovf export output 1
    add_interface_port exported_connections arxwlevel export output [expr $rxbuf_addr_width + 5]
    add_interface_port exported_connections buf_av0 export output 1
    add_interface_port exported_connections buf_av1 export output 1
    add_interface_port exported_connections buf_av2 export output 1
    add_interface_port exported_connections buf_av3 export output 1
    add_interface_port exported_connections packet_transmitted export output 1
    add_interface_port exported_connections packet_cancelled export output 1
    add_interface_port exported_connections packet_accepted export output 1
    add_interface_port exported_connections packet_retry export output 1
    add_interface_port exported_connections packet_not_accepted export output 1
    add_interface_port exported_connections packet_crc_error export output 1
    add_interface_port exported_connections symbol_error export output 1
    add_interface_port exported_connections port_error export output 1
    add_interface_port exported_connections char_err export output 1
    add_interface_port exported_connections multicast_event_rx export output 1

    if {[string compare -nocase [get_parameter_value p_GENERIC_LOGICAL] true] == 0 } {
      # Source operation and Destination operation is only supported when Avalon-ST Pass-through interface is enabled.
      if {[string compare -nocase [get_parameter_value p_SOURCE_OPERATION_DATA_MESSAGE] true] == 0 || [string compare -nocase [get_parameter_value p_DESTINATION_OPERATION_DATA_MESSAGE] true] == 0 } {
	# exports opt based on "source operation" or "destination operation" params
	add_interface rio_data_messages conduit end
	add_interface_port rio_data_messages error_detect_message_error_response export input 1
	add_interface_port rio_data_messages error_detect_message_format_error export input 1
	add_interface_port rio_data_messages error_detect_message_request_timeout export input 1
	add_interface_port rio_data_messages error_capture_letter export input 2
	add_interface_port rio_data_messages error_capture_mbox export input 2
	add_interface_port rio_data_messages error_capture_msgseg_or_xmbox export input 4
	add_interface_port rio_data_messages error_detect_illegal_transaction_decode export input 1
	add_interface_port rio_data_messages error_detect_illegal_transaction_target export input 1
	add_interface_port rio_data_messages error_detect_packet_response_timeout export input 1
	add_interface_port rio_data_messages error_detect_unsolicited_response export input 1
	add_interface_port rio_data_messages error_detect_unsupported_transaction export input 1
	add_interface_port rio_data_messages error_capture_ftype export input 4
	add_interface_port rio_data_messages error_capture_ttype export input 4
	add_interface_port rio_data_messages error_capture_destination_id export input 16
	add_interface_port rio_data_messages error_capture_source_id export input 16
      } else {
        if {$use_native_phy_mode == 1} {
          add_interface rio_data_messages conduit end
          add_interface_port rio_data_messages error_detect_message_error_response export input 1
          set_port_property error_detect_message_error_response TERMINATION TRUE
          set_port_property error_detect_message_error_response TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_message_format_error export input 1
          set_port_property error_detect_message_format_error TERMINATION TRUE
          set_port_property error_detect_message_format_error TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_message_request_timeout export input 1
          set_port_property error_detect_message_request_timeout TERMINATION TRUE
          set_port_property error_detect_message_request_timeout TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_letter export input 2
          set_port_property error_capture_letter TERMINATION TRUE
          set_port_property error_capture_letter TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_mbox export input 2
          set_port_property error_capture_mbox TERMINATION TRUE
          set_port_property error_capture_mbox TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_msgseg_or_xmbox export input 4
          set_port_property error_capture_msgseg_or_xmbox TERMINATION TRUE
          set_port_property error_capture_msgseg_or_xmbox TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_illegal_transaction_decode export input 1
          set_port_property error_detect_illegal_transaction_decode TERMINATION TRUE
          set_port_property error_detect_illegal_transaction_decode TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_illegal_transaction_target export input 1
          set_port_property error_detect_illegal_transaction_target TERMINATION TRUE
          set_port_property error_detect_illegal_transaction_target TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_packet_response_timeout export input 1
          set_port_property error_detect_packet_response_timeout TERMINATION TRUE
          set_port_property error_detect_packet_response_timeout TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_unsolicited_response export input 1
          set_port_property error_detect_unsolicited_response TERMINATION TRUE
          set_port_property error_detect_unsolicited_response TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_unsupported_transaction export input 1
          set_port_property error_detect_unsupported_transaction TERMINATION TRUE
          set_port_property error_detect_unsupported_transaction TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_ftype export input 4
          set_port_property error_capture_ftype TERMINATION TRUE
          set_port_property error_capture_ftype TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_ttype export input 4
          set_port_property error_capture_ttype TERMINATION TRUE
          set_port_property error_capture_ttype TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_destination_id export input 16
          set_port_property error_capture_destination_id TERMINATION TRUE
          set_port_property error_capture_destination_id TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_source_id export input 16
          set_port_property error_capture_source_id TERMINATION TRUE
          set_port_property error_capture_source_id TERMINATION_VALUE 0
        }
      }
    } else {
        if {$use_native_phy_mode == 1} {
          add_interface rio_data_messages conduit end
          add_interface_port rio_data_messages error_detect_message_error_response export input 1
          set_port_property error_detect_message_error_response TERMINATION TRUE
          set_port_property error_detect_message_error_response TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_message_format_error export input 1
          set_port_property error_detect_message_format_error TERMINATION TRUE
          set_port_property error_detect_message_format_error TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_message_request_timeout export input 1
          set_port_property error_detect_message_request_timeout TERMINATION TRUE
          set_port_property error_detect_message_request_timeout TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_letter export input 2
          set_port_property error_capture_letter TERMINATION TRUE
          set_port_property error_capture_letter TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_mbox export input 2
          set_port_property error_capture_mbox TERMINATION TRUE
          set_port_property error_capture_mbox TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_msgseg_or_xmbox export input 4
          set_port_property error_capture_msgseg_or_xmbox TERMINATION TRUE
          set_port_property error_capture_msgseg_or_xmbox TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_illegal_transaction_decode export input 1
          set_port_property error_detect_illegal_transaction_decode TERMINATION TRUE
          set_port_property error_detect_illegal_transaction_decode TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_illegal_transaction_target export input 1
          set_port_property error_detect_illegal_transaction_target TERMINATION TRUE
          set_port_property error_detect_illegal_transaction_target TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_packet_response_timeout export input 1
          set_port_property error_detect_packet_response_timeout TERMINATION TRUE
          set_port_property error_detect_packet_response_timeout TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_unsolicited_response export input 1
          set_port_property error_detect_unsolicited_response TERMINATION TRUE
          set_port_property error_detect_unsolicited_response TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_detect_unsupported_transaction export input 1
          set_port_property error_detect_unsupported_transaction TERMINATION TRUE
          set_port_property error_detect_unsupported_transaction TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_ftype export input 4
          set_port_property error_capture_ftype TERMINATION TRUE
          set_port_property error_capture_ftype TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_ttype export input 4
          set_port_property error_capture_ttype TERMINATION TRUE
          set_port_property error_capture_ttype TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_destination_id export input 16
          set_port_property error_capture_destination_id TERMINATION TRUE
          set_port_property error_capture_destination_id TERMINATION_VALUE 0
          add_interface_port rio_data_messages error_capture_source_id export input 16
          set_port_property error_capture_source_id TERMINATION TRUE
          set_port_property error_capture_source_id TERMINATION_VALUE 0
        }
    }



    if {[string compare -nocase ${io_interface} "AVALONMASTER" ] == 0 || [string compare -nocase ${io_interface} "AVALONMASTERSLAVE" ] == 0 } {

	#  io master wr (opt)
	add_interface io_write_master avalon master clock
	add_interface_port io_write_master io_m_wr_waitrequest waitrequest input 1
	add_interface_port io_write_master io_m_wr_write write output 1
	add_interface_port io_write_master io_m_wr_address address output 32

   if {[param_matches mode_selection "SERIAL_1X" ]} {
	    add_interface_port io_write_master io_m_wr_writedata writedata output 32
	    add_interface_port io_write_master io_m_wr_byteenable  byteenable output 4
	    add_interface_port io_write_master io_m_wr_burstcount burstcount output 7
	} else {
	    add_interface_port io_write_master io_m_wr_writedata writedata output 64
	    add_interface_port io_write_master io_m_wr_byteenable  byteenable output 8
	    add_interface_port io_write_master io_m_wr_burstcount burstcount output 6 
	}

	# io master rd(opt)
	add_interface io_read_master avalon master clock
	add_interface_port io_read_master io_m_rd_waitrequest waitrequest input 1
	add_interface_port io_read_master io_m_rd_readdatavalid readdatavalid input 1
#	add_interface_port io_read_master io_m_rd_readerror endofpacket input 1
        add_interface_port exported_connections io_m_rd_readerror export input 1
	add_interface_port io_read_master io_m_rd_read read output 1
	add_interface_port io_read_master io_m_rd_address address output 32
   if {[param_matches mode_selection "SERIAL_1X" ]} {
	    add_interface_port io_read_master io_m_rd_readdata readdata input 32
	    add_interface_port io_read_master io_m_rd_burstcount burstcount output 7 
	} else {
	    add_interface_port io_read_master io_m_rd_readdata readdata input 64 
	    add_interface_port io_read_master io_m_rd_burstcount burstcount output 6 
	}
    }

    if {[string compare -nocase ${io_interface} "AVALONSLAVE" ] == 0 || [string compare -nocase ${io_interface} "AVALONMASTERSLAVE" ] == 0 } {

	# io slave wr(opt)
	add_interface io_write_slave avalon slave clock
	add_interface_port io_write_slave io_s_wr_chipselect chipselect Input 1
	add_interface_port io_write_slave io_s_wr_write write Input 1
	add_interface_port io_write_slave io_s_wr_address address Input $io_slave_addr_width
   if {[param_matches mode_selection "SERIAL_1X" ]} {
	    add_interface_port io_write_slave io_s_wr_writedata writedata Input 32
	    add_interface_port io_write_slave io_s_wr_byteenable byteenable Input 4 
	    add_interface_port io_write_slave io_s_wr_burstcount burstcount Input 7
	} else {
	    add_interface_port io_write_slave io_s_wr_writedata writedata Input 64 
	    add_interface_port io_write_slave io_s_wr_byteenable byteenable Input 8 
	    add_interface_port io_write_slave io_s_wr_burstcount burstcount Input 6 
	}

	add_interface_port io_write_slave io_s_wr_waitrequest waitrequest Output 1

	# io slave rd(opt)
	add_interface io_read_slave avalon slave clock
	set_interface_property io_read_slave maximumPendingReadTransactions 14
	add_interface_port io_read_slave io_s_rd_chipselect chipselect Input 1
	add_interface_port io_read_slave io_s_rd_read read Input 1
	add_interface_port io_read_slave io_s_rd_address address Input $io_slave_addr_width
  
	add_interface_port io_read_slave io_s_rd_waitrequest waitrequest Output 1
	add_interface_port io_read_slave io_s_rd_readdatavalid readdatavalid Output 1
   if {[param_matches mode_selection "SERIAL_1X" ]} {
	    add_interface_port io_read_slave io_s_rd_burstcount burstcount Input 7
	    add_interface_port io_read_slave io_s_rd_readdata readdata Output 32 
	} else {
	    add_interface_port io_read_slave io_s_rd_burstcount burstcount Input 6 
	    add_interface_port io_read_slave io_s_rd_readdata readdata Output 64
	}

#	add_interface_port io_read_slave io_s_rd_readerror endofpacket Output 1
	add_interface_port exported_connections io_s_rd_readerror export Output 1
    }


    if {[string compare -nocase [get_parameter_value p_DRBELL_TX] true] == 0 || [string compare -nocase [get_parameter_value p_DRBELL_RX] true] == 0} {
	# doorbell slave (opt)
	add_interface drbell_slave avalon slave clock
	add_interface_port drbell_slave drbell_s_chipselect chipselect Input 1
	add_interface_port drbell_slave drbell_s_read read Input 1
	add_interface_port drbell_slave drbell_s_write write Input 1
	add_interface_port drbell_slave drbell_s_address address Input 4
	add_interface_port drbell_slave drbell_s_writedata writedata Input 32
	add_interface_port drbell_slave drbell_s_waitrequest waitrequest Output 1
	add_interface_port drbell_slave drbell_s_readdata readdata Output 32

	add_interface drbell_s_irq interrupt end
	set_interface_property drbell_s_irq associatedAddressablePoint drbell_slave
	set_interface_property drbell_s_irq ASSOCIATED_CLOCK clock
	add_interface_port drbell_s_irq drbell_s_irq irq Output 1
    }

    if { [param_matches rio_p_maintenance_master_slave "AVALONMASTER" ] || [param_matches rio_p_maintenance_master_slave "AVALONMASTERSLAVE" ] } {

	# maintenance master (opt)
	add_interface mnt_master avalon master clock
	add_interface_port mnt_master mnt_m_read read output 1
	add_interface_port mnt_master mnt_m_write write output 1
	add_interface_port mnt_master mnt_m_address address output 32
	add_interface_port mnt_master mnt_m_writedata writedata output 32
	add_interface_port mnt_master mnt_m_waitrequest waitrequest input 1
	add_interface_port mnt_master mnt_m_readdata readdata input 32
	add_interface_port mnt_master mnt_m_readdatavalid readdatavalid input 1

    }

    if { [param_matches rio_p_maintenance_master_slave "AVALONSLAVE" ] || [param_matches rio_p_maintenance_master_slave "AVALONMASTERSLAVE" ] } {
	# maint slave (opt)
	add_interface mnt_slave avalon slave clock
	set_interface_property mnt_slave maximumPendingReadTransactions 1
	add_interface_port mnt_slave mnt_s_chipselect chipselect Input 1
	add_interface_port mnt_slave mnt_s_read read Input 1
	add_interface_port mnt_slave mnt_s_write write Input 1
	add_interface_port mnt_slave mnt_s_address address Input 24
	add_interface_port mnt_slave mnt_s_writedata writedata Input 32
	add_interface_port mnt_slave mnt_s_waitrequest waitrequest Output 1
	add_interface_port mnt_slave mnt_s_readdata readdata Output 32
#	add_interface_port mnt_slave mnt_s_readerror endofpacket Output 1
	add_interface_port exported_connections mnt_s_readerror export Output 1
	add_interface_port mnt_slave mnt_s_readdatavalid readdatavalid Output 1
    }

    # avalon system maintenance slave
    add_interface sys_mnt_slave avalon slave clock
    add_interface_port sys_mnt_slave sys_mnt_s_chipselect chipselect Input 1
    add_interface_port sys_mnt_slave sys_mnt_s_read read Input 1
    add_interface_port sys_mnt_slave sys_mnt_s_write write Input 1
    add_interface_port sys_mnt_slave sys_mnt_s_address address Input 15
    add_interface_port sys_mnt_slave sys_mnt_s_writedata writedata Input 32
    add_interface_port sys_mnt_slave sys_mnt_s_waitrequest waitrequest Output 1
    add_interface_port sys_mnt_slave sys_mnt_s_readdata readdata Output 32

    add_interface sys_mnt_s_irq interrupt end
    set_interface_property sys_mnt_s_irq associatedAddressablePoint sys_mnt_slave
    set_interface_property sys_mnt_s_irq ASSOCIATED_CLOCK clock
    add_interface_port sys_mnt_s_irq sys_mnt_s_irq irq Output 1

    #avalon streaming pass through sink (opt)
    if {[string compare -nocase [get_parameter_value p_GENERIC_LOGICAL] true] == 0} {
	add_interface_port exported_connections port_response_timeout export output 24

	add_interface pass_through_tx avalon_streaming sink clock
	set_interface_property pass_through_tx dataBitsPerSymbol 8
	set_interface_property pass_through_tx errorDescriptor ""
	set_interface_property pass_through_tx maxChannel 0
	set_interface_property pass_through_tx readyLatency 1
	set_interface_property pass_through_tx symbolsPerBeat 1
	
	set_interface_property pass_through_tx ENABLED true
	add_interface_port pass_through_tx gen_tx_valid valid Input 1
	add_interface_port pass_through_tx gen_tx_startofpacket startofpacket Input 1
	add_interface_port pass_through_tx gen_tx_endofpacket endofpacket Input 1
	add_interface_port pass_through_tx gen_tx_error error Input 1
	if {[param_matches mode_selection "SERIAL_1X" ]} {
		add_interface_port pass_through_tx gen_tx_empty empty Input 2
		add_interface_port pass_through_tx gen_tx_data data Input 32
	} else {
		add_interface_port pass_through_tx gen_tx_empty empty Input 3
		add_interface_port pass_through_tx gen_tx_data data Input 64		
	}
	add_interface_port pass_through_tx gen_tx_ready ready Output 1
	
	#avalon streaminf pass through source (opt)
	add_interface pass_through_rx avalon_streaming source clock
	set_interface_property pass_through_rx dataBitsPerSymbol 8
	set_interface_property pass_through_rx errorDescriptor ""
	set_interface_property pass_through_rx maxChannel 0
	set_interface_property pass_through_rx readyLatency 1
	set_interface_property pass_through_rx symbolsPerBeat 1
	
	set_interface_property pass_through_rx ENABLED true
	add_interface_port pass_through_rx gen_rx_valid valid Output 1
	add_interface_port pass_through_rx gen_rx_startofpacket startofpacket Output 1
	add_interface_port pass_through_rx gen_rx_endofpacket endofpacket Output 1
    if  {$use_native_phy_mode == 0} {
	    add_interface_port pass_through_rx gen_rx_error error Output 1
    }
	if {[param_matches mode_selection "SERIAL_1X" ]} {
		add_interface_port pass_through_rx gen_rx_empty empty Output 2
		add_interface_port pass_through_rx gen_rx_data data Output 32
		#add_interface_port pass_through_rx gen_rx_size size Output 7
                #Note: gen_rx_size bus is added to the exported_connections bundle until Avalon-ST adds a size signal.
                add_interface_port exported_connections gen_rx_size export output 7
	} else {
		add_interface_port pass_through_rx gen_rx_empty empty Output 3
		add_interface_port pass_through_rx gen_rx_data data Output 64
		#add_interface_port pass_through_rx gen_rx_size size Output 6
                add_interface_port exported_connections gen_rx_size export output 6
	}
	add_interface_port pass_through_rx gen_rx_ready ready Input 1
    }
   if  {$use_native_phy_mode == 1} {
   	# For Arria 10 and above family devices transceiver components instantiations and CSR, CAR termination value setting based on parameters
   	# 1) Transceiver Native PHY is instantiated
   	
   	set_parameter_property "XCVR_RECONFIG" VISIBLE true 
        set_display_item_property "Transceiver Settings" VISIBLE true
   	  	
   	add_hdl_instance altera_rapidio_xcvr_native_phy altera_xcvr_native_a10
        set_instance_property altera_rapidio_xcvr_native_phy HDLINSTANCE_USE_GENERATED_NAME 1
	set_instance_parameter_value altera_rapidio_xcvr_native_phy base_device [get_parameter_value "BASE_DEVICE"]
   	set_instance_parameter_value altera_rapidio_xcvr_native_phy  protocol_mode "basic_std"
   	if {[param_matches mode_selection SERIAL_1X]} {
       	set_instance_parameter_value altera_rapidio_xcvr_native_phy  channels 1
       	set num_of_pll 1
       	set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_tx_byte_ser_mode "Disabled"
        set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_rx_byte_deser_mode "Disabled"
   	} elseif {[param_matches mode_selection SERIAL_2X]} {
       	set_instance_parameter_value altera_rapidio_xcvr_native_phy  channels 2
       	set num_of_pll 2
       	set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_tx_byte_ser_mode "Serialize x2"
        set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_rx_byte_deser_mode "Deserialize x2"
   	} else {
       	set_instance_parameter_value altera_rapidio_xcvr_native_phy  channels 4
       	set num_of_pll 4
       	set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_tx_byte_ser_mode "Disabled"
        set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_rx_byte_deser_mode "Disabled"
   	}
   	set_instance_parameter_value altera_rapidio_xcvr_native_phy std_pcs_pma_width 20
   	set_instance_parameter_value altera_rapidio_xcvr_native_phy  set_data_rate [get_parameter_value p_data_rate]
   	set_instance_parameter_value altera_rapidio_xcvr_native_phy set_cdr_refclk_freq [get_parameter_value p_ref_clk_freq]
   	set_instance_parameter_value altera_rapidio_xcvr_native_phy duplex_mode duplex
    set_instance_parameter_value altera_rapidio_xcvr_native_phy  bonded_mode pma_only
    set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_simple_interface 1
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_port_tx_pma_elecidle 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy std_pcs_pma_width 20
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_port_rx_pma_clkout 0
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_port_rx_is_lockedtodata 1
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_port_rx_is_lockedtoref 1 
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  enable_ports_rx_manual_cdr_mode 1
     
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_tx_8b10b_enable 1
      set_instance_parameter_value  altera_rapidio_xcvr_native_phy  std_rx_8b10b_enable 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy std_tx_bitslip_enable false
      set_instance_parameter_value altera_rapidio_xcvr_native_phy std_tx_8b10b_enable true
      set_instance_parameter_value altera_rapidio_xcvr_native_phy std_rx_8b10b_enable true
      set_instance_parameter_value altera_rapidio_xcvr_native_phy enable_port_rx_std_bitslip false
      set_instance_parameter_value altera_rapidio_xcvr_native_phy std_rx_word_aligner_mode "synchronous state machine"
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_word_aligner_pattern 124
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_word_aligner_rknumber 127
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_word_aligner_renumber 3
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_word_aligner_rgnumber 255
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_rx_std_wa_patternalign 0
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_tx_bitrev_enable 0
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_tx_byterev_enable 0
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_tx_polinv_enable 1	
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_tx_polinv 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_bitrev_enable 1 
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_rx_std_bitrev_ena 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_byterev_enable 0 
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_rx_std_byterev_ena 0
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  std_rx_polinv_enable 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_rx_polinv 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  enable_port_rx_std_signaldetect 1
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  rcfg_enable [get_parameter_value "XCVR_RECONFIG"]
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  set_capability_reg_enable [get_parameter_value "XCVR_CAPABILITY_REG_EN"]
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  set_user_identifier [get_parameter_value "XCVR_SET_USER_IDENTIFIER"]
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  set_csr_soft_logic_enable [get_parameter_value "XCVR_CSR_SOFT_LOG_EN"]
      set_instance_parameter_value altera_rapidio_xcvr_native_phy  set_prbs_soft_logic_enable [get_parameter_value "XCVR_PRBS_SOFT_LOG_EN"]


      #2) Create interface for native PHY IP usage4
       # External PLL signals
        #add_interface tx_bonding_clocks hssi_bonded_clock end
        #add_interface_port tx_bonding_clocks tx_bonding_clocks clk input $num_of_pll*6
        
        if { [param_matches mode_selection "SERIAL_4X"]} {
        #separate the tx_bonding_clocks to per channel to enable connection in Qsys. 
            add_interface tx_bonding_clocks_ch0 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch0 tx_bonding_clocks_ch0 clk input 6
            set_port_property tx_bonding_clocks_ch0 fragment_list "tx_bonding_clocks(5:0)"

            add_interface tx_bonding_clocks_ch1 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch1 tx_bonding_clocks_ch1 clk input 6
            set_port_property tx_bonding_clocks_ch1 fragment_list "tx_bonding_clocks(11:6)"

            add_interface tx_bonding_clocks_ch2 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch2 tx_bonding_clocks_ch2 clk input 6
            set_port_property tx_bonding_clocks_ch2 fragment_list "tx_bonding_clocks(17:12)"

            add_interface tx_bonding_clocks_ch3 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch3 tx_bonding_clocks_ch3 clk input 6
            set_port_property tx_bonding_clocks_ch3 fragment_list "tx_bonding_clocks(23:18)"

        } elseif {[param_matches mode_selection "SERIAL_2X"]} {
            add_interface tx_bonding_clocks_ch0 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch0 tx_bonding_clocks_ch0 clk input 6
            set_port_property tx_bonding_clocks_ch0 fragment_list "tx_bonding_clocks(5:0)"

            add_interface tx_bonding_clocks_ch1 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch1 tx_bonding_clocks_ch1 clk input 6
            set_port_property tx_bonding_clocks_ch1 fragment_list "tx_bonding_clocks(11:6)"

        } else {
            add_interface tx_bonding_clocks_ch0 hssi_bonded_clock end
            add_interface_port tx_bonding_clocks_ch0 tx_bonding_clocks_ch0 clk input 6
            set_port_property tx_bonding_clocks_ch0 fragment_list "tx_bonding_clocks(5:0)"
        }

        # External reconfig signals
        if { [param_is_true XCVR_RECONFIG] } {
            if {[param_matches mode_selection SERIAL_4X] } {
                add_interface reconfig_clk_ch0 clock sink
                add_interface_port reconfig_clk_ch0 reconfig_clk_ch0 clk input 1
                set_port_property reconfig_clk_ch0 fragment_list "reconfig_clk(0)"
                add_interface reconfig_reset_ch0 reset sink reconfig_clk_ch0
                add_interface_port reconfig_reset_ch0 reconfig_reset_ch0 reset input 1
                set_port_property reconfig_reset_ch0 fragment_list "reconfig_reset(0)"
                add_interface reconfig_avmm_ch0 avalon slave reconfig_clk_ch0
                add_interface_port reconfig_avmm_ch0 reconfig_write_ch0       write       input  1
                set_port_property reconfig_write_ch0 fragment_list "reconfig_write(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_read_ch0        read        input  1
                set_port_property reconfig_read_ch0 fragment_list "reconfig_read(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_address_ch0     address     input  10
                set_port_property reconfig_address_ch0 fragment_list "reconfig_address(9:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_writedata_ch0   writedata   input  32
                set_port_property reconfig_writedata_ch0 fragment_list "reconfig_writedata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_readdata_ch0    readdata    output 32 
                set_port_property reconfig_readdata_ch0 fragment_list "reconfig_readdata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_waitrequest_ch0 waitrequest output 1
                set_port_property reconfig_waitrequest_ch0 fragment_list "reconfig_waitrequest(0)"

                add_interface reconfig_clk_ch1 clock sink
                add_interface_port reconfig_clk_ch1 reconfig_clk_ch1 clk input 1
                set_port_property reconfig_clk_ch1 fragment_list "reconfig_clk(1)"
                add_interface reconfig_reset_ch1 reset sink reconfig_clk_ch1
                add_interface_port reconfig_reset_ch1 reconfig_reset_ch1 reset input 1
                set_port_property reconfig_reset_ch1 fragment_list "reconfig_reset(1)"
                add_interface reconfig_avmm_ch1 avalon slave reconfig_clk_ch1
                add_interface_port reconfig_avmm_ch1 reconfig_write_ch1       write       input  1
                set_port_property reconfig_write_ch1 fragment_list "reconfig_write(1)"
                add_interface_port reconfig_avmm_ch1 reconfig_read_ch1        read        input  1
                set_port_property reconfig_read_ch1 fragment_list "reconfig_read(1)"
                add_interface_port reconfig_avmm_ch1 reconfig_address_ch1     address     input  10
                set_port_property reconfig_address_ch1 fragment_list "reconfig_address(19:10)"
                add_interface_port reconfig_avmm_ch1 reconfig_writedata_ch1   writedata   input  32
                set_port_property reconfig_writedata_ch1 fragment_list "reconfig_writedata(63:32)"
                add_interface_port reconfig_avmm_ch1 reconfig_readdata_ch1    readdata    output 32 
                set_port_property reconfig_readdata_ch1 fragment_list "reconfig_readdata(63:32)"
                add_interface_port reconfig_avmm_ch1 reconfig_waitrequest_ch1 waitrequest output 1
                set_port_property reconfig_waitrequest_ch1 fragment_list "reconfig_waitrequest(1)"

                add_interface reconfig_clk_ch2 clock sink
                add_interface_port reconfig_clk_ch2 reconfig_clk_ch2 clk input 1
                set_port_property reconfig_clk_ch2 fragment_list "reconfig_clk(2)"
                add_interface reconfig_reset_ch2 reset sink reconfig_clk_ch2
                add_interface_port reconfig_reset_ch2 reconfig_reset_ch2 reset input 1
                set_port_property reconfig_reset_ch2 fragment_list "reconfig_reset(2)"
                add_interface reconfig_avmm_ch2 avalon slave reconfig_clk_ch2
                add_interface_port reconfig_avmm_ch2 reconfig_write_ch2       write       input  1
                set_port_property reconfig_write_ch2 fragment_list "reconfig_write(2)"
                add_interface_port reconfig_avmm_ch2 reconfig_read_ch2        read        input  1
                set_port_property reconfig_read_ch2 fragment_list "reconfig_read(2)"
                add_interface_port reconfig_avmm_ch2 reconfig_address_ch2     address     input  10
                set_port_property reconfig_address_ch2 fragment_list "reconfig_address(29:20)"
                add_interface_port reconfig_avmm_ch2 reconfig_writedata_ch2   writedata   input  32
                set_port_property reconfig_writedata_ch2 fragment_list "reconfig_writedata(95:64)"
                add_interface_port reconfig_avmm_ch2 reconfig_readdata_ch2    readdata    output 32 
                set_port_property reconfig_readdata_ch2 fragment_list "reconfig_readdata(95:64)"
                add_interface_port reconfig_avmm_ch2 reconfig_waitrequest_ch2 waitrequest output 1
                set_port_property reconfig_waitrequest_ch2 fragment_list "reconfig_waitrequest(2)"

                add_interface reconfig_clk_ch3 clock sink
                add_interface_port reconfig_clk_ch3 reconfig_clk_ch3 clk input 1
                set_port_property reconfig_clk_ch3 fragment_list "reconfig_clk(3)"
                add_interface reconfig_reset_ch3 reset sink reconfig_clk_ch3
                add_interface_port reconfig_reset_ch3 reconfig_reset_ch3 reset input 1
                set_port_property reconfig_reset_ch3 fragment_list "reconfig_reset(3)"
                add_interface reconfig_avmm_ch3 avalon slave reconfig_clk_ch3
                add_interface_port reconfig_avmm_ch3 reconfig_write_ch3       write       input  1
                set_port_property reconfig_write_ch3 fragment_list "reconfig_write(3)"
                add_interface_port reconfig_avmm_ch3 reconfig_read_ch3        read        input  1
                set_port_property reconfig_read_ch3 fragment_list "reconfig_read(3)"
                add_interface_port reconfig_avmm_ch3 reconfig_address_ch3     address     input  10
                set_port_property reconfig_address_ch3 fragment_list "reconfig_address(39:30)"
                add_interface_port reconfig_avmm_ch3 reconfig_writedata_ch3   writedata   input  32
                set_port_property reconfig_writedata_ch3 fragment_list "reconfig_writedata(127:96)"
                add_interface_port reconfig_avmm_ch3 reconfig_readdata_ch3    readdata    output 32 
                set_port_property reconfig_readdata_ch3 fragment_list "reconfig_readdata(127:96)"
                add_interface_port reconfig_avmm_ch3 reconfig_waitrequest_ch3 waitrequest output 1
                set_port_property reconfig_waitrequest_ch3 fragment_list "reconfig_waitrequest(3)"
            } elseif {[param_matches mode_selection SERIAL_2X]} {
                add_interface reconfig_clk_ch0 clock sink
                add_interface_port reconfig_clk_ch0 reconfig_clk_ch0 clk input 1
                set_port_property reconfig_clk_ch0 fragment_list "reconfig_clk(0)"
                add_interface reconfig_reset_ch0 reset sink reconfig_clk_ch0
                add_interface_port reconfig_reset_ch0 reconfig_reset_ch0 reset input 1
                set_port_property reconfig_reset_ch0 fragment_list "reconfig_reset(0)"
                add_interface reconfig_avmm_ch0 avalon slave reconfig_clk_ch0
                add_interface_port reconfig_avmm_ch0 reconfig_write_ch0       write       input  1
                set_port_property reconfig_write_ch0 fragment_list "reconfig_write(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_read_ch0        read        input  1
                set_port_property reconfig_read_ch0 fragment_list "reconfig_read(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_address_ch0     address     input  10
                set_port_property reconfig_address_ch0 fragment_list "reconfig_address(9:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_writedata_ch0   writedata   input  32
                set_port_property reconfig_writedata_ch0 fragment_list "reconfig_writedata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_readdata_ch0    readdata    output 32 
                set_port_property reconfig_readdata_ch0 fragment_list "reconfig_readdata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_waitrequest_ch0 waitrequest output 1
                set_port_property reconfig_waitrequest_ch0 fragment_list "reconfig_waitrequest(0)"

                add_interface reconfig_clk_ch1 clock sink
                add_interface_port reconfig_clk_ch1 reconfig_clk_ch1 clk input 1
                set_port_property reconfig_clk_ch1 fragment_list "reconfig_clk(1)"
                add_interface reconfig_reset_ch1 reset sink reconfig_clk_ch1
                add_interface_port reconfig_reset_ch1 reconfig_reset_ch1 reset input 1
                set_port_property reconfig_reset_ch1 fragment_list "reconfig_reset(1)"
                add_interface reconfig_avmm_ch1 avalon slave reconfig_clk_ch1
                add_interface_port reconfig_avmm_ch1 reconfig_write_ch1       write       input  1
                set_port_property reconfig_write_ch1 fragment_list "reconfig_write(1)"
                add_interface_port reconfig_avmm_ch1 reconfig_read_ch1        read        input  1
                set_port_property reconfig_read_ch1 fragment_list "reconfig_read(1)"
                add_interface_port reconfig_avmm_ch1 reconfig_address_ch1     address     input  10
                set_port_property reconfig_address_ch1 fragment_list "reconfig_address(19:10)"
                add_interface_port reconfig_avmm_ch1 reconfig_writedata_ch1   writedata   input  32
                set_port_property reconfig_writedata_ch1 fragment_list "reconfig_writedata(63:32)"
                add_interface_port reconfig_avmm_ch1 reconfig_readdata_ch1    readdata    output 32 
                set_port_property reconfig_readdata_ch1 fragment_list "reconfig_readdata(63:32)"
                add_interface_port reconfig_avmm_ch1 reconfig_waitrequest_ch1 waitrequest output 1
                set_port_property reconfig_waitrequest_ch1 fragment_list "reconfig_waitrequest(1)"
            } else {
                add_interface reconfig_clk_ch0 clock sink
                add_interface_port reconfig_clk_ch0 reconfig_clk_ch0 clk input 1
                set_port_property reconfig_clk_ch0 fragment_list "reconfig_clk(0)"
                add_interface reconfig_reset_ch0 reset sink reconfig_clk_ch0
                add_interface_port reconfig_reset_ch0 reconfig_reset_ch0 reset input 1
                set_port_property reconfig_reset_ch0 fragment_list "reconfig_reset(0)"
                add_interface reconfig_avmm_ch0 avalon slave reconfig_clk_ch0
                add_interface_port reconfig_avmm_ch0 reconfig_write_ch0       write       input  1
                set_port_property reconfig_write_ch0 fragment_list "reconfig_write(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_read_ch0        read        input  1
                set_port_property reconfig_read_ch0 fragment_list "reconfig_read(0)"
                add_interface_port reconfig_avmm_ch0 reconfig_address_ch0     address     input  10
                set_port_property reconfig_address_ch0 fragment_list "reconfig_address(9:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_writedata_ch0   writedata   input  32
                set_port_property reconfig_writedata_ch0 fragment_list "reconfig_writedata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_readdata_ch0    readdata    output 32 
                set_port_property reconfig_readdata_ch0 fragment_list "reconfig_readdata(31:0)"
                add_interface_port reconfig_avmm_ch0 reconfig_waitrequest_ch0 waitrequest output 1
                set_port_property reconfig_waitrequest_ch0 fragment_list "reconfig_waitrequest(0)"
            }
        } else {
            if {[param_matches mode_selection SERIAL_4X] } {
                add_interface reconfig_clk clock sink
                add_interface_port reconfig_clk reconfig_clk clk input 4
                set_port_property reconfig_clk TERMINATION TRUE
                set_port_property reconfig_clk TERMINATION_VALUE 0

                add_interface reconfig_reset reset sink reconfig_clk
                add_interface_port reconfig_reset reconfig_reset reset input 4
                set_port_property reconfig_reset TERMINATION TRUE
                set_port_property reconfig_reset TERMINATION_VALUE 0

                add_interface reconfig_avmm avalon slave reconfig_clk
                add_interface_port reconfig_avmm reconfig_write       write       input  4
                set_port_property reconfig_write TERMINATION TRUE
                set_port_property reconfig_write TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_read        read        input  4
                set_port_property reconfig_read  TERMINATION TRUE
                set_port_property reconfig_read  TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_address     address     input  40
                set_port_property reconfig_address TERMINATION TRUE
                set_port_property reconfig_address TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_writedata   writedata   input  128
                set_port_property reconfig_writedata TERMINATION TRUE
                set_port_property reconfig_writedata TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_readdata    readdata    output 128
                set_port_property reconfig_readdata TERMINATION TRUE

                add_interface_port reconfig_avmm reconfig_waitrequest waitrequest output 4
                set_port_property reconfig_waitrequest TERMINATION TRUE

           } elseif {[param_matches mode_selection SERIAL_2X]} {
                add_interface reconfig_clk clock sink
                add_interface_port reconfig_clk reconfig_clk clk input 2
                set_port_property reconfig_clk TERMINATION TRUE
                set_port_property reconfig_clk TERMINATION_VALUE 0

                add_interface reconfig_reset reset sink reconfig_clk
                add_interface_port reconfig_reset reconfig_reset reset input 2
                set_port_property reconfig_reset TERMINATION TRUE
                set_port_property reconfig_reset TERMINATION_VALUE 0

                add_interface reconfig_avmm avalon slave reconfig_clk
                add_interface_port reconfig_avmm reconfig_write       write       input  2
                set_port_property reconfig_write TERMINATION TRUE
                set_port_property reconfig_write TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_read        read        input  2
                set_port_property reconfig_read TERMINATION TRUE
                set_port_property reconfig_read TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_address     address     input  20
                set_port_property reconfig_address TERMINATION TRUE
                set_port_property reconfig_address TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_writedata   writedata   input  64
                set_port_property reconfig_writedata TERMINATION TRUE
                set_port_property reconfig_writedata TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_readdata    readdata    output 64 
                set_port_property reconfig_readdata TERMINATION TRUE

                add_interface_port reconfig_avmm reconfig_waitrequest waitrequest output 2
                set_port_property reconfig_waitrequest TERMINATION TRUE

           } else {
                add_interface reconfig_clk clock sink
                add_interface_port reconfig_clk reconfig_clk clk input 1
                set_port_property reconfig_clk TERMINATION TRUE
                set_port_property reconfig_clk TERMINATION_VALUE 0

                add_interface reconfig_reset reset sink reconfig_clk
                add_interface_port reconfig_reset reconfig_reset reset input 1
                set_port_property reconfig_reset TERMINATION TRUE
                set_port_property reconfig_reset TERMINATION_VALUE 0

                add_interface reconfig_avmm avalon slave reconfig_clk
                add_interface_port reconfig_avmm reconfig_write       write       input  1
                set_port_property reconfig_write TERMINATION TRUE
                set_port_property reconfig_write TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_read        read        input  1
                set_port_property reconfig_read TERMINATION TRUE
                set_port_property reconfig_read TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_address     address     input  10
                set_port_property reconfig_address TERMINATION TRUE
                set_port_property reconfig_address TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_writedata   writedata   input  32
                set_port_property reconfig_writedata TERMINATION TRUE
                set_port_property reconfig_writedata TERMINATION_VALUE 0

                add_interface_port reconfig_avmm reconfig_readdata    readdata    output 32 
                set_port_property reconfig_readdata TERMINATION TRUE

                add_interface_port reconfig_avmm reconfig_waitrequest waitrequest output 1
                set_port_property reconfig_waitrequest TERMINATION TRUE

           }
        }

        
      
           
      # 3) Create ports for CSR and CAR related ports and set the termination value
      add_interface car_csr_intf conduit end
      
      add_interface_port car_csr_intf device_identifier export input 16
      set_port_property device_identifier TERMINATION TRUE
      set_port_property device_identifier TERMINATION_VALUE [get_parameter_value p_DEVICE_ID]
      
      add_interface_port car_csr_intf device_vendor_id export input 16
      set_port_property device_vendor_id TERMINATION TRUE
      set_port_property device_vendor_id TERMINATION_VALUE [get_parameter_value p_DEVICE_VENDOR_ID]
      
      add_interface_port car_csr_intf device_revision export input 32
      set_port_property device_revision TERMINATION TRUE
      set_port_property device_revision TERMINATION_VALUE [get_parameter_value p_DEVICE_REV]
      
      add_interface_port car_csr_intf assembly_id export input 16
      set_port_property assembly_id TERMINATION TRUE
      set_port_property assembly_id TERMINATION_VALUE [get_parameter_value p_ASSEMBLY_ID]
      
      add_interface_port car_csr_intf assembly_vendor_id export input 16
      set_port_property assembly_vendor_id TERMINATION TRUE
      set_port_property assembly_vendor_id TERMINATION_VALUE [get_parameter_value p_ASSEMBLY_VENDOR_ID]
      
      add_interface_port car_csr_intf assembly_revision export input 16
      set_port_property assembly_revision TERMINATION TRUE
      set_port_property assembly_revision TERMINATION_VALUE [get_parameter_value p_ASSEMBLY_REVISION]
      
      add_interface_port car_csr_intf extended_features_ptr export input 16
      set_port_property extended_features_ptr TERMINATION TRUE
      set_port_property extended_features_ptr TERMINATION_VALUE [get_parameter_value p_FIRST_EF_PTR]
      
      add_interface_port car_csr_intf bridge_support export input 1
      set_port_property bridge_support TERMINATION TRUE
      set_port_property bridge_support TERMINATION_VALUE [param_matches p_BRIDGE true]
      
      add_interface_port car_csr_intf memory_access export input 1
      set_port_property memory_access TERMINATION TRUE
      set_port_property memory_access TERMINATION_VALUE [param_matches p_MEMORY true]

      add_interface_port car_csr_intf processor_present export input 1
      set_port_property processor_present TERMINATION TRUE
      set_port_property processor_present TERMINATION_VALUE [param_matches p_PROCESSOR true]
      
      add_interface_port car_csr_intf switch_support export input 1
      set_port_property switch_support TERMINATION TRUE
      set_port_property switch_support TERMINATION_VALUE [param_matches p_SWITCH true]

      add_interface_port car_csr_intf number_of_ports export input 8
      set_port_property number_of_ports TERMINATION TRUE
      set_port_property number_of_ports TERMINATION_VALUE [get_parameter_value p_PORT_TOTAL]
      
      add_interface_port car_csr_intf port_number export input 8
      set_port_property port_number TERMINATION TRUE
      set_port_property port_number TERMINATION_VALUE [get_parameter_value p_PORT_NUMBER]

      # 4) Create ports for buffer size which is set according to parameter
      add_interface rx_buf_threshold_intf conduit end
      
      add_interface_port rx_buf_threshold_intf rx_threshold_0 export input 10
      set_port_property rx_threshold_0 TERMINATION TRUE
      set_port_property rx_threshold_0 TERMINATION_VALUE [get_parameter_value p_rx_threshold_0]
      
      add_interface_port rx_buf_threshold_intf rx_threshold_1 export input 10
      set_port_property rx_threshold_1 TERMINATION TRUE
      set_port_property rx_threshold_1 TERMINATION_VALUE [get_parameter_value p_rx_threshold_1]
      
      add_interface_port rx_buf_threshold_intf rx_threshold_2 export input 10
      set_port_property rx_threshold_2 TERMINATION TRUE
      set_port_property rx_threshold_2 TERMINATION_VALUE [get_parameter_value p_rx_threshold_2]
      
     # 5) Calculation for prescaler value to set the value for ports txclk_timeout_prescaler and sysclk_timeout_prescaler
         # Frequency = ( baud rate x number of lanes ) / bits per cycle
         # Period = bits per cycle / ( baud rate x number of lanes )
         
         if {[param_matches mode_selection "SERIAL_2X" ]} {
            set lanes 2
            set internal_data_width 64
            set xcvr_pma_width 20
         } else {
             set xcvr_pma_width 20
            if {[param_matches mode_selection "SERIAL_4X" ]} {
               set lanes 4
               set internal_data_width 64
            } else {
               set lanes 1
               set internal_data_width 32
            }
         }
         
         
         set data_rate_int [get_parameter_value p_data_rate] 
         set bits_per_cycle [expr (10.0 * ($internal_data_width / 8))]  
         set clock_period [expr {$bits_per_cycle / ( $data_rate_int * 1000000.0 * $lanes )}]
         set clock_cnt [expr 4.5 / $clock_period]
         set no_of_bit [expr log($clock_cnt) / log(2)]
         set no_of_bit_minus_24 [expr $no_of_bit - 24]
         set exp_no_of_bit_minus_24 [expr {2 ** $no_of_bit_minus_24}] 
         set prescaler_value [expr int($exp_no_of_bit_minus_24)]
         
                  
         add_interface clk_prescaler conduit end
      
         add_interface_port clk_prescaler txclk_timeout_prescaler export input 7
         set_port_property txclk_timeout_prescaler TERMINATION TRUE
         set_port_property txclk_timeout_prescaler TERMINATION_VALUE $prescaler_value
         
         add_interface_port clk_prescaler sysclk_timeout_prescaler export input 7
         set_port_property sysclk_timeout_prescaler TERMINATION TRUE
         set_port_property sysclk_timeout_prescaler TERMINATION_VALUE $prescaler_value
         
         set_parameter_value "p_PRESCALER_VALUE" $prescaler_value
                  
         if {[param_matches mode_selection "SERIAL_4X" ]} {
            set clock_period_in_ps [expr (20.0 /$data_rate_int) * 1000000]
         
         } else {
             set clock_period_in_ps [expr (40.0 / $data_rate_int) * 1000000]
         }
         set_parameter_value "p_SYS_CLK_PERIOD" $clock_period_in_ps
                  
         #6) Set the required parameter to be passed down to top level module
         set_parameter_property "mode_selection" HDL_PARAMETER true 
         set_parameter_property "p_TX_PORT_WRITE" HDL_PARAMETER true
         set_parameter_property "p_RX_PORT_WRITE" HDL_PARAMETER true
         set_parameter_property "p_DRBELL_TX" HDL_PARAMETER true
         set_parameter_property "p_DRBELL_RX" HDL_PARAMETER true
         set_parameter_property "p_TRANSPORT_LARGE" HDL_PARAMETER true
         set_parameter_property "p_GENERIC_LOGICAL" HDL_PARAMETER true
         set_parameter_property "p_SEND_RESET_DEVICE" HDL_PARAMETER true
         set_parameter_property "p_IO_SLAVE_WIDTH" HDL_PARAMETER true
         set_parameter_property "p_MAINTENANCE" HDL_PARAMETER true
         set_parameter_property "p_IO_MASTER" HDL_PARAMETER true
         set_parameter_property "p_IO_SLAVE" HDL_PARAMETER true
         set_parameter_property "p_timeout_enable" HDL_PARAMETER true
         set_parameter_property "XCVR_RECONFIG" HDL_PARAMETER true
         set_parameter_property "p_SOURCE_OPERATION_DATA_MESSAGE" HDL_PARAMETER true
         set_parameter_property "p_DESTINATION_OPERATION_DATA_MESSAGE" HDL_PARAMETER true
                            
         #7) Create the ports for transceiver reset controller
         add_interface transceiver_rst conduit end
         add_interface_port transceiver_rst  tx_analogreset tx_analogreset input $lanes
         add_interface_port transceiver_rst  rx_analogreset rx_analogreset input $lanes
         add_interface_port transceiver_rst  tx_digitalreset tx_digitalreset input $lanes
         add_interface_port transceiver_rst  rx_digitalreset rx_digitalreset input $lanes
         add_interface_port transceiver_rst  rx_is_lockedtodata rx_is_lockedtodata output $lanes
         add_interface_port transceiver_rst  tx_cal_busy tx_cal_busy output $lanes
         add_interface_port transceiver_rst  rx_cal_busy rx_cal_busy output $lanes
         
          #8) Create the transceiver PLL and reset controller for customer testbench usage
       	  set half_data_rate_int [expr $data_rate_int / 2.0 ]
       	  add_hdl_instance altera_rapidio_tx_pll altera_xcvr_atx_pll_a10
          set_instance_property altera_rapidio_tx_pll HDLINSTANCE_USE_GENERATED_NAME 1
	  set_instance_parameter_value altera_rapidio_tx_pll base_device [get_parameter_value "BASE_DEVICE"]
       	  set_instance_parameter_value altera_rapidio_tx_pll enable_8G_path "0"
       	  set_instance_parameter_value altera_rapidio_tx_pll set_output_clock_frequency ${half_data_rate_int}
       	  set_instance_parameter_value altera_rapidio_tx_pll set_auto_reference_clock_frequency [get_parameter_value p_ref_clk_freq]
       	  set_instance_parameter_value altera_rapidio_tx_pll enable_mcgb "1"
       	  set_instance_parameter_value altera_rapidio_tx_pll enable_bonding_clks "1"
       	  set_instance_parameter_value altera_rapidio_tx_pll pma_width $xcvr_pma_width
       	  
          add_hdl_instance altera_rapidio_xcvr_rst altera_xcvr_reset_control
          set_instance_property altera_rapidio_xcvr_rst HDLINSTANCE_USE_GENERATED_NAME 1
          if {[param_matches mode_selection SERIAL_1X]} {
             set_instance_parameter_value altera_rapidio_xcvr_rst CHANNELS 1
          } elseif {[param_matches mode_selection SERIAL_2X]} {
             set_instance_parameter_value altera_rapidio_xcvr_rst CHANNELS 2
          } else {
             set_instance_parameter_value altera_rapidio_xcvr_rst CHANNELS 4
          }
          set_instance_parameter_value altera_rapidio_xcvr_rst PLLS 1
          set_instance_parameter_value altera_rapidio_xcvr_rst SYS_CLK_IN_MHZ 156
          set_instance_parameter_value altera_rapidio_xcvr_rst SYNCHRONIZE_RESET 1
          set_instance_parameter_value altera_rapidio_xcvr_rst REDUCED_SIM_TIME 1
          set_instance_parameter_value altera_rapidio_xcvr_rst TX_PLL_ENABLE 1
          set_instance_parameter_value altera_rapidio_xcvr_rst T_PLL_POWERDOWN 1000
          set_instance_parameter_value altera_rapidio_xcvr_rst SYNCHRONIZE_PLL_RESET 0
          set_instance_parameter_value altera_rapidio_xcvr_rst TX_ENABLE 1
          set_instance_parameter_value altera_rapidio_xcvr_rst TX_PER_CHANNEL 0
          set_instance_parameter_value altera_rapidio_xcvr_rst T_TX_ANALOGRESET 70000
          set_instance_parameter_value altera_rapidio_xcvr_rst T_TX_DIGITALRESET 70000
          set_instance_parameter_value altera_rapidio_xcvr_rst T_PLL_LOCK_HYST 0
          set_instance_parameter_value altera_rapidio_xcvr_rst RX_ENABLE 1
          set_instance_parameter_value altera_rapidio_xcvr_rst RX_PER_CHANNEL 0
          set_instance_parameter_value altera_rapidio_xcvr_rst T_RX_ANALOGRESET 70000
          set_instance_parameter_value altera_rapidio_xcvr_rst T_RX_DIGITALRESET 1000000
   
       	  #9) Restrict the number of Windows mapping to be 16 
       	  param_disable "p_MAINTENANCE_WINDOWS" 
       	  param_disable "p_IO_MASTER_WINDOWS" 
       	  param_disable "p_IO_SLAVE_WINDOWS"
       	  send_message info "Number of transmit and receive address translation windows is set to 16 by default"
       	         	  
       	  
       	  #10) Restrict the p_LINK_REQUEST_ATTEMPTS to be 7
       	  param_disable "p_LINK_REQUEST_ATTEMPTS"
       	  
       	  #11) Restrict the p_RXBUFSIZE and p_TXBUFSIZE
       	  param_disable "p_RXBUFRSIZE"
       	  param_disable "p_TXBUFRSIZE"
       	  
       	  #12) Add transceiver related ports 
       	  if {[param_matches mode_selection "SERIAL_1X" ]} {
            add_interface_port exported_connections rx_ctrldetect export output 2
            add_interface_port exported_connections rx_patterndetect export output 2
          } else {
              add_interface_port exported_connections rx_ctrldetect export output 8
              add_interface_port exported_connections rx_patterndetect export output 8
          }
          
          add_interface_port exported_connections rx_is_lockedtoref export output $lanes
          add_interface_port exported_connections input_enable export input 1
          add_interface_port exported_connections output_enable export input 1
          
          #13) Due to static fileset and parameterization requirement, we need to pull up hanging
          # ports with 0
           if {[string compare -nocase [get_parameter_value p_GENERIC_LOGICAL] false] == 0} {
                add_interface pass_through_tx conduit end
                add_interface_port pass_through_tx gen_tx_valid valid Input 1
                set_port_property gen_tx_valid TERMINATION TRUE
                set_port_property gen_tx_valid TERMINATION_VALUE 0
                add_interface_port pass_through_tx gen_tx_startofpacket startofpacket Input 1
                set_port_property gen_tx_startofpacket TERMINATION TRUE
                set_port_property gen_tx_startofpacket TERMINATION_VALUE 0
                add_interface_port pass_through_tx gen_tx_endofpacket endofpacket Input 1
                set_port_property gen_tx_endofpacket TERMINATION TRUE
                set_port_property gen_tx_endofpacket TERMINATION_VALUE 0
                add_interface_port pass_through_tx gen_tx_error error Input 1
                set_port_property gen_tx_error TERMINATION TRUE
                set_port_property gen_tx_error TERMINATION_VALUE 0
                if {[param_matches mode_selection "SERIAL_1X" ]} {
                    add_interface_port pass_through_tx gen_tx_empty empty Input 2
                    set_port_property gen_tx_empty TERMINATION TRUE
                    set_port_property gen_tx_empty TERMINATION_VALUE 0
                    add_interface_port pass_through_tx gen_tx_data data Input 32
                    set_port_property gen_tx_data TERMINATION TRUE
                    set_port_property gen_tx_data TERMINATION_VALUE 0
                } else {
                    add_interface_port pass_through_tx gen_tx_empty empty Input 3
                    set_port_property gen_tx_empty TERMINATION TRUE
                    set_port_property gen_tx_empty TERMINATION_VALUE 0
                    add_interface_port pass_through_tx gen_tx_data data Input 64	
                    set_port_property gen_tx_data TERMINATION TRUE
                    set_port_property gen_tx_data TERMINATION_VALUE 0
               }
               add_interface_port pass_through_tx gen_tx_ready ready Output 1
               set_port_property gen_tx_ready TERMINATION TRUE
	            
               add_interface pass_through_rx conduit end
 
               add_interface_port pass_through_rx gen_rx_valid valid Output 1
               set_port_property gen_rx_valid TERMINATION TRUE
               add_interface_port pass_through_rx gen_rx_startofpacket startofpacket Output 1
               set_port_property gen_rx_startofpacket TERMINATION TRUE
               add_interface_port pass_through_rx gen_rx_endofpacket endofpacket Output 1
               set_port_property gen_rx_endofpacket TERMINATION TRUE

               if {[param_matches mode_selection "SERIAL_1X" ]} {
                   add_interface_port pass_through_rx gen_rx_empty empty Output 2
                   set_port_property gen_rx_empty TERMINATION TRUE
                   add_interface_port pass_through_rx gen_rx_data data Output 32
                   set_port_property gen_rx_data TERMINATION TRUE
                   add_interface_port exported_connections gen_rx_size export Output 7
                   set_port_property gen_rx_size TERMINATION TRUE
               } else {
                   add_interface_port pass_through_rx gen_rx_empty empty Output 3
                   set_port_property gen_rx_empty TERMINATION TRUE
                   add_interface_port pass_through_rx gen_rx_data data Output 64
                   set_port_property gen_rx_data TERMINATION TRUE
                   add_interface_port exported_connections gen_rx_size export Output 6
                   set_port_property gen_rx_size TERMINATION TRUE
               }
               add_interface_port pass_through_rx gen_rx_ready ready Input 1
               set_port_property gen_rx_ready TERMINATION TRUE
               set_port_property gen_rx_ready TERMINATION_VALUE 0

           }
           # End of pass through related ports
           
            if {[string compare -nocase [get_parameter_value p_DRBELL_TX] false] == 0 || [string compare -nocase [get_parameter_value p_DRBELL_RX] false] == 0} {
            	# doorbell slave (opt)
            	add_interface drbell_slave conduit end
            	add_interface_port drbell_slave drbell_s_chipselect chipselect Input 1
            	set_port_property drbell_s_chipselect TERMINATION TRUE
                set_port_property drbell_s_chipselect TERMINATION_VALUE 0
            	add_interface_port drbell_slave drbell_s_read read Input 1
            	set_port_property drbell_s_read TERMINATION TRUE
                set_port_property drbell_s_read TERMINATION_VALUE 0
            	add_interface_port drbell_slave drbell_s_write write Input 1
            	set_port_property drbell_s_write TERMINATION TRUE
                set_port_property drbell_s_write TERMINATION_VALUE 0
            	add_interface_port drbell_slave drbell_s_address address Input 4
            	set_port_property drbell_s_address  TERMINATION TRUE
                set_port_property drbell_s_address  TERMINATION_VALUE 0
            	add_interface_port drbell_slave drbell_s_writedata writedata Input 32
            	set_port_property drbell_s_writedata TERMINATION TRUE
                set_port_property drbell_s_writedata TERMINATION_VALUE 0
            	add_interface_port drbell_slave drbell_s_waitrequest waitrequest Output 1
                set_port_property drbell_s_waitrequest TERMINATION TRUE
            	add_interface_port drbell_slave drbell_s_readdata readdata Output 32
                set_port_property drbell_s_readdata TERMINATION TRUE
                add_interface_port drbell_slave drbell_s_irq irq Output 1
                set_port_property drbell_s_irq TERMINATION TRUE
            }
            # End of doorbell related ports
            
            
            if {[string compare -nocase ${io_interface} "NONE" ] == 0 } {
                #  io master wr (opt)
            	add_interface io_write_master conduit end
            	add_interface_port io_write_master io_m_wr_waitrequest waitrequest input 1
            	set_port_property io_m_wr_waitrequest TERMINATION TRUE
                set_port_property io_m_wr_waitrequest TERMINATION_VALUE 0
            	add_interface_port io_write_master io_m_wr_write write output 1
            	set_port_property io_m_wr_write TERMINATION TRUE
            	add_interface_port io_write_master io_m_wr_address address output 32
                set_port_property io_m_wr_address TERMINATION TRUE

                if {[param_matches mode_selection "SERIAL_1X" ]} {
            	    add_interface_port io_write_master io_m_wr_writedata writedata output 32
                    set_port_property io_m_wr_writedata TERMINATION TRUE
            	    add_interface_port io_write_master io_m_wr_byteenable  byteenable output 4
                    set_port_property io_m_wr_byteenable TERMINATION TRUE
            	    add_interface_port io_write_master io_m_wr_burstcount burstcount output 7
                    set_port_property io_m_wr_burstcount TERMINATION TRUE
            	} else {
            	    add_interface_port io_write_master io_m_wr_writedata writedata output 64
                    set_port_property io_m_wr_writedata TERMINATION TRUE
            	    add_interface_port io_write_master io_m_wr_byteenable  byteenable output 8
                    set_port_property io_m_wr_byteenable TERMINATION TRUE
            	    add_interface_port io_write_master io_m_wr_burstcount burstcount output 6 
                    set_port_property io_m_wr_burstcount TERMINATION TRUE
            	}
            
            	# io master rd(opt)
            	add_interface io_read_master conduit end
            	add_interface_port io_read_master io_m_rd_waitrequest waitrequest input 1
                set_port_property io_m_rd_waitrequest TERMINATION TRUE
                set_port_property io_m_rd_waitrequest TERMINATION_VALUE 0
            	add_interface_port io_read_master io_m_rd_readdatavalid readdatavalid input 1
                set_port_property io_m_rd_readdatavalid TERMINATION TRUE
                set_port_property io_m_rd_readdatavalid TERMINATION_VALUE 0
                add_interface_port exported_connections io_m_rd_readerror export input 1
                set_port_property io_m_rd_readerror TERMINATION TRUE
                set_port_property io_m_rd_readerror TERMINATION_VALUE 0
            	add_interface_port io_read_master io_m_rd_read read output 1
                set_port_property io_m_rd_read TERMINATION TRUE
            	add_interface_port io_read_master io_m_rd_address address output 32
                set_port_property io_m_rd_address TERMINATION TRUE
                if {[param_matches mode_selection "SERIAL_1X" ]} {
            	    add_interface_port io_read_master io_m_rd_readdata readdata input 32
                    set_port_property io_m_rd_readdata TERMINATION TRUE
                    set_port_property io_m_rd_readdata TERMINATION_VALUE 0
            	    add_interface_port io_read_master io_m_rd_burstcount burstcount output 7 
                    set_port_property io_m_rd_burstcount TERMINATION TRUE
            	} else {
            	    add_interface_port io_read_master io_m_rd_readdata readdata input 64 
                    set_port_property io_m_rd_readdata TERMINATION TRUE
                    set_port_property io_m_rd_readdata TERMINATION_VALUE 0
            	    add_interface_port io_read_master io_m_rd_burstcount burstcount output 6 
                    set_port_property io_m_rd_burstcount TERMINATION TRUE
                }
            }
            #End of IO Master

            if {[string compare -nocase ${io_interface} "NONE" ] == 0 } {
    
            	# io slave wr(opt)
            	add_interface io_write_slave conduit end
            	add_interface_port io_write_slave io_s_wr_chipselect chipselect Input 1
                set_port_property io_s_wr_chipselect TERMINATION TRUE
                set_port_property io_s_wr_chipselect TERMINATION_VALUE 0
            	add_interface_port io_write_slave io_s_wr_write write Input 1
                set_port_property io_s_wr_write TERMINATION TRUE
                set_port_property io_s_wr_write TERMINATION_VALUE 0
            	add_interface_port io_write_slave io_s_wr_address address Input $io_slave_addr_width
                set_port_property io_s_wr_address TERMINATION TRUE
                set_port_property io_s_wr_address TERMINATION_VALUE 0
               if {[param_matches mode_selection "SERIAL_1X" ]} {
            	    add_interface_port io_write_slave io_s_wr_writedata writedata Input 32
                    set_port_property io_s_wr_writedata TERMINATION TRUE
                    set_port_property io_s_wr_writedata TERMINATION_VALUE 0
            	    add_interface_port io_write_slave io_s_wr_byteenable byteenable Input 4 
                    set_port_property io_s_wr_byteenable TERMINATION TRUE
                    set_port_property io_s_wr_byteenable TERMINATION_VALUE 0
            	    add_interface_port io_write_slave io_s_wr_burstcount burstcount Input 7
                    set_port_property io_s_wr_burstcount TERMINATION TRUE
                    set_port_property io_s_wr_burstcount TERMINATION_VALUE 0
            	} else {
            	    add_interface_port io_write_slave io_s_wr_writedata writedata Input 64 
                    set_port_property io_s_wr_writedata TERMINATION TRUE
                    set_port_property io_s_wr_writedata TERMINATION_VALUE 0
            	    add_interface_port io_write_slave io_s_wr_byteenable byteenable Input 8 
                    set_port_property io_s_wr_byteenable TERMINATION TRUE
                    set_port_property io_s_wr_byteenable TERMINATION_VALUE 0
            	    add_interface_port io_write_slave io_s_wr_burstcount burstcount Input 6 
                    set_port_property io_s_wr_burstcount TERMINATION TRUE
                    set_port_property io_s_wr_burstcount TERMINATION_VALUE 0
            	}
            
            	add_interface_port io_write_slave io_s_wr_waitrequest waitrequest Output 1
                set_port_property io_s_wr_waitrequest TERMINATION TRUE
            
            	# io slave rd(opt)
            	add_interface io_read_slave conduit end
            	add_interface_port io_read_slave io_s_rd_chipselect chipselect Input 1
                set_port_property io_s_rd_chipselect TERMINATION TRUE
                set_port_property io_s_rd_chipselect TERMINATION_VALUE 0
            	add_interface_port io_read_slave io_s_rd_read read Input 1
                set_port_property io_s_rd_read TERMINATION TRUE
                set_port_property io_s_rd_read TERMINATION_VALUE 0
            	add_interface_port io_read_slave io_s_rd_address address Input $io_slave_addr_width
                set_port_property io_s_rd_address TERMINATION TRUE
                set_port_property io_s_rd_address TERMINATION_VALUE 0
              
            	add_interface_port io_read_slave io_s_rd_waitrequest waitrequest Output 1
                set_port_property io_s_rd_waitrequest TERMINATION TRUE
            	add_interface_port io_read_slave io_s_rd_readdatavalid readdatavalid Output 1
                set_port_property io_s_rd_readdatavalid TERMINATION TRUE
               if {[param_matches mode_selection "SERIAL_1X" ]} {
            	    add_interface_port io_read_slave io_s_rd_burstcount burstcount Input 7
                    set_port_property io_s_rd_burstcount TERMINATION TRUE
                    set_port_property io_s_rd_burstcount TERMINATION_VALUE 0
            	    add_interface_port io_read_slave io_s_rd_readdata readdata Output 32
                    set_port_property io_s_rd_readdata TERMINATION TRUE
            	} else {
            	    add_interface_port io_read_slave io_s_rd_burstcount burstcount Input 6 
                    set_port_property io_s_rd_burstcount TERMINATION TRUE
                    set_port_property io_s_rd_burstcount TERMINATION_VALUE 0
            	    add_interface_port io_read_slave io_s_rd_readdata readdata Output 64
                    set_port_property io_s_rd_readdata TERMINATION TRUE
            	}
            
            	add_interface_port exported_connections io_s_rd_readerror export Output 1
                set_port_property io_s_rd_readerror TERMINATION TRUE
                }
                
                #End of IO Slave
                
         if { [param_matches rio_p_maintenance_master_slave "NONE" ] } {
             # maintenance master (opt)
             add_interface mnt_master conduit end
             add_interface_port mnt_master mnt_m_read read output 1
             set_port_property mnt_m_read TERMINATION TRUE
             add_interface_port mnt_master mnt_m_write write output 1
             set_port_property mnt_m_write TERMINATION TRUE
             add_interface_port mnt_master mnt_m_address address output 32
             set_port_property mnt_m_address TERMINATION TRUE
             add_interface_port mnt_master mnt_m_writedata writedata output 32
             set_port_property mnt_m_writedata TERMINATION TRUE
             add_interface_port mnt_master mnt_m_waitrequest waitrequest input 1
             set_port_property mnt_m_waitrequest TERMINATION TRUE
             set_port_property mnt_m_waitrequest TERMINATION_VALUE 0
             add_interface_port mnt_master mnt_m_readdata readdata input 32
             set_port_property mnt_m_readdata TERMINATION TRUE
             set_port_property mnt_m_readdata TERMINATION_VALUE 0
             add_interface_port mnt_master mnt_m_readdatavalid readdatavalid input 1
             set_port_property mnt_m_readdatavalid TERMINATION TRUE
             set_port_property mnt_m_readdatavalid TERMINATION_VALUE 0
         }
         #End of Maintenance master

         if { [param_matches rio_p_maintenance_master_slave "NONE" ] } {
             # maint slave (opt)
             add_interface mnt_slave conduit end
             add_interface_port mnt_slave mnt_s_chipselect chipselect Input 1
             set_port_property mnt_s_chipselect TERMINATION TRUE
             set_port_property mnt_s_chipselect TERMINATION_VALUE 0
             add_interface_port mnt_slave mnt_s_read read Input 1
             set_port_property mnt_s_read TERMINATION TRUE
             set_port_property mnt_s_read TERMINATION_VALUE 0
             add_interface_port mnt_slave mnt_s_write write Input 1
             set_port_property mnt_s_write TERMINATION TRUE
             set_port_property mnt_s_write TERMINATION_VALUE 0
             add_interface_port mnt_slave mnt_s_address address Input 24
             set_port_property mnt_s_address TERMINATION TRUE
             set_port_property mnt_s_address TERMINATION_VALUE 0
             add_interface_port mnt_slave mnt_s_writedata writedata Input 32
             set_port_property mnt_s_writedata TERMINATION TRUE
             set_port_property mnt_s_writedata TERMINATION_VALUE 0
             add_interface_port mnt_slave mnt_s_waitrequest waitrequest Output 1
             set_port_property mnt_s_waitrequest TERMINATION TRUE
             add_interface_port mnt_slave mnt_s_readdata readdata Output 32
             set_port_property mnt_s_readdata TERMINATION TRUE
             add_interface_port exported_connections mnt_s_readerror export Output 1
             set_port_property mnt_s_readerror TERMINATION TRUE
             add_interface_port mnt_slave mnt_s_readdatavalid readdatavalid Output 1
             set_port_property mnt_s_readdatavalid TERMINATION TRUE
         }
         #End of Maintenance Slave

      
	}
}

proc commonrunqmega {name language gensim} {
	global env
	set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

	set used_ports ""
	set cbx_params ""
	set use_xcvr_phy_mode 0
	set use_native_phy_mode 0
	
	if {[param_matches deviceFamily "Stratix V"] || [param_matches deviceFamily "Arria V"] || [param_matches deviceFamily "Arria V GZ"] || [param_matches deviceFamily "Cyclone V"]} {
	    set use_xcvr_phy_mode 1
        }
    
        if {[param_matches deviceFamily "Arria 10"]} {
	    set use_native_phy_mode 1
        }
	
	if {[string compare -nocase ${language} verilog] == 0} {
	    set output_file "${name}.v"
	    set simgen_file "${name}.vo"
	    set sister_simgen_file "${name}_sister_rio.vo"
	} else {
	    set output_file "${name}.vhd"
	    set simgen_file "${name}.vho"
	    set sister_simgen_file "${name}_sister_rio.vho"
	}

#For old families simulatio use-the fileset
        set testbench_file "${name}_tb.v"
        set utils_file "${name}_hutil.iv"
        set hookup_file "${name}_hookup.iv"
        set demoutils_file "${name}_demo_util.iv"
        set avalon_master_files "${name}_avalon_bfm_master.v"
        set avalon_slave_files  "${name}_avalon_bfm_slave.v"
        set simulator_script  "srio_simulator.tcl"


	set family [get_parameter_value deviceFamily]
	set mode_selection [get_parameter_value mode_selection]  

    set PLATFORM $::tcl_platform(platform)
    if { $PLATFORM == "java" } {
        set PLATFORM $::tcl_platform(host_platform)
    }

    # Case:136864 Use quartus(binpath) if its set
    if { [catch {set QUARTUS_BINDIR $::quartus(binpath)} errmsg] } {
        if { $PLATFORM == "windows" } {
            set BINDIRNAME "bin"
        } else {
            set BINDIRNAME "linux"
        }

        # Only the native tcl interpreter has 'tcl_platform(wordSize)'
        # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
        if { [catch {set WORDSIZE $::tcl_platform(wordSize)} errmsg] } {
            if {[string match "*64" $::tcl_platform(machine)]} {
                set WORDSIZE 8
            } else {
                set WORDSIZE 4
            }
        }
        if { $WORDSIZE == 8 } {
            set BINDIRNAME "${BINDIRNAME}64"
        }

        set QUARTUS_BINDIR "$QUARTUS_ROOTDIR/$BINDIRNAME"
    }

       
    if  {$use_native_phy_mode == 0} {
       
        set tmpdir [create_temp_file "dummy.txt"]
        set dummydirname [file dirname $tmpdir]
        set filesep "/"
        set tmpdir ${dummydirname}${filesep}
       
   
   	set libdir "${QUARTUS_ROOTDIR}/../ip/altera/rapidio/lib"
   	set flowdir "${QUARTUS_ROOTDIR}/../ip/altera/common/ip_toolbench/v1.3.0/bin"
       set iptb_exe "${flowdir}/ip_toolbench.exe"
       if { [file exists $iptb_exe] == 0 } {
           # Use full path since we can't be sure what is in PATH
           set iptb_exe "${QUARTUS_BINDIR}/ip_toolbench"
       }


   	set command [list -n -devicefamily:${family} -lib_dir:${libdir} -flow_dir:${flowdir} -wizard:rapidio -silent -parameterization.p_serial:1  -parameterization.p_xgmii:0 -parameterization.p_VOD:2 ]
   	
   	foreach param [get_parameters] {
   	    set type [ get_parameter_property $param TYPE ] 
   	    set value [ get_parameter_value $param ]  
   	    if { [ string compare -nocase $type BOOLEAN ] == 0 } { 
   		if { [ string compare -nocase $value true ] == 0 } {
   		    set argument "-parameterization.$param:1"
                       #SPR:360341#################################################
                       # Reset Source operation and Destination operation when Avalon-ST pass-through interface is turned off
                       if { [ string compare -nocase $param p_SOURCE_OPERATION_DATA_MESSAGE ] == 0 } {
                           set value [ get_parameter_value p_GENERIC_LOGICAL ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           }
                       }
   
                       if { [ string compare -nocase $param p_DESTINATION_OPERATION_DATA_MESSAGE ] == 0 } {
                           set value [ get_parameter_value p_GENERIC_LOGICAL ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           }
                       }
                       # Reset Port Write when Maintenance Slave is not enabled.
                       if { [ string compare -nocase $param p_TX_PORT_WRITE ] == 0 } {
                           set value [ get_parameter_value p_MAINTENANCE_SLAVE ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           }
                       }
   
                       if { [ string compare -nocase $param p_RX_PORT_WRITE ] == 0 } {
                           set value [ get_parameter_value p_MAINTENANCE_SLAVE ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           }
                       }
                       # Reset I/O read write order when I/O Slave is not enabled.
                       if { [ string compare -nocase $param p_READ_WRITE_ORDER ] == 0 } {
                           set value [ get_parameter_value p_IO_SLAVE ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           }
                       }
   
                       # Reset Drbell write order either I/O Slave or Drbell Tx is not enabled.
                       if { [ string compare -nocase $param p_DRBELL_WRITE_ORDER ] == 0 } {
                           set value [ get_parameter_value p_IO_SLAVE ]
                           if { [ string compare -nocase $value false ] == 0 } {
   		        set argument "-parameterization.$param:0"
                           } else {
                               set value [ get_parameter_value p_DRBELL_TX ]
                               if { [ string compare -nocase $value false ] == 0 } {
   		            set argument "-parameterization.$param:0"
                               }
                           }
                       }
   
                       ############################################################
   
   		} else {
   		    set argument "-parameterization.$param:0"
   		}
   		lappend command $argument 
   	    } else {
   		if { [ string compare -nocase $param p_DEVICE_ID ] == 0 ||
   			 [ string compare -nocase $param p_DEVICE_VENDOR_ID ] == 0 ||
   			 [ string compare -nocase $param p_DEVICE_REV ] == 0 ||
   			 [ string compare -nocase $param p_ASSEMBLY_ID ] == 0 ||
   			 [ string compare -nocase $param p_ASSEMBLY_VENDOR_ID ] == 0 ||
   			 [ string compare -nocase $param p_ASSEMBLY_REVISION ] == 0 ||
   			 [ string compare -nocase $param p_FIRST_EF_PTR ] == 0 } {
   			set value_in_hex [format "0x%x" $value]
   			set argument "-parameterization.$param:$value_in_hex"
   		    lappend command $argument 
   		} elseif { [ string compare -nocase $param devicefamily ] != 0 } {
   		    set argument "-parameterization.$param:$value"
   		    lappend command $argument 
   		} 
   		
   	    }
   
   	}
   	
   	lappend command "-simgen_enable.language:${language}"	
   	lappend command "-simgen_enable.enabled:${gensim}"
        lappend command "-parameterization.p_UNDER_QSYS:1"
   
   	lappend command "${tmpdir}/${output_file}"
   
   	send_message info "exec $iptb_exe $command "
   
    	if { [catch [list exec {*}[auto_execok $iptb_exe] $command] msg] } {
   	#    send_message error "Stderr: $::errorInfo"
    	} else {
   	}
	}

    if { [expr $gensim == 1] } {
      
        # 17/02/2011, HLONG: adding the files for PHY IP simulation
        if {$use_native_phy_mode == 0} {
          if {$use_xcvr_phy_mode == 1} {
            set fp1 [open ${tmpdir}phy_ip_sim.lst r]
            set sim_filepaths_data [read $fp1]
            close $fp1
            set sim_filepaths [split $sim_filepaths_data "\n"]
            set sim_directory_len [expr [string length [lindex $sim_filepaths 0]] + 1]
            foreach sim_filepath $sim_filepaths {
              set sim_filepath_len [string length $sim_filepath]
              set sim_filename [string range $sim_filepath $sim_directory_len $sim_filepath_len]
              if {[string match -nocase "*.sv" $sim_filepath]} {
                #VCS cannot eleborate this in AV and CV family- decided to removed this for all V families for all simulator
              	if {[string match -nocase "*altera_xcvr_custom.sv" $sim_filepath]} {
                  add_fileset_file ${sim_filename} OTHER PATH ${tmpdir}${sim_filepath}
                } else {
                  add_fileset_file ${sim_filename} SYSTEMVERILOG PATH ${tmpdir}${sim_filepath}
                }
              } elseif {[string match -nocase "*.v" $sim_filepath]} {
                  add_fileset_file ${sim_filename} VERILOG PATH ${tmpdir}${sim_filepath}
              }
            }
          }

            if {[string compare -nocase ${language} verilog] == 0} {
                add_fileset_file ${simgen_file} VERILOG PATH ${tmpdir}${simgen_file}
                add_fileset_file ${sister_simgen_file} VERILOG PATH ${tmpdir}${sister_simgen_file}
                add_fileset_file ${utils_file} VERILOG_INCLUDE PATH ${tmpdir}${utils_file}
                add_fileset_file ${hookup_file} VERILOG_INCLUDE PATH ${tmpdir}${hookup_file}
                add_fileset_file ${demoutils_file} VERILOG_INCLUDE PATH ${tmpdir}${demoutils_file}
                add_fileset_file ${avalon_master_files} VERILOG PATH ${tmpdir}${avalon_master_files}
                add_fileset_file ${avalon_slave_files} VERILOG PATH ${tmpdir}${avalon_slave_files}
                add_fileset_file ${testbench_file} VERILOG PATH ${tmpdir}${testbench_file}
               

            } else {
	        add_fileset_file ${simgen_file} VHDL PATH ${tmpdir}${simgen_file}
                add_fileset_file ${sister_simgen_file} VHDL PATH ${tmpdir}${sister_simgen_file}
                add_fileset_file ${utils_file} VERILOG_INCLUDE PATH ${tmpdir}${utils_file}
                add_fileset_file ${hookup_file} VERILOG_INCLUDE PATH ${tmpdir}${hookup_file}
                add_fileset_file ${demoutils_file} VERILOG_INCLUDE PATH ${tmpdir}${demoutils_file}
                add_fileset_file ${avalon_master_files} VERILOG PATH ${tmpdir}${avalon_master_files}
                add_fileset_file ${avalon_slave_files} VERILOG PATH ${tmpdir}${avalon_slave_files}
                add_fileset_file ${testbench_file} VERILOG PATH ${tmpdir}${testbench_file}
               
            }
            # The rest of the testbench files which needed to be added



        } else {
            # Fileset generation for Simulation
            if {1} {
                common_add_fileset_static $name 1 mentor 1
            }
               
            if {1} {
                common_add_fileset_static $name 1 synopsys 0
            }
               
            if {1} {
                common_add_fileset_static $name 1 cadence 0
            }
               
            if {1} {
                common_add_fileset_static $name 1 aldec 0
            }
            
            cust_demo_tb $name 
        }

	} else {
      # Fileset generation for Synthesis purpose
      if  {$use_native_phy_mode == 1} {
         # Fileset generation for synthesis
         common_add_fileset_static  $name 0 "" 1
         
      } else {
	    add_fileset_file ${output_file} VERILOG PATH ${tmpdir}${output_file}
	    add_fileset_file ${name}_riophy_gxb.v VERILOG PATH ${tmpdir}${name}_riophy_gxb.v
	    add_fileset_file ${name}_concentrator.v  VERILOG PATH ${tmpdir}${name}_concentrator.v  

	    if { [param_matches rio_p_io_master_slave AVALONMASTER] || [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
		   add_fileset_file ${name}_io_master.v VERILOG PATH ${tmpdir}${name}_io_master.v 
	    }

	    if { [param_matches rio_p_io_master_slave AVALONSLAVE] || [param_matches rio_p_io_master_slave AVALONMASTERSLAVE] } {
		    add_fileset_file ${name}_io_slave.v VERILOG PATH ${tmpdir}${name}_io_slave.v 
	    }

	    if { [param_matches rio_p_maintenance_master_slave AVALONMASTER] || [param_matches rio_p_maintenance_master_slave AVALONSLAVE] || [param_matches rio_p_maintenance_master_slave AVALONMASTERSLAVE] } {
		    add_fileset_file ${name}_maintenance.v VERILOG PATH ${tmpdir}${name}_maintenance.v
	    }

        if { [param_is_true p_DRBELL_TX] || [param_is_true p_DRBELL_RX] } {
		    add_fileset_file ${name}_drbell.v VERILOG PATH ${tmpdir}${name}_drbell.v
	    }

	    add_fileset_file ${name}_phy_mnt.v  VERILOG PATH ${tmpdir}${name}_phy_mnt.v 
	    add_fileset_file ${name}_reg_mnt.v  VERILOG PATH ${tmpdir}${name}_reg_mnt.v 
	    add_fileset_file ${name}_rio.v  VERILOG PATH ${tmpdir}${name}_rio.v 
	    add_fileset_file ${name}_riophy_dcore.v VERILOG PATH ${tmpdir}${name}_riophy_dcore.v 
	    add_fileset_file ${name}_riophy_reset.v  VERILOG PATH ${tmpdir}${name}_riophy_reset.v 
	    add_fileset_file ${name}_riophy_xcvr.v  VERILOG PATH ${tmpdir}${name}_riophy_xcvr.v 
	    add_fileset_file ${name}_transport.v  VERILOG PATH ${tmpdir}${name}_transport.v 

            # 17/2/2011, HLONG: adding the files for PHY IP simulation
            if {$use_xcvr_phy_mode == 1} {
              set fp2 [open ${tmpdir}phy_ip_synth.lst r]
              set synth_filenames_data [read $fp2]
              close $fp2
              set synth_filenames [split $synth_filenames_data "\n"]
              foreach synth_filename $synth_filenames {
                if {[string match -nocase "*.sv" $synth_filename]} {
	          add_fileset_file ${synth_filename} SYSTEMVERILOG PATH ${tmpdir}${synth_filename}
                } elseif {[string match -nocase "*.v" $synth_filename]} {
	          add_fileset_file ${synth_filename} VERILOG PATH ${tmpdir}${synth_filename}
                }
              }
            }

	    add_fileset_file ${name}.sdc  SDC PATH ${tmpdir}${name}.sdc 	
	    add_fileset_file ${name}_constraints.tcl OTHER PATH ${tmpdir}${name}_constraints.tcl 
	    add_fileset_file ${name}_riophy_dcore.ocp OTHER PATH ${tmpdir}${name}_riophy_dcore.ocp 
	    
   	    }
	}
}

proc synthproc {name} {
    commonrunqmega $name "verilog" 0
}

proc verilogsimproc {name} {
    commonrunqmega $name "verilog" 1

}

proc vhdlsimproc {name} {
    commonrunqmega $name "vhdl" 1
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" http://www.altera.com/literature/ug/ug_rapidio.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697904134
