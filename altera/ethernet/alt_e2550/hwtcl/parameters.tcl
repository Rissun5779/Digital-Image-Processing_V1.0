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


package provide alt_e2550::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::common
package require alt_xcvr::utils::device

namespace eval ::alt_e2550::parameters:: {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*
    namespace import ::alt_xcvr::ip_tcl::messages::*

    variable val_prefix
    variable display_items
    variable parameters

    set package_name "alt_e2550::parameters"

    set display_items {\
        {NAME                                           GROUP               TYPE    ARGS    VISIBLE             }\
        {"IP"                                           ""                  GROUP   tab     true                }\
        {"General Options"                              "IP"                GROUP   NOVAL   true                }\
        {"PCS/PMA Options"                              "IP"                GROUP   NOVAL   true                }\
        {"Flow Control Options"                         "IP"                GROUP   NOVAL   true                }\
        {"MAC Options"                                  "IP"                GROUP   NOVAL   true                }\
        {"IEEE 1588 Options"                            "IP"                GROUP   NOVAL   "SPEED_CONFIG==25"  }\
        {"Example Design"                               ""                  GROUP   tab     true                }\
        {"Available Example Designs"                    "Example Design"    GROUP   NOVAL   true                }\
        {"Example Design Files"                         "Example Design"    GROUP   NOVAL   true                }\
        {"Generated HDL Format"                         "Example Design"    GROUP   NOVAL   true                }\
        {"Target Development Kit"                       "Example Design"    GROUP   NOVAL   true                }\
        {"Debug"                                        ""                  GROUP   tab     SHOW_DEBUG_TAB      }\
        {"Configuration, Debug and Extension Options"   "IP"                GROUP   NOVAL   true                }\
    }

