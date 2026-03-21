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


package require -exact qsys 13.1

set alt_xcvr_packages_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages"
if { [lsearch -exact $auto_path $alt_xcvr_packages_dir] == -1 } {
    lappend auto_path $alt_xcvr_packages_dir
}

package require alt_xcvr::utils::common
namespace import ::alt_xcvr::utils::common::map_allowed_range
namespace import ::alt_xcvr::utils::common::get_mapped_allowed_range_value

#+-------------------------------------------
#|
#|  source files
#|
#+-------------------------------------------
source  clearbox.tcl
source altera_soft_lvds_hw_extra.tcl


#+-------------------------------------------
#|
#|  Filesets
#|
#+-------------------------------------------

add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim

#+--------------------------------------------
#|
#|  module property
#|
#+--------------------------------------------
set_module_property   NAME         "altera_soft_lvds"
set_module_property   AUTHOR       "Intel Corporation"
set_module_property   DESCRIPTION  "Soft LVDS Intel FPGA IP"
set_module_property   VERSION      18.1
set_module_property   DISPLAY_NAME "Soft LVDS Intel FPGA IP"
set_module_property   DESCRIPTION  "Soft LVDS Intel FPGA IP using core logic elements."
set_module_property   EDITABLE      false
set_module_property   GROUP        "Basic Functions/I\/O"
set_module_property   HIDE_FROM_QSYS true

set supported_device_families_list {"MAX 10 FPGA"}

set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list
#+--------------------------------------------
#|
#|  device family info
#|
#+--------------------------------------------
add_parameter           DEVICE_FAMILY    STRING          "MAX 10 FPGA"
set_parameter_property  DEVICE_FAMILY    DISPLAY_NAME    "Device family"
set_parameter_property  DEVICE_FAMILY    SYSTEM_INFO     "device_family"
set_parameter_property  DEVICE_FAMILY    VISIBLE         false
set_parameter_property  DEVICE_FAMILY    DESCRIPTION     "Specifies which device family is currently selected."

#+--------------------------------------------
#|
#|  Display Item
#|
#+--------------------------------------------

add_display_item "" "General" GROUP tab
add_display_item "" "PLL Settings" GROUP tab
add_display_item "" "Receiver Settings" GROUP tab
add_display_item "Receiver Settings" "Bitslip Settings" GROUP
add_display_item "Receiver Settings" "Output Synchronization Buffer Implementation Settings" GROUP
add_display_item "" "Transmitter Settings" GROUP tab

# -------------------------------------------------------------------------------------------------------------- #
#    COMMON BLOCK parameter declarations
# -------------------------------------------------------------------------------------------------------------- #
add_parameter           DEVICE_TYPE    STRING "Dual Supply"
set_parameter_property  DEVICE_TYPE    DISPLAY_NAME "Power Supply Mode"
set_parameter_property  DEVICE_TYPE    GROUP        "General"
set_parameter_property  DEVICE_TYPE    VISIBLE        true
set_parameter_property  DEVICE_TYPE    ALLOWED_RANGES {"Dual Supply" "Single Supply"}
set_parameter_property  DEVICE_TYPE    AFFECTS_GENERATION   true
set_parameter_property  DEVICE_TYPE    HDL_PARAMETER false
set_parameter_property  DEVICE_TYPE    DESCRIPTION        ""
add_parameter           FUNCTIONAL_MODE    STRING "RX"
set_parameter_property  FUNCTIONAL_MODE    DISPLAY_NAME "Functional mode"
set_parameter_property  FUNCTIONAL_MODE    GROUP        "General"
set_parameter_property  FUNCTIONAL_MODE    VISIBLE        true
set_parameter_property  FUNCTIONAL_MODE    ALLOWED_RANGES {"TX" "RX"}
set_parameter_property  FUNCTIONAL_MODE    AFFECTS_GENERATION   true
set_parameter_property  FUNCTIONAL_MODE    HDL_PARAMETER false
set_parameter_property  FUNCTIONAL_MODE    DESCRIPTION        ""

add_parameter           FUNCTIONAL_MODE_UI_BOOL    BOOLEAN 0
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    DISPLAY_NAME "Functional Mode:"
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    VISIBLE        false
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    DERIVED        true
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    AFFECTS_GENERATION   true
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    HDL_PARAMETER false
set_parameter_property  FUNCTIONAL_MODE_UI_BOOL    DESCRIPTION        ""

add_parameter           NUMBER_OF_CHANNELS    INTEGER "1"
set_parameter_property  NUMBER_OF_CHANNELS    DISPLAY_NAME "Number of channels"
set_parameter_property  NUMBER_OF_CHANNELS    GROUP        "General"
set_parameter_property  NUMBER_OF_CHANNELS    VISIBLE    true
set_parameter_property  NUMBER_OF_CHANNELS    ALLOWED_RANGES    {"1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18"}
set_parameter_property  NUMBER_OF_CHANNELS    AFFECTS_GENERATION   true
set_parameter_property  NUMBER_OF_CHANNELS    HDL_PARAMETER false
set_parameter_property  NUMBER_OF_CHANNELS    DESCRIPTION        ""

add_parameter           WIDTH    INTEGER "1"
set_parameter_property  WIDTH    DISPLAY_NAME "Number of channels"
set_parameter_property  WIDTH    GROUP        "General"
set_parameter_property  WIDTH    VISIBLE    false
set_parameter_property  WIDTH    DERIVED    true
set_parameter_property  WIDTH    ALLOWED_RANGES    {"1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18"}
set_parameter_property  WIDTH    AFFECTS_GENERATION   true
set_parameter_property  WIDTH    HDL_PARAMETER false
set_parameter_property  WIDTH    DESCRIPTION        ""

add_parameter           LPM_WIDTH    INTEGER "1"
set_parameter_property  LPM_WIDTH    VISIBLE    false
set_parameter_property  LPM_WIDTH    DERIVED    true
set_parameter_property  LPM_WIDTH    ALLOWED_RANGES    {"1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18"}
set_parameter_property  LPM_WIDTH    AFFECTS_GENERATION   true
set_parameter_property  LPM_WIDTH    HDL_PARAMETER false
set_parameter_property  LPM_WIDTH    DESCRIPTION        ""

add_parameter           DESERIALIZATION_FACTOR INTEGER 4
set_parameter_property  DESERIALIZATION_FACTOR DISPLAY_NAME "SERDES factor"
set_parameter_property  DESERIALIZATION_FACTOR GROUP "General"
set_parameter_property  DESERIALIZATION_FACTOR VISIBLE true
set_parameter_property  DESERIALIZATION_FACTOR ALLOWED_RANGES {"1" "2" "4" "5" "6" "7" "8" "9" "10" }
set_parameter_property  DESERIALIZATION_FACTOR AFFECTS_GENERATION    true
set_parameter_property  DESERIALIZATION_FACTOR HDL_PARAMETER false
set_parameter_property  DESERIALIZATION_FACTOR DESCRIPTION        ""
set_parameter_update_callback DESERIALIZATION_FACTOR update_settings_datawidth

