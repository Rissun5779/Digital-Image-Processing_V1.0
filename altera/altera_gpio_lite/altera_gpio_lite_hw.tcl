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


package require -exact qsys 13.0


set_module_property DESCRIPTION "GPIO Lite Intel FPGA IP"
set_module_property NAME altera_gpio_lite
set_module_property VERSION 18.1
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME "GPIO Lite Intel FPGA IP"
set_module_property GROUP "Basic Functions/I\/O"
set_module_property AUTHOR "Intel Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property HIDE_FROM_QSYS true
set_module_property HIDE_FROM_SOPC true
set_module_property   SUPPORTED_DEVICE_FAMILIES  {"MAX 10 FPGA"}

add_parameter           DEVICE_FAMILY    STRING          "MAX 10 FPGA"
set_parameter_property  DEVICE_FAMILY    DISPLAY_NAME    "Device family"
set_parameter_property  DEVICE_FAMILY    SYSTEM_INFO     "device_family"
set_parameter_property  DEVICE_FAMILY    VISIBLE         false
set_parameter_property  DEVICE_FAMILY    DESCRIPTION     "Specifies which device family is currently selected."

add_display_item "" "General" GROUP
add_display_item "" "Buffer" GROUP
add_display_item "" "Registers" GROUP
add_display_item "" "Advanced DDR features" GROUP

add_parameter PIN_TYPE STRING "output"
set_parameter_property PIN_TYPE DEFAULT_VALUE "output"
set_parameter_property PIN_TYPE DISPLAY_NAME "Data direction"
set_parameter_property PIN_TYPE ALLOWED_RANGES {"input" "output" "bidir"}
set_parameter_property PIN_TYPE AFFECTS_GENERATION true
set_parameter_property PIN_TYPE DESCRIPTION "Specify the data direction for the GPIO"
set_parameter_property PIN_TYPE HDL_PARAMETER true
add_display_item "General" PIN_TYPE parameter

add_parameter SIZE INTEGER 4
set_parameter_property SIZE DEFAULT_VALUE 4
set_parameter_property SIZE DISPLAY_NAME "Data width"
set_parameter_property SIZE AFFECTS_GENERATION true
set_parameter_property SIZE DESCRIPTION "Specify the data width"
set_parameter_property SIZE HDL_PARAMETER true
add_display_item "General" SIZE parameter

add_parameter gui_true_diff_buf BOOLEAN false ""
set_parameter_property gui_true_diff_buf DISPLAY_NAME "Use true differential buffer"
set_parameter_property gui_true_diff_buf AFFECTS_GENERATION true
set_parameter_property gui_true_diff_buf DESCRIPTION "Specify the use of true differential buffer"
set_parameter_property gui_true_diff_buf HDL_PARAMETER false
set_parameter_property gui_true_diff_buf VISIBLE true
set_parameter_property gui_true_diff_buf ENABLED true
add_display_item "Buffer" gui_true_diff_buf parameter

add_parameter gui_pseudo_diff_buf BOOLEAN false ""
set_parameter_property gui_pseudo_diff_buf DISPLAY_NAME "Use pseudo differential buffer"
set_parameter_property gui_pseudo_diff_buf AFFECTS_GENERATION true
set_parameter_property gui_pseudo_diff_buf DESCRIPTION "Specify the use of pseudo differential buffer"
set_parameter_property gui_pseudo_diff_buf HDL_PARAMETER false
set_parameter_property gui_pseudo_diff_buf VISIBLE true
set_parameter_property gui_pseudo_diff_buf ENABLED true
add_display_item "Buffer" gui_pseudo_diff_buf parameter

add_parameter gui_bus_hold BOOLEAN false ""
set_parameter_property gui_bus_hold DISPLAY_NAME "Use bus-hold circuitry"
set_parameter_property gui_bus_hold AFFECTS_GENERATION true
set_parameter_property gui_bus_hold DESCRIPTION "Specify the use of bus-hold circuitry"
set_parameter_property gui_bus_hold HDL_PARAMETER false
set_parameter_property gui_bus_hold VISIBLE true
set_parameter_property gui_bus_hold ENABLED true
add_display_item "Buffer" gui_bus_hold parameter

