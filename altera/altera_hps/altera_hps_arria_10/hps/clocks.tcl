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



################################################
# Static lists for speed.
# Kept in sync with elaboration by a test.
################################################

# interfaces
proc get_peripheral_fpga_input_clocks {peripheral} {
	array set map {
		EMAC0 {emac0_rx_clk_in emac0_tx_clk_in}
		EMAC1 {emac1_rx_clk_in emac1_tx_clk_in}
		EMAC2 {emac2_rx_clk_in emac2_tx_clk_in}
		I2C0   i2c0_scl_in
		I2C1   i2c1_scl_in
		I2CEMAC0   i2cemac0_scl_in
		I2CEMAC1   i2cemac1_scl_in
		I2CEMAC2   i2cemac2_scl_in
		NAND  {}
		QSPI  {}
		SDMMC  sdmmc_clk_in
		SPIM0 {}
		SPIM1 {}
		SPIS0  spis0_sclk_in
		SPIS1  spis1_sclk_in
		TRACE {}
		UART0 {}
		UART1 {}
		USB0   usb0_clk_in
		USB1   usb1_clk_in
		CM {}
	}
	return $map($peripheral)
}

# interfaces
proc get_peripheral_fpga_output_clocks {peripheral} {
    array set map {
	EMAC0 {emac0_md_clk emac0_gtx_clk}
	EMAC1 {emac1_md_clk emac1_gtx_clk}
	EMAC2 {emac2_md_clk emac2_gtx_clk}
	I2C0   i2c0_clk
	I2C1   i2c1_clk
	I2CEMAC0   i2cemac0_clk
	I2CEMAC1   i2cemac1_clk
	I2CEMAC2   i2cemac2_clk
	NAND  {}
	QSPI   qspi_sclk_out
	SDMMC  sdmmc_cclk
	SPIM0  spim0_sclk_out
	SPIM1  spim1_sclk_out
	SPIS0 {}
	SPIS1 {}
	TRACE {}
	UART0 {}
	UART1 {}
	USB0  {} 
	USB1  {}
	CM {}
    }
    return $map($peripheral)
}

# signals
# the actual pins will be named ${peripheral}_${signal}
proc get_peripheral_soc_io_input_clocks {peripheral} {
    array set map {
	EMAC0  rx_clk
	EMAC1  rx_clk
	EMAC2  rx_clk
	I2C0   scl
	I2C1   scl
	I2CEMAC0   scl
	I2CEMAC1   scl
	I2CEMAC2   scl
	NAND  {}
	QSPI  {}
	SDMMC   clk_in
	SPIM0 {}
	SPIM1 {}
	SPIS0  clk
	SPIS1  clk
	TRACE {}
	UART0 {}
	UART1 {}
	USB0   clk 
	USB1   clk
	CM {}
    }
    return $map($peripheral)
}

proc form_peripheral_soc_io_input_clock_frequency_parameter {peripheral port} {
    return "SOC_PERIPHERAL_INPUT_CLOCK_FREQ_[string toupper ${peripheral}_${port}]"
}

proc form_peripheral_fpga_input_clock_frequency_parameter {interface} {
    return "FPGA_PERIPHERAL_INPUT_CLOCK_FREQ_[string toupper $interface]"
}

proc form_peripheral_fpga_output_clock_frequency_parameter {interface} {
    return "FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_[string toupper $interface]"
}

######################

proc interface_is_vaild_in_this_mode { peripheral_name  interface_name } {
	set ret 1
	if { $peripheral_name == "EMAC0" || $peripheral_name == "EMAC1" || $peripheral_name == "EMAC2" } {
		set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]
		
		if { [string first "with_MDIO" $mode_value] == -1 } {
			if { [string first "md_clk" $interface_name] != -1 } {
				set ret 0
			}
		}
	}
	
	return $ret	
}

proc port_is_vaild_in_this_mode { peripheral_name  port_name } {
	
	set ret 1
	if { $peripheral_name == "EMAC0" || $peripheral_name == "EMAC1" || $peripheral_name == "EMAC2" } {
		set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]
		
		if { [string first "with_MDIO" $mode_value] == -1 } {
			if { [string first "gmii_md" $port_name] != -1 } {
				set ret 0
			}
		}
	}
	
	return $ret	
}
## Show only the signals asociated with the proper mode.
proc update_emac_width { peripheral_name port_name width } {
	if { $peripheral_name == "EMAC0" || $peripheral_name == "EMAC1" || $peripheral_name == "EMAC2" } {
		set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]

		if { [string first "RGMII" $mode_value] == -1 } {
			if { [string first "phy_txd" $port_name] != -1  || [string first "phy_rxd_" $port_name] != -1} {
				set width 4
			}
		}
	}
	if { $peripheral_name == "NAND" } {
		set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]
		if { $mode_value == "8-bit" } {
			if { $port_name == "nand_adq_i" || $port_name == "nand_adq_o" } {
				set width 8
			}
		}
	}
	if { $peripheral_name == "SDMMC" } {
		set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]
		
		if {  $mode_value == "4-bit" ||  $mode_value == "4-bit_PWREN" } {
			if { [string first "sdmmc_data" $port_name] != -1 } {
				set width 4
			}
		}
		if {  $mode_value == "1-bit" ||  $mode_value == "1-bit_PWREN" } {
			if { [string first "sdmmc_data" $port_name] != -1 } {
				set width 1
			}
		}
	}
	
	#send_message info "NEA: peripheral_name $peripheral_name port_name $port_name mode_value $mode_value width $width"
	
	return $width
}
