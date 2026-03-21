if [ "$MTI_VCO_MODE" == "64" ]
then
	RUN_64bit=-64bit
	QUESTA_MVC_GCC_LIB=../../../common/questa_mvc_core/linux_x86_64_gcc-4.4_ius
	export LD_LIBRARY_PATH=${QUESTA_MVC_GCC_LIB}:${LD_LIBRARY_PATH}
else
	QUESTA_MVC_GCC_LIB=../../../common/questa_mvc_core/linux_gcc-4.4_ius
	export LD_LIBRARY_PATH=${QUESTA_MVC_GCC_LIB}:${LD_LIBRARY_PATH}
fi
irun -clean -nowarn CLEAN -nowarn SVLGMT -access +w -sv_root ${QUESTA_MVC_GCC_LIB} -sv_lib libaxi4stream_IN_SystemVerilog_IUS_full -timescale 1ns/1ns \
    -sv -v93 +define+_MGC_VIP_VHDL_INTERFACE \
    ../../../common/questa_mvc_svapi.svh \
    ../../bfm/mgc_common_axi4stream.sv   \
    ../../bfm/mgc_axi4stream_master.sv   \
    ../../bfm/mgc_axi4stream_monitor.sv  \
    ../../bfm/mgc_axi4stream_slave.sv    \
    ../../bfm/mgc_axi4stream_bfm_pkg.vhd \
    ../../bfm/mgc_axi4stream_master.vhd  \
    ../../bfm/mgc_axi4stream_slave.vhd   \
    ../../bfm/mgc_axi4stream_monitor.vhd \
    master_test_program.vhd       \
    monitor_test_program.vhd      \
    slave_test_program.vhd        \
    top.vhd                       \
    -input @"run 2500ns" -exit -top top \
    ${RUN_64bit}