#+--------------------------------------------
#|
#|  'PLL Settings' tab
#|
#+--------------------------------------------
add_parameter           USE_EXTERNAL_PLL_UI BOOLEAN 0
set_parameter_property  USE_EXTERNAL_PLL_UI DISPLAY_NAME "Use external PLL"
set_parameter_property  USE_EXTERNAL_PLL_UI GROUP "PLL Settings"
set_parameter_property  USE_EXTERNAL_PLL_UI AFFECTS_GENERATION    true
set_parameter_property  USE_EXTERNAL_PLL_UI HDL_PARAMETER false
set_parameter_property  USE_EXTERNAL_PLL_UI DESCRIPTION        ""

add_parameter           USE_EXTERNAL_PLL STRING "OFF"
set_parameter_property  USE_EXTERNAL_PLL GROUP "PLL Settings"
set_parameter_property  USE_EXTERNAL_PLL AFFECTS_GENERATION    true
set_parameter_property  USE_EXTERNAL_PLL HDL_PARAMETER false
set_parameter_property  USE_EXTERNAL_PLL DERIVED true
set_parameter_property  USE_EXTERNAL_PLL VISIBLE false
set_parameter_property  USE_EXTERNAL_PLL DESCRIPTION        ""

add_parameter           INPUT_DATA_RATE FLOAT 720.0
set_parameter_property  INPUT_DATA_RATE DISPLAY_NAME "Data rate"
set_parameter_property  INPUT_DATA_RATE ENABLED true
set_parameter_property  INPUT_DATA_RATE GROUP "PLL Settings"
set_parameter_property  INPUT_DATA_RATE DISPLAY_UNITS "Mbps"
set_parameter_property  INPUT_DATA_RATE AFFECTS_GENERATION    true
set_parameter_property  INPUT_DATA_RATE HDL_PARAMETER false
set_parameter_property  INPUT_DATA_RATE DESCRIPTION        ""

# ###############################################################################
# IPTAF
add_parameter           VALID_FREQ STRING "200.00"
set_parameter_property  VALID_FREQ DEFAULT_VALUE "200.00"
set_parameter_property  VALID_FREQ DISPLAY_NAME "Inclock frequency"
set_parameter_property  VALID_FREQ VISIBLE true
set_parameter_property  VALID_FREQ DISPLAY_UNITS "MHz"
set_parameter_property  VALID_FREQ GROUP "PLL Settings"
set_parameter_property  VALID_FREQ AFFECTS_GENERATION true
set_parameter_property  VALID_FREQ HDL_PARAMETER false
set_parameter_property  VALID_FREQ DESCRIPTION        ""
# #################################################################################

add_parameter           ENABLE_RX_LOCKED_PORT_UI BOOLEAN 0
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI DISPLAY_NAME "Enable rx_locked port"
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI VISIBLE true
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI GROUP "PLL Settings"
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_RX_LOCKED_PORT_UI DESCRIPTION        ""

add_parameter           ENABLE_TX_LOCKED_PORT_UI BOOLEAN 0
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI DISPLAY_NAME "Enable tx_locked port"
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI VISIBLE true
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI GROUP "PLL Settings"
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_TX_LOCKED_PORT_UI DESCRIPTION        ""

# -------------Always expose pll_areset to user--------------------------------------#
add_parameter           ENABLE_PLL_ARESET_PORT_UI BOOLEAN 1
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI DISPLAY_NAME "Enable pll_areset port"
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI VISIBLE true
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI GROUP "PLL Settings"
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_PLL_ARESET_PORT_UI DESCRIPTION        ""

add_parameter           ENABLE_PLL_TX_DATA_RESET_PORT_UI BOOLEAN 0
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI DISPLAY_NAME "Enable tx_data_reset port"
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI VISIBLE true
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI GROUP "PLL Settings"
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_PLL_TX_DATA_RESET_PORT_UI DESCRIPTION        ""

add_parameter           ENABLE_PLL_RX_DATA_RESET_PORT_UI BOOLEAN 0
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI DISPLAY_NAME "Enable rx_data_reset port"
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI VISIBLE true
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI GROUP "PLL Settings"
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_PLL_RX_DATA_RESET_PORT_UI DESCRIPTION        ""

add_parameter           COMMON_RX_TX_PLL_UI BOOLEAN 0
set_parameter_property  COMMON_RX_TX_PLL_UI DISPLAY_NAME "Use common PLL(s) for receivers and transmitters."
set_parameter_property  COMMON_RX_TX_PLL_UI VISIBLE true
set_parameter_property  COMMON_RX_TX_PLL_UI GROUP "PLL Settings"
set_parameter_property  COMMON_RX_TX_PLL_UI AFFECTS_GENERATION    true
set_parameter_property  COMMON_RX_TX_PLL_UI HDL_PARAMETER false
set_parameter_property  COMMON_RX_TX_PLL_UI DESCRIPTION        ""

add_parameter           COMMON_RX_TX_PLL STRING "ON"
set_parameter_property  COMMON_RX_TX_PLL DISPLAY_NAME "Use common PLL(s) for receivers and transmitters."
set_parameter_property  COMMON_RX_TX_PLL VISIBLE false
set_parameter_property  COMMON_RX_TX_PLL DERIVED true
set_parameter_property  COMMON_RX_TX_PLL AFFECTS_GENERATION    true
set_parameter_property  COMMON_RX_TX_PLL HDL_PARAMETER false
set_parameter_property  COMMON_RX_TX_PLL DESCRIPTION        ""

add_parameter           PLL_SELF_RESET_ON_LOSS_LOCK_UI BOOLEAN 0
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI DISPLAY_NAME "Enable self-reset on loss lock in PLL"
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI VISIBLE true
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI GROUP "PLL Settings"
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI AFFECTS_GENERATION    true
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI HDL_PARAMETER false
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK_UI DESCRIPTION        ""

add_parameter           PLL_SELF_RESET_ON_LOSS_LOCK STRING "OFF"
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK DISPLAY_NAME "Enable self-reset on loss lock in PLL"
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK VISIBLE false
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK DERIVED true
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK AFFECTS_GENERATION    true
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK HDL_PARAMETER false
set_parameter_property  PLL_SELF_RESET_ON_LOSS_LOCK DESCRIPTION        ""

# add_parameter           INCLOCK_PERIOD_UI FLOAT 100.00
# set_parameter_property  INCLOCK_PERIOD_UI DISPLAY_NAME "Desired Inclock Frequency"
# set_parameter_property  INCLOCK_PERIOD_UI VISIBLE false
# set_parameter_property  INCLOCK_PERIOD_UI DISPLAY_UNITS "MHz"
# set_parameter_property  INCLOCK_PERIOD_UI GROUP "PLL Settings"
# set_parameter_property  INCLOCK_PERIOD_UI AFFECTS_GENERATION true
# set_parameter_property  INCLOCK_PERIOD_UI HDL_PARAMETER false
# set_parameter_property  INCLOCK_PERIOD_UI DESCRIPTION        ""

