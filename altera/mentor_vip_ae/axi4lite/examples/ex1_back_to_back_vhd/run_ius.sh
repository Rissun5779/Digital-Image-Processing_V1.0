if [ "$MTI_VCO_MODE" == "64" ]
then
	RUN_64bit=-64bit
	QUESTA_MVC_GCC_LIB=../../../common/questa_mvc_core/linux_x86_64_gcc-4.4_ius
	export LD_LIBRARY_PATH=${QUESTA_MVC_GCC_LIB}:${LD_LIBRARY_PATH}
else
	QUESTA_MVC_GCC_LIB=../../../common/questa_mvc_core/linux_gcc-4.4_ius
	export LD_LIBRARY_PATH=${QUESTA_MVC_GCC_LIB}:${LD_LIBRARY_PATH}
fi
irun -clean -nowarn CLEAN -nowarn SVLGMT -access +w -sv_root ${QUESTA_MVC_GCC_LIB} -sv_lib libaxi4_IN_SystemVerilog_IUS_full -timescale 1ns/1ns \
    -sv -v93 +define+_MGC_VIP_VHDL_INTERFACE \
    ../../../common/questa_mvc_svapi.svh \
    ../../../axi4/bfm/mgc_common_axi4.sv   \
    ../../../axi4/bfm/mgc_axi4_master.sv   \
    ../../../axi4/bfm/mgc_axi4_monitor.sv  \
    ../../../axi4/bfm/mgc_axi4_slave.sv    \
    ../../../axi4/bfm/mgc_axi4_bfm_pkg.vhd \
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
    top.vhd                       \
    -input @"run 500ns" -exit -top top \
    ${RUN_64bit}
