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

vhdlan  ../../../axi4/bfm/mgc_axi4_bfm_pkg.vhd \
        ../../../axi4/bfm/mgc_axi4_master.vhd  \
        ../../../axi4lite/bfm/mgc_axi4lite_master.vhd  \
        ../../../axi4/bfm/mgc_axi4_slave.vhd   \
        ../../../axi4lite/bfm/mgc_axi4lite_slave.vhd   \
        ../../../axi4/bfm/mgc_axi4_monitor.vhd \
        ../../../axi4/bfm/mgc_axi4_inline_monitor.vhd \
        ../../../axi4lite/bfm/mgc_axi4lite_inline_monitor.vhd \
        master_test_program.vhd       \
        monitor_test_program.vhd      \
        slave_test_program.vhd        \
        top.vhd \
	${RUN_64bit}

vlogan -sverilog +define+_MGC_VIP_VHDL_INTERFACE -q ${RUN_64bit} \
    ../../../common/questa_mvc_svapi.svh \
    ../../../axi4/bfm/mgc_common_axi4.sv   \
    ../../../axi4/bfm/mgc_axi4_master.sv   \
    ../../../axi4/bfm/mgc_axi4_monitor.sv  \
    ../../../axi4/bfm/mgc_axi4_slave.sv

vcs -q +warn=noACC_CLI_ON +warn=noUII +vpi +acc +vcs+lic+wait -cpp ${QUESTA_MVC_GCC_PATH}/xbin/g++ -timescale=1ns/1ns \
    -LDFLAGS "-L ${QUESTA_MVC_GCC_LIB} -Wl,-rpath ${QUESTA_MVC_GCC_LIB}" \
    -laxi4_IN_SystemVerilog_VCS_full \
    top \
    ${RUN_64bit}

./simv -l transcript -q +vcs+finish+500