add_parameter gui_open_drain BOOLEAN false ""
set_parameter_property gui_open_drain DISPLAY_NAME "Use open drain output"
set_parameter_property gui_open_drain AFFECTS_GENERATION true
set_parameter_property gui_open_drain DESCRIPTION "Specify the use of open drain output"
set_parameter_property gui_open_drain HDL_PARAMETER false
set_parameter_property gui_open_drain VISIBLE true
set_parameter_property gui_open_drain ENABLED true
add_display_item "Buffer" gui_open_drain parameter

add_parameter gui_enable_oe_port BOOLEAN false ""
set_parameter_property gui_enable_oe_port DISPLAY_NAME "Enable oe port"
set_parameter_property gui_enable_oe_port AFFECTS_GENERATION true
set_parameter_property gui_enable_oe_port DESCRIPTION "Add an oe port which when asserted high will enable the output buffer"
set_parameter_property gui_enable_oe_port HDL_PARAMETER false
set_parameter_property gui_enable_oe_port VISIBLE true
set_parameter_property gui_enable_oe_port ENABLED true
add_display_item "Buffer" gui_enable_oe_port parameter

add_parameter gui_enable_oe_port_off_shadow BOOLEAN false ""
set_parameter_property gui_enable_oe_port_off_shadow DISPLAY_NAME "Enable oe port"
set_parameter_property gui_enable_oe_port_off_shadow AFFECTS_GENERATION true
set_parameter_property gui_enable_oe_port_off_shadow DESCRIPTION "Add an oe port which when asserted high will enable the output buffer"
set_parameter_property gui_enable_oe_port_off_shadow HDL_PARAMETER false
set_parameter_property gui_enable_oe_port_off_shadow VISIBLE false
set_parameter_property gui_enable_oe_port_off_shadow ENABLED false
set_parameter_property gui_enable_oe_port_off_shadow DERIVED true
add_display_item "Buffer" gui_enable_oe_port_off_shadow parameter

add_parameter gui_enable_oe_port_on_shadow BOOLEAN true ""
set_parameter_property gui_enable_oe_port_on_shadow DISPLAY_NAME "Enable oe port"
set_parameter_property gui_enable_oe_port_on_shadow AFFECTS_GENERATION true
set_parameter_property gui_enable_oe_port_on_shadow DESCRIPTION "Add an oe port which when asserted high will enable the output buffer"
set_parameter_property gui_enable_oe_port_on_shadow HDL_PARAMETER false
set_parameter_property gui_enable_oe_port_on_shadow VISIBLE false
set_parameter_property gui_enable_oe_port_on_shadow ENABLED false
set_parameter_property gui_enable_oe_port_on_shadow DERIVED true
add_display_item "Buffer" gui_enable_oe_port_on_shadow parameter

add_parameter gui_enable_nsleep_port BOOLEAN false ""
set_parameter_property gui_enable_nsleep_port DISPLAY_NAME "Enable nsleep port (only available in selected devices)"
set_parameter_property gui_enable_nsleep_port AFFECTS_GENERATION true
set_parameter_property gui_enable_nsleep_port DESCRIPTION "Add a nsleep port which when asserted low will disable the input buffer"
set_parameter_property gui_enable_nsleep_port HDL_PARAMETER false
set_parameter_property gui_enable_nsleep_port VISIBLE true
set_parameter_property gui_enable_nsleep_port ENABLED true
add_display_item "Buffer" gui_enable_nsleep_port parameter

add_parameter gui_io_reg_mode STRING "bypass"
set_parameter_property gui_io_reg_mode DEFAULT_VALUE "bypass"
set_parameter_property gui_io_reg_mode DISPLAY_NAME "Register mode"
set_parameter_property gui_io_reg_mode ALLOWED_RANGES {"bypass" "single-register" "ddr"}
set_parameter_property gui_io_reg_mode AFFECTS_GENERATION true
set_parameter_property gui_io_reg_mode DESCRIPTION "Specify the register mode for the GPIO (Input, Output, or Both)"
set_parameter_property gui_io_reg_mode HDL_PARAMETER false
set_parameter_property gui_io_reg_mode VISIBLE true
add_display_item "Registers" gui_io_reg_mode parameter

add_parameter gui_enable_aclr_port BOOLEAN false ""
set_parameter_property gui_enable_aclr_port DISPLAY_NAME "Enable aclr port"
set_parameter_property gui_enable_aclr_port AFFECTS_GENERATION true
set_parameter_property gui_enable_aclr_port DESCRIPTION "Add a aclr port which when asserted high will asynchronously clear the register content to 0 "
set_parameter_property gui_enable_aclr_port HDL_PARAMETER false
set_parameter_property gui_enable_aclr_port VISIBLE true
set_parameter_property gui_enable_aclr_port ENABLED true
add_display_item "Registers" gui_enable_aclr_port parameter

