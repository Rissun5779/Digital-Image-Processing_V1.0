# Usage: "vsim -mvchome ../../../common -do "source script.do; run 1000ns; quit -f""

vlib work
vlog -mixedsvvh +define+_MGC_VIP_VHDL_INTERFACE -sv -timescale 1ns/1ns \
  +incdir+../../../axi4/bfm \
  ../../../common/questa_mvc_svapi.svh \
  ../../../axi4/bfm/mgc_common_axi4.sv  \
  ../../../axi4/bfm/mgc_axi4_master.sv  \
  ../../../axi4/bfm/mgc_axi4_monitor.sv \
  ../../../axi4/bfm/mgc_axi4_slave.sv


vcom -mixedsvvh ../../../axi4/bfm/mgc_axi4_bfm_pkg.vhd \
  ../../../axi4/bfm/mgc_axi4_master.vhd \
  ../../../axi4lite/bfm/mgc_axi4lite_master.vhd \
  ../../../axi4/bfm/mgc_axi4_monitor.vhd \
  ../../../axi4/bfm/mgc_axi4_inline_monitor.vhd \
  ../../../axi4lite/bfm/mgc_axi4lite_inline_monitor.vhd \
  ../../../axi4/bfm/mgc_axi4_slave.vhd \
  ../../../axi4lite/bfm/mgc_axi4lite_slave.vhd \
  master_test_program.vhd \
  monitor_test_program.vhd \
  slave_test_program.vhd \
  top.vhd

vsim top
