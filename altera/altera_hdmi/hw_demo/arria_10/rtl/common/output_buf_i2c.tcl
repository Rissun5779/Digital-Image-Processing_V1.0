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


# qsys scripting (.tcl) file for output_buf_i2c
package require -exact qsys 16.0

create_system {output_buf_i2c}

set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S2F45I2SGES}
set_project_property HIDE_FROM_IP_CATALOG {true}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance output_buf_i2c altera_gpio 
set_instance_parameter_value output_buf_i2c {PIN_TYPE_GUI} {Bidir}
set_instance_parameter_value output_buf_i2c {SIZE} {1}
set_instance_parameter_value output_buf_i2c {gui_enable_migratable_port_names} {1}
set_instance_parameter_value output_buf_i2c {gui_diff_buff} {0}
set_instance_parameter_value output_buf_i2c {gui_pseudo_diff} {0}
set_instance_parameter_value output_buf_i2c {gui_bus_hold} {0}
set_instance_parameter_value output_buf_i2c {gui_open_drain} {1}
set_instance_parameter_value output_buf_i2c {gui_use_oe} {1}
set_instance_parameter_value output_buf_i2c {gui_enable_termination_ports} {0}
set_instance_parameter_value output_buf_i2c {gui_io_reg_mode} {none}
set_instance_parameter_value output_buf_i2c {gui_sreset_mode} {None}
set_instance_parameter_value output_buf_i2c {gui_areset_mode} {None}
set_instance_parameter_value output_buf_i2c {gui_enable_cke} {0}
set_instance_parameter_value output_buf_i2c {gui_hr_logic} {0}
set_instance_parameter_value output_buf_i2c {gui_separate_io_clks} {0}
set_instance_parameter_value output_buf_i2c {EXT_DRIVER_PARAM} {0}
set_instance_parameter_value output_buf_i2c {GENERATE_SDC_FILE} {0}
set_instance_parameter_value output_buf_i2c {IP_MIGRATE_PORT_MAP_FILE} {altiobuf_bidir_port_map.csv}

# exported interfaces
set_instance_property output_buf_i2c AUTO_EXPORT {true}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

save_system {output_buf_i2c.qsys}