add_parameter gui_enable_aset_port BOOLEAN false ""
set_parameter_property gui_enable_aset_port DISPLAY_NAME "Enable aset port"
set_parameter_property gui_enable_aset_port AFFECTS_GENERATION true
set_parameter_property gui_enable_aset_port DESCRIPTION "Add a aset port which when asserted high will asynchronously preset the register content to 1 "
set_parameter_property gui_enable_aset_port HDL_PARAMETER false
set_parameter_property gui_enable_aset_port VISIBLE true
set_parameter_property gui_enable_aset_port ENABLED true
add_display_item "Registers" gui_enable_aset_port parameter

add_parameter gui_enable_sclr_port BOOLEAN false ""
set_parameter_property gui_enable_sclr_port DISPLAY_NAME "Enable sclr port"
set_parameter_property gui_enable_sclr_port AFFECTS_GENERATION true
set_parameter_property gui_enable_sclr_port DESCRIPTION "Add a sclr port which when asserted high will synchronously clear the register content to 0 "
set_parameter_property gui_enable_sclr_port HDL_PARAMETER false
set_parameter_property gui_enable_sclr_port VISIBLE true
set_parameter_property gui_enable_sclr_port ENABLED true
add_display_item "Registers" gui_enable_sclr_port parameter

add_parameter gui_set_registers_to_power_up_high BOOLEAN false ""
set_parameter_property gui_set_registers_to_power_up_high DISPLAY_NAME "Set registers to power up high (when aclr, sclr and aset ports are not used)"
set_parameter_property gui_set_registers_to_power_up_high AFFECTS_GENERATION true
set_parameter_property gui_set_registers_to_power_up_high DESCRIPTION "Set registers to power up high (when aclr, sclr and aset ports are not used) "
set_parameter_property gui_set_registers_to_power_up_high HDL_PARAMETER false
set_parameter_property gui_set_registers_to_power_up_high VISIBLE true
set_parameter_property gui_set_registers_to_power_up_high ENABLED true
add_display_item "Registers" gui_set_registers_to_power_up_high parameter

add_parameter gui_clock_enable BOOLEAN false ""
set_parameter_property gui_clock_enable DISPLAY_NAME "Enable inclocken/outclocken ports"
set_parameter_property gui_clock_enable AFFECTS_GENERATION true
set_parameter_property gui_clock_enable DESCRIPTION "Add a clock enable port to control when data input and output are clocked in."
set_parameter_property gui_clock_enable HDL_PARAMETER false
set_parameter_property gui_clock_enable VISIBLE true
set_parameter_property gui_clock_enable ENABLED true
add_display_item "Registers" gui_clock_enable parameter

add_parameter gui_invert_output BOOLEAN false ""
set_parameter_property gui_invert_output DISPLAY_NAME "Invert din"
set_parameter_property gui_invert_output AFFECTS_GENERATION true
set_parameter_property gui_invert_output DESCRIPTION "Use this option to invert the data to be output through the DDIO register."
set_parameter_property gui_invert_output HDL_PARAMETER false
set_parameter_property gui_invert_output VISIBLE true
set_parameter_property gui_invert_output ENABLED true
add_display_item "Registers" gui_invert_output parameter

add_parameter gui_invert_input_clock BOOLEAN false ""
set_parameter_property gui_invert_input_clock DISPLAY_NAME "Invert DDIO inclock"
set_parameter_property gui_invert_input_clock AFFECTS_GENERATION true
set_parameter_property gui_invert_input_clock DESCRIPTION "Use this option to invert the input clock to DDIO input register."
set_parameter_property gui_invert_input_clock HDL_PARAMETER false
set_parameter_property gui_invert_input_clock VISIBLE true
set_parameter_property gui_invert_input_clock ENABLED true
add_display_item "Registers" gui_invert_input_clock parameter

