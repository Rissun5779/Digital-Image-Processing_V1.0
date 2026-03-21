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


#####################
##### Constants #####
#####################

proc create_constants {} {
    set constants {
        FPGA_MUX_VALUE         "FPGA"
        IO_MUX_VALUE           "IO"
        UNUSED_MUX_VALUE       "Unused"
        NA_MODE_VALUE          "N/A"
        PIN_MUX_PARAM_FORMAT   "%%s_PinMuxing"
        MODE_PARAM_FORMAT      "%%s_Mode"
        ORDERED_NAMES          "@orderednames"
        TERMINATION            "termination"
        TRUE                   "true"
        FALSE                  "false"
        TERMINATIONVALUE       "terminationValue"
        QSYS_ONLY              "qsys_only"
        HDL_ONLY               "hdl_only"
        NO_EXPORT              "no_export"
        F2HSDRAM_AXI3          "AXI-3"
        SDC_CREATE_CLOCK       "create_clock -period %%s [get_pins -compatibility_mode %%s]"
        MHZ_TO_HZ              "1000000.0"
        MAIN_PLL                "0:Main PLL clock"
        PERI_PLL                "1:Peripheral PLL clock"
        EOSC1                   "2:HPS external oscillator (OSC1) clock"
        CB                      "3:Internal oscillator from control block"
        F2S_FREE                "4:FPGA to HPS free clock"

        EOSC1_VCO               "0:HPS external oscillator (OSC1) clock"
        CB_VCO                  "1:Internal oscillator from control block"
        F2S_VCO                 "2:FPGA to HPS free clock"

        MUXA                    "0:EMAC mux a"
        MUXB                    "1:EMAC mux b"
        
    }

    foreach {constant_name constant_value} $constants {
        set proc_creation_code [format "proc %s \{\} \{ return {${constant_value}}\}" $constant_name $constant_value]
        uplevel 0 {
            eval $proc_creation_code
        }
    }
}
create_constants

proc list_peripheral_names {} {
    set peripherals [list]
    foreach group_name [list_group_names] {
        foreach peripheral [peripherals_in_group $group_name] {
            lappend peripherals $peripheral
        }
    }
    return $peripherals
}

proc list_group_names {} {
    return [list "Ethernet Media Access Controller" \
                 "NAND Flash Controller"            \
                 "Quad SPI Flash Controller"        \
                 "SD/MMC Controller"                \
                 "USB Controllers"                  \
                 "SPI Controllers"                  \
                 "UART Controllers"                 \
                 "I2C Controllers"                  \
                 "Trace Port Interface Unit"        \
                 "Clock Out" ]
}

proc peripherals_in_group {group_name} {
    # this may take longer, but it's more maintainable
    if {[string compare $group_name "Ethernet Media Access Controller"] == 0} { return {EMAC0 EMAC1 EMAC2}       }
    if {[string compare $group_name "NAND Flash Controller"] == 0}            { return {NAND}                    }
    if {[string compare $group_name "SD/MMC Controller"] == 0}                { return {SDMMC}                   }
    if {[string compare $group_name "USB Controllers"] == 0}                  { return {USB0 USB1}               }
    if {[string compare $group_name "SPI Controllers"] == 0}                  { return {SPIM0 SPIM1 SPIS0 SPIS1} }
    if {[string compare $group_name "UART Controllers"] == 0}                 { return {UART0 UART1}             }
    if {[string compare $group_name "I2C Controllers"] == 0}                  { return {I2C0 I2C1 I2CEMAC0 I2CEMAC1 I2CEMAC2}}
    if {[string compare $group_name "Trace Port Interface Unit"] == 0}        { return {TRACE}                   }
    if {[string compare $group_name "Clock Out"] == 0}                        { return {CM}                      }

}

# converts a specific peripheral name to type. really just uppercases and then removes numbers
proc peripheral_to_type {peripheral_name} {
    set len [string length $peripheral_name]
    
    set end_index [expr {$len - 1}]
    
    for {set i $end_index} {$i >= 0} {incr i -1} {
        set ch [string index $peripheral_name $i]
        if {[string is integer $ch]} {
            incr end_index -1
        } else {
            break
        }
    }
    return [string toupper [string range $peripheral_name 0 $end_index]]
}

#####################
#####################
#####################