add_parameter           INCLOCK_PERIOD INTEGER 10000
set_parameter_property  INCLOCK_PERIOD VISIBLE false
set_parameter_property  INCLOCK_PERIOD DERIVED true
set_parameter_property  INCLOCK_PERIOD AFFECTS_GENERATION    true
set_parameter_property  INCLOCK_PERIOD HDL_PARAMETER false
set_parameter_property  INCLOCK_PERIOD DESCRIPTION        ""
# ###################################################################################################

# -------------------------------------------------------------------------------------------------------------- #
#    RX BLOCK parameter declarations
# -------------------------------------------------------------------------------------------------------------- #
#+--------------------------------------------
#|
#|  'Receiver Settings' tab
#|
#+--------------------------------------------
add_parameter           PORT_RX_DATA_ALIGN_UI BOOLEAN 0
set_parameter_property  PORT_RX_DATA_ALIGN_UI DISPLAY_NAME "Enable bitslip mode"
set_parameter_property  PORT_RX_DATA_ALIGN_UI VISIBLE true
set_parameter_property  PORT_RX_DATA_ALIGN_UI GROUP "Bitslip Settings"
set_parameter_property  PORT_RX_DATA_ALIGN_UI AFFECTS_GENERATION    true
set_parameter_property  PORT_RX_DATA_ALIGN_UI HDL_PARAMETER false
set_parameter_property  PORT_RX_DATA_ALIGN_UI DESCRIPTION        ""

# Check whether associated with rx_channel_data_align
add_parameter           PORT_RX_DATA_ALIGN STRING "PORT_UNUSED"
set_parameter_property  PORT_RX_DATA_ALIGN DISPLAY_NAME "Enable bitslip mode"
set_parameter_property  PORT_RX_DATA_ALIGN VISIBLE false
set_parameter_property  PORT_RX_DATA_ALIGN DERIVED true
set_parameter_property  PORT_RX_DATA_ALIGN AFFECTS_GENERATION    true
set_parameter_property  PORT_RX_DATA_ALIGN HDL_PARAMETER false
set_parameter_property  PORT_RX_DATA_ALIGN DESCRIPTION        ""

add_parameter           PORT_RX_CHANNEL_DATA_ALIGN_UI BOOLEAN 0
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI DISPLAY_NAME "Enable independent bitslip controls for each channel"
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI VISIBLE true
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI GROUP "Bitslip Settings"
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI AFFECTS_GENERATION    true
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI HDL_PARAMETER false
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN_UI DESCRIPTION        ""

# Check whether associated with rx_channel_data_align
add_parameter           PORT_RX_CHANNEL_DATA_ALIGN STRING "PORT_UNUSED"
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN DISPLAY_NAME ""
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN VISIBLE false
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN DERIVED true
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN AFFECTS_GENERATION    true
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN HDL_PARAMETER false
set_parameter_property  PORT_RX_CHANNEL_DATA_ALIGN DESCRIPTION        ""

add_parameter           USE_CDA_RESET_UI BOOLEAN 1
set_parameter_property  USE_CDA_RESET_UI DISPLAY_NAME "Enable rx_cda_reset input port"
set_parameter_property  USE_CDA_RESET_UI VISIBLE true
set_parameter_property  USE_CDA_RESET_UI ENABLED false
set_parameter_property  USE_CDA_RESET_UI GROUP "Bitslip Settings"
set_parameter_property  USE_CDA_RESET_UI AFFECTS_GENERATION    true
set_parameter_property  USE_CDA_RESET_UI HDL_PARAMETER false
set_parameter_property  USE_CDA_RESET_UI DESCRIPTION        ""

add_parameter           PORT_RX_DATA_ALIGN_RESET_UI BOOLEAN 0
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI DISPLAY_NAME "Enable rx_data_align_reset port"
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI VISIBLE true
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI ENABLED false
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI GROUP "Bitslip Settings"
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI AFFECTS_GENERATION    true
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI HDL_PARAMETER false
set_parameter_property  PORT_RX_DATA_ALIGN_RESET_UI DESCRIPTION        ""

add_parameter           REGISTERED_DATA_ALIGN_INPUT_UI BOOLEAN 0
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI DISPLAY_NAME "Add extra register for rx_data_align port"
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI VISIBLE true
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI GROUP "Bitslip Settings"
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI HDL_PARAMETER false
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT_UI DESCRIPTION        ""

add_parameter           REGISTERED_DATA_ALIGN_INPUT STRING "ON"
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT DISPLAY_NAME "Add extra register for rx_data_align port"
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT VISIBLE false
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT DERIVED true
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT HDL_PARAMETER false
set_parameter_property  REGISTERED_DATA_ALIGN_INPUT DESCRIPTION        ""