add_parameter gui_use_register_to_drive_obuf_oe BOOLEAN false ""
set_parameter_property gui_use_register_to_drive_obuf_oe DISPLAY_NAME "Use a single register to drive the output enable (oe) signal at the I/O buffer"
set_parameter_property gui_use_register_to_drive_obuf_oe AFFECTS_GENERATION true
set_parameter_property gui_use_register_to_drive_obuf_oe DESCRIPTION "Use a single register to drive the output enable (oe) signal at the I/O buffer."
set_parameter_property gui_use_register_to_drive_obuf_oe HDL_PARAMETER false
set_parameter_property gui_use_register_to_drive_obuf_oe VISIBLE true
set_parameter_property gui_use_register_to_drive_obuf_oe ENABLED true
add_display_item "Registers" gui_use_register_to_drive_obuf_oe parameter

add_parameter gui_use_register_to_drive_obuf_oe_off_shadow BOOLEAN false ""
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow DISPLAY_NAME "Use a single register to drive the output enable (oe) signal at the I/O buffer"
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow AFFECTS_GENERATION true
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow DESCRIPTION "Use a single register to drive the output enable (oe) signal at the I/O buffer."
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow HDL_PARAMETER false
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow VISIBLE false
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow ENABLED false
set_parameter_property gui_use_register_to_drive_obuf_oe_off_shadow DERIVED true
add_display_item "Registers" gui_use_register_to_drive_obuf_oe_off_shadow parameter

add_parameter gui_use_ddio_reg_to_drive_oe BOOLEAN false ""
set_parameter_property gui_use_ddio_reg_to_drive_oe DISPLAY_NAME "Use DDIO registers to drive the output enable (oe) signal at the I/O buffer"
set_parameter_property gui_use_ddio_reg_to_drive_oe AFFECTS_GENERATION true
set_parameter_property gui_use_ddio_reg_to_drive_oe DESCRIPTION "When this option is used, the output pin is held at high impedance for an extra half clock cycle after the output_enable port goes high."
set_parameter_property gui_use_ddio_reg_to_drive_oe HDL_PARAMETER false
set_parameter_property gui_use_ddio_reg_to_drive_oe VISIBLE true
set_parameter_property gui_use_ddio_reg_to_drive_oe ENABLED true
add_display_item "Registers" gui_use_ddio_reg_to_drive_oe parameter

add_parameter gui_use_ddio_reg_to_drive_oe_off_shadow BOOLEAN false ""
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow DISPLAY_NAME "Use DDIO registers to drive the output enable (oe) signal at the I/O buffer"
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow AFFECTS_GENERATION true
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow DESCRIPTION "hen this option is used, the output pin is held at high impedance for an extra half clock cycle after the output_enable port goes high."
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow HDL_PARAMETER false
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow VISIBLE false
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow ENABLED false
set_parameter_property gui_use_ddio_reg_to_drive_oe_off_shadow DERIVED true
add_display_item "Registers" gui_use_ddio_reg_to_drive_oe_off_shadow parameter

add_parameter gui_use_advanced_ddr_features BOOLEAN false ""
set_parameter_property gui_use_advanced_ddr_features DISPLAY_NAME "Enable advanced DDR features"
set_parameter_property gui_use_advanced_ddr_features AFFECTS_GENERATION true
set_parameter_property gui_use_advanced_ddr_features DESCRIPTION "Use this option to enable advanced DDR features in the IO and enable the IO clock divider for input and bidir pin"
set_parameter_property gui_use_advanced_ddr_features HDL_PARAMETER false
set_parameter_property gui_use_advanced_ddr_features VISIBLE false
set_parameter_property gui_use_advanced_ddr_features ENABLED true
add_display_item "Advanced DDR features" gui_use_advanced_ddr_features parameter

add_parameter gui_enable_phase_detector_for_ck BOOLEAN false ""
set_parameter_property gui_enable_phase_detector_for_ck DISPLAY_NAME "Enable Phase Detector from CK loopback signal"
set_parameter_property gui_enable_phase_detector_for_ck AFFECTS_GENERATION true
set_parameter_property gui_enable_phase_detector_for_ck DESCRIPTION "Specify whether to enable Phase Detector from CK loopback signal"
set_parameter_property gui_enable_phase_detector_for_ck HDL_PARAMETER false
set_parameter_property gui_enable_phase_detector_for_ck VISIBLE false
set_parameter_property gui_enable_phase_detector_for_ck ENABLED true
add_display_item "Advanced DDR features" gui_enable_phase_detector_for_ck parameter

