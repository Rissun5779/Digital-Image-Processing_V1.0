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



# *********************************************************************
# Description
# 
# Script for compiling the DisplayPort Example Design software
#
# *********************************************************************

# Location where BSP is built
BSP_DIR=./software/dp_demo_bsp

# Location where the application is built
APP_DIR=./software/dp_demo

# ::WARNING:: If you used spaces in your ACDS install location
# this script will not work. You will need to copy the software
# directory to another location and update this script appropriately
SW_ROOTDIR=$QUARTUS_ROOTDIR/../ip/altera/altera_dp/software

# Location containing the working copy for the system libraries files
RX_LIB_DIR=./software/btc_dprx_syslib
TX_LIB_DIR=./software/btc_dptx_syslib
TXLL_LIB_DIR=./software/btc_dptxll_syslib

# Location containing all the application source files
APP_SRC_DIR=$SW_ROOTDIR/dp_demo_src

# Location containing the original system libraries files
RX_LIB_SRC_DIR=$SW_ROOTDIR/btc_dprx_syslib
TX_LIB_SRC_DIR=$SW_ROOTDIR/btc_dptx_syslib
TXLL_LIB_SRC_DIR=$SW_ROOTDIR/btc_dptxll_syslib

# SOPC file definitions
SOPC_INFO="./control.sopcinfo"
SOPC_TIMER_NAME="sys_clock_timer"
SOPC_CPU_NAME="cpu"
SOPC_CODE_MEMORY_NAME="onchip_mem"

# Various
ELF_NAME=dp_demo.elf
OPTIMIZATION_LEVEL="-O2"
APP_FLAGS="--set APP_CFLAGS_OPTIMIZATION $OPTIMIZATION_LEVEL"

# BSP options
SIMULATION_OPTIMIZED_SUPPORT="false"
BSP_TYPE=hal
BSP_FLAGS="--set hal.enable_c_plus_plus 0 \
--set hal.enable_clean_exit 0 \
--set hal.enable_exit 0 \
--set hal.enable_gprof 0 \
--set hal.enable_lightweight_device_driver_api 0 \
--set hal.enable_mul_div_emulation 0 \
--set hal.enable_reduced_device_drivers 1 \
--set hal.enable_runtime_stack_checking 0 \
--set hal.enable_sim_optimize 0 \
--set hal.enable_small_c_library 1 \
--set hal.enable_sopc_sysid_check 1 \
--set hal.enable_sim_optimize $SIMULATION_OPTIMIZED_SUPPORT \
--set hal.make.bsp_cflags_optimization $OPTIMIZATION_LEVEL \
--set hal.linker.allow_code_at_reset 1 \
--set hal.linker.enable_alt_load 1 \
--set hal.linker.enable_alt_load_copy_exceptions 0 \
--set hal.linker.enable_alt_load_copy_rodata 0 \
--set hal.linker.enable_alt_load_copy_rwdata 1 \
--set hal.linker.enable_exception_stack 0 \
--set hal.linker.enable_interrupt_stack 0 \
--set hal.linker.exception_stack_memory_region_name $SOPC_CODE_MEMORY_NAME \
--set hal.linker.interrupt_stack_memory_region_name $SOPC_CODE_MEMORY_NAME \
--set hal.make.ignore_system_derived.big_endian 0 \
--set hal.make.ignore_system_derived.debug_core_present 0 \
--set hal.make.ignore_system_derived.fpu_present 0 \
--set hal.make.ignore_system_derived.hardware_divide_present 0 \
--set hal.make.ignore_system_derived.hardware_fp_cust_inst_divider_present 0 \
--set hal.make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present 0 \
--set hal.make.ignore_system_derived.hardware_multiplier_present 0 \
--set hal.make.ignore_system_derived.hardware_mulx_present 0 \
--set hal.make.ignore_system_derived.sopc_simulation_enabled 0 \
--set hal.make.ignore_system_derived.sopc_system_base_address 0 \
--set hal.make.ignore_system_derived.sopc_system_id 0 \
--set hal.make.ignore_system_derived.sopc_system_timestamp 0 \
--set hal.max_file_descriptors 4 \
--set hal.stderr jtag_uart \
--set hal.stdin jtag_uart \
--set hal.stdout jtag_uart \
--set hal.sys_clk_timer none \
--set hal.timestamp_timer $SOPC_TIMER_NAME"

# make a copy of standard dp_demo sources
mkdir -p $APP_DIR
cp $APP_SRC_DIR/*.* $APP_DIR

# replace standard dp_demo sources with example specific files
cp -f *.c $APP_DIR
cp -f *.h $APP_DIR

# copy the core system libraries
mkdir -p $RX_LIB_DIR
mkdir -p $TX_LIB_DIR
mkdir -p $TXLL_LIB_DIR
cp $RX_LIB_SRC_DIR/*.* $RX_LIB_DIR
cp $TX_LIB_SRC_DIR/*.* $TX_LIB_DIR
cp $TXLL_LIB_SRC_DIR/*.* $TXLL_LIB_DIR
cp $RX_LIB_SRC_DIR/release_mst/*.a $RX_LIB_DIR
cp $TX_LIB_SRC_DIR/release_mst/*.a $TX_LIB_DIR
cp $TXLL_LIB_SRC_DIR/release/*.a $TXLL_LIB_DIR

generate the BSP in the $BSP_DIR
cmd="nios2-bsp $BSP_TYPE $BSP_DIR $SOPC_INFO $BSP_FLAGS"
$cmd || {
  echo "nios2-bsp failed"
}

# generate the application make file in the $APP_DIR
cmd="nios2-app-generate-makefile --app-dir $APP_DIR --bsp-dir $BSP_DIR --elf-name $ELF_NAME --src-rdir $APP_DIR \
--use-lib-dir $RX_LIB_DIR --use-lib-dir $TX_LIB_DIR --use-lib-dir $TXLL_LIB_DIR $APP_FLAGS \
--set APP_INCLUDE_DIRS ../../$RX_LIB_DIR ../../$TX_LIB_DIR ../../$TXLL_LIB_DIR"
$cmd || {
  echo "nios2-app-generate-makefile failed"
  exit 1
}

# Running make (for application, memory initialization files and the bsp due to dependencies)
cmd="make mem_init_generate --directory=$APP_DIR"
$cmd || {
    echo "make failed"
}

