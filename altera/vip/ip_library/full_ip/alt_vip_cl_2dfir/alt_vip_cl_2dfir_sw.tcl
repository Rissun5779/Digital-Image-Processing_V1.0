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


# ---------------------------------------------------------------------------------------------------
# --                                                                                               --
# -- _sw.tcl file for Component Library 2D Fir (2D Fir 2)                                          --
# --                                                                                               --
# ---------------------------------------------------------------------------------------------------

# [info script] does not work through Nios tools. Others have been using $argv0 so following their lead
set      comp_dir                        [file dirname $argv0]
set      alt_vip_software_common_file    [file join $comp_dir "../../common_tcl/alt_vip_software_common.tcl"]
source   $alt_vip_software_common_file

declare_general_software_driver_info alt_vip_cl_2dfir

# Common files (base VipCore and logger)
add_common_software_files
 
# Common files for quantization support
add_sw_property include_source ../../drivers/vip/inc/VipMath.hpp
add_sw_property include_source ../../drivers/vip/inc/QuantizedCoefficients.hpp
add_sw_property cpp_source     ../../drivers/vip/src/VipMath.cpp
add_sw_property cpp_source     ../../drivers/vip/src/QuantizedCoefficients.cpp

# 2D Fir files
add_sw_property include_source ../../drivers/vip/inc/FirCoefficients.hpp
add_sw_property include_source ../../drivers/vip/inc/Fir_Filter.hpp
add_sw_property cpp_source     ../../drivers/vip/src/FirCoefficients.cpp
add_sw_property cpp_source     ../../drivers/vip/src/Fir_Filter.cpp