add_parameter gui_enable_phase_detector_for_ck_off_shadow BOOLEAN false ""
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow DISPLAY_NAME "Enable Phase Detector from CK loopback signal"
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow AFFECTS_GENERATION true
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow DESCRIPTION "Specify whether to enable Phase Detector from CK loopback signal"
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow HDL_PARAMETER false
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow VISIBLE false
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow ENABLED false
set_parameter_property gui_enable_phase_detector_for_ck_off_shadow DERIVED true
add_display_item "Advanced DDR features" gui_enable_phase_detector_for_ck_off_shadow parameter

add_parameter gui_enable_oe_half_cycle_delay BOOLEAN true ""
set_parameter_property gui_enable_oe_half_cycle_delay DISPLAY_NAME "Add half-cycle delay to OE signal"
set_parameter_property gui_enable_oe_half_cycle_delay AFFECTS_GENERATION true
set_parameter_property gui_enable_oe_half_cycle_delay DESCRIPTION "Specify whether to add half-cycle delay to OE signal"
set_parameter_property gui_enable_oe_half_cycle_delay HDL_PARAMETER false
set_parameter_property gui_enable_oe_half_cycle_delay VISIBLE false
set_parameter_property gui_enable_oe_half_cycle_delay ENABLED true
add_display_item "Advanced DDR features" gui_enable_oe_half_cycle_delay parameter

add_parameter gui_enable_hr_clock BOOLEAN false ""
set_parameter_property gui_enable_hr_clock DISPLAY_NAME "Enable half-rate clock port"
set_parameter_property gui_enable_hr_clock AFFECTS_GENERATION true
set_parameter_property gui_enable_hr_clock DESCRIPTION "Add half-rate clock port for DDR input path"
set_parameter_property gui_enable_hr_clock HDL_PARAMETER false
set_parameter_property gui_enable_hr_clock VISIBLE false
set_parameter_property gui_enable_hr_clock ENABLED true
add_display_item "Advanced DDR features" gui_enable_hr_clock parameter

add_parameter gui_enable_invert_hr_clock_port BOOLEAN false ""
set_parameter_property gui_enable_invert_hr_clock_port DISPLAY_NAME "Enable invert_hr_clock port"
set_parameter_property gui_enable_invert_hr_clock_port AFFECTS_GENERATION true
set_parameter_property gui_enable_invert_hr_clock_port DESCRIPTION "Add invert_hr_clock port for DDR input path"
set_parameter_property gui_enable_invert_hr_clock_port HDL_PARAMETER false
set_parameter_property gui_enable_invert_hr_clock_port VISIBLE false
set_parameter_property gui_enable_invert_hr_clock_port ENABLED true
add_display_item "Advanced DDR features" gui_enable_invert_hr_clock_port parameter

add_parameter gui_invert_clkdiv_input_clock BOOLEAN false ""
set_parameter_property gui_invert_clkdiv_input_clock DISPLAY_NAME "Invert clock divider input clock"
set_parameter_property gui_invert_clkdiv_input_clock AFFECTS_GENERATION true
set_parameter_property gui_invert_clkdiv_input_clock DESCRIPTION "Specify whether to invert the input clock of clock divider"
set_parameter_property gui_invert_clkdiv_input_clock HDL_PARAMETER false
set_parameter_property gui_invert_clkdiv_input_clock VISIBLE false
set_parameter_property gui_invert_clkdiv_input_clock ENABLED true
add_display_item "Advanced DDR features" gui_invert_clkdiv_input_clock parameter

add_parameter gui_invert_output_clock BOOLEAN false ""
set_parameter_property gui_invert_output_clock DISPLAY_NAME "Invert DDIO outclock"
set_parameter_property gui_invert_output_clock AFFECTS_GENERATION true
set_parameter_property gui_invert_output_clock DESCRIPTION "Use this option to invert the output clock to DDIO output register."
set_parameter_property gui_invert_output_clock HDL_PARAMETER false
set_parameter_property gui_invert_output_clock VISIBLE false
set_parameter_property gui_invert_output_clock ENABLED true
add_display_item "Advanced DDR features" gui_invert_output_clock parameter

add_parameter gui_invert_oe_inclock BOOLEAN false ""
set_parameter_property gui_invert_oe_inclock DISPLAY_NAME "Invert output enable (oe) register inclock"
set_parameter_property gui_invert_oe_inclock AFFECTS_GENERATION true
set_parameter_property gui_invert_oe_inclock DESCRIPTION "Use this option to invert the clock to the single register or DDIO register that drives the output enable (oe) signal at the I/O buffer."
set_parameter_property gui_invert_oe_inclock HDL_PARAMETER false
set_parameter_property gui_invert_oe_inclock VISIBLE false
set_parameter_property gui_invert_oe_inclock ENABLED true
add_display_item "Advanced DDR features" gui_invert_oe_inclock parameter

