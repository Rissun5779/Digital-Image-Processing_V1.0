PWD=`pwd`
if [ "$MTI_VCO_MODE" == "64" ]
then
	RUN_64bit=-full64
	LD_LIBRARY_PATH=${PWD}/../../../common/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib64
        QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
        QUESTA_MVC_GCC_LIB=${PWD}/../../../common/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs
else
	LD_LIBRARY_PATH=${PWD}/../../../common/questa_mvc_core/linux_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib
	QUESTA_MVC_GCC_PATH=${VCS_HOME}/gnu/linux/gcc-4.7.2
	QUESTA_MVC_GCC_LIB=${PWD}/../../../common/questa_mvc_core/linux_gcc-4.7.2_vcs
fi
export LD_LIBRARY_PATH
vcs -sverilog +warn=noACC_CLI_ON +warn=noUII +vpi +acc +vcs+lic+wait -cpp ${QUESTA_MVC_GCC_PATH}/xbin/g++ \
    -LDFLAGS "-L ${QUESTA_MVC_GCC_LIB} -Wl,-rpath ${QUESTA_MVC_GCC_LIB}" \
    -laxi4_IN_SystemVerilog_VCS_full \
    -timescale=1ns/1ns \
    ../../../common/questa_mvc_svapi.svh \
    ../../../axi4/bfm/mgc_common_axi4.sv  \
    ../../../axi4/bfm/mgc_axi4_master.sv  \
    ../../../axi4lite/bfm/mgc_axi4lite_master.sv  \
    ../../../axi4/bfm/mgc_axi4_monitor.sv \
    ../../../axi4/bfm/mgc_axi4_inline_monitor.sv \
    ../../../axi4lite/bfm/mgc_axi4lite_inline_monitor.sv \
    ../../../axi4/bfm/mgc_axi4_slave.sv   \
    ../../../axi4lite/bfm/mgc_axi4lite_slave.sv   \
    master_test_program.sv       \
    monitor_test_program.sv      \
    slave_test_program.sv        \
    top.sv \
    ${RUN_64bit}

./simv -l transcript
