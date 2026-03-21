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


namespace eval isw {
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util xml.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util constants.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util procedures.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util pin_mux.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util pin_mux_db.tcl]
    
    proc render_hps_xml_file {parameters_ref} {
	upvar 1 $parameters_ref parameters
	
	# hps
	set hps_elem [xml::writer::create_element "hps"]

	# system info
	add_system_info $hps_elem parameters
	
	# FPGA interface info
	add_fpga_interface $hps_elem parameters

	# peripherals
	add_peripherals $hps_elem parameters

	# pin muxing
	add_pin_muxing $hps_elem parameters
	
	set xml_contents [xml::writer::render_xml_contents $hps_elem]
	xml::writer::cleanup
	return $xml_contents
    }
    
    proc add_system_info {parent_elem parameters_ref} {
	upvar 1 $parameters_ref parameters
	
	set system_elem [xml::writer::create_element "system"]
	xml::writer::add_child $parent_elem $system_elem
	
	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child      $system_elem  $config_elem
	    xml::writer::set_attribute  $config_elem  "name" DEVICE_FAMILY
	    xml::writer::set_attribute  $config_elem  "value" $parameters(hps_device_family)

	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child      $system_elem  $config_elem
	    xml::writer::set_attribute  $config_elem  "name" DMA_Enable
	    xml::writer::set_attribute  $config_elem  "value" "$parameters(DMA_Enable)"

	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child      $system_elem  $config_elem
	    xml::writer::set_attribute  $config_elem  "name" dbctrl_stayosc1
	    xml::writer::set_attribute  $config_elem  "value" "$parameters(dbctrl_stayosc1)"
	    
	    # There are 2 sets of parameters, user and auto-calculated PLL parameters.
	    # Use the desired one depending on which mode we're using 
	    if { $parameters(configure_advanced_parameters) } {
		    set mode {}
	    } else {
		    set mode _auto
	    }
    	    
	    # c0, c1, c2 are actually clock manager internal registers
	    set auto_or_manual_clock_params [ list \
                main_pll_m main_pll_n main_pll_c0_internal main_pll_c1_internal main_pll_c2_internal main_pll_c3 main_pll_c4 main_pll_c5 \
                l4_mp_clk_div l4_sp_clk_div \
                periph_pll_m periph_pll_n periph_pll_c0 periph_pll_c1 periph_pll_c2 periph_pll_c3 periph_pll_c4 periph_pll_c5 \
                usb_mp_clk_div spi_m_clk_div can0_clk_div can1_clk_div gpio_db_clk_div ]

	    foreach param $auto_or_manual_clock_params {
		    set config_elem [xml::writer::create_element "config"]
		    xml::writer::add_child      $system_elem  $config_elem
		    xml::writer::set_attribute  $config_elem  "name" $param
		    xml::writer::set_attribute  $config_elem  "value" $parameters($param$mode)
	    }

	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child      $system_elem  $config_elem
	    xml::writer::set_attribute  $config_elem  "name" main_pll_vco_hz
	    xml::writer::set_attribute  $config_elem  "value" $parameters(main_pll_vco${mode}_hz)

	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child      $system_elem  $config_elem
	    xml::writer::set_attribute  $config_elem  "name" periph_pll_vco_hz
	    xml::writer::set_attribute  $config_elem  "value" $parameters(periph_pll_vco${mode}_hz)
	    
	    set user_input_or_derived_clock_params [ list \
                eosc1_clk_hz eosc2_clk_hz F2SCLK_PERIPHCLK_FREQ F2SCLK_SDRAMCLK_FREQ \
                l3_mp_clk_div l3_sp_clk_div dbg_at_clk_div dbg_clk_div dbg_trace_clk_div \
                periph_pll_source sdmmc_clk_source nand_clk_source qspi_clk_source l4_mp_clk_source l4_sp_clk_source \
                emac0_clk_hz emac1_clk_hz usb_mp_clk_hz nand_clk_hz sdmmc_clk_hz qspi_clk_hz spi_m_clk_hz can0_clk_hz can1_clk_hz gpio_db_clk_hz l4_mp_clk_hz l4_sp_clk_hz ]
		    
	    foreach param $user_input_or_derived_clock_params {
		    set config_elem [xml::writer::create_element "config"]
		    xml::writer::add_child      $system_elem  $config_elem
		    xml::writer::set_attribute  $config_elem  "name" $param
		    xml::writer::set_attribute  $config_elem  "value" $parameters($param)
	    }
    
            set config_elem [xml::writer::create_element "config"]
            xml::writer::add_child      $system_elem  $config_elem
            xml::writer::set_attribute  $config_elem  "name"   "sdram_pll_c5"
            xml::writer::set_attribute  $config_elem  "value"  $parameters(S2FCLK_USER2CLK)
    
    }
    
    proc add_fpga_interface {parent_elem parameters_ref} {
	upvar 1 $parameters_ref parameters
	
	set interface_elem [xml::writer::create_element "fpga_interfaces"]
	
	# fpga interface
	xml::writer::add_child $parent_elem $interface_elem
	
	
	# fpga interface    
	set used "true"
        if {$parameters(F2S_Width) == 0} { set used "false" }
	set config_elem [xml::writer::create_element "config"]    
	xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name" F2H_AXI_SLAVE
	xml::writer::set_attribute  $config_elem     "used" $used	
	
	set used "true"     
	if {$parameters(S2F_Width) == 0} { set used "false" }
	set config_elem [xml::writer::create_element "config"]    
	xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name" H2F_AXI_MASTER
	xml::writer::set_attribute  $config_elem     "used" $used	
	
	set used "true"     
	if {[string compare $parameters(LWH2F_Enable) "false"] == 0} { set used "false" }
	set config_elem [xml::writer::create_element "config"]    
	xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name" LWH2F_AXI_MASTER
	xml::writer::set_attribute  $config_elem     "used" $used
	
	# f2sdram fpgaportrst config
	add_f2sdram_config_element parameters $interface_elem
 
	}
    proc add_peripherals {parent_elem parameters_ref} {
	upvar 1 $parameters_ref parameters

	set peripherals_elem [xml::writer::create_element "peripherals"]
	xml::writer::add_child $parent_elem $peripherals_elem
	
	foreach peripheral [list_peripheral_names] {
	    set peripheral_elem [xml::writer::create_element "peripheral"]
	    xml::writer::add_child $peripherals_elem $peripheral_elem
	    set sw_name [to_sw_peripheral_name $peripheral]
	    xml::writer::set_attribute $peripheral_elem "name" [string tolower $sw_name]
	    set pin_mux_param [format [PIN_MUX_PARAM_FORMAT] $peripheral]
	    set used "true"
	    if {[string compare $parameters($pin_mux_param) "Unused"] == 0} {
		set used "false"
	    }
	    xml::writer::set_attribute $peripheral_elem "used" $used
	    
	    add_peripheral_attributes parameters $peripheral $peripheral_elem
	}
    }

    # there are so few attributes to apply that we shouldn't over-engineer how general this proc is (like using tables with conditions, attributes, and values)
    proc add_peripheral_attributes {parameters_ref peripheral peripheral_elem} {
	upvar 1 $parameters_ref parameters

	array set callback_by_peripheral {
	    QSPI  add_qspi_attributes
	    SDIO  add_sdio_attributes
	    UART0 add_uart0_attributes
	    UART1 add_uart1_attributes
	}
	
	if {[info exists callback_by_peripheral($peripheral)]} {
	    set callback $callback_by_peripheral($peripheral)
	    $callback parameters $peripheral_elem
	}
    }
    
    proc add_attributes_for_signals_muxed {signals_ref peripheral peripheral_elem} {
	upvar 1 $signals_ref signals
	set prefix "CONFIG_HPS_${peripheral}_"
	foreach {signal value} [array get signals] {
	    set name   "${prefix}${signal}"

	    set config_elem [xml::writer::create_element "config"]
	    xml::writer::add_child $peripheral_elem $config_elem
	    xml::writer::set_attribute $config_elem "name"  $name
	    xml::writer::set_attribute $config_elem "value" $value
	}
    }
    
    proc add_qspi_attributes {parameters_ref peripheral_elem} {
	upvar 1 $parameters_ref parameters
	set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] QSPI]
	set mode_param_name       [format [MODE_PARAM_FORMAT]    QSPI]
	
	set pin_muxing_value $parameters($pin_muxing_param_name)
	set mode_value       $parameters($mode_param_name)
	
	set signals(CS0) 0
	set signals(CS1) 0
	set signals(CS2) 0
	set signals(CS3) 0
	if {[string compare $pin_muxing_value "FPGA"] == 0} {
	    set signals(CS0) 1
	    set signals(CS1) 1
	    set signals(CS2) 1
	    set signals(CS3) 1
	} elseif {[string first "HPS I/O Set " $pin_muxing_value] == 0} {
	    if {[string compare $mode_value "2 SS"] == 0} {
		set signals(CS1) 1
	    } elseif {[string compare $mode_value "4 SS"] == 0} {
		set signals(CS1) 1
		set signals(CS2) 1
		set signals(CS3) 1
	    }
	    set signals(CS0) 1
	}
	
	add_attributes_for_signals_muxed signals QSPI $peripheral_elem
    }
    
    proc add_sdio_attributes {parameters_ref peripheral_elem} {
	upvar 1 $parameters_ref parameters

	set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] SDIO]
	set mode_param_name       [format [MODE_PARAM_FORMAT]    SDIO]
	
	set pin_muxing_value $parameters($pin_muxing_param_name)
	set mode_value       $parameters($mode_param_name)
	
	set attr(BUSWIDTH) 0
	if {[string compare $pin_muxing_value "FPGA"] == 0} {
	    set attr(BUSWIDTH) 8
	} elseif {[string first "HPS I/O Set " $pin_muxing_value] == 0} {
	    if {[string match     "1-bit Data*" $mode_value] } {
		set attr(BUSWIDTH) 1
	    } elseif {[string match  "4-bit Data*" $mode_value] } {
		set attr(BUSWIDTH) 4
	    } elseif {[string match  "8-bit Data*" $mode_value] } {
		set attr(BUSWIDTH) 8
	    }
	}
	
	set sw_name [to_sw_peripheral_name SDIO]
	add_attributes_for_signals_muxed attr $sw_name $peripheral_elem
    }
    
    proc add_uart0_attributes {parameters_ref peripheral_elem} {
	upvar 1 $parameters_ref parameters
	add_uart_attributes parameters 0 $peripheral_elem
    }
    proc add_uart1_attributes {parameters_ref peripheral_elem} {
	upvar 1 $parameters_ref parameters
	add_uart_attributes parameters 1 $peripheral_elem
    }
    proc add_uart_attributes {parameters_ref uart_index peripheral_elem} {
	upvar 1 $parameters_ref parameters
	set peripheral "UART${uart_index}"
	
	set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] $peripheral]
	set mode_param_name       [format [MODE_PARAM_FORMAT]    $peripheral]
	
	set pin_muxing_value $parameters($pin_muxing_param_name)
	set mode_value       $parameters($mode_param_name)
	
	set signals(TX)  0
	set signals(RX)  0
	set signals(CTS) 0
	set signals(RTS) 0
	if {[string compare $pin_muxing_value "FPGA"] == 0} {
	    set signals(TX)  1
	    set signals(RX)  1
	    set signals(CTS) 1
	    set signals(RTS) 1
	} elseif {[string first "HPS I/O Set " $pin_muxing_value] == 0} {
	    if {[string compare $mode_value "Flow Control"] == 0} {
		set signals(CTS) 1
		set signals(RTS) 1
	    }
	    set signals(TX)  1
	    set signals(RX)  1
	}
	
	add_attributes_for_signals_muxed signals $peripheral $peripheral_elem
    }
    
    
    proc add_pin_muxing {parent_elem parameters_ref} {
	upvar 1 $parameters_ref parameters
	
	set pin_muxes_elem [xml::writer::create_element "pin_muxes"]
	xml::writer::add_child $parent_elem $pin_muxes_elem
	
	foreach {name choice value} [calc_pin_mux_names_and_values parameters] {
	    set pin_mux_elem [xml::writer::create_element "pin_mux"]
	    xml::writer::add_child $pin_muxes_elem $pin_mux_elem
	    xml::writer::set_attribute $pin_mux_elem "name" $name
	    xml::writer::set_attribute $pin_mux_elem "choice" $choice
	    xml::writer::set_attribute $pin_mux_elem "value" $value
	}

	# *USEFPGA registers
	foreach peripheral [list_sw_peripheral_names] {
	    set sw_name [to_sw_peripheral_name $peripheral]
	    set use_fpga_name "${sw_name}USEFPGA" 

	    set pin_mux_elem [xml::writer::create_element "pin_mux"]
	    xml::writer::add_child $pin_muxes_elem $pin_mux_elem
	    xml::writer::set_attribute $pin_mux_elem "name" $use_fpga_name
	    set pin_mux_param [format [PIN_MUX_PARAM_FORMAT] $peripheral]
	    set value 0
	    if {[string compare $parameters($pin_mux_param) "FPGA"] == 0} {
		set value 1
	    }
	    xml::writer::set_attribute $pin_mux_elem "value" $value
	}
    }

    proc to_sw_peripheral_name {peripheral_name} {
	array set map {
	    CAN0  CAN0
	    CAN1  CAN1
	    I2C0  I2C0
	    I2C1  I2C1
	    I2C2  I2C2
	    I2C3  I2C3
	    NAND  NAND
	    QSPI  QSPI
	    SPIM0 SPIM0
	    SPIM1 SPIM1
	    SPIS0 SPIS0
	    SPIS1 SPIS1
	    UART0 UART0 
	    UART1 UART1
	    USB0  USB0
	    USB1  USB1

	    EMAC0 RGMII0
	    EMAC1 RGMII1
	    SDIO  SDMMC
	    TRACE TRACE
	}
	set name ""
	if {[info exists map($peripheral_name)]} {
	    set name $map($peripheral_name)
	}
	return $name
    }
    
    proc calc_pin_mux_names_and_values {parameters_ref} {
	upvar 1 $parameters_ref parameters

	set result [list]

	set part $parameters(device_name)
	pin_muxing_model::set_parameters [array get parameters]
	set rc [pin_mux_db::load $part]
	if {!$rc} {
	    send_message error "could not load data for part $part"
	}
	load_peripherals_pin_muxing_model peripherals_model
	pin_muxing_model::set_peripherals_model [array get peripherals_model]
	pin_muxing_model::set_gpio_pins         [pin_mux_db::get_gpio_pins]
	pin_muxing_model::set_loanio_pins       [pin_mux_db::get_loan_io_pins]

	foreach peripheral [list_peripheral_names] {
	    foreach_used_peripheral_pin pin_muxing_model $peripheral\
		signal signal_elements pin location mux_select\
	    {
	        lappend result $pin ${peripheral}_${signal} $mux_select
	    }

	}
	
	# pin mux select for GPLIO
	set PIN_MUX_SELECT_GPLIO 0
	
	# default gpl mux and gplin mux select value
	set LOANIO_SELECT 0
	set GPIO_SELECT 1
	set GPLMUX_SEL_DEFAULT $GPIO_SELECT
	set GPLINMUX_SEL_DEFAULT 0

	foreach_gplio parameters\
	    index name select pin gplin_name gplin_select\
	{
	    if {$pin != ""} {
	        lappend result $pin "GPIO/LoanIO" $PIN_MUX_SELECT_GPLIO ;# the pin register
	    }
	    if {"$select" == ""} {
	        set select $GPLMUX_SEL_DEFAULT
	    }
	    set choice "LoanIO"
	    if {"$select" == "$GPIO_SELECT"} {
	        set choice "GPIO"
	    }
	    lappend result $name $choice $select              ;# the GPLIO register
	    
	    if {$gplin_name != ""} {
	        if {$gplin_select != ""} {
	            set gplinmux_sel [pin_mux_db::get_gplinmux_select $part $pin]
	            set choice $pin
	        } else {
	            set gplinmux_sel $GPLINMUX_SEL_DEFAULT
	            set choice ""
	    	}
		lappend result $gplin_name $choice $gplinmux_sel
	    }
	}
	return $result
    }

    proc foreach_gplio {parameters_ref
			index_ref name_ref select_ref pin_ref gplin_name_ref gplin_select_ref
			body} {
	upvar 1 $parameters_ref parameters
	upvar 1 $index_ref index_out
	upvar 1 $name_ref name_out
	upvar 1 $select_ref select_out
	upvar 1 $pin_ref pin_out
	upvar 1 $gplin_name_ref gplin_name_out
	upvar 1 $gplin_select_ref gplin_select_out

	set LOANIO_SELECT 0
	set GPIO_SELECT   1
	set GPLIO_REGISTER_NAME_FORMAT {GPLMUX%s}
	set GPLIN_REGISTER_NAME_FORMAT {GPLINMUX%s}
	
	set gpio_pins [pin_mux_db::get_gpio_pins]
	set entry 0
	foreach value $parameters(GPIO_Enable) {
	    set value [expr {[string compare $value "Yes"] == 0}]
	    set gpio_enable($entry) $value
	    incr entry
	}
	
	array set gplmux_used {}
	
	foreach_gpio_entry pin_muxing_model\
	    entry gpio_index gpio_name pin gplin_used gplin_select\
	{
	    if {$gpio_enable($entry)} {
		set index_out        $gpio_index
		set name_out         [format $GPLIO_REGISTER_NAME_FORMAT $gpio_index]
		set select_out       $GPIO_SELECT
		set pin_out          $pin
		if {$gplin_used} {
		    set gplin_name_out [format $GPLIN_REGISTER_NAME_FORMAT $gpio_index]
		    set gplin_select_out $gplin_select
		} else { 
		    set gplin_name_out ""
		    set gplin_select_out ""
		}
		set gplmux_used($gpio_index) 1
		uplevel 1 $body
		}
	}
	
	set entry 0
	foreach value $parameters(LOANIO_Enable) {
	    set value [expr {[string compare $value "Yes"] == 0}]
	    set loanio_enable($entry) $value
	    incr entry
	}
	set loanio_pins [pin_mux_db::get_loan_io_pins]
	foreach_loan_io_entry pin_muxing_model\
	    entry loanio_index loanio_name pin gplin_used gplin_select\
	{
	    if {$loanio_enable($entry)} {
		set index_out        $loanio_index
		set name_out         [format $GPLIO_REGISTER_NAME_FORMAT $loanio_index]
		set select_out       $LOANIO_SELECT
		set pin_out          $pin
		if {$gplin_used} {
		    set gplin_name_out [format $GPLIN_REGISTER_NAME_FORMAT $loanio_index]
		    set gplin_select_out $gplin_select
		} else { 
		    set gplin_name_out ""
		    set gplin_select_out ""
		}
		set gplmux_used($loanio_index) 1
		uplevel 1 $body
	    }
	}
	
	# default unused GPLMUX and GPLINMUX register value
	foreach_gpio_entry pin_muxing_model\
	    entry gpio_index gpio_name pin gplin_used gplin_select\
	{
		if {![info exists gplmux_used($gpio_index)]} {
            set index_out        $gpio_index
            set name_out         [format $GPLIO_REGISTER_NAME_FORMAT $gpio_index]
            set select_out       ""
            set pin_out          ""
            if {$gplin_used} {
                set gplin_name_out [format $GPLIN_REGISTER_NAME_FORMAT $gpio_index]
                set gplin_select_out ""
            } else { 
                set gplin_name_out ""
                set gplin_select_out ""
            }
            set gplmux_used($gpio_index) 1
            uplevel 1 $body
            }
	}
    }
    
    # remove TRACE component in *USEFPGA option( TRACE already in FPGA interface/general)
    proc list_sw_peripheral_names {} {
	set peripheral_names [list_peripheral_names]
	set trace_index [lsearch $peripheral_names TRACE]
	return [lreplace $peripheral_names $trace_index $trace_index]
    }

    # case:124025 provide fpgaportrst info - F2SDRAM config element
    proc add_f2sdram_config_element { parameters_ref interface_elem } {
        upvar 1 $parameters_ref parameters
    	
        # command port
        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name"   F2SDRAM_COMMAND_PORT_USED
        xml::writer::set_attribute  $config_elem     "value"  $parameters(F2SDRAM_CMD_PORT_USED)
        # read port
        set config_elem [xml::writer::create_element "config"]    
        xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name"   F2SDRAM_READ_PORT_USED
        xml::writer::set_attribute  $config_elem     "value"  $parameters(F2SDRAM_RD_PORT_USED)
        # write port
        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name"   F2SDRAM_WRITE_PORT_USED
        xml::writer::set_attribute  $config_elem     "value"  $parameters(F2SDRAM_WR_PORT_USED)
        
        # reset port mask
        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name"   F2SDRAM_RESET_PORT_USED
        xml::writer::set_attribute  $config_elem     "value"  $parameters(F2SDRAM_RST_PORT_USED)
    }
    
