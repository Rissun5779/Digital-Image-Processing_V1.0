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


## Generated SDC file "espi.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Standard Edition"

## DATE    "Fri Dec 22 18:26:35 2017"

##
## DEVICE  "10M02DCU324A6G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

#---------- User will have to change <ip_clock_name> to the IP clock name at the top level wrapper file ------------
#---------- User will have to change <spi_clock_name> to the SPI clock name at the top level wrapper file ----------

#create_clock -name {<ip_clock_name>} -period 6.667 -waveform { 0.000 3.333 } [get_ports {<ip_clock_name>}]
#create_clock -name {<spi_clock_name>} -period 15.000 -waveform { 0.000 7.500 } [get_ports {<spi_clock_name>}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

# IP clock to eSPI clock domain crossing
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[0] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[1] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[2] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[3] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[4] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[5] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[6] *espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_dataout_byte_nxt[7]}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|rx_detect_command_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|error_condition1_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|detect_rx_idle_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|detect_tx_idle_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|rx_detect_crc_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|tx_gen_crc_nxt}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|spiclk_cnt[0] *espi_lpc_condt_det_inst|spiclk_cnt[1] *espi_lpc_condt_det_inst|spiclk_cnt[2] *espi_lpc_condt_det_inst|spiclk_cnt[3]}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[0] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[1] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[2] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[3] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[4] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[5] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[6] *espi_lpc_condt_det:espi_lpc_condt_det_inst|txshift_data[7]}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|spiclk_cnt_done}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|trigger_output}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|stop_trigger_output}]
set_false_path -from [get_registers {*espi_lpc_register:espi_lpc_register_inst|io_mode[0] *espi_lpc_register:espi_lpc_register_inst|io_mode[1]}] -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[0] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[1] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[2] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[3] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[4] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[5] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[6] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data[7]}]

# eSPI clock to IP clock domain crossing
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|trigger_output_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|espi_cs_n_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|spiclk_cnt_done_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|posspiclk_cnt_done_nxt}]
set_false_path -to [get_registers {*espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[0] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[1] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[2] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[3] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[4] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[5] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[6] *espi_lpc_condt_det:espi_lpc_condt_det_inst|rxshift_data_nxt[7]}]

# IP clock to LPC clock domain crossing
set_false_path -to [get_registers {*espi_lpc_pc_channel:pc_channel_enable_blk.espi_lpc_pc_channel_inst|pc_rxfifo_avail_nxt}]
set_false_path -to [get_registers {*espi_lpc_pc_channel:pc_channel_enable_blk.espi_lpc_pc_channel_inst|np_rxfifo_avail_nxt}]

# LPC to IP clock domain crossing
set_false_path -to [get_registers {*espi_to_lpc_bridge:intel_espi_to_lpc_bridge_0|irq_num_nxt[*]}]
set_false_path -to [get_registers {*espi_lpc_pc_channel:pc_channel_enable_blk.espi_lpc_pc_channel_inst|multibyte_nxt}]
set_false_path -to [get_registers {*espi_lpc_pc_channel:pc_channel_enable_blk.espi_lpc_pc_channel_inst|txfifo_free_nxt}]

# Reset Synchronizer registers
set_false_path -to [get_pins -nocase -compatibility_mode {*|intel_espi_to_lpc_bridge_0|lpc_reset_n_nxt|clrn *|intel_espi_to_lpc_bridge_0|lpc_reset_n|clrn}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|intel_espi_to_lpc_bridge_0|pc_channel_enable_blk.espi_lpc_pc_channel_inst|pc_channel_lpc_reset_nxt|clrn *|intel_espi_to_lpc_bridge_0|pc_channel_enable_blk.espi_lpc_pc_channel_inst|pc_channel_lpc_reset|clrn}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

