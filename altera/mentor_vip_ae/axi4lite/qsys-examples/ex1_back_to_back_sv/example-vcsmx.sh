#!/bin/sh

# Usage: <command> [32|64]
# 32 bit mode is run unless 64 is passed in as the first argument.

SYSTEM_NAME=ex1_back_to_back_sv
ARRIA10_OR_NEWER=0

MENTOR_VIP_AE=${MENTOR_VIP_AE:-$QUARTUS_ROOTDIR/../ip/altera/mentor_vip_ae}

if [ "$1" == "64" ]
then
        RUN_64bit=-full64
        export LD_LIBRARY_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2/lib64
        QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
        QUESTA_MVC_GCC_LIB=${MENTOR_VIP_AE}/common/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs
else
        export LD_LIBRARY_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2/lib
        QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
        QUESTA_MVC_GCC_LIB=${MENTOR_VIP_AE}/common/questa_mvc_core/linux_gcc-4.7.2_vcs
fi

set QSYS_SIMDIR    ../../

if [ ${ARRIA10_OR_NEWER} == "1" ]
then
        SIM_DIR_NAME=sim
else
        SIM_DIR_NAME=simulation
fi
cd ${SYSTEM_NAME}/${SIM_DIR_NAME}/synopsys/vcsmx
rm -rf csrc libraries simv simv.daidir transcript ucli.key vc_hdrs.h
source vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1;

vlogan +v2k -sverilog \
  $MENTOR_VIP_AE/common/questa_mvc_svapi.svh \
  $MENTOR_VIP_AE/axi4/bfm/mgc_common_axi4.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_monitor.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_inline_monitor.sv \
  $MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_inline_monitor.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_master.sv \
  $MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_master.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_slave.sv \
  $MENTOR_VIP_AE/axi4lite/bfm/mgc_axi4lite_slave.sv \
    ${RUN_64bit} 

vlogan +v2k -sverilog $QSYS_SIMDIR/../../master_test_program.sv  ${RUN_64bit}
vlogan +v2k -sverilog $QSYS_SIMDIR/../../monitor_test_program.sv ${RUN_64bit}
vlogan +v2k -sverilog $QSYS_SIMDIR/../../slave_test_program.sv   ${RUN_64bit}

vlogan +v2k -sverilog $QSYS_SIMDIR/../../top.sv                  ${RUN_64bit}

vcs -t ps -lca -timescale=1ps/1ps \
  +vpi +acc +vcs+lic+wait \
  -cpp ${QUESTA_MVC_GCC_PATH}/xbin/g++ \
  -LDFLAGS "-L ${QUESTA_MVC_GCC_LIB} \
    -Wl,-rpath ${QUESTA_MVC_GCC_LIB}" \
  -laxi4_IN_SystemVerilog_VCS_full \
  top \
 ${RUN_64bit}

./simv -l transcript