################################################################################
# Implements interface of util/pin_mux.tcl
#
    namespace eval pin_muxing_model {
################################################################################

	source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util constants.tcl]
	source [file join $env(QUARTUS_ROOTDIR) .. ip altera hps util procedures.tcl]

	variable peripherals
	variable gpio_pins
	variable loanio_pins
	variable parameters
	proc set_peripherals_model {peripherals_in} {
	    variable peripherals
	    set peripherals $peripherals_in
	}
	proc set_gpio_pins {gpio_pins_in} {
	    variable gpio_pins
	    set gpio_pins $gpio_pins_in
	}
	proc set_loanio_pins {loanio_pins_in} {
	    variable loanio_pins
	    set loanio_pins $loanio_pins_in
	}
	proc set_parameters {parameters_in} {
	    variable parameters
	    array set parameters $parameters_in
	}
	proc is_parameter_enabled {parameter_name} {
	    variable parameters
	    set enabled [expr {[string compare $parameters($parameter_name) "true"] == 0}]
	    return $enabled
	}
	
	proc get_peripherals_model {} {
	    variable peripherals
	    return $peripherals
	}
	proc get_emac0_fpga_ini {} {
	    return [is_parameter_enabled quartus_ini_hps_ip_enable_emac0_peripheral_fpga_interface]
	}
	proc get_lssis_fpga_ini {} {
	    return [is_parameter_enabled quartus_ini_hps_ip_enable_low_speed_serial_fpga_interfaces]
	}
	proc get_all_fpga_ini {} {
	    return [is_parameter_enabled quartus_ini_hps_ip_enable_all_peripheral_fpga_interfaces]
	}
	proc get_peripheral_pin_muxing_selection {peripheral_name} {
	    variable parameters
	    set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] $peripheral_name]
	    set selection $parameters($pin_muxing_param_name)
	    return $selection
	}
	proc get_peripheral_mode_selection {peripheral_name} {
	    variable parameters
	    set mode_param_name [format [MODE_PARAM_FORMAT] $peripheral_name]
	    set selection $parameters($mode_param_name)
	    return $selection
	}
	proc get_gpio_pins {} {
	    variable gpio_pins
	    return $gpio_pins
	}
	proc get_loanio_pins {} {
	    variable loanio_pins
	    return $loanio_pins
	}
	proc get_unsupported_peripheral {peripheral_name} {
	    return 0
        }
    }
}
