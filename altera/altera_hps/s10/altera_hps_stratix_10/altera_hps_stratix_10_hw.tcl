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
package require -exact altera_terp 1.0
package require quartus::advanced_wysiwyg

set_module_property NAME altera_stratix10_hps
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property SUPPORTED_DEVICE_FAMILIES {Stratix10}

set_module_property GROUP "Processors and Peripherals/Hard Processor Systems"
set_module_property DESCRIPTION "The HPS contains a microprocessor unit (MPU) subsystem with Cuad-core ARM® Cortex-A56 MPCore processors, flash memory controllers, dedicatedSDRAMcontroller interconnect, on-chip memories, support peripherals, interface peripherals, debug capabilities, and phase-locked loops (PLLs)."
set_module_property DISPLAY_NAME "Stratix 10 Hard Processor System"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QUARTUS true
add_documentation_link "HPS User Guide for Stratix 10"   "http://www.altera.com/literature/lit-arria-10.jsp"


source ../util/constants.tcl
source ../util/procedures.tcl
source ../util/pin_mux_db.tcl
source ../util/locations.tcl
source clocks.tcl
source clock_manager.tcl
source elab_bridges.tcl
source diagnostics.tcl


proc add_storage_parameter {name { default_value {} } } {
    add_parameter $name string $default_value ""
    set_parameter_property $name derived true
    set_parameter_property $name visible false
}


proc list_h2f_interrupt_groups {} {
    return {
        "CLOCKPERIPHERAL" "CTI"
        "DMA"             "EMAC0" "EMAC1" "EMAC2"
        "FPGAMANAGER"
        "GPIO"            "HMC"             "I2CEMAC0" "I2CEMAC1" "I2CEMAC2"
        "I2C0"   "I2C1"     "L4TIMER"         "NAND"
        "SYSTIMER"         "SDMMC"
        "SPIM0"       "SPIM1" "SPIS0" "SPIS1"        "SYSTEMMANAGER"
        "UART0" "UART1"           "USB0"   "USB1"           "WATCHDOG"
    }
}

proc get_h2f_interrupt_descriptions {data_ref} {
    upvar 1 $data_ref data
    array set data {
        "DMA"             "Enable DMA interrupts"
        "EMAC0"           "Enable EMAC0 interrupts"
        "EMAC1"           "Enable EMAC1 interrupts"
        "EMAC2"           "Enable EMAC2 interrupts"
        "USB0"            "Enable USB0 interrupts"
        "USB1"            "Enable USB1 interrupts"
        "SDMMC"           "Enable SD/MMC interrupt"
        "NAND"            "Enable NAND interrupt"
        "SPIM0"           "Enable SPI Master interrupts (for master 0)"
        "SPIM1"           "Enable SPI Master interrupts (for master 1)"
        "SPIS0"           "Enable SPI Slave interrupts (for slave 0)"
        "SPIS1"           "Enable SPI Slave interrupts (for slave 1)"
        "I2C0"            "Enable I2C Peripheral interrupts (for I2C 0)"
        "I2C1"            "Enable I2C Peripheral interrupts (for I2C 1)"
        "I2CEMAC0"        "Enable I2C-EMAC interrupts (for I2C_EMAC 0)"
        "I2CEMAC1"        "Enable I2C-EMAC interrupts (for I2C_EMAC 1)"
        "I2CEMAC2"        "Enable I2C-EMAC interrupts (for I2C_EMAC 2)"
        "UART0"           "Enable UART interrupts (for UART 0)"
        "UART1"           "Enable UART interrupts (for UART 1)"
        "GPIO"            "Enable GPIO interrupts"
        "L4TIMER"         "Enable L4 Timer interrupts"
        "SYSTIMER"        "Enable SYS Timer interrupts"
        "WATCHDOG"        "Enable Watchdog interrupts"
        "CLOCKPERIPHERAL" "Enable Clock Peripheral interrupts"
        "FPGAMANAGER"     "Enable FPGA manager interrupt"
        "CTI"             "Enable CTI interrupts"
        "HMC"             "Enable HMC interrupts"
        "SYSTEMMANAGER"   "Enable ECC/Parity_L1 interrupts"
    }
}

proc get_atom_for_instance {data_ref} {
    upvar 1 $data_ref data
    array set data {
        "EMAC0" "EMAC"
        "EMAC1" "EMAC"
        "EMAC2" "EMAC"
        "USB0"  "USB"
        "USB1"  "USB"
        "SDMMC" "SDMMC"
        "NAND"  "NAND"
        "SPIM0" "SPIM"
        "SPIM1" "SPIM"
        "SPIS0" "SPIS"
        "SPIS1" "SPIS"
        "I2C0"  "I2C"
        "I2C1"  "I2C"
        "I2CEMAC0" "I2C"
        "I2CEMAC1" "I2C"
        "I2CEMAC2" "I2C"
        "UART0" "UART"
        "UART1" "UART"
        "SDIO"  "SDMMC"
        "TRACE" "TRACE"
        "CM"    "CM"
    }
}

proc load_modes_table { modes_table_ref } {
    upvar 1 $modes_table_ref modes_table
    array set modes_table {
        "EMAC"  { "RGMII" "RMII" "RGMII_with_I2C" "RMII_with_I2C" "RGMII_with_MDIO" "RMII_with_MDIO" }
        "NAND"  { "8-bit" "16-bit" }
        "SDMMC" { "1-bit"  "4-bit"  "8-bit"  }
        "SDIO"  { "1-bit"  "4-bit"  "8-bit"  }
        "USB"   { "default" }
        "SPIM"  { "Dual_slave_selects" "Single_slave_selects" }
        "SPIS"  { "default" }
        "UART"  { "Flow_control" "No_flow_control" }
        "I2C"   { "default" }
        "TRACE" { "default" }
        "CM"    { "1" "2" "3" "4" "0" "default" }
    }
}

proc load_h2f_interrupt_table {functions_by_group_ref
                               width_by_function_ref
                               inverted_by_function_ref} {
    upvar 1 $functions_by_group_ref   functions_by_group
    upvar 1 $width_by_function_ref    width_by_function
    upvar 1 $inverted_by_function_ref inverted_by_function
    array set functions_by_group {
        "DMA"             {"dma"          "dma_abort"                }
        "EMAC0"           {"emac0"                                   }
        "EMAC1"           {"emac1"                                   }
        "EMAC2"           {"emac2"                                   }
        "USB0"            {"usb0"                                    }
        "USB1"            {"usb1"                                    }
        "SDMMC"           {"sdmmc"                                   }
        "NAND"            {"nand"                                    }
        "SPIM0"           {"spim0"                                   }
        "SPIM1"           {"spim1"                                   }
        "SPIS0"           {"spis0"                                   }
        "SPIS1"           {"spis1"                                   }
        "I2C0"            {"i2c0"                                    }
        "I2C1"            {"i2c1"                                    }
        "I2CEMAC0"        {"i2c_emac0"                               }
        "I2CEMAC1"        {"i2c_emac1"                               }
        "I2CEMAC2"        {"i2c_emac2"                               }
        "UART0"           {"uart0"                                   }
        "UART1"           {"uart1"                                   }
        "GPIO"            {"gpio0"        "gpio1"        "gpio2"     }
        "L4TIMER"         {"timer_l4sp_0" "timer_l4sp_1"             }
        "SYSTIMER"        {"timer_sys_0"  "timer_sys_1"              }
        "WATCHDOG"        {"wdog0"        "wdog1"                    }
        "CLOCKPERIPHERAL" {"clkmgr"       "mpuwakeup"                }
        "FPGAMANAGER"     {"fpga_man"                                }
        "CTI"             {"ncti"                                    }
        "HMC"             {"hmc"                                     }
        "SYSTEMMANAGER"   {"ecc_serr"     "ecc_derr"     "parity_l1" }
    }
    array set width_by_function {
        "dma"        8
        "ncti"       2
    }
    array set inverted_by_function {
    }
}

proc add_interrupt_parameters {} {
    set top_group_name "Interrupts"
    add_display_item "FPGA Interfaces" $top_group_name "group" ""

    set inner_group_name "FPGA-to-HPS"    
    add_display_item $top_group_name $inner_group_name "group" ""
    add_parameter            F2SINTERRUPT_Enable   boolean        false
    set_parameter_property   F2SINTERRUPT_Enable   enabled        true
    set_parameter_property   F2SINTERRUPT_Enable   display_name   "Enable FPGA-to-HPS Interrupts"
    set_parameter_property   F2SINTERRUPT_Enable   description    "Enables the interrupt interface allowing the FPGA interrupt signal to be driven into the HPS generic interrupt controller (GIC), 2 x 32 bit wide (64 bir total)"
    set_parameter_property   F2SINTERRUPT_Enable   group          $inner_group_name

    set inner_group_name "HPS-to-FPGA"
    add_display_item $top_group_name $inner_group_name "group" ""
    get_h2f_interrupt_descriptions descriptions_by_group
    set interrupt_groups [list_h2f_interrupt_groups]
    foreach interrupt_group $interrupt_groups {
        set parameter "S2FINTERRUPT_${interrupt_group}_Enable"
        add_parameter          $parameter boolean      false
        set_parameter_property $parameter enabled      true
        set_parameter_property $parameter display_name $descriptions_by_group($interrupt_group)
        set_parameter_property $parameter group        $inner_group_name
        set_parameter_property $parameter description  "Enables the HPS peripheral interrupt for $interrupt_group to be driven into the FPGA fabric. If Disabled, you need to enable it in the Pin Mux and peripherals tab first."
    }
}
proc add_dma_parameters {} {
    set group_name "DMA Peripheral Request"
    add_display_item "FPGA Interfaces" $group_name "group" ""
    add_display_item $group_name "DMA Table" "group" "table"

    add_parameter           DMA_PeriphId_DERIVED string_list {0 1 2 3 4 5 6 7}
    set_parameter_property  DMA_PeriphId_DERIVED display_name "Peripheral Request ID"
    set_parameter_property  DMA_PeriphId_DERIVED derived true
    set_parameter_property  DMA_PeriphId_DERIVED display_hint "FIXED_SIZE"
    set_parameter_property  DMA_PeriphId_DERIVED group        "DMA Table"
    set_parameter_property  DMA_PeriphId_DERIVED description  "You can enable each direct memory access (DMA) controller peripheral request interface, individually. Each of the eight peripheral request ID setting enables or disables a peripheral request interface."

    add_parameter           DMA_Enable string_list    {"No" "No" "No" "No" "No" "No" "No" "No"}
    set_parameter_property  DMA_Enable allowed_ranges {"Yes" "No"}
    set_parameter_property  DMA_Enable display_name    "Enabled"
    set_parameter_property  DMA_Enable display_hint    "FIXED_SIZE"
    set_parameter_property  DMA_Enable group           "DMA Table"
    set_parameter_property  DMA_Enable description     "When set to enable, it allowsfor FPGA soft logic to request a DMA transfer. For DMA transfers to or from the FPGA, this feature is only necessary if your design requires transfer flow control."
}

proc add_security_module_parameters {} {
    set group_name "Security Manager"
    add_display_item "FPGA Interfaces" $group_name "group" ""

    add_parameter            SECURITY_MODULE_Enable   boolean        false
    set_parameter_property   SECURITY_MODULE_Enable   enabled        true
    set_parameter_property   SECURITY_MODULE_Enable   display_name   "Enable Anti-tamper Signals"
    set_parameter_property   SECURITY_MODULE_Enable   description    "The security manager anti-tamper interface provides communication between the anti-tamper logic in the FPGA and the HPS Security Manager."
    set_parameter_property   SECURITY_MODULE_Enable   group          $group_name
}

proc add_fpga_emac_switch_parameters {} {
    set group_name "FPGA EMAC Switch Interface"
    add_display_item "FPGA Interfaces" $group_name "group" ""

    add_parameter            EMAC0_SWITCH_Enable   boolean        false
    set_parameter_property   EMAC0_SWITCH_Enable   enabled        true
    set_parameter_property   EMAC0_SWITCH_Enable   display_name   "Enable EMAC0 Ethernet Switch Interface"
    set_parameter_property   EMAC0_SWITCH_Enable   group          $group_name
    set_parameter_property   EMAC0_SWITCH_Enable   description    "The FPGA ethernet MAC (EMAC) switch interface provides direct connectivity from FPGA soft logic to the HPS EMAC peripherals, bypassing the L3 Interconnect."

    add_parameter            EMAC1_SWITCH_Enable   boolean        false
    set_parameter_property   EMAC1_SWITCH_Enable   enabled        true
    set_parameter_property   EMAC1_SWITCH_Enable   display_name   "Enable EMAC1 Ethernet Switch Interface"
    set_parameter_property   EMAC1_SWITCH_Enable   group          $group_name
    set_parameter_property   EMAC1_SWITCH_Enable   description    "The FPGA ethernet MAC (EMAC) switch interface provides direct connectivity from FPGA soft logic to the HPS EMAC peripherals, bypassing the L3 Interconnect."

    add_parameter            EMAC2_SWITCH_Enable   boolean        false
    set_parameter_property   EMAC2_SWITCH_Enable   enabled        true
    set_parameter_property   EMAC2_SWITCH_Enable   display_name   "Enable EMAC2 Ethernet Switch Interface"
    set_parameter_property   EMAC2_SWITCH_Enable   group          $group_name
    set_parameter_property   EMAC2_SWITCH_Enable   description    "The FPGA ethernet MAC (EMAC) switch interface provides direct connectivity from FPGA soft logic to the HPS EMAC peripherals, bypassing the L3 Interconnect."
}


add_display_item ""                "FPGA Interfaces"  "group" "tab"
add_display_item "FPGA Interfaces" "General"          "group" ""

add_parameter            MPU_EVENTS_Enable  boolean        true
set_parameter_property   MPU_EVENTS_Enable  display_name   "Enable MPU standby and event signals"
set_parameter_property   MPU_EVENTS_Enable  description    "Enables interfaces that perform the following functions: <p> Notify the FPGA fabric that the microprocessorunit (MPU) is in standby mode <p> Wake up the MPU from a wait for event (WFE) state"
set_parameter_property   MPU_EVENTS_Enable  group          "General"

add_parameter            GP_Enable   boolean        false
set_parameter_property   GP_Enable   display_name   "Enable general purpose signals"
set_parameter_property   GP_Enable   description    "Enables a pair of 32-bit unidirectional general-purpose interfaces between the FPGA fabric and the FPGA manager in the HPS"
set_parameter_property   GP_Enable   group          "General"

add_parameter            DEBUG_APB_Enable  boolean       false
set_parameter_property   DEBUG_APB_Enable  display_name  "Enable Debug APB interface"
set_parameter_property   DEBUG_APB_Enable  description   "Enables the APB debug master interface into the FPGA, allowing debuggers access to debug information in FPGA soft IP."
set_parameter_property   DEBUG_APB_Enable  group         "General"

add_parameter            STM_Enable   boolean        false
set_parameter_property   STM_Enable   display_name   "Enable System Trace Macrocell hardware events"
set_parameter_property   STM_Enable   description    "Enables system trace macrocell (STM) hardware events, allowing logic inside the FPGA fabric to insert messages into the trace stream"
set_parameter_property   STM_Enable   group          "General"