    set parameters {\
        {NAME                       DERIVED HDL_PARAMETER   TYPE    DEFAULT_VALUE   ALLOWED_RANGES             ENABLED                 VISIBLE       DISPLAY_HINT    DISPLAY_UNITS       DISPLAY_ITEM                DISPLAY_NAME                        VALIDATION_CALLBACK                         UNITS       DESCRIPTION                          }\
                                                                                                                                       
        {part_trait_bd              false   false           STRING  "Unknown"       NOVAL                      true                    false         NOVAL           NOVAL               NOVAL                       NOVAL                               NOVAL                                       NOVAL       NOVAL                                }\
        {DEVICE                     false   false           STRING  "Unknown"       NOVAL                      true                    false         NOVAL           NOVAL               NOVAL                       NOVAL                               ::alt_e2550::parameters::chk_dev_unknown    NOVAL       NOVAL                                }\
        {SHOW_DEBUG_TAB             true    false           STRING  "false"         NOVAL                      true                    false         NOVAL           NOVAL               NOVAL                       NOVAL                               ::alt_e2550::parameters::chk_qii_ini        NOVAL       NOVAL                                }\
        {UNHIDE_ADV                 true    false           STRING  "false"         NOVAL                      true                    false         NOVAL           NOVAL               NOVAL                       NOVAL                               ::alt_e2550::parameters::chk_qii_ini        NOVAL       NOVAL                                }\
                                                                                                                                       
        {DEVICE_FAMILY              false   false           STRING  NOVAL           {"Arria 10"}               false                   true          "Device Family" NOVAL               "General Options"           "Device family"                     ::alt_e2550::parameters::v_DEV_FAM          NOVAL       "Only Arria 10 devices are supported"}\
        {SPEED_CONFIG               false   false           integer 50              {"50:50 GbE" "25:25 GbE"}  true                    true          NOVAL           NOVAL               "General Options"           "Protocol speed"                    ::alt_e2550::parameters::v_SPEED_CONFIG     NOVAL       "Select Ethernet protocol speed"     }\
        {SYNOPT_READY_LATENCY       false   true            integer 0               {0 3}                      true                    true          NOVAL           NOVAL               "General Options"           "Ready Latency"                     ::alt_e2550::parameters::v_READY_LATENCY    NOVAL       ""                                   }\
                                                                                                                                       
        {SYNOPT_RSFEC               false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "PCS/PMA Options"           "Enable RS-FEC"                     NOVAL                                       NOVAL       "Enable Reed-Solomon FEC. IEEE 1588 cannot be combined with this feature"            }\
        {SYNOPT_DIV40               false   true            integer 1               NOVAL                      "SPEED_CONFIG==50"      false         boolean         NOVAL               "PCS/PMA Options"           "Use DIV40 from XCVR"               NOVAL                                       NOVAL       "Use divide by 40 clock from XCVR and fPLL"            }\
                                                                                                                                       
        {SYNOPT_LINK_FAULT          false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "MAC Options"               "Enable link fault generation"      NOVAL                                       NOVAL       ""                                   }\
        {SYNOPT_STRICT_SOP          false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "MAC Options"               "Enable strict SFD checking"        NOVAL                                       NOVAL       ""                                   }\
        {SYNOPT_PREAMBLE_PASS       false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "MAC Options"               "Enable preamble passthrough"       NOVAL                                       NOVAL       ""                                   }\
        {SYNOPT_TXCRC_PASS          false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "MAC Options"               "Enable TX CRC passthrough"         NOVAL                                       NOVAL       "IEEE 1588 cannot be combined with this feature"                                   }\
        {SYNOPT_MAC_STATS_COUNTERS  false   true            integer 1               NOVAL                      true                    true          boolean         NOVAL               "MAC Options"               "Enable MAC statistics counters"    NOVAL                                       NOVAL       ""                                   }\
        {SYNOPT_OTN                 false   false           integer 0               NOVAL                      "SPEED_CONFIG==25"      "UNHIDE_ADV"  boolean         NOVAL               "PCS/PMA Options"           "Enable OTN"                        NOVAL                                       NOVAL       "Enable OTN PCS"                     }\
                                                                                                                                       
        {SYNOPT_FLOW_CONTROL        false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "Flow Control Options"      "Enable flow control"               NOVAL                                       NOVAL       ""                                   }\
        {SYNOPT_NUMPRIORITY         false   true            integer 8               {1:8}                      "SYNOPT_FLOW_CONTROL"   true          integer         NOVAL               "Flow Control Options"      "Number of queues"                  NOVAL                                       NOVAL       ""                                   }\
                                                                                                               
        {SYNOPT_ENABLE_PTP          false   true            integer 0               NOVAL                      true                    true          boolean         NOVAL               "IEEE 1588 Options"         "Enable IEEE 1588"                  NOVAL                                       NOVAL       NOVAL                                }\
        {SYNOPT_TIME_OF_DAY_FORMAT  false   true            integer 2               NOVAL                      "SYNOPT_ENABLE_PTP"     true          integer         NOVAL               "IEEE 1588 Options"         "Time of day format"                NOVAL                                       NOVAL       NOVAL                                }\
        {SYNOPT_TSTAMP_FP_WIDTH     false   true            integer 4               NOVAL                      "SYNOPT_ENABLE_PTP"     true          integer         NOVAL               "IEEE 1588 Options"         "Fingerprint width"                 NOVAL                                       NOVAL       NOVAL                                }\
                                                                                                                                       
        {TARGET_CHIP                true    true            integer 2               NOVAL                      true                    false         integer         NOVAL               "IP"                        "TARGET_CHIP"                       NOVAL                                       NOVAL       ""                                   }\
                                                                                                                                       
        {EXAMPLE_DESIGN             false   false           integer 1               NOVAL                      true                    true          NOVAL           NOVAL               "Available Example Designs" "Select design:"                    NOVAL                                       NOVAL       ""                                   }\
        {GEN_SIMULATION             false   false           integer 1               NOVAL                      true                    true          boolean         NOVAL               "Example Design Files"      "Simulation"                        NOVAL                                       NOVAL       ""                                   }\
        {GEN_SYNTH                  false   false           integer 0               NOVAL                      false                   true          boolean         NOVAL               "Example Design Files"      "Synthesis"                         NOVAL                                       NOVAL       ""                                   }\
        {DEV_BOARD                  false   false           integer 1               NOVAL                      "GEN_SYNTH == 1"        true          NOVAL           NOVAL               "Target Development Kit"    "Select board:"                     NOVAL                                       NOVAL       ""                                   }\
        {HDL_FORMAT                 false   false           integer 0               {"0:Verilog"}              true                    true          NOVAL           NOVAL               "Generated HDL Format"      "Generate File Format"              NOVAL                                       NOVAL       ""                                   }\
                                                                                                                                       
        {adme_enable_hwtcl          false   false           INTEGER 0               NOVAL                      true                    true          boolean         NOVAL               NOVAL                       NOVAL                               NOVAL                                       NOVAL       NOVAL                                }\
        {set_odi_soft_logic_enable  false   false           INTEGER 0               NOVAL                      true                    false         boolean         NOVAL               NOVAL                       NOVAL                               NOVAL                                       NOVAL       NOVAL                                }\
                                                                                                                                       
        {OVERRIDE_PART_NUM          false   false           integer 0               NOVAL                      true                    true          boolean         NOVAL               "Debug"                     NOVAL                               NOVAL                                       NOVAL       ""                                   }\
    }
}