add_parameter           DATA_ALIGN_ROLLOVER STRING "4"
set_parameter_property  DATA_ALIGN_ROLLOVER DISPLAY_NAME "Bitslip rollover value"
set_parameter_property  DATA_ALIGN_ROLLOVER VISIBLE true
set_parameter_property  DATA_ALIGN_ROLLOVER ALLOWED_RANGES {"1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
set_parameter_property  DATA_ALIGN_ROLLOVER GROUP "Bitslip Settings"
set_parameter_property  DATA_ALIGN_ROLLOVER AFFECTS_GENERATION    true
set_parameter_property  DATA_ALIGN_ROLLOVER HDL_PARAMETER false
set_parameter_property  DATA_ALIGN_ROLLOVER DESCRIPTION        ""

add_parameter           REGISTERED_OUTPUT_UI BOOLEAN 1
set_parameter_property  REGISTERED_OUTPUT_UI DISPLAY_NAME "Register outputs"
set_parameter_property  REGISTERED_OUTPUT_UI VISIBLE true
set_parameter_property  REGISTERED_OUTPUT_UI GROUP "Receiver Settings"
set_parameter_property  REGISTERED_OUTPUT_UI AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_OUTPUT_UI HDL_PARAMETER false
set_parameter_property  REGISTERED_OUTPUT_UI DESCRIPTION        ""

add_parameter           REGISTERED_OUTPUT STRING "OFF"
set_parameter_property  REGISTERED_OUTPUT DISPLAY_NAME "REGISTERED_OUTPUT"
set_parameter_property  REGISTERED_OUTPUT VISIBLE false
set_parameter_property  REGISTERED_OUTPUT DERIVED true
set_parameter_property  REGISTERED_OUTPUT AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_OUTPUT HDL_PARAMETER false
set_parameter_property  REGISTERED_OUTPUT DESCRIPTION        ""

add_parameter           OUTCLOCK_PHASE_SHIFT STRING "0.00"
set_parameter_property  OUTCLOCK_PHASE_SHIFT VISIBLE false
set_parameter_property  OUTCLOCK_PHASE_SHIFT DERIVED true
set_parameter_property  OUTCLOCK_PHASE_SHIFT AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_PHASE_SHIFT HDL_PARAMETER false
set_parameter_property  OUTCLOCK_PHASE_SHIFT DESCRIPTION        ""

add_parameter           CORECLOCK_DIVIDE_BY STRING "2"
set_parameter_property  CORECLOCK_DIVIDE_BY VISIBLE false
set_parameter_property  CORECLOCK_DIVIDE_BY DERIVED true
set_parameter_property  CORECLOCK_DIVIDE_BY AFFECTS_GENERATION    true
set_parameter_property  CORECLOCK_DIVIDE_BY HDL_PARAMETER false
set_parameter_property  CORECLOCK_DIVIDE_BY DESCRIPTION        ""
# -------------------------------------------------------------------------------------------------------------- #
#    TX BLOCK parameter declarations
# -------------------------------------------------------------------------------------------------------------- #
add_parameter           ENABLE_TX_OUTCLOCK_PORT_UI BOOLEAN 1
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI DISPLAY_NAME "Enable 'tx_outclock' output port"
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI VISIBLE true
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI GROUP "Transmitter Settings"
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_TX_OUTCLOCK_PORT_UI DESCRIPTION        ""

add_parameter           OUTCLOCK_DIVIDE_BY_UI STRING "4"
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI DISPLAY_NAME "Tx_outclock division factor"
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI VISIBLE true
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI HDL_PARAMETER false
set_parameter_property  OUTCLOCK_DIVIDE_BY_UI DESCRIPTION        ""

add_parameter           OUTCLOCK_DIVIDE_BY STRING "1"
set_parameter_property  OUTCLOCK_DIVIDE_BY DISPLAY_NAME "Tx_outclock division factor"
set_parameter_property  OUTCLOCK_DIVIDE_BY VISIBLE false
set_parameter_property  OUTCLOCK_DIVIDE_BY DERIVED true
set_parameter_property  OUTCLOCK_DIVIDE_BY GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_DIVIDE_BY AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_DIVIDE_BY HDL_PARAMETER false
set_parameter_property  OUTCLOCK_DIVIDE_BY DESCRIPTION        ""

add_parameter           OUTCLOCK_DUTY_CYCLE_UI STRING "50"
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI DISPLAY_NAME "Outclock duty cycle"
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI VISIBLE true
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI HDL_PARAMETER false
set_parameter_property  OUTCLOCK_DUTY_CYCLE_UI DESCRIPTION        ""

add_parameter           OUTCLOCK_DUTY_CYCLE STRING "50"
set_parameter_property  OUTCLOCK_DUTY_CYCLE DISPLAY_NAME "Outclock duty cycle"
set_parameter_property  OUTCLOCK_DUTY_CYCLE VISIBLE false
set_parameter_property  OUTCLOCK_DUTY_CYCLE DERIVED true
set_parameter_property  OUTCLOCK_DUTY_CYCLE GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_DUTY_CYCLE AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_DUTY_CYCLE HDL_PARAMETER false
set_parameter_property  OUTCLOCK_DUTY_CYCLE DESCRIPTION        ""

add_parameter           TX_OUTCLOCK_PHASE_SHIFT_UI STRING "0.00"
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI DISPLAY_NAME "Desired transmitter outclock phase shift"
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI VISIBLE true
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI GROUP "Transmitter Settings"
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI DISPLAY_UNITS "degrees"
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI AFFECTS_GENERATION    true
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI HDL_PARAMETER false
set_parameter_property  TX_OUTCLOCK_PHASE_SHIFT_UI DESCRIPTION        ""

add_parameter           TX_INCLOCK_PHASE_SHIFT_UI STRING "0.00"
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI DISPLAY_NAME "Desired transmitter inclock phase shift"
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI VISIBLE true
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI GROUP "PLL Settings"
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI DISPLAY_UNITS "degrees"
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI AFFECTS_GENERATION    true
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI HDL_PARAMETER false
set_parameter_property  TX_INCLOCK_PHASE_SHIFT_UI DESCRIPTION        ""

add_parameter           RX_INCLOCK_PHASE_SHIFT_UI STRING "0.00"
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI DISPLAY_NAME "Desired receiver inclock phase shift"
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI VISIBLE true
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI GROUP "PLL Settings"
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI DISPLAY_UNITS "degrees"
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI AFFECTS_GENERATION    true
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI HDL_PARAMETER false
set_parameter_property  RX_INCLOCK_PHASE_SHIFT_UI DESCRIPTION        ""

# There is no outclock phase shift needed on RX side.
add_parameter           RX_OUTCLOCK_PHASE_SHIFT_UI STRING "0.00"
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI DISPLAY_NAME "Desired receiver outclock phase shift"
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI VISIBLE false
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI ENABLED false
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI GROUP " "
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI DISPLAY_UNITS "degrees"
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI AFFECTS_GENERATION    true
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI HDL_PARAMETER false
set_parameter_property  RX_OUTCLOCK_PHASE_SHIFT_UI DESCRIPTION        ""

add_parameter           INCLOCK_PHASE_SHIFT STRING "0.00"
set_parameter_property  INCLOCK_PHASE_SHIFT VISIBLE false
set_parameter_property  INCLOCK_PHASE_SHIFT DERIVED true
set_parameter_property  INCLOCK_PHASE_SHIFT AFFECTS_GENERATION    true
set_parameter_property  INCLOCK_PHASE_SHIFT HDL_PARAMETER false
set_parameter_property  INCLOCK_PHASE_SHIFT DESCRIPTION        ""

add_parameter           REGISTERED_INPUT_ENABLED_UI BOOLEAN 0
set_parameter_property  REGISTERED_INPUT_ENABLED_UI DISPLAY_NAME "Register 'tx_in' input port"
set_parameter_property  REGISTERED_INPUT_ENABLED_UI VISIBLE true
set_parameter_property  REGISTERED_INPUT_ENABLED_UI GROUP "Transmitter Settings"
set_parameter_property  REGISTERED_INPUT_ENABLED_UI AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_INPUT_ENABLED_UI HDL_PARAMETER false
set_parameter_property  REGISTERED_INPUT_ENABLED_UI DESCRIPTION        ""

add_parameter           REGISTERED_INPUT_UI STRING "tx_coreclock"
set_parameter_property  REGISTERED_INPUT_UI DISPLAY_NAME "Clock resource"
set_parameter_property  REGISTERED_INPUT_UI VISIBLE true
set_parameter_property  REGISTERED_INPUT_UI ALLOWED_RANGES {"tx_inclock" "tx_coreclock"}
set_parameter_property  REGISTERED_INPUT_UI GROUP "Transmitter Settings"
set_parameter_property  REGISTERED_INPUT_UI AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_INPUT_UI HDL_PARAMETER false
set_parameter_property  REGISTERED_INPUT_UI DESCRIPTION        ""

add_parameter           REGISTERED_INPUT STRING "OFF"
set_parameter_property  REGISTERED_INPUT VISIBLE false
set_parameter_property  REGISTERED_INPUT DERIVED true
set_parameter_property  REGISTERED_INPUT ALLOWED_RANGES {"OFF" "ON" "TX_CLKIN" "TX_CORECLK"}
set_parameter_property  REGISTERED_INPUT GROUP "Transmitter Settings"
set_parameter_property  REGISTERED_INPUT AFFECTS_GENERATION    true
set_parameter_property  REGISTERED_INPUT HDL_PARAMETER false
set_parameter_property  REGISTERED_INPUT DESCRIPTION        ""

add_parameter           ENABLE_TX_CORECLOCK_PORT_UI BOOLEAN 0
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI DISPLAY_NAME "Enable 'tx_coreclock' output port"
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI VISIBLE true
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI GROUP "Transmitter Settings"
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI AFFECTS_GENERATION true
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI HDL_PARAMETER false
set_parameter_property  ENABLE_TX_CORECLOCK_PORT_UI DESCRIPTION        ""

add_parameter           USE_CORECLOCK_INPUT STRING "OFF"
set_parameter_property  USE_CORECLOCK_INPUT DISPLAY_NAME "Enable tx_coreclock port"
set_parameter_property  USE_CORECLOCK_INPUT VISIBLE false
set_parameter_property  USE_CORECLOCK_INPUT DERIVED true
set_parameter_property  USE_CORECLOCK_INPUT GROUP "Transmitter Settings"
set_parameter_property  USE_CORECLOCK_INPUT AFFECTS_GENERATION true
set_parameter_property  USE_CORECLOCK_INPUT HDL_PARAMETER false
set_parameter_property  USE_CORECLOCK_INPUT DESCRIPTION        ""

add_parameter OUTCLOCK_RESOURCE_UI STRING "Auto selection"
set_parameter_property  OUTCLOCK_RESOURCE_UI DISPLAY_NAME "Clock source for 'tx_coreclock'"
set_parameter_property  OUTCLOCK_RESOURCE_UI VISIBLE true
set_parameter_property  OUTCLOCK_RESOURCE_UI ALLOWED_RANGES {"Auto selection" "Global clock" "Regional clock" "Auto selection" "Dual-Regional clock"}
set_parameter_property  OUTCLOCK_RESOURCE_UI GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_RESOURCE_UI AFFECTS_GENERATION true
set_parameter_property  OUTCLOCK_RESOURCE_UI HDL_PARAMETER false
set_parameter_property  OUTCLOCK_RESOURCE_UI DESCRIPTION        ""

add_parameter OUTCLOCK_RESOURCE STRING "AUTO"
set_parameter_property  OUTCLOCK_RESOURCE VISIBLE false
set_parameter_property  OUTCLOCK_RESOURCE DERIVED true
set_parameter_property  OUTCLOCK_RESOURCE GROUP "Transmitter Settings"
set_parameter_property  OUTCLOCK_RESOURCE AFFECTS_GENERATION true
set_parameter_property  OUTCLOCK_RESOURCE HDL_PARAMETER false
set_parameter_property  OUTCLOCK_RESOURCE DESCRIPTION        ""

# BUFFER IMPLEMENTATION
add_parameter BUFFER_IMPLEMENTATION_RAM_UI BOOLEAN 0
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI VISIBLE true
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI GROUP "Output Synchronization Buffer Implementation Settings"
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI DISPLAY_NAME "Use RAM buffer"
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI AFFECTS_GENERATION true
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI HDL_PARAMETER false
set_parameter_property  BUFFER_IMPLEMENTATION_RAM_UI DESCRIPTION        ""

add_parameter BUFFER_IMPLEMENTATION_MUX_UI BOOLEAN 0
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI VISIBLE true
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI GROUP "Output Synchronization Buffer Implementation Settings"
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI DISPLAY_NAME "Use a multiplexer and synchronization register"
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI AFFECTS_GENERATION true
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI HDL_PARAMETER false
set_parameter_property  BUFFER_IMPLEMENTATION_MUX_UI DESCRIPTION        ""

add_parameter BUFFER_IMPLEMENTATION_LE_UI BOOLEAN 0
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI VISIBLE true
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI GROUP "Output Synchronization Buffer Implementation Settings"
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI DISPLAY_NAME "Use logic element based RAM"
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI AFFECTS_GENERATION true
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI HDL_PARAMETER false
set_parameter_property  BUFFER_IMPLEMENTATION_LE_UI DESCRIPTION        ""

add_parameter BUFFER_IMPLEMENTATION STRING "RAM"
set_parameter_property  BUFFER_IMPLEMENTATION VISIBLE false
set_parameter_property  BUFFER_IMPLEMENTATION DERIVED true
set_parameter_property  BUFFER_IMPLEMENTATION GROUP "Output Synchronization Buffer Implementation Settings"
set_parameter_property  BUFFER_IMPLEMENTATION AFFECTS_GENERATION true
set_parameter_property  BUFFER_IMPLEMENTATION HDL_PARAMETER false
set_parameter_property  BUFFER_IMPLEMENTATION DESCRIPTION        ""

add_parameter           OUTPUT_DATA_RATE INTEGER 720
set_parameter_property  OUTPUT_DATA_RATE DISPLAY_NAME "Data rate:"
set_parameter_property  OUTPUT_DATA_RATE ENABLED true
set_parameter_property  OUTPUT_DATA_RATE VISIBLE false
set_parameter_property  OUTPUT_DATA_RATE DERIVED true
set_parameter_property  OUTPUT_DATA_RATE GROUP "PLL Settings"
set_parameter_property  OUTPUT_DATA_RATE DISPLAY_UNITS "Mbps"
set_parameter_property  OUTPUT_DATA_RATE AFFECTS_GENERATION    true
set_parameter_property  OUTPUT_DATA_RATE HDL_PARAMETER false
set_parameter_property  OUTPUT_DATA_RATE DESCRIPTION        ""

# -------------------------------------------------------------------------------------------------------------- #
# Backward compatibility reason
# -------------------------------------------------------------------------------------------------------------- #
# General
add_parameter           IMPLEMENT_IN_LES    STRING "ON"
set_parameter_property  IMPLEMENT_IN_LES    DISPLAY_NAME "IMPLEMENT_IN_LES"
set_parameter_property  IMPLEMENT_IN_LES    VISIBLE false
set_parameter_property  IMPLEMENT_IN_LES    GROUP "General"
set_parameter_property  IMPLEMENT_IN_LES    AFFECTS_GENERATION    true
set_parameter_property  IMPLEMENT_IN_LES    HDL_PARAMETER false
set_parameter_property  IMPLEMENT_IN_LES    DESCRIPTION        ""

add_parameter           DATA_RATE   STRING "720.0 Mbps"
set_parameter_property  DATA_RATE   DISPLAY_NAME "DATA_RATE"
set_parameter_property  DATA_RATE   VISIBLE false
set_parameter_property  DATA_RATE   DERIVED        true
set_parameter_property  DATA_RATE   GROUP "General"
set_parameter_property  DATA_RATE   AFFECTS_GENERATION    true
set_parameter_property  DATA_RATE   HDL_PARAMETER false
set_parameter_property  DATA_RATE   DESCRIPTION        ""

# Rx only
add_parameter           CARRY_CHAIN_LENGTH    INTEGER "48"
set_parameter_property  CARRY_CHAIN_LENGTH    DISPLAY_NAME "CARRY_CHAIN_LENGTH"
set_parameter_property  CARRY_CHAIN_LENGTH    GROUP        "General"
set_parameter_property  CARRY_CHAIN_LENGTH    VISIBLE    false
set_parameter_property  CARRY_CHAIN_LENGTH    AFFECTS_GENERATION   true
set_parameter_property  CARRY_CHAIN_LENGTH    HDL_PARAMETER false
set_parameter_property  CARRY_CHAIN_LENGTH    DESCRIPTION        ""

add_parameter           DPA_INITIAL_PHASE_VALUE    INTEGER "0"
set_parameter_property  DPA_INITIAL_PHASE_VALUE    DISPLAY_NAME "DPA_INITIAL_PHASE_VALUE"
set_parameter_property  DPA_INITIAL_PHASE_VALUE    GROUP        "General"
set_parameter_property  DPA_INITIAL_PHASE_VALUE    VISIBLE    false
set_parameter_property  DPA_INITIAL_PHASE_VALUE    AFFECTS_GENERATION   true
set_parameter_property  DPA_INITIAL_PHASE_VALUE    HDL_PARAMETER false
set_parameter_property  DPA_INITIAL_PHASE_VALUE    DESCRIPTION        ""

add_parameter           DPLL_LOCK_COUNT     INTEGER "0"
set_parameter_property  DPLL_LOCK_COUNT     DISPLAY_NAME "DPLL_LOCK_COUNT"
set_parameter_property  DPLL_LOCK_COUNT     GROUP        "General"
set_parameter_property  DPLL_LOCK_COUNT     VISIBLE    false
set_parameter_property  DPLL_LOCK_COUNT     AFFECTS_GENERATION   true
set_parameter_property  DPLL_LOCK_COUNT     HDL_PARAMETER false
set_parameter_property  DPLL_LOCK_COUNT     DESCRIPTION        ""

add_parameter           DPLL_LOCK_WINDOW    INTEGER "0"
set_parameter_property  DPLL_LOCK_WINDOW    DISPLAY_NAME "DPLL_LOCK_WINDOW"
set_parameter_property  DPLL_LOCK_WINDOW    GROUP        "General"
set_parameter_property  DPLL_LOCK_WINDOW    VISIBLE    false
set_parameter_property  DPLL_LOCK_WINDOW    AFFECTS_GENERATION   true
set_parameter_property  DPLL_LOCK_WINDOW    HDL_PARAMETER false
set_parameter_property  DPLL_LOCK_WINDOW    DESCRIPTION        ""

add_parameter           INCLOCK_BOOST   INTEGER "0"
set_parameter_property  INCLOCK_BOOST   DISPLAY_NAME "INCLOCK_BOOST"
set_parameter_property  INCLOCK_BOOST   GROUP        "General"
set_parameter_property  INCLOCK_BOOST   VISIBLE    false
set_parameter_property  INCLOCK_BOOST   AFFECTS_GENERATION   true
set_parameter_property  INCLOCK_BOOST   HDL_PARAMETER false
set_parameter_property  INCLOCK_BOOST   DESCRIPTION        ""

add_parameter           SIM_DPA_NET_PPM_VARIATION   INTEGER "0"
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   DISPLAY_NAME "SIM_DPA_NET_PPM_VARIATION"
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   GROUP        "General"
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   VISIBLE    false
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   AFFECTS_GENERATION   true
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   HDL_PARAMETER false
set_parameter_property  SIM_DPA_NET_PPM_VARIATION   DESCRIPTION        ""

add_parameter           SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    INTEGER "0"
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    DISPLAY_NAME "SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT"
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    GROUP        "General"
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    VISIBLE    false
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    AFFECTS_GENERATION   true
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    HDL_PARAMETER false
set_parameter_property  SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT    DESCRIPTION        ""

add_parameter           CARRY_CHAIN     STRING "MANUAL"
set_parameter_property  CARRY_CHAIN     DISPLAY_NAME "CARRY_CHAIN"
set_parameter_property  CARRY_CHAIN     VISIBLE false
set_parameter_property  CARRY_CHAIN     GROUP "General"
set_parameter_property  CARRY_CHAIN     AFFECTS_GENERATION    true
set_parameter_property  CARRY_CHAIN     HDL_PARAMETER false
set_parameter_property  CARRY_CHAIN     DESCRIPTION        ""

add_parameter           CYCLONEII_M4K_COMPATIBILITY     STRING "ON"
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     DISPLAY_NAME "CYCLONEII_M4K_COMPATIBILITY"
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     VISIBLE false
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     GROUP "General"
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     AFFECTS_GENERATION    true
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     HDL_PARAMETER false
set_parameter_property  CYCLONEII_M4K_COMPATIBILITY     DESCRIPTION        ""

add_parameter           ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    STRING "OFF"
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    DISPLAY_NAME "ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY"
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    VISIBLE false
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    GROUP "General"
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    AFFECTS_GENERATION    true
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    HDL_PARAMETER false
set_parameter_property  ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY    DESCRIPTION        ""

add_parameter           ENABLE_DPA_CALIBRATION  STRING "ON"
set_parameter_property  ENABLE_DPA_CALIBRATION  DISPLAY_NAME "ENABLE_DPA_CALIBRATION"
set_parameter_property  ENABLE_DPA_CALIBRATION  VISIBLE false
set_parameter_property  ENABLE_DPA_CALIBRATION  GROUP "General"
set_parameter_property  ENABLE_DPA_CALIBRATION  AFFECTS_GENERATION    true
set_parameter_property  ENABLE_DPA_CALIBRATION  HDL_PARAMETER false
set_parameter_property  ENABLE_DPA_CALIBRATION  DESCRIPTION        ""

add_parameter           ENABLE_DPA_INITIAL_PHASE_SELECTION  STRING "OFF"
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  DISPLAY_NAME "ENABLE_DPA_INITIAL_PHASE_SELECTION"
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  VISIBLE false
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  GROUP "General"
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  AFFECTS_GENERATION    true
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  HDL_PARAMETER false
set_parameter_property  ENABLE_DPA_INITIAL_PHASE_SELECTION  DESCRIPTION        ""

add_parameter           ENABLE_DPA_MODE     STRING "OFF"
set_parameter_property  ENABLE_DPA_MODE     DISPLAY_NAME "ENABLE_DPA_MODE"
set_parameter_property  ENABLE_DPA_MODE     VISIBLE false
set_parameter_property  ENABLE_DPA_MODE     GROUP "General"
set_parameter_property  ENABLE_DPA_MODE     AFFECTS_GENERATION    true
set_parameter_property  ENABLE_DPA_MODE     HDL_PARAMETER false
set_parameter_property  ENABLE_DPA_MODE     DESCRIPTION        ""

add_parameter           ENABLE_DPA_PLL_CALIBRATION  STRING "OFF"
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  DISPLAY_NAME "ENABLE_DPA_PLL_CALIBRATION"
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  VISIBLE false
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  GROUP "General"
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  AFFECTS_GENERATION    true
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  HDL_PARAMETER false
set_parameter_property  ENABLE_DPA_PLL_CALIBRATION  DESCRIPTION        ""

add_parameter           ENABLE_SOFT_CDR_MODE    STRING "OFF"
set_parameter_property  ENABLE_SOFT_CDR_MODE    DISPLAY_NAME "ENABLE_SOFT_CDR_MODE"
set_parameter_property  ENABLE_SOFT_CDR_MODE    VISIBLE false
set_parameter_property  ENABLE_SOFT_CDR_MODE    GROUP "General"
set_parameter_property  ENABLE_SOFT_CDR_MODE    AFFECTS_GENERATION    true
set_parameter_property  ENABLE_SOFT_CDR_MODE    HDL_PARAMETER false
set_parameter_property  ENABLE_SOFT_CDR_MODE    DESCRIPTION        ""

add_parameter           INCLOCK_DATA_ALIGNMENT  STRING "EDGE_ALIGNED"
set_parameter_property  INCLOCK_DATA_ALIGNMENT  DISPLAY_NAME "INCLOCK_DATA_ALIGNMENT"
set_parameter_property  INCLOCK_DATA_ALIGNMENT  VISIBLE false
set_parameter_property  INCLOCK_DATA_ALIGNMENT  GROUP "General"
set_parameter_property  INCLOCK_DATA_ALIGNMENT  AFFECTS_GENERATION    true
set_parameter_property  INCLOCK_DATA_ALIGNMENT  HDL_PARAMETER false
set_parameter_property  INCLOCK_DATA_ALIGNMENT  DESCRIPTION        ""

add_parameter           LOW_POWER_MODE    STRING "AUTO"
set_parameter_property  LOW_POWER_MODE    DISPLAY_NAME "LOW_POWER_MODE"
set_parameter_property  LOW_POWER_MODE    VISIBLE false
set_parameter_property  LOW_POWER_MODE    GROUP "General"
set_parameter_property  LOW_POWER_MODE    AFFECTS_GENERATION    true
set_parameter_property  LOW_POWER_MODE    HDL_PARAMETER false
set_parameter_property  LOW_POWER_MODE    DESCRIPTION        ""

add_parameter           SIM_DPA_IS_NEGATIVE_PPM_DRIFT   STRING "OFF"
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   DISPLAY_NAME "SIM_DPA_IS_NEGATIVE_PPM_DRIFT"
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   VISIBLE false
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   GROUP "General"
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   AFFECTS_GENERATION    true
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   HDL_PARAMETER false
set_parameter_property  SIM_DPA_IS_NEGATIVE_PPM_DRIFT   DESCRIPTION        ""

add_parameter           USE_DPLL_RAWPERROR  STRING "OFF"
set_parameter_property  USE_DPLL_RAWPERROR  DISPLAY_NAME "USE_DPLL_RAWPERROR"
set_parameter_property  USE_DPLL_RAWPERROR  VISIBLE false
set_parameter_property  USE_DPLL_RAWPERROR  GROUP "General"
set_parameter_property  USE_DPLL_RAWPERROR  AFFECTS_GENERATION    true
set_parameter_property  USE_DPLL_RAWPERROR  HDL_PARAMETER false
set_parameter_property  USE_DPLL_RAWPERROR  DESCRIPTION        ""

add_parameter           USE_NO_PHASE_SHIFT  STRING "ON"
set_parameter_property  USE_NO_PHASE_SHIFT  DISPLAY_NAME "USE_NO_PHASE_SHIFT"
set_parameter_property  USE_NO_PHASE_SHIFT  VISIBLE false
set_parameter_property  USE_NO_PHASE_SHIFT  GROUP "General"
set_parameter_property  USE_NO_PHASE_SHIFT  AFFECTS_GENERATION    true
set_parameter_property  USE_NO_PHASE_SHIFT  HDL_PARAMETER false
set_parameter_property  USE_NO_PHASE_SHIFT  DESCRIPTION        ""

add_parameter           X_ON_BITSLIP    STRING "ON"
set_parameter_property  X_ON_BITSLIP    DISPLAY_NAME "X_ON_BITSLIP"
set_parameter_property  X_ON_BITSLIP    VISIBLE false
set_parameter_property  X_ON_BITSLIP    GROUP "General"
set_parameter_property  X_ON_BITSLIP    AFFECTS_GENERATION    true
set_parameter_property  X_ON_BITSLIP    HDL_PARAMETER false
set_parameter_property  X_ON_BITSLIP    DESCRIPTION        ""


# Tx only
add_parameter           DIFFERENTIAL_DRIVE  INTEGER "0"
set_parameter_property  DIFFERENTIAL_DRIVE  DISPLAY_NAME "DIFFERENTIAL_DRIVE"
set_parameter_property  DIFFERENTIAL_DRIVE  GROUP        "General"
set_parameter_property  DIFFERENTIAL_DRIVE  VISIBLE    false
set_parameter_property  DIFFERENTIAL_DRIVE  AFFECTS_GENERATION   true
set_parameter_property  DIFFERENTIAL_DRIVE  HDL_PARAMETER false
set_parameter_property  DIFFERENTIAL_DRIVE  DESCRIPTION        ""

add_parameter           ENABLE_CLK_LATENCY  STRING "OFF"
set_parameter_property  ENABLE_CLK_LATENCY  DISPLAY_NAME "ENABLE_CLK_LATENCY"
set_parameter_property  ENABLE_CLK_LATENCY  VISIBLE false
set_parameter_property  ENABLE_CLK_LATENCY  GROUP "General"
set_parameter_property  ENABLE_CLK_LATENCY  AFFECTS_GENERATION    true
set_parameter_property  ENABLE_CLK_LATENCY  HDL_PARAMETER false
set_parameter_property  ENABLE_CLK_LATENCY  DESCRIPTION        ""

add_parameter           MULTI_CLOCK  STRING "OFF"
set_parameter_property  MULTI_CLOCK  DISPLAY_NAME "MULTI_CLOCK"
set_parameter_property  MULTI_CLOCK  VISIBLE false
set_parameter_property  MULTI_CLOCK  GROUP "General"
set_parameter_property  MULTI_CLOCK  AFFECTS_GENERATION    true
set_parameter_property  MULTI_CLOCK  HDL_PARAMETER false
set_parameter_property  MULTI_CLOCK  DESCRIPTION        ""

add_parameter           OUTCLOCK_ALIGNMENT  STRING "EDGE_ALIGNED"
set_parameter_property  OUTCLOCK_ALIGNMENT  DISPLAY_NAME "OUTCLOCK_ALIGNMENT"
set_parameter_property  OUTCLOCK_ALIGNMENT  VISIBLE false
set_parameter_property  OUTCLOCK_ALIGNMENT  GROUP "General"
set_parameter_property  OUTCLOCK_ALIGNMENT  AFFECTS_GENERATION    true
set_parameter_property  OUTCLOCK_ALIGNMENT  HDL_PARAMETER false
set_parameter_property  OUTCLOCK_ALIGNMENT  DESCRIPTION        ""

add_parameter           OUTCLOCK_MULTIPLY_BY    INTEGER "1"
set_parameter_property  OUTCLOCK_MULTIPLY_BY    DISPLAY_NAME "OUTCLOCK_MULTIPLY_BY"
set_parameter_property  OUTCLOCK_MULTIPLY_BY    GROUP        "General"
set_parameter_property  OUTCLOCK_MULTIPLY_BY    VISIBLE    false
set_parameter_property  OUTCLOCK_MULTIPLY_BY    DERIVED        true
set_parameter_property  OUTCLOCK_MULTIPLY_BY    AFFECTS_GENERATION   true
set_parameter_property  OUTCLOCK_MULTIPLY_BY    HDL_PARAMETER false
set_parameter_property  OUTCLOCK_MULTIPLY_BY    DESCRIPTION        ""

add_parameter           PLL_COMPENSATION_MODE    STRING "AUTO"
set_parameter_property  PLL_COMPENSATION_MODE    DISPLAY_NAME "PLL_COMPENSATION_MODE"
set_parameter_property  PLL_COMPENSATION_MODE    VISIBLE false
set_parameter_property  PLL_COMPENSATION_MODE    GROUP "General"
set_parameter_property  PLL_COMPENSATION_MODE    AFFECTS_GENERATION    true
set_parameter_property  PLL_COMPENSATION_MODE    HDL_PARAMETER false
set_parameter_property  PLL_COMPENSATION_MODE    DESCRIPTION        ""

add_parameter           PREEMPHASIS_SETTING     INTEGER "0"
set_parameter_property  PREEMPHASIS_SETTING     DISPLAY_NAME "PREEMPHASIS_SETTING"
set_parameter_property  PREEMPHASIS_SETTING     GROUP        "General"
set_parameter_property  PREEMPHASIS_SETTING     VISIBLE    false
set_parameter_property  PREEMPHASIS_SETTING     AFFECTS_GENERATION   true
set_parameter_property  PREEMPHASIS_SETTING     HDL_PARAMETER false
set_parameter_property  PREEMPHASIS_SETTING     DESCRIPTION        ""

add_parameter           VOD_SETTING     INTEGER "0"
set_parameter_property  VOD_SETTING     DISPLAY_NAME "VOD_SETTING"
set_parameter_property  VOD_SETTING     GROUP        "General"
set_parameter_property  VOD_SETTING     VISIBLE    false
set_parameter_property  VOD_SETTING     AFFECTS_GENERATION   true
set_parameter_property  VOD_SETTING     HDL_PARAMETER false
set_parameter_property  VOD_SETTING     DESCRIPTION        ""


#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus synth
#|
#+-------------------------------------------------------------------------------------------------------------------------
proc do_quartus_synth {output_name} {
    send_message    info    "Generating top-level entity $output_name."

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.v]

    # Get all parameters and ports
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set ip_mode [get_parameter_value FUNCTIONAL_MODE]
    set deser_factor [get_parameter_value DESERIALIZATION_FACTOR]

    if {$ip_mode=="TX"} {
        if {$deser_factor=="2"} {
            set ip_name altddio_out
        } else {
            set ip_name     altlvds_tx
        }
    } else {
        if {$deser_factor=="1"} {
            set ip_name lpm_ff
        } else {
            set ip_name     altlvds_rx
        }
    }

    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]

    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
    }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file

}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Quartus simulation
#|
#+-------------------------------------------------------------------------------------------------------------------------