add_parameter gui_use_hardened_ddio_input_registers BOOLEAN false ""
set_parameter_property gui_use_hardened_ddio_input_registers DISPLAY_NAME "Implement DDIO input registers in hard implementation (Only available in certain devices) "
set_parameter_property gui_use_hardened_ddio_input_registers AFFECTS_GENERATION true
set_parameter_property gui_use_hardened_ddio_input_registers DESCRIPTION "Specify whether to implement DDIO input registers in hard implementation. This feature is only available in certain devices."
set_parameter_property gui_use_hardened_ddio_input_registers HDL_PARAMETER false
set_parameter_property gui_use_hardened_ddio_input_registers VISIBLE true
set_parameter_property gui_use_hardened_ddio_input_registers ENABLED true
add_display_item "Registers" gui_use_hardened_ddio_input_registers parameter




add_parameter REGISTER_MODE STRING "bypass"
set_parameter_property REGISTER_MODE DEFAULT_VALUE "bypass"
set_parameter_property REGISTER_MODE ALLOWED_RANGES {"bypass" "single-register" "ddr"}
set_parameter_property REGISTER_MODE AFFECTS_GENERATION true
set_parameter_property REGISTER_MODE HDL_PARAMETER true
set_parameter_property REGISTER_MODE VISIBLE false
set_parameter_property REGISTER_MODE DERIVED true

add_parameter BUFFER_TYPE STRING "single-ended"
set_parameter_property BUFFER_TYPE DEFAULT_VALUE "single-ended"
set_parameter_property BUFFER_TYPE ALLOWED_RANGES {"single-ended" "true_differential" "pseudo_differential"}
set_parameter_property BUFFER_TYPE AFFECTS_GENERATION true
set_parameter_property BUFFER_TYPE HDL_PARAMETER true
set_parameter_property BUFFER_TYPE VISIBLE false
set_parameter_property BUFFER_TYPE DERIVED true


add_parameter ASYNC_MODE STRING "none"
set_parameter_property ASYNC_MODE DEFAULT_VALUE "none"
set_parameter_property ASYNC_MODE ALLOWED_RANGES {"none" "preset" "clear"}
set_parameter_property ASYNC_MODE AFFECTS_GENERATION true
set_parameter_property ASYNC_MODE HDL_PARAMETER true
set_parameter_property ASYNC_MODE VISIBLE false
set_parameter_property ASYNC_MODE DERIVED true

add_parameter SYNC_MODE STRING "none"
set_parameter_property SYNC_MODE DEFAULT_VALUE "none"
set_parameter_property SYNC_MODE ALLOWED_RANGES {"none" "preset" "clear"}
set_parameter_property SYNC_MODE AFFECTS_GENERATION true
set_parameter_property SYNC_MODE HDL_PARAMETER true
set_parameter_property SYNC_MODE VISIBLE false
set_parameter_property SYNC_MODE DERIVED true

add_parameter BUS_HOLD STRING "false"
set_parameter_property BUS_HOLD DEFAULT_VALUE "false"
set_parameter_property BUS_HOLD ALLOWED_RANGES {"true" "false"}
set_parameter_property BUS_HOLD AFFECTS_GENERATION true
set_parameter_property BUS_HOLD HDL_PARAMETER true
set_parameter_property BUS_HOLD VISIBLE false
set_parameter_property BUS_HOLD DERIVED true

add_parameter OPEN_DRAIN_OUTPUT STRING "false"
set_parameter_property OPEN_DRAIN_OUTPUT DEFAULT_VALUE "false"
set_parameter_property OPEN_DRAIN_OUTPUT ALLOWED_RANGES {"true" "false"}
set_parameter_property OPEN_DRAIN_OUTPUT AFFECTS_GENERATION true
set_parameter_property OPEN_DRAIN_OUTPUT HDL_PARAMETER true
set_parameter_property OPEN_DRAIN_OUTPUT VISIBLE false
set_parameter_property OPEN_DRAIN_OUTPUT DERIVED true

