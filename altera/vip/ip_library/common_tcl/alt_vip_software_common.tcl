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


proc declare_general_software_driver_info {entity_name} {

    # Create a new driver
    create_driver $entity_name\_driver

    # Associate it with the hardware entity
    set_sw_property hw_class_name $entity_name

    # The version of this driver and HW compatibility
    if { "0" == 0 } {
        set_sw_property version                          18.1
    } else {
        set_sw_property version                          99.0
    }

    # No initialization macro defined
    set_sw_property auto_initialize false

    # Initialize the driver in alt_irq_init() if this module
    # is recognized as containing an interrupt controller.
    set_sw_property irq_auto_initialize false

    # The code supports the two interrupt APIs (using the define in system.h)
    set_sw_property supported_interrupt_apis "legacy_interrupt_api enhanced_interrupt_api"

    # This driver supports the HAL
    add_sw_property supported_bsp_type HAL
    #add_sw_property supported_bsp_type UCOSII

    # Location in generated BSP that above sources will be copied into
    set_sw_property bsp_subdirectory drivers/vip
}


proc add_common_software_files {} {
    add_sw_property include_directory ../../drivers/vip/inc
    add_sw_property include_directory ../../drivers/vip/src

    add_sw_property include_source ../../drivers/vip/inc/VipUtil.hpp
    add_sw_property cpp_source     ../../drivers/vip/src/VipUtil.cpp
    add_sw_property include_source ../../drivers/vip/inc/VipCore.hpp
    add_sw_property cpp_source     ../../drivers/vip/src/VipCore.cpp
}