proc ::alt_e2550::parameters::declare_parameters {} {
    variable display_items
    variable parameters
    ip_declare_display_items  $display_items
    ip_declare_parameters     $parameters
    ip_set "parameter.DEVICE_FAMILY.SYSTEM_INFO"          DEVICE_FAMILY

    add_display_item "Target Development Kit" TARGET_DEVICE text ""
    add_display_item "Target Development Kit" TARGET_DESCRIPTION text \
    "<html>Example design supports generation, simulation, and Quartus compile flows for any <br> 
    selected device. The hardware support is provided through selected Development kit(s) <br>
    with a specific device. To exclude hardware aspects of example design, select \"None\" <br>
    from the \"Target Development Kit\" pull down menu</html>"

    # Add long parameters here to help compact parameter table
    ip_set "parameter.EXAMPLE_DESIGN.ALLOWED_RANGES"            {"1:Single instance of IP core"}
    ip_set "parameter.SYNOPT_TSTAMP_FP_WIDTH.ALLOWED_RANGES"    {"1:1" "2:2" "3:3" "4:4" "5:5" "6:6" "7:7" "8:8" "9:9" "10:10" "11:11" "12:12" "13:13" "14:14" "15:15" "16:16" "17:17" "18:18" "19:19" "20:20" "21:21" "22:22" "23:23" "24:24" "25:25" "26:26" "27:27" "28:28" "29:29" "30:30" "31:31" "32:32"}
    ip_set "parameter.SYNOPT_TIME_OF_DAY_FORMAT.ALLOWED_RANGES" {"0:Enable 96-bit timestamp format" "1:Enable 64-bit timestamp format" "2:Enable both formats"}
    ip_set "parameter.adme_enable_hwtcl.DISPLAY_ITEM"           "Configuration, Debug and Extension Options"
    ip_set "parameter.adme_enable_hwtcl.DISPLAY_NAME"           "Enable Altera Debug Master Endpoint (ADME)"
    ip_set "parameter.set_odi_soft_logic_enable.DISPLAY_ITEM"   "Configuration, Debug and Extension Options"
    ip_set "parameter.set_odi_soft_logic_enable.DISPLAY_NAME"   "Enable ODI(On Die Instrumentation) acceleration logic"
    ip_set "parameter.OVERRIDE_PART_NUM.DISPLAY_NAME"           "Override example design part number"

    ip_set "parameter.EXAMPLE_DESIGN.DESCRIPTION"   \
        "<b>Single Instance of IP Core</b><br>
        Example designs instantiate a single instance of the IP core.<br>
        <br>
        The Synthesis project is a project designed to run on a development 
        kit and includes the necessary supporting hardware including JTAG master 
        and PLLs.<br>
        <br>
        The Simulation project is a testbench which demonstrates basic core 
        interfacing and usage.<br>
        <br>
        <b>None</b><br>
        If neither the Simulation or Synthesis designs are available, 
        this option will be set to None. In this case, only a compilation 
        design will be generated which instantiates the IP and assigns its I/O 
        to virtual pins."

    ip_set "parameter.GEN_SYNTH.DESCRIPTION" \
        "When the synthesis box is checked, all necessary filesets required for 
        the hardware example design will be generated. <br>
        <br>
        When Synthesis box is NOT 
        checked, files required for Synthesis will be NOT be generated."

    ip_set "parameter.GEN_SIMULATION.DESCRIPTION" \
        "When Synthesis box is checked, all necessary filesets required for 
        synthesis will be generated.<br>
        <br>
        When Synthesis box is NOT checked, files required for Synthesis will 
        be NOT generated."

    ip_set "parameter.HDL_FORMAT.DESCRIPTION" \
        "Please select an HDL format for the generated Example Design filesets."

    ip_set "parameter.adme_enable_hwtcl.DESCRIPTION"            \
        "When on, an embedded Altera Debug Master Endpoint (ADME) connects internally to the Avalon-MM slave 
        interface for the dynamic reconfiguration. The ADME can access the reconfiguration space of the 
        transceiver. It can perform certain tests and debug functions via JTAG using System Console."

    ip_set "parameter.set_odi_soft_logic_enable.DESCRIPTION"    \
        "Enables soft logic for accelerating bit and error accumulation when using ODI."

    ip_set "parameter.DEV_BOARD.DESCRIPTION" \
        "This option provides supports for various Development Kits listed. The 
        details of Intel FPGA Development kits can be found on the 
        <a href=\"https://www.altera.com/products/boards_and_kits/all-development-kits.html\">
        Intel FPGA website</a>. If this menu is greyed out, it is because no board is supported 
        for the options selected such as synthesis checked off. If an Intel FPGA Development 
        board is selected, the Target Device used for generation will be the one that 
        matches the device on the Development Kit."
        
    ip_set "parameter.SYNOPT_ENABLE_PTP.DESCRIPTION"            \
        "Enables IEEE 1588 timestamp features; TX CRC passthrough and RS-FEC cannot be combined with this feature."
        
    ip_set "parameter.SYNOPT_TIME_OF_DAY_FORMAT.DESCRIPTION"            \
        "Select the 64b correction field format, the 96b IEEE 1588v2 format, or enable per-frame format
        selection by choosing Both"
        
    ip_set "parameter.SYNOPT_TSTAMP_FP_WIDTH.DESCRIPTION"            \
        "Sets the number of bits used to ID frames for 2-step timestamps. Use a small value to
        save resources if 2-step timestamps will not be used, or will be used rarely. Set a larger
        value if the system will transmit large bursts of frames that need 2-step timestamps"

    ip_set "parameter.SYNOPT_LINK_FAULT.DESCRIPTION"            \
        "When Link fault signaling is enabled, Altera Ethernet IP can detect and report fault
        conditions on transmit and receive ports."

    ip_set "parameter.SYNOPT_READY_LATENCY.DESCRIPTION" "Specifies the ready latency for the TX ready status signal"

    ip_set "parameter.SYNOPT_STRICT_SOP.DESCRIPTION" "Enables RX MAC strict SFD checking"

    ip_set "parameter.SYNOPT_PREAMBLE_PASS.DESCRIPTION"     \
        "When enabled, the user must pass the 8 octet preamble value to the Ethernet core on
        the TX interface. On the RX interface, the received preamble is presented to the user."

    ip_set "parameter.SYNOPT_TXCRC_PASS.DESCRIPTION"     \
        "When enabled, the user must pass in the CRC value at the end of the data stream."

    ip_set "parameter.SYNOPT_MAC_STATS_COUNTERS.DESCRIPTION"     \
        "Enables the MAC statistics counters which give information sent and received packets."

    ip_set "parameter.SYNOPT_FLOW_CONTROL.DESCRIPTION"     \
        "Select to turn on the priority-based flow control."

    ip_set "parameter.SYNOPT_NUMPRIORITY.DESCRIPTION"     \
        "Specify the number of PFC queues."

    set_parameter_update_callback SPEED_CONFIG      ::alt_e2550::parameters::change_state
    set_parameter_update_callback GEN_SYNTH         ::alt_e2550::parameters::change_state
    set_parameter_update_callback GEN_SIMULATION    ::alt_e2550::parameters::change_state

    ip_set "parameter.part_trait_bd.SYSTEM_INFO_TYPE"     PART_TRAIT
    ip_set "parameter.part_trait_bd.SYSTEM_INFO_ARG"      BASE_DEVICE
    ip_set "parameter.DEVICE.SYSTEM_INFO"                 DEVICE
}

