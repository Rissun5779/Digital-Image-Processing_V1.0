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


package provide altera_xcvr_cal_a10::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::common


namespace eval ::altera_xcvr_cal_a10::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_parameters \
    validate

  variable package_name
  variable val_prefix
  variable display_items
  variable parameters

  set package_name "altera_xcvr_cal_a10::parameters"

  set display_items {\
    { NAME               GROUP             TYPE  ARGS  }\
    {"NIOS Options"       ""                GROUP tab }\
    {"Soft-NIOS OPtions"  "NIOS Options"    GROUP NOVAL }\
    {"Memory  Options"    ""                GROUP tab }\
    {"JTAG Options"       ""                GROUP tab }\
    { "General Options"  ""                GROUP NOVAL }\
  }
    
  set parameters {\
    {NAME                   DERIVED HDL_PARAMETER TYPE          DEFAULT_VALUE         ALLOWED_RANGES                              ENABLED         VISIBLE 		  DISPLAY_HINT    DISPLAY_UNITS      DISPLAY_ITEM         DISPLAY_NAME                                               VALIDATION_CALLBACK                                                  DESCRIPTION }\
    {ENABLE_DFT_SIGNALS     false   false         INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "General Options"     "Enable DFT signals on HW-NIOS "                           NOVAL                                                               "Enables access to DFT signals on PM_UC block"}\
    {ENABLE_PMA_AUX         false   true          INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "General Options"     "Enable PMA AUX"                                           NOVAL                                                               "Enables the direct access to the PMA auxiliary block"}\
    {ENABLE_DFX_SIGNALS     false   false         INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "General Options"     "Enable DFX signals on HW-NIOS "                           NOVAL                                                               "Enables access to DFX signals on PM_UC block"}\
    {ENABLE_CORE_M20K       false   true          INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "Memory  Options"     "Enable core M20K expansion memory"                        NOVAL                                                               "Enables the generation of expansion RAM memory in the PLD core, as part of the Calibration IP, addressable by the Hard-NIOS CPU."}\
    {ENABLE_JTAG_DBG        false   true          INTEGER       1                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "JTAG Options"        "Enable JTAG debug port for hard NIOS"                     NOVAL                                                               "When enabled, the Transceiver Calibration IP provides access to the JTAG interface ports of the Hard-NIOS CPU."}\
    {ENABLE_SOFT_NIOS       false   true          INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "NIOS Options"        "Enable Soft-NIOS CPU (Deactivate HW-NIOS)"                NOVAL                                                               "When enabled, a soft-NIOS subsystem takes control of the calibration. When disabled, the Hard-NIOS is activated instead."}\
    {USR_FILE_NAME          false   true          STRING        "pm_uc.hex"           NOVAL                                       NOVAL           true                    NOVAL           NOVAL             "NIOS Options"        "HEX-Calibration file name"                                NOVAL                                                               "Specifies the name of the executable file to be used by the NIOS-CPU during calibration. File must be in Intel HEX format."}\
    {NIOS_BREAK_VECTOR      false   true          STRING        "0"                   NOVAL                                       NOVAL           true                    hexadecimal     NOVAL             "NIOS Options"        "NIOS break-vector address"                                NOVAL                                                               "Defines the address of the routine entry-point for NIOS to execute after a break-interrupt is received."}\
    {NIOS_EXCEPTION_VECTOR  false   true          STRING        "0"                   NOVAL                                       NOVAL           true                    hexadecimal     NOVAL             "NIOS Options"        "NIOS exception-vector address"                            NOVAL                                                               "Defines the address of the routine entry-point for NIOS to execute after an exception-interrupt is received."}\
    {NIOS_RESET_VECTOR      false   true          STRING        "0"                   NOVAL                                       NOVAL           true                    hexadecimal     NOVAL             "NIOS Options"        "NIOS reset-vector address"                                NOVAL                                                               "Defines the address of the entry-point for NIOS to execute after a reset is received"}\
    {uc_core_clksel_gui     false   false         INTEGER       0                     NOVAL                                       NOVAL           true                    boolean         NOVAL             "NIOS Options"       "Enable CORE_CLK as NIOS clock source"                     NOVAL                                                               "When enabled, the PLD_CLK becomes the clock source for the Hard-NIOS, overriding any other selection."}\
    {UC_CORE_CLKSEL         true    true          STRING        "DISABLE_CORE_CLK"    NOVAL                                       NOVAL           false                   NOVAL           NOVAL              NOVAL                NOVAL                                                      ::altera_xcvr_cal_a10::parameters::validate_uc_core_clksel       NOVAL      }\
    {UC_CLK_SRC             false   true          STRING        "CB_CLKUSR"           {"CB_CLKUSR" "CB_INTOSC"}                   NOVAL           !UC_CORE_CLKSEL_GUI     boolean         NOVAL             "NIOS Options"        "       Select Default NIOS clock source"                  NOVAL                                                               "Selects between the USR_CLK and the INT_OSC clock as clock source for the Hard-NIOS."}\
    {M20K_SIZE              false   true          INTEGER        512                 {512 1024 2048 4096 8192 16384} NOVAL           ENABLE_CORE_M20K        boolean         NOVAL             "Memory  Options"     "       Specify expansion memory size(in 32-bits words)"   NOVAL                                                               "Specifies the size of the expansion memory to be connect to the Hard-NIOS"}\
  }

}

proc ::altera_xcvr_cal_a10::parameters::declare_parameters {} {
  variable display_items
  variable parameters
  ip_declare_display_items $display_items
  ip_declare_parameters $parameters

}

proc ::altera_xcvr_cal_a10::parameters::validate {} {
  ip_validate_parameters
}

##########################################################################
####################### Validation Callbacks #############################

###

###
# Validation for UC_CORE_CLKSEL
proc ::altera_xcvr_cal_a10::parameters::validate_uc_core_clksel { uc_core_clksel_gui } {
  if {$uc_core_clksel_gui == 1} {
    set uc_core_clksel "ENABLE_CORE_CLK"
  } else {
    set uc_core_clksel "DISABLE_CORE_CLK"
  }
  ip_set "parameter.uc_core_clksel.value" $uc_core_clksel
}



####################### Validation Callbacks #############################
##########################################################################