proc do_vhdl_sim {output_name} {

    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.vhd]

    # Get all parameters and ports
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
    }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
    }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
    }

    # Execute clearbox to produce a variation file
    set ip_mode [get_parameter_value FUNCTIONAL_MODE]
    set deser_factor [get_parameter_value DESERIALIZATION_FACTOR]

    if {$ip_mode=="TX"} {
        if {$deser_factor=="2"} {
            set ip_name altddio_out
        } else {
            set ip_name     altlvds_tx
        }
    } else {
        if {$deser_factor=="1"} {
            set ip_name lpm_ff
        } else {
            set ip_name     altlvds_rx
        }
    }

    set status      [do_clearbox_gen $ip_name $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
    }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file


}

#+----------------------------------------------------------------------------------------------------------------------------
#|
#|  Parameters and ports transfer procedure
#|
#+----------------------------------------------------------------------------------------------------------------------------

proc parameters_transfer {}   {

    set deser_factor [get_parameter_value DESERIALIZATION_FACTOR]
    set width [get_parameter_value NUMBER_OF_CHANNELS]
    set ip_mode [get_parameter_value FUNCTIONAL_MODE]
    if {$deser_factor=="2" && $ip_mode=="TX"} {
        set param_list   {"DEVICE_FAMILY" "WIDTH"}
        foreach param   $param_list    {
           set param_arr($param)    [get_parameter_value  $param]
        }
        set parameters_list     [array get param_arr]
    } elseif {$deser_factor=="1" && $ip_mode=="RX"} {
        set param_list   {"LPM_WIDTH"}
        foreach param   $param_list    {
            set param_arr($param)    [get_parameter_value  $param]
        }
        set parameters_list     [array get param_arr]
    } else {
        #get all parameters#
        set param_list   [get_parameters]
        foreach param   $param_list    {
            set param_arr($param)    [get_parameter_value  $param]
        }
        set parameters_list     [array get param_arr]
    }
    return $parameters_list
}

proc ports_transfer {}   {
    #get all parameters#
    set deser_factor [get_parameter_value DESERIALIZATION_FACTOR]
    set ip_mode [get_parameter_value FUNCTIONAL_MODE]

    if {$deser_factor=="2" && $ip_mode=="TX"} {
        set ports_list     {"datain_h" "datain_l" "dataout" "outclock"}
    } else {
        set ports_list   [get_interface_ports]
    }
    return $ports_list
}

proc update_settings_datawidth {arg} {
    set datawidth [get_parameter_value $arg]
    set_parameter_value OUTCLOCK_DIVIDE_BY_UI $datawidth
    if {$datawidth == 5} {
        set_parameter_value OUTCLOCK_DUTY_CYCLE_UI "60"
    } elseif {$datawidth == 7} {
        set_parameter_value OUTCLOCK_DUTY_CYCLE_UI "57"
    } elseif {$datawidth == 9} {
        set_parameter_value OUTCLOCK_DUTY_CYCLE_UI "56"
    } else {
        set_parameter_value OUTCLOCK_DUTY_CYCLE_UI "50"
    }
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1394433606063/sam1394433911642
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