add_parameter ENABLE_OE_PORT STRING "false"
set_parameter_property ENABLE_OE_PORT DEFAULT_VALUE "false"
set_parameter_property ENABLE_OE_PORT ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_OE_PORT AFFECTS_GENERATION true
set_parameter_property ENABLE_OE_PORT HDL_PARAMETER true
set_parameter_property ENABLE_OE_PORT VISIBLE false
set_parameter_property ENABLE_OE_PORT DERIVED true

add_parameter ENABLE_NSLEEP_PORT STRING "false"
set_parameter_property ENABLE_NSLEEP_PORT DEFAULT_VALUE "false"
set_parameter_property ENABLE_NSLEEP_PORT ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_NSLEEP_PORT AFFECTS_GENERATION true
set_parameter_property ENABLE_NSLEEP_PORT HDL_PARAMETER true
set_parameter_property ENABLE_NSLEEP_PORT VISIBLE false
set_parameter_property ENABLE_NSLEEP_PORT DERIVED true

add_parameter ENABLE_CLOCK_ENA_PORT STRING "false"
set_parameter_property ENABLE_CLOCK_ENA_PORT DEFAULT_VALUE "false"
set_parameter_property ENABLE_CLOCK_ENA_PORT ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_CLOCK_ENA_PORT AFFECTS_GENERATION true
set_parameter_property ENABLE_CLOCK_ENA_PORT HDL_PARAMETER true
set_parameter_property ENABLE_CLOCK_ENA_PORT VISIBLE false
set_parameter_property ENABLE_CLOCK_ENA_PORT DERIVED true

add_parameter SET_REGISTER_OUTPUTS_HIGH STRING "false"
set_parameter_property SET_REGISTER_OUTPUTS_HIGH DEFAULT_VALUE "false"
set_parameter_property SET_REGISTER_OUTPUTS_HIGH ALLOWED_RANGES {"true" "false"}
set_parameter_property SET_REGISTER_OUTPUTS_HIGH AFFECTS_GENERATION true
set_parameter_property SET_REGISTER_OUTPUTS_HIGH HDL_PARAMETER true
set_parameter_property SET_REGISTER_OUTPUTS_HIGH VISIBLE false
set_parameter_property SET_REGISTER_OUTPUTS_HIGH DERIVED true

add_parameter INVERT_OUTPUT STRING "false"
set_parameter_property INVERT_OUTPUT DEFAULT_VALUE "false"
set_parameter_property INVERT_OUTPUT ALLOWED_RANGES {"true" "false"}
set_parameter_property INVERT_OUTPUT AFFECTS_GENERATION true
set_parameter_property INVERT_OUTPUT HDL_PARAMETER true
set_parameter_property INVERT_OUTPUT VISIBLE false
set_parameter_property INVERT_OUTPUT DERIVED true

add_parameter INVERT_INPUT_CLOCK STRING "false"
set_parameter_property INVERT_INPUT_CLOCK DEFAULT_VALUE "false"
set_parameter_property INVERT_INPUT_CLOCK ALLOWED_RANGES {"true" "false"}
set_parameter_property INVERT_INPUT_CLOCK AFFECTS_GENERATION true
set_parameter_property INVERT_INPUT_CLOCK HDL_PARAMETER true
set_parameter_property INVERT_INPUT_CLOCK VISIBLE false
set_parameter_property INVERT_INPUT_CLOCK DERIVED true

add_parameter USE_ONE_REG_TO_DRIVE_OE STRING "false"
set_parameter_property USE_ONE_REG_TO_DRIVE_OE DEFAULT_VALUE "false"
set_parameter_property USE_ONE_REG_TO_DRIVE_OE ALLOWED_RANGES {"true" "false"}
set_parameter_property USE_ONE_REG_TO_DRIVE_OE AFFECTS_GENERATION true
set_parameter_property USE_ONE_REG_TO_DRIVE_OE HDL_PARAMETER true
set_parameter_property USE_ONE_REG_TO_DRIVE_OE VISIBLE false
set_parameter_property USE_ONE_REG_TO_DRIVE_OE DERIVED true

add_parameter USE_DDIO_REG_TO_DRIVE_OE STRING "false"
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE DEFAULT_VALUE "false"
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE ALLOWED_RANGES {"true" "false"}
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE AFFECTS_GENERATION true
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE HDL_PARAMETER true
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE VISIBLE false
set_parameter_property USE_DDIO_REG_TO_DRIVE_OE DERIVED true