add_parameter            CTI_Enable   boolean        false
set_parameter_property   CTI_Enable   display_name   "Enable FPGA Cross Trigger Interface"
set_parameter_property   CTI_Enable   description    "Enables the cross trigger interface (CTI), which allows trigger sources and sinks to interface with the embedded cross trigger (ECT) system"
set_parameter_property   CTI_Enable   group          "General"



add_parameter            JTAG_Enable  boolean        false
set_parameter_property   JTAG_Enable  enabled        true
set_parameter_property   JTAG_Enable  display_name   "Enable Jtag Interface"
set_parameter_property   JTAG_Enable  group          "General"
set_parameter_property   JTAG_Enable  description    "Enables the JTAG hosting interface to the FPGA. This interface allows the HPS to communicate with the JTAG logic in the FPGA directly."
set_parameter_property   JTAG_Enable  visible        false

add_parameter            TEST_Enable  boolean        false
set_parameter_property   TEST_Enable  enabled        true
set_parameter_property   TEST_Enable  display_name   "Enable Test Interface (Internal Altera Use Only!)"
set_parameter_property   TEST_Enable  group          "General"

add_display_item "FPGA Interfaces" "Boot and Clock Selection" "group" ""

add_parameter            BOOT_FROM_FPGA_Enable   boolean        false
set_parameter_property   BOOT_FROM_FPGA_Enable   enabled        true
set_parameter_property   BOOT_FROM_FPGA_Enable   display_name   "Enable boot from fpga signals"
set_parameter_property   BOOT_FROM_FPGA_Enable   description    "Enables an input to the HPS indicating it is safe for the processor to boot from memory located at offset 0x0 of the HPS-to-FPGA bridge (absolute address 0xTBD). This ensures that a valid bootloader image is available before the bootROM code attempts to jump to the location in the FPGA."
set_parameter_property   BOOT_FROM_FPGA_Enable   group          "Boot and Clock Selection"


add_parameter            BSEL_EN      boolean        false
set_parameter_property   BSEL_EN      display_name   "Enable boot selection from FPGA"
set_parameter_property   BSEL_EN      group          "Boot and Clock Selection"
set_parameter_property   BSEL_EN      visible        false
set_parameter_property   BSEL_EN      enabled        false
set_parameter_property   BSEL_EN      description    "Enable boot selection from FPGA"

add_parameter            BSEL         integer 1
set_parameter_property   BSEL         allowed_ranges { "0:RESERVED" "1:FPGA" "2:NAND Flash (1.8v)" "3:NAND Flash (3.0v)" "4:SD/MMC External Transceiver (1.8v)" "5:SD/MMC Internal Transceiver (3.0v)" "6:Quad SPI Flash (1.8v)" "7:Quad SPI Flash (3.0v)"}
set_parameter_property   BSEL         display_name   "Boot selection from FPGA"
set_parameter_property   BSEL         group          "Boot and Clock Selection"
set_parameter_property   BSEL         visible        false
set_parameter_property   BSEL         enabled        false
set_parameter_property   BSEL         description    "Selects the boot source"


add_display_item "FPGA Interfaces"   "HPS FPGA Bridge" "group" ""
add_parameter            F2S_Width  integer 2
set_parameter_property   F2S_Width  allowed_ranges {"0:Unused" "1:32-bit AXI" "2:64-bit AXI" "3:128-bit AXI" "4:32-bit AXI (ready latency support)" "5:64-bit AXI (ready latency support)" "6:128-bit AXI (ready latency support)"}
set_parameter_property   F2S_Width  display_name   "FPGA-to-HPS interface width"
set_parameter_property   F2S_Width  hdl_parameter  true
set_parameter_property   F2S_Width  group          "HPS FPGA Bridge"
set_parameter_property   F2S_Width   description    "Enable or disable the FPGA-to-HPS interface; if enabled, set the data width to 32, 64, or 128 bits and optionally enable ready latency support."

add_parameter            S2F_Width  integer 2
set_parameter_property   S2F_Width  allowed_ranges {"0:Unused" "1:32-bit AXI" "2:64-bit AXI" "3:128-bit AXI" "4:32-bit AXI (ready latency support)" "5:64-bit AXI (ready latency support)" "6:128-bit AXI (ready latency support)"}
set_parameter_property   S2F_Width  display_name   "HPS-to-FPGA interface width"
set_parameter_property   S2F_Width  hdl_parameter  true
set_parameter_property   S2F_Width  group          "HPS FPGA Bridge"
set_parameter_property   S2F_Width  description    "Enable or disable the HPS-to-FPGA interface; if enabled, set the data width to 32, 64, or 128 bits and optionally enable ready latency support."

add_parameter            LWH2F_Enable integer 1
set_parameter_property   LWH2F_Enable display_name "Lightweight HPS-to-FPGA interface width"
set_parameter_property   LWH2F_Enable description  "The lightweight HPS-to-FPGA bridge provides a secondary, fixed-width, smaller address space, lower-performance master interface to the FPGA fabric. Use the lightweight HPS-to-FPGA bridge for high-latency, low-bandwidth traffic, such as memory-mapped register accesses of FPGA peripherals. This approach diverts traffic from the high-performance HPS-to-FPGA bridge, which can improve overall performance."
set_parameter_property   LWH2F_Enable allowed_ranges {"0:Unused" "1:32-bit AXI" "2:32-bit AXI (ready latency support)"}
set_parameter_property   LWH2F_Enable group        "HPS FPGA Bridge"



add_parameter            RUN_INTERNAL_BUILD_CHECKS  integer        0
set_parameter_property   RUN_INTERNAL_BUILD_CHECKS  display_name   "Runs internal test for new builds. It makes the IP too slow. (Internal Altera Use Only!)"
set_parameter_property   RUN_INTERNAL_BUILD_CHECKS  group          "General"
set_parameter_property   RUN_INTERNAL_BUILD_CHECKS  visible        false


set group_name "FPGA-to-HPS SDRAM Interface"
add_display_item "FPGA Interfaces" $group_name "group" ""


add_parameter            F2SDRAM0_Width  integer 0
set_parameter_property   F2SDRAM0_Width  allowed_ranges {"0:Unused" "1:32-bit AXI" "2:64-bit AXI" "3:128-bit AXI" "4:32-bit AXI (ready latency support)" "5:64-bit AXI (ready latency support)" "6:128-bit AXI (ready latency support)"}
set_parameter_property   F2SDRAM0_Width  display_name   "F2SDRAM0 port "
set_parameter_property   F2SDRAM0_Width  hdl_parameter  true
set_parameter_property   F2SDRAM0_Width  group          $group_name
set_parameter_property   F2SDRAM0_Width  description    "Enable or disable the F2SDRAM port 0; if enabled, set the data width to 32, 64, or 128 bits and optionally enable ready latency support."

add_parameter            F2SDRAM1_Width  integer 0
set_parameter_property   F2SDRAM1_Width  allowed_ranges {"0:Unused" "1:32-bit AXI" "2:64-bit AXI" "3:128-bit AXI" "4:32-bit AXI (ready latency support)" "5:64-bit AXI (ready latency support)" "6:128-bit AXI (ready latency support)"}
set_parameter_property   F2SDRAM1_Width  display_name   "F2SDRAM1 port "
set_parameter_property   F2SDRAM1_Width  hdl_parameter  true
set_parameter_property   F2SDRAM1_Width  group          $group_name
set_parameter_property   F2SDRAM1_Width  description    "Enable or disable the F2SDRAM port 1; if enabled, set the data width to 32, 64, or 128 bits and optionally enable ready latency support."

add_parameter            F2SDRAM2_Width  integer 0
set_parameter_property   F2SDRAM2_Width  allowed_ranges {"0:Unused" "1:32-bit AXI" "2:64-bit AXI" "3:128-bit AXI" "4:32-bit AXI (ready latency support)" "5:64-bit AXI (ready latency support)" "6:128-bit AXI (ready latency support)"}
set_parameter_property   F2SDRAM2_Width  display_name   "F2SDRAM2 port "
set_parameter_property   F2SDRAM2_Width  hdl_parameter  true
set_parameter_property   F2SDRAM2_Width  group          $group_name
set_parameter_property   F2SDRAM2_Width  description    "Enable or disable the F2SDRAM port 2; if enabled, set the data width to 32, 64, or 128 bits and optionally enable ready latency support."


add_parameter            F2SDRAM_ADDRESS_WIDTH  integer 32
set_parameter_property   F2SDRAM_ADDRESS_WIDTH  display_name   "F2SDRAM bidge address width"
set_parameter_property   F2SDRAM_ADDRESS_WIDTH  allowed_ranges {"32:32-bit 4Gb" "31:31-bit 2Gb" "30:30-bit 1Gb" "29:29-bit 512 Mb" "28:28-bit 256 Mb" "27:27-bit 128 Mb" "26:26-bit 64 Mb" }
set_parameter_property   F2SDRAM_ADDRESS_WIDTH  group          $group_name
set_parameter_property   F2SDRAM_ADDRESS_WIDTH  description    "Use this setting to select the HPS external memroy interface address width. It will configure the AXI address space in QSYS"


add_dma_parameters
add_security_module_parameters
add_fpga_emac_switch_parameters
add_interrupt_parameters

proc make_mode_display_name {peripheral} {
    set default_suffix "mode"
    array set custom_suffix_by_peripheral {
        USB0 "PHY interface mode"
        USB1 "PHY interface mode"
    }
    if {[info exists custom_suffix_by_peripheral($peripheral)]} {
        set suffix $custom_suffix_by_peripheral($peripheral)
    } else {
        set suffix $default_suffix
    }

    set display_name "${peripheral} ${suffix}"
    return $display_name
}


proc add_peripheral_pin_muxing_parameters {} {
    set TOP_LEVEL_GROUP_NAME "Peripheral Pins"
    set show_parameters false
    if {$show_parameters} {
        add_display_item "" $TOP_LEVEL_GROUP_NAME "group" "tab"
    }
    

    load_modes_table modes_table
    get_atom_for_instance instance_map

    foreach group_name [list_group_names] {
        if {$show_parameters} {
            add_display_item $TOP_LEVEL_GROUP_NAME $group_name "group" ""
        }

        foreach peripheral_name [peripherals_in_group $group_name] {
            set pin_muxing_param_name "${peripheral_name}_PinMuxing"
            set mode_param_name       "${peripheral_name}_Mode"

            set atom $instance_map($peripheral_name)
            set values $modes_table($atom)
            lappend values [NA_MODE_VALUE]
            lappend values "Full"

            add_parameter                 $pin_muxing_param_name  string [UNUSED_MUX_VALUE]
            set_parameter_property        $pin_muxing_param_name  enabled          true
            set_parameter_property        $pin_muxing_param_name  display_name     "${peripheral_name} pin"
            set_parameter_property        $pin_muxing_param_name  allowed_ranges   [list [UNUSED_MUX_VALUE] [FPGA_MUX_VALUE] [IO_MUX_VALUE] ]
            set_parameter_property        $pin_muxing_param_name  group            $group_name
            set_parameter_property        $pin_muxing_param_name  visible          $show_parameters

            set mode_display_name [make_mode_display_name $peripheral_name]
            add_parameter            $mode_param_name        string [NA_MODE_VALUE]
            set_parameter_property   $mode_param_name        enabled          true
            set_parameter_property   $mode_param_name        display_name     $mode_display_name
            set_parameter_property   $mode_param_name        allowed_ranges   $values
            set_parameter_property   $mode_param_name        group            $group_name
            set_parameter_property   $mode_param_name        visible          $show_parameters

        }
    }
    
    set group_name "Trace Width"
    if {$show_parameters} {
        add_display_item $TOP_LEVEL_GROUP_NAME $group_name "group" ""
    }
    add_parameter           TRACE_WIDTH integer        4
    set_parameter_property  TRACE_WIDTH allowed_ranges 4:32
    set_parameter_property  TRACE_WIDTH enabled        true
    set_parameter_property  TRACE_WIDTH display_name   "Trace Width"
    set_parameter_property  TRACE_WIDTH group          $group_name
    set_parameter_property  TRACE_WIDTH visible        $show_parameters
    
    
    set group_name "PLL CLK out"
    if {$show_parameters} {
        add_display_item $TOP_LEVEL_GROUP_NAME $group_name "group" ""
    }
    for {set i 0} {$i < 5} {incr i} {
        set peripheral_name "PLL_CLK${i}"
        add_parameter                 $peripheral_name  string [UNUSED_MUX_VALUE]
        set_parameter_property        $peripheral_name  enabled          true
        set_parameter_property        $peripheral_name  display_name     "${peripheral_name} pin"
        set_parameter_property        $peripheral_name  allowed_ranges   [list [UNUSED_MUX_VALUE] [IO_MUX_VALUE] ]
        set_parameter_property        $peripheral_name  group            $group_name
        set_parameter_property        $peripheral_name  visible          $show_parameters
    }

    set max_possible_hps_io_options 48
    set hps_io_list [list]

    for {set i 0} {$i < $max_possible_hps_io_options} {incr i} {
        lappend hps_io_list "unused"
    }


    set group_name "Pin assigments"
    if {$show_parameters} {
        add_display_item $TOP_LEVEL_GROUP_NAME $group_name "group" ""
    }
    add_parameter           HPS_IO_Enable string_list   $hps_io_list
    set_parameter_property  HPS_IO_Enable enabled       true
    set_parameter_property  HPS_IO_Enable display_name  "HPSIO Enabled"
    set_parameter_property  HPS_IO_Enable group         $group_name
    set_parameter_property  HPS_IO_Enable visible       $show_parameters


    add_parameter           PIN_TO_BALL_MAP string_list   {}
    set_parameter_property  PIN_TO_BALL_MAP enabled       true
    set_parameter_property  PIN_TO_BALL_MAP display_name  "HPA ball names"
    set_parameter_property  PIN_TO_BALL_MAP group         $group_name
    set_parameter_property  PIN_TO_BALL_MAP visible       false
    set_parameter_property  PIN_TO_BALL_MAP DERIVED       true


}


