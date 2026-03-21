#!/bin/sh

# Usage: <command> [32|64]
# 32 bit mode is run unless 64 is passed in as the first argument.

SYSTEM_NAME=ex1_back_to_back_sv
ARRIA10_OR_NEWER=0

MENTOR_VIP_AE=${MENTOR_VIP_AE:-$QUARTUS_ROOTDIR/../ip/altera/mentor_vip_ae}

if [ "$1" == "64" ]
then
        export RUN_64bit=-full64
        export VCS_TARGET_ARCH=`getsimarch 64`
        export LD_LIBRARY_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2/lib64
        export QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
        export QUESTA_MVC_GCC_LIB=${MENTOR_VIP_AE}/common/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs
else
        export RUN_64bit=
        export LD_LIBRARY_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2/lib
        export QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
        export QUESTA_MVC_GCC_LIB=${MENTOR_VIP_AE}/common/questa_mvc_core/linux_gcc-4.7.2_vcs
fi

if [ ${ARRIA10_OR_NEWER} == "1" ]
then
        SIM_DIR_NAME=sim
else
        SIM_DIR_NAME=simulation
fi
cd ${SYSTEM_NAME}/${SIM_DIR_NAME}/synopsys/vcs
rm -rf csrc simv simv.daidir transcript ucli.key vc_hdrs.h

# VCS accepts the -LDFLAGS flag on the command line, but the shell quoting is too difficult.
# Just set the LDFLAGS ENV variable for the compiler to pick up. Alternatively, use the VCS command 
# line option '-file' with the LDFLAGS set (this avoids shell quoting issues).
#  vcs-switches.f: 
#     -LDFLAGS "-L ${QUESTA_MVC_GCC_LIB} -Wl,-rpath ${QUESTA_MVC_GCC_LIB} -laxi4_IN_SystemVerilog_VCS_full"
export LDFLAGS="-L ${QUESTA_MVC_GCC_LIB} -Wl,-rpath ${QUESTA_MVC_GCC_LIB} -laxi4_IN_SystemVerilog_VCS_full "

USER_DEFINED_ELAB_OPTIONS="\"\
  $RUN_64bit \
  +systemverilogext+.sv +vpi +acc +vcs+lic+wait \
  -cpp ${QUESTA_MVC_GCC_PATH}/xbin/g++ \
  \
  $MENTOR_VIP_AE/common/questa_mvc_svapi.svh \
  $MENTOR_VIP_AE/axi4/bfm/mgc_common_axi4.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_monitor.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_inline_monitor.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_slave.sv \
  $MENTOR_VIP_AE/axi4/bfm/mgc_axi4_master.sv \
  \
  ../../../../master_test_program.sv \
  ../../../../monitor_test_program.sv  \
  ../../../../slave_test_program.sv \
  ../../../../top.sv  \""

source vcs_setup.sh \
  USER_DEFINED_ELAB_OPTIONS="$USER_DEFINED_ELAB_OPTIONS" \
  USER_DEFINED_SIM_OPTIONS="'-l transcript'" \
  TOP_LEVEL_NAME=top