add_parameter USE_ADVANCED_DDR_FEATURES STRING "false"
set_parameter_property USE_ADVANCED_DDR_FEATURES DEFAULT_VALUE "false"
set_parameter_property USE_ADVANCED_DDR_FEATURES ALLOWED_RANGES {"true" "false"}
set_parameter_property USE_ADVANCED_DDR_FEATURES AFFECTS_GENERATION true
set_parameter_property USE_ADVANCED_DDR_FEATURES HDL_PARAMETER true
set_parameter_property USE_ADVANCED_DDR_FEATURES VISIBLE false
set_parameter_property USE_ADVANCED_DDR_FEATURES DERIVED true

add_parameter USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY STRING "false"
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY DEFAULT_VALUE "false"
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY ALLOWED_RANGES {"true" "false"}
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY AFFECTS_GENERATION true
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY HDL_PARAMETER true
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY VISIBLE false
set_parameter_property USE_ADVANCED_DDR_FEATURES_FOR_INPUT_ONLY DERIVED true

add_parameter ENABLE_OE_HALF_CYCLE_DELAY STRING "true"
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY DEFAULT_VALUE "true"
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY AFFECTS_GENERATION true
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY HDL_PARAMETER true
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY VISIBLE false
set_parameter_property ENABLE_OE_HALF_CYCLE_DELAY DERIVED true

add_parameter INVERT_CLKDIV_INPUT_CLOCK STRING "false"
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK DEFAULT_VALUE "false"
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK ALLOWED_RANGES {"true" "false"}
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK AFFECTS_GENERATION true
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK HDL_PARAMETER true
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK VISIBLE false
set_parameter_property INVERT_CLKDIV_INPUT_CLOCK DERIVED true

add_parameter ENABLE_PHASE_INVERT_CTRL_PORT STRING "false"
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT DEFAULT_VALUE "false"
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT AFFECTS_GENERATION true
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT HDL_PARAMETER true
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT VISIBLE false
set_parameter_property ENABLE_PHASE_INVERT_CTRL_PORT DERIVED true

add_parameter ENABLE_HR_CLOCK STRING "false"
set_parameter_property ENABLE_HR_CLOCK DEFAULT_VALUE "false"
set_parameter_property ENABLE_HR_CLOCK ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_HR_CLOCK AFFECTS_GENERATION true
set_parameter_property ENABLE_HR_CLOCK HDL_PARAMETER true
set_parameter_property ENABLE_HR_CLOCK VISIBLE false
set_parameter_property ENABLE_HR_CLOCK DERIVED true


add_parameter INVERT_OUTPUT_CLOCK STRING "false"
set_parameter_property INVERT_OUTPUT_CLOCK DEFAULT_VALUE "false"
set_parameter_property INVERT_OUTPUT_CLOCK ALLOWED_RANGES {"true" "false"}
set_parameter_property INVERT_OUTPUT_CLOCK AFFECTS_GENERATION true
set_parameter_property INVERT_OUTPUT_CLOCK HDL_PARAMETER true
set_parameter_property INVERT_OUTPUT_CLOCK VISIBLE false
set_parameter_property INVERT_OUTPUT_CLOCK DERIVED true

add_parameter INVERT_OE_INCLOCK STRING "false"
set_parameter_property INVERT_OE_INCLOCK DEFAULT_VALUE "false"
set_parameter_property INVERT_OE_INCLOCK ALLOWED_RANGES {"true" "false"}
set_parameter_property INVERT_OE_INCLOCK AFFECTS_GENERATION true
set_parameter_property INVERT_OE_INCLOCK HDL_PARAMETER true
set_parameter_property INVERT_OE_INCLOCK VISIBLE false
set_parameter_property INVERT_OE_INCLOCK DERIVED true

add_parameter ENABLE_PHASE_DETECTOR_FOR_CK STRING "false"
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK DEFAULT_VALUE "false"
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK ALLOWED_RANGES {"true" "false"}
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK AFFECTS_GENERATION true
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK HDL_PARAMETER true
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK VISIBLE false
set_parameter_property ENABLE_PHASE_DETECTOR_FOR_CK DERIVED true



    
source altera_gpio_lite_hw_extra.tcl



add_documentation_link "User Guide" "https://www.altera.com/en_US/pdfs/literature/hb/max-10/ug_m10_gpio.pdf"
add_documentation_link "Release Notes" "https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408"