proc add_pin_mux_gui {} {
    #TER
    set TOP_LEVEL_GROUP_NAME "Pin Mux and Peripherals"
    set group_name "Pin Mux GUI"

    add_display_item ""                    $TOP_LEVEL_GROUP_NAME "group" "tab"
    add_display_item $TOP_LEVEL_GROUP_NAME $group_name     "group" ""

    add_parameter                JAVA_ERROR_MSG   string_list {}
    set_parameter_property  JAVA_ERROR_MSG   derived true
    set_parameter_property  JAVA_ERROR_MSG   visible false

    add_parameter                JAVA_WARNING_MSG   string_list {}
    set_parameter_property  JAVA_WARNING_MSG   derived true
    set_parameter_property  JAVA_WARNING_MSG   visible false
    

    set widget_parameters {
        NAND_PinMuxing            NAND_PinMuxing
        NAND_Mode                   NAND_Mode
        EMAC0_PinMuxing          EMAC0_PinMuxing
        EMAC0_Mode                 EMAC0_Mode
        EMAC1_PinMuxing          EMAC1_PinMuxing
        EMAC1_Mode                 EMAC1_Mode
        EMAC2_PinMuxing          EMAC2_PinMuxing
        EMAC2_Mode                 EMAC2_Mode
        SDMMC_PinMuxing             SDIO_PinMuxing
        SDMMC_Mode                    SDIO_Mode
        USB0_PinMuxing             USB0_PinMuxing
        USB0_Mode                    USB0_Mode
        USB1_PinMuxing             USB1_PinMuxing
        USB1_Mode                     USB1_Mode
        SPIM0_PinMuxing             SPIM0_PinMuxing
        SPIM0_Mode                    SPIM0_Mode
        SPIM1_PinMuxing             SPIM1_PinMuxing
        SPIM1_Mode                    SPIM1_Mode
        SPIS0_PinMuxing             SPIS0_PinMuxing
        SPIS0_Mode                    SPIS0_Mode
        SPIS1_PinMuxing             SPIS1_PinMuxing
        SPIS1_Mode                    SPIS1_Mode
        UART0_PinMuxing           UART0_PinMuxing
        UART0_Mode                  UART0_Mode
        UART1_PinMuxing           UART1_PinMuxing
        UART1_Mode                  UART1_Mode
        I2C0_PinMuxing              I2C0_PinMuxing
        I2C0_Mode                     I2C0_Mode
        I2C1_PinMuxing              I2C1_PinMuxing
        I2C1_Mode                     I2C1_Mode
        I2CEMAC0_PinMuxing              I2C_EMAC0_PinMuxing
        I2CEMAC0_Mode                     I2C_EMAC0_Mode
        I2CEMAC1_PinMuxing              I2C_EMAC1_PinMuxing
        I2CEMAC1_Mode                     I2C_EMAC1_Mode
        I2CEMAC2_PinMuxing              I2C_EMAC2_PinMuxing
        I2CEMAC2_Mode                     I2C_EMAC2_Mode
        CM_PinMuxing                CM_PinMuxing
        CM_Mode                       CM_Mode
        PLL_CLK0                       PLL_CLK0
        PLL_CLK1                       PLL_CLK1
        PLL_CLK2                       PLL_CLK2
        PLL_CLK3                       PLL_CLK3
        PLL_CLK4                       PLL_CLK4
        TRACE_PinMuxing         TRACE_PinMuxing
        TRACE_Mode                 TRACE_Mode
        HPS_IO_Enable              HPS_IO_Enable
        JAVA_ERROR_MSG         JAVA_ERROR_MSG
        JAVA_WARNING_MSG     JAVA_WARNING_MSG
    }

    add_display_item $group_name the_widget "group"
    set_display_item_property the_widget widget [list ../pin_mux_gui/pin_mux_stratix10.jar pin_mux_stratix10]
    set_display_item_property the_widget WIDGET_PARAMETER_MAP $widget_parameters
    
    
    ################################
    set group_name "Pin Mux Report"
    add_display_item $TOP_LEVEL_GROUP_NAME $group_name     "group" ""
    add_display_item $group_name PIN_REPORT  TEXT ""

}


set TOP_LEVEL_GROUP_NAME "HPS Clocks and resets"
add_display_item "" $TOP_LEVEL_GROUP_NAME "group" "tab" 
add_clock_tab $TOP_LEVEL_GROUP_NAME


###############################################################################################
proc add_sdram_parameters {} {

    set TOP_LEVEL_GROUP_NAME "SDRAM"
    add_display_item ""                    $TOP_LEVEL_GROUP_NAME "group" "tab"
    add_display_item $TOP_LEVEL_GROUP_NAME "EMIF Conduit"        "group" ""
    add_parameter            EMIF_CONDUIT_Enable  boolean        true
    set_parameter_property   EMIF_CONDUIT_Enable  display_name   "Enable the conduit to connect to the Stratix 10 External Memory Interface"
    set_parameter_property   EMIF_CONDUIT_Enable  description    "Enables the HPS dedicated conduit to the Stratix 10 External Memory Interface for HPS. This conduit cannot connect to any other External Memory Interface (EMIF). Only IP generated by the Arria 10 External Memory Interface for HPS Qsys library should be used."
    set_parameter_property   EMIF_CONDUIT_Enable  group          "EMIF Conduit"
}
add_sdram_parameters
add_pin_mux_gui

add_peripheral_pin_muxing_parameters



add_parameter          hps_device_family string "" ""
set_parameter_property hps_device_family derived true
set_parameter_property hps_device_family system_info {DEVICE_FAMILY}
set_parameter_property hps_device_family visible false

add_parameter          device_name string "" ""
set_parameter_property device_name system_info {DEVICE}
set_parameter_property device_name visible false


add_parameter          quartus_ini_hps_ip_enable_test_interface boolean "" ""
set_parameter_property quartus_ini_hps_ip_enable_test_interface system_info_type quartus_ini
set_parameter_property quartus_ini_hps_ip_enable_test_interface system_info_arg  hps_ip_enable_test_interface
set_parameter_property quartus_ini_hps_ip_enable_test_interface visible false


add_parameter          quartus_ini_hps_ip_enable_jtag boolean "" ""
set_parameter_property quartus_ini_hps_ip_enable_jtag system_info_type quartus_ini
set_parameter_property quartus_ini_hps_ip_enable_jtag system_info_arg  hps_ip_enable_jtag
set_parameter_property quartus_ini_hps_ip_enable_jtag visible false


add_parameter          quartus_ini_hps_ip_enable_a10_advanced_options boolean "" ""
set_parameter_property quartus_ini_hps_ip_enable_a10_advanced_options system_info_type quartus_ini
set_parameter_property quartus_ini_hps_ip_enable_a10_advanced_options system_info_arg  hps_ip_enable_a10_advanced_options
set_parameter_property quartus_ini_hps_ip_enable_a10_advanced_options visible false

add_parameter          quartus_ini_hps_ip_boot_from_fpga_ready boolean "" ""
set_parameter_property quartus_ini_hps_ip_boot_from_fpga_ready system_info_type quartus_ini
set_parameter_property quartus_ini_hps_ip_boot_from_fpga_ready system_info_arg  hps_ip_boot_from_fpga_ready
set_parameter_property quartus_ini_hps_ip_boot_from_fpga_ready visible false

add_parameter          quartus_ini_hps_ip_override_sdmmc_4bit boolean "" ""
set_parameter_property quartus_ini_hps_ip_override_sdmmc_4bit system_info_type quartus_ini
set_parameter_property quartus_ini_hps_ip_override_sdmmc_4bit system_info_arg  hps_ip_override_sdmmc_4bit
set_parameter_property quartus_ini_hps_ip_override_sdmmc_4bit visible false


proc load_test_iface_definition {} {
    set csv_file "test_iface.csv"

    set data [list]
    set count 0
    csv_foreach_row $csv_file cols {
        incr count
        if {$count == 1} {
            continue
        }

        lassign_trimmed $cols port width dir
        lappend data $port $width $dir
    }
    return $data
}
add_storage_parameter test_iface_definition [load_test_iface_definition]

# order of interfaces per peripheral should be kept
# order of ports per interface should be kept
proc load_periph_ifaces_db {} {
    set interfaces_file "fpga_peripheral_interfaces.csv"
    set peripherals_file "fpga_peripheral_atoms.csv"
    set ports_file "fpga_interface_ports.csv"
    set pins_file "fpga_port_pins.csv"

    # peripherals and interfaces
    set peripherals([ORDERED_NAMES]) [list]
    funset interface_ports
    set count 0
    set PERIPHERAL_INTERFACES_PROPERTIES_COLUMNS_START 4
    csv_foreach_row $interfaces_file cols {
        incr count

        # skip header
        if {$count == 1} {
            set ordered_names [list]
            set length [llength $cols]
            for {set col $PERIPHERAL_INTERFACES_PROPERTIES_COLUMNS_START} {$col < $length} {incr col} {
                set col_value [lindex $cols $col]
                if {$col_value != ""} {
                    set property_to_col($col_value) $col
                    lappend ordered_names $col_value
                }
            }
            set property_to_col([ORDERED_NAMES]) $ordered_names
            continue
        }

        set peripheral_name [string trim [lindex $cols 0]]
        set interface_name  [string trim [lindex $cols 1]]
        set type            [string trim [lindex $cols 2]]
        set dir             [string trim [lindex $cols 3]]

        funset peripheral
        if {[info exists peripherals($peripheral_name)]} {
            array set peripheral $peripherals($peripheral_name)
        } else {
            funset interfaces
            set interfaces([ORDERED_NAMES]) [list]
            set peripheral(interfaces) [array get interfaces]
            set ordered_names $peripherals([ORDERED_NAMES])
            lappend ordered_names $peripheral_name
            set peripherals([ORDERED_NAMES]) $ordered_names
        }
        funset interfaces
        array set interfaces $peripheral(interfaces)
        set ordered_names $interfaces([ORDERED_NAMES])
        lappend ordered_names $interface_name
        set interfaces([ORDERED_NAMES]) $ordered_names
        funset interface
        set interface(type) $type
        set interface(direction) $dir
        funset properties
        foreach property $property_to_col([ORDERED_NAMES]) {
            set col $property_to_col($property)
            set property_value [lindex $cols $col]

            if {$property_value != ""} {
                # Add Meta Property
                if { [string compare [string index ${property} 0] "@" ] == 0 } {
                    set interface(${property}) ${property_value}
                } else {
                    set properties($property) $property_value
                }
            }
        }

        set interface(properties)         [array get properties]

        set interfaces($interface_name)   [array get interface]
        set peripheral(interfaces)        [array get interfaces]
        set peripherals($peripheral_name) [array get peripheral]

        funset ports
        set ports([ORDERED_NAMES]) [list]
        set interface_ports($interface_name) [array get ports]
    }
    set count 0
    csv_foreach_row $peripherals_file cols {  ;# peripheral atom and location table
        incr count

        # skip header
        if {$count == 1} {
            continue
        }

        set peripheral_name      [string trim [lindex $cols 0]]
        set atom_name            [string trim [lindex $cols 1]]

        funset peripheral
        if {[info exists peripherals($peripheral_name)]} {
            array set peripheral $peripherals($peripheral_name)
        } else {
            # Assume that if a peripheral hasn't be recognized until now, we won't be using it
            continue
        }
        set peripheral(atom_name)           $atom_name
        set peripherals($peripheral_name)   [array get peripheral]
    }
    add_parameter          DB_periph_ifaces string [array get peripherals] ""
    set_parameter_property DB_periph_ifaces derived true
    set_parameter_property DB_periph_ifaces visible false

    set p [array get peripherals]
    #send_message debug "DB_periph_ifaces: ${p}"

    # ports
    array set ports_to_pins {}
    #    # prepopulate interface_ports with names of interfaces that are known
    #    foreach {peripheral_name peripheral_string} [array get peripherals] {
    #        array set peripheral_array $peripheral_string
    #        foreach interface_name [array names peripheral_array] {
    #            set interface_ports($interface_name) {}
    #        }
    #    }
    set count 0
    csv_foreach_row $ports_file cols {
        incr count

        # skip header
        if {$count == 1} continue

        set interface_name   [string trim [lindex $cols 0]]
        set port_name        [string trim [lindex $cols 1]]
        set role             [string trim [lindex $cols 2]]
        set dir              [string trim [lindex $cols 3]]
        set atom_signal_name [string trim [lindex $cols 4]]

        funset interface
        array set interface $interface_ports($interface_name)
        set ordered_names $interface([ORDERED_NAMES])
        lappend ordered_names $port_name
        set interface([ORDERED_NAMES]) $ordered_names

        funset port
        set port(role) $role
        set port(direction) $dir
        set port(atom_signal_name) $atom_signal_name
        set interface($port_name) [array get port]
        set interface_ports($interface_name) [array get interface]

        set ports_to_pins($port_name) {}
    }
    add_parameter          DB_iface_ports string [array get interface_ports] ""
    set_parameter_property DB_iface_ports derived true
    set_parameter_property DB_iface_ports visible false

    set p [array get interface_ports]
    #send_message debug "DB_iface_ports: ${p}"

    # peripheral signals to ports
    set count 0
    csv_foreach_row $pins_file cols {
        incr count

        # skip header
        if {$count == 1} continue

        set peripheral_name [string trim [lindex $cols 0]]
        set pin_name        [string trim [lindex $cols 1]]
        set port_name       [string trim [lindex $cols 2]]

        set is_multibit_signal [regexp {^([a-zA-Z0-9_]+)\[([0-9]+)\]} $port_name match real_name bit]
        if {$is_multibit_signal == 0} {
            set bit 0
        } else {
            set port_name $real_name
        }

        if {[info exists ports_to_pins($port_name)] == 0} {
            send_message error "Peripheral ${peripheral_name} signal ${pin_name} is defined but corresponding FPGA signal ${port_name}\[${bit}\] is not"
        } else {
            funset port
            array set port $ports_to_pins($port_name)

            if {[info exists port($bit)]} {
                 # collision!
                send_message error "Signal ${port_name}\[${bit}\] is having original assignment ${peripheral_name}.${port($bit)} replaced with ${peripheral_name}.${pin_name}"
            }
            set port($bit) $pin_name
            set ports_to_pins($port_name) [array get port]
        }
    }
    add_parameter          DB_port_pins string [array get ports_to_pins] ""
    set_parameter_property DB_port_pins derived true
    set_parameter_property DB_port_pins visible false

    set p [array get ports_to_pins]
    #send_message debug "DB_port_pins: ${p}"

}

# only run during class creation
load_periph_ifaces_db

#######################
##### Composition #####
#######################

namespace eval ::fpga_interfaces {
    source ../interface_generator/api.tcl
}

namespace eval ::hps_io {
    namespace eval internal {
        source ../interface_generator/api.tcl
    }
    variable pins
    variable interface_created

    proc add_peripheral {peripheral_name atom_name location} {
        internal::add_module_instance $peripheral_name $atom_name $location
    }

    proc is_used {} {
        variable interface_created
        return $interface_created
    }
    # oe used in tristate output and inout
    # out used in output and inout
    # in used in input and inout
    proc add_pin {peripheral_name pin_name dir location in_port out_port oe_port} {
        variable pins
        lappend  pins [list $peripheral_name $pin_name $dir $location $in_port $out_port $oe_port]
    }

