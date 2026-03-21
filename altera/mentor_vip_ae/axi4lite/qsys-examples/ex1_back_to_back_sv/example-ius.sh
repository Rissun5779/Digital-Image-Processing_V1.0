#!/bin/sh

# Usage: <command> [32|64]
# 32 bit mode is run unless 64 is passed in as the first argument. 

SYSTEM_NAME=ex1_back_to_back_sv
ARRIA10_OR_NEWER=0

MENTOR_VIP_AE=${MENTOR_VIP_AE:-$QUARTUS_ROOTDIR/../ip/altera/mentor_vip_ae}

if [ "$1" == "64" ]
then
       # RUN_64bit=-64bit
       export QUESTA_MVC_GCC_LIB=$MENTOR_VIP_AE/common/questa_mvc_core/linux_x86_64_gcc-4.4_ius
       export INCA_64BIT=1
else
       export QUESTA_MVC_GCC_LIB=$MENTOR_VIP_AE/common/questa_mvc_core/linux_gcc-4.4_ius
fi
export LD_LIBRARY_PATH=$QUESTA_MVC_GCC_LIB:${LD_LIBRARY_PATH}

if [ ${ARRIA10_OR_NEWER} == "1" ]
then
        SIM_DIR_NAME=sim
else
        SIM_DIR_NAME=simulation
fi

cd ${SYSTEM_NAME}/${SIM_DIR_NAME}/cadence
source ncsim_setup.sh SKIP_COM=1 SKIP_DEV_COM=1 SKIP_ELAB=1 SKIP_SIM=1;

  # Compile VIP
  ncvlog -sv \
    "$MENTOR_VIP_AE/common/questa_mvc_svapi.svh" \
    "$MENTOR_VIP_AE/axi4/bfm/mgc_common_axi4.sv" \
    "$MENTOR_VIP_AE/axi4/bfm/mgc_axi4_monitor.sv" \
    "$MENTOR_VIP_AE/axi4/bfm/mgc_axi4_inline_monitor.sv" \
    "$MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_inline_monitor.sv" \
    "$MENTOR_VIP_AE/axi4/bfm/mgc_axi4_master.sv" \
    "$MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_master.sv" \
    "$MENTOR_VIP_AE/axi4/bfm/mgc_axi4_slave.sv" \
    "$MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_slave.sv"

# Compile the test program
ncvlog -sv ../../../master_test_program.sv
ncvlog -sv ../../../monitor_test_program.sv
ncvlog -sv ../../../slave_test_program.sv

# Compile the top
ncvlog -sv ../../../top.sv

# Elaborate and simulate
source ncsim_setup.sh \
  USER_DEFINED_ELAB_OPTIONS="\"-timescale 1ns/1ns\"" \
  USER_DEFINED_SIM_OPTIONS="\"-MESSAGES -sv_lib $QUESTA_MVC_GCC_LIB/libaxi4_IN_SystemVerilog_IUS_full\"" \
  TOP_LEVEL_NAME=top