proc ::alt_e2550::parameters::change_state {PROP_NAME} {
    set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
    set LINK_FAULT      [ip_get "parameter.SYNOPT_LINK_FAULT.value"]
    set EN_RSFEC        [ip_get "parameter.SYNOPT_RSFEC.value"]
    set DIV40           [ip_get "parameter.SYNOPT_DIV40.value"]

    if {($SPEED_CONFIG == 50) && $EN_RSFEC} {
        ip_set "parameter.SYNOPT_RSFEC.value" 0
    }

    if {($SPEED_CONFIG == 25} {
        ip_set "parameter.SYNOPT_DIV40.value" 0
    }

    set hw_enable [ip_get "parameter.GEN_SYNTH.value"]
    set tb_enable [ip_get "parameter.GEN_SIMULATION.value"]

    # Set available designs to None if both testbench and hw design disabled # Usability requirement
    if {!$hw_enable && !$tb_enable} {
        ip_set "parameter.EXAMPLE_DESIGN.value" 0
    } else {
        ip_set "parameter.EXAMPLE_DESIGN.value" 1
    }

}

proc ::alt_e2550::parameters::validate {} {
    # Set available designs to None if both testbench and hw design disabled # Usability requirement
    set allowed_designs { "1:Single instance of IP core" }
    set hw_enable [ip_get "parameter.GEN_SYNTH.value"]
    set tb_enable [ip_get "parameter.GEN_SIMULATION.value"]
    if {!$hw_enable && !$tb_enable} {
        set allowed_designs  { "0:None" }
    }
    ip_set "parameter.EXAMPLE_DESIGN.ALLOWED_RANGES" $allowed_designs

    ip_validate_parameters
    ip_validate_display_items

    set TARGET_DEVICE [ ::alt_e2550::fileset::get_board_safe_part ]
    set_display_item_property TARGET_DEVICE text "Target device: $TARGET_DEVICE"
    
    #1588 validation
    set SPEED_CONFIG    [ip_get "parameter.SPEED_CONFIG.value"]
    set SYNOPT_TXCRC_PASS    [ip_get "parameter.SYNOPT_TXCRC_PASS.value"]
    set SYNOPT_RSFEC    [ip_get "parameter.SYNOPT_RSFEC.value"]
    set SYNOPT_ENABLE_PTP    [ip_get "parameter.SYNOPT_ENABLE_PTP.value"]
    if {$SPEED_CONFIG == 50} {
        ip_set "parameter.SYNOPT_ENABLE_PTP.HDL_PARAMETER" "false"
        ip_set "parameter.SYNOPT_TIME_OF_DAY_FORMAT.HDL_PARAMETER" "false"
        ip_set "parameter.SYNOPT_TSTAMP_FP_WIDTH.HDL_PARAMETER" "false"
    }
    
    if {$SPEED_CONFIG==25 && $SYNOPT_TXCRC_PASS==0 && $SYNOPT_RSFEC==0} {
        ip_set "parameter.SYNOPT_ENABLE_PTP.ENABLED" "true"
    } else {
        ip_set "parameter.SYNOPT_ENABLE_PTP.ENABLED" "false"
    }
    
    if {$SPEED_CONFIG==25} {
        if {$SYNOPT_ENABLE_PTP==0} {
            ip_set "parameter.SYNOPT_RSFEC.ENABLED" "true"
        } else {
            ip_set "parameter.SYNOPT_RSFEC.ENABLED" "false"
        }
    } else {
        ip_set "parameter.SYNOPT_RSFEC.ENABLED" "false"
    }
    
    if {$SYNOPT_ENABLE_PTP==0} {
        ip_set "parameter.SYNOPT_TXCRC_PASS.ENABLED" "true"
    } else {
        ip_set "parameter.SYNOPT_TXCRC_PASS.ENABLED" "false"
    }
}

proc ::alt_e2550::parameters::chk_dev_unknown {part_trait_bd DEVICE DEVICE_FAMILY} {
    if { ([string compare -nocase $DEVICE_FAMILY "Arria 10"] == 0) & \
         ([string compare -nocase $part_trait_bd "unknown" ] == 0) } {
        send_message error "The current selected device \"$DEVICE\" is invalid, please select a valid device to generate the IP."
    }
}

proc ::alt_e2550::parameters::v_SPEED_CONFIG {PROP_VALUE} {

}

proc ::alt_e2550::parameters::v_READY_LATENCY {PROP_VALUE SPEED_CONFIG} {
    if {$SPEED_CONFIG == 50} {
        if {$PROP_VALUE == 3} {
            send_message error "For 50G ethernet, only a ready latency value of 0 is valid"
        }
    }
}

proc ::alt_e2550::parameters::v_DEV_FAM {PROP_VALUE} {
    if {$PROP_VALUE == "Stratix V"} {
        ip_set "parameter.TARGET_CHIP.value" 2
    } elseif {$PROP_VALUE == "Arria 10"} {
        ip_set "parameter.TARGET_CHIP.value" 5
    } else {
        ip_set "parameter.TARGET_CHIP.value" 0
    }
}

proc ::alt_e2550::parameters::replace_parameter { param prop newval } {
    variable parameters
    ::alt_e2550::parameters::replace_element parameters $param $prop $newval
}

proc ::alt_e2550::parameters::replace_element { array param prop newval } {
    upvar 1 $array arr
    set row_num [get_row $arr $param]
    set col_num [get_column $arr $prop]
    set row [lindex $arr $row_num]
    lset row $col_num $newval
    lset arr $row_num $row
}

proc ::alt_e2550::parameters::get_column { array name } {
    set col_num 0
    set header [lindex $array 0]
    foreach col_name $header {
        if { [string compare $name $col_name] == 0 } {
            return $col_num
        }
        incr col_num
    }
    return -1
}

proc ::alt_e2550::parameters::get_row { array name } {
    set row_num 0
    foreach row $array {
        set row_name [lindex $row 0]
        if { [string compare $name $row_name] == 0 } {
            return $row_num
        }
        incr row_num
    }
    return -1
}


proc ::alt_e2550::parameters::chk_qii_ini { }  {
    set show_debug_tab  [get_quartus_ini "show_debug_tab"]
    set unhide_val      [get_quartus_ini "altera_ethernet_25g_arria10_advanced"]

    if {$show_debug_tab} {
        ip_set "parameter.SHOW_DEBUG_TAB.value" "true"
    } else {
        ip_set "parameter.SHOW_DEBUG_TAB.value" "false"
    }

    if {$unhide_val} {
        ip_set "parameter.UNHIDE_ADV.value" "true"          
    } else {
        ip_set "parameter.UNHIDE_ADV.value" "false"         
    } 

}

# set enable_all_designs  [get_quartus_ini "enable_all_designs"]
# Remove ini restriction on hardware design
set enable_all_designs 1
if {$enable_all_designs == 1} {
    set available_boards {"1:Arria 10 GX Transceiver Signal Integrity Development Kit" "0:None"}
    ::alt_e2550::parameters::replace_parameter GEN_SYNTH ENABLED        true
    ::alt_e2550::parameters::replace_parameter GEN_SYNTH DEFAULT_VALUE  1
    ::alt_e2550::parameters::replace_parameter DEV_BOARD DEFAULT_VALUE  1
} else {
    set available_boards {"0:None"}
    ::alt_e2550::parameters::replace_parameter GEN_SYNTH ENABLED        false
    ::alt_e2550::parameters::replace_parameter GEN_SYNTH DEFAULT_VALUE  0
    ::alt_e2550::parameters::replace_parameter DEV_BOARD DEFAULT_VALUE  0
}
::alt_e2550::parameters::replace_parameter DEV_BOARD ALLOWED_RANGES $available_boards