    proc process_pins {} {
        variable pins
        variable interface_created

        set interface_name "hps_io"
        set hps_io_interface_created 0
        funset ports_used ;# set of inst/ports used
        funset port_wire  ;# map of ports to aliased wires
        foreach pin $pins { ;# Check for multiple uses of the same port and create wires for those cases
            lassign $pin peripheral_name pin_name dir location in_port out_port oe_port

            # check to see if port is used multiple times
            foreach port_part [list $in_port $out_port $oe_port] {
                if {$port_part != "" && [info exists ports_used($port_part)]} {
                    # Assume only outputs will be used multiple times. Inputs would be an error
                    if {[info exists port_wire($port_part)] == 0} {
                        set port_wire($port_part) [internal::allocate_wire]
                        # Drive new wire with port
                        internal::set_wire_port_fragments $port_wire($port_part) driven_by $port_part
                    }
                }
                set ports_used($port_part) 1
            }
        }

        set qip [list]
        foreach pin $pins {
            lassign $pin peripheral_name pin_name dir location in_port out_port oe_port
            foreach port_part_ref {in_port out_port oe_port} { ;# Replace ports with wires if needed
                set port_part [set $port_part_ref]
                if {[info exists port_wire($port_part)]} {
                    set $port_part_ref [internal::wire_tofragment $port_wire($port_part)]
                }
            }

            # Hook things up
            set instance_name [string tolower $peripheral_name] ;# is this necessary???
            if {$hps_io_interface_created == 0} {
                set interface_created 1
                set hps_io_interface_created 1
                internal::add_interface $interface_name conduit input
            }
            set export_signal_name "hps_io_${instance_name}_${pin_name}"
            internal::add_interface_port $interface_name $export_signal_name $export_signal_name $dir 1
            if {[string compare $dir "input"] == 0} {
                        internal::set_port_fragments $interface_name $export_signal_name $in_port
                        internal::add_raw_sdc_constraint "set_false_path -from \[get_ports ${interface_name}_${export_signal_name}\] -to *"
            } elseif {[string compare $dir "output"] == 0} {
                if {[string compare $oe_port "" ] == 0} {
                        internal::set_port_fragments $interface_name $export_signal_name $out_port
                        internal::add_raw_sdc_constraint "set_false_path -from * -to \[get_ports ${interface_name}_${export_signal_name}\]"
                } else {
                        internal::set_port_tristate_output $interface_name $export_signal_name $out_port $oe_port
                        internal::add_raw_sdc_constraint "set_false_path -from * -to \[get_ports ${interface_name}_${export_signal_name}\]"
                }
            } else {
                        internal::set_port_fragments $interface_name $export_signal_name $in_port
                        internal::set_port_tristate_output $interface_name $export_signal_name $out_port $oe_port
                        internal::add_raw_sdc_constraint "set_false_path -from \[get_ports ${interface_name}_${export_signal_name}\] -to *"
                        internal::add_raw_sdc_constraint "set_false_path -from * -to \[get_ports ${interface_name}_${export_signal_name}\]"
            }
            set path_to_pin "hps_io|border|${export_signal_name}\[0\]"
            set location_assignment "set_instance_assignment -name HPS_LOCATION ${location} -entity %entityName% -to ${path_to_pin}"
            lappend qip $location_assignment
        }
        set_qip_strings $qip
    }

    proc init {} {
        internal::init
        variable pins [list]
        variable interface_created 0
    }

    proc serialize {var_name} {
        upvar 1 $var_name data
        process_pins
        internal::serialize data
    }
}

set_module_property composition_callback compose

proc compose {} {

    fpga_interfaces::init

    hps_io::init
    validate
    elab 0

    update_hps_to_fpga_clock_frequency_parameters


    fpga_interfaces::serialize fpga_interfaces_data

    add_instance fpga_interfaces altera_stratix10_interface_generator 
    set_instance_parameter_value fpga_interfaces interfaceDefinition [array get fpga_interfaces_data]

    expose_border fpga_interfaces $fpga_interfaces_data(interfaces)

    declare_cmsis_svd $fpga_interfaces_data(interfaces)

    # io pins
    hps_io::internal::set_property GENERATE_ISW 1
    funset hps_io_border
    hps_io::serialize hps_io_border

    clear_array temp_array
    array set temp_array $hps_io_border(instances)

    add_instance hps_io altera_stratix10_hps_io 
    set_instance_parameter_value hps_io border_description [array get hps_io_border]
    
    expose_border hps_io $hps_io_border(interfaces)

    set_instance_parameter_value hps_io hps_parameter_map [construct_hps_parameter_map]

    set_interface_assignment hps_io "qsys.ui.export_name" hps_io

}

