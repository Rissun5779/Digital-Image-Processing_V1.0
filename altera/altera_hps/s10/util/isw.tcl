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
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util xml.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util constants.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util procedures.tcl]
    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util pin_mux_db.tcl]

    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util hps_csr.tcl]
    variable hps_csr_data [source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util hps_csr_data.tcl]]

    proc render_hps_xml_file {parameters_ref } {
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
        
        add_csr_info $hps_elem parameters

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
        xml::writer::set_attribute  $config_elem  "name" VERSION 
        xml::writer::set_attribute  $config_elem  "value" 18.1 
        
        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $system_elem  $config_elem
        xml::writer::set_attribute  $config_elem  "name" DEVICE_FAMILY
        xml::writer::set_attribute  $config_elem  "value" $parameters(hps_device_family)
        
        set dia  [ clock format [clock seconds] -format {%A %B, %d, %Y} ]
        set hora [ clock format [clock seconds] -format {%I:%M:%S %p %Z} ]
        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $system_elem  $config_elem
        xml::writer::set_attribute  $config_elem  "name" TIME_AND_DATE
        xml::writer::set_attribute  $config_elem  "value" "$dia - $hora"

        set config_elem [xml::writer::create_element "config"]
        xml::writer::add_child      $system_elem  $config_elem
        xml::writer::set_attribute  $config_elem  "name" DMA_Enable
        xml::writer::set_attribute  $config_elem  "value" "$parameters(DMA_Enable)"

        foreach {par_name replacement  } { 
            eosc1_clk_mhz           eosc1_clk_hz 
            EMAC0_CLK               emac0_clk_hz
            EMAC1_CLK               emac1_clk_hz
            EMAC2_CLK               emac2_clk_hz
            SDMMC_REF_CLK           sdmmc_clk_hz
            L3_MAIN_FREE_CLK        l3_main_free_clk_hz
            H2F_USER0_CLK_FREQ      h2f_user0_clk_hz
            H2F_USER1_CLK_FREQ      h2f_user1_clk_hz
            H2F_TPIU_CLOCK_IN_FREQ  tpiu_clk_hz
            F2H_FREE_CLK_FREQ       f2h_free_clk_hz      } {
                
            set clk_hz [ expr $parameters($par_name) * 1000000 ]
            set config_elem [xml::writer::create_element "config"]
            xml::writer::add_child      $system_elem  $config_elem
            xml::writer::set_attribute  $config_elem  "name"  $replacement
            xml::writer::set_attribute  $config_elem  "value" $clk_hz
        }

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
        if {$parameters(LWH2F_Enable) == 0} { set used "false" }
        set config_elem [xml::writer::create_element "config"]    
        xml::writer::add_child      $interface_elem  $config_elem
        xml::writer::set_attribute  $config_elem     "name" LWH2F_AXI_MASTER
        xml::writer::set_attribute  $config_elem     "used" $used

        foreach f2sdram { F2SDRAM0 F2SDRAM1 F2SDRAM2 } {
            set used "true"         
            if { $parameters(${f2sdram}_Width)  == 0} { set used "false" }
            set config_elem [xml::writer::create_element "config"]    
            xml::writer::add_child      $interface_elem  $config_elem
            xml::writer::set_attribute  $config_elem     "name" "${f2sdram}_AXI_SLAVE"
            xml::writer::set_attribute  $config_elem     "used" $used
        }
    }
    
    proc add_csr_info {parent_elem parameters_ref} {
        upvar 1 $parameters_ref parameters
        variable hps_csr_data
        
        set csr_elem [xml::writer::create_element "csr"]
        xml::writer::add_child $parent_elem $csr_elem
    
        ::hps_csr::init $hps_csr_data

        foreach csr [::hps_csr::to_list] {
            set csrNamespace [lindex $csr 0]
            set csrValue [lindex $csr 1]
            set config_elem [xml::writer::create_element "config"]
            xml::writer::add_child      $csr_elem     $config_elem
            xml::writer::set_attribute  $config_elem  "name" $csrNamespace 
            xml::writer::set_attribute  $config_elem  "value" $csrValue
        }
        
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
            SDMMC  add_sdio_attributes
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
    
    proc add_sdio_attributes {parameters_ref peripheral_elem} {
        upvar 1 $parameters_ref parameters
    
        set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] SDMMC]
        set mode_param_name       [format [MODE_PARAM_FORMAT]    SDMMC]
        
        set pin_muxing_value $parameters($pin_muxing_param_name)
        set mode_value       $parameters($mode_param_name)
        
        set attr(BUSWIDTH) 0
        if {[string compare $pin_muxing_value "FPGA"] == 0} {
            set attr(BUSWIDTH) 8
        } elseif {[string compare "IO" $pin_muxing_value] == 0} {
            if {[string match  "1-bit*" $mode_value ]} {
                set attr(BUSWIDTH) 1
            } elseif {[string match  "4-bit*" $mode_value ]} {
                set attr(BUSWIDTH) 4
            } elseif {[string match  "8-bit*" $mode_value ]} {
                set attr(BUSWIDTH) 8
            }
        }
        
        set sw_name [to_sw_peripheral_name SDMMC]
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
        } elseif {[string compare "IO" $pin_muxing_value] == 0} {
            if {[string compare $mode_value "Flow Control"] == 0} {
                set signals(CTS) 1
                set signals(RTS) 1
            }
            set signals(TX)  1
            set signals(RX)  1
        }
        
        add_attributes_for_signals_muxed signals $peripheral $peripheral_elem
    }
    
    proc convert_to_prefered_name {name} {
        
        set name [string tolower $name]
        
        set isw_prefered_name $name
        if {[string match hps_direct_shared_* $name]} {
            
            set    isw_prefered_name "i_io48_pin_mux_shared_3v_io_grp.pinmux_shared_io_"
            append isw_prefered_name [string range $name 18 end]
            append isw_prefered_name ".sel"
            
        } elseif {[string match hps_dedicated_* $name]} {
            
            set    isw_prefered_name "i_io48_pin_mux_dedicated_io_grp.pinmux_dedicated_io_"
            append isw_prefered_name [string range $name 14 end]
            append isw_prefered_name ".sel"
        }
        
        return $isw_prefered_name
    }
        
    proc add_pin_muxing {parent_elem parameters_ref } {
        upvar 1 $parameters_ref parameters
        
        set pin_muxes_elem [xml::writer::create_element "csr"]
        xml::writer::add_child $parent_elem $pin_muxes_elem
        
        foreach {name choice value} [calc_pin_mux_names_and_values parameters ] {
            set pin_mux_elem [xml::writer::create_element "config"]
            xml::writer::add_child $pin_muxes_elem $pin_mux_elem
            xml::writer::set_attribute $pin_mux_elem "name" [convert_to_prefered_name $name]
            #xml::writer::set_attribute $pin_mux_elem "choice" $choice
            xml::writer::set_attribute $pin_mux_elem "value" $value
            
            
            
        }
    
        # *USEFPGA registers
        foreach peripheral [list_sw_peripheral_names] {
            set sw_name [to_sw_peripheral_name $peripheral]
            set sw_name [string tolower $sw_name ]
            set use_fpga_name "i_io48_pin_mux_fpga_interface_grp.pinmux_${sw_name}_usefpga.sel" 
    
            set pin_mux_elem [xml::writer::create_element "config"]
            xml::writer::add_child $pin_muxes_elem $pin_mux_elem
            xml::writer::set_attribute $pin_mux_elem "name" $use_fpga_name
            set pin_mux_param [format [PIN_MUX_PARAM_FORMAT] $peripheral]
            set value 0
            if {[string compare $parameters($pin_mux_param) "FPGA"] == 0} {
                set value 1
            }
            xml::writer::set_attribute $pin_mux_elem "value" $value
        }
        
        set pll_parms(CLK_MAIN_PLL_SOURCE2)        "i_clk_mgr_mainpllgrp.vco0.psrc"
        set pll_parms(CLK_PERI_PLL_SOURCE2)        "i_clk_mgr_perpllgrp.vco0.psrc"
        set pll_parms(CLK_MPU_SOURCE)              "i_clk_mgr_mainpllgrp.mpuclk.src"
        set pll_parms(CLK_MPU_CNT)                 "i_clk_mgr_mainpllgrp.mpuclk.cnt"
        set pll_parms(CLK_NOC_SOURCE)              "i_clk_mgr_mainpllgrp.nocclk.src"
        set pll_parms(CLK_NOC_CNT)                 "i_clk_mgr_mainpllgrp.nocclk.cnt"
        set pll_parms(CLK_S2F_USER0_SOURCE)        "i_clk_mgr_mainpllgrp.cntr7clk.src"
        set pll_parms(CLK_S2F_USER1_SOURCE)        "i_clk_mgr_perpllgrp.cntr8clk.src"
        set pll_parms(CLK_HMC_PLL_SOURCE)          "i_clk_mgr_mainpllgrp.cntr9clk.src"
        set pll_parms(CLK_EMAC_PTP_SOURCE)         "i_clk_mgr_perpllgrp.cntr4clk.src"
        set pll_parms(CLK_GPIO_SOURCE)             "i_clk_mgr_perpllgrp.cntr5clk.src"
        set pll_parms(CLK_SDMMC_SOURCE)            "i_clk_mgr_perpllgrp.cntr6clk.src"
        set pll_parms(CLK_EMACA_SOURCE)            "i_clk_mgr_perpllgrp.cntr2clk.src"
        set pll_parms(CLK_EMACB_SOURCE)            "i_clk_mgr_perpllgrp.cntr3clk.src"
        set pll_parms(EMAC0SEL)                    "i_clk_mgr_perpllgrp.emacctl.emac0sel"
        set pll_parms(EMAC1SEL)                    "i_clk_mgr_perpllgrp.emacctl.emac1sel"
        set pll_parms(EMAC2SEL)                    "i_clk_mgr_perpllgrp.emacctl.emac2sel"
        set pll_parms(MAINPLLGRP_VCO_DENOM)        "i_clk_mgr_mainpllgrp.vco1.denom"
        set pll_parms(MAINPLLGRP_VCO_NUMER)        "i_clk_mgr_mainpllgrp.vco1.numer"
        set pll_parms(MAINPLLGRP_MPU_CNT)          "i_clk_mgr_alteragrp.mpuclk.maincnt"
        set pll_parms(MAINPLLGRP_NOC_CNT)          "i_clk_mgr_alteragrp.nocclk.maincnt"
        set pll_parms(MAINPLLGRP_EMACA_CNT)        "i_clk_mgr_mainpllgrp.cntr2clk.cnt"
        set pll_parms(MAINPLLGRP_EMACB_CNT)        "i_clk_mgr_mainpllgrp.cntr3clk.cnt"
        set pll_parms(MAINPLLGRP_EMAC_PTP_CNT)     "i_clk_mgr_mainpllgrp.cntr4clk.cnt"
        set pll_parms(MAINPLLGRP_GPIO_DB_CNT)      "i_clk_mgr_mainpllgrp.cntr5clk.cnt"
        set pll_parms(MAINPLLGRP_SDMMC_CNT)        "i_clk_mgr_mainpllgrp.cntr6clk.cnt"
        set pll_parms(MAINPLLGRP_S2F_USER0_CNT)    "i_clk_mgr_mainpllgrp.cntr7clk.cnt"
        set pll_parms(MAINPLLGRP_S2F_USER1_CNT)    "i_clk_mgr_mainpllgrp.cntr8clk.cnt"
        set pll_parms(MAINPLLGRP_HMC_PLL_REF_CNT)  "i_clk_mgr_mainpllgrp.cntr9clk.cnt"
        set pll_parms(MAINPLLGRP_PERIPH_REF_CNT)   "i_clk_mgr_mainpllgrp.cntr15clk.cnt"
        set pll_parms(PERPLLGRP_VCO_DENOM)         "i_clk_mgr_perpllgrp.vco1.denom"
        set pll_parms(PERPLLGRP_VCO_NUMER)         "i_clk_mgr_perpllgrp.vco1.numer"
        set pll_parms(PERPLLGRP_MPU_CNT)           "i_clk_mgr_alteragrp.mpuclk.pericnt"
        set pll_parms(PERPLLGRP_NOC_CNT)           "i_clk_mgr_alteragrp.nocclk.pericnt"
        set pll_parms(PERPLLGRP_EMACA_CNT)         "i_clk_mgr_perpllgrp.cntr2clk.cnt"
        set pll_parms(PERPLLGRP_EMACB_CNT)         "i_clk_mgr_perpllgrp.cntr3clk.cnt"
        set pll_parms(PERPLLGRP_EMAC_PTP_CNT)      "i_clk_mgr_perpllgrp.cntr4clk.cnt"
        set pll_parms(PERPLLGRP_GPIO_DB_CNT)       "i_clk_mgr_perpllgrp.cntr5clk.cnt"
        set pll_parms(PERPLLGRP_SDMMC_CNT)         "i_clk_mgr_perpllgrp.cntr6clk.cnt"
        set pll_parms(PERPLLGRP_S2F_USER0_CNT)     "i_clk_mgr_perpllgrp.cntr7clk.cnt"
        set pll_parms(PERPLLGRP_S2F_USER1_CNT)     "i_clk_mgr_perpllgrp.cntr8clk.cnt"
        set pll_parms(PERPLLGRP_HMC_PLL_REF_CNT)   "i_clk_mgr_perpllgrp.cntr9clk.cnt"
        set pll_parms(NOCDIV_L4MAINCLK)            "i_clk_mgr_mainpllgrp.nocdiv.l4mainclk"
        set pll_parms(NOCDIV_L4MPCLK)              "i_clk_mgr_mainpllgrp.nocdiv.l4mpclk"
        set pll_parms(NOCDIV_L4SPCLK)              "i_clk_mgr_mainpllgrp.nocdiv.l4spclk"
        set pll_parms(NOCDIV_CS_ATCLK)             "i_clk_mgr_mainpllgrp.nocdiv.csatclk"
        set pll_parms(NOCDIV_CS_TRACECLK)          "i_clk_mgr_mainpllgrp.nocdiv.cstraceclk"
        set pll_parms(NOCDIV_CS_PDBGCLK)           "i_clk_mgr_mainpllgrp.nocdiv.cspdbgclk"
        set pll_parms(CONFIG_HPS_DIV_GPIO)         "i_clk_mgr_perpllgrp.gpiodiv.gpiodbclk"
                
        set pll_parms(TESTIOCTRL_MAINCLKSEL)       "i_clk_mgr_clkmgr.testioctrl.mainclksel"
        set pll_parms(TESTIOCTRL_PERICLKSEL)       "i_clk_mgr_clkmgr.testioctrl.periclksel"
        set pll_parms(TESTIOCTRL_DEBUGCLKSEL)      "i_clk_mgr_clkmgr.testioctrl.debugclksel"
                
        foreach param  [array names pll_parms] {
            set config_elem [xml::writer::create_element "config"]
            xml::writer::add_child   $pin_muxes_elem          $config_elem
            xml::writer::set_attribute  $config_elem  "name"  $pll_parms($param)
            xml::writer::set_attribute  $config_elem  "value" $parameters($param)
        }
    }


    proc to_sw_peripheral_name {peripheral_name} {
        array set map {
            I2C0  I2C0
            I2C1  I2C1
            I2CEMAC0  I2CEMAC0
            I2CEMAC1  I2CEMAC1
            I2CEMAC2  I2CEMAC2
            NAND  NAND
            SPIM0 SPIM0
            SPIM1 SPIM1
            SPIS0 SPIS0
            SPIS1 SPIS1
            UART0 UART0 
            UART1 UART1
            USB0  USB0
            USB1  USB1
            CM    PLL_CLOCK_OUT
            EMAC0 RGMII0
            EMAC1 RGMII1
            EMAC2 RGMII2
            SDMMC  SDMMC
            TRACE TRACE
        }
        set name ""
        if {[info exists map($peripheral_name)]} {
            set name $map($peripheral_name)
        }
        return $name
    }
    
    proc calc_pin_mux_names_and_values {parameters_ref } {
        upvar 1 $parameters_ref parameters
    
        set result [list]
    
        set part        $parameters(device_name)
        set hps_io_list $parameters(HPS_IO_Enable)
        
        array set pin_mux_table    [::pin_mux_db::load_pin_mux_table      $part]
        array set pad_to_pin_table [::pin_mux_db::load_pad_to_pin_name    $part]
        array set io_locations     [::pin_mux_db::load_pad_to_index_table $part]
        
        
        foreach { location list_of_valid_locations }  [array get pin_mux_table ] {
            set location_index $io_locations($location)

            set hps_io_assigment   [string trim [lindex $hps_io_list $location_index]]
            # The pn mux has this pin named MDTO but java gui uses EMAC
            if { [string match   "MDIO?:MD*" $hps_io_assigment ] } {
                set hps_io_assigment [string replace $hps_io_assigment 0 3 "EMAC" ]
            }

            ### Set the pin mux for XML file
            set pin_mux_setting 10
            set pin_mux_choice "N/A"
            if {$hps_io_assigment  == "GPIO" } {
                set pin_mux_setting 15
                set pin_mux_choice "default"
            } else {
                foreach {pin_mux_value  hps_io_option}  $list_of_valid_locations {
                    if {$hps_io_option == $hps_io_assigment} {
                        set pin_mux_setting $pin_mux_value
                        set pin_mux_choice  $hps_io_option
                    }
                }
            }
            #<pin_mux name='GPLMUX0' choice='GPIO' value='1' />
            set pin_name $pad_to_pin_table($location)
            lappend result $pin_name $pin_mux_choice $pin_mux_setting 

        }
        
        return $result
    }
    
    
    # remove TRACE component in *USEFPGA option( TRACE already in FPGA interface/general)
    proc list_sw_peripheral_names {} {
        set peripheral_names [list_peripheral_names]
        set trace_index [lsearch $peripheral_names TRACE]
        return [lreplace $peripheral_names $trace_index $trace_index]
    }
################################################################################
#
    namespace eval pin_muxing_model {
################################################################################

        source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util constants.tcl]
        source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util procedures.tcl]
    
        variable peripherals
        variable gpio_pins
        variable parameters
        proc set_peripherals_model {peripherals_in} {
            variable peripherals
            set peripherals $peripherals_in
        }
        proc set_gpio_pins {gpio_pins_in} {
            variable gpio_pins
            set gpio_pins $gpio_pins_in
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
        proc get_unsupported_peripheral {peripheral_name} {
            return 0
        }
    }
}
