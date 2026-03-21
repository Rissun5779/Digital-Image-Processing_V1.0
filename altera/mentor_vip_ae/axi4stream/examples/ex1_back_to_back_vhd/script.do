# Usage: "vsim -mvchome ../../../common -do "source script.do; run 2500ns; quit -f""

vlib work
vlog -mixedsvvh +define+_MGC_VIP_VHDL_INTERFACE -sv -timescale 1ns/1ns \
  +incdir+../../bfm \
  ../../../common/questa_mvc_svapi.svh \
  ../../bfm/mgc_common_axi4stream.sv  \
  ../../bfm/mgc_axi4stream_master.sv  \
  ../../bfm/mgc_axi4stream_monitor.sv \
  ../../bfm/mgc_axi4stream_slave.sv


vcom -mixedsvvh ../../bfm/mgc_axi4stream_bfm_pkg.vhd \
  ../../bfm/mgc_axi4stream_master.vhd \
  ../../bfm/mgc_axi4stream_monitor.vhd \
  ../../bfm/mgc_axi4stream_slave.vhd \
  master_test_program.vhd \
  monitor_test_program.vhd \
  slave_test_program.vhd \
  top.vhd

vsim top