proc logicalview_dtg {} {
    source ../util/hps_utils.tcl

    source hps_clarke_periphs.tcl

    set F2S_Width [ get_parameter_value F2S_Width ]
    set S2F_Width [ get_parameter_value S2F_Width ]
    set h2f_lw_present [ expr [ get_parameter_value LWH2F_Enable ] > 0 ]
    set LWH2F_Enable [ get_parameter_value LWH2F_Enable ]
    set device_family [get_parameter_value hps_device_family]

    set F2SDRAM0_Width   [ get_parameter_value F2SDRAM0_Width ]
    set F2SDRAM1_Width   [ get_parameter_value F2SDRAM1_Width ]
    set F2SDRAM2_Width   [ get_parameter_value F2SDRAM2_Width ]


    set F2SDRAM_ADDRESS_WIDTH [get_parameter_value F2SDRAM_ADDRESS_WIDTH]

    set number_of_a9 2

    add_instance clk_0 hps_clk_src 
    hps_utils_add_instance_clk_reset clk_0 bridges stratix10_hps_bridge_avalon
    set_instance_parameter_value bridges F2S_Width $F2S_Width
    set_instance_parameter_value bridges S2F_Width $S2F_Width
    set_instance_parameter_value bridges LWH2F_Enable $LWH2F_Enable

    set_instance_parameter_value bridges F2SDRAM0_Width $F2SDRAM0_Width
    set_instance_parameter_value bridges F2SDRAM1_Width $F2SDRAM1_Width
    set_instance_parameter_value bridges F2SDRAM2_Width $F2SDRAM2_Width

    
    set_instance_parameter_value bridges F2SDRAM_ADDRESS_WIDTH $F2SDRAM_ADDRESS_WIDTH
    # ACID TODO
    #add_interface h2f_reset reset output
    #set_interface_property h2f_reset EXPORT_OF bridges.h2f_reset
    #set_interface_property h2f_reset PORT_NAME_MAP "h2f_rst_n h2f_rst_n"

    foreach n { 0 1 2 } {
        set F2SDRAM_Width   [ get_parameter_value F2SDRAM${n}_Width ]
        
        if {$F2SDRAM_Width > 0 } {
            add_interface f2sdram${n}_clock clock Input
            set_interface_property f2sdram${n}_clock EXPORT_OF bridges.f2sdram${n}_clock
            set_interface_property f2sdram${n}_clock PORT_NAME_MAP "f2sdram${n}_clk f2sdram${n}_clk"

            add_interface f2sdram${n}_data axi slave
            set_interface_property f2sdram${n}_data EXPORT_OF bridges.f2sdram${n}_data
            set_interface_property f2sdram${n}_data PORT_NAME_MAP "f2sdram${n}_AWID f2sdram${n}_AWID f2sdram${n}_AWADDR f2sdram${n}_AWADDR f2sdram${n}_AWLEN f2sdram${n}_AWLEN f2sdram${n}_AWSIZE f2sdram${n}_AWSIZE f2sdram${n}_AWBURST f2sdram${n}_AWBURST f2sdram${n}_AWLOCK f2sdram${n}_AWLOCK f2sdram${n}_AWCACHE f2sdram${n}_AWCACHE f2sdram${n}_AWPROT f2sdram${n}_AWPROT f2sdram${n}_AWVALID f2sdram${n}_AWVALID f2sdram${n}_AWREADY f2sdram${n}_AWREADY f2sdram${n}_AWUSER f2sdram${n}_AWUSER f2sdram${n}_WID f2sdram${n}_WID f2sdram${n}_WDATA f2sdram${n}_WDATA f2sdram${n}_WSTRB f2sdram${n}_WSTRB f2sdram${n}_WLAST f2sdram${n}_WLAST f2sdram${n}_WVALID f2sdram${n}_WVALID f2sdram${n}_WREADY f2sdram${n}_WREADY f2sdram${n}_BID f2sdram${n}_BID f2sdram${n}_BRESP f2sdram${n}_BRESP f2sdram${n}_BVALID f2sdram${n}_BVALID f2sdram${n}_BREADY f2sdram${n}_BREADY f2sdram${n}_ARID f2sdram${n}_ARID f2sdram${n}_ARADDR f2sdram${n}_ARADDR f2sdram${n}_ARLEN f2sdram${n}_ARLEN f2sdram${n}_ARSIZE f2sdram${n}_ARSIZE f2sdram${n}_ARBURST f2sdram${n}_ARBURST f2sdram${n}_ARLOCK f2sdram${n}_ARLOCK f2sdram${n}_ARCACHE f2sdram${n}_ARCACHE f2sdram${n}_ARPROT f2sdram${n}_ARPROT f2sdram${n}_ARVALID f2sdram${n}_ARVALID f2sdram${n}_ARREADY f2sdram${n}_ARREADY f2sdram${n}_ARUSER f2sdram${n}_ARUSER f2sdram${n}_RID f2sdram${n}_RID f2sdram${n}_RDATA f2sdram${n}_RDATA f2sdram${n}_RRESP f2sdram${n}_RRESP f2sdram${n}_RLAST f2sdram${n}_RLAST f2sdram${n}_RVALID f2sdram${n}_RVALID f2sdram${n}_RREADY f2sdram${n}_RREADY"
            
            if {$F2SDRAM_Width > 3} { 
                add_interface f2sdram${n}_reset reset Input
                set_interface_property f2sdram${n}_reset EXPORT_OF bridges.f2sdram${n}_reset
                set_interface_property f2sdram${n}_reset PORT_NAME_MAP "f2sdram${n}_rst_n f2sdram${n}_rst_n"
            }
            
        }
    }
    hps_utils_add_instance_clk_reset clk_0 arm_a9_0 arm_a9
    hps_utils_add_instance_clk_reset clk_0 arm_a9_1 arm_a9
    if { $S2F_Width > 0 } {
        
        hps_utils_add_slave_interface arm_a9_0.altera_axi_master bridges.axi_h2f [hps_i_fpga_bridge_soc2fpga128_base]
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master bridges.axi_h2f [hps_i_fpga_bridge_soc2fpga128_base]

        add_interface h2f_axi_clock clock Input
        set_interface_property h2f_axi_clock EXPORT_OF bridges.h2f_axi_clock
        set_interface_property h2f_axi_clock PORT_NAME_MAP "h2f_axi_clk h2f_axi_clk"

        if {$S2F_Width > 3} { 
            add_interface h2f_axi_reset reset Input
            set_interface_property h2f_axi_reset EXPORT_OF bridges.h2f_axi_reset
            set_interface_property h2f_axi_reset PORT_NAME_MAP "h2f_axi_rst_n h2f_axi_rst_n"
        }
            
        add_interface h2f_axi_master axi master
        set_interface_property h2f_axi_master EXPORT_OF bridges.h2f
        set_interface_property h2f_axi_master PORT_NAME_MAP "h2f_AWID h2f_AWID h2f_AWADDR h2f_AWADDR h2f_AWLEN h2f_AWLEN h2f_AWSIZE h2f_AWSIZE h2f_AWBURST h2f_AWBURST h2f_AWLOCK h2f_AWLOCK h2f_AWCACHE h2f_AWCACHE h2f_AWPROT h2f_AWPROT h2f_AWVALID h2f_AWVALID h2f_AWREADY h2f_AWREADY h2f_WID h2f_WID h2f_WDATA h2f_WDATA h2f_WSTRB h2f_WSTRB h2f_WLAST h2f_WLAST h2f_WVALID h2f_WVALID h2f_WREADY h2f_WREADY h2f_BID h2f_BID h2f_BRESP h2f_BRESP h2f_BVALID h2f_BVALID h2f_BREADY h2f_BREADY h2f_ARID h2f_ARID h2f_ARADDR h2f_ARADDR h2f_ARLEN h2f_ARLEN h2f_ARSIZE h2f_ARSIZE h2f_ARBURST h2f_ARBURST h2f_ARLOCK h2f_ARLOCK h2f_ARCACHE h2f_ARCACHE h2f_ARPROT h2f_ARPROT h2f_ARVALID h2f_ARVALID h2f_ARREADY h2f_ARREADY h2f_RID h2f_RID h2f_RDATA h2f_RDATA h2f_RRESP h2f_RRESP h2f_RLAST h2f_RLAST h2f_RVALID h2f_RVALID h2f_RREADY h2f_RREADY h2f_AWUSER h2f_AWUSER h2f_ARUSER h2f_ARUSER"
    }

    if { $F2S_Width > 0 } {
        add_interface f2h_axi_clock clock Input
        set_interface_property f2h_axi_clock EXPORT_OF bridges.f2h_axi_clock
        set_interface_property f2h_axi_clock PORT_NAME_MAP "f2h_axi_clk f2h_axi_clk"

        if {$F2S_Width > 3} { 
            add_interface f2h_axi_reset reset Input
            set_interface_property f2h_axi_reset EXPORT_OF bridges.f2h_axi_reset
            set_interface_property f2h_axi_reset PORT_NAME_MAP "f2h_axi_rst_n f2h_axi_rst_n"
        }

        add_interface f2h_axi_slave axi slave
        set_interface_property f2h_axi_slave EXPORT_OF bridges.f2h
        set_interface_property f2h_axi_slave PORT_NAME_MAP "f2h_AWID f2h_AWID f2h_AWADDR f2h_AWADDR f2h_AWLEN f2h_AWLEN f2h_AWSIZE f2h_AWSIZE f2h_AWBURST f2h_AWBURST f2h_AWLOCK f2h_AWLOCK f2h_AWCACHE f2h_AWCACHE f2h_AWPROT f2h_AWPROT f2h_AWVALID f2h_AWVALID f2h_AWREADY f2h_AWREADY f2h_AWUSER f2h_AWUSER f2h_WID f2h_WID f2h_WDATA f2h_WDATA f2h_WSTRB f2h_WSTRB f2h_WLAST f2h_WLAST f2h_WVALID f2h_WVALID f2h_WREADY f2h_WREADY f2h_BID f2h_BID f2h_BRESP f2h_BRESP f2h_BVALID f2h_BVALID f2h_BREADY f2h_BREADY f2h_ARID f2h_ARID f2h_ARADDR f2h_ARADDR f2h_ARLEN f2h_ARLEN f2h_ARSIZE f2h_ARSIZE f2h_ARBURST f2h_ARBURST f2h_ARLOCK f2h_ARLOCK f2h_ARCACHE f2h_ARCACHE f2h_ARPROT f2h_ARPROT f2h_ARVALID f2h_ARVALID f2h_ARREADY f2h_ARREADY f2h_ARUSER f2h_ARUSER f2h_RID f2h_RID f2h_RDATA f2h_RDATA f2h_RRESP f2h_RRESP f2h_RLAST f2h_RLAST f2h_RVALID f2h_RVALID f2h_RREADY f2h_RREADY"
    }

    if { $h2f_lw_present } {
        hps_utils_add_slave_interface arm_a9_0.altera_axi_master bridges.axi_h2f_lw [hps_i_fpga_bridge_lwsoc2fpga_base]
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master bridges.axi_h2f_lw [hps_i_fpga_bridge_lwsoc2fpga_base]

        add_interface h2f_lw_axi_clock clock Input
        set_interface_property h2f_lw_axi_clock EXPORT_OF bridges.h2f_lw_axi_clock
        set_interface_property h2f_lw_axi_clock PORT_NAME_MAP "h2f_lw_axi_clk h2f_lw_axi_clk"

        if {$LWH2F_Enable > 1} { 
            add_interface h2f_lw_axi_reset reset Input
            set_interface_property h2f_lw_axi_reset EXPORT_OF bridges.h2f_lw_axi_reset
            set_interface_property h2f_lw_axi_reset PORT_NAME_MAP "h2f_lw_axi_rst_n h2f_lw_axi_rst_n"
        }
        
        add_interface h2f_lw_axi_master axi start
        set_interface_property h2f_lw_axi_master EXPORT_OF bridges.h2f_lw
        set_interface_property h2f_lw_axi_master PORT_NAME_MAP "h2f_lw_AWID h2f_lw_AWID h2f_lw_AWADDR h2f_lw_AWADDR h2f_lw_AWLEN h2f_lw_AWLEN h2f_lw_AWSIZE h2f_lw_AWSIZE h2f_lw_AWBURST h2f_lw_AWBURST h2f_lw_AWLOCK h2f_lw_AWLOCK h2f_lw_AWCACHE h2f_lw_AWCACHE h2f_lw_AWPROT h2f_lw_AWPROT h2f_lw_AWVALID h2f_lw_AWVALID h2f_lw_AWREADY h2f_lw_AWREADY h2f_lw_WID h2f_lw_WID h2f_lw_WDATA h2f_lw_WDATA h2f_lw_WSTRB h2f_lw_WSTRB h2f_lw_WLAST h2f_lw_WLAST h2f_lw_WVALID h2f_lw_WVALID h2f_lw_WREADY h2f_lw_WREADY h2f_lw_BID h2f_lw_BID h2f_lw_BRESP h2f_lw_BRESP h2f_lw_BVALID h2f_lw_BVALID h2f_lw_BREADY h2f_lw_BREADY h2f_lw_ARID h2f_lw_ARID h2f_lw_ARADDR h2f_lw_ARADDR h2f_lw_ARLEN h2f_lw_ARLEN h2f_lw_ARSIZE h2f_lw_ARSIZE h2f_lw_ARBURST h2f_lw_ARBURST h2f_lw_ARLOCK h2f_lw_ARLOCK h2f_lw_ARCACHE h2f_lw_ARCACHE h2f_lw_ARPROT h2f_lw_ARPROT h2f_lw_ARVALID h2f_lw_ARVALID h2f_lw_ARREADY h2f_lw_ARREADY h2f_lw_RID h2f_lw_RID h2f_lw_RDATA h2f_lw_RDATA h2f_lw_RRESP h2f_lw_RRESP h2f_lw_RLAST h2f_lw_RLAST h2f_lw_RVALID h2f_lw_RVALID h2f_lw_RREADY h2f_lw_RREADY h2f_lw_AWUSER h2f_lw_AWUSER h2f_lw_ARUSER h2f_lw_ARUSER"
    }

    clocks_logicalview_dtg

    hps_instantiate_arm_gic_0 $number_of_a9
    hps_instantiate_i_clk_mgr_clkmgr $number_of_a9
    hps_instantiate_mpu_reg_l2_MPUL2 $number_of_a9
    hps_instantiate_i_dma_DMASECURE $number_of_a9
    hps_instantiate_i_sys_mgr_core $number_of_a9
    hps_instantiate_i_rst_mgr_rstmgr $number_of_a9
    hps_instantiate_i_fpga_mgr_fpgamgrregs $number_of_a9
    hps_instantiate_clark_timer $number_of_a9
    hps_instantiate_i_timer_sp_0_timer $number_of_a9
    hps_instantiate_i_timer_sp_1_timer $number_of_a9
    hps_instantiate_i_timer_sys_0_timer $number_of_a9
    hps_instantiate_i_timer_sys_1_timer $number_of_a9
    hps_instantiate_i_watchdog_0_l4wd $number_of_a9
    hps_instantiate_i_watchdog_1_l4wd $number_of_a9
    hps_instantiate_i_gpio_0_gpio $number_of_a9
    hps_instantiate_i_gpio_1_gpio $number_of_a9
    hps_instantiate_i_gpio_2_gpio $number_of_a9
    hps_instantiate_i_uart_0_uart $number_of_a9 "UART0_PinMuxing"
    hps_instantiate_i_uart_1_uart $number_of_a9 "UART1_PinMuxing"
    hps_instantiate_i_emac_emac0 $number_of_a9 "EMAC0_PinMuxing"
    hps_instantiate_i_emac_emac1 $number_of_a9 "EMAC1_PinMuxing"
    hps_instantiate_i_emac_emac2 $number_of_a9 "EMAC2_PinMuxing"
    hps_instantiate_i_spim_0_spim $number_of_a9 "SPIM0_PinMuxing"
    hps_instantiate_i_spim_1_spim $number_of_a9 "SPIM1_PinMuxing"
    hps_instantiate_i_spis_0_spis $number_of_a9 "SPIS0_PinMuxing"
    hps_instantiate_i_spis_1_spis $number_of_a9 "SPIS1_PinMuxing"
    hps_instantiate_i_i2c_0_i2c $number_of_a9 "I2C0_PinMuxing"
    hps_instantiate_i_i2c_1_i2c $number_of_a9 "I2C1_PinMuxing"
    hps_instantiate_i_i2c_emac_0_i2c $number_of_a9 "I2CEMAC0_PinMuxing"
    hps_instantiate_i_i2c_emac_1_i2c $number_of_a9 "I2CEMAC1_PinMuxing"
    hps_instantiate_i_i2c_emac_2_i2c $number_of_a9 "I2CEMAC2_PinMuxing"
    #hps_instantiate_i_qspi_QSPIDATA $number_of_a9 "QSPI_PinMuxing"
    hps_instantiate_i_sdmmc_sdmmc $number_of_a9 "SDMMC_PinMuxing"
    hps_instantiate_i_nand_NANDDATA $number_of_a9 "NAND_PinMuxing"
    hps_instantiate_i_usbotg_0_globgrp $number_of_a9 "USB0_PinMuxing"
    hps_instantiate_i_usbotg_1_globgrp $number_of_a9 "USB1_PinMuxing"

    if { $F2S_Width > 0 } {
        hps_utils_add_slave_interface bridges.axi_f2h arm_gic_0.axi_slave0 [hps_arm_gic_0_base]
        hps_utils_add_slave_interface bridges.axi_f2h arm_gic_0.axi_slave1 [hps_arm_gic_0_base2]
        hps_utils_add_slave_interface bridges.axi_f2h mpu_reg_l2_MPUL2.axi_slave0 [hps_mpu_reg_l2_MPUL2_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_dma_DMASECURE.axi_slave0 [hps_i_dma_DMASECURE_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_sys_mgr_core.axi_slave0 [hps_i_sys_mgr_core_base]
        # This connection already exists?
        #hps_utils_add_slave_interface bridges.axi_f2h clark_clkmgr.axi_slave0 [hps_i_clk_mgr_clkmgr_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_rst_mgr_rstmgr.axi_slave0 [hps_i_rst_mgr_rstmgr_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_fpga_mgr_fpgamgrregs.axi_slave0 [hps_i_fpga_mgr_fpgamgrregs_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_fpga_mgr_fpgamgrregs.axi_slave1 [hps_i_fpga_mgr_fpgamgrdata_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_uart_0_uart.axi_slave0 [hps_i_uart_0_uart_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_uart_1_uart.axi_slave0 [hps_i_uart_1_uart_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_timer_sp_0_timer.axi_slave0 [hps_i_timer_sp_0_timer_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_timer_sp_1_timer.axi_slave0 [hps_i_timer_sp_1_timer_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_timer_sys_0_timer.axi_slave0 [hps_i_timer_sys_0_timer_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_timer_sys_1_timer.axi_slave0 [hps_i_timer_sys_1_timer_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_watchdog_0_l4wd.axi_slave0 [hps_i_watchdog_0_l4wd_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_watchdog_1_l4wd.axi_slave0 [hps_i_watchdog_1_l4wd_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_gpio_0_gpio.axi_slave0 [hps_i_gpio_0_gpio_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_gpio_1_gpio.axi_slave0 [hps_i_gpio_1_gpio_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_gpio_2_gpio.axi_slave0 [hps_i_gpio_2_gpio_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_i2c_0_i2c.axi_slave0 [hps_i_i2c_0_i2c_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_i2c_1_i2c.axi_slave0 [hps_i_i2c_1_i2c_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_i2c_emac_0_i2c.axi_slave0 [hps_i_i2c_emac_0_i2c_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_i2c_emac_1_i2c.axi_slave0 [hps_i_i2c_emac_1_i2c_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_i2c_emac_2_i2c.axi_slave0 [hps_i_i2c_emac_2_i2c_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_nand_NANDDATA.axi_slave0 [hps_i_nand_NANDDATA_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_nand_NANDDATA.axi_slave1 [hps_i_nand_config_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_spim_0_spim.axi_slave0 [hps_i_spim_0_spim_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_spim_1_spim.axi_slave0 [hps_i_spim_1_spim_base]
        #hps_utils_add_slave_interface bridges.axi_f2h i_qspi_QSPIDATA.axi_slave0 [hps_i_qspi_qspiregs_base]
        #hps_utils_add_slave_interface bridges.axi_f2h i_qspi_QSPIDATA.axi_slave1 [hps_i_qspi_QSPIDATA_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_sdmmc_sdmmc.axi_slave0 [hps_i_sdmmc_sdmmc_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_usbotg_0_globgrp.axi_slave0 [hps_i_usbotg_0_globgrp_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_usbotg_1_globgrp.axi_slave0 [hps_i_usbotg_1_globgrp_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_emac_emac0.axi_slave0 [hps_i_emac_emac0_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_emac_emac1.axi_slave0 [hps_i_emac_emac1_base]
        hps_utils_add_slave_interface bridges.axi_f2h i_emac_emac2.axi_slave0 [hps_i_emac_emac2_base]
        #Do we need these in Clark?
        #hps_utils_add_slave_interface bridges.axi_f2h axi_ocram.axi_slave0 {0xffff0000}
        #hps_utils_add_slave_interface bridges.axi_f2h axi_sdram.axi_slave0 [hps_sdram_base]
        #hps_utils_add_slave_interface bridges.axi_f2h timer.axi_slave0 {0xfffec600}
        #hps_utils_add_slave_interface bridges.axi_f2h l3regs.axi_slave0 [hps_l3regs_base]
        #hps_utils_add_slave_interface bridges.axi_f2h sdrctl.axi_slave0 [hps_sdrctl_base]
    }

    ##### F2H #####
    if [param_bool_is_enabled F2SINTERRUPT_Enable] {
        set any_interrupt_enabled 1
        set iname "f2h_irq"
        set pname "f2h_irq"
            add_interface      "${iname}0"  interrupt receiver
            set_interface_property f2h_irq0 EXPORT_OF arm_gic_0.f2h_irq_0_irq_rx_offset_19
            set_interface_property f2h_irq0 PORT_NAME_MAP "f2h_irq_p0 irq_siq_19"

            add_interface      "${iname}1"  interrupt receiver
            set_interface_property f2h_irq1 EXPORT_OF arm_gic_0.f2h_irq_32_irq_rx_offset_51
            set_interface_property f2h_irq1 PORT_NAME_MAP "f2h_irq_p1 irq_siq_51"
    }
}

set_module_property OPAQUE_ADDRESS_MAP false
set_module_property STRUCTURAL_COMPOSITION_CALLBACK compose_logicalview
proc compose_logicalview {} {

    fpga_interfaces::init

    hps_io::init
    validate
    elab 1

    update_hps_to_fpga_clock_frequency_parameters


    fpga_interfaces::serialize fpga_interfaces_data

    add_instance fpga_interfaces altera_stratix10_interface_generator 
    set_instance_parameter_value fpga_interfaces interfaceDefinition [array get fpga_interfaces_data]

    expose_border fpga_interfaces $fpga_interfaces_data(interfaces)

    declare_cmsis_svd $fpga_interfaces_data(interfaces)

    # io pins
    hps_io::internal::set_property GENERATE_ISW 1
    funset hps_io_border
    hps_io::serialize hps_io_border

    clear_array temp_array
    array set temp_array $hps_io_border(instances)

    add_instance hps_io altera_stratix10_hps_io 
                        
    set_instance_parameter_value hps_io border_description [array get hps_io_border]
    
    expose_border hps_io $hps_io_border(interfaces)

    set_instance_parameter_value hps_io hps_parameter_map [construct_hps_parameter_map]

    if [hps_io::is_used] {
        set_interface_assignment hps_io "qsys.ui.export_name" hps_io
    }
    # Debugging message
    #send_message debug "list_peripheral_names:[list_peripheral_names]"
    #send_message debug "instance= fpga_interfaces param= interfaceDefinition value = [array get fpga_interfaces_data]"
    #send_message debug "instance= hps_io  param= border_description  value = [array get hps_io_border]"

    #set hps_param        [construct_hps_parameter_map]
    #foreach { param_key param_value } $hps_param {
    #  send_message debug "instance= hps_io  param= hps_parameter_map   parameter= $param_key value= $param_value"
    #}

    logicalview_dtg
    
    run_self_tests 
    
    # call quartus_locations_query.
}

proc quartus_locations_query. {} {
    ## Pin Mux GUI report
    
    array set pin_to_ball_name [::pin_mux_db::get_pin_to_ball_name_table [get_device] ]
    set p [array get pin_to_ball_name]
    send_message debug "Pin name to ball name array: ${p}"
    set_parameter_value PIN_TO_BALL_MAP ${p}
    
    array set pin_to_pall_map {}
    foreach {pin ballname} $p {
        set pin_to_pall_map($pin)  $ballname
    }

    set msg "<tr><td><b>Dedicated IO</b></td><td><b>Pin location</b></td>"
    set msg "$msg<td><b>Quadrant 1</b></td><td><b>Pin location</b></td>"
    set msg "$msg<td><b>Quadrant 2</b></td><td><b>Pin location</b></td>"
    set msg "$msg<td><b>Quadrant 3</b></td><td><b>Pin location</b></td>"
    set msg "$msg<td><b>Quadrant 4</b></td><td><b>Pin location</b></td></tr>"
    
    for {set i 1} {$i <= 12} {incr i} {
        
        set d [ expr {$i + 3 }]
        set pin_d "D_$d"
        
        #set msg "$msg<tr><td>$d</td><td>$pin_to_pall_map($pin_d)</td>"
        set msg "$msg<tr><td>$d</td><td>$pin_d</td>"
        
        for {set j 1} {$j <= 4} {incr j} {
            set pin "Q${j}_${i}"
            #set msg "$msg<td>$pin</td><td>$pin_to_pall_map($pin)</td>"
            set msg "$msg<td>$pin</td><td>$pin</td>"
        }
        
        set msg "$msg</tr>"
    }
    set d 16 
    set pin_d "D_$d"
    #set msg "$msg<tr><td>$d</td><td>$pin_to_pall_map($pin_d)</td><td></td><td></td><td></td><td></td></tr>"
    
    set d 17 
    set pin_d "D_$d"
    #set msg "$msg<tr><td>$d</td><td>$pin_to_pall_map($pin_d)</td><td></td><td></td><td></td><td></td></tr>"

    set html_all "<html><table border=\"0\" width=\"100%\"><font size=3>$msg</table></html>"
    set_display_item_property PIN_REPORT TEXT $html_all
}




proc declare_cmsis_svd {interfaces_str} {
    array set interfaces $interfaces_str
    set interface_names $interfaces([ORDERED_NAMES])

    set h2f_exists   0
    set lwh2f_exists 0
    foreach interface_name $interface_names {
        if {[string compare $interface_name "h2f_axi_master"] == 0} {
            set h2f_exists   1
        } elseif {[string compare $interface_name "h2f_lw_axi_master"] == 0} {
            set lwh2f_exists 1
        }
    }

    set svd_path [file join $::env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 altera_hps_stratix_10 altera_hps.svd]
    set address_group hps
    set declared_svd_file 0

    if {$h2f_exists} {
        if {!$declared_svd_file} {
            set_interface_property h2f_axi_master CMSIS_SVD_FILE $svd_path
            set declared_svd_file 1
        }
        set_interface_property h2f_axi_master SVD_ADDRESS_GROUP  $address_group
        set_interface_property h2f_axi_master SVD_ADDRESS_OFFSET 0xC0000000
    }
    if {$lwh2f_exists} {
        if {!$declared_svd_file} {
            set_interface_property h2f_lw_axi_master CMSIS_SVD_FILE $svd_path
            set declared_svd_file 1
        }
        set_interface_property h2f_lw_axi_master SVD_ADDRESS_GROUP  $address_group
        set_interface_property h2f_lw_axi_master SVD_ADDRESS_OFFSET 0xFF200000
    }
    if {!$declared_svd_file} {
        set_module_assignment "cmsis.svd.file"   $svd_path
        set_module_assignment "cmsis.svd.suffix" $address_group
    }
}


######################
##### Validation #####
######################

proc validate {} {
    set device_family [get_parameter_value hps_device_family]

    set java_error [get_parameter_value JAVA_ERROR_MSG]
    set java_warning [get_parameter_value JAVA_WARNING_MSG]
    
    
    if {$java_error != ""} {
        foreach line $java_error {
            send_message error $line
        }
    }

    if {$java_warning != ""} {
        foreach line $java_warning {
            send_message warning $line
        }
    }

    ensure_device_data $device_family
    update_table_derived_parameters
    validate_F2SDRAM
    validate_TEST
    
    validate_clocks

}



proc validate_TEST {} {
    set ini [get_parameter_value quartus_ini_hps_ip_enable_test_interface]
    set_parameter_property TEST_Enable visible $ini
}



proc update_table_derived_parameters {} {
    update_dma_peripheral_ids
}


proc update_dma_peripheral_ids {} {
    set periph_id_list {0 1 2 3 4 5 6 7}
    set_parameter_value DMA_PeriphId_DERIVED $periph_id_list
}

# compare returned string in Boolean Parameter to integer value. to be used in expression(if elseif)
proc param_bool_is_enabled {parameter} {
    if { [string compare -nocase [get_parameter_value $parameter] "true" ] == 0 } {
        return 1
    } else { return 0 }
}

proc validate_F2SDRAM {} {


    foreach n { 0 1 2 } {
        set F2SDRAM_Width   [ get_parameter_value F2SDRAM${n}_Width ]
    
        if {$F2SDRAM_Width == 1 || $F2SDRAM_Width == 4 } {
            send_message warning "Setting the slave port width of interface <b>f2h_sdram${n}</b> to 32-bit results in bandwidth under-utilization.  Altera recommends you set the interface data width to 64-bit or greater."
        }
    }
}

#####################################################################
#
# Gets valid modes for a peripheral with a given pin muxing option.
# Parameters: * peripheral_ref: name of an array pointing to the
#                               Peripheral HPS I/O Data
#
proc get_valid_modes {peripheral_name pin_muxing_option peripheral_ref fpga_available} {
#####################################################################
    upvar 1 $peripheral_ref peripheral

    if {[info exists peripheral(pin_sets)]} {
        array set pin_sets $peripheral(pin_sets)
    }

    if {[info exists pin_sets($pin_muxing_option)]} {
        array set pin_set $pin_sets($pin_muxing_option)
        set pin_set_modes $pin_set(valid_modes)
        set valid_modes $pin_set_modes
    } elseif {$fpga_available && [string compare $pin_muxing_option [FPGA_MUX_VALUE]] == 0} {
        set valid_modes [list "Full"]
    } else {
        set valid_modes [list [NA_MODE_VALUE]]
    }
    return [lsort -ascii -increasing $valid_modes]
}

proc is_peripheral_low_speed_serial_interface {peripheral_name} {
    if {[string match -nocase "i2c*"  $peripheral_name] ||
        [string match -nocase "can*"  $peripheral_name] ||
        [string match -nocase "spi*"  $peripheral_name] ||
        [string match -nocase "uart*" $peripheral_name]
    } {
        return 1
    }
    return 0
}

proc peripheral_to_wys_atom_name { peripheral} {
    set generic_atom_name [hps_io_peripheral_to_generic_atom_name $peripheral]
    set wys_atom_name "fourteennm_${generic_atom_name}"

    return $wys_atom_name
}


######################
##### Elaboration #####
######################

proc elab {logical_view} {

    set device_family [get_parameter_value hps_device_family]

    # TODO: enabme these:
    #elab_CLOCKS_RESETS            $device_family

    elab_MPU_EVENTS_STANDBY       $device_family
    #elab_DEBUG_APB                $device_family
    elab_STM                      $device_family
    elab_CTI                      $device_family
    elab_GP                       $device_family
    elab_EMIF_INTERFACE           $device_family

    #if {$logical_view == 0} {
    #    elab_F2H                  $device_family
    #    elab_LWH2F                $device_family
    #    elab_H2F                  $device_family
    #    set base_device  [::pin_mux_db::verify_base_device [get_device] ]
    #    elab_F2SDRAM              $device_family
    #}

    elab_DMA                      $device_family
    elab_INTERRUPTS               $device_family $logical_view
    elab_EMAC_SWITCH              $device_family
    elab_TEST                     $device_family

    # Handle Special Case EMAC signal... ptp_ref_clk
    set emac_fpga_enabled false
    for {set i 0} {$i < 3} {incr i} {
        set emac_pin_mux_value [get_parameter_value EMAC${i}_PinMuxing]
        if {[string compare $emac_pin_mux_value [FPGA_MUX_VALUE]] == 0} {
            set emac_fpga_enabled true
        }
    }
    
    if {$emac_fpga_enabled } {
        set instance_name clocks_resets
        fpga_interfaces::add_interface      emac_ptp_ref_clock                    clock  Input
        fpga_interfaces::add_interface_port emac_ptp_ref_clock  emac_ptp_ref_clk  clk    Input  1     $instance_name ptp_ref_clk
    }

    
    elab_FPGA_Peripheral_Signals  $device_family
    elab_GPIO                     $device_family
    
}

proc elab_MPU_EVENTS_STANDBY {device_family} {
    set instance_name  mpu_events
    set atom_name      hps_interface_mpu_event_standby
    set wys_atom_name  fourteennm_hps_interface_mpu_event_standby
    set location       [locations::get_fpga_location $instance_name $atom_name]

    if [param_bool_is_enabled MPU_EVENTS_Enable] {
        set iface_name "h2f_mpu_events"
        set z          "h2f_mpu_"
        fpga_interfaces::add_interface       $iface_name conduit Input
        fpga_interfaces::add_interface_port  $iface_name ${z}eventi      eventi      Input  1  $instance_name eventi
        fpga_interfaces::add_interface_port  $iface_name ${z}evento      evento      Output 1  $instance_name evento
        fpga_interfaces::add_interface_port  $iface_name ${z}standbywfe  standbywfe  Output 2  $instance_name standbywfe
        fpga_interfaces::add_interface_port  $iface_name ${z}standbywfi  standbywfi  Output 2  $instance_name standbywfi

        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}

proc elab_DEBUG_APB {device_family} {
    set instance_name  debug_apb
    set atom_name      hps_interface_dbg_apb
    set wys_atom_name  fourteennm_hps_interface_dbg_apb
    set location       [locations::get_fpga_location $instance_name $atom_name]

    fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location

    if [param_bool_is_enabled DEBUG_APB_Enable] {
        set clock_name "h2f_debug_apb_clock"
        fpga_interfaces::add_interface           $clock_name clock Input
        fpga_interfaces::add_interface_port      $clock_name "h2f_dbg_apb_clk"  clk Input 1 $instance_name F2S_PCLKDBG

        set reset_name "h2f_debug_apb_reset"
        fpga_interfaces::add_interface           $reset_name reset Output
        fpga_interfaces::add_interface_port      $reset_name "h2f_dbg_apb_rst_n"  reset_n Output 1 $instance_name S2F_PRESETDBGN
        fpga_interfaces::set_interface_property  $reset_name associatedClock $clock_name
        fpga_interfaces::set_interface_property  $reset_name associatedResetSinks none

        set iface_name "h2f_debug_apb"
        set z          "h2f_dbg_apb_"
        fpga_interfaces::add_interface               $iface_name apb master
        fpga_interfaces::add_interface_port  $iface_name "${z}PADDR"           paddr           Output 18
        fpga_interfaces::set_port_fragments  $iface_name "${z}PADDR"          "${instance_name}:S2F_PADDRDBG(19:2)"
        fpga_interfaces::add_interface_port  $iface_name "${z}PADDR31"         paddr31         Output 1  $instance_name S2F_PADDRDBG31
        fpga_interfaces::add_interface_port  $iface_name "${z}PENABLE"         penable         Output 1  $instance_name S2F_PENABLEDBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PRDATA"          prdata          Input  32 $instance_name F2S_PRDATADBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PREADY"          pready          Input  1  $instance_name F2S_PREADYDBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PSEL"            psel            Output 1  $instance_name S2F_PSELDBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PSLVERR"         pslverr         Input  1  $instance_name F2S_PSLVERRDBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PWDATA"          pwdata          Output 32 $instance_name S2F_PWDATADBG
        fpga_interfaces::add_interface_port  $iface_name "${z}PWRITE"          pwrite          Output 1  $instance_name S2F_PWRITEDBG
        fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
        fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name

        set iface_name "h2f_debug_apb_sideband"
        set z          "h2f_dbg_apb_"
        fpga_interfaces::add_interface       $iface_name conduit Input
        fpga_interfaces::add_interface_port  $iface_name "${z}PCLKEN"          pclken          Input  1  $instance_name F2S_PCLKENDBG
        fpga_interfaces::add_interface_port  $iface_name "${z}DBG_APB_DISABLE" dbg_apb_disable Input  1  $instance_name F2S_DBGAPB_DISABLE
        fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
        fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name

    } else {
        # Tie low when FPGA debug apb not being used
        fpga_interfaces::set_instance_port_termination ${instance_name} "F2S_PCLKENDBG" 1 0 0:0 0
        fpga_interfaces::set_instance_port_termination ${instance_name} "F2S_DBGAPB_DISABLE" 1 0 0:0 0
    }
}

proc elab_STM {device_family} {
    set instance_name  stm_event
    set atom_name      hps_interface_stm_event
    set wys_atom_name  fourteennm_hps_interface_stm_event
    set location       [locations::get_fpga_location $instance_name $atom_name]

    if [param_bool_is_enabled STM_Enable] {
        fpga_interfaces::add_interface       f2h_stm_hw_events conduit Input
        fpga_interfaces::add_interface_port  f2h_stm_hw_events f2h_stm_hwevents stm_hwevents Input 28  $instance_name f2s_stm_event

        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}

proc elab_CTI {device_family} {
    set instance_name  cross_trigger_interface
    set atom_name      hps_interface_cross_trigger
    set wys_atom_name  fourteennm_hps_interface_cross_trigger
    set location       [locations::get_fpga_location $instance_name $atom_name]

    if [param_bool_is_enabled CTI_Enable] {
        set iface_name "h2f_cti"
        set z          "h2f_cti_"
        fpga_interfaces::add_interface          $iface_name conduit Input
        fpga_interfaces::add_interface_port     $iface_name ${z}trig_in         trig_in         Input  8 $instance_name trigin
        fpga_interfaces::add_interface_port     $iface_name ${z}trig_out_ack    trig_out_ack    Input  8 $instance_name trigoutack
        fpga_interfaces::add_interface_port     $iface_name ${z}trig_out        trig_out        Output 8 $instance_name trigout
        fpga_interfaces::add_interface_port     $iface_name ${z}trig_in_ack     trig_in_ack     Output 8 $instance_name triginack

        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}


proc elab_EMIF_INTERFACE {device_family} {
    if [param_bool_is_enabled EMIF_CONDUIT_Enable] {
        set instance_name  emif_interface
        set atom_name      hps_interface_ddr
        set wys_atom_name  a10_hps_emif_interface
        set location       [locations::get_fpga_location $instance_name $atom_name]
        set iface_name "emif"
        set z          "emif_"
        fpga_interfaces::add_interface      $iface_name conduit Output
        fpga_interfaces::add_interface_port $iface_name ${z}emif_to_hps      emif_to_hps      Input   4096 $instance_name  emif_to_hps
        fpga_interfaces::add_interface_port $iface_name ${z}hps_to_emif      hps_to_emif      Output  4096 $instance_name  hps_to_emif
        
        #someting
        fpga_interfaces::add_interface_port $iface_name ${z}emif_to_gp      emif_to_gp      Input   1 
        fpga_interfaces::add_interface_port $iface_name ${z}gp_to_emif      gp_to_emif      Output  2 
        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}


proc elab_GP {device_family} {
    set instance_name  h2f_gp
    set atom_name      hps_interface_mpu_general_purpose
    set wys_atom_name  fourteennm_hps_interface_mpu_general_purpose
    set location       [locations::get_fpga_location $instance_name $atom_name]

    if [param_bool_is_enabled GP_Enable] {
        set iface_name "h2f_gp"
        set z          "h2f_gp_"
        fpga_interfaces::add_interface       $iface_name  conduit Input
        
        fpga_interfaces::add_interface_port  $iface_name  ${z}in   gp_in  Input  32  $instance_name f2s_gp
        fpga_interfaces::add_interface_port  $iface_name  ${z}out  gp_out Output 32  $instance_name s2f_gp
        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    } 
}



proc elab_CLOCKS_RESETS {device_family} {
    set instance_name  clocks_resets
    set atom_name      hps_interface_clocks_resets
    set wys_atom_name  fourteennm_hps_interface_clocks_resets
    set location       [locations::get_fpga_location $instance_name $atom_name]

    fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location

    # h2f_reset using s2f_clk[3] - temporary tie to h2f_user3_clk, should change the name to proper reset name
    fpga_interfaces::add_interface          h2f_reset             reset    Output
    fpga_interfaces::add_interface_port     h2f_reset  h2f_rst_n  reset_n  Output  1     $instance_name s2f_user3_clk
    fpga_interfaces::set_interface_property h2f_reset  synchronousEdges  none
    fpga_interfaces::set_interface_property h2f_reset associatedResetSinks none

    # h2f_reset using s2f_clk[2] - temporary tie to h2f_user2_clk, should change the name to proper reset name
    if [param_bool_is_enabled H2F_COLD_RST_Enable] {
        fpga_interfaces::add_interface          h2f_cold_reset      reset               Output
        fpga_interfaces::add_interface_port     h2f_cold_reset      h2f_cold_rst_n      reset_n  Output  1     $instance_name  s2f_user2_clk
        fpga_interfaces::set_interface_property h2f_cold_reset      synchronousEdges    none
        fpga_interfaces::set_interface_property h2f_cold_reset      associatedResetSinks none
    }

    if [param_bool_is_enabled F2H_COLD_RST_Enable] {
        fpga_interfaces::add_interface          f2h_cold_reset_req  reset               Input
        fpga_interfaces::add_interface_port     f2h_cold_reset_req  f2h_cold_rst_req_n  reset_n  Input   1     $instance_name  f2s_cold_rst_req_n
        fpga_interfaces::set_interface_property f2h_cold_reset_req  synchronousEdges    none
        fpga_interfaces::set_interface_property h2f_reset associatedResetSinks f2h_cold_reset_req
        if [param_bool_is_enabled H2F_COLD_RST_Enable] {
            fpga_interfaces::set_interface_property h2f_cold_reset      associatedResetSinks f2h_cold_reset_req
        }
    } else {
        fpga_interfaces::set_instance_port_termination ${instance_name} "f2s_cold_rst_req_n" 1 1 0:0 1
    }

    if [param_bool_is_enabled H2F_PENDING_RST_Enable] {
        fpga_interfaces::add_interface          h2f_warm_reset_handshake conduit               Output
        fpga_interfaces::add_interface_port     h2f_warm_reset_handshake h2f_pending_rst_req_n h2f_pending_rst_req_n  Output  1     $instance_name  s2f_pending_rst_req
        fpga_interfaces::add_interface_port     h2f_warm_reset_handshake f2h_pending_rst_ack_n f2h_pending_rst_ack_n  Input   1     $instance_name  f2s_pending_rst_ack
    } else {
        fpga_interfaces::set_instance_port_termination ${instance_name} "f2s_pending_rst_ack" 1 1 0:0 1
    }

    if [param_bool_is_enabled F2H_DBG_RST_Enable] {
        fpga_interfaces::add_interface          f2h_debug_reset_req                     reset    Input
        fpga_interfaces::add_interface_port     f2h_debug_reset_req  f2h_dbg_rst_req_n  reset_n  Input  1     $instance_name  f2s_dbg_rst_req_n
        fpga_interfaces::set_interface_property f2h_debug_reset_req  synchronousEdges   none
    } else {
        fpga_interfaces::set_instance_port_termination ${instance_name} "f2s_dbg_rst_req_n" 1 1 0:0 1
    }

    if [param_bool_is_enabled F2H_WARM_RST_Enable] {
        fpga_interfaces::add_interface          f2h_warm_reset_req                      reset    Input
        fpga_interfaces::add_interface_port     f2h_warm_reset_req  f2h_warm_rst_req_n  reset_n  Input  1     $instance_name  f2s_warm_rst_req_n
        fpga_interfaces::set_interface_property f2h_warm_reset_req  synchronousEdges    none

        if [param_bool_is_enabled F2H_COLD_RST_Enable] {
            fpga_interfaces::set_interface_property h2f_reset associatedResetSinks {f2h_warm_reset_req f2h_cold_reset_req}
        } else {
            fpga_interfaces::set_interface_property h2f_reset associatedResetSinks {f2h_warm_reset_req}
        }
    } else {
        fpga_interfaces::set_instance_port_termination ${instance_name} "f2s_warm_rst_req_n" 1 1 0:0 1
    }

    if [param_bool_is_enabled F2H_FREE_CLK_Enable] {
        fpga_interfaces::add_interface          f2h_free_clock                     clock    Input
        fpga_interfaces::add_interface_port     f2h_free_clock  f2h_free_clk       clk      Input  1     $instance_name  f2s_free_clk
    } else {
        fpga_interfaces::set_instance_port_termination ${instance_name} "f2s_free_clk" 1 1 0:0 0
    }

    if [param_bool_is_enabled H2F_USER0_CLK_Enable] {
        fpga_interfaces::add_interface          h2f_user0_clock                 clock  Output
        fpga_interfaces::add_interface_port     h2f_user0_clock  s2f_user0_clk  clk    Output  1     $instance_name
        set frequency [get_parameter_value H2F_USER0_CLK_FREQ]
        set frequency [expr {$frequency * [MHZ_TO_HZ]}]
        fpga_interfaces::set_interface_property h2f_user0_clock clockRateKnown true
        fpga_interfaces::set_interface_property h2f_user0_clock clockRate      $frequency
        add_clock_constraint_if_valid $frequency "*|fpga_interfaces|s2f_user0_clk*"
    }


    if [param_bool_is_enabled H2F_USER1_CLK_Enable] {
        fpga_interfaces::add_interface          h2f_user1_clock                 clock  Output
        fpga_interfaces::add_interface_port     h2f_user1_clock  s2f_user1_clk  clk    Output  1     $instance_name
        set frequency [get_parameter_value H2F_USER1_CLK_FREQ]
        set frequency [expr {$frequency * [MHZ_TO_HZ]}]
        fpga_interfaces::set_interface_property h2f_user1_clock clockRateKnown true
        fpga_interfaces::set_interface_property h2f_user1_clock clockRate      $frequency
        add_clock_constraint_if_valid $frequency "*|fpga_interfaces|s2f_user1_clk*"
    }
    
    if [param_bool_is_enabled JTAG_Enable] {
        fpga_interfaces::add_interface_port     "h2f_jtag" h2f_jtag_tck    s2f_fpga_scanman_tck  Output  1  $instance_name  s2f_fpga_scanman_tck
    }
    
}

# Elaborate peripheral request interfaces for the fpga and
# the clk/reset per pair
proc elab_DMA {device_family} {
    set instance_name  dma
    set atom_name      hps_interface_dma
    set wys_atom_name  fourteennm_hps_interface_dma
    set location       [locations::get_fpga_location $instance_name $atom_name]

    set can_message 0
    set available_list [get_parameter_value DMA_Enable]
    if {[llength $available_list] > 0} {
        set dma_used 0
        set periph_id 0
        foreach entry $available_list {
            if {[string compare $entry "Yes" ] == 0} {
                elab_DMA_entry $periph_id $instance_name
                set dma_used 1
                if {$periph_id >= 4} {
                    set can_message 1
                }
            }
            incr periph_id
        }
        if $dma_used {
            fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
        }

    }
}

proc elab_DMA_make_conduit_name {periph_id} {
    return "f2h_dma${periph_id}"
}

proc elab_DMA_entry {periph_id instance_name} {
    set iname [elab_DMA_make_conduit_name $periph_id]
    set atom_signal_prefix "FPGA${periph_id}"
    fpga_interfaces::add_interface      $iname conduit Output
    fpga_interfaces::add_interface_port $iname "${iname}_req"    "dma_req"    Input  1  $instance_name  ${atom_signal_prefix}_DMA_REQ
    fpga_interfaces::add_interface_port $iname "${iname}_single" "dma_single" Input  1  $instance_name  ${atom_signal_prefix}_DMA_SINGLE
    fpga_interfaces::add_interface_port $iname "${iname}_ack"    "dma_ack"    Output 1  $instance_name  ${atom_signal_prefix}_DMA_PERI_ACK
}

proc elab_INTERRUPTS {device_family logical_view} {
    set instance_name  interrupts
    set atom_name      hps_interface_interrupts
    set wys_atom_name  fourteennm_hps_interface_interrupts
    set location       [locations::get_fpga_location $instance_name $atom_name]
    set any_interrupt_enabled 0

    ##### F2H #####
    if [param_bool_is_enabled F2SINTERRUPT_Enable] {
        set any_interrupt_enabled 1
        set iname "f2h_irq"
        set pname "f2h_irq"
        if { $logical_view == 0 } {
            fpga_interfaces::add_interface      "${iname}0"  interrupt receiver
            fpga_interfaces::add_interface_port "${iname}0" "${pname}_p0"    irq Input 32    $instance_name  f2s_fpga_irq
            fpga_interfaces::set_port_fragments "${iname}0" "${pname}_p0" "${instance_name}:f2s_fpga_irq(31:0)"

            fpga_interfaces::add_interface      "${iname}1"  interrupt receiver
            fpga_interfaces::add_interface_port "${iname}1" "${pname}_p1"    irq Input 32    $instance_name  f2s_fpga_irq
            fpga_interfaces::set_port_fragments "${iname}1" "${pname}_p1" "${instance_name}:f2s_fpga_irq(63:32)"
        }
    }

    ##### H2F #####
    load_h2f_interrupt_table\
        functions_by_group width_by_function inverted_by_function

    set interrupts_to_hide [list "EMAC0" "EMAC1" "EMAC2"  "NAND"  "SDMMC" \
                "I2CEMAC0" "I2CEMAC1" "I2CEMAC2" "USB0" "USB1" "UART0" "UART1" \
                "SPIM0"       "SPIM1" "SPIS0" "SPIS1" "I2C0"   "I2C1"]

    set interrupt_groups [list_h2f_interrupt_groups]
    foreach group $interrupt_groups {
        set parameter "S2FINTERRUPT_${group}_Enable"
        set enabled [param_bool_is_enabled $parameter]

        
        if {[lsearch $interrupts_to_hide $group] != -1} {
            if {[get_parameter_value "${group}_PinMuxing"] == [UNUSED_MUX_VALUE] } {
                set_parameter_property $parameter enabled      false
            } else {
                set_parameter_property $parameter enabled      true
            }
        }
        
        
        if {!$enabled} {
            continue
        }
        set any_interrupt_enabled 1

        foreach function $functions_by_group($group) {
            set width 1
            if {[info exists width_by_function($function)]} {
                set width $width_by_function($function)
            }

            set suffix ""
            set inverted [info exists inverted_by_function($function)]
            if {$inverted} {
                set suffix "_n"
            }

            set prefix_atom    "s2f_${function}_"
            
            set prefix    "h2f_${function}_"
            set interface "${prefix}interrupt"

            if {$function eq "dma_abort"} {
                set port "s2f_dma_irq_abort"
            } else {
                set port "${prefix_atom}irq"
            }

            if {$width > 1} { ;# for buses, use index in interface/port names
                set port "$port${suffix}"
                for {set i 0} {$i < $width} {incr i} {
                  fpga_interfaces::add_interface      "${interface}${i}"  interrupt   sender
                  fpga_interfaces::add_interface_port "${interface}${i}"  "${port}_p${i}"   irq   Output  1  $instance_name $port
                  fpga_interfaces::set_port_fragments "${interface}${i}"  "${port}_p${i}"   "${instance_name}:${port}(${i}:${i})"
                }
            } else {
                set port "$port${suffix}"
                fpga_interfaces::add_interface\
                    $interface interrupt sender
                fpga_interfaces::add_interface_port\
                    $interface $port irq Output 1  $instance_name $port
            }
        }
    }

    if {$any_interrupt_enabled}  {
        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}


proc elab_EMAC_SWITCH {device_family} {
    set atom_name      hps_interface_emac_switch
    set wys_atom_name  fourteennm_hps_interface_emac_switch

    for { set i 0 } { $i < 3 } { incr i } {
        if [param_bool_is_enabled EMAC${i}_SWITCH_Enable] {
            set instance_name peripheral_emac_switch${i}
            set iface_name "emac_switch${i}"
            set z "emac_switch${i}"
            fpga_interfaces::add_interface       ${iface_name}_clock               clock  Input
            fpga_interfaces::add_interface_port  ${iface_name}_clock  ${z}_AP_CLK  clk    Input  1     $instance_name  AP_CLK

            fpga_interfaces::add_interface       $iface_name  conduit Input
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_ACK_I           ari_ack            Input   1   $instance_name  ARI_ACK_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_FRAMEFLUSH_I    ari_frameflush     Input   1   $instance_name  ARI_FRAMEFLUSH_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_ACK_I           ati_ack            Input   1   $instance_name  ATI_ACK_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_DISCRS_I        ati_discrs         Input   1   $instance_name  ATI_DISCRC_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_DISPAD_I        ati_dispad         Input   1   $instance_name  ATI_DISPAD_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_ENA_TIMESTAMP_I ati_ena_timestamp  Input   1   $instance_name  ATI_ENA_TIMESTAMP_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_EOF_I           ati_eof            Input   1   $instance_name  ATI_EOF_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_SOF_I           ati_sof            Input   1   $instance_name  ATI_SOF_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_VAL_I           ati_val            Input   1   $instance_name  ATI_VAL_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_PBL_I           ari_pbl            Input   9   $instance_name  ARI_PBL_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_BE_I            ati_be             Input   2   $instance_name  ATI_BE_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_CHKSUM_CTRL_I   ati_chksum_ctrl    Input   2   $instance_name  ATI_CHKSUM_CTRL_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_DATA_I          ati_data           Input   32  $instance_name  ATI_DATA_I
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_PBL_I           ati_pbl            Input   9   $instance_name  ATI_PBL_I

            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_EOF_O           ari_eof            Output  1   $instance_name  ARI_EOF_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_RX_WATERMARK_O  ari_rx_watermark   Output  1   $instance_name  ARI_RX_WATERMARK_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_RXSTATUS_VAL_O  ari_rxstatus_val   Output  1   $instance_name  ARI_RXSTATUS_VAL_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_SOF_O           ari_sof            Output  1   $instance_name  ARI_SOF_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_TIMESTAMP_VAL_O ari_timestamp_val  Output  1   $instance_name  ARI_TIMESTAMP_VAL_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_VAL_O           ari_val            Output  1   $instance_name  ARI_VAL_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_RDY_O           ati_rdy            Output  1   $instance_name  ATI_RDY_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_TX_WATERMARK_O  ati_tx_watermark   Output  1   $instance_name  ATI_TX_WATERMARK_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_TXSTATUS_VAL    ati_txstatus_val   Output  1   $instance_name  ATI_TXSTATUS_VAL
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_BE_O            ari_be             Output  2   $instance_name  ARI_BE_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ARI_DATA_O          ari_data           Output  32  $instance_name  ARI_DATA_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_TIMESTAMP_O     ati_timestamp      Output  64  $instance_name  ATI_TIMESTAMP_O
            fpga_interfaces::add_interface_port  $iface_name  ${z}_ATI_TXSTATUS_O      ati_txstatus       Output  18  $instance_name  ATI_TXSTATUS_O

            set location       [locations::get_fpga_location $instance_name $atom_name]
            fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
        }
    }
}

proc elab_TEST {device_family} {
    set parameter_enabled [expr {[string compare [get_parameter_value TEST_Enable] "true" ] == 0}]
    set ini_enabled       [expr {[string compare [get_parameter_value quartus_ini_hps_ip_enable_test_interface] "true" ] == 0}]

    set instance_name  test_interface
    set atom_name      hps_interface_test
    set wys_atom_name  fourteennm_hps_interface_test
    set location       [locations::get_fpga_location $instance_name $atom_name]

    if {$parameter_enabled && $ini_enabled} {

        set iname "test"
        set z     "test_"

        set data [get_parameter_value test_iface_definition]

        fpga_interfaces::add_interface      $iname  conduit input
        foreach {port width dir} $data {
            fpga_interfaces::add_interface_port $iname "${z}${port}" $port $dir $width $instance_name $port
        }

        fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
    }
}


proc get_HPS_IO_Enable_wrapper {} {
    set hps_io_list [get_parameter_value HPS_IO_Enable]
    set overided_io_list [list]
    
    foreach hps_io $hps_io_list {
        # Need to use a regular expression, but they did not worked at 1st try and TCL documentation sucks. so it is faster this way. Other day with more time I will retry.
        if {$hps_io == "MDIO0:MDIO" || $hps_io == "MDIO0:MDC" ||$hps_io == "MDIO1:MDIO" || $hps_io == "MDIO1:MDC" || $hps_io == "MDIO2:MDIO" || $hps_io == "MDIO2:MDC" } {
            #send_message info "we matched  $hps_io "
            set hps_io [string replace $hps_io 0 3 "EMAC" ]
        }
        lappend overided_io_list $hps_io
    }
    return $overided_io_list
}
        

proc get_pin_location {peripheral_and_pin} {
    set hps_io [get_HPS_IO_Enable_wrapper]

    set device [get_device]
    array set io_locations [::pin_mux_db::load_gpio_index_table $device]
    #pinmux.csv
    set i 0
    foreach hps_io $hps_io {
        if { $peripheral_and_pin == $hps_io } {
            set location $io_locations($i)
            return $location
        }
        incr i
    }
    send_message warning "The pin $peripheral_and_pin Needs to be connected to a pin, but has no pin asigment Yet "

    return "PAD_illegal"
}

# This function added in 14.0 to generate the pins. replaces the mux leglity
proc elab_io_interface_signals {peripheral_name mode_value peripheral_ports_arg} {
    upvar 1 $peripheral_ports_arg peripheral_ports

    get_atom_for_instance instance_map
    set instance_name [string tolower "phery_${peripheral_name}"]
    set atom $instance_map($peripheral_name)
    load_modes_table modes_table
    set values $modes_table($atom)
    set device [get_device]
    array set pin_mux_table [::pin_mux_db::load_pin_mux_table $device]
    #send_message debug "NEA 00: this is an IO $peripheral_name $mode_value"

    if {[lsearch $values $mode_value] == -1} {
        send_message error " The $peripheral_name has an invaled mode: \"$mode_value\". Valid modes are: $values"
    }

    set atom_ports $peripheral_ports($atom)
    
    ## Detect if we have a NAND on the dedicated Io cuadrant.
    set boot_nand false
    set hps_io [get_HPS_IO_Enable_wrapper]
    if {[lsearch $hps_io "NAND:ALE"] != -1} {
        # nand ale must be in the 7th position
        set dedicated_boot_location [string trim [lindex $hps_io 7]] 
        if {$dedicated_boot_location == "NAND:ALE"} {
            set boot_nand true

            if {[lsearch $hps_io "NAND:WP"] != -1 && $atom == "NAND"} {
                send_message warning "The NAND is in assigned to the dedicated IO, but we detected a Write Protect pin." 
            }
        }
    } 
    
    array set pad_to_ball_name {}
    set location_map [locations::get_pad_to_pkg_map ]
    foreach {pad_id ball_name } $location_map {
        set pad_name "PAD_${pad_id}"
        set pad_to_ball_name($pad_name) $ball_name
        #send_message info " $pad_name -> $pad_to_ball_name($pad_name)"
    }
    
    
    foreach  {pin_name input_signal output_signal oe_signal modes} $atom_ports {
        # Hack. If the NAND is located in the dedicated IO, It does not have the WP pin connected.
        if { $boot_nand && $output_signal == "NAND_WP_N(0:0)" } {
            continue
        }
        ## The PLL clock is special. We overide the contents of the CM mode for indibidual variables.
        if { $atom == "CM"} {
            set pll_name "PLL_CLK${modes}"
            set pll_clock  [get_parameter_value $pll_name]

            if { $pll_clock == [IO_MUX_VALUE]} {
                set mode_value $modes
            } else {
                set mode_value "not_used"
            }
        }
        if {[lsearch $modes $mode_value] != -1} {
            set peripheral_and_pin "$peripheral_name:$pin_name"

            #look for the signal on the location string
            if {$input_signal == ""} {
                set dire "output"
            } elseif { $output_signal == "" &&   $oe_signal == "" } {
                set dire "input"
            } else {
                set dire "bidir"
            }
            # Create the port names to create the RTL.
            if {$input_signal != ""} {
             set in_port  "${instance_name}:${input_signal}"
            } else { set in_port "" }

            if { $output_signal != ""} {
             set out_port  "${instance_name}:${output_signal}"
            } else { set out_port "" }
            #
            if {$oe_signal != ""} {
             set oe_port  "${instance_name}:${oe_signal}"
            } else { set oe_port "" }
            
            # Legality check, make sure the location is valid!
            set location [get_pin_location $peripheral_and_pin]

            if {[info exists pin_mux_table($location)] == 0} {
                if {$location != "PAD_illegal"} {
                    send_message error "Pin $peripheral_and_pin has a valid pin location Assigment but it is not the correct one"
                }
                send_message debug "Pin Location ${location} for pin $peripheral_and_pin is not the correct one"
            } else {
                set list_of_valid_locations $pin_mux_table($location)
                if {[lsearch $list_of_valid_locations $peripheral_and_pin] == -1} {
                    send_message debug "ACID 1: $list_of_valid_locations"
                    send_message warning "Invalid Pin selection!. Location $location is invalid for the pin $peripheral_and_pin"
                }
            }
            # Translate PAD to BALL name
            
            if {[info exists pad_to_ball_name($location)]} {
                set ball_name  $pad_to_ball_name($location)
                set location "PIN_${ball_name}"
            }
            
            hps_io::add_pin $instance_name $pin_name $dire  $location $in_port $out_port $oe_port
        }
    }

    set wys_atom_name [peripheral_to_wys_atom_name $peripheral_name]
    set location [locations::get_hps_io_peripheral_location $peripheral_name]
    hps_io::add_peripheral $instance_name $wys_atom_name $location
}

proc elab_GPIO {device_family} {
    set gpio_used 0
    set periph_inst "gpio"
    set hps_io_list [get_HPS_IO_Enable_wrapper]
    set device [get_device]
    array set gpio_locations [::pin_mux_db::load_gpio_index_table $device]

    array set pad_to_ball_name {}
    set location_map [locations::get_pad_to_pkg_map ]
    foreach {pad_id ball_name } $location_map {
        set pad_name "PAD_${pad_id}"
        set pad_to_ball_name($pad_name) $ball_name
        #send_message info " $pad_name -> $pad_to_ball_name($pad_name)"
    }
    
    set i 0
    foreach hps_io $hps_io_list {
        if { $hps_io == "GPIO" } {

            set gpio_used 1
            set location $gpio_locations($i)
            
            if { $i < 14 } {
                # dedicated IO
                set gpio_group 2    
                set gpio_port_index $i
            } elseif { $i >= 38} {
                # this is Q3 and Q4
                set gpio_group 1    
                set gpio_port_index [expr $i - 38 ]
            } else {
                # this is Q1 and Q2
                set gpio_group 0    
                set gpio_port_index [expr $i - 14 ]
            }
            
            #send_message debug "NEA $i: $pad $gpio_group $gpio_port_index"
            set gpio_name "gpio${gpio_group}_io${gpio_port_index}"
            set in_port   "${periph_inst}:GPIO${gpio_group}_PORTA_I($gpio_port_index:$gpio_port_index)"
            set out_port  "${periph_inst}:GPIO${gpio_group}_PORTA_O($gpio_port_index:$gpio_port_index)"
            set oe_port   "${periph_inst}:GPIO${gpio_group}_PORTA_OE($gpio_port_index:$gpio_port_index)"

            if {[info exists pad_to_ball_name($location)]} {
                set ball_name $pad_to_ball_name($location)
                set location "PIN_${ball_name}"
            }
            
            hps_io::add_pin $periph_inst $gpio_name bidir $location $in_port $out_port $oe_port
        }
        incr i
    }

    if {$gpio_used} {
        set wys_atom_name  fourteennm_hps_peripheral_gpio
        set location   [locations::get_hps_io_peripheral_location GPIO ]
        hps_io::add_peripheral $periph_inst $wys_atom_name $location
    }
}

proc elab_FPGA_Peripheral_Signals {device_family} {

    set peripherals [list_peripheral_names]
    foreach peripheral $peripherals {
        set clocks [get_peripheral_fpga_output_clocks $peripheral]
        foreach clock $clocks {
            set parameter [form_peripheral_fpga_output_clock_frequency_parameter $clock]
            set_parameter_property $parameter enabled  false
            set_parameter_property $parameter visible  true
            set clock_output_set($clock) 1
        }

        set clocks [get_peripheral_fpga_input_clocks $peripheral]
        foreach clock $clocks {
            set clock_input_set($clock) 1
        }
    }
    #set TIME_start [clock clicks -milliseconds]
    load_pin_to_atom_map peripheral_ports
    #set TIME_taken [expr [clock clicks -milliseconds] - $TIME_start]
    #send_message debug "ACID: This is how much ot took load_pin_to_atom_map: ${TIME_taken}"
    array set fpga_ifaces [get_parameter_value DB_periph_ifaces]
    array set iface_ports [get_parameter_value DB_iface_ports]
    array set port_pins   [get_parameter_value DB_port_pins]
    
    set add_false_paths 1

    foreach peripheral_name $fpga_ifaces([ORDERED_NAMES]) { ;# Peripherals
        set pin_mux_param_name [format [PIN_MUX_PARAM_FORMAT] $peripheral_name]
        set pin_mux_value  [get_parameter_value    $pin_mux_param_name]
        set allowed_ranges [get_parameter_property $pin_mux_param_name allowed_ranges]

        if {[string compare $pin_mux_value [FPGA_MUX_VALUE]] == 0 && [lsearch $allowed_ranges [FPGA_MUX_VALUE]] != -1} {
            funset peripheral
            array set peripheral $fpga_ifaces($peripheral_name)

            funset interfaces
            array set interfaces $peripheral(interfaces)

            set instance_name [invent_peripheral_instance_name $peripheral_name]
            
            foreach interface_name $interfaces([ORDERED_NAMES]) { ;# Interfaces
                funset interface
                array set interface $interfaces($interface_name)
                
                if { [ interface_is_vaild_in_this_mode  $peripheral_name  $interface_name ]} {
                    fpga_interfaces::add_interface $interface_name $interface(type) $interface(direction)

                    foreach {property_key property_value} $interface(properties) {
                        fpga_interfaces::set_interface_property $interface_name $property_key $property_value
                    }
                
                    foreach {meta_property} [array names interface] {
                        # Meta Property if leading with an @
                        if {[string compare [string index ${meta_property} 0] "@"] == 0} {
                            fpga_interfaces::set_interface_meta_property $interface_name [string replace ${meta_property} 0 0] $interface($meta_property)
                        }
                    }
    
                    set once_per_clock 1
                    funset ports
                    array set ports $iface_ports($interface_name)
                    foreach port_name $ports([ORDERED_NAMES]) { ;# Ports
                        funset port
                        array set port $ports($port_name)
    
                        set width [calculate_port_width $port_pins($port_name)]
                        if { [port_is_vaild_in_this_mode $peripheral_name $port_name ]} {
                            set width [ update_emac_width $peripheral_name $port_name $width ]
                            fpga_interfaces::add_interface_port $interface_name $port_name $port(role) $port(direction) $width $instance_name $port(atom_signal_name)
                        }
                    }
                    set frequency 0
                    # enable and show clock frequency parameters for outputs
                    if {[info exists clock_output_set($interface_name)]} {
                        set parameter [form_peripheral_fpga_output_clock_frequency_parameter $interface_name]
                        set_parameter_property $parameter enabled  true
                        set frequency [get_parameter_value $parameter]
                        set frequency [expr {$frequency * [MHZ_TO_HZ]}]
                        fpga_interfaces::set_interface_property $interface_name clockRateKnown true
                        fpga_interfaces::set_interface_property $interface_name clockRate      $frequency
                    }
    
                    if {[string compare -nocase $interface(type) "clock"] == 0 && $once_per_clock} {
                        set once_per_clock 0
                        add_clock_constraint_if_valid $frequency "*|fpga_interfaces|${instance_name}|[string tolower $port(atom_signal_name)]"
                        
                        set add_false_paths 1
                    }
                } 
            }
            # device-specific atom
            set atom_name     $peripheral(atom_name)
            set wys_atom_name fourteennm_${atom_name}
            set location [locations::get_fpga_location $peripheral_name $atom_name]

            fpga_interfaces::add_module_instance $instance_name $wys_atom_name $location
        }

        if {[string compare $pin_mux_value [IO_MUX_VALUE]] == 0 && [lsearch $allowed_ranges [IO_MUX_VALUE]] != -1} {

            set mode_value [hps_ip_pin_muxing_model::get_peripheral_mode_selection $peripheral_name]
            elab_io_interface_signals $peripheral_name $mode_value peripheral_ports
        }
    }
    if {$add_false_paths} {
        set l3     [get_parameter_value L3_MAIN_FREE_CLK]
        set l4main [get_parameter_value NOCDIV_L4MAINCLK]
        set div_period 10.00
        foreach { div index } [ list 1 0 2 1 4 2 8 3 ] {
           if {$l4main == $index} {
                set div_freq   [ expr { $l3 / $div } ]
                set div_period [ expr { 1.0 / $div_freq * 1000}]
            }
        }
        
        fpga_interfaces::add_raw_sdc_constraint "create_clock  -period $div_period \[get_nodes   *l4_main_clk\]"
        fpga_interfaces::add_raw_sdc_constraint "create_clock  -period $div_period \[get_registers {*~gen_noc_clk.reg}\]"
        

    }
}

# invents an instance name from the peripheral's name
# assumes that the instance name is the same across a peripheral
proc invent_peripheral_instance_name {peripheral_name} {
    return "peripheral_[string tolower $peripheral_name]"
}

proc calculate_port_width {pin_array_string} {
    array set pins $pin_array_string
    #       -do we need to be able to support ports that don't start with pins at 0?
    #       -e.g. pins D0-D7 are indexed 0-7. if want D4-D7, can we do indexes 4-7?
    #       -for now, no!
    set bit_index 0
    while {[info exists pins($bit_index)]} {
        incr bit_index
    }
    return $bit_index
}



proc is_soc_device {device} {
    return [::pin_mux_db::verify_soc_device $device]
}

# Add cached device database parameter
add_storage_parameter dev_database {}

# Add pin muxing details to soc_io peripheral/signal data
add_storage_parameter pin_muxing {}
add_storage_parameter pin_muxing_check ""


proc ensure_device_data {device_family} {
    
    set device [get_device]
    locations::load $device
    if {![is_soc_device $device]} {
        send_message error "Selected device '${device}' is not an SoC device supported by this Qsys Library. Please choose a valid Stratix 10 device to uses the Hard Processor System (HPS)."
    }
}


proc get_device {} {

    set device_name [get_parameter_value device_name]
    return $device_name
}

proc construct_hps_parameter_map {} {
    set parameters [get_parameters]
    foreach parameter $parameters {
        set value [get_parameter_value $parameter]
        set result($parameter) $value
    }
    return [array get result]
}

################################################################################
#
namespace eval hps_ip_pin_muxing_model {
################################################################################
    proc get_peripherals_model {} {
        set pin_muxing [get_parameter_value pin_muxing]
        set peripherals [lindex $pin_muxing 0]
        return $peripherals
    }

    proc get_peripheral_pin_muxing_selection {peripheral_name} {
        set pin_muxing_param_name [format [PIN_MUX_PARAM_FORMAT] $peripheral_name]
        set selection [get_parameter_value $pin_muxing_param_name]
        return $selection
    }
    proc get_peripheral_mode_selection {peripheral_name} {
        set mode_param_name [format [MODE_PARAM_FORMAT] $peripheral_name]
        set selection [get_parameter_value $mode_param_name]
        return $selection
    }

    proc get_customer_pin_names {} {
        set pin_muxing [get_parameter_value pin_muxing]
        set pins [lindex $pin_muxing 3]
        return $pins
    }
    proc get_unsupported_peripheral {peripheral_name} {
        set device_family [get_parameter_value hps_device_family]
        set skip 0
        if {[check_device_family_equivalence $device_family ARRIAV]} {
            foreach excluded_peripheral [ARRIAV_EXCLUDED_PERIPHRERALS] {
                if {[string compare $excluded_peripheral $peripheral_name] == 0} {
                    set skip 1
                }
            }
        }
        return $skip
    }
}
